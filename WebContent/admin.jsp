<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3cEf5zq1p9s+p12k+kk726zsYGk0u41GWzUqLJM9MQyTqKGHxlIUAXnQv4n1v2hRZg4" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .subtable td, .subtable th {
            padding: 8px;
            border: 1px solid #ddd;
        }
        .buy-btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="auth.jsp" %>
    <%@ include file="jdbc.jsp" %>

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
        out.println(e);
    }

    if (!Authenticated) {
        String loginMessage = "You do not have admin privileges to access the URL " + request.getRequestURL().toString();
        session.setAttribute("loginMessage", loginMessage);
    %>
        <h2>You do not have Admin Access.</h2>
        <a href="/shop/login.jsp" class="buy-btn">Go to Login Page</a>
    <%
    } else {
        String q = "SELECT CONVERT(DATE, orderDate) AS OrderDay, SUM(totalAmount) AS TotalSales FROM ordersummary GROUP BY CONVERT(DATE, orderDate) ORDER BY OrderDay;";
        StringBuilder dates = new StringBuilder();
        StringBuilder sales = new StringBuilder();
        try (Connection con = DriverManager.getConnection(url, uid, pw);
             PreparedStatement ps = con.prepareStatement(q)) {
            ResultSet rs = ps.executeQuery();
    %>
            <div class="container">
                <h2>Admin Sales Report by Day</h2>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Order Date</th>
                            <th>Total Order Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    boolean first = true;
                    while (rs.next()) {
                        String OrderDay = rs.getString("OrderDay");
                        String TotalSales = rs.getString("TotalSales");

                        // Append data for the graph
                        if (!first) {
                            dates.append(",");
                            sales.append(",");
                        }
                        dates.append("'").append(OrderDay).append("'");
                        sales.append(TotalSales);
                        first = false;
                    %>
                        <tr>
                            <td><%= OrderDay %></td>
                            <td><%= TotalSales %></td>
                        </tr>
                    <%
                    }
                    %>
                    </tbody>
                </table>

                <!-- Chart Container -->
                <div class="mt-5">
                    <h3>Sales Graph</h3>
                    <canvas id="salesChart" width="400" height="200"></canvas>
                </div>
            </div>

            <script>
                // Pass data to JavaScript
                const dates = [<%= dates.toString() %>];
                const sales = [<%= sales.toString() %>];

                // Render the chart using Chart.js
                const ctx = document.getElementById('salesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: dates,
                        datasets: [{
                            label: 'Total Sales',
                            data: sales,
                            borderColor: 'rgba(75, 192, 192, 1)',
                            backgroundColor: 'rgba(75, 192, 192, 0.2)',
                            fill: true
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            </script>
    <%
        } catch (Exception e) {
            out.println(e);
        }
    }
    %>
    <%@ include file="Footer.jsp" %>
</body>
</html>
