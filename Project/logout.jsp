<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Logout</title>
</head>
<body>
    <%
        // Use the implicit session object to invalidate the session
        if (session != null) {
            session.invalidate(); // Ends the session
        }
        response.sendRedirect("index.jsp"); // Redirect to login page
    %>
</body>
</html>
