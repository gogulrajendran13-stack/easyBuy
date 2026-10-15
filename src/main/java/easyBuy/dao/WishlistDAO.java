package easyBuy.dao;

import java.util.List;
import easyBuy.model.Wishlist;

public interface WishlistDAO {

    boolean addToWishlist(Wishlist wishlist);

    boolean removeFromWishlist(int userId, int productId);

    List<Wishlist> getWishlistByUserId(int userId);

    boolean isProductInWishlist(int userId, int productId);

    boolean clearWishlist(int userId);
}