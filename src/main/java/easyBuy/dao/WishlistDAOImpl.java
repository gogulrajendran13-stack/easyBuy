package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import easyBuy.model.Wishlist;
import easyBuy.util.DBConnection;

public class WishlistDAOImpl implements WishlistDAO {

    @Override
    public boolean addToWishlist(Wishlist wishlist) {

        String sql = "INSERT INTO wishlist (user_id, product_id) VALUES (?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, wishlist.getUserId());
            statement.setInt(2, wishlist.getProductId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeFromWishlist(int userId, int productId) {

        String sql = "DELETE FROM wishlist "
                   + "WHERE user_id = ? AND product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setInt(2, productId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Wishlist> getWishlistByUserId(int userId) {

        String sql = "SELECT * FROM wishlist WHERE user_id = ?";

        List<Wishlist> wishlistItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                wishlistItems.add(mapWishlist(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wishlistItems;
    }

    @Override
    public boolean isProductInWishlist(int userId, int productId) {

        String sql = "SELECT wishlist_id FROM wishlist "
                   + "WHERE user_id = ? AND product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.setInt(2, productId);

            ResultSet resultSet = statement.executeQuery();

            return resultSet.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean clearWishlist(int userId) {

        String sql = "DELETE FROM wishlist WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Wishlist mapWishlist(ResultSet resultSet)
            throws SQLException {

        Wishlist wishlist = new Wishlist();

        wishlist.setWishlistId(
                resultSet.getInt("wishlist_id"));

        wishlist.setUserId(
                resultSet.getInt("user_id"));

        wishlist.setProductId(
                resultSet.getInt("product_id"));

        return wishlist;
    }
}