package easyBuy.controller;

import java.io.IOException;
import java.math.BigDecimal;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.OrderDAO;
import easyBuy.dao.OrderDAOImpl;
import easyBuy.dao.PaymentDAO;
import easyBuy.dao.PaymentDAOImpl;
import easyBuy.model.Order;
import easyBuy.model.Payment;

@WebServlet("/order-confirmation")
public class OrderConfirmationController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;

    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        orderDAO = new OrderDAOImpl();
        paymentDAO = new PaymentDAOImpl();

        System.out.println("=================================");
        System.out.println(
                "ORDER CONFIRMATION CONTROLLER INITIALIZED"
        );
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
        System.out.println(
                "ORDER CONFIRMATION CONTROLLER - doGet()"
        );
        System.out.println("=================================");

        HttpSession session =
                request.getSession(false);

        // ---------------------------------------------------------
        // LOGIN CHECK
        // ---------------------------------------------------------

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        Integer userId =
                getUserIdFromSession(
                        session
                );

        if (userId == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        // ---------------------------------------------------------
        // ORDER ID
        // ---------------------------------------------------------

        int orderId =
                getOrderId(
                        request,
                        session
                );

        if (orderId <= 0) {

            request.setAttribute(
                    "confirmationError",
                    "Order information is unavailable."
            );

            request.getRequestDispatcher(
                    "/order-confirmation.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        System.out.println(
                "Confirmation Order ID: "
                        + orderId
        );

        // ---------------------------------------------------------
        // LOAD ORDER
        // ---------------------------------------------------------

        Order order =
                orderDAO.getOrderById(
                        orderId
                );

        if (order == null) {

            request.setAttribute(
                    "confirmationError",
                    "The requested order could not be found."
            );

            request.getRequestDispatcher(
                    "/order-confirmation.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // ---------------------------------------------------------
        // ORDER OWNERSHIP CHECK
        // ---------------------------------------------------------

        if (order.getUserId() != userId) {

            request.setAttribute(
                    "confirmationError",
                    "You are not authorized to view this order."
            );

            request.getRequestDispatcher(
                    "/order-confirmation.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // ---------------------------------------------------------
        // LOAD PAYMENT
        // ---------------------------------------------------------

        Payment payment =
                paymentDAO.getPaymentByOrderId(
                        orderId
                );

        // ---------------------------------------------------------
        // REFRESH ORDER SESSION INFORMATION
        // ---------------------------------------------------------

        session.setAttribute(
                "orderId",
                String.valueOf(
                        order.getOrderId()
                )
        );

        session.setAttribute(
                "orderStatus",
                safeString(
                        order.getOrderStatus(),
                        "CONFIRMED"
                )
        );

        session.setAttribute(
                "orderTotal",
                BigDecimal.valueOf(
                        order.getTotalAmount()
                )
        );

        // ---------------------------------------------------------
        // CLEAR OLD PAYMENT VALUES
        //
        // Prevents a previous order's payment details from being
        // displayed if the current order has no payment row.
        // ---------------------------------------------------------

        session.removeAttribute(
                "paymentMethod"
        );

        session.removeAttribute(
                "paymentStatus"
        );

        session.removeAttribute(
                "paymentTransactionId"
        );

        // ---------------------------------------------------------
        // REFRESH PAYMENT INFORMATION
        // ---------------------------------------------------------

        if (payment != null) {

            session.setAttribute(
                    "paymentMethod",
                    safeString(
                            payment.getPaymentMethod(),
                            ""
                    )
            );

            session.setAttribute(
                    "paymentStatus",
                    safeString(
                            payment.getPaymentStatus(),
                            ""
                    )
            );

            session.setAttribute(
                    "paymentTransactionId",
                    safeString(
                            payment.getTransactionId(),
                            ""
                    )
            );

        }

        /*
         * PaymentDAOImpl currently does not map paymentDate.
         *
         * Therefore we intentionally leave the existing
         * session paymentDate untouched. PaymentController
         * supplies it when the payment is processed.
         */

        // ---------------------------------------------------------
        // REQUEST ATTRIBUTES
        // ---------------------------------------------------------

        request.setAttribute(
                "order",
                order
        );

        request.setAttribute(
                "payment",
                payment
        );

        request.setAttribute(
                "orderId",
                order.getOrderId()
        );

        request.setAttribute(
                "orderTotal",
                BigDecimal.valueOf(
                        order.getTotalAmount()
                )
        );

        if (payment != null) {

            request.setAttribute(
                    "paymentMethod",
                    safeString(
                            payment.getPaymentMethod(),
                            ""
                    )
            );

            request.setAttribute(
                    "paymentStatus",
                    safeString(
                            payment.getPaymentStatus(),
                            ""
                    )
            );

            request.setAttribute(
                    "transactionId",
                    safeString(
                            payment.getTransactionId(),
                            ""
                    )
            );
        }

        // ---------------------------------------------------------
        // FORWARD TO JSP
        // ---------------------------------------------------------

        request.getRequestDispatcher(
                "/order-confirmation.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        /*
         * Order confirmation is display-only.
         *
         * If a POST reaches this controller, handle it exactly
         * like GET.
         */

        doGet(
                request,
                response
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
                                userIdObject
                                        .toString()
                                        .trim()
                        );

                if (userId > 0) {

                    session.setAttribute(
                            "userId",
                            userId
                    );

                    return userId;
                }

            } catch (NumberFormatException e) {

                System.out.println(
                        "Invalid userId session value."
                );
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

        // ---------------------------------------------------------
        // FIRST: REQUEST PARAMETER
        // ---------------------------------------------------------

        String orderIdParameter =
                request.getParameter(
                        "orderId"
                );

        if (orderIdParameter != null
                && !orderIdParameter.trim().isEmpty()) {

            try {

                int orderId =
                        Integer.parseInt(
                                orderIdParameter.trim()
                        );

                if (orderId > 0) {
                    return orderId;
                }

            } catch (NumberFormatException e) {

                System.out.println(
                        "Invalid orderId request parameter."
                );
            }
        }

        // ---------------------------------------------------------
        // SECOND: SESSION ORDER ID
        // ---------------------------------------------------------

        if (session != null) {

            Object orderIdObject =
                    session.getAttribute(
                            "orderId"
                    );

            if (orderIdObject instanceof Integer) {

                int orderId =
                        (Integer) orderIdObject;

                if (orderId > 0) {
                    return orderId;
                }
            }

            if (orderIdObject instanceof String) {

                try {

                    int orderId =
                            Integer.parseInt(
                                    orderIdObject
                                            .toString()
                                            .trim()
                            );

                    if (orderId > 0) {
                        return orderId;
                    }

                } catch (NumberFormatException e) {

                    System.out.println(
                            "Invalid orderId session value."
                    );
                }
            }

            // -----------------------------------------------------
            // THIRD: CHECKOUT ORDER ID
            // -----------------------------------------------------

            Object checkoutOrderIdObject =
                    session.getAttribute(
                            "checkoutOrderId"
                    );

            if (checkoutOrderIdObject instanceof Integer) {

                int orderId =
                        (Integer) checkoutOrderIdObject;

                if (orderId > 0) {
                    return orderId;
                }
            }

            if (checkoutOrderIdObject instanceof String) {

                try {

                    int orderId =
                            Integer.parseInt(
                                    checkoutOrderIdObject
                                            .toString()
                                            .trim()
                            );

                    if (orderId > 0) {
                        return orderId;
                    }

                } catch (NumberFormatException e) {

                    System.out.println(
                            "Invalid checkoutOrderId session value."
                    );
                }
            }
        }

        return -1;
    }

    // =========================================================
    // SAFE STRING
    // =========================================================

    private String safeString(
            String value,
            String defaultValue) {

        if (value == null
                || value.trim().isEmpty()) {

            return defaultValue;
        }

        return value.trim();
    }
}