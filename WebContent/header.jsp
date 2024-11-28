<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Database connection details
    String url1 = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid1 = "sa";
    String pw1 = "304#sa#pw";

    // Check if the user is authenticated and is an admin
    boolean isAdmin = false;
    String authenticatedUser1 = (String) session.getAttribute("authenticatedUser");

    if (authenticatedUser1 != null) {
        String query = "SELECT isAdmin FROM customer WHERE userid = ?";

        try (Connection con = DriverManager.getConnection(url1, uid1, pw1);
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, authenticatedUser1);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                isAdmin = rs.getBoolean("isAdmin");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    }
%>

<meta charset="utf-8" />
<title>Your Grocery Store</title>
<meta name="viewport" content="width=device-width" />
<meta name="description" content="" />
<meta name="author" content="" />
<link href="//cdn.ubc.ca/clf/7.0.5/css/ubc-clf-full.min.css" rel="stylesheet" />
<link href="css/unit.css" rel="stylesheet" />
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
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
                    <a href="/shop/index.jsp">
                        <span id="unit-faculty">Your Supermart</span>
                        <span id="unit-identifier"></span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div id="unit-menu" class="navbar expand" role="navigation">
        <div class="navbar-inner expand">
            <div class="container">
                <div class="nav-collapse collapse" id="unit-navigation">
                    <ul class="nav">
                        <li><a href="/shop/index.jsp">Home</a></li>
                        <li><a href="/shop/listprod.jsp">Products</a></li>
                        <li><a href="/shop/listorder.jsp">Order List</a></li>
                        <li><a href="/shop/showcart.jsp">Cart</a></li>						
                        <% if (isAdmin) { %>
                            <li><a href="/shop/admin.jsp">Admin Dashboard</a></li>
                            <li><a href="/shop/createUser.jsp">Create User</a></li>
                        <% } %>
						<li><a href="/shop/editUser.jsp">Edit User</a></li>
                    </ul>
                    <h3 style="text-align: end; color: white;">
                        <% 
                            if (authenticatedUser1 != null) { 
                                out.println("Welcome, " + authenticatedUser1); 
                            } else { 
                        %>
                            <a href="/shop/login.jsp" style="color: white;">Login</a>
                        <% } %>
                    </h3>
                </div>
            </div>
        </div>
    </div>
</body>
