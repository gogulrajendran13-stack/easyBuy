package easyBuy.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.dao.WishlistDAO;
import easyBuy.dao.WishlistDAOImpl;
import easyBuy.model.Product;
import easyBuy.model.Wishlist;

@WebServlet("/wishlist")
public class WishlistController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private WishlistDAO wishlistDAO;
    private ProductDAO productDAO;


    // =========================================================
    // INITIALIZE
    // =========================================================

    @Override
    public void init() throws ServletException {

        wishlistDAO = new WishlistDAOImpl();
        productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("WISHLIST CONTROLLER INITIALIZED");
        System.out.println("=================================");
    }


    // =========================================================
    // GET
    // VIEW WISHLIST
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        Integer userId =
                getUserIdFromSession(session);


        /*
         * User must be logged in.
         */

        if (userId == null || userId <= 0) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        /*
         * Get wishlist rows.
         */

        List<Wishlist> wishlistItems =
                wishlistDAO.getWishlistByUserId(userId);


        /*
         * Prepare product map.
         */

        Map<Integer, Product> products =
                new HashMap<>();


        /*
         * Load product information.
         */

        if (wishlistItems != null) {

            for (Wishlist wishlist : wishlistItems) {

                int productId =
                        wishlist.getProductId();

                Product product =
                        productDAO.getProductById(productId);

                if (product != null) {

                    products.put(
                            productId,
                            product
                    );
                }
            }
        }


        /*
         * Send data to JSP.
         */

        request.setAttribute(
                "wishlistItems",
                wishlistItems
        );

        request.setAttribute(
                "products",
                products
        );


        /*
         * IMPORTANT:
         * Your JSP file is Wishlist.jsp
         * with capital W.
         */

        request.getRequestDispatcher(
                "/Wishlist.jsp"
        ).forward(
                request,
                response
        );
    }


    // =========================================================
    // POST
    // ADD / REMOVE / CLEAR
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        Integer userId =
                getUserIdFromSession(session);


        /*
         * User must be logged in.
         */

        if (userId == null || userId <= 0) {

            response.sendRedirect(
                    request.getContextPath() + "/login"
            );

            return;
        }


        /*
         * Read action.
         */

        String action =
                clean(request.getParameter("action"));


        // =====================================================
        // ADD
        // =====================================================

        if ("add".equalsIgnoreCase(action)) {

            handleAddToWishlist(
                    request,
                    response,
                    session,
                    userId
            );

            return;
        }


        // =====================================================
        // REMOVE
        // =====================================================

        if ("remove".equalsIgnoreCase(action)) {

            handleRemoveFromWishlist(
                    request,
                    response,
                    session,
                    userId
            );

            return;
        }


        // =====================================================
        // CLEAR
        // =====================================================

        if ("clear".equalsIgnoreCase(action)) {

            boolean success =
                    wishlistDAO.clearWishlist(userId);


            if (success) {

                session.setAttribute(
                        "wishlistSuccessMessage",
                        "Wishlist cleared successfully."
                );

            } else {

                session.setAttribute(
                        "wishlistErrorMessage",
                        "Your wishlist is already empty."
                );
            }


            response.sendRedirect(
                    request.getContextPath() + "/wishlist"
            );

            return;
        }


        // =====================================================
        // INVALID ACTION
        // =====================================================

        session.setAttribute(
                "wishlistErrorMessage",
                "Invalid wishlist action."
        );


        response.sendRedirect(
                request.getContextPath() + "/wishlist"
        );
    }


    // =========================================================
    // ADD TO WISHLIST
    // =========================================================

    private void handleAddToWishlist(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            int userId)
            throws IOException {

        String productIdParam =
                clean(request.getParameter("productId"));


        if (productIdParam.isEmpty()) {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Product ID is missing."
            );

            redirectBackToProduct(
                    request,
                    response
            );

            return;
        }


        int productId;

        try {

            productId =
                    Integer.parseInt(productIdParam);

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Invalid product."
            );

            redirectBackToProduct(
                    request,
                    response
            );

            return;
        }


        /*
         * Verify product exists.
         */

        Product product =
                productDAO.getProductById(productId);


        if (product == null) {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Product not found."
            );

            redirectBackToProduct(
                    request,
                    response
            );

            return;
        }


        /*
         * Prevent duplicates.
         */

        boolean alreadyExists =
                wishlistDAO.isProductInWishlist(
                        userId,
                        productId
                );


        if (alreadyExists) {

            session.setAttribute(
                    "wishlistSuccessMessage",
                    "Product is already in your wishlist."
            );

            redirectBackToProduct(
                    request,
                    response
            );

            return;
        }


        /*
         * Create Wishlist object.
         */

        Wishlist wishlist =
                new Wishlist();

        wishlist.setUserId(userId);
        wishlist.setProductId(productId);


        /*
         * Save to database.
         */

        boolean success =
                wishlistDAO.addToWishlist(
                        wishlist
                );


        if (success) {

            session.setAttribute(
                    "wishlistSuccessMessage",
                    "Product added to your wishlist."
            );

        } else {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Unable to add product to your wishlist."
            );
        }


        redirectBackToProduct(
                request,
                response
        );
    }


    // =========================================================
    // REMOVE FROM WISHLIST
    // =========================================================

    private void handleRemoveFromWishlist(
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            int userId)
            throws IOException {

        String productIdParam =
                clean(request.getParameter("productId"));


        if (productIdParam.isEmpty()) {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Product ID is missing."
            );

            response.sendRedirect(
                    request.getContextPath() + "/wishlist"
            );

            return;
        }


        int productId;

        try {

            productId =
                    Integer.parseInt(productIdParam);

        } catch (NumberFormatException e) {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Invalid product."
            );

            response.sendRedirect(
                    request.getContextPath() + "/wishlist"
            );

            return;
        }


        /*
         * Remove wishlist item.
         */

        boolean success =
                wishlistDAO.removeFromWishlist(
                        userId,
                        productId
                );


        if (success) {

            session.setAttribute(
                    "wishlistSuccessMessage",
                    "Product removed from your wishlist."
            );

        } else {

            session.setAttribute(
                    "wishlistErrorMessage",
                    "Product was not found in your wishlist."
            );
        }


        response.sendRedirect(
                request.getContextPath() + "/wishlist"
        );
    }


    // =========================================================
    // REDIRECT BACK TO PRODUCT DETAILS
    // =========================================================

    private void redirectBackToProduct(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        String productId =
                clean(request.getParameter("productId"));


        if (!productId.isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/product-details?productId="
                    + productId
            );

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/wishlist"
            );
        }
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
                session.getAttribute("userId");


        if (userIdObject instanceof Integer) {

            return (Integer) userIdObject;
        }


        if (userIdObject instanceof String) {

            try {

                return Integer.parseInt(
                        String.valueOf(userIdObject)
                );

            } catch (NumberFormatException e) {

                return null;
            }
        }


        return null;
    }


    // =========================================================
    // CLEAN INPUT
    // =========================================================

    private String clean(String value) {

        if (value == null) {
            return "";
        }

        return value.trim();
    }
}