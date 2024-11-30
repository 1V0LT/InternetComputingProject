<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%
    String user_id = request.getParameter("user_id");
    String event_id = request.getParameter("event_id");

    String dbURL = "jdbc:mysql://127.0.0.1:3306/event_management";
    String dbUser = "root";
    String dbPassword = "Admin"; // Replace with your actual MySQL password

    try {
        // Establish connection
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Insert registration into event_registrations table
        String insertSQL = "INSERT INTO event_registrations (user_id, event_id) VALUES (?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(insertSQL);
        pstmt.setString(1, user_id);
        pstmt.setString(2, event_id);
        pstmt.executeUpdate();

        // Optionally, update the event's registration count
        String updateSQL = "UPDATE events SET registrations_count = registrations_count + 1 WHERE event_id = ?";
        PreparedStatement updateStmt = conn.prepareStatement(updateSQL);
        updateStmt.setString(1, event_id);
        updateStmt.executeUpdate();

        out.println("<h3>You have successfully registered for the event!</h3>");

        // Close connections
        pstmt.close();
        updateStmt.close();
        conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>
