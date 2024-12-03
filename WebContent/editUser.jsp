<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User Information</title>
    <%@ include file="header.jsp" %>
</head>
<body>
<%
    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // Check if the user is authenticated
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
%>
        <h1>You are not logged in!</h1>
        <h2><a href="/shop/login.jsp">Go to Login Page</a></h2>
<%
        return;
    }

    // Fetch user details from the database
    String firstName = "";
    String lastName = "";
    String email = "";
    String phonenum = "";
    String address = "";
    String city = "";
    String state = "";
    String postalCode = "";
    String country = "";

    String query = "SELECT * FROM customer WHERE userid = ?";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setString(1, authenticatedUser);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            phonenum = rs.getString("phonenum");
            address = rs.getString("address");
            city = rs.getString("city");
            state = rs.getString("state");
            postalCode = rs.getString("postalCode");
            country = rs.getString("country");
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        return;
    }
%>

<h1>Edit Your Information</h1>
<form action="processEditUser.jsp" method="post">
    <label for="firstName">First Name:</label>
    <input type="text" id="firstName" name="firstName" value="<%= firstName %>" required /><br/>

    <label for="lastName">Last Name:</label>
    <input type="text" id="lastName" name="lastName" value="<%= lastName %>" required /><br/>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" value="<%= email %>" required /><br/>

    <label for="phonenum">Phone Number:</label>
    <input type="text" id="phonenum" name="phonenum" value="<%= phonenum %>" required /><br/>

    <label for="address">Address:</label>
    <input type="text" id="address" name="address" value="<%= address %>" required /><br/>

    <label for="city">City:</label>
    <input type="text" id="city" name="city" value="<%= city %>" required /><br/>

    <label for="state">State:</label>
    <input type="text" id="state" name="state" value="<%= state %>" required /><br/>

    <label for="postalCode">Postal Code:</label>
    <input type="text" id="postalCode" name="postalCode" value="<%= postalCode %>" required /><br/>

    <label for="country">Country:</label>
    <input type="text" id="country" name="country" value="<%= country %>" required /><br/>

    <button type="submit">Save Changes</button>
</form>

<h2><a href="/shop/index.jsp">Cancel</a></h2>
<%@ include file="Footer.jsp" %>
</body>
</html>
