<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery</title>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Display</title>
    <!-- Link to Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-pzjw8f+ua7Kw1TIq0R2F3P6twxoFf13iTxH28m41jxFTJt2kOk/2pwrXo6v1YgDz" crossorigin="anonymous">
    <style>
        .product-card {
            border: 8px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            transition: transform 0.3s ease-in-out;
        }
        .product-card:hover {
            transform: translateY(-10px);
        }
        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .product-category {
            font-size: 14px;
            color: #007bff;
            font-weight: bold;
        }
        .product-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }
        .product-price {
            font-size: 1.1rem;
            color: #28a745;
            font-weight: bold;
        }

    </style>
    
    <head>
        <meta charset="utf-8"/>
        <title>Your Groccery Store</title>
        <meta name="viewport" content="width=device-width"/>
        <meta name="description" content=""/>
        <meta name="author" content=""/>
        <link href="//cdn.ubc.ca/clf/7.0.5/css/ubc-clf-full.min.css" rel="stylesheet"/>
        <link href="css/unit.css" rel="stylesheet"/>
       
        </head> 
        <routing />
        <body class="full-width full-width-left">
            <div id="unit" class="row-fluid expand">
              <div class="container">
                  <div class="span12">
                      <div class="navbar">
                          <a class="btn btn-navbar" data-toggle="collapse" data-target="#unit-navigation">
                              <span class="icon-bar"></span>
                              <span class="icon-bar"></span>
                              <span class="icon-bar"></span>
                          </a>
                      </div>
                      <div id="unit-name">
                          <a href="/shop/shop.html"><span id="unit-faculty">Your Supermart</span><span id="unit-identifier"></span></a>
                      </div>
                  </div>
            </div>
            </div>

            <div id="unit-menu" class="navbar expand" role="navigation">
                <div class="navbar-inner expand">
                    <div class="container">
                        <div class="nav-collapse collapse" id="unit-navigation">
                            <ul class="nav">
                                <li><a href="/shop/shop.html">Home</a></li>
                                <li class="active"><a href="/shop/listprod.html">Products</a></li>
                                <li><a href='/shop/listorder.jsp'>Order List</a></li>
                                <li><a href="/shop/showcart.jsp">Cart</a></li>
                                        </ul>
                                    </div> 
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

<h1>Search for the products you want to buy:</h1>

<div class="form-container">
    <form method="get" action="listprod.jsp">
        <div class="form-group">
            <label for="productName">Product Name:</label>
            <input type="text" name="productName" id="productName" size="50" placeholder="Enter product name" class="input-field">
        </div>
        <div class="form-group">
            <label for="category">Category:</label>
            <select name="category" id="category" class="input-field">
                <option value="">-- Select a Category --</option>
                <option value="Beverages">Beverages</option>
                <option value="Condiments">Condiments</option>
                <option value="Dairy Products">Dairy Products</option>
                <option value="Produce">Produce</option>
                <option value="Meat/Poultry">Meat/Poultry</option>
                <option value="Seafood">Seafood</option>
                <option value="Confections">Confections</option>
                <option value="Grains/Cereals">Grains/Cereals</option>
            </select>
        </div>

        <div class="form-buttons">
            <input type="submit" value="Search" class="btn btn-submit">
            <input type="reset" value="Reset" class="btn btn-reset">
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C89scichPD02hX1v7vXRs024ppR2oZYtQv2lSR7ijD5Exx1GlgQlWWYPbFOptLWN9" crossorigin="anonymous"></script>

<div class="container mt-5">
    <h2 class="text-center mb-4">Product List</h2>
    <div class="row" id="productGrid">
        <% String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";

        String query = "SELECT * FROM product as p join category as c on p.categoryId = c.categoryId where p.productName LIKE ? and c.categoryName LIKE ?";

            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                PreparedStatement ps = con.prepareStatement(query);
                
                Statement stmt = con.createStatement();
                ) {

                    String n = request.getParameter("productName");
                    String c = request.getParameter("category");


                    if (n != null && !n.isEmpty()){
                        ps.setString(1,"%" + n + "%");
                    } else {
                       ps.setString(1,"%_%");
                    }
                    

                    if (c != null && !c.isEmpty()){
                        ps.setString(2,"%" + c + "%");
                    } else {
                       ps.setString(2,"%_%");
                    }

                    ResultSet rs = ps.executeQuery();

                    
                    // Number format for price display
                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
                    

                    // Loop through the result set and render each product
                    while (rs.next()) {
                        
                        String s = rs.getString("productImageURL");
                        int id = rs.getInt("productId");
                        String name = rs.getString("productName");
                        Double price = rs.getDouble("productPrice");
            %>
                    <div class="col-md-4 mb-4">
                        <div class="card product-card">
                            <img src= <%= s %> alt="<%= rs.getString("productName") %>" class="card-img-top product-image">
                            <div class="card-body">
                                <h5 class="card-title product-name"><%= rs.getString("productName") %></h5>
                                <p class="product-category"><%= rs.getString("categoryName") %></p>
                                <p class="card-text"><%= rs.getString("productDesc") %></p>
                                <p class="product-price"><%= currencyFormat.format(rs.getDouble("productPrice")) %></p>
                                <a href = "/shop/addcart.jsp?id=<%= id %>&name=<%= name %>&price=<%= price %>" style="text-decoration: none;"> Add to cart</a>
                            </div>
                        </div>
                    </div>
        <% 
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println(e);
            }
        %>
    </div>
</div>
</body>
</html>