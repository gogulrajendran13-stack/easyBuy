# EasyBuy – Java E-Commerce Web Application

EasyBuy is a Java-based e-commerce web application developed to demonstrate full-stack web development using Java, JSP, Servlets, JDBC, MySQL, HTML, CSS, and JavaScript.

## Project Overview

- **Project Name:** EasyBuy
- **Project Type:** E-Commerce Web Application
- **Backend:** Java, Servlets, JSP, JDBC
- **Frontend:** HTML5, CSS3, JavaScript
- **Database:** MySQL
- **Build Tool:** Maven
- **Development Environment:** Eclipse IDE
- **Server:** Apache Tomcat

## Features

The project is designed to support e-commerce functionality such as:

- User registration and login
- Product browsing and product details
- Shopping cart management
- Wishlist functionality
- Address and checkout pages
- Order management
- Payment-method selection

Feature availability and completeness depend on the current implementation.

## Technologies Used

| Technology | Purpose |
|---|---|
| Java | Application logic |
| JSP | Dynamic web pages |
| Servlets | Request handling and controllers |
| JDBC | Database connectivity |
| MySQL | Data storage |
| HTML, CSS, JavaScript | User interface |
| Maven | Dependency and build management |
| Apache Tomcat | Java web application server |
| Eclipse IDE | Development environment |

## Project Structure

```text
easyBuy/
├── src/
│   └── main/
│       ├── java/
│       │   └── easyBuy/
│       │       ├── controller/
│       │       ├── dao/
│       │       ├── model/
│       │       └── util/
│       └── webapp/
│           ├── css/
│           ├── images/
│           ├── js/
│           └── WEB-INF/
├── pom.xml
├── .gitignore
├── .project
├── .classpath
└── README.md
```

## Prerequisites

Install the following software before running the project:

- JDK compatible with the project's Java configuration
- Eclipse IDE with Maven support
- Apache Tomcat 10.1
- MySQL Server
- Git

## Database Configuration

1. Start your MySQL server.
2. Create the `ecommerce_db` database if it does not already exist.
3. Configure the required tables according to the SQL queries used by the application.
4. Set the database connection environment variables:

```text
EASYBUY_DB_USERNAME=your_mysql_username
EASYBUY_DB_PASSWORD=your_mysql_password
```

Use your own local credentials. Never publish actual passwords in this repository.

Check the database URL and connection settings in the application's database utility class.

## Run the Project in Eclipse

1. Clone or download this repository.
2. In Eclipse, select **File → Import → Maven → Existing Maven Projects**.
3. Select the project folder containing `pom.xml`.
4. Finish the import and allow Maven to resolve dependencies.
5. Configure Apache Tomcat in Eclipse.
6. Add the EasyBuy project to the Tomcat server.
7. Start the server.
8. Open the application's configured URL in your browser.

The local URL depends on the Tomcat port and deployed context path. For example:

```text
http://localhost:8081/easyBuy/
```

## Security Notes

- Database credentials should be supplied through environment variables.
- Do not commit passwords, API keys, tokens, or private customer data.
- Validate user input and use prepared statements for database queries.
- Configure HTTPS and production database access before public deployment.

## Deployment Status

EasyBuy is maintained as a Java web development and portfolio project. Public deployment requires a hosting environment that supports Java Servlets/JSP and a remotely accessible database.

## Future Improvements

- Improve input validation and error handling.
- Add automated tests.
- Improve accessibility and responsive design.
- Integrate a production payment gateway when appropriate.
- Deploy the application to a Java-compatible hosting service.

## Author

**Gogul R**

- GitHub: https://github.com/gogulrajendran13-stack
- LinkedIn: https://www.linkedin.com/in/gogul6006/

## Disclaimer

This project is intended for learning and portfolio demonstration. Review security, payment processing, and production configuration before using it commercially.
