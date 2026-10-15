package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import easyBuy.model.Order;
import easyBuy.model.OrderItem;
import easyBuy.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int createOrder(Order order) {

        String sql = "INSERT INTO orders "
                   + "(user_id, order_date, total_amount, order_status) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(1, order.getUserId());
            statement.setTimestamp(
                    2,
                    java.sql.Timestamp.valueOf(order.getOrderDate())
            );
            statement.setDouble(3, order.getTotalAmount());
            statement.setString(4, order.getOrderStatus());

            int rowsInserted = statement.executeUpdate();

            if (rowsInserted > 0) {

                ResultSet generatedKeys = statement.getGeneratedKeys();

                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    @Override
    public boolean addOrderItem(OrderItem orderItem) {

        String sql = "INSERT INTO order_items "
                   + "(order_id, product_id, quantity, price, subtotal) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, orderItem.getOrderId());
            statement.setInt(2, orderItem.getProductId());
            statement.setInt(3, orderItem.getQuantity());
            statement.setDouble(4, orderItem.getPrice());
            statement.setDouble(5, orderItem.getSubtotal());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Order getOrderById(int orderId) {

        String sql = "SELECT * FROM orders WHERE order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, orderId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapOrder(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        String sql = "SELECT * FROM orders "
                   + "WHERE user_id = ? "
                   + "ORDER BY order_date DESC";

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                orders.add(mapOrder(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public List<OrderItem> getOrderItems(int orderId) {

        String sql = "SELECT * FROM order_items "
                   + "WHERE order_id = ?";

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, orderId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                orderItems.add(mapOrderItem(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItems;
    }

    @Override
    public boolean updateOrderStatus(
            int orderId,
            String orderStatus) {

        String sql = "UPDATE orders "
                   + "SET order_status = ? "
                   + "WHERE order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, orderStatus);
            statement.setInt(2, orderId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean cancelOrder(int orderId) {

        String sql = "UPDATE orders "
                   + "SET order_status = ? "
                   + "WHERE order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, "CANCELLED");
            statement.setInt(2, orderId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Order mapOrder(ResultSet resultSet)
            throws SQLException {

        Order order = new Order();

        order.setOrderId(
                resultSet.getInt("order_id"));

        order.setUserId(
                resultSet.getInt("user_id"));

        order.setOrderDate(
                resultSet.getTimestamp("order_date")
                        .toLocalDateTime());

        order.setTotalAmount(
                resultSet.getDouble("total_amount"));

        order.setOrderStatus(
                resultSet.getString("order_status"));

        return order;
    }

    private OrderItem mapOrderItem(ResultSet resultSet)
            throws SQLException {

        OrderItem orderItem = new OrderItem();

        orderItem.setOrderItemId(
                resultSet.getInt("order_item_id"));

        orderItem.setOrderId(
                resultSet.getInt("order_id"));

        orderItem.setProductId(
                resultSet.getInt("product_id"));

        orderItem.setQuantity(
                resultSet.getInt("quantity"));

        orderItem.setPrice(
                resultSet.getDouble("price"));

        orderItem.setSubtotal(
                resultSet.getDouble("subtotal"));

        return orderItem;
    }
}