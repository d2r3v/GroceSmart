<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
@SuppressWarnings("unchecked")
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    String removeProductId = request.getParameter("remove");
    String updateAction = request.getParameter("update");

    if (removeProductId != null) {
        // Remove product logic
        productList.remove(removeProductId);
    } else if (updateAction != null) {
        // Update quantities
        for (String productId : productList.keySet()) {
            String quantityParam = request.getParameter("quantity_" + productId);
            if (quantityParam != null) {
                try {
                    int quantity = Integer.parseInt(quantityParam);
                    if (quantity > 0 && quantity <= 100) { // Validate quantity range
                        ArrayList<Object> product = productList.get(productId);
                        if (product != null) {
                            product.set(3, quantity); // Update quantity
                        }
                    }
                } catch (NumberFormatException e) {
                    // Handle invalid number gracefully
                }
            }
        }
    }

    session.setAttribute("productList", productList); // Update session data
}
response.sendRedirect("showcart.jsp"); // Redirect back to the cart page
%>
