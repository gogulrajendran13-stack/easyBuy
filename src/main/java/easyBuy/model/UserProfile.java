package easyBuy.model;

public class UserProfile {

    private int profileId;
    private int userId;

    private String firstName;
    private String lastName;

    private String gender;
    private String address;


    // =========================================================
    // DEFAULT CONSTRUCTOR
    // =========================================================

    public UserProfile() {

    }


    // =========================================================
    // EXISTING CONSTRUCTOR
    // Kept for compatibility with existing code
    // =========================================================

    public UserProfile(int profileId,
                       int userId,
                       String firstName,
                       String lastName) {

        this.profileId = profileId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
    }


    // =========================================================
    // NEW CONSTRUCTOR
    // =========================================================

    public UserProfile(int profileId,
                       int userId,
                       String firstName,
                       String lastName,
                       String gender,
                       String address) {

        this.profileId = profileId;
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.address = address;
    }


    // =========================================================
    // PROFILE ID
    // =========================================================

    public int getProfileId() {
        return profileId;
    }

    public void setProfileId(int profileId) {
        this.profileId = profileId;
    }


    // =========================================================
    // USER ID
    // =========================================================

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    // =========================================================
    // FIRST NAME
    // =========================================================

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }


    // =========================================================
    // LAST NAME
    // =========================================================

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }


    // =========================================================
    // GENDER
    // =========================================================

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }


    // =========================================================
    // ADDRESS
    // =========================================================

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}