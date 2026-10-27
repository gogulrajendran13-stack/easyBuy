
package easyBuy.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;

public class DBConnectionTest {

    public static void main(String[] args) {

        System.out.println("EASYBUY_DB_USERNAME = "
                + System.getenv("EASYBUY_DB_USERNAME"));

        System.out.println("EASYBUY_DB_URL = "
                + System.getenv("EASYBUY_DB_URL"));

        try (Connection connection = DBConnection.getConnection()) {

            DatabaseMetaData metaData = connection.getMetaData();

            System.out.println("================================");
            System.out.println("DATABASE CONNECTION SUCCESSFUL");
            System.out.println("Database: " + connection.getCatalog());
            System.out.println("Server: " + metaData.getURL());
            System.out.println("Username: " + metaData.getUserName());
            System.out.println("================================");

        } catch (Exception e) {
            System.out.println("DATABASE CONNECTION FAILED");
            e.printStackTrace();
        }
    }
}
