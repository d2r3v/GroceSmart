<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
    <%@ include file="header.jsp" %>

</head>
<body>
<%
    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
    String uid = "sa";
    String pw = "304#sa#pw";

    // Check if the user is logged in
    String authenticatedUser = (String) session.getAttribute("authenticatedUser");
    if (authenticatedUser == null) {
%>
        <h1>You are not logged in!</h1>
        <h2><a href="/shop/login.jsp">Go to Login Page</a></h2>
<%
        return;
    }

    // Query to fetch the orders of the logged-in customer
    String query = "SELECT o.orderId, o.orderDate, o.totalAmount, o.shiptoAddress, o.shiptoCity, o.shiptoState, o.shiptoPostalCode, o.shiptoCountry " +
                   "FROM ordersummary AS o " +
                   "JOIN customer AS c ON c.customerId = o.customerId " +
                   "WHERE c.userid = ?";
    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(query)) {

        ps.setString(1, authenticatedUser);
        ResultSet rs = ps.executeQuery();

        if (!rs.isBeforeFirst()) {
%>
            <h1>You have no orders!</h1>
            <h2><a href="/shop/listprod.jsp">Shop Now</a></h2>
<%
        } else {
%>
            <h1>My Orders</h1>
            <table border="1">
                <tr>
                    <th>Order ID</th>
                    <th>Order Date</th>
                    <th>Total Amount</th>
                    <th>Shipping Address</th>
                    <th>Status</th> <!-- You can add order status if needed -->
                </tr>
<%
            // Format for displaying currency
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            while (rs.next()) {
                int orderId = rs.getInt("orderId");
                String orderDate = rs.getString("orderDate");
                double totalAmount = rs.getDouble("totalAmount");
                String shiptoAddress = rs.getString("shiptoAddress");
                String shiptoCity = rs.getString("shiptoCity");
                String shiptoState = rs.getString("shiptoState");
                String shiptoPostalCode = rs.getString("shiptoPostalCode");
                String shiptoCountry = rs.getString("shiptoCountry");

                String shippingDetails = shiptoAddress + ", " + shiptoCity + ", " + shiptoState + ", " + shiptoPostalCode + ", " + shiptoCountry;
%>
                <tr>
                    <td><%= orderId %></td>
                    <td><%= orderDate %></td>
                    <td><%= currFormat.format(totalAmount) %></td>
                    <td><%= shippingDetails %></td>
                    <td>Pending</td> <!-- Add logic for Order Status if available in your table -->
                </tr>
<%
            }
%>
            </table>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>
<h2><a href="/shop/index.jsp">Back to Home</a></h2>
</body>
</html>
