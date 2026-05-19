<%@ page language="java" %>
<%
    
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

// Destroy full session (student is no longer logged in)
session.invalidate();

// Redirect to public home page
response.sendRedirect("Home Page.jsp");
%>
