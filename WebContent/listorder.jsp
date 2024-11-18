<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3cEf5zq1p9s+p12k+kk726zsYGk0u41GWzUqLJM9MQyTqKGHxlIUAXnQv4n1v2hRZg4" crossorigin="anonymous">
	<style>
		.subtable td, .subtable th {
		  padding: 8px;
		  border: 1px solid #ddd;
		}
	  </style>
<title> Grocery Order List</title>
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
							<li class = "active"><a href='/shop/listorder.jsp'>Order List</a></li>
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
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C89scichPD02hX1v7vXRs024ppR2oZYtQv2lSR7ijD5Exx1GlgQlWWYPbFOptLWN9" crossorigin="anonymous"></script>

	
	<div class="container mt-5">
		<h2 class="text-center mb-4">Order List</h2>
		<div class="table-responsive">
		  <table class="table table-striped table-hover table-bordered">
			<thead class="table-dark">
			  <tr>
				<th style = "padding: 5px;">Order Id</th>
				<th style = "padding: 5px;">Order Date</th>
				<th style = "padding: 5px;">Customer Id</th>
				<th style = "padding: 5px;">Customer Name</th>
				<th style = "padding: 5px;">Total Amount</th>
			  </tr>
			</thead>
			<tbody>
			  

				<% 

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";

		Integer s = 1;
		
			
		try ( Connection con = DriverManager.getConnection(url, uid, pw);
	          Statement stmt = con.createStatement();
			  Statement st = con.createStatement();) 
	    {			
			 ResultSet rst = stmt.executeQuery("SELECT * FROM ordersummary as o join customer as c on c.customerId = o.customerId ");
			 NumberFormat currFormat = NumberFormat.getCurrencyInstance();


			 while(rst.next()){
				%> 			  
				<tr data-bs-toggle="collapse" data-bs-target="#subtable<%= s.intValue() %>" class="clickable">

				<td> <% out.print(rst.getInt("orderId")); %> </td> 
				<td> <% out.print(rst.getString("orderDate")); %> </td> 
				<td style="padding: 15px;"> <% out.print(rst.getInt("customerID")); %> </td> 
				<td > <% out.print(rst.getString("firstName") + "  " + rst.getString("lastName") ); %> </td> 
				<td> <% out.print(currFormat.format(rst.getDouble("totalAmount"))); %> </td> </tr> <%
				
				ResultSet rst1 = st.executeQuery("select * from orderproduct where orderId = " + rst.getInt("orderId")); %>
			
			<tr id= "subtable<%= s.intValue() %>" class="collapse">
			  <td colspan="7">
				<table class="table subtable">
				  <thead>
					<tr>
					  <th>Product Id</th>
					  <th>Quantity</th>
					  <th>Price</th>
					</tr>
				  </thead>
				  <tbody>
					<% 
					  while(rst1.next()){
						%> 
						<tr>
							<td> <% out.print(rst1.getInt("productId")); %></td>
							<td> <% out.print(rst1.getInt("quantity")); %></td>
							<td> <% out.print(currFormat.format(rst1.getDouble("price"))); %></td>
						</tr> <%
					  } %>

				  </tbody>
				  </table>
				  </td>
				  </tr> <%
					rst1.close();
					s++;
			 } 

		}
		catch (SQLException ex)
		{
			System.err.println("SQLException: " + ex);
		}		

%>	  
			</tbody>
		  </table>
		</div>
	  </div>  

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);  // Prints $5.00

// Make connection

// Write query to retrieve all order summary records

// For each order in the ResultSet

	// Print out the order summary information
	// Write a query to retrieve the products in the order
	//   - Use a PreparedStatement as will repeat this query many times
	// For each product in the order
		// Write out product information 

// Close connection
%>

</body>
</html>

