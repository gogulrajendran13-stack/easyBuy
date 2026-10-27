
package easyBuy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String LOCAL_URL =
            "jdbc:mysql://localhost:3306/ecommerce_db"
            + "?useSSL=false"
            + "&serverTimezone=Asia/Kolkata"
            + "&allowPublicKeyRetrieval=true";

    private static final String URL =
            getEnvironmentValue("EASYBUY_DB_URL", LOCAL_URL);

    private static final String USERNAME =
            getEnvironmentValue("EASYBUY_DB_USERNAME", null);

    private static final String PASSWORD =
            getEnvironmentValue("EASYBUY_DB_PASSWORD", null);

    private static String getEnvironmentValue(
            String variableName, String defaultValue) {

        String value = System.getenv(variableName);

        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBConnection() {
        // Prevent object creation.
    }

    public static Connection getConnection() throws SQLException {

        if (USERNAME == null || USERNAME.isEmpty()) {
            throw new SQLException(
                    "EASYBUY_DB_USERNAME is missing from the application environment."
            );
        }

        if (PASSWORD == null || PASSWORD.isEmpty()) {
            throw new SQLException(
                    "EASYBUY_DB_PASSWORD is missing from the application environment."
            );
        }

        if (URL.contains("localhost:3306")) {
            System.out.println(
                    "Database configuration: local MySQL URL selected."
            );
        } else {
            System.out.println(
                    "Database configuration: hosted database URL selected."
            );
        }

        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
