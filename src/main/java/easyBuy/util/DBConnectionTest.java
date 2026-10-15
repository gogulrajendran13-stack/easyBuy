package easyBuy.util;

import java.sql.Connection;

public class DBConnectionTest {

    public static void main(String[] args) {

        try (Connection connection = DBConnection.getConnection()) {

            if (connection != null && !connection.isClosed()) {

                System.out.println("=================================");
                System.out.println("DATABASE CONNECTION SUCCESSFUL");
                System.out.println("Database : " + connection.getCatalog());
                System.out.println("=================================");

            }

        } catch (Exception e) {

            System.out.println("=================================");
            System.out.println("DATABASE CONNECTION FAILED");
            System.out.println("=================================");

            e.printStackTrace();
        }
    }
}