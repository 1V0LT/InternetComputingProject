<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register for Event</title>
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
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            width: 100%;
        }

        .nav-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .nav-btn:hover {
            background-color: #45a049;
        }

        .logout-btn {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .logout-btn:hover {
            background-color: #d32f2f;
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
                <button class="logout-btn" onclick="window.location.href='logout.jsp'">Log Out</button>
            <% } %>
        </div>
    </div>

    <!-- Registration Form Section -->
    <div class="form-container">
        <h2>Register for an Event</h2>
        <form action="register.jsp" method="post">
            <label for="name">Name:</label><br>
            <input type="text" id="name" name="name" required><br><br>
            <label for="email">Email:</label><br>
            <input type="email" id="email" name="email" required><br><br>
            <label for="event_id">Event ID:</label><br>
            <input type="number" id="event_id" name="event_id" required><br><br>
            <button type="submit">Register</button>
        </form>

        <%
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String event_id = request.getParameter("event_id");

                try {
                    // Database connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/event_management", "root", "Admin"); // Replace with your password
                    String sql = "INSERT INTO registrations (name, email, event_id) VALUES (?, ?, ?)";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, name);
                    pstmt.setString(2, email);
                    pstmt.setInt(3, Integer.parseInt(event_id));
                    int rows = pstmt.executeUpdate();

                    if (rows > 0) {
                        out.println("<p style='color: green;'>Successfully registered for the event!</p>");
                    } else {
                        out.println("<p style='color: red;'>Failed to register. Please try again.</p>");
                    }

                    pstmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                }
            }
        %>
    </div>

    <div class="footer">
        <p>&copy; 2024 Event Management System</p>
    </div>
</body>
</html>
