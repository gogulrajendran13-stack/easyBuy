package easyBuy.dao;

import java.util.List;
import easyBuy.model.Product;

public interface ProductDAO {

    boolean addProduct(Product product);

    Product getProductById(int productId);

    List<Product> getAllProducts();

    List<Product> getProductsByCategory(int categoryId);

    List<Product> searchProducts(String keyword);

    List<Product> filterProducts(
            Integer categoryId,
            String size,
            String color,
            Double minPrice,
            Double maxPrice
    );

    boolean updateProduct(Product product);

    boolean deleteProduct(int productId);
}