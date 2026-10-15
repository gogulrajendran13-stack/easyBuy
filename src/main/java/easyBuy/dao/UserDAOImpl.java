package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import easyBuy.model.User;
import easyBuy.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    /* =========================================================
       REGISTER USER
       ========================================================= */
    @Override
    public boolean registerUser(User user) {

        String sql =
                "INSERT INTO users " +
                "(name, email, password_hash, phone) " +
                "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, user.getName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPasswordHash());
            statement.setString(4, user.getPhone());

            int rowsAffected = statement.executeUpdate();

            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    /* =========================================================
       CHECK WHETHER EMAIL ALREADY EXISTS
       ========================================================= */
    @Override
    public boolean emailExists(String email) {

        String sql =
                "SELECT user_id " +
                "FROM users " +
                "WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {

                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    /* =========================================================
       GET USER BY EMAIL
       ========================================================= */
    @Override
    public User getUserByEmail(String email) {

        String sql =
                "SELECT user_id, name, email, password_hash, phone " +
                "FROM users " +
                "WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {

                    User user = new User();

                    user.setUserId(
                            resultSet.getInt("user_id")
                    );

                    user.setName(
                            resultSet.getString("name")
                    );

                    user.setEmail(
                            resultSet.getString("email")
                    );

                    user.setPasswordHash(
                            resultSet.getString("password_hash")
                    );

                    user.setPhone(
                            resultSet.getString("phone")
                    );

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}