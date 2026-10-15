# EasyBuy — Java E-Commerce Web Application

EasyBuy is a Java-based e-commerce web application developed to demonstrate full-stack web development using Java, JSP, Servlets, JDBC, MySQL, HTML, CSS, and JavaScript.

The project follows a structured Java web application architecture with controllers, DAO classes, model classes, JSP views, and database connectivity. It is intended as a learning and portfolio project for demonstrating core Java and web development skills.

## Project Overview

- **Project Name:** EasyBuy
- **Project Type:** E-Commerce Web Application
- **Backend:** Java, Servlets, JSP, JDBC
- **Frontend:** HTML5, CSS3, JavaScript
- **Database:** MySQL
- **Build Tool:** Apache Maven
- **Development Environment:** Eclipse IDE
- **Application Server:** Apache Tomcat

## Features

The project includes pages and components for the following e-commerce workflows:

- User registration and login
- Product browsing and product details
- Shopping cart management
- Order and order-item pages
- Checkout and payment pages
- User profile
- Invite-a-friend page with sharing options
- Database connectivity using JDBC and MySQL
- Reusable Java controllers, DAO classes, and model classes
- CSS styling and JavaScript for the user interface

*Note: The availability of a page does not necessarily mean every workflow is fully production-ready. The project should be tested before presenting each feature as complete.*

## Technology Stack

| Technology | Purpose |
|---|---|
| Java | Application logic |
| Java Servlets | Handle HTTP requests and application workflows |
| JSP | Render dynamic web pages |
| JDBC | Connect Java code to MySQL |
| MySQL | Store application data |
| HTML5 | Structure web pages |
| CSS3 | Styling and responsive layouts |
| JavaScript | Client-side interactions |
| Apache Maven | Dependency and build management |
| Apache Tomcat | Run the Java web application |
| Eclipse IDE | Development environment |
| Git and GitHub | Version control and source-code hosting |

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
│           ├── WEB-INF/
│           ├── home.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── products.jsp
│           ├── product-details.jsp
│           ├── cart.jsp
│           ├── orders.jsp
│           ├── order.jsp
│           ├── payment.jsp
│           ├── profile.jsp
│           └── invite-friend.jsp
├── pom.xml
├── .gitignore
└── README.md
```

*This is a high-level structure. Some files may be added, removed, or organized differently as development continues.*

## Application Architecture

EasyBuy uses a layered structure:

1. **JSP views:** Display the user interface.
2. **Servlet controllers:** Receive HTTP requests and coordinate application actions.
3. **DAO layer:** Handles database operations.
4. **Model classes:** Represent application data.
5. **Database utility:** Manages JDBC connectivity to MySQL.

Typical request flow:

```text
User
  ↓
JSP Page
  ↓
Servlet Controller
  ↓
DAO Layer
  ↓
MySQL Database
  ↓
Controller returns response
  ↓
JSP Page
```

## Getting Started

### Prerequisites

Install the following software:

- Java Development Kit (JDK), compatible with your project configuration
- Eclipse IDE with Java web development support
- Apache Tomcat compatible with the Servlet API used by the project
- MySQL Server
- Apache Maven
- MySQL Connector/J dependency

### 1. Clone the Repository

Open a terminal and run:

```bash
git clone https://github.com/gogulrajendran13-stack/easyBuy.git
cd easyBuy
```

You can also download the repository as a ZIP file from GitHub.

### 2. Open the Project in Eclipse

1. Open Eclipse IDE.
2. Select **File → Import**.
3. Choose **Maven → Existing Maven Projects**.
4. Select the cloned `easyBuy` project folder.
5. Finish the import and wait for Maven dependencies to resolve.

If you use a different import option, ensure the project is recognized as a Maven Java web application.

### 3. Configure MySQL

1. Start MySQL Server.
2. Create the database named `ecommerce_db`, or update the database name to match your configuration.
3. Create the required tables using your project's database schema.
4. Configure the database credentials using environment variables.

The application expects these environment variable names:

```text
EASYBUY_DB_USERNAME
EASYBUY_DB_PASSWORD
```

Set their values on your own computer. Do not commit actual database passwords to GitHub.

The database schema and sample data must be supplied separately if they are not included in this repository.

### 4. Configure the Database Connection

The database utility uses a JDBC connection to MySQL. Verify that:

- MySQL Server is running.
- The database exists.
- The username and password are correct.
- MySQL Connector/J is available through Maven.
- The JDBC URL and timezone settings match your environment.

Never publish real credentials or private customer data.

### 5. Run the Application

1. Start Eclipse.
2. Configure a compatible Apache Tomcat server.
3. Add the `easyBuy` project to the server.
4. Start the server.
5. Open the application using the context path and port configured in Eclipse.

For example, your local URL may resemble:

```text
http://localhost:8081/easyBuy/
```

The exact URL depends on your Tomcat port and application context path.

## Security Notes

- Database credentials should be provided through environment variables.
- Do not commit passwords, access tokens, or private configuration files.
- Do not upload customer records or production database backups.
- Use parameterized SQL queries for database operations.
- Validate and sanitize user input.
- Use HTTPS and secure session handling before deploying a public production application.

## Current Deployment Status

- **Source code:** Available on GitHub
- **Local development:** Eclipse and Apache Tomcat
- **Public live deployment:** To be configured

A traditional Java Servlet/JSP application requires a compatible Java web server. Static hosting alone does not execute JSP pages or run Java Servlets.

## Screenshots

Screenshots of the home page, product listing, product details, cart, and checkout can be added here after capturing them from the running application.

Example:

```text
Add application screenshots here.
```

## Future Improvements

- Deploy the application to a suitable Java web hosting environment.
- Provide a database schema and safe sample data for easier setup.
- Add automated tests.
- Improve responsive design and accessibility.
- Add production-grade logging and error handling.
- Review authentication, authorization, and payment security before production use.

## Author

**GOGUL R**

- GitHub: https://github.com/gogulrajendran13-stack
- LinkedIn: https://www.linkedin.com/in/gogul6006/

## Disclaimer

EasyBuy is a portfolio and learning project. Review the implementation, database setup, security controls, and payment flow before using it for real customers or production transactions.
