<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register User</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        .header {
            background-color: #4CAF50;
            padding: 20px;
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
            width: 30%;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px #ccc;
        }
        .form-container input,
        .form-container button {
            width: 100%;
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
        }
        .form-container button {
            background-color: #4CAF50;
            color: white;
            border: none;
        }
        .form-container button:hover {
            background-color: #45a049;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            width: 100%;
            z-index: 1000;
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
    </div>

    <!-- Registration Form Section -->
    <div class="form-container">
        <h2>Create an Account</h2>
        <form action="registerUser.jsp" method="post">
            <label for="username">Username:</label><br>
            <input type="text" id="username" name="username" required><br><br>

            <label for="password">Password:</label><br>
            <input type="password" id="password" name="password" required><br><br>

            <label for="role">Role (admin/user):</label><br>
            <input type="text" id="role" name="role" required><br><br>

            <button type="submit">Register</button>
        </form>

        <%
            // Declare the PreparedStatements and ResultSet outside the try block
            PreparedStatement checkStmt = null;
            PreparedStatement insertStmt = null;
            Connection conn = null;
            ResultSet rs = null;

            if (request.getMethod().equalsIgnoreCase("POST")) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String role = request.getParameter("role");

                try {
                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/event_management", "root", "Admin"); // Replace with your password

                    // Check if the username already exists
                    String checkUserSql = "SELECT username FROM users WHERE username = ?";
                    checkStmt = conn.prepareStatement(checkUserSql);
                    checkStmt.setString(1, username);
                    rs = checkStmt.executeQuery();

                    if (rs.next()) {
                        out.println("<p style='color: red;'>Username already exists. Please choose another username.</p>");
                    } else {
                        // Insert new user into the users table
                        String insertUserSql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
                        insertStmt = conn.prepareStatement(insertUserSql);
                        insertStmt.setString(1, username);
                        insertStmt.setString(2, password);
                        insertStmt.setString(3, role);

                        int rowsInserted = insertStmt.executeUpdate();

                        if (rowsInserted > 0) {
                            out.println("<p style='color: green;'>User registered successfully! You can now <a href='login.jsp'>login</a>.</p>");
                        }
                    }

                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Close resources in the finally block to ensure they are always closed
                    try {
                        if (rs != null) rs.close();
                        if (checkStmt != null) checkStmt.close();
                        if (insertStmt != null) insertStmt.close();
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
