package easyBuy.dao;

import easyBuy.model.Payment;

public interface PaymentDAO {

    boolean createPayment(Payment payment);

    Payment getPaymentById(int paymentId);

    Payment getPaymentByOrderId(int orderId);

    boolean updatePaymentStatus(int paymentId, String paymentStatus);

    boolean updateTransactionId(int paymentId, String transactionId);
}