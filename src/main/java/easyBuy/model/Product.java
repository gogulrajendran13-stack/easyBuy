
package easyBuy.model;

public class Product {

    private int productId;
    private String productName;
    private String size;
    private String color;
    private double price;
    private int categoryId;

    // Stores the product image filename
    // Example: wireless-headphones.jpg
    private String imageName;

    public Product() {
    }

    public Product(int productId, String productName,
                   String size, String color,
                   double price, int categoryId) {
        this.productId = productId;
        this.productName = productName;
        this.size = size;
        this.color = color;
        this.price = price;
        this.categoryId = categoryId;
    }

    // Constructor including image filename
    public Product(int productId, String productName,
                   String size, String color,
                   double price, int categoryId,
                   String imageName) {
        this.productId = productId;
        this.productName = productName;
        this.size = size;
        this.color = color;
        this.price = price;
        this.categoryId = categoryId;
        this.imageName = imageName;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    // Getter for product image filename
    public String getImageName() {
        return imageName;
    }

    // Setter for product image filename
    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    @Override
    public String toString() {
        return "Product{" +
                "productId=" + productId +
                ", productName='" + productName + '\'' +
                ", size='" + size + '\'' +
                ", color='" + color + '\'' +
                ", price=" + price +
                ", categoryId=" + categoryId +
                ", imageName='" + imageName + '\'' +
                '}';
    }
}
