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
			  <!-- Row 1 -->

				<% 

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";

		Integer s = 1;
		
			
		try ( Connection con = DriverManager.getConnection(url, uid, pw);
	          Statement stmt = con.createStatement();) 
	    {			
			 ResultSet rst = stmt.executeQuery("SELECT * FROM ordersummary");
			 NumberFormat currFormat = NumberFormat.getCurrencyInstance();


			 while(rst.next()){
				%> 			  
				<tr data-bs-toggle="collapse" data-bs-target="#subtable<%= s.intValue() %>" class="clickable">

				<td> <% out.print(rst.getInt("orderId")); %> </td> 
				<td> <% out.print(rst.getString("orderDate")); %> </td> 
				<td style="padding: 15px;"> <% out.print(rst.getInt("customerID")); %> </td> 
				<td > <% out.print(rst.getInt("orderId")); %> </td> 
				<td> <% out.print(currFormat.format(rst.getDouble("totalAmount"))); %> </td> <%
				
				ResultSet rst1 = stmt.executeQuery("select * from orderproduct where orderId = " + rst.getInt("orderId")); %>
			</tr>
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
			  <!-- More Rows can follow in similar format -->
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

