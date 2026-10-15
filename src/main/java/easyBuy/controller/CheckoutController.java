package easyBuy.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.CartDAO;
import easyBuy.dao.CartDAOImpl;
import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Cart;
import easyBuy.model.CartItem;
import easyBuy.model.Product;
import easyBuy.model.User;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        cartDAO = new CartDAOImpl();
        productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("CHECKOUT CONTROLLER INITIALIZED");
        System.out.println("=================================");
    }

    // =========================================================
    // GET
    //
    // Loads:
    // - logged-in customer information
    // - cart
    // - cart items
    // - products
    // - cart total
    // - previously entered checkout information
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("CHECKOUT CONTROLLER - doGet()");
        System.out.println("=================================");

        HttpSession session =
                request.getSession(false);

        Integer userId =
                getUserIdFromSession(session);

        // ---------------------------------------------------------
        // LOGIN CHECK
        // ---------------------------------------------------------

        if (!isValidUserId(userId)) {

            System.out.println(
                    "No logged-in user found for checkout."
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        // ---------------------------------------------------------
        // CUSTOMER INFORMATION
        // ---------------------------------------------------------

        String userName =
                getSessionString(
                        session,
                        "userName"
                );

        String userEmail =
                getSessionString(
                        session,
                        "userEmail"
                );

        String userPhone =
                getSessionString(
                        session,
                        "userPhone"
                );

        // ---------------------------------------------------------
        // FALLBACK TO USER OBJECT
        // ---------------------------------------------------------

        Object userObject =
                session.getAttribute("user");

        if (userObject instanceof User) {

            User user =
                    (User) userObject;

            if (userName.isEmpty()) {

                userName =
                        safeString(
                                user.getName()
                        );
            }

            if (userEmail.isEmpty()) {

                userEmail =
                        safeString(
                                user.getEmail()
                        );
            }

            if (userPhone.isEmpty()) {

                userPhone =
                        safeString(
                                user.getPhone()
                        );
            }
        }

        // ---------------------------------------------------------
        // SEND CUSTOMER INFORMATION TO JSP
        // ---------------------------------------------------------

        request.setAttribute(
                "userId",
                userId
        );

        request.setAttribute(
                "userName",
                userName
        );

        request.setAttribute(
                "userEmail",
                userEmail
        );

        request.setAttribute(
                "userPhone",
                userPhone
        );

        // ---------------------------------------------------------
        // PREVIOUS CHECKOUT INFORMATION
        //
        // IMPORTANT:
        // checkoutEmail is used consistently because POST stores
        // the entered email under checkoutEmail.
        // ---------------------------------------------------------

        setCheckoutRequestAttribute(
                request,
                session,
                "receiverName",
                userName
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "primaryMobile",
                userPhone
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "alternateMobile",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "checkoutEmail",
                userEmail
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "houseFlatNumber",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "buildingName",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "street",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "area",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "landmark",
                ""
        );

        setCheckoutRequestAttribute(
                request,
                session,
                "city",
                ""
        );

        // ---------------------------------------------------------
        // CART
        // ---------------------------------------------------------

        Cart cart =
                cartDAO.getCartByUserId(
                        userId
                );

        List<CartItem> cartItems;

        if (cart != null) {

            cartItems =
                    cartDAO.getCartItems(
                            cart.getCartId()
                    );

        } else {

            cartItems =
                    Collections.emptyList();
        }

        if (cartItems == null) {

            cartItems =
                    Collections.emptyList();
        }

        // ---------------------------------------------------------
        // EMPTY CART
        // ---------------------------------------------------------

        if (cartItems.isEmpty()) {

            System.out.println(
                    "Checkout blocked: cart is empty."
            );

            request.setAttribute(
                    "checkoutErrorMessage",
                    "Your cart is empty. Please add products before checkout."
            );

            request.setAttribute(
                    "cart",
                    cart
            );

            request.setAttribute(
                    "cartItems",
                    Collections.emptyList()
            );

            request.setAttribute(
                    "products",
                    new HashMap<Integer, Product>()
            );

            request.setAttribute(
                    "cartTotal",
                    BigDecimal.ZERO
            );

            request.setAttribute(
                    "checkoutAddress",
                    getSessionString(
                            session,
                            "checkoutAddress"
                    )
            );

            request.getRequestDispatcher(
                    "/checkout.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // ---------------------------------------------------------
        // PRODUCT MAP + CART TOTAL
        // ---------------------------------------------------------

        Map<Integer, Product> products =
                new HashMap<Integer, Product>();

        BigDecimal cartTotal =
                BigDecimal.ZERO;

        boolean invalidProductFound =
                false;

        for (CartItem cartItem : cartItems) {

            if (cartItem == null) {

                invalidProductFound =
                        true;

                break;
            }

            if (cartItem.getQuantity() <= 0) {

                invalidProductFound =
                        true;

                break;
            }

            Product product =
                    productDAO.getProductById(
                            cartItem.getProductId()
                    );

            if (product == null) {

                invalidProductFound =
                        true;

                break;
            }

            products.put(
                    product.getProductId(),
                    product
            );

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

            cartTotal =
                    cartTotal.add(subtotal);

            System.out.println(
                    "Checkout Item: "
                            + product.getProductName()
                            + " | Quantity: "
                            + cartItem.getQuantity()
                            + " | Subtotal: "
                            + subtotal
            );
        }

        // ---------------------------------------------------------
        // INVALID CART PRODUCT / QUANTITY
        // ---------------------------------------------------------

        if (invalidProductFound) {

            request.setAttribute(
                    "checkoutErrorMessage",
                    "One of the products in your cart is no longer available."
            );

            request.setAttribute(
                    "cart",
                    cart
            );

            request.setAttribute(
                    "cartItems",
                    cartItems
            );

            request.setAttribute(
                    "products",
                    products
            );

            request.setAttribute(
                    "cartTotal",
                    cartTotal
            );

            request.setAttribute(
                    "checkoutAddress",
                    getSessionString(
                            session,
                            "checkoutAddress"
                    )
            );

            request.getRequestDispatcher(
                    "/checkout.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // ---------------------------------------------------------
        // TOTAL VALIDATION
        // ---------------------------------------------------------

        if (cartTotal.compareTo(
                BigDecimal.ZERO
        ) <= 0) {

            request.setAttribute(
                    "checkoutErrorMessage",
                    "Your order total must be greater than zero."
            );

            request.setAttribute(
                    "cart",
                    cart
            );

            request.setAttribute(
                    "cartItems",
                    cartItems
            );

            request.setAttribute(
                    "products",
                    products
            );

            request.setAttribute(
                    "cartTotal",
                    cartTotal
            );

            request.setAttribute(
                    "checkoutAddress",
                    getSessionString(
                            session,
                            "checkoutAddress"
                    )
            );

            request.getRequestDispatcher(
                    "/checkout.jsp"
            ).forward(
                    request,
                    response
            );

            return;
        }

        // ---------------------------------------------------------
        // SEND CART DATA TO JSP
        // ---------------------------------------------------------

        request.setAttribute(
                "cart",
                cart
        );

        request.setAttribute(
                "cartItems",
                cartItems
        );

        request.setAttribute(
                "products",
                products
        );

        request.setAttribute(
                "cartTotal",
                cartTotal
        );

        // ---------------------------------------------------------
        // EXISTING COMBINED ADDRESS
        // ---------------------------------------------------------

        String checkoutAddress =
                getSessionString(
                        session,
                        "checkoutAddress"
                );

        request.setAttribute(
                "checkoutAddress",
                checkoutAddress
        );

        // ---------------------------------------------------------
        // ERROR MESSAGE FROM SESSION
        // ---------------------------------------------------------

        Object sessionError =
                session.getAttribute(
                        "checkoutErrorMessage"
                );

        if (sessionError != null) {

            request.setAttribute(
                    "checkoutErrorMessage",
                    sessionError.toString()
            );

            session.removeAttribute(
                    "checkoutErrorMessage"
            );
        }

        // ---------------------------------------------------------
        // OPEN CHECKOUT JSP
        // ---------------------------------------------------------

        request.getRequestDispatcher(
                "/checkout.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // POST
    //
    // Validates checkout information and then forwards to:
    //
    // /orders?action=checkout
    //
    // OrderController creates the actual order.
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("CHECKOUT CONTROLLER - doPost()");
        System.out.println("=================================");

        HttpSession session =
                request.getSession(false);

        Integer userId =
                getUserIdFromSession(session);

        // ---------------------------------------------------------
        // LOGIN CHECK
        // ---------------------------------------------------------

        if (!isValidUserId(userId)) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login"
            );

            return;
        }

        // =========================================================
        // READ CUSTOMER INFORMATION
        // =========================================================

        String receiverName =
                trim(
                        request.getParameter(
                                "receiverName"
                        )
                );

        String primaryMobile =
                trim(
                        request.getParameter(
                                "primaryMobile"
                        )
                );

        String alternateMobile =
                trim(
                        request.getParameter(
                                "alternateMobile"
                        )
                );

        String email =
                trim(
                        request.getParameter(
                                "email"
                        )
                );

        // =========================================================
        // READ DELIVERY ADDRESS
        // =========================================================

        String houseFlatNumber =
                trim(
                        request.getParameter(
                                "houseFlatNumber"
                        )
                );

        String buildingName =
                trim(
                        request.getParameter(
                                "buildingName"
                        )
                );

        String street =
                trim(
                        request.getParameter(
                                "street"
                        )
                );

        String area =
                trim(
                        request.getParameter(
                                "area"
                        )
                );

        String landmark =
                trim(
                        request.getParameter(
                                "landmark"
                        )
                );

        String city =
                trim(
                        request.getParameter(
                                "city"
                        )
                );

        // =========================================================
        // SAVE FORM VALUES
        // =========================================================

        session.setAttribute(
                "receiverName",
                receiverName
        );

        session.setAttribute(
                "primaryMobile",
                primaryMobile
        );

        session.setAttribute(
                "alternateMobile",
                alternateMobile
        );

        session.setAttribute(
                "checkoutEmail",
                email
        );

        session.setAttribute(
                "houseFlatNumber",
                houseFlatNumber
        );

        session.setAttribute(
                "buildingName",
                buildingName
        );

        session.setAttribute(
                "street",
                street
        );

        session.setAttribute(
                "area",
                area
        );

        session.setAttribute(
                "landmark",
                landmark
        );

        session.setAttribute(
                "city",
                city
        );

        // =========================================================
        // VALIDATION
        // =========================================================

        if (receiverName.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the full name of the receiver."
            );

            return;
        }

        if (primaryMobile.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the primary mobile number."
            );

            return;
        }

        if (email.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the email address."
            );

            return;
        }

        if (houseFlatNumber.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the house or flat number."
            );

            return;
        }

        if (street.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the street."
            );

            return;
        }

        if (area.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the area or locality."
            );

            return;
        }

        if (city.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Please enter the city."
            );

            return;
        }

        // =========================================================
        // BUILD COMPLETE DELIVERY ADDRESS
        // =========================================================

        StringBuilder addressBuilder =
                new StringBuilder();

        appendAddressPart(
                addressBuilder,
                houseFlatNumber
        );

        appendAddressPart(
                addressBuilder,
                buildingName
        );

        appendAddressPart(
                addressBuilder,
                street
        );

        appendAddressPart(
                addressBuilder,
                area
        );

        appendAddressPart(
                addressBuilder,
                landmark
        );

        appendAddressPart(
                addressBuilder,
                city
        );

        String checkoutAddress =
                addressBuilder.toString();

        // =========================================================
        // SAVE CHECKOUT-SPECIFIC INFORMATION
        // =========================================================

        session.setAttribute(
                "checkoutReceiverName",
                receiverName
        );

        session.setAttribute(
                "checkoutPrimaryMobile",
                primaryMobile
        );

        session.setAttribute(
                "checkoutAlternateMobile",
                alternateMobile
        );

        session.setAttribute(
                "checkoutEmail",
                email
        );

        session.setAttribute(
                "checkoutAddress",
                checkoutAddress
        );

        // =========================================================
        // DEBUG
        // =========================================================

        System.out.println(
                "Checkout Receiver Name: "
                        + receiverName
        );

        System.out.println(
                "Checkout Primary Mobile: "
                        + primaryMobile
        );

        System.out.println(
                "Checkout Alternate Mobile: "
                        + alternateMobile
        );

        System.out.println(
                "Checkout Email: "
                        + email
        );

        System.out.println(
                "Checkout Address: "
                        + checkoutAddress
        );

        // =========================================================
        // VERIFY CART STILL EXISTS
        // =========================================================

        Cart cart =
                cartDAO.getCartByUserId(
                        userId
                );

        if (cart == null) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Your cart could not be found. Please try again."
            );

            return;
        }

        List<CartItem> cartItems =
                cartDAO.getCartItems(
                        cart.getCartId()
                );

        if (cartItems == null
                || cartItems.isEmpty()) {

            showCheckoutError(
                    request,
                    response,
                    session,
                    "Your cart is empty. Please add products before checkout."
            );

            return;
        }

        // =========================================================
        // VERIFY CART PRODUCTS
        // =========================================================

        for (CartItem cartItem : cartItems) {

            if (cartItem == null) {

                showCheckoutError(
                        request,
                        response,
                        session,
                        "Your cart contains an invalid item. Please review your cart."
                );

                return;
            }

            if (cartItem.getQuantity() <= 0) {

                showCheckoutError(
                        request,
                        response,
                        session,
                        "Your cart contains an invalid quantity. Please review your cart."
                );

                return;
            }

            Product product =
                    productDAO.getProductById(
                            cartItem.getProductId()
                    );

            if (product == null) {

                showCheckoutError(
                        request,
                        response,
                        session,
                        "One of the products in your cart is no longer available."
                );

                return;
            }
        }

        // =========================================================
        // REMOVE OLD CHECKOUT ERROR
        // =========================================================

        session.removeAttribute(
                "checkoutErrorMessage"
        );

        // =========================================================
        // MOVE TO ORDER CONTROLLER
        // =========================================================

        request.getRequestDispatcher(
                "/orders?action=checkout"
        ).forward(
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

        // ---------------------------------------------------------
        // FALLBACK TO USER OBJECT
        // ---------------------------------------------------------

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
    // GET STRING FROM SESSION
    // =========================================================

    private String getSessionString(
            HttpSession session,
            String attributeName) {

        if (session == null) {
            return "";
        }

        Object value =
                session.getAttribute(
                        attributeName
                );

        if (value == null) {
            return "";
        }

        return value.toString().trim();
    }

    // =========================================================
    // SET CHECKOUT REQUEST ATTRIBUTE
    // =========================================================

    private void setCheckoutRequestAttribute(
            HttpServletRequest request,
            HttpSession session,
            String attributeName,
            String defaultValue) {

        String value =
                getSessionString(
                        session,
                        attributeName
                );

        if (value.isEmpty()) {
            value = defaultValue;
        }

        request.setAttribute(
                attributeName,
                value
        );
    }

    // =========================================================
    // SHOW CHECKOUT ERROR
    // =========================================================

    private void showCheckoutError(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            String message)
            throws IOException {

        session.setAttribute(
                "checkoutErrorMessage",
                message
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/checkout"
        );
    }

    // =========================================================
    // TRIM
    // =========================================================

    private String trim(
            String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    // =========================================================
    // SAFE STRING
    // =========================================================

    private String safeString(
            String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }

    // =========================================================
    // APPEND ADDRESS PART
    // =========================================================

    private void appendAddressPart(
            StringBuilder builder,
            String value) {

        if (value == null
                || value.trim().isEmpty()) {

            return;
        }

        if (builder.length() > 0) {
            builder.append(", ");
        }

        builder.append(
                value.trim()
        );
    }
}