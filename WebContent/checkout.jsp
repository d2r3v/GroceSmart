<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
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

<h1>Enter your customer id and password to complete the transaction:</h1>

<h2>Login</h2>
<!-- Form to capture username and password -->
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


</body>
</html>
