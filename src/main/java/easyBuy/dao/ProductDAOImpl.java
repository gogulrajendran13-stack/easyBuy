
package easyBuy.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import easyBuy.model.Product;
import easyBuy.util.DBConnection;

public class ProductDAOImpl implements ProductDAO {

    @Override
    public boolean addProduct(Product product) {

        String sql = "INSERT INTO products "
                   + "(product_name, size, color, price, category_id, image_name) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, product.getProductName());
            statement.setString(2, product.getSize());
            statement.setString(3, product.getColor());
            statement.setDouble(4, product.getPrice());
            statement.setInt(5, product.getCategoryId());
            statement.setString(6, product.getImageName());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Product getProductById(int productId) {

        String sql = "SELECT * FROM products WHERE product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, productId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapProduct(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Product> getAllProducts() {

        String sql = "SELECT * FROM products ORDER BY product_id";

        List<Product> products = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                products.add(mapProduct(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public List<Product> getProductsByCategory(int categoryId) {

        String sql = "SELECT * FROM products WHERE category_id = ?";

        List<Product> products = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, categoryId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    products.add(mapProduct(resultSet));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public List<Product> searchProducts(String keyword) {

        String sql = "SELECT * FROM products "
                   + "WHERE product_name LIKE ? "
                   + "OR color LIKE ? "
                   + "OR size LIKE ?";

        List<Product> products = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            String searchKeyword = "%" + keyword + "%";

            statement.setString(1, searchKeyword);
            statement.setString(2, searchKeyword);
            statement.setString(3, searchKeyword);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    products.add(mapProduct(resultSet));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public List<Product> filterProducts(
            Integer categoryId,
            String size,
            String color,
            Double minPrice,
            Double maxPrice) {

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM products WHERE 1=1"
        );

        List<Object> parameters = new ArrayList<>();

        if (categoryId != null) {
            sql.append(" AND category_id = ?");
            parameters.add(categoryId);
        }

        if (size != null && !size.trim().isEmpty()) {
            sql.append(" AND size = ?");
            parameters.add(size);
        }

        if (color != null && !color.trim().isEmpty()) {
            sql.append(" AND color = ?");
            parameters.add(color);
        }

        if (minPrice != null) {
            sql.append(" AND price >= ?");
            parameters.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            parameters.add(maxPrice);
        }

        List<Product> products = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                statement.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    products.add(mapProduct(resultSet));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    @Override
    public boolean updateProduct(Product product) {

        String sql = "UPDATE products "
                   + "SET product_name = ?, size = ?, color = ?, "
                   + "price = ?, category_id = ?, image_name = ? "
                   + "WHERE product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, product.getProductName());
            statement.setString(2, product.getSize());
            statement.setString(3, product.getColor());
            statement.setDouble(4, product.getPrice());
            statement.setInt(5, product.getCategoryId());
            statement.setString(6, product.getImageName());
            statement.setInt(7, product.getProductId());

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteProduct(int productId) {

        String sql = "DELETE FROM products WHERE product_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, productId);

            return statement.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Product mapProduct(ResultSet resultSet)
            throws SQLException {

        Product product = new Product();

        product.setProductId(
                resultSet.getInt("product_id"));

        product.setProductName(
                resultSet.getString("product_name"));

        product.setSize(
                resultSet.getString("size"));

        product.setColor(
                resultSet.getString("color"));

        product.setPrice(
                resultSet.getDouble("price"));

        product.setCategoryId(
                resultSet.getInt("category_id"));

        product.setImageName(
                resultSet.getString("image_name"));

        return product;
    }
}
