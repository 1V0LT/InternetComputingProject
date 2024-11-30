<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        .content {
            margin: 50px auto;
            width: 50%;
            text-align: center;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 10px #ccc;
        }
        .logout {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="content">
        <%
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userName") != null) {
                String userName = (String) session.getAttribute("userName");
        %>
                <h2>Welcome, <%= userName %>!</h2>
                <form action="logout.jsp" method="post" class="logout">
                    <button type="submit">Logout</button>
                </form>
        <%
            } else {
                response.sendRedirect("login.jsp");
            }
        %>
    </div>
</body>
</html>
