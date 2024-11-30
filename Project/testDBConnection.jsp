<%@ page import="java.sql.*" %>
<html>
<head><title>Database Connection Test</title></head>
<body>
<h1>Testing Database Connection</h1>
<%
    String dbURL = "jdbc:mysql://127.0.0.1:3306/event_management";
    String user = "root";
    String password = "Admin"; // Replace with your actual MySQL password

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(dbURL, user, password);

        if (conn != null) {
            out.println("<p>Database connection successful!</p>");
        } else {
            out.println("<p>Database connection failed!</p>");
        }
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>