package easyBuy.dao;

import easyBuy.model.UserProfile;

public interface UserProfileDAO {

    UserProfile getProfileByUserId(int userId);

    boolean createProfile(UserProfile profile);

    boolean updateProfile(UserProfile profile);

    boolean deleteProfile(int userId);
}