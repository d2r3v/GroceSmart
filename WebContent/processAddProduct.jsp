<%@ page import="java.sql.*" %>
<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";        
String uid = "sa";
String pw = "304#sa#pw";
boolean Authenticated = false;

String query = "SELECT * FROM customer WHERE userid = ? AND isAdmin = 1";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     PreparedStatement ps = con.prepareStatement(query)) {

    ps.setString(1, (String) session.getAttribute("authenticatedUser"));
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        Authenticated = true;
    }
} catch (Exception e) {
    out.println("<p>Error: " + e.getMessage() + "</p>");
}

if (!Authenticated) {
%>
    <h2>You do not have Admin Access.</h2>
    <a href="/shop/login.jsp" class="buy-btn">Go to Login Page</a>
<%
    return; // Prevent further code from executing
}
%>

<%

    // Database credentials
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    // Retrieve form data
    String productName = request.getParameter("productName");
    String productPrice = request.getParameter("productPrice");
    String categoryId = request.getParameter("categoryId");
    String productDesc = request.getParameter("productDesc");
    String productImageURL = request.getParameter("productImageURL");

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         PreparedStatement ps = con.prepareStatement(
             "INSERT INTO product (productName, productPrice, categoryId, productDesc, productImageURL, productImage) VALUES (?, ?, ?, ?, ?, ?)")) {

        ps.setString(1, productName);
        ps.setDouble(2, Double.parseDouble(productPrice));
        ps.setInt(3, Integer.parseInt(categoryId));
        ps.setString(4, productDesc);
        ps.setString(5, productImageURL);

        // Check for an uploaded file
        Part productImage = request.getPart("productImage");
        if (productImage != null && productImage.getSize() > 0) {
            ps.setBinaryStream(6, productImage.getInputStream(), (int) productImage.getSize());
        } else {
            ps.setNull(6, Types.BLOB);
        }

        // Execute the insert
        int rows = ps.executeUpdate();
        if (rows > 0) {
            out.println("<h1>Product added successfully!</h1>");
        } else {
            out.println("<h1>Error adding product!</h1>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h1>Error: " + e.getMessage() + "</h1>");
    }
%>
