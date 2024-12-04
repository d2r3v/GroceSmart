<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>
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



    <div class="container mt-5">
        <h1 class="text-center">Add New Product</h1>

        <!-- Form for adding a new product -->
        <form action="processAddProduct.jsp" method="POST" enctype="multipart/form-data" class="mt-4">
            <div class="mb-3">
                <label for="productName" class="form-label">Product Name</label>
                <input type="text" class="form-control" id="productName" name="productName" required>
            </div>
            <div class="mb-3">
                <label for="productPrice" class="form-label">Product Price</label>
                <input type="number" class="form-control" id="productPrice" name="productPrice" step="0.01" required>
            </div>
            <div class="mb-3">
                <label for="productCategory" class="form-label">Category</label>
                <select class="form-select" id="productCategory" name="categoryId" required>
                    <option value="">-- Select a Category --</option>
                    <%
                        // Fetch categories from the database

                        try (Connection con = DriverManager.getConnection(url, uid, pw);
                             Statement stmt = con.createStatement()) {
                            ResultSet rs = stmt.executeQuery("SELECT categoryId, categoryName FROM category");
                            while (rs.next()) {
                                int categoryId = rs.getInt("categoryId");
                                String categoryName = rs.getString("categoryName");
                    %>
                            <option value="<%= categoryId %>"><%= categoryName %></option>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("Error fetching categories: " + e.getMessage());
                        }
                    %>
                </select>
            </div>
            <div class="mb-3">
                <label for="productDescription" class="form-label">Description</label>
                <textarea class="form-control" id="productDescription" name="productDesc" rows="4" required></textarea>
            </div>
            <div class="mb-3">
                <label for="productImage" class="form-label">Product Image URL</label>
                <input type="url" class="form-control" id="productImage" name="productImageURL" required>
            </div>
            <div class="mb-3">
                <label for="productImageBinary" class="form-label">Upload Product Image (Optional)</label>
                <input type="file" class="form-control" id="productImageBinary" name="productImage">
            </div>
            <button type="submit" class="btn btn-primary">Add Product</button>
        </form>
    </div>
    <%@ include file="Footer.jsp" %>

</body>
</html>
