package easyBuy.dao;

import java.util.List;
import easyBuy.model.Order;
import easyBuy.model.OrderItem;

public interface OrderDAO {

    int createOrder(Order order);

    boolean addOrderItem(OrderItem orderItem);

    Order getOrderById(int orderId);

    List<Order> getOrdersByUserId(int userId);

    List<OrderItem> getOrderItems(int orderId);

    boolean updateOrderStatus(int orderId, String orderStatus);

    boolean cancelOrder(int orderId);
}