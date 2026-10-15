package easyBuy.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

import easyBuy.dao.CategoryDAO;
import easyBuy.dao.CategoryDAOImpl;
import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Category;
import easyBuy.model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/products")
public class ProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAOImpl();
        categoryDAO = new CategoryDAOImpl();

        System.out.println("PRODUCT CONTROLLER INITIALIZED");
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // Read filter values.
            String search = clean(request.getParameter("search"));
            String categoryIdParameter =
                    clean(request.getParameter("categoryId"));
            String minPriceParameter =
                    clean(request.getParameter("minPrice"));
            String maxPriceParameter =
                    clean(request.getParameter("maxPrice"));
            String size = clean(request.getParameter("size"));
            String color = clean(request.getParameter("color"));
            String sort = clean(request.getParameter("sort"));

            if (sort.isEmpty()) {
                sort = "relevance";
            }

            // Parse category ID.
            Integer selectedCategoryId = null;

            if (!categoryIdParameter.isEmpty()) {
                try {
                    int parsed = Integer.parseInt(categoryIdParameter);

                    if (parsed > 0) {
                        selectedCategoryId = parsed;
                    }

                } catch (NumberFormatException ignored) {
                    selectedCategoryId = null;
                }
            }

            // Parse minimum and maximum prices.
            double minPrice = 0;
            double maxPrice = Double.MAX_VALUE;

            if (!minPriceParameter.isEmpty()) {
                try {
                    minPrice = Math.max(
                            0,
                            Double.parseDouble(minPriceParameter)
                    );
                } catch (NumberFormatException ignored) {
                    minPrice = 0;
                }
            }

            if (!maxPriceParameter.isEmpty()) {
                try {
                    maxPrice = Double.parseDouble(maxPriceParameter);

                    if (maxPrice < 0) {
                        maxPrice = Double.MAX_VALUE;
                    }

                } catch (NumberFormatException ignored) {
                    maxPrice = Double.MAX_VALUE;
                }
            }

            // Correct the range if minimum is greater than maximum.
            if (maxPrice != Double.MAX_VALUE && minPrice > maxPrice) {

                double temp = minPrice;
                minPrice = maxPrice;
                maxPrice = temp;
            }

            // Load categories.
            List<Category> categories =
                    categoryDAO.getAllCategories();

            if (categories == null) {
                categories = new ArrayList<>();
            }

            // Load all products or products from one category.
            List<Product> products;

            if (selectedCategoryId == null) {
                products = productDAO.getAllProducts();
            } else {
                products = productDAO.getProductsByCategory(
                        selectedCategoryId
                );
            }

            if (products == null) {
                products = new ArrayList<>();
            }

            // Collect available sizes and colors.
            Set<String> sizeSet = new LinkedHashSet<>();
            Set<String> colorSet = new LinkedHashSet<>();

            for (Product product : products) {

                if (product == null) {
                    continue;
                }

                String productSize = clean(product.getSize());
                String productColor = clean(product.getColor());

                if (!productSize.isEmpty()) {
                    sizeSet.add(productSize);
                }

                if (!productColor.isEmpty()) {
                    colorSet.add(productColor);
                }
            }

            List<String> availableSizes =
                    new ArrayList<>(sizeSet);

            List<String> availableColors =
                    new ArrayList<>(colorSet);

            availableSizes.sort(String.CASE_INSENSITIVE_ORDER);
            availableColors.sort(String.CASE_INSENSITIVE_ORDER);

            // Search by product name, size, or color.
            if (!search.isEmpty()) {

                String query = search.toLowerCase(Locale.ROOT);
                List<Product> filtered = new ArrayList<>();

                for (Product product : products) {

                    if (product == null) {
                        continue;
                    }

                    if (safeLower(product.getProductName())
                            .contains(query)
                            || safeLower(product.getSize())
                            .contains(query)
                            || safeLower(product.getColor())
                            .contains(query)) {

                        filtered.add(product);
                    }
                }

                products = filtered;
            }

            // Filter by size.
            if (!size.isEmpty()) {

                List<Product> filtered = new ArrayList<>();

                for (Product product : products) {

                    if (product != null
                            && clean(product.getSize())
                            .equalsIgnoreCase(size)) {

                        filtered.add(product);
                    }
                }

                products = filtered;
            }

            // Filter by color.
            if (!color.isEmpty()) {

                List<Product> filtered = new ArrayList<>();

                for (Product product : products) {

                    if (product != null
                            && clean(product.getColor())
                            .equalsIgnoreCase(color)) {

                        filtered.add(product);
                    }
                }

                products = filtered;
            }

            // Filter by price.
            List<Product> priceFiltered = new ArrayList<>();

            for (Product product : products) {

                if (product != null
                        && product.getPrice() >= minPrice
                        && product.getPrice() <= maxPrice) {

                    priceFiltered.add(product);
                }
            }

            products = priceFiltered;

            // Sort products.
            switch (sort) {

                case "price_asc":

                    products.sort(
                            Comparator.comparingDouble(
                                    Product::getPrice
                            )
                    );

                    break;

                case "price_desc":

                    products.sort(
                            Comparator.comparingDouble(
                                    Product::getPrice
                            ).reversed()
                    );

                    break;

                case "name_asc":

                    products.sort(
                            Comparator.comparing(
                                    p -> safeLower(
                                            p.getProductName()
                                    )
                            )
                    );

                    break;

                case "name_desc":

                    products.sort(
                            Comparator.comparing(
                                    (Product p) ->
                                            safeLower(
                                                    p.getProductName()
                                            )
                            ).reversed()
                    );

                    break;

                case "relevance":
                default:
                    // Keep the DAO's original order.
                    break;
            }

            /*
             * Display one product card per product name.
             * Filtering is completed first so that size and color
             * selections can still determine the matching variant.
             */
            Map<String, Product> uniqueProducts =
                    new LinkedHashMap<>();

            for (Product product : products) {

                if (product == null) {
                    continue;
                }

                String key = safeLower(
                        product.getProductName()
                ).trim();

                if (key.isEmpty()) {
                    key = "product-id-" + product.getProductId();
                }

                uniqueProducts.putIfAbsent(key, product);
            }

            products = new ArrayList<>(
                    uniqueProducts.values()
            );

            // Find the selected category.
            Category selectedCategory = null;

            if (selectedCategoryId != null) {

                for (Category category : categories) {

                    if (category != null
                            && category.getCategoryId()
                            == selectedCategoryId) {

                        selectedCategory = category;
                        break;
                    }
                }
            }

            // Send data to products.jsp.
            request.setAttribute("products", products);
            request.setAttribute("categories", categories);

            request.setAttribute(
                    "selectedCategoryId",
                    selectedCategoryId
            );

            request.setAttribute(
                    "selectedCategory",
                    selectedCategory
            );

            request.setAttribute(
                    "availableSizes",
                    availableSizes
            );

            request.setAttribute(
                    "availableColors",
                    availableColors
            );

            request.setAttribute("search", search);
            request.setAttribute("minPrice", minPriceParameter);
            request.setAttribute("maxPrice", maxPriceParameter);
            request.setAttribute("size", size);
            request.setAttribute("color", color);
            request.setAttribute("sort", sort);

            request.getRequestDispatcher("/products.jsp")
                   .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load products.",
                    e
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }

    // Return an empty string instead of null.
    private String clean(String value) {

        return value == null ? "" : value.trim();
    }

    // Convert text to lowercase safely.
    private String safeLower(String value) {

        return value == null
                ? ""
                : value.toLowerCase(Locale.ROOT);
    }
}