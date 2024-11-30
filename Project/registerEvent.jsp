<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register for Event</title>
</head>
<body>
    <h2>Register for an Event</h2>
    <form action="registerEventAction.jsp" method="POST">
        <label for="event_id">Event ID:</label>
        <input type="number" id="event_id" name="event_id" required /><br/><br/>

        <label for="user_id">Your User ID:</label>
        <input type="number" id="user_id" name="user_id" required /><br/><br/>

        <input type="submit" value="Register" />
    </form>
</body>
</html>
