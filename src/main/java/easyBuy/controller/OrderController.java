package easyBuy.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.CartDAO;
import easyBuy.dao.CartDAOImpl;
import easyBuy.dao.OrderDAO;
import easyBuy.dao.OrderDAOImpl;
import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Cart;
import easyBuy.model.CartItem;
import easyBuy.model.Order;
import easyBuy.model.OrderItem;
import easyBuy.model.Product;
import easyBuy.model.User;

@WebServlet({"/orders", "/my-orders"})
public class OrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private ProductDAO productDAO;

    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        orderDAO = new OrderDAOImpl();
        cartDAO = new CartDAOImpl();
        productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("ORDER CONTROLLER INITIALIZED");
        System.out.println("=================================");
    }

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("ORDER CONTROLLER - doGet()");
        System.out.println("=================================");

        HttpSession session =
                request.getSession(false);

        Integer sessionUserId =
                getUserIdFromSession(session);

        String servletPath =
                request.getServletPath();

        // =====================================================
        // MY ORDERS
        // =====================================================

        if ("/my-orders".equalsIgnoreCase(servletPath)) {

            if (!isValidUserId(sessionUserId)) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/login"
                );

                return;
            }

            listOrdersForUser(
                    request,
                    response,
                    sessionUserId
            );

            return;
        }

        // =====================================================
        // /orders
        // =====================================================

        String action =
                clean(
                        request.getParameter("action")
                );

        /*
         * /orders without an action:
         * show current user's orders.
         */

        if (action.isEmpty()) {

            if (!isValidUserId(sessionUserId)) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/login"
                );

                return;
            }

            listOrdersForUser(
                    request,
                    response,
                    sessionUserId
            );

            return;
        }

        try {

            switch (action.toLowerCase()) {

                case "view":

                    viewOrder(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                case "items":

                    viewOrderItems(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                case "list":

                    listOrders(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Invalid order action."
                    );

                    break;
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order or user ID."
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to process order request.",
                    e
            );
        }
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("ORDER CONTROLLER - doPost()");
        System.out.println("=================================");

        HttpSession session =
                request.getSession(false);

        Integer sessionUserId =
                getUserIdFromSession(session);

        if (!isValidUserId(sessionUserId)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        String action =
                clean(
                        request.getParameter("action")
                );

        if (action.isEmpty()) {
            action = "create";
        }

        try {

            switch (action.toLowerCase()) {

                /*
                 * Existing manual order creation flow.
                 */
                case "create":

                    createOrder(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                /*
                 * New checkout flow.
                 *
                 * Creates the order directly from the
                 * current user's cart.
                 */
                case "checkout":

                    createOrderFromCart(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                case "additem":

                    addOrderItem(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                case "status":

                    updateOrderStatus(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                case "cancel":

                    cancelOrder(
                            request,
                            response,
                            sessionUserId
                    );

                    break;

                default:

                    response.sendError(
                            HttpServletResponse.SC_BAD_REQUEST,
                            "Invalid order action."
                    );

                    break;
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid numeric value."
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to process order request.",
                    e
            );
        }
    }

    // =========================================================
    // CREATE ORDER FROM CHECKOUT / CART
    // =========================================================

    private void createOrderFromCart(
            HttpServletRequest request,
            HttpServletResponse response,
            int sessionUserId)
            throws Exception {

        System.out.println(
                "Creating order from current user's cart."
        );

        // =====================================================
        // GET USER CART
        // =====================================================

        Cart cart =
                cartDAO.getCartByUserId(
                        sessionUserId
                );

        if (cart == null) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Your cart is empty."
            );

            return;
        }

        // =====================================================
        // GET CART ITEMS
        // =====================================================

        List<CartItem> cartItems =
                cartDAO.getCartItems(
                        cart.getCartId()
                );

        if (cartItems == null) {
            cartItems = Collections.emptyList();
        }

        if (cartItems.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Your cart is empty."
            );

            return;
        }

        // =====================================================
        // CALCULATE TOTAL FROM DATABASE PRODUCTS
        // =====================================================

        BigDecimal total =
                BigDecimal.ZERO;

        for (CartItem cartItem : cartItems) {

            if (cartItem == null) {
                continue;
            }

            if (cartItem.getQuantity() <= 0) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid cart quantity."
                );

                return;
            }

            Product product =
                    productDAO.getProductById(
                            cartItem.getProductId()
                    );

            if (product == null) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "A product in your cart is no longer available."
                );

                return;
            }

            BigDecimal price =
                    BigDecimal.valueOf(
                            product.getPrice()
                    );

            BigDecimal quantity =
                    BigDecimal.valueOf(
                            cartItem.getQuantity()
                    );

            BigDecimal subtotal =
                    price.multiply(quantity);

            total =
                    total.add(subtotal);
        }

        if (total.compareTo(BigDecimal.ZERO) <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order total must be greater than zero."
            );

            return;
        }

        // =====================================================
        // CREATE ORDER
        // =====================================================

        Order order =
                new Order();

        order.setUserId(
                sessionUserId
        );

        order.setOrderDate(
                LocalDateTime.now()
        );

        order.setTotalAmount(
                total.doubleValue()
        );

        /*
         * PaymentController changes this to CONFIRMED
         * after successful payment.
         */
        order.setOrderStatus(
                "PENDING"
        );

        int orderId =
                orderDAO.createOrder(
                        order
                );

        if (orderId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to create order."
            );

            return;
        }

        System.out.println(
                "Order created successfully."
        );

        System.out.println(
                "Order ID: " + orderId
        );

        System.out.println(
                "User ID: " + sessionUserId
        );

        System.out.println(
                "Order Total: " + total
        );

        // =====================================================
        // CREATE ORDER ITEMS
        // =====================================================

        for (CartItem cartItem : cartItems) {

            Product product =
                    productDAO.getProductById(
                            cartItem.getProductId()
                    );

            if (product == null) {

                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "A product in your cart is no longer available."
                );

                return;
            }

            BigDecimal price =
                    BigDecimal.valueOf(
                            product.getPrice()
                    );

            BigDecimal quantity =
                    BigDecimal.valueOf(
                            cartItem.getQuantity()
                    );

            BigDecimal subtotal =
                    price.multiply(quantity);

            OrderItem orderItem =
                    new OrderItem();

            orderItem.setOrderId(
                    orderId
            );

            orderItem.setProductId(
                    product.getProductId()
            );

            orderItem.setQuantity(
                    cartItem.getQuantity()
            );

            orderItem.setPrice(
                    price.doubleValue()
            );

            orderItem.setSubtotal(
                    subtotal.doubleValue()
            );

            boolean added =
                    orderDAO.addOrderItem(
                            orderItem
                    );

            if (!added) {

                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to create order items."
                );

                return;
            }
        }

        // =====================================================
        // SAVE ORDER ID FOR PAYMENT CONTROLLER
        // =====================================================

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "orderId",
                orderId
        );

        session.setAttribute(
                "checkoutOrderId",
                orderId
        );

        session.setAttribute(
                "checkoutOrderTotal",
                total
        );

        // =====================================================
        // CONTINUE TO PAYMENT
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                        + "/payment?orderId="
                        + orderId
        );
    }

    // =========================================================
    // EXISTING CREATE ORDER
    // =========================================================

    private void createOrder(
            HttpServletRequest request,
            HttpServletResponse response,
            int sessionUserId)
            throws ServletException, IOException {

        String userIdParameter =
                clean(
                        request.getParameter("userId")
                );

        String totalAmountParameter =
                clean(
                        request.getParameter("totalAmount")
                );

        String orderStatus =
                clean(
                        request.getParameter("orderStatus")
                );

        if (userIdParameter.isEmpty()
                || totalAmountParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "User ID and total amount are required."
            );

            return;
        }

        int userId =
                Integer.parseInt(
                        userIdParameter
                );

        if (userId != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to create this order."
            );

            return;
        }

        double totalAmount =
                Double.parseDouble(
                        totalAmountParameter
                );

        if (totalAmount < 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Total amount cannot be negative."
            );

            return;
        }

        if (orderStatus.isEmpty()) {
            orderStatus = "PENDING";
        }

        Order order =
                new Order();

        order.setUserId(
                userId
        );

        order.setOrderDate(
                LocalDateTime.now()
        );

        order.setTotalAmount(
                totalAmount
        );

        order.setOrderStatus(
                orderStatus
        );

        int orderId =
                orderDAO.createOrder(
                        order
                );

        if (orderId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to create order."
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/orders?action=view&orderId="
                        + orderId
        );
    }

    // =========================================================
    // ADD ORDER ITEM
    // =========================================================

    private void addOrderItem(
            HttpServletRequest request,
            HttpServletResponse response,
            int sessionUserId)
            throws IOException {

        String orderIdParameter =
                clean(
                        request.getParameter("orderId")
                );

        String productIdParameter =
                clean(
                        request.getParameter("productId")
                );

        String quantityParameter =
                clean(
                        request.getParameter("quantity")
                );

        String priceParameter =
                clean(
                        request.getParameter("price")
                );

        String subtotalParameter =
                clean(
                        request.getParameter("subtotal")
                );

        if (orderIdParameter.isEmpty()
                || productIdParameter.isEmpty()
                || quantityParameter.isEmpty()
                || priceParameter.isEmpty()
                || subtotalParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "All order item fields are required."
            );

            return;
        }

        int orderId =
                Integer.parseInt(
                        orderIdParameter
                );

        int productId =
                Integer.parseInt(
                        productIdParameter
                );

        int quantity =
                Integer.parseInt(
                        quantityParameter
                );

        double price =
                Double.parseDouble(
                        priceParameter
                );

        double subtotal =
                Double.parseDouble(
                        subtotalParameter
                );

        if (orderId <= 0
                || productId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order or product ID."
            );

            return;
        }

        if (quantity <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Quantity must be greater than zero."
            );

            return;
        }

        if (price < 0
                || subtotal < 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Price and subtotal cannot be negative."
            );

            return;
        }

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found."
            );

            return;
        }

        if (order.getUserId() != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to modify this order."
            );

            return;
        }

        OrderItem orderItem =
                new OrderItem();

        orderItem.setOrderId(
                orderId
        );

        orderItem.setProductId(
                productId
        );

        orderItem.setQuantity(
                quantity
        );

        orderItem.setPrice(
                price
        );

        orderItem.setSubtotal(
                subtotal
        );

        boolean added =
                orderDAO.addOrderItem(
                        orderItem
                );

        if (!added) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to add order item."
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/orders?action=view&orderId="
                        + orderId
        );
    }

    // =========================================================
    // VIEW ORDER
    // =========================================================

    private void viewOrder(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer sessionUserId)
            throws ServletException, IOException {

        if (!isValidUserId(sessionUserId)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        String orderIdParameter =
                clean(
                        request.getParameter("orderId")
                );

        if (orderIdParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID is required."
            );

            return;
        }

        int orderId =
                Integer.parseInt(
                        orderIdParameter
                );

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found."
            );

            return;
        }

        if (order.getUserId() != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to view this order."
            );

            return;
        }


