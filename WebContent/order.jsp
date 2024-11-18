<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>YOUR NAME Grocery Order Processing</title>
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
							<li><a href="/shop/listprod.html">Products</a></li>
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
</head>
<body>


<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message

if (productList == null){ %>
	<h1> No Items in Cart</h1>
	<h2><a href = "/shop/listprod.jsp">Continue Shopping</a></h2> <%
} else {

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";

	String query = "Insert into ordersummary (orderDate,customerId) values (CURRENT_TIMESTAMP,?);";
	String query2 = "UPDATE ordersummary SET totalAmount = ? where orderId = ?";
	String query1 = "Insert into orderproduct values (?,?,?,?);";

		
	try ( Connection con = DriverManager.getConnection(url, uid, pw);
		  Statement stmt = con.createStatement();
		PreparedStatement pstmt = con.prepareStatement(query,stmt.RETURN_GENERATED_KEYS);
		PreparedStatement ps1 = con.prepareStatement(query1);
		PreparedStatement ps2 = con.prepareStatement(query2);) 
	{			

		pstmt.setString(1,custId);

		pstmt.executeUpdate();

		ResultSet keys = pstmt.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);

		Double Total = 0.0; %>

		
		<h3> Order Placed!</h3>
		<h3> Your Order Refrence Number is <% out.println(orderId); %></h3>

		<div class="container">
			<h2>Your Order Summary</h2>
			<table class="table table-bordered">
				<thead>
					<tr>
						<th>Product Id</th>
						<th>Quantity</th>
						<th>Price</th>
					</tr>
				</thead>
				<tbody> 
					<%

		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
			while (iterator.hasNext())
			{ 
				Map.Entry<String, ArrayList<Object>> entry = iterator.next();
				ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
				String productId = (String) product.get(0);
				String price = (String) product.get(2);
				double pr = Double.parseDouble(price);
				int qty = ( (Integer)product.get(3)).intValue();
					ps1.setInt(1,orderId);
					ps1.setString(2,productId);
					ps1.setInt(3,qty);
					ps1.setDouble(4,pr);
					Total += pr;
					ps1.executeUpdate();

					%>

					<tr>
						<td><% out.println(productId); %> </td>
						<td><% out.println(qty); %> </td>
						<td><% out.println(pr); %> </td>
					</tr> <%
			}

			ps2.setDouble(1,Total);
			ps2.setInt(2,orderId);
			ps2.executeQuery();

	}catch(Exception e){
		e.printStackTrace();
	} %> </tbody> </table> </div> <%

	session.removeAttribute("productList");

}

// Make connection

// Save order information to database


	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/

// Insert each item into OrderProduct table using OrderId from previous INSERT

// Update total amount for order record

// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price

/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/

// Print out order summary

// Clear cart if order placed successfully
%>
</BODY>
</HTML>

