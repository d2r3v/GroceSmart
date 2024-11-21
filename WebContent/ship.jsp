<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;databaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";
	String n = request.getParameter("orderId");

	String query = "SELECT * FROM orderproduct where orderId = ?";
	String q2 = "Select * from productinventory where quantity > ? and productId = ? ";
	String q1 = "Update productinventory set quantity = ? where productId = ? and warehouseId = ?";
	String s = "INSERT INTO Shipment (shipmentId, shipmentDate,warehouseId) VALUES (?,?,?);";

		try ( Connection con = DriverManager.getConnection(url, uid, pw);
			PreparedStatement ps = con.prepareStatement(query);
			PreparedStatement ps1 = con.prepareStatement(q1);
			PreparedStatement ps2 = con.prepareStatement(s);
			PreparedStatement ps3 = con.prepareStatement(q2);

						Statement stmt = con.createStatement();
			) {

				ps.setString(1,n);
				ResultSet rs = ps.executeQuery();
				out.println("true");

				if(!rs.next()){
					%> <h2>No Such Order!</h2> <%
				}else {
					ps3.setString(2,rs.getString("productId"));
						ps3.setInt(1,rs.getInt("quantity"));
						ResultSet rs1 = ps3.executeQuery();
						if(!rs1.next()){
							%> <h3>Shipment Not Done! Insufficient Inventory for Product ID - <%= rs.getString("productId") %></h3> <%
							return;
						} else {
							%> <h4>Ordered Product : <% rs.getString("producId"); %> Previous Inventory - <% rs1.getString("quantity"); %> New Inventory - <% out.println(rs1.getInt("quantity") - rs.getInt("quantity")); %> </h4> <%
						}
					while(rs.next()){
						ps3.setString(2,rs.getString("productId"));
						ps3.setInt(1,rs.getInt("quantity"));
						ResultSet rs2 = ps3.executeQuery();
						if(!rs1.next()){
							%> <h3>Shipment Not Done! Insufficient Inventory for Product ID - <%= rs.getString("productId") %></h3> <%
							return;
						} else {
							%> <h4>Ordered Product : <% rs.getString("producId"); %> Previous Inventory - <% rs1.getString("quantity"); %> New Inventory - <% out.println(rs1.getInt("quantity") - rs.getInt("quantity")); %> </h4> <%
						}
					}
				}
			} catch (Exception ex){
				out.println(ex);
			} %>

<%
	// TODO: Get order id
          
	// TODO: Check if valid order id in database
	
	// TODO: Start a transaction (turn-off auto-commit)
	
	// TODO: Retrieve all items in order with given id
	// TODO: Create a new shipment record.
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
	
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="shop/index.jsp">Back to Main Page</a></h2>

</body>
</html>
