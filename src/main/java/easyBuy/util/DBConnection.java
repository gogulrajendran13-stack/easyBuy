package easyBuy.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/ecommerce_db"
            + "?useSSL=false"
            + "&serverTimezone=Asia/Kolkata"
            + "&allowPublicKeyRetrieval=true";


private static final String USERNAME =
        System.getenv("EASYBUY_DB_USERNAME");

private static final String PASSWORD =
        System.getenv("EASYBUY_DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println(
                    "MySQL JDBC Driver loaded successfully."
            );

        } catch (ClassNotFoundException e) {

            System.err.println(
                    "MySQL JDBC Driver not found."
            );

            e.printStackTrace();
        }
    }

    private DBConnection() {
        // Prevent creating objects.
    }

    public static Connection getConnection()
            throws SQLException {

        return DriverManager.getConnection(
                URL,
                USERNAME,
                PASSWORD
        );
    }
}
