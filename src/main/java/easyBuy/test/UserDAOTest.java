package easyBuy.test;

import java.sql.Connection;
import java.sql.PreparedStatement;

import easyBuy.dao.UserDAO;
import easyBuy.dao.UserDAOImpl;
import easyBuy.model.User;
import easyBuy.util.DBConnection;

public class UserDAOTest {

    public static void main(String[] args) {

        String testEmail = "testuser_easybuy@gmail.com";

        UserDAO userDAO = new UserDAOImpl();

        try {

            System.out.println("=================================");
            System.out.println("STARTING USER DAO TEST");
            System.out.println("=================================");

            // 1. Check whether test email already exists
            boolean exists = userDAO.emailExists(testEmail);

            if (exists) {

                System.out.println(
                        "Test email already exists."
                );

                System.out.println(
                        "Delete the test user from MySQL and run again."
                );

                return;
            }

            // 2. Create test user
            User user = new User(
                    "EasyBuy Test User",
                    testEmail,
                    "test_password_hash",
                    "9876543210"
            );

            // 3. Register user
            boolean registered =
                    userDAO.registerUser(user);

            if (!registered) {

                System.out.println(
                        "USER REGISTRATION TEST FAILED"
                );

                return;
            }

            System.out.println(
                    "User inserted successfully."
            );

            // 4. Find the newly created user
            User savedUser =
                    userDAO.getUserByEmail(testEmail);

            if (savedUser != null) {

                System.out.println(
                        "User retrieved successfully."
                );

                System.out.println(
                        "User ID   : " + savedUser.getUserId()
                );

                System.out.println(
                        "Name      : " + savedUser.getName()
                );

                System.out.println(
                        "Email     : " + savedUser.getEmail()
                );

                System.out.println(
                        "Phone     : " + savedUser.getPhone()
                );

            } else {

                System.out.println(
                        "USER RETRIEVAL TEST FAILED"
                );

                return;
            }

            // 5. Check duplicate email detection
            boolean duplicate =
                    userDAO.emailExists(testEmail);

            if (duplicate) {

                System.out.println(
                        "Duplicate email check: PASSED"
                );

            } else {

                System.out.println(
                        "Duplicate email check: FAILED"
                );
            }

            // 6. Delete test user
            String deleteSQL =
                    "DELETE FROM users WHERE email = ?";

            try (Connection connection =
                         DBConnection.getConnection();
                 PreparedStatement statement =
                         connection.prepareStatement(deleteSQL)) {

                statement.setString(1, testEmail);

                int deleted =
                        statement.executeUpdate();

                if (deleted > 0) {

                    System.out.println(
                            "Test user deleted successfully."
                    );
                }
            }

            System.out.println("=================================");
            System.out.println("USER DAO TEST SUCCESSFUL");
            System.out.println("=================================");

        } catch (Exception e) {

            System.out.println("=================================");
            System.out.println("USER DAO TEST FAILED");
            System.out.println("=================================");

            e.printStackTrace();
        }
    }
}