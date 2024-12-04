<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery CheckOut Line</title>
    <%@ include file="header.jsp" %>
</head>
<body>
    <h1>Enter your customer ID and password to complete the transaction:</h1>
    <h2>Login</h2>

    <!-- Login Form -->
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
    // Ensure processing happens only after form submission
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        try {
            // Load the JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Database connection details
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            // SQL query to validate login
            String query = "SELECT * FROM customer WHERE userId = ? AND password = ?";

            // Open database connection and execute query
            try (Connection con = DriverManager.getConnection(url, uid, pw);
                 PreparedStatement ps = con.prepareStatement(query)) {

                // Set query parameters to prevent SQL injection
                ps.setString(1, username);
                ps.setString(2, password);

                // Execute the query
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // Successful login, redirect to order page
                    response.sendRedirect("order.jsp?customerId=" + rs.getString("customerId"));
                } else {
                    // Invalid credentials
                    %> 
                    <h4 style="color: red;">Incorrect Username or Password.</h4>
                    <%
                }
            }
        } catch (ClassNotFoundException e) {
            // Handle missing driver class
            out.println("<h4 style='color: red;'>Error: Unable to load database driver. Please contact support.</h4>");
        } catch (SQLException e) {
            // Handle database errors
            out.println("<h4 style='color: red;'>Error: " + e.getMessage() + "</h4>");
        }
    }
    %>

    <%@ include file="Footer.jsp" %>
</body>
</html>
