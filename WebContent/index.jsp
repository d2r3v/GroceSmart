<!DOCTYPE html>
<html>
<head>
        <title>Your Grocery Main Page</title>
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3cEf5zq1p9s+p12k+kk726zsYGk0u41GWzUqLJM9MQyTqKGHxlIUAXnQv4n1v2hRZg4" crossorigin="anonymous">
	<style>
		.subtable td, .subtable th {
		  padding: 8px;
		  border: 1px solid #ddd;
		}
	  </style>
<title> Grocery Order List</title>
<head>
	<%@ include file="header.jsp" %>
<body>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C89scichPD02hX1v7vXRs024ppR2oZYtQv2lSR7ijD5Exx1GlgQlWWYPbFOptLWN9" crossorigin="anonymous"></script>
</head>
<body>
<h1 align="center">Welcome to Your Grocery Store</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

<%@ include file="Footer.jsp" %>

</body>
</head>


