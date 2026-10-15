package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import easyBuy.model.Cart;
import easyBuy.model.CartItem;
import easyBuy.util.DBConnection;

public class CartDAOImpl implements CartDAO {

    @Override
    public Cart getCartByUserId(int userId) {

        String sql = "SELECT * FROM cart WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                Cart cart = new Cart();

                cart.setCartId(resultSet.getInt("cart_id"));
                cart.setUserId(resultSet.getInt("user_id"));

                return cart;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Cart createCart(int userId) {

        String sql = "INSERT INTO cart (user_id) VALUES (?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, userId);

            int rowsInserted = statement.executeUpdate();

            if (rowsInserted > 0) {

                ResultSet generatedKeys = statement.getGeneratedKeys();

                if (generatedKeys.next()) {
                    Cart cart = new Cart();

                    cart.setCartId(generatedKeys.getInt(1));
                    cart.setUserId(userId);

                    return cart;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean addItemToCart(CartItem cartItem) {

        String sql = "INSERT INTO cart_items "
                   + "(cart_id, product_id, quantity) "
                   + "VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, cartItem.getCartId());
            statement.setInt(2, cartItem.getProductId());
            statement.setInt(3, cartItem.getQuantity());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<CartItem> getCartItems(int cartId) {

        String sql = "SELECT * FROM cart_items WHERE cart_id = ?";

        List<CartItem> cartItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, cartId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                cartItems.add(mapCartItem(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItems;
    }

    @Override
    public boolean updateItemQuantity(int cartItemId, int quantity) {

        String sql = "UPDATE cart_items "
                   + "SET quantity = ? "
                   + "WHERE cart_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, quantity);
            statement.setInt(2, cartItemId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean removeItemFromCart(int cartItemId) {

        String sql = "DELETE FROM cart_items "
                   + "WHERE cart_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, cartItemId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean clearCart(int cartId) {

        String sql = "DELETE FROM cart_items WHERE cart_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, cartId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isProductInCart(int cartId, int productId) {

        String sql = "SELECT cart_item_id "
                   + "FROM cart_items "
                   + "WHERE cart_id = ? AND product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, cartId);
            statement.setInt(2, productId);

            ResultSet resultSet = statement.executeQuery();

            return resultSet.next();

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private CartItem mapCartItem(ResultSet resultSet)
            throws SQLException {

        CartItem cartItem = new CartItem();

        cartItem.setCartItemId(
                resultSet.getInt("cart_item_id"));

        cartItem.setCartId(
                resultSet.getInt("cart_id"));

        cartItem.setProductId(
                resultSet.getInt("product_id"));

        cartItem.setQuantity(
                resultSet.getInt("quantity"));

        return cartItem;
    }
}