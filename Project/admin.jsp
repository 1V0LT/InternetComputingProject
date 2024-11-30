<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: white;
        }
        .header .title {
            margin: 0;
        }
        .header nav {
            display: flex;
            gap: 10px;
        }
        .header nav a {
            color: white;
            text-decoration: none;
            margin: 0 10px;
        }
        .header nav a:hover {
            text-decoration: underline;
        }
        .header .account {
            margin-left: auto;
        }
        .form-container {
            margin: 50px auto;
            width: 50%;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px #ccc;
        }
        .form-container h2 {
            margin-bottom: 20px;
        }
        .form-container label {
            font-size: 16px;
            margin-bottom: 5px;
            display: block;
        }
        .form-container input {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }
        .form-container button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
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
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <div class="header">
        <h1 class="title">Event Management System</h1>
        <nav>
            <a href="index.jsp" class="nav-btn">Home</a>
            <a href="viewEvents.jsp" class="nav-btn">View Events</a>
            <%
                // Check login status and role
                String accountName = "Login";
                String role = "user"; // Default role
                if (session != null && session.getAttribute("userName") != null) {
                    accountName = (String) session.getAttribute("userName");
                    role = (String) session.getAttribute("role"); // Retrieve role from session
                }

                // Only display Admin link if user is an admin
                if ("admin".equals(role)) {
            %>
                <a href="admin.jsp" class="nav-btn">Admin</a>
            <% } %>
        </nav>
        <div class="account">
            <%
                String accountLink = (accountName.equals("Login")) ? "login.jsp" : "account.jsp";
            %>
            <a href="<%= accountLink %>" style="color: white; text-decoration: none;"><%= accountName %></a>
            <% if (!"Login".equals(accountName)) { %>
                <button class="nav-btn" onclick="window.location.href='logout.jsp'">Log Out</button>
            <% } %>
        </div>
    </div>

    <!-- Admin Dashboard Form Section -->
    <div class="form-container">
        <h2>Admin Dashboard</h2>
        <form action="admin.jsp" method="post">
            <label for="name">Event Name:</label>
            <input type="text" id="name" name="name" required><br><br>

            <label for="date">Date:</label>
            <input type="date" id="date" name="date" required><br><br>

            <label for="location">Location:</label>
            <input type="text" id="location" name="location" required><br><br>

            <label for="price">Price:</label>
            <input type="number" id="price" name="price" required><br><br>

            <button type="submit">Add Event</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String name = request.getParameter("name");
                String date = request.getParameter("date");
                String location = request.getParameter("location");
                String price = request.getParameter("price");

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/event_management", "root", "Admin");
                    String sql = "INSERT INTO events (name, date, location, price) VALUES (?, ?, ?, ?)";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, name);
                    pstmt.setString(2, date);
                    pstmt.setString(3, location);
                    pstmt.setDouble(4, Double.parseDouble(price));
                    int rows = pstmt.executeUpdate();

                    if (rows > 0) {
                        out.println("<p style='color: green;'>Event added successfully!</p>");
                    } else {
                        out.println("<p style='color: red;'>Failed to add event.</p>");
                    }

                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
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
