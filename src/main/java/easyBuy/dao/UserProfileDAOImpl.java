package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import easyBuy.model.UserProfile;
import easyBuy.util.DBConnection;

public class UserProfileDAOImpl implements UserProfileDAO {

    // =========================================================
    // GET PROFILE BY USER ID
    // =========================================================

    @Override
    public UserProfile getProfileByUserId(int userId) {

        String sql =
                "SELECT profile_id, user_id, first_name, last_name, gender, address " +
                "FROM user_profiles " +
                "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {

                if (resultSet.next()) {
                    return mapUserProfile(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    // =========================================================
    // CREATE PROFILE
    // =========================================================

    @Override
    public boolean createProfile(UserProfile profile) {

        String sql =
                "INSERT INTO user_profiles " +
                "(user_id, first_name, last_name, gender, address) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, profile.getUserId());
            statement.setString(2, profile.getFirstName());
            statement.setString(3, profile.getLastName());
            statement.setString(4, profile.getGender());
            statement.setString(5, profile.getAddress());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // =========================================================
    // UPDATE PROFILE
    // =========================================================

    @Override
    public boolean updateProfile(UserProfile profile) {

        String sql =
                "UPDATE user_profiles " +
                "SET first_name = ?, " +
                "last_name = ?, " +
                "gender = ?, " +
                "address = ? " +
                "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, profile.getFirstName());
            statement.setString(2, profile.getLastName());
            statement.setString(3, profile.getGender());
            statement.setString(4, profile.getAddress());
            statement.setInt(5, profile.getUserId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // =========================================================
    // DELETE PROFILE
    // =========================================================

    @Override
    public boolean deleteProfile(int userId) {

        String sql =
                "DELETE FROM user_profiles " +
                "WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // =========================================================
    // MAP RESULT SET TO USER PROFILE
    // =========================================================

    private UserProfile mapUserProfile(ResultSet resultSet)
            throws SQLException {

        UserProfile profile = new UserProfile();

        profile.setProfileId(
                resultSet.getInt("profile_id")
        );

        profile.setUserId(
                resultSet.getInt("user_id")
        );

        profile.setFirstName(
                resultSet.getString("first_name")
        );

        profile.setLastName(
                resultSet.getString("last_name")
        );

        profile.setGender(
                resultSet.getString("gender")
        );

        profile.setAddress(
                resultSet.getString("address")
        );

        return profile;
    }
}