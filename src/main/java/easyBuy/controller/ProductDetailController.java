package easyBuy.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Product;

@WebServlet("/product-details")
public class ProductDetailController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;

    // =========================================================
    // INITIALIZE CONTROLLER
    // =========================================================

    @Override
    public void init() throws ServletException {

        productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("PRODUCT DETAIL CONTROLLER STARTED");
        System.out.println("=================================");
    }

    // =========================================================
    // GET
    // Open product details page
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=================================");
        System.out.println("PRODUCT DETAIL CONTROLLER - doGet()");
        System.out.println("=================================");

        /*
         * Expected URL:
         *
         * /product-details?productId=1
         */

        String productIdParameter =
                clean(request.getParameter("productId"));

        System.out.println(
                "Received productId: " + productIdParameter
        );

        // =====================================================
        // CHECK PRODUCT ID
        // =====================================================

        if (productIdParameter.isEmpty()) {

            System.out.println(
                    "Product ID is missing."
            );

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Product ID is required."
            );

            return;
        }

        // =====================================================
        // PARSE PRODUCT ID
        // =====================================================

        int productId;

        try {

            productId =
                    Integer.parseInt(productIdParameter);

        } catch (NumberFormatException e) {

            System.out.println(
                    "Invalid productId: "
                            + productIdParameter
            );

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Product ID."
            );

            return;
        }

        // =====================================================
        // VALIDATE PRODUCT ID
        // =====================================================

        if (productId <= 0) {

            System.out.println(
                    "Product ID must be greater than zero: "
                            + productId
            );

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid Product ID."
            );

            return;
        }

        // =====================================================
        // LOAD PRODUCT
        // =====================================================

        try {

            Product product =
                    productDAO.getProductById(productId);

            // =================================================
            // PRODUCT NOT FOUND
            // =================================================

            if (product == null) {

                System.out.println(
                        "Product not found for ID: "
                                + productId
                );

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Product not found."
                );

                return;
            }

            // =================================================
            // DEBUG INFORMATION
            // =================================================

            System.out.println(
                    "Product found successfully."
            );

            System.out.println(
                    "Product ID   : "
                            + product.getProductId()
            );

            System.out.println(
                    "Product Name : "
                            + product.getProductName()
            );

            System.out.println(
                    "Category ID  : "
                            + product.getCategoryId()
            );

            System.out.println(
                    "Price        : "
                            + product.getPrice()
            );

            System.out.println(
                    "Size         : "
                            + product.getSize()
            );

            System.out.println(
                    "Color        : "
                            + product.getColor()
            );

            // =================================================
            // SEND PRODUCT TO JSP
            // =================================================

            /*
             * product-details.jsp receives the Product object
             * using:
             *
             * request.getAttribute("product")
             */

            request.setAttribute(
                    "product",
                    product
            );

            // =================================================
            // FORWARD TO PRODUCT DETAILS PAGE
            // =================================================

            request.getRequestDispatcher(
                    "/product-details.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load product details.",
                    e
            );
        }
    }

    // =========================================================
    // POST
    // Product details itself does not require POST.
    //
    // If a POST reaches this controller accidentally, send the
    // user back to the normal GET product-details URL.
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String productId =
                clean(request.getParameter("productId"));

        if (productId.isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Product ID is required."
            );

            return;
        }

        /*
         * Redirect to the normal product-details GET request.
         */

        response.sendRedirect(
                request.getContextPath()
                        + "/product-details?productId="
                        + productId
        );
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