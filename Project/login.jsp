<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }

        .header {
            background-color: #4CAF50;
            padding: 2px;
            color: white;
            text-align: center;
        }

        .navbar {
            background-color: #4CAF50;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar nav {
            display: flex;
            gap: 15px;
        }

        .navbar nav a {
            color: white;
            text-decoration: none;
            font-size: 16px;
        }

        .navbar nav a:hover {
            text-decoration: underline;
        }

        .navbar .account {
            color: white;
            text-decoration: none;
            position: relative;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-container {
            margin: 50px auto;
            width: 90%;
            max-width: 400px;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px #ccc;
            display: flex;
            flex-direction: column; /* Stack buttons vertically */
        }

        .form-container label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-container input {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px; /* Adjust spacing between inputs */
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .form-container button {
            width: 100%; /* Ensure both buttons take the same full width */
            padding: 15px; /* Make buttons bigger */
            background-color: #45a049; /* Same background color for both buttons */
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 18px; /* Increase font size */
            margin-bottom: 10px; /* Space between buttons */
            text-align: center; /* Center the text inside the buttons */
        }

        .form-container button:hover {
            background-color: #388e3c;
        }

        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <div class="header">
        <h1>Event Management System</h1>
    </div>

    <!-- Navigation Bar -->
    <div class="navbar">
        <nav>
            <a href="index.jsp" class="nav-btn">Home</a>
        </nav>
        <div class="account">
        </div>
    </div>

    <!-- Form Section -->
    <div class="form-container">
        <h2>Login</h2>
        <form action="login.jsp" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required><br><br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required><br><br>

            <button type="submit">Login</button>
        </form>

        <!-- Register Button directly under the Login button -->
        <form action="registerUser.jsp" method="get">
            <button type="submit" class="register-btn">Register</button>
        </form>

        <%
            // Declare all necessary resources outside the try block for proper scope
            PreparedStatement checkStmt = null;
            Connection conn = null;
            ResultSet rs = null;

            // Check if the form is submitted
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                try {
                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/event_management", "root", "Admin"); // Replace with your password

                    // Query to check user credentials and fetch the role
                    String sql = "SELECT username, role FROM users WHERE username = ? AND password = ?";
                    checkStmt = conn.prepareStatement(sql);
                    checkStmt.setString(1, username);
                    checkStmt.setString(2, password); // Password is checked in plain text, consider hashing in production

                    // Execute query
                    rs = checkStmt.executeQuery();

                    if (rs.next()) {
                        // Successful login
                        String userName = rs.getString("username");
                        String role = rs.getString("role"); // Fetch the role from the database

                        // Store the username and role in the session
                        session.setAttribute("userName", userName);
                        session.setAttribute("role", role);

                        // Redirect based on user role
                        if ("admin".equals(role)) {
                            response.sendRedirect("index.jsp"); // Redirect to admin page if role is admin
                        } else {
                            response.sendRedirect("index.jsp"); // Redirect to regular user home page
                        }
                    } else {
                        out.println("<p style='color: red;'>Invalid username or password!</p>");
                    }

                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Close resources in the finally block to ensure they are always closed
                    try {
                        if (rs != null) rs.close();
                        if (checkStmt != null) checkStmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        %>
    </div>

    <!-- Footer Section -->
    <div class="footer">
        <p>&copy; 2024 Event Management System</p>
    </div>

</body>
</html>
