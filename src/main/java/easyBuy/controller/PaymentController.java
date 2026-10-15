
package easyBuy.controller;

import java.io.IOException;
import java.time.LocalDateTime;

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
import easyBuy.dao.PaymentDAO;
import easyBuy.dao.PaymentDAOImpl;
import easyBuy.model.Cart;
import easyBuy.model.Order;
import easyBuy.model.Payment;
import easyBuy.model.User;

@WebServlet("/payment")
public class PaymentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaymentDAO paymentDAO;
    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        paymentDAO = new PaymentDAOImpl();
        orderDAO = new OrderDAOImpl();
        cartDAO = new CartDAOImpl();

        System.out.println("=================================");
        System.out.println("PAYMENT CONTROLLER INITIALIZED");
        System.out.println("DEMO PAYMENT MODE ENABLED");
        System.out.println("=================================");
    }

    // =========================================================
    // GET
    //
    // Loads the payment page for an existing order.
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Integer userId = getUserIdFromSession(session);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        int orderId = getOrderId(request, session);

        if (orderId <= 0) {
            request.setAttribute(
                    "errorMessage",
                    "Order information is unavailable.");

            request.getRequestDispatcher("/payment.jsp")
                    .forward(request, response);
            return;
        }

        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            request.setAttribute(
                    "errorMessage",
                    "The requested order could not be found.");

            request.getRequestDispatcher("/payment.jsp")
                    .forward(request, response);
            return;
        }

        // Ensure the logged-in user owns this order.
        if (order.getUserId() != userId) {
            request.setAttribute(
                    "errorMessage",
                    "You are not authorized to access this order.");

            request.getRequestDispatcher("/payment.jsp")
                    .forward(request, response);
            return;
        }

        // Keep the existing session attributes for compatibility.
        session.setAttribute(
                "orderId",
                String.valueOf(order.getOrderId()));

        session.setAttribute(
                "checkoutOrderId",
                order.getOrderId());

        session.setAttribute(
                "orderTotal",
                java.math.BigDecimal.valueOf(order.getTotalAmount()));

        session.setAttribute(
                "checkoutOrderTotal",
                java.math.BigDecimal.valueOf(order.getTotalAmount()));

        session.setAttribute(
                "orderStatus",
                safeString(order.getOrderStatus(), "PENDING"));

        // Load the payment already saved for this order.
        Payment payment = paymentDAO.getPaymentByOrderId(orderId);

        if (payment != null) {
            request.setAttribute(
                    "paymentMethod",
                    safeString(payment.getPaymentMethod(), ""));

            request.setAttribute(
                    "paymentStatus",
                    safeString(payment.getPaymentStatus(), ""));

            request.setAttribute(
                    "transactionId",
                    safeString(payment.getTransactionId(), ""));
        } else {
            request.setAttribute("paymentMethod", "");
            request.setAttribute("paymentStatus", "");
            request.setAttribute("transactionId", "");
        }

        // Load delivery/customer details from the session.
        String[] sessionAttributes = {
            "receiverName",
            "primaryMobile",
            "alternateMobile",
            "checkoutEmail",
            "checkoutAddress",
            "houseFlatNumber",
            "buildingName",
            "street",
            "area",
            "landmark",
            "city"
        };

        for (String attributeName : sessionAttributes) {
            setRequestAttributeFromSession(
                    request, session, attributeName);
        }

        // Use the logged-in user's details as fallbacks.
        Object userObject = session.getAttribute("user");

        if (userObject instanceof User) {
            User user = (User) userObject;

            if (isEmpty(request.getAttribute("receiverName"))) {
                request.setAttribute(
                        "receiverName",
                        safeString(user.getName(), ""));
            }

            if (isEmpty(request.getAttribute("primaryMobile"))) {
                request.setAttribute(
                        "primaryMobile",
                        safeString(user.getPhone(), ""));
            }

            if (isEmpty(request.getAttribute("checkoutEmail"))) {
                request.setAttribute(
                        "checkoutEmail",
                        safeString(user.getEmail(), ""));
            }
        }

        // Display and then remove any saved error message.
        Object errorObject =
                session.getAttribute("paymentErrorMessage");

        if (errorObject != null) {
            request.setAttribute(
                    "errorMessage",
                    errorObject.toString());

            session.removeAttribute("paymentErrorMessage");
        }

        request.setAttribute("order", order);
        request.setAttribute("orderId", order.getOrderId());
        request.setAttribute(
                "orderTotal",
                java.math.BigDecimal.valueOf(order.getTotalAmount()));

        request.getRequestDispatcher("/payment.jsp")
                .forward(request, response);
    }

    // =========================================================
    // POST
    //
    // Saves a simulated payment or a COD selection.
    // No real payment gateway is used.
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        Integer userId = getUserIdFromSession(session);

        if (userId == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return;
        }

        int orderId = getOrderId(request, session);

        if (orderId <= 0) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "Order information is unavailable.");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "The requested order could not be found.");
            return;
        }

        // Do not allow a user to pay for another user's order.
        if (order.getUserId() != userId) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "You are not authorized to make payment for this order.");
            return;
        }

        String paymentMethod =
                trim(request.getParameter("paymentMethod"));

        // The browser does not provide a trusted transaction ID.
        // Generate the demo reference on the server.
        String transactionId = "";

        if (!isValidPaymentMethod(paymentMethod)) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "Please select a valid payment method.");
            return;
        }

        String paymentStatus;

        if ("Cash on Delivery".equalsIgnoreCase(paymentMethod)) {

            paymentMethod = "Cash on Delivery";
            paymentStatus = "PENDING";
            transactionId = "";

        } else {

            if ("UPI".equalsIgnoreCase(paymentMethod)) {
                paymentMethod = "UPI";
            } else {
                paymentMethod = "Card";
            }

            /*
             * DEMO ONLY:
             * This reference represents a simulated submission.
             * It is not issued by a bank or payment gateway.
             */
            transactionId = generateDemoTransactionId();
            paymentStatus = "SUCCESS";
        }

        // ---------------------------------------------------------
        // SAVE OR UPDATE THE EXISTING PAYMENT
        // ---------------------------------------------------------

        Payment existingPayment =
                paymentDAO.getPaymentByOrderId(orderId);

        boolean paymentSaved;

        if (existingPayment == null) {

            Payment payment = new Payment();

            payment.setOrderId(orderId);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentStatus(paymentStatus);
            payment.setTransactionId(transactionId);

            paymentSaved = paymentDAO.createPayment(payment);

        } else {

            /*
             * The current PaymentDAO contract has no method to update
             * payment method. Keep using the existing DAO methods.
             */
            boolean statusUpdated =
                    paymentDAO.updatePaymentStatus(
                            existingPayment.getPaymentId(),
                            paymentStatus);

            boolean transactionUpdated =
                    paymentDAO.updateTransactionId(
                            existingPayment.getPaymentId(),
                            transactionId);

            paymentSaved = statusUpdated && transactionUpdated;
        }

        if (!paymentSaved) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "Unable to save payment information. Please try again.");
            return;
        }

        // ---------------------------------------------------------
        // UPDATE ORDER STATUS
        // ---------------------------------------------------------

        /*
         * Preserve the existing demo workflow:
         * - simulated UPI/Card: order is confirmed
         * - COD: order is also confirmed, but payment remains PENDING
         *
         * This is a demonstration flow, not a production payment flow.
         */
        boolean orderUpdated =
                orderDAO.updateOrderStatus(orderId, "CONFIRMED");

        if (!orderUpdated) {
            showPaymentError(
                    request,
                    response,
                    session,
                    "Payment information was saved, but the order status could not be updated.");
            return;
        }

        // ---------------------------------------------------------
        // CLEAR CART AFTER THE DATABASE UPDATES SUCCEED
        // ---------------------------------------------------------

        Cart cart = cartDAO.getCartByUserId(userId);

        if (cart != null) {
            boolean cartCleared = cartDAO.clearCart(cart.getCartId());

            if (!cartCleared) {
                System.out.println(
                        "Cart was already empty or could not be cleared "
                                + "for user " + userId);
            }
        }

        // ---------------------------------------------------------
        // SAVE CONFIRMATION DETAILS IN THE SESSION
        // ---------------------------------------------------------

        session.setAttribute("orderId", String.valueOf(orderId));
        session.setAttribute("checkoutOrderId", orderId);
        session.setAttribute("orderStatus", "CONFIRMED");

        session.setAttribute(
                "orderTotal",
                java.math.BigDecimal.valueOf(order.getTotalAmount()));

        session.setAttribute(
                "checkoutOrderTotal",
                java.math.BigDecimal.valueOf(order.getTotalAmount()));

        session.setAttribute("paymentMethod", paymentMethod);
        session.setAttribute("paymentStatus", paymentStatus);
        session.setAttribute("paymentTransactionId", transactionId);

        // The existing DAO does not persist paymentDate.
        session.setAttribute("paymentDate", LocalDateTime.now());

        session.removeAttribute("paymentErrorMessage");

        // Navigate to the existing confirmation controller.
        response.sendRedirect(
                request.getContextPath()
                        + "/order-confirmation?orderId="
                        + orderId);
    }

    // =========================================================
    // SHOW PAYMENT ERROR
    // =========================================================

    private void showPaymentError(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            String message)
            throws IOException {

        session.setAttribute("paymentErrorMessage", message);

        int orderId = getOrderId(request, session);

        if (orderId > 0) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/payment?orderId="
                            + orderId);
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/payment");
        }
    }

    // =========================================================
    // GET USER ID FROM SESSION
    // =========================================================

    private Integer getUserIdFromSession(HttpSession session) {

        if (session == null) {
            return null;
        }

        Object userIdObject = session.getAttribute("userId");

        if (userIdObject instanceof Integer) {
            Integer userId = (Integer) userIdObject;

            if (userId > 0) {
                return userId;
            }
        }

        if (userIdObject instanceof String) {
            try {
                int userId = Integer.parseInt(
                        userIdObject.toString().trim());

                if (userId > 0) {
                    session.setAttribute("userId", userId);
                    return userId;
                }

            } catch (NumberFormatException e) {
                System.out.println("Invalid userId session value.");
            }
        }

        // Fall back to the User object in the session.
        Object userObject = session.getAttribute("user");

        if (userObject instanceof User) {
            User user = (User) userObject;
            int userId = user.getUserId();

            if (userId > 0) {
                session.setAttribute("userId", userId);
                return userId;
            }
        }

        return null;
    }

    // =========================================================
    // GET ORDER ID
    // =========================================================

    private int getOrderId(
            HttpServletRequest request,
            HttpSession session) {

        String orderIdParameter = request.getParameter("orderId");

        if (orderIdParameter != null
                && !orderIdParameter.trim().isEmpty()) {

            try {
                int orderId = Integer.parseInt(orderIdParameter.trim());

                if (orderId > 0) {
                    return orderId;
                }

            } catch (NumberFormatException e) {
                System.out.println(
                        "Invalid orderId request parameter.");
            }
        }

        if (session == null) {
            return -1;
        }

        Object orderIdObject = session.getAttribute("orderId");

        if (orderIdObject != null) {
            try {
                int orderId = Integer.parseInt(
                        orderIdObject.toString().trim());

                if (orderId > 0) {
                    return orderId;
                }

            } catch (NumberFormatException e) {
                System.out.println("Invalid orderId session value.");
            }
        }

        Object checkoutOrderIdObject =
                session.getAttribute("checkoutOrderId");

        if (checkoutOrderIdObject != null) {
            try {
                int orderId = Integer.parseInt(
                        checkoutOrderIdObject.toString().trim());

                if (orderId > 0) {
                    return orderId;
                }

            } catch (NumberFormatException e) {
                System.out.println(
                        "Invalid checkoutOrderId session value.");
            }
        }

        return -1;
    }

    // =========================================================
    // VALID PAYMENT METHOD
    // =========================================================

    private boolean isValidPaymentMethod(String paymentMethod) {

        return "UPI".equalsIgnoreCase(paymentMethod)
                || "Card".equalsIgnoreCase(paymentMethod)
                || "Cash on Delivery".equalsIgnoreCase(paymentMethod);
    }

    // =========================================================
    // GENERATE DEMO TRANSACTION REFERENCE
    // =========================================================

    private String generateDemoTransactionId() {

        return "EB-DEMO-TXN-" + System.currentTimeMillis();
    }

    // =========================================================
    // SET REQUEST ATTRIBUTE FROM SESSION
    // =========================================================

    private void setRequestAttributeFromSession(
            HttpServletRequest request,
            HttpSession session,
            String attributeName) {

        if (session == null) {
            return;
        }

        Object value = session.getAttribute(attributeName);

        if (value != null) {
            request.setAttribute(attributeName, value.toString());
        }
    }

    // =========================================================
    // CHECK EMPTY VALUE
    // =========================================================

    private boolean isEmpty(Object value) {

        return value == null || value.toString().trim().isEmpty();
    }

    // =========================================================
    // SAFE STRING
    // =========================================================

    private String safeString(
            String value,
            String defaultValue) {

        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }

    // =========================================================
    // TRIM STRING
    // =========================================================

    private String trim(String value) {

        return value == null ? "" : value.trim();
    }
}
