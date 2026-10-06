import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class AppRecetas {

    public static void main(String[] args) {
        try (Scanner entrada = new Scanner(System.in)) {
            while (true) {
                System.out.println("\nGESTION DE RECETAS");
                System.out.println("1. Registrar un ingrediente nuevo en una receta");
                System.out.println("2. Consultar los ingredientes de una receta");
                System.out.println("3. Actualizar cantidad y observaciones");
                System.out.println("4. Actualizar datos de un ingrediente");
                System.out.println("5. Quitar un ingrediente de una receta");
                System.out.println("6. Eliminar un ingrediente del catalogo");
                System.out.println("0. Salir");
                System.out.print("Opcion: ");
                if (!entrada.hasNextLine()) {
                    return;
                }
                String opcion = entrada.nextLine().trim();

                try {
                    switch (opcion) {
                        case "1":
                            registrar(entrada);
                            break;
                        case "2":
                            consultar(entrada);
                            break;
                        case "3":
                            actualizarRelacion(entrada);
                            break;
                        case "4":
                            actualizarIngrediente(entrada);
                            break;
                        case "5":
                            eliminarRelacion(entrada);
                            break;
                        case "6":
                            eliminarIngrediente(entrada);
                            break;
                        case "0":
                            return;
                        default:
                            System.out.println("Selecciona una opción del menu");
                    }
                } catch (SQLException e) {
                    if (e.getErrorCode() == 1062) {
                        System.out.println("Ese ingrediente ya existe. Usa otro nombre para un registro nuevo.");
                    } else {
                        System.out.println("Error de base de datos: " + e.getMessage());
                    }
                } catch (NumberFormatException e) {
                    System.out.println("Escribe un ID entero y una cantidad numerica.");
                } catch (IllegalArgumentException e) {
                    System.out.println(e.getMessage());
                }
            }
        }
    }

    private static void registrar(Scanner entrada) throws SQLException {
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarRecetas(conexion);
            int idReceta = Integer.parseInt(leer(entrada, "ID de la receta: "));
            String nombre = leer(entrada, "Nombre del ingrediente nuevo: ");
            String tipo = leer(entrada, "Tipo de ingrediente: ");
            String unidad = leer(entrada, "Unidad base (ml, g, pieza, etc.): ");
            String respuesta = leer(entrada, "Es alcoholico? (s/n): ");
            BigDecimal cantidad = new BigDecimal(leer(entrada, "Cantidad en la unidad base: "));
            System.out.print("Observaciones (opcional): ");
            String observaciones = entrada.nextLine().trim();

            if (idReceta <= 0) {
                throw new IllegalArgumentException("El ID de la receta debe ser positivo.");
            }
            if (!respuesta.equalsIgnoreCase("s") && !respuesta.equalsIgnoreCase("n")) {
                throw new IllegalArgumentException("Indica s o n para el contenido alcoholico.");
            }
            if (nombre.length() > 100 || tipo.length() > 50
                    || unidad.length() > 20 || observaciones.length() > 255) {
                throw new IllegalArgumentException("Texto demasiado largo: nombre 100, tipo 50, unidad 20 y observaciones 255 caracteres.");
            }
            if (cantidad.signum() <= 0 || cantidad.compareTo(new BigDecimal("999999.99")) > 0
                    || cantidad.stripTrailingZeros().scale() > 2) {
                throw new IllegalArgumentException("La cantidad debe estar entre 0.01 y 999999.99, con hasta dos decimales.");
            }

            String sqlIngrediente = "INSERT INTO ingredientes "
                    + "(nombre_ingrediente, tipo, unidad_base, alcoholico) VALUES (?, ?, ?, ?)";
            String sqlRelacion = "INSERT INTO receta_ingrediente "
                    + "(id_receta, id_ingrediente, cantidad, observaciones) VALUES (?, ?, ?, ?)";

            // Los dos INSERT se confirman juntos; un error provoca rollback.
            conexion.setAutoCommit(false);
            int idIngrediente;
            try {
                try (PreparedStatement sentencia = conexion.prepareStatement(
                        sqlIngrediente, Statement.RETURN_GENERATED_KEYS)) {
                    sentencia.setString(1, nombre);
                    sentencia.setString(2, tipo);
                    sentencia.setString(3, unidad);
                    sentencia.setBoolean(4, respuesta.equalsIgnoreCase("s"));
                    sentencia.executeUpdate();
                    try (ResultSet claves = sentencia.getGeneratedKeys()) {
                        if (!claves.next()) {
                            throw new SQLException("No se obtuvo el ID del ingrediente.");
                        }
                        idIngrediente = claves.getInt(1);
                    }
                }

                try (PreparedStatement sentencia = conexion.prepareStatement(sqlRelacion)) {
                    sentencia.setInt(1, idReceta);
                    sentencia.setInt(2, idIngrediente);
                    sentencia.setBigDecimal(3, cantidad);
                    sentencia.setString(4, observaciones);
                    sentencia.executeUpdate();
                }
                conexion.commit();
            } catch (SQLException e) {
                try {
                    conexion.rollback();
                } catch (SQLException errorRollback) {
                    e.addSuppressed(errorRollback);
                }
                throw e;
            }

            System.out.println("\nREGISTRO GUARDADO CORRECTAMENTE");
            System.out.println("Ingrediente: " + nombre + " | ID: " + idIngrediente);
            System.out.println("Asociado a la receta ID: " + idReceta);
            System.out.println("Cantidad: " + cantidad.toPlainString() + " " + unidad);
        }
    }

    private static void consultar(Scanner entrada) throws SQLException {
        // Una conexion nueva permite consultar los registros ya confirmados.
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarRecetas(conexion);
            int idReceta = Integer.parseInt(leer(entrada, "ID de la receta a consultar: "));
            String sql = "SELECT r.nombre_receta, i.id_ingrediente, i.nombre_ingrediente, "
                    + "ri.cantidad, i.unidad_base, i.alcoholico, ri.observaciones "
                    + "FROM receta_ingrediente ri "
                    + "JOIN ingredientes i ON i.id_ingrediente = ri.id_ingrediente "
                    + "JOIN recetas r ON r.id_receta = ri.id_receta "
                    + "WHERE ri.id_receta = ? ORDER BY i.nombre_ingrediente";

            try (PreparedStatement sentencia = conexion.prepareStatement(sql)) {
                sentencia.setInt(1, idReceta);
                try (ResultSet resultados = sentencia.executeQuery()) {
                    int total = 0;
                    while (resultados.next()) {
                        if (total == 0) {
                            System.out.println("\nRECETA: " + resultados.getString("nombre_receta"));
                        }
                        String observaciones = resultados.getString("observaciones");

                        System.out.println("ID: " + resultados.getInt("id_ingrediente") + " | "
                                + resultados.getString("nombre_ingrediente") + " | "
                                + resultados.getBigDecimal("cantidad").toPlainString() + " "
                                + resultados.getString("unidad_base") + " | Alcoholico: "
                                + (resultados.getBoolean("alcoholico") ? "Si" : "No")
                                + " | Observaciones: " + (observaciones == null ? "-" : observaciones));
                        total++;
                    }
                    System.out.println("Ingredientes encontrados: " + total);
                }
            }
        }
    }

    private static void actualizarRelacion(Scanner entrada) throws SQLException {
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarRecetas(conexion);

            int idReceta = Integer.parseInt(leer(entrada, " ID de la receta: "));
            int idIngrediente = Integer.parseInt(leer(entrada, "ID del ingrediente: "));
            BigDecimal cantidad = new BigDecimal(leer(entrada, "Nueva cantidad: "));

            System.out.print("Nuevas observaciones (opcional): ");
            String observaciones = entrada.nextLine().trim();

            if (idReceta <= 0 || idIngrediente <= 0) {
                throw new IllegalArgumentException("Los ID deben ser positivos.");
            }

            if (cantidad.signum() <= 0
                    || cantidad.compareTo(new BigDecimal("999999.99")) > 0
                    || cantidad.stripTrailingZeros().scale() > 2) {
                throw new IllegalArgumentException(
                        "La cantidad debe estar entre 0.01 y 999999.99, con hasta dos decimales.");
            }

            if (observaciones.length() > 255) {
                throw new IllegalArgumentException(
                        "Las observaciones admiten hasta 255 caracteres.");
            }

            String sql = "UPDATE receta_ingrediente SET cantidad = ?, observaciones = ? "
                    + "WHERE id_receta = ? AND id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sql)) {
                sentencia.setBigDecimal(1, cantidad);
                sentencia.setString(2, observaciones.isEmpty() ? null : observaciones);
                sentencia.setInt(3, idReceta);
                sentencia.setInt(4, idIngrediente);

                int filas = sentencia.executeUpdate();

                if (filas > 0) {
                    System.out.println("Cantidad y observaciones actualizadas correctamente.");
                } else {
                    System.out.println("Ese ingrediente no esta asociado a la receta indicada.");
                }
            }
        }
    }

    private static void actualizarIngrediente(Scanner entrada) throws SQLException {
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarIngredientes(conexion);

            int idIngrediente = Integer.parseInt(leer(entrada, "ID del ingrediente: "));
            String nombre = leer(entrada, "Nuevo nombre: ");
            String tipo = leer(entrada, "Nuevo tipo: ");
            String respuesta = leer(entrada, "Es alcoholico? (s/n): ");

            if (idIngrediente <= 0) {
                throw new IllegalArgumentException("El ID debe ser positivo.");
            }

            if (nombre.length() > 100 || tipo.length() > 50) {
                throw new IllegalArgumentException(
                        "Nombre: maximo 100 caracteres. Tipo: maximo 50.");
            }

            if (!respuesta.equalsIgnoreCase("s") && !respuesta.equalsIgnoreCase("n")) {
                throw new IllegalArgumentException("Indica s o n.");
            }

            String sql = "UPDATE ingredientes SET nombre_ingrediente = ?, tipo = ?, alcoholico = ? "
                    + "WHERE id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sql)) {
                sentencia.setString(1, nombre);
                sentencia.setString(2, tipo);
                sentencia.setBoolean(3, respuesta.equalsIgnoreCase("s"));
                sentencia.setInt(4, idIngrediente);

                int filas = sentencia.executeUpdate();

                if (filas > 0) {
                    System.out.println("Ingrediente actualizado correctamente.");
                    mostrarIngredientes(conexion);
                } else {
                    System.out.println("El ingrediente indicado no existe.");
                }
            }
        }
    }

    private static void eliminarRelacion(Scanner entrada) throws SQLException {
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarRecetas(conexion);
            int idReceta = Integer.parseInt(leer(entrada, "ID de la receta: "));

            mostrarIngredientes(conexion);
            int idIngrediente = Integer.parseInt(
                    leer(entrada, "ID del ingrediente a quitar: "));

            if (idReceta <= 0 || idIngrediente <= 0) {
                throw new IllegalArgumentException("Los ID deben ser positivos.");
            }

            String respuesta = leer(
                    entrada, "Confirmas quitarlo de esta receta? (s/n): ");

            if (respuesta.equalsIgnoreCase("n")) {
                System.out.println("Eliminacion cancelada.");
                return;
            }

            if (!respuesta.equalsIgnoreCase("s")) {
                throw new IllegalArgumentException("Indica s o n.");
            }

            String sql = "DELETE FROM receta_ingrediente "
                    + "WHERE id_receta = ? AND id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sql)) {
                sentencia.setInt(1, idReceta);
                sentencia.setInt(2, idIngrediente);

                int filas = sentencia.executeUpdate();

                if (filas > 0) {
                    System.out.println(
                            "Asociacion eliminada. El ingrediente sigue en el catalogo.");
                } else {
                    System.out.println(
                            "Ese ingrediente no esta asociado a la receta indicada.");
                }
            }
        }
    }

    private static void eliminarIngrediente(Scanner entrada) throws SQLException {
        try (Connection conexion = ConexionDB.obtenerConexion()) {
            mostrarIngredientes(conexion);

            int idIngrediente = Integer.parseInt(
                    leer(entrada, "ID del ingrediente a eliminar: "));

            if (idIngrediente <= 0) {
                throw new IllegalArgumentException("El ID debe ser positivo.");
            }

            String nombre;
            String sqlBuscar = "SELECT nombre_ingrediente FROM ingredientes "
                    + "WHERE id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sqlBuscar)) {
                sentencia.setInt(1, idIngrediente);

                try (ResultSet resultados = sentencia.executeQuery()) {
                    if (!resultados.next()) {
                        System.out.println("El ingrediente indicado no existe.");
                        return;
                    }
                    nombre = resultados.getString("nombre_ingrediente");
                }
            }

            String sqlUso = "SELECT COUNT(*) AS total FROM receta_ingrediente "
                    + "WHERE id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sqlUso)) {
                sentencia.setInt(1, idIngrediente);

                try (ResultSet resultados = sentencia.executeQuery()) {
                    resultados.next();

                    if (resultados.getInt("total") > 0) {
                        System.out.println(
                                "El ingrediente sigue asociado a recetas. "
                                        + "Quita sus asociaciones con la opcion 5 antes de eliminarlo.");
                        return;
                    }
                }
            }

            String respuesta = leer(
                    entrada, "Confirmas eliminar " + nombre + " del catalogo? (s/n): ");

            if (respuesta.equalsIgnoreCase("n")) {
                System.out.println("Eliminacion cancelada.");
                return;
            }

            if (!respuesta.equalsIgnoreCase("s")) {
                throw new IllegalArgumentException("Indica s o n.");
            }

            String sql = "DELETE FROM ingredientes WHERE id_ingrediente = ?";

            try (PreparedStatement sentencia = conexion.prepareStatement(sql)) {
                sentencia.setInt(1, idIngrediente);

                int filas = sentencia.executeUpdate();

                if (filas > 0) {
                    System.out.println("Ingrediente eliminado del catalogo.");
                    mostrarIngredientes(conexion);
                } else {
                    System.out.println("El ingrediente indicado no existe.");
                }
            }
        }
    }

    private static void mostrarRecetas(Connection conexion) throws SQLException {
        String sql = "SELECT id_receta, nombre_receta FROM recetas ORDER BY id_receta";
        try (PreparedStatement sentencia = conexion.prepareStatement(sql);
             ResultSet resultados = sentencia.executeQuery()) {
            System.out.println("\nRECETAS DISPONIBLES");
            while (resultados.next()) {
                System.out.println(resultados.getInt("id_receta") + " - "
                        + resultados.getString("nombre_receta"));
            }
        }
    }

    private static void mostrarIngredientes(Connection conexion) throws SQLException {
        String sql = "SELECT id_ingrediente, nombre_ingrediente, tipo, unidad_base, alcoholico "
                + "FROM ingredientes ORDER BY id_ingrediente";

        try (PreparedStatement sentencia = conexion.prepareStatement(sql);
             ResultSet resultados = sentencia.executeQuery()) {

            System.out.println("\nID | Ingrediente | Tipo | Unidad base | Alcoholico");

            while (resultados.next()) {
                System.out.println(resultados.getInt("id_ingrediente") + " | "
                        + resultados.getString("nombre_ingrediente") + " | "
                        + resultados.getString("tipo") + " | "
                        + resultados.getString("unidad_base") + " | "
                        + (resultados.getBoolean("alcoholico") ? "Si" : "No"));
            }
        }
    }

    private static String leer(Scanner entrada, String mensaje) {
        System.out.print(mensaje);
        String valor = entrada.nextLine().trim();
        if (valor.isEmpty()) {
            throw new IllegalArgumentException("Completa los campos obligatorios.");
        }
        return valor;
    }
}
