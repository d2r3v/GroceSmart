<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Process Edit User</title>
    <%@ include file="header.jsp" %>
</head>
<body>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // Get form data
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    // Regular expressions for validation
    String nameRegex = "^[A-Za-z]+$";
    String phoneRegex = "^[0-9]+$";
    String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    boolean hasErrors = false;
    StringBuilder errorMessage = new StringBuilder("<h1>Error:</h1><ul>");

    if (firstName == null || !firstName.matches(nameRegex)) {
        hasErrors = true;
        errorMessage.append("<li>First name must contain only alphabets.</li>");
    }
    if (lastName == null || !lastName.matches(nameRegex)) {
        hasErrors = true;
        errorMessage.append("<li>Last name must contain only alphabets.</li>");
    }
    if (email == null || !email.matches(emailRegex)) {
        hasErrors = true;
        errorMessage.append("<li>Invalid email format.</li>");
    }
    if (phonenum == null || !phonenum.matches(phoneRegex)) {
        hasErrors = true;
        errorMessage.append("<li>Phone number must contain only digits.</li>");
    }

    errorMessage.append("</ul>");

    // If there are validation errors, display them and stop processing
    if (hasErrors) {
        out.println(errorMessage.toString());
        out.println("<h2><a href='editUser.jsp'>Go Back</a></h2>");
        return;
    }

    // Update user details in the database
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    String updateQuery = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE userid = ?";

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(updateQuery)) {

        ps.setString(1, firstName);
        ps.setString(2, lastName);
        ps.setString(3, email);
        ps.setString(4, phonenum);
        ps.setString(5, address);
        ps.setString(6, city);
        ps.setString(7, state);
        ps.setString(8, postalCode);
        ps.setString(9, country);
        ps.setString(10, authenticatedUser);

        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<h1>Your information has been updated successfully!</h1>");
        } else {
            out.println("<h1>Failed to update your information.</h1>");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<h2><a href="/shop/index.jsp">Go to Homepage</a></h2>
</body>
</html>
