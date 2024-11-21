<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp"%>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";

        String query = "SELECT * FROM customer where userid = ?";

            try ( Connection con = DriverManager.getConnection(url, uid, pw);
                PreparedStatement ps = con.prepareStatement(query);
                Statement stmt = con.createStatement();
                ) {

					ps.setString(1,userName);

					ResultSet rs = ps.executeQuery();

					if(rs.next()){
						%>
						<div class="container">
							<h2>Customer Information</h2>
							<table class="table table-bordered">
								<tbody> 
						<tr>
							<td><b>ID</b></td>
							<td><% out.println( rs.getString("customerId")); %> </td>
						</tr> 
						<tr>
							<td><b>First Name</b></td>
							<td><% out.println( rs.getString("firstName")); %> </td>
						</tr> 						<tr>
							<td><b>Last Name</b></td>
							<td><% out.println( rs.getString("lastName")); %> </td>
						</tr> 						<tr>
							<td><b>Email</b></td>
							<td><% out.println( rs.getString("email"));%> </td>
						</tr> 						<tr>
							<td><b>Phone Number</b></td>
							<td><% out.println( rs.getString("phonenum")); %> </td>
						</tr> 						<tr>
							<td><b>Address </b></td>
							<td><% out.println( rs.getString("address")); %> </td>
						</tr> 						<tr>
							<td><b> City</b></td>
							<td><% out.println( rs.getString("city")); %> </td>
						</tr> 						<tr>
							<td><b>State</b></td>
							<td><% out.println( rs.getString("state")); %> </td>
						</tr> 						<tr>
							<td><b>Postal Code</b></td>
							<td><% out.println( rs.getString("postalCode"));%> </td>
						</tr> 						<tr>
							<td><b>Country</b></td>
							<td><% out.println( rs.getString("country")); %> </td>
						</tr> 						<tr>
							<td><b>User Id</b></td>
							<td><% out.println( rs.getString("userid")); %> </td>
						</tr> 
						<%
					}
				}
				catch(Exception e){
					out.println(e);
				}%> </tbody> </table> </div> 


</body>
</html>

