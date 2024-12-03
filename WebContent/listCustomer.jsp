<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";
    
    boolean isAdmin = false;
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");

    // Check if the user is logged in and an admin
    if (authenticatedUser != null) {
        String adminCheckQuery = "SELECT isAdmin FROM customer WHERE userid = ?";
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement ps = con.prepareStatement(adminCheckQuery)) {
             
            ps.setString(1, authenticatedUser);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isAdmin = rs.getBoolean("isAdmin");
            }
        } catch (SQLException e) {
            out.println("<p>Error checking admin privileges: " + e.getMessage() + "</p>");
        }
    }

    if (!isAdmin) {
%>
        <h1>Access Denied</h1>
        <p>You do not have admin privileges to access this page.</p>
        <a href="/shop/index.jsp">Go to Home Page</a>
<%
        return;
    }

    // Fetch all users from the database
    List<Map<String, String>> users = new ArrayList<>();
    String fetchUsersQuery = "SELECT customerId, firstName, lastName, email, phonenum, city, country, userid, isAdmin FROM customer";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery(fetchUsersQuery)) {
         
        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("customerId", rs.getString("customerId"));
            user.put("firstName", rs.getString("firstName"));
            user.put("lastName", rs.getString("lastName"));
            user.put("email", rs.getString("email"));
            user.put("phonenum", rs.getString("phonenum"));
            user.put("city", rs.getString("city"));
            user.put("country", rs.getString("country"));
            user.put("userid", rs.getString("userid"));
            user.put("isAdmin", rs.getBoolean("isAdmin") ? "Yes" : "No");
            users.add(user);
        }
    } catch (SQLException e) {
        out.println("<p>Error fetching users: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Users</title>
    <link href="//cdn.ubc.ca/clf/7.0.5/css/ubc-clf-full.min.css" rel="stylesheet">
    <%@ include file="header.jsp" %>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table th, table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        table th {
            background-color: #f4f4f4;
        }
        .center {
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>All Users</h1>
        <table>
            <thead>
                <tr>
                    <th>Customer ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>City</th>
                    <th>Country</th>
                    <th>User ID</th>
                    <th>Is Admin</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> user : users) { %>
                    <tr>
                        <td><%= user.get("customerId") %></td>
                        <td><%= user.get("firstName") %></td>
                        <td><%= user.get("lastName") %></td>
                        <td><%= user.get("email") %></td>
                        <td><%= user.get("phonenum") %></td>
                        <td><%= user.get("city") %></td>
                        <td><%= user.get("country") %></td>
                        <td><%= user.get("userid") %></td>
                        <td class="center"><%= user.get("isAdmin") %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <a href="/shop/index.jsp" class="btn btn-primary">Back to Home</a>
    </div>
    <%@ include file="Footer.jsp" %>
</body>
</html>
