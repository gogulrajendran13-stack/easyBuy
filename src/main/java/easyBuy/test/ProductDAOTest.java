package easyBuy.test;

import java.util.List;

import easyBuy.dao.ProductDAO;
import easyBuy.dao.ProductDAOImpl;
import easyBuy.model.Product;

public class ProductDAOTest {

    public static void main(String[] args) {

        ProductDAO productDAO = new ProductDAOImpl();

        System.out.println("=================================");
        System.out.println("       PRODUCT DAO TEST");
        System.out.println("=================================");

        // Test 1: Get all products
        System.out.println("\n1. ALL PRODUCTS");

        List<Product> products = productDAO.getAllProducts();

        for (Product product : products) {
            System.out.println(product);
        }

        // Test 2: Get product by ID
        System.out.println("\n2. PRODUCT BY ID");

        Product product = productDAO.getProductById(1);

        if (product != null) {
            System.out.println(product);
        } else {
            System.out.println("Product not found.");
        }

        // Test 3: Category filter
        System.out.println("\n3. PRODUCTS BY CATEGORY");

        List<Product> categoryProducts =
                productDAO.getProductsByCategory(1);

        for (Product p : categoryProducts) {
            System.out.println(p);
        }

        // Test 4: Search products
        System.out.println("\n4. SEARCH PRODUCTS");

        List<Product> searchResults =
                productDAO.searchProducts("T-Shirt");

        for (Product p : searchResults) {
            System.out.println(p);
        }

        // Test 5: Filter products
        System.out.println("\n5. FILTER PRODUCTS");

        List<Product> filteredProducts =
                productDAO.filterProducts(
                        1,
                        "M",
                        "White",
                        400.0,
                        1000.0
                );

        for (Product p : filteredProducts) {
            System.out.println(p);
        }

        System.out.println("\n=================================");
        System.out.println("       TEST COMPLETED");
        System.out.println("=================================");
    }
}