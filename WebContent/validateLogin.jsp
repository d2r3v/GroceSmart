<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = validateLogin(out,request,session);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("login.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String validateLogin(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		boolean r = true;
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String retStr = null;

		if(username == null || password == null)
				return null;
		if((username.length() == 0) || (password.length() == 0))
				return null;

				String query = "Select * from customer where username = ? and password = ?";

    
				try ( Connection con = DriverManager.getConnection(url, uid, pw);
					  Statement stmt = con.createStatement();
					PreparedStatement ps = con.prepareStatement(query);
				   ) 
				{			
					ps.setString(1,username);
					ps.setString(2,password);
				
					ResultSet rs = ps.executeQuery();
					r = rs.next();
					
					if(rs.next()){
						retStr = rs.getString("firstName");
					}
		
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			closeConnection();
		}	
		
		if(retStr != null)
		{	session.removeAttribute("loginMessage");
			session.setAttribute("authenticatedUser",username);
		} else if (r){
			session.setAttribute("loginMessage",username + " " + password);
		}
		else
			session.setAttribute("loginMessage","Could not connect to the system using that username/password.");

		return retStr;
	}
%>

