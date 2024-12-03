<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Create New User</title>
    <%@ include file="header.jsp" %>
</head>
<body>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";        
    String uid = "sa";
    String pw = "304#sa#pw";
    boolean Authenticated = false;

    String query = "SELECT * FROM customer WHERE userid = ? AND isAdmin = 1";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setString(1, (String) session.getAttribute("authenticatedUser"));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Authenticated = true;
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }

    if (!Authenticated) {
%>
        <h2>You do not have Admin Access.</h2>
        <a href="/shop/login.jsp" class="buy-btn">Go to Login Page</a>
<%
        return; // Prevent further code from executing
    }
%>

<h1>Create a New User</h1>
<form method="post" action="processCreateUser.jsp">
    <table>
        <tr>
            <td>First Name:</td>
            <td><input type="text" name="firstName" required maxlength="40"></td>
        </tr>
        <tr>
            <td>Last Name:</td>
            <td><input type="text" name="lastName" required maxlength="40"></td>
        </tr>
        <tr>
            <td>Email:</td>
            <td><input type="email" name="email" required maxlength="50"></td>
        </tr>
        <tr>
            <td>Phone Number:</td>
            <td><input type="text" name="phonenum" required maxlength="20"></td>
        </tr>
        <tr>
            <td>Address:</td>
            <td><input type="text" name="address" required maxlength="50"></td>
        </tr>
        <tr>
            <td>City:</td>
            <td><input type="text" name="city" required maxlength="40"></td>
        </tr>
        <tr>
            <td>State:</td>
            <td><input type="text" name="state" required maxlength="20"></td>
        </tr>
        <tr>
            <td>Postal Code:</td>
            <td><input type="text" name="postalCode" required maxlength="20"></td>
        </tr>
        <tr>
            <td>Country:</td>
            <td><input type="text" name="country" required maxlength="40"></td>
        </tr>
        <tr>
            <td>User ID:</td>
            <td><input type="text" name="userid" required maxlength="20"></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="password" required maxlength="30"></td>
        </tr>
        <tr>
            <td>Is Admin:</td>
            <td>
                <input type="checkbox" name="isAdmin" value="1"> (Check to grant admin privileges)
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <input type="submit" value="Create User">
            </td>
        </tr>
    </table>
</form>

<h2><a href="admin.jsp">Back to Admin Dashboard</a></h2>
<%@ include file="Footer.jsp" %>
</body>
</html>
