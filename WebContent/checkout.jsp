<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
<head>
    <%@ include file="header.jsp" %>
<body>

<h1>Enter your customer id and password to complete the transaction:</h1>

<h2>Login</h2>

<form method="post" action="checkout.jsp">
    <label for="username">Username: </label>
    <input type="text" id="username" name="username" required>
    <br><br>
    <label for="password">Password: </label>
    <input type="password" id="password" name="password" required>
    <br><br>
    <input type="submit" value="Submit">
    <input type="reset" value="Reset">
</form>

<%

try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";

String query = "Select * from customer where customerId = ? and password = ?";

    
try ( Connection con = DriverManager.getConnection(url, uid, pw);
      Statement stmt = con.createStatement();
    PreparedStatement ps = con.prepareStatement(query);
   ) 
{			
    ps.setString(1,request.getParameter("username"));
    ps.setString(2,request.getParameter("password"));

    ResultSet rs = ps.executeQuery();

    if(!rs.next()){
        %> <h4 style="color: red;"> Incorrect Username or Password.</h4> <%
    } else {
        response.sendRedirect("order.jsp?customerId=" + request.getParameter("username"));
    }


}
catch(Exception e){
    out.println(e);
}
%>

<%@ include file="Footer.jsp" %>
</body>
</html>
