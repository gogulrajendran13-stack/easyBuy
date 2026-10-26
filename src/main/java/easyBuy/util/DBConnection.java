
package easyBuy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // Read the hosted database URL from Render.
    // Use the local database URL when running on your computer.
    private static final String URL = getEnvironmentValue(
            "EASYBUY_DB_URL",
            "jdbc:mysql://localhost:3306/ecommerce_db"
                    + "?useSSL=false"
                    + "&serverTimezone=Asia/Kolkata"
                    + "&allowPublicKeyRetrieval=true"
    );

    private static final String USERNAME =
            System.getenv("EASYBUY_DB_USERNAME");

    private static final String PASSWORD =
            System.getenv("EASYBUY_DB_PASSWORD");

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
            System.err.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
        }
    }

    private DBConnection() {
        // Prevent object creation.
    }

    public static Connection getConnection() throws SQLException {

        if (USERNAME == null || USERNAME.trim().isEmpty()
                || PASSWORD == null || PASSWORD.isEmpty()) {
            throw new SQLException(
                    "Database username or password environment variable is missing."
            );
        }

        return DriverManager.getConnection(
                URL,
                USERNAME,
                PASSWORD
        );
    }
}
