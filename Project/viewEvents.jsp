<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Management System</title>
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
        .header h1 {
            margin: 0;
            font-size: 24px;
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
        .content {
            padding: 20px;
            padding-bottom: 60px; /* Add padding to the bottom to avoid overlap with the footer */
        }
        .event {
            border: 1px solid #ddd;
            margin: 10px 0;
            padding: 10px;
            background-color: #fff;
        }
        .event h3 {
            margin: 0;
        }
        .footer {
            background-color: #333;
            color: white;
            text-align: center;
            padding: 10px;
            position: fixed;
            bottom: 0;
            width: 100%;
            z-index: 1000; /* Ensure it stays on top */
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

        .login-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .register-btn {
            background-color: #45a049;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
        }

        .register-btn:hover {
            background-color: #388e3c;
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

        .delete-btn {
            background-color: #f44336;
            color: white;
            padding: 5px 10px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .delete-btn:hover {
            background-color: #d32f2f;
        }

        .no-events {
            color: #f44336;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
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
            <a href="<%= "Login".equals(accountName) ? "login.jsp" : "#" %>" class="login-btn"><%= accountName %></a>
            <% if (!"Login".equals(accountName)) { %>
                <button class="logout-btn" onclick="window.location.href='logout.jsp'">Log Out</button>
            <% } %>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content">
        <h2>Your Registered Events</h2>
        <%
            String message = "";
            String dbURL = "jdbc:mysql://127.0.0.1:3306/event_management";
            String user = "root";
            String password = "Admin"; // Replace with your actual MySQL password

            // Declare userId variable outside the try block to make it accessible throughout the code
            String userId = null;

            try {
                // Load MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Establish connection
                Connection conn = DriverManager.getConnection(dbURL, user, password);

                // Get userId from session
                String username = (String) session.getAttribute("userName");

                if (username != null) {
                    // Fetch userId from the database using the username
                    String sqlUserId = "SELECT user_id FROM users WHERE username = ?";
                    PreparedStatement pstmtUserId = conn.prepareStatement(sqlUserId);
                    pstmtUserId.setString(1, username); // Set username parameter
                    ResultSet rsUserId = pstmtUserId.executeQuery();
                    if (rsUserId.next()) {
                        userId = rsUserId.getString("user_id"); // Get the userId
                    }
                    pstmtUserId.close();
                }

                // Check if userId is not null
                if (userId != null) {
                    // Query the events registered by the user using scrollable ResultSet
                    String sql = "SELECT e.event_id, e.name, e.date, e.location, e.price FROM events e " +
                                 "JOIN registrations r ON e.event_id = r.event_id WHERE r.user_id = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    pstmt.setString(1, userId); // Set userId parameter
                    ResultSet rs = pstmt.executeQuery();

                    // If no events are registered, show a message
                    if (!rs.next()) {
                        out.println("<p class='no-events'>You have no registered events.</p>");
                    } else {
                        // Reset the cursor to the beginning of the result set
                        rs.beforeFirst();

                        // Display registered events dynamically
                        while (rs.next()) {
                            out.println("<div class='event'>");
                            out.println("<h3>" + rs.getString("name") + "</h3>");
                            out.println("<p>Date: " + rs.getString("date") + "</p>");
                            out.println("<p>Location: " + rs.getString("location") + "</p>");
                            out.println("<p>Price: $" + rs.getString("price") + "</p>");

                            // Delete button with eventId as URL parameter
                            out.println("<form method='POST' style='display:inline;'>");
                            out.println("<input type='hidden' name='eventId' value='" + rs.getInt("event_id") + "' />");
                            out.println("<button type='submit' name='deleteEvent' class='delete-btn'>Delete</button>");
                            out.println("</form>");

                            out.println("</div>");
                        }
                    }

                    // Close resources
                    rs.close();
                    pstmt.close();
                } else {
                    message = "You are not logged in!";
                }

                conn.close();
            } catch (Exception e) {
                message = "Error fetching registered events: " + e.getMessage();
                out.println("<p style='color:red;'>" + message + "</p>");
            }

            // Handle event deletion
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String eventId = request.getParameter("eventId");

                if (eventId != null && userId != null) {
                    try {
                        // Connect to the database and delete the registration
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(dbURL, user, password);

                        // Prepare the delete statement
                        String deleteSql = "DELETE FROM registrations WHERE user_id = ? AND event_id = ?";
                        PreparedStatement pstmtDelete = conn.prepareStatement(deleteSql);
                        pstmtDelete.setString(1, userId); // Set userId
                        pstmtDelete.setInt(2, Integer.parseInt(eventId)); // Set eventId
                        int rows = pstmtDelete.executeUpdate();

                        // Check if the deletion was successful
                        if (rows > 0) {
                            message = "Event registration deleted successfully!";
                        } else {
                            message = "Error deleting the registration.";
                        }

                        pstmtDelete.close();
                        conn.close();
                    } catch (Exception e) {
                        message = "Error: " + e.getMessage();
                    }
                }
            }

            // Show success or error message
            if (!message.isEmpty()) {
                out.println("<p style='color: green;'>" + message + "</p>");
            }
        %>
    </div>

    <!-- Footer Section -->
    <div class="footer">
        <p>&copy; 2024 Event Management System</p>
    </div>

</body>
</html>