/* Get all items belonging to this order */
List<OrderItem> orderItems =
        orderDAO.getOrderItems(orderId);

/* Pass the ordered products to order.jsp */
java.util.Map<Integer, Product> orderedProducts =
        new java.util.HashMap<Integer, Product>();

if (orderItems != null) {
    for (OrderItem item : orderItems) {
        Product product =
                productDAO.getProductById(
                        item.getProductId()
                );

        if (product != null) {
            orderedProducts.put(
                    item.getProductId(),
                    product
            );
        }
    }
}

request.setAttribute("order", order);
request.setAttribute("orderItems", orderItems);
request.setAttribute("orderedProducts", orderedProducts);

request.getRequestDispatcher("/order.jsp")
       .forward(request, response);

    }

    // =========================================================
    // VIEW ORDER ITEMS
    // =========================================================

    private void viewOrderItems(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer sessionUserId)
            throws ServletException, IOException {

        if (!isValidUserId(sessionUserId)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        String orderIdParameter =
                clean(
                        request.getParameter("orderId")
                );

        if (orderIdParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID is required."
            );

            return;
        }

        int orderId =
                Integer.parseInt(
                        orderIdParameter
                );

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found."
            );

            return;
        }

        if (order.getUserId() != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to view these order items."
            );

            return;
        }

        List<OrderItem> orderItems =
                orderDAO.getOrderItems(
                        orderId
                );

        request.setAttribute(
                "order",
                order
        );

        request.setAttribute(
                "orderItems",
                orderItems
        );

        request.setAttribute(
                "orderId",
                orderId
        );

        request.getRequestDispatcher(
                "/order-items.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // LIST ORDERS
    // =========================================================

    private void listOrders(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer sessionUserId)
            throws ServletException, IOException {

        if (!isValidUserId(sessionUserId)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        String userIdParameter =
                clean(
                        request.getParameter("userId")
                );

        int userId;

        if (userIdParameter.isEmpty()) {

            userId =
                    sessionUserId;

        } else {

            userId =
                    Integer.parseInt(
                            userIdParameter
                    );

            if (userId != sessionUserId) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You are not authorized to view these orders."
                );

                return;
            }
        }

        listOrdersForUser(
                request,
                response,
                userId
        );
    }

    // =========================================================
    // LIST ORDERS FOR CURRENT USER
    // =========================================================

    private void listOrdersForUser(
            HttpServletRequest request,
            HttpServletResponse response,
            int userId)
            throws ServletException, IOException {

        List<Order> orders =
                orderDAO.getOrdersByUserId(
                        userId
                );

        if (orders == null) {
            orders = Collections.emptyList();
        }

        request.setAttribute(
                "orders",
                orders
        );

        request.setAttribute(
                "userId",
                userId
        );

        request.getRequestDispatcher(
                "/orders.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // UPDATE ORDER STATUS
    // =========================================================

    private void updateOrderStatus(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer sessionUserId)
            throws IOException {

        String orderIdParameter =
                clean(
                        request.getParameter("orderId")
                );

        String orderStatus =
                clean(
                        request.getParameter("orderStatus")
                );

        if (orderIdParameter.isEmpty()
                || orderStatus.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID and order status are required."
            );

            return;
        }

        int orderId =
                Integer.parseInt(
                        orderIdParameter
                );

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found."
            );

            return;
        }

        if (!isValidUserId(sessionUserId)
                || order.getUserId() != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to update this order."
            );

            return;
        }

        boolean updated =
                orderDAO.updateOrderStatus(
                        orderId,
                        orderStatus
                );

        if (!updated) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to update order status."
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/orders?action=view&orderId="
                        + orderId
        );
    }

    // =========================================================
    // CANCEL ORDER
    // =========================================================

    private void cancelOrder(
            HttpServletRequest request,
            HttpServletResponse response,
            Integer sessionUserId)
            throws IOException {

        String orderIdParameter =
                clean(
                        request.getParameter("orderId")
                );

        if (orderIdParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Order ID is required."
            );

            return;
        }

        int orderId =
                Integer.parseInt(
                        orderIdParameter
                );

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Order not found."
            );

            return;
        }

        if (!isValidUserId(sessionUserId)
                || order.getUserId() != sessionUserId) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "You are not authorized to cancel this order."
            );

            return;
        }

        String currentStatus =
                clean(
                        order.getOrderStatus()
                );

        if ("CANCELLED".equalsIgnoreCase(
                currentStatus)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/orders?action=view&orderId="
                            + orderId
            );

            return;
        }

        if ("DELIVERED".equalsIgnoreCase(
                currentStatus)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A delivered order cannot be cancelled."
            );

            return;
        }

        boolean cancelled =
                orderDAO.cancelOrder(
                        orderId
                );

        if (!cancelled) {

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to cancel order."
            );

            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/orders?action=view&orderId="
                        + orderId
        );
    }

    // =========================================================
    // GET USER ID FROM SESSION
    // =========================================================

    private Integer getUserIdFromSession(
            HttpSession session) {

        if (session == null) {
            return null;
        }

        Object userIdObject =
                session.getAttribute(
                        "userId"
                );

        if (userIdObject instanceof Integer) {

            Integer userId =
                    (Integer) userIdObject;

            if (userId > 0) {
                return userId;
            }
        }

        if (userIdObject instanceof String) {

            try {

                int userId =
                        Integer.parseInt(
                                userIdObject.toString().trim()
                        );

                if (userId > 0) {
                    return userId;
                }

            } catch (NumberFormatException e) {

                System.out.println(
                        "Invalid userId session value."
                );
            }
        }

        Object userObject =
                session.getAttribute(
                        "user"
                );

        if (userObject instanceof User) {

            User user =
                    (User) userObject;

            int userId =
                    user.getUserId();

            if (userId > 0) {
                session.setAttribute(
                        "userId",
                        userId
                );

                return userId;
            }
        }

        return null;
    }

    // =========================================================
    // VALID USER ID
    // =========================================================

    private boolean isValidUserId(
            Integer userId) {

        return userId != null
                && userId > 0;
    }

    // =========================================================
    // CLEAN INPUT
    // =========================================================

    private String clean(
            String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}