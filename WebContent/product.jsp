<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
<title>Your Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        .container {
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        .product-header {
            text-align: center;
            background: #007bff;
            color: white;
            padding: 15px;
        }
        .product-header h1 {
            margin: 0;
        }
        .product-details {
            display: flex;
            flex-wrap: wrap;
            padding: 20px;
        }
        .product-image {
            flex: 1;
            min-width: 300px;
            padding: 20px;
            text-align: center;
        }
        .product-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }
        .product-info {
            flex: 2;
            padding: 20px;
        }
        .product-info h2 {
            margin: 0 0 10px;
            color: #333;
        }
        .product-info p {
            line-height: 1.6;
            color: #666;
        }
        .product-price {
            font-size: 1.5em;
            color: #007bff;
            margin: 10px 0;
        }
        .buy-btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
        }
        .buy-btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    String productQuery = "SELECT * FROM product WHERE productId = ?";
    String reviewQuery = "SELECT r.reviewRating, r.reviewDate, r.reviewComment, c.firstName, c.lastName " +
                         "FROM review AS r " +
                         "JOIN customer AS c ON r.customerId = c.customerId " +
                         "WHERE r.productId = ?";
    String userReviewQuery = "SELECT reviewId FROM review WHERE productId = ? AND customerId = ?";
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");

    String productId = request.getParameter("Id");
    boolean hasReviewed = false;
    int customerId = -1;

    // Check if user is logged in
    if (authenticatedUser != null) {
        String userIdQuery = "SELECT customerId FROM customer WHERE userid = ?";
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement ps = con.prepareStatement(userIdQuery)) {
            ps.setString(1, authenticatedUser);
            ResultSet userRs = ps.executeQuery();
            if (userRs.next()) {
                customerId = userRs.getInt("customerId");
            }
        }
    }

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement productPs = con.prepareStatement(productQuery);
         PreparedStatement reviewPs = con.prepareStatement(reviewQuery);
         PreparedStatement userReviewPs = con.prepareStatement(userReviewQuery)) {

        // Fetch product details
        productPs.setString(1, productId);
        ResultSet productRs = productPs.executeQuery();

        if (productRs.next()) {
            String productName = productRs.getString("productName");
            String productPrice = productRs.getString("productPrice");
            String productImageURL = productRs.getString("productImageURL");
            String productDesc = productRs.getString("productDesc");

            // Check if the user has already reviewed this product
            if (customerId != -1) {
                userReviewPs.setString(1, productId);
                userReviewPs.setInt(2, customerId);
                ResultSet userReviewRs = userReviewPs.executeQuery();
                hasReviewed = userReviewRs.next();
            }
%>
            <div class="container">
                <div class="product-header">
                    <h1><%= productName %></h1>
                </div>
                <div class="product-details">
                    <div class="product-image">
                        <img src="<%= productImageURL %>" alt="<%= productName %>">
                        <% if (productRs.getString("productImage") != null) { %>
                        <img src="displayImage.jsp?id=<%= productId %>" alt="<%= productName %>">
                        <% } %>
                    </div>
                    <div class="product-info">
                        <h2>Description</h2>
                        <p><%= productDesc %></p>
                        <div class="product-price">$<%= productPrice %></div>
                        <a href="/shop/addcart.jsp?id=<%= productId %>&name=<%= productName %>&price=<%= productPrice %>" class="buy-btn">Buy Now</a>
                        <a href="/shop/listprod.jsp" class="buy-btn">Continue Shopping</a>
                    </div>
                </div>

                <div class="review-section">
                    <h2>Reviews</h2>
<%
                    // Fetch and display reviews
                    reviewPs.setString(1, productId);
                    ResultSet reviewRs = reviewPs.executeQuery();
                    if (!reviewRs.isBeforeFirst()) {
%>
                        <p>No reviews yet for this product.</p>
<%
                    } else {
                        while (reviewRs.next()) {
                            int rating = reviewRs.getInt("reviewRating");
                            String reviewDate = new SimpleDateFormat("MMM dd, yyyy").format(reviewRs.getDate("reviewDate"));
                            String reviewComment = reviewRs.getString("reviewComment");
                            String reviewerName = reviewRs.getString("firstName") + " " + reviewRs.getString("lastName");
%>
                            <div class="review">
                                <p><strong><%= reviewerName %></strong> - <%= reviewDate %></p>
                                <p>Rating: <%= rating %> / 5</p>
                                <p><%= reviewComment %></p>
                            </div>
<%
                        }
                    }

                    // If the user is logged in and hasn't reviewed this product, display the review form
                    if (authenticatedUser != null && !hasReviewed) {
%>
                    <h3>Write a Review</h3>
                    <form action="/shop/addReview.jsp" method="POST">
                        <input type="hidden" name="productId" value="<%= productId %>">
                        <label for="rating">Rating (1-5):</label>
                        <input type="number" id="rating" name="rating" min="1" max="5" required>
                        <br>
                        <label for="comment">Comment:</label>
                        <textarea id="comment" name="comment" rows="4" required></textarea>
                        <br>
                        <button type="submit" class="buy-btn">Submit Review</button>
                    </form>
<%
                    } else if (authenticatedUser == null) {
%>
                    <p><a href="/shop/login.jsp">Log in</a> to write a review.</p>
<%
                    } else if (hasReviewed) {
%>
                    <p>You have already reviewed this product.</p>
<%
                    }
%>
                </div>
            </div>
<%
        } else {
%>
        <h1>Product not found.</h1>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>
</body>
</html>