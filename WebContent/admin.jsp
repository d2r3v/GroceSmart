<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3cEf5zq1p9s+p12k+kk726zsYGk0u41GWzUqLJM9MQyTqKGHxlIUAXnQv4n1v2hRZg4" crossorigin="anonymous">
	<style>
		.subtable td, .subtable th {
		  padding: 8px;
		  border: 1px solid #ddd;
		}
	  </style>
<title> Grocery Order List</title>
<head>
<body>

<%
// TODO: Include files auth.jsp and jdbc.jsp
%>
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>


<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
		String uid = "sa";
		String pw = "304#sa#pw";
        boolean Authenticated = false;

        String query = "SELECT * FROM customer where userid = ? and isAdmin = 1";

            try (Connection con = DriverManager.getConnection(url, uid, pw);
                PreparedStatement ps = con.prepareStatement(query);
                Statement stmt = con.createStatement();
                ) {

                    ps.setString(1,(String)session.getAttribute("authenticatedUser"));

                    ResultSet rs = ps.executeQuery();

                    if(rs.next()){
                        Authenticated = true;
                    }
                } catch (Exception e){
                    out.println(e);
                }

                if (!Authenticated){
                    String loginMessage = "You do not have admin privelages to access the URL "+request.getRequestURL().toString();
                    session.setAttribute("loginMessage",loginMessage);        
                    %> <c:redirect url="/login.jsp"/> <%
                } else {
                    String q = "SELECT CONVERT(DATE, orderDate) AS OrderDay, SUM(totalAmount) AS TotalSales FROM ordersummary GROUP BY CONVERT(DATE, orderDate) ORDER BY OrderDay;";
                    try ( Connection con = DriverManager.getConnection(url, uid, pw);
                PreparedStatement ps = con.prepareStatement(q);
                Statement stmt = con.createStatement();
                ){
                    ResultSet rs = ps.executeQuery();

                    %> 		<div class="container">
                        <h2>Admin Sales Report by Day</h2>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Order Date</th>
                                    <th>Total Order Amount</th>
                                </tr>
                            </thead>
                            <tbody> 
<%            

                    while(rs.next()){

                        String OrderDay = rs.getString("OrderDay");
                        String Sales = rs.getString("TotalSales");
                        
                        %>

					<tr>
						<td><% out.println(OrderDay); %> </td>
						<td><% out.println( Sales); %> </td>
					</tr> <%

                    }
                    
                } catch (Exception e){
                    out.println(e);
                }%> </tbody> </table> </div> <%
            }

%>

</body>
</html>

