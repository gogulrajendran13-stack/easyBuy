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

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CartDAO cartDAO;
    private ProductDAO productDAO;

    /* =========================================================
       INITIALIZE
    ========================================================= */

    @Override
    public void init() throws ServletException {

        cartDAO = new CartDAOImpl();
        productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("CART CONTROLLER INITIALIZED");
        System.out.println("=================================");
    }

    /* =========================================================
       GET
    ========================================================= */

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("CART CONTROLLER - doGet()");
        System.out.println("=================================");

        try {

            Integer userId = getLoggedInUserId(request);

            System.out.println(
                    "Resolved logged-in user ID: " + userId
            );

            /* =================================================
               USER NOT LOGGED IN
            ================================================= */

            if (userId == null || userId <= 0) {

                System.out.println(
                        "No logged-in user found."
                );

                prepareEmptyCartView(request);

                request.setAttribute(
                        "errorMessage",
                        "Please log in before accessing your cart."
                );

                request.getRequestDispatcher(
                        "/cart.jsp"
                ).forward(
                        request,
                        response
                );

                return;
            }

            /* =================================================
               GET USER CART
            ================================================= */

            Cart cart = cartDAO.getCartByUserId(userId);

            /* =================================================
               CREATE CART IF IT DOES NOT EXIST
            ================================================= */

            if (cart == null) {

                System.out.println(
                        "Cart not found. Creating cart for user: "
                                + userId
                );

                cart = cartDAO.createCart(userId);
            }

            /* =================================================
               GET CART ITEMS
            ================================================= */

            List<CartItem> cartItems;

            if (cart != null) {

                cartItems = cartDAO.getCartItems(
                        cart.getCartId()
                );

                if (cartItems == null) {
                    cartItems = Collections.emptyList();
                }

            } else {

                cartItems = Collections.emptyList();
            }

            /* =================================================
               GET PRODUCT INFORMATION
            ================================================= */

            Map<Integer, Product> products =
                    new HashMap<Integer, Product>();

            BigDecimal cartTotal = BigDecimal.ZERO;

            for (CartItem cartItem : cartItems) {

                Product product =
                        productDAO.getProductById(
                                cartItem.getProductId()
                        );

                if (product != null) {

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
                            "Cart Item: "
                                    + product.getProductName()
                                    + " | Quantity: "
                                    + cartItem.getQuantity()
                                    + " | Subtotal: "
                                    + subtotal
                    );
                }
            }

            /* =================================================
               SEND DATA TO cart.jsp
            ================================================= */

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

            /* =================================================
               CART SUCCESS MESSAGE
            ================================================= */

            HttpSession session =
                    request.getSession(false);

            if (session != null) {

                Object cartMessage =
                        session.getAttribute("cartMessage");

                if (cartMessage != null) {

                    request.setAttribute(
                            "successMessage",
                            cartMessage.toString()
                    );

                    session.removeAttribute(
                            "cartMessage"
                    );
                }
            }

            /* =================================================
               OPEN CART JSP
            ================================================= */

            request.getRequestDispatcher(
                    "/cart.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load cart.",
                    e
            );
        }
    }

    /* =========================================================
       POST
    ========================================================= */

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("CART CONTROLLER - doPost()");
        System.out.println("=================================");

        try {

            Integer userId =
                    getLoggedInUserId(request);

            System.out.println(
                    "Resolved logged-in user ID: "
                            + userId
            );

            /* =================================================
               CHECK LOGIN
            ================================================= */

            if (userId == null || userId <= 0) {

                System.out.println(
                        "Cart request rejected: user is not logged in."
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/login"
                );

                return;
            }

            /* =================================================
               GET ACTION
            ================================================= */

            String action =
                    clean(request.getParameter("action"));

            if (action.isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                                + "/cart"
                );

                return;
            }

            action = action.toLowerCase();

            /* =================================================
               GET USER CART
            ================================================= */

            Cart cart =
                    cartDAO.getCartByUserId(userId);

            if (cart == null) {

                cart =
                        cartDAO.createCart(userId);
            }

            if (cart == null) {

                throw new ServletException(
                        "Unable to create cart for user."
                );
            }

            /* =================================================
               ADD PRODUCT
            ================================================= */

            if ("add".equals(action)) {

                addProductToCart(
                        request,
                        response,
                        cart
                );

                return;
            }

            /* =================================================
               UPDATE QUANTITY
            ================================================= */

            if ("update".equals(action)) {

                updateCartItem(
                        request,
                        response,
                        cart
                );

                return;
            }

            /* =================================================
               REMOVE ITEM
            ================================================= */

            if ("remove".equals(action)) {

                removeCartItem(
                        request,
                        response,
                        cart
                );

                return;
            }

            /* =================================================
               CLEAR CART
            ================================================= */

            if ("clear".equals(action)) {

                boolean cleared =
                        cartDAO.clearCart(
                                cart.getCartId()
                        );

                if (cleared) {

                    request.getSession()
                            .setAttribute(
                                    "cartMessage",
                                    "Your cart has been cleared."
                            );

                } else {

                    request.getSession()
                            .setAttribute(
                                    "cartMessage",
                                    "Your cart is already empty."
                            );
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/cart"
                );

                return;
            }

            /* =================================================
               UNKNOWN ACTION
            ================================================= */

            response.sendRedirect(
                    request.getContextPath()
                            + "/cart"
            );

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid cart information."
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to update cart.",
                    e
            );
        }
    }

    /* =========================================================
       GET LOGGED-IN USER ID
    ========================================================= */

    private Integer getLoggedInUserId(
            HttpServletRequest request) {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            System.out.println(
                    "No HTTP session exists."
            );

            return null;
        }

        /* =====================================================
           FIRST: userId SESSION ATTRIBUTE
        ===================================================== */

        Object userIdObject =
                session.getAttribute("userId");

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

        /* =====================================================
           SECOND: USER OBJECT FROM SESSION
        ===================================================== */

        Object userObject =
                session.getAttribute("user");

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

        System.out.println(
                "No valid logged-in user found in session."
        );

        return null;
    }

    /* =========================================================
       PREPARE EMPTY CART VIEW
    ========================================================= */

    private void prepareEmptyCartView(
            HttpServletRequest request) {

        request.setAttribute(
                "cart",
                null
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
    }

    /* =========================================================
       ADD PRODUCT TO CART
    ========================================================= */

    private void addProductToCart(
            HttpServletRequest request,
            HttpServletResponse response,
            Cart cart)
            throws IOException {

        String productIdParameter =
                clean(request.getParameter("productId"));

        String quantityParameter =
                clean(request.getParameter("quantity"));

        /* =================================================
           CHECK PRODUCT ID
        ================================================= */

        if (productIdParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Product ID is required."
            );

            return;
        }

        int productId =
                Integer.parseInt(
                        productIdParameter
                );

        if (productId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Product ID."
            );

            return;
        }

        /* =================================================
           VERIFY PRODUCT EXISTS
        ================================================= */

        Product product =
                productDAO.getProductById(productId);

        if (product == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Product not found."
            );

            return;
        }

        /* =================================================
           QUANTITY
        ================================================= */

        int quantity = 1;

        if (!quantityParameter.isEmpty()) {

            quantity =
                    Integer.parseInt(
                            quantityParameter
                    );
        }

        if (quantity <= 0) {
            quantity = 1;
        }

        System.out.println(
                "Adding product ID "
                        + productId
                        + " to cart ID "
                        + cart.getCartId()
        );

        /* =================================================
           CHECK WHETHER PRODUCT ALREADY EXISTS
        ================================================= */

        boolean alreadyExists =
                cartDAO.isProductInCart(
                        cart.getCartId(),
                        productId
                );

        if (alreadyExists) {

            List<CartItem> existingItems =
                    cartDAO.getCartItems(
                            cart.getCartId()
                    );

            boolean updated = false;

            if (existingItems != null) {

                for (CartItem item : existingItems) {

                    if (item.getProductId()
                            == productId) {

                        int newQuantity =
                                item.getQuantity()
                                        + quantity;

                        updated =
                                cartDAO.updateItemQuantity(
                                        item.getCartItemId(),
                                        newQuantity
                                );

                        break;
                    }
                }
            }

            if (updated) {

                request.getSession()
                        .setAttribute(
                                "cartMessage",
                                "Product quantity updated in your cart."
                        );

                System.out.println(
                        "Cart quantity updated successfully."
                );

            } else {

                request.getSession()
                        .setAttribute(
                                "cartMessage",
                                "Unable to update product quantity."
                        );

                System.out.println(
                        "Cart quantity update failed."
                );
            }

        } else {

            /* =================================================
               CREATE CART ITEM
            ================================================= */

            CartItem cartItem =
                    new CartItem();

            cartItem.setCartId(
                    cart.getCartId()
            );

            cartItem.setProductId(
                    productId
            );

            cartItem.setQuantity(
                    quantity
            );

            boolean added =
                    cartDAO.addItemToCart(
                            cartItem
                    );

            if (added) {

                request.getSession()
                        .setAttribute(
                                "cartMessage",
                                "Product added to your cart successfully."
                        );

                System.out.println(
                        "Product added to cart successfully."
                );

            } else {

                request.getSession()
                        .setAttribute(
                                "cartMessage",
                                "Unable to add product to cart."
                        );

                System.out.println(
                        "Product could not be added to cart."
                );
            }
        }

        /* =================================================
           RETURN TO CART
        ================================================= */

        response.sendRedirect(
                request.getContextPath()
                        + "/cart"
        );
    }

    /* =========================================================
       UPDATE CART ITEM
    ========================================================= */

    private void updateCartItem(
            HttpServletRequest request,
            HttpServletResponse response,
            Cart cart)
            throws IOException {

        String cartItemIdParameter =
                clean(
                        request.getParameter(
                                "cartItemId"
                        )
                );

        String quantityParameter =
                clean(
                        request.getParameter(
                                "quantity"
                        )
                );

        if (cartItemIdParameter.isEmpty()
                || quantityParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Cart item information is required."
            );

            return;
        }

        int cartItemId =
                Integer.parseInt(
                        cartItemIdParameter
                );

        int quantity =
                Integer.parseInt(
                        quantityParameter
                );

        if (cartItemId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid cart item ID."
            );

            return;
        }

        /* =================================================
           VERIFY ITEM BELONGS TO CURRENT USER'S CART
        ================================================= */

        CartItem cartItem =
                getCartItemFromCart(
                        cart.getCartId(),
                        cartItemId
                );

        if (cartItem == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Cart item not found."
            );

            return;
        }

        /* =================================================
           UPDATE OR REMOVE
        ================================================= */

        if (quantity <= 0) {

            cartDAO.removeItemFromCart(
                    cartItemId
            );

        } else {

            cartDAO.updateItemQuantity(
                    cartItemId,
                    quantity
            );
        }

        request.getSession()
                .setAttribute(
                        "cartMessage",
                        "Cart updated successfully."
                );

        response.sendRedirect(
                request.getContextPath()
                        + "/cart"
        );
    }

    /* =========================================================
       REMOVE CART ITEM
    ========================================================= */

    private void removeCartItem(
            HttpServletRequest request,
            HttpServletResponse response,
            Cart cart)
            throws IOException {

        String cartItemIdParameter =
                clean(
                        request.getParameter(
                                "cartItemId"
                        )
                );

        if (cartItemIdParameter.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Cart item ID is required."
            );

            return;
        }

        int cartItemId =
                Integer.parseInt(
                        cartItemIdParameter
                );

        if (cartItemId <= 0) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid cart item ID."
            );

            return;
        }

        /* =================================================
           VERIFY ITEM BELONGS TO CURRENT USER'S CART
        ================================================= */

        CartItem cartItem =
                getCartItemFromCart(
                        cart.getCartId(),
                        cartItemId
                );

        if (cartItem == null) {

            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Cart item not found."
            );

            return;
        }

        boolean removed =
                cartDAO.removeItemFromCart(
                        cartItemId
                );

        if (removed) {

            request.getSession()
                    .setAttribute(
                            "cartMessage",
                            "Product removed from your cart."
                    );

        } else {

            request.getSession()
                    .setAttribute(
                            "cartMessage",
                            "Unable to remove product from cart."
                    );
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/cart"
        );
    }

    /* =========================================================
       FIND CART ITEM INSIDE CURRENT CART
    ========================================================= */

    private CartItem getCartItemFromCart(
            int cartId,
            int cartItemId) {

        List<CartItem> cartItems =
                cartDAO.getCartItems(cartId);

        if (cartItems == null) {
            return null;
        }

        for (CartItem item : cartItems) {

            if (item.getCartItemId()
                    == cartItemId) {

                return item;
            }
        }

        return null;
    }

    /* =========================================================
       CLEAN INPUT
    ========================================================= */

    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}