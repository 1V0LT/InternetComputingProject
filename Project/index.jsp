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

        .message {
            font-size: 16px;
            padding: 10px;
            margin-top: 20px;
            text-align: center;
        }

        .success {
            color: green;
        }

        .error {
            color: red;
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
            <a href="<%= "Login".equals(accountName) ? "login.jsp" : "#" %>" class="login-btn"><%= accountName %></a>
            <% if (!"Login".equals(accountName)) { %>
                <button class="logout-btn" onclick="window.location.href='logout.jsp'">Log Out</button>
            <% } %>
        </div>
    </div>

    <!-- Content Section -->
    <div class="content">
        <h2>Featured Events</h2>

        <%
            String message = "";
            String dbURL = "jdbc:mysql://127.0.0.1:3306/event_management";
            String user = "root";
            String password = "Admin"; // Replace with your actual MySQL password

            // Get eventId from request and userName from session
            String eventId = request.getParameter("eventId");
            String username = (String) session.getAttribute("userName"); // Get the username from session

            // Debugging: Check if username and eventId are available
            //out.println("<p>Debugging - Username: " + username + "</p>");
            //out.println("<p>Debugging - Event ID: " + eventId + "</p>");

            if (eventId != null && username != null) {
                try {
                    // Fetch userId from the database using the username
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(dbURL, user, password);

                    // Query to get userId from the database using username
                    String sqlUserId = "SELECT user_id FROM users WHERE username = ?";
                    PreparedStatement pstmtUserId = conn.prepareStatement(sqlUserId);
                    pstmtUserId.setString(1, username); // Set username parameter
                    ResultSet rsUserId = pstmtUserId.executeQuery();

                    // Check if the user exists and retrieve userId
                    if (rsUserId.next()) {
                        String userId = rsUserId.getString("user_id"); // Assuming user_id is of type String

                        // Now register the user for the event
                        String sqlRegister = "INSERT INTO registrations (user_id, event_id) VALUES (?, ?)";
                        PreparedStatement pstmtRegister = conn.prepareStatement(sqlRegister);
                        pstmtRegister.setString(1, userId); // Set the retrieved userId
                        pstmtRegister.setInt(2, Integer.parseInt(eventId)); // Set eventId

                        // Execute the insert query
                        int rows = pstmtRegister.executeUpdate();

                        // Check if the registration was successful
                        if (rows > 0) {
                            message = "<p class='success'>Successfully registered for the event!</p>";
                        } else {
                            message = "<p class='error'>Failed to register for the event. Please try again.</p>";
                        }
                    } else {
                        message = "<p class='error'>User not found in the database.</p>";
                    }

                    pstmtUserId.close();
                    conn.close();
                } catch (Exception e) {
                    message = "<p class='error'>Error: " + e.getMessage() + "</p>";
                    e.printStackTrace();
                }
            } else {
                //message = "<p class='error'>Event ID or Username not found!</p>";
            }

            // Display message if available
            out.println(message);

            // Fetch events and display them
            try {
                // Load MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(dbURL, user, password);

                // Query the database for events
                String sql = "SELECT event_id, name, date, location, price FROM events LIMIT 5";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);

                // Display events dynamically
                while (rs.next()) {
                    out.println("<div class='event'>");
                    out.println("<h3>" + rs.getString("name") + "</h3>");
                    out.println("<p>Date: " + rs.getString("date") + "</p>");
                    out.println("<p>Location: " + rs.getString("location") + "</p>");
                    out.println("<p>Price: $" + rs.getString("price") + "</p>");
                    // Register button with eventId as URL parameter
                    out.println("<a href='index.jsp?eventId=" + rs.getInt("event_id") + "' class='register-btn'>Register</a>");
                    out.println("</div>");
                }

                // Close resources
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>Error fetching events: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <!-- Footer Section -->
    <div class="footer">
        <p>&copy; 2024 Event Management System</p>
    </div>

</body>
</html>
