package easyBuy.dao;

import java.util.List;
import easyBuy.model.Cart;
import easyBuy.model.CartItem;

public interface CartDAO {

    Cart getCartByUserId(int userId);

    Cart createCart(int userId);

    boolean addItemToCart(CartItem cartItem);

    List<CartItem> getCartItems(int cartId);

    boolean updateItemQuantity(int cartItemId, int quantity);

    boolean removeItemFromCart(int cartItemId);

    boolean clearCart(int cartId);

    boolean isProductInCart(int cartId, int productId);
}