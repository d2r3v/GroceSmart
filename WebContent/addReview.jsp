<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Review</title>
    <%@ include file="header.jsp" %>
</head>
<body>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
%>
        <h1>You must be logged in to add a review!</h1>
        <a href="/shop/login.jsp">Go to Login</a>
<%
    } else {
        String productId = request.getParameter("productId");
        String reviewComment = request.getParameter("comment");
        String reviewRatingStr = request.getParameter("rating");

        if (productId == null || reviewComment == null || reviewRatingStr == null) {
%>
            <h1>Invalid Request</h1>
            <a href="/shop/listprod.jsp">Go Back to Products</a>
<%
        } else {
            int reviewRating = 0;

            try {
                reviewRating = Integer.parseInt(reviewRatingStr);

                // Validate rating is between 1 and 5
                if (reviewRating < 1 || reviewRating > 5) {
                    throw new NumberFormatException("Rating must be between 1 and 5");
                }

                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    // Check if user already has a review for this product
                    String checkReviewQuery = "SELECT * FROM review WHERE customerId = (SELECT customerId FROM customer WHERE userid = ?) AND productId = ?";
                    try (PreparedStatement psCheck = con.prepareStatement(checkReviewQuery)) {
                        psCheck.setString(1, authenticatedUser);
                        psCheck.setInt(2, Integer.parseInt(productId));

                        ResultSet rs = psCheck.executeQuery();
                        if (rs.next()) {
%>
                            <h1>You have already reviewed this product!</h1>
                            <a href="/shop/product.jsp?Id=<%= productId %>">Back to Product</a>
<%
                        } else {
                            // Add the review
                            String addReviewQuery = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, GETDATE(), (SELECT customerId FROM customer WHERE userid = ?), ?, ?)";
                            try (PreparedStatement psAdd = con.prepareStatement(addReviewQuery)) {
                                psAdd.setInt(1, reviewRating);
                                psAdd.setString(2, authenticatedUser);
                                psAdd.setInt(3, Integer.parseInt(productId));
                                psAdd.setString(4, reviewComment);

                                int rowsInserted = psAdd.executeUpdate();

                                if (rowsInserted > 0) {
%>
                                    <h1>Thank you for your review!</h1>
                                    <h3><a href="/shop/product.jsp?Id=<%= productId %>">Back to Product</a></h3>
<%
                                } else {
%>
                                    <h1>Failed to add review. Please try again later.</h1>
                                    <h3><a href="/shop/product.jsp?Id=<%= productId %>">Back to Product</a></h3>
<%
                                }
                            }
                        }
                    }
                }
            } catch (NumberFormatException e) {
%>
                <h1>Invalid review rating. It must be a number between 1 and 5.</h1>
                <a href="/shop/product.jsp?Id=<%= productId %>">Back to Product</a>
<%
            } catch (Exception e) {
%>
                <h1>Error: <%= e.getMessage() %></h1>
                <a href="/shop/product.jsp?Id=<%= productId %>">Back to Product</a>
<%
            }
        }
    }
%>
<%@ include file="Footer.jsp" %>
</body>
</html>
