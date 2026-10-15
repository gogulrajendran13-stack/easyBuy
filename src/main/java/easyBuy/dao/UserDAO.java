package easyBuy.dao;

import easyBuy.model.User;

public interface UserDAO {

    boolean registerUser(User user);

    boolean emailExists(String email);

    User getUserByEmail(String email);
}