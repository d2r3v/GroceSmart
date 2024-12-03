<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <%@ include file="header.jsp" %>
</head>
<body>

<%
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Check if the cart is empty
if (productList == null || productList.isEmpty()) {
    out.println("<h1>No items in cart</h1>");
} else {
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<form method='post' action='updateCart.jsp'>"); // Start a single form for the entire table
    out.print("<table border='1'><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th><th>Actions</th></tr>");

    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = entry.getValue();

        if (product.size() < 4) {
            out.println("Expected product with four entries. Got: " + product);
            continue;
        }

        String productId = product.get(0).toString();
        String productName = product.get(1).toString();
        double price = Double.parseDouble(product.get(2).toString());
        int quantity = Integer.parseInt(product.get(3).toString());

        double subtotal = price * quantity;
        total += subtotal;

        out.print("<tr>");
        out.print("<td>" + productId + "</td>");
        out.print("<td>" + productName + "</td>");

        // Quantity input field
        out.print("<td align='center'>");
        out.print("<input type='number' name='quantity_" + productId + "' value='" + quantity + "' min='1' max='100'/>");
        out.print("</td>");

        out.print("<td align='right'>" + currFormat.format(price) + "</td>");
        out.print("<td align='right'>" + currFormat.format(subtotal) + "</td>");

        // Remove button
        out.print("<td align='center'>");
        out.print("<button type='submit' name='remove' value='" + productId + "'>Remove</button>");
        out.print("</td>");

        out.print("</tr>");
    }

    out.println("<tr><td colspan='4' align='right'><b>Order Total</b></td>"
            + "<td align='right'>" + currFormat.format(total) + "</td><td></td></tr>");
    out.println("</table>");
    out.println("<button type='submit' name='update'>Update Cart</button>"); // Submit button for updating quantities
    out.println("</form>");

    out.println("<h2><a href='checkout.jsp'>Check Out</a></h2>");
}

out.println("<h2><a href='listprod.jsp'>Continue Shopping</a></h2>");
%>
<%@ include file="Footer.jsp" %>
</body>
</html>
