package easyBuy.model;

public class User {

    /* =====================================================
       USER FIELDS
    ===================================================== */

    private int userId;

    private String name;

    private String email;

    private String passwordHash;

    private String phone;

    private String gender;

    private String address;


    /* =====================================================
       DEFAULT CONSTRUCTOR
    ===================================================== */

    public User() {

    }


    /* =====================================================
       EXISTING FULL CONSTRUCTOR
       Kept for compatibility with current code.
    ===================================================== */

    public User(
            int userId,
            String name,
            String email,
            String passwordHash,
            String phone) {

        this.userId = userId;

        this.name = name;

        this.email = email;

        this.passwordHash = passwordHash;

        this.phone = phone;
    }


    /* =====================================================
       NEW FULL CONSTRUCTOR
       Includes profile information.
    ===================================================== */

    public User(
            int userId,
            String name,
            String email,
            String passwordHash,
            String phone,
            String gender,
            String address) {

        this.userId = userId;

        this.name = name;

        this.email = email;

        this.passwordHash = passwordHash;

        this.phone = phone;

        this.gender = gender;

        this.address = address;
    }


    /* =====================================================
       EXISTING REGISTRATION CONSTRUCTOR
       Kept for compatibility with RegisterController.
    ===================================================== */

    public User(
            String name,
            String email,
            String passwordHash,
            String phone) {

        this.name = name;

        this.email = email;

        this.passwordHash = passwordHash;

        this.phone = phone;
    }


    /* =====================================================
       NEW REGISTRATION / PROFILE CONSTRUCTOR
       Includes gender and address.
    ===================================================== */

    public User(
            String name,
            String email,
            String passwordHash,
            String phone,
            String gender,
            String address) {

        this.name = name;

        this.email = email;

        this.passwordHash = passwordHash;

        this.phone = phone;

        this.gender = gender;

        this.address = address;
    }


    /* =====================================================
       USER ID
    ===================================================== */

    public int getUserId() {

        return userId;
    }


    public void setUserId(int userId) {

        this.userId = userId;
    }


    /* =====================================================
       NAME
    ===================================================== */

    public String getName() {

        return name;
    }


    public void setName(String name) {

        this.name = name;
    }


    /* =====================================================
       EMAIL
    ===================================================== */

    public String getEmail() {

        return email;
    }


    public void setEmail(String email) {

        this.email = email;
    }


    /* =====================================================
       PASSWORD HASH
    ===================================================== */

    public String getPasswordHash() {

        return passwordHash;
    }


    public void setPasswordHash(String passwordHash) {

        this.passwordHash = passwordHash;
    }


    /* =====================================================
       PHONE / MOBILE NUMBER
    ===================================================== */

    public String getPhone() {

        return phone;
    }


    public void setPhone(String phone) {

        this.phone = phone;
    }


    /* =====================================================
       GENDER
    ===================================================== */

    public String getGender() {

        return gender;
    }


    public void setGender(String gender) {

        this.gender = gender;
    }


    /* =====================================================
       ADDRESS
    ===================================================== */

    public String getAddress() {

        return address;
    }


    public void setAddress(String address) {

        this.address = address;
    }


    /* =====================================================
       TO STRING
    ===================================================== */

    @Override
    public String toString() {

        return "User{" +

                "userId=" + userId +

                ", name='" + name + '\'' +

                ", email='" + email + '\'' +

                ", phone='" + phone + '\'' +

                ", gender='" + gender + '\'' +

                ", address='" + address + '\'' +

                '}';
    }
}