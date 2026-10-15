package easyBuy.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import easyBuy.dao.CategoryDAO;
import easyBuy.dao.CategoryDAOImpl;
import easyBuy.dao.OrderDAO;
import easyBuy.dao.OrderDAOImpl;
import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Category;
import easyBuy.model.Order;
import easyBuy.model.Product;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;
    private ProductDAO productDAO;


    @Override
    public void init() throws ServletException {

        categoryDAO = new CategoryDAOImpl();
        orderDAO = new OrderDAOImpl();
        productDAO = new ProductDAOImpl();

    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            /* =================================================
               CATEGORIES
            ================================================== */

            List<Category> categories =
                    categoryDAO.getAllCategories();

            if (categories == null) {

                categories =
                        new ArrayList<Category>();
            }


            /* =================================================
               PRODUCTS
            ================================================== */

            List<Product> products =
                    productDAO.getAllProducts();

            if (products == null) {

                products =
                        new ArrayList<Product>();
            }


            /* =================================================
               CURRENT HOME SECTION
            ================================================== */

            String section =
                    clean(request.getParameter("section"));

            if (section.isEmpty()) {

                section = "home";
            }


            /* =================================================
               RECENT ORDERS
            ================================================== */

            List<Order> recentOrders =
                    new ArrayList<Order>();

            HttpSession session =
                    request.getSession(false);

            Integer userId =
                    getUserIdFromSession(session);


            if (userId != null && userId > 0) {

                List<Order> userOrders =
                        orderDAO.getOrdersByUserId(userId);

                if (userOrders != null) {

                    recentOrders.addAll(userOrders);
                }
            }


            /*
             * Keep the sidebar compact.
             */

            if (recentOrders.size() > 3) {

                recentOrders =
                        new ArrayList<Order>(
                                recentOrders.subList(0, 3)
                        );
            }


            /* =================================================
               CATEGORY IDS
            ================================================== */

            int menCategoryId =
                    findCategoryId(
                            categories,
                            "men"
                    );

            int womenCategoryId =
                    findCategoryId(
                            categories,
                            "women"
                    );

            int kidsCategoryId =
                    findCategoryId(
                            categories,
                            "kids"
                    );


            /* =================================================
               REQUEST ATTRIBUTES
            ================================================== */

            request.setAttribute(
                    "categories",
                    categories
            );

            request.setAttribute(
                    "products",
                    products
            );

            request.setAttribute(
                    "recentOrders",
                    recentOrders
            );

            request.setAttribute(
                    "selectedSection",
                    section
            );

            request.setAttribute(
                    "menCategoryId",
                    menCategoryId
            );

            request.setAttribute(
                    "womenCategoryId",
                    womenCategoryId
            );

            request.setAttribute(
                    "kidsCategoryId",
                    kidsCategoryId
            );


            /* =================================================
               FORWARD
            ================================================== */

            request.getRequestDispatcher(
                    "/home.jsp"
            ).forward(
                    request,
                    response
            );


        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load home page.",
                    e
            );
        }
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);

    }


    /* =====================================================
       FIND CATEGORY ID
    ====================================================== */

    private int findCategoryId(
            List<Category> categories,
            String wanted) {

        if (categories == null || wanted == null) {

            return -1;
        }


        String target =
                wanted.trim()
                        .toLowerCase(Locale.ROOT);


        for (Category category : categories) {

            if (category == null
                    || category.getCategoryName() == null) {

                continue;
            }


            String name =
                    category.getCategoryName()
                            .trim()
                            .toLowerCase(Locale.ROOT);


            if (name.equals(target)
                    || name.contains(target)) {

                return category.getCategoryId();
            }
        }


        return -1;
    }


    /* =====================================================
       USER ID FROM SESSION
    ====================================================== */

    private Integer getUserIdFromSession(
            HttpSession session) {

        if (session == null) {

            return null;
        }


        Object value =
                session.getAttribute("userId");


        if (value instanceof Integer) {

            return (Integer) value;
        }


        if (value instanceof String) {

            try {

                return Integer.parseInt(
                        (String) value
                );

            } catch (NumberFormatException e) {

                return null;
            }
        }


        return null;
    }


    /* =====================================================
       CLEAN
    ====================================================== */

    private String clean(String value) {

        return value == null
                ? ""
                : value.trim();
    }

}