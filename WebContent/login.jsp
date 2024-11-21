<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<%@ include file="header.jsp" %>
<style>
	.subtable td, .subtable th {
	  padding: 8px;
	  border: 1px solid #ddd;
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
  </style>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Please Login to System</h3>

<%
// Print prior error login message if present
if (session.getAttribute("loginMessage") != null)
	out.println("<p>"+session.getAttribute("loginMessage").toString()+"</p>");
%>

<br>
<form name="MyForm" method=post action="validateLogin.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
</table>
<br/>
<input class="buy-btn" type="submit" name="Submit2" value="Log In">
</form>

</div>

</body>
</html>

