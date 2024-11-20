<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

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
 
<%@ include file="header.jsp" %>

<% String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";

        String query = "SELECT * FROM product where productId = ?";

            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                PreparedStatement ps = con.prepareStatement(query);
                
                Statement stmt = con.createStatement();
                ) {

                    String n = request.getParameter("Id");

                    ps.setString(1,n);
                    ResultSet rs = ps.executeQuery();

                    if (rs.next()) {
                        String productName = rs.getString("productName");
                        String productPrice = rs.getString("productPrice");
                        String productImageURL = rs.getString("productImageURL");
                        String productDesc = rs.getString("productDesc");
                        
            %>
            <div class="container">
                <div class="product-header">
                    <h1><%= productName %></h1>
                </div>
                <div class="product-details">
                    <div class="product-image">
                        <img src="<%= productImageURL %>" alt="<%= productName %>"> <% if (rs.getString("productImage") != null){
                            %>
                        <img src="displayImage.jsp?id=<%= n %>" alt="<%= productName %>">
                        <% } %>
                    </div>
                    <div class="product-info">
                        <h2>Description</h2>
                        <p><%= productDesc %></p>
                        <div class="product-price">$<%= productPrice %></div>
                        <a href="/shop/addcart.jsp?id=<%= n %>&name=<%= productName %>&price=<%= productPrice %>" class="buy-btn">Buy Now</a>
                        <a href="/shop/listprod.jsp" class="buy-btn">Continue Shopping</a>

                    </div>
                </div>
            </div>
<% 
}
}catch (Exception e){
    out.println(e);
}
%>

<%

// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

