package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import easyBuy.model.Payment;
import easyBuy.util.DBConnection;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public boolean createPayment(Payment payment) {

        String sql = "INSERT INTO payments "
                   + "(order_id, payment_method, payment_status, transaction_id) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, payment.getOrderId());
            statement.setString(2, payment.getPaymentMethod());
            statement.setString(3, payment.getPaymentStatus());
            statement.setString(4, payment.getTransactionId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Payment getPaymentById(int paymentId) {

        String sql = "SELECT * FROM payments WHERE payment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, paymentId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapPayment(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Payment getPaymentByOrderId(int orderId) {

        String sql = "SELECT * FROM payments WHERE order_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, orderId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return mapPayment(resultSet);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean updatePaymentStatus(
            int paymentId,
            String paymentStatus) {

        String sql = "UPDATE payments "
                   + "SET payment_status = ? "
                   + "WHERE payment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, paymentStatus);
            statement.setInt(2, paymentId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateTransactionId(
            int paymentId,
            String transactionId) {

        String sql = "UPDATE payments "
                   + "SET transaction_id = ? "
                   + "WHERE payment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, transactionId);
            statement.setInt(2, paymentId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Payment mapPayment(ResultSet resultSet)
            throws SQLException {

        Payment payment = new Payment();

        payment.setPaymentId(
                resultSet.getInt("payment_id"));

        payment.setOrderId(
                resultSet.getInt("order_id"));

        payment.setPaymentMethod(
                resultSet.getString("payment_method"));

        payment.setPaymentStatus(
                resultSet.getString("payment_status"));

        payment.setTransactionId(
                resultSet.getString("transaction_id"));

        return payment;
    }
}