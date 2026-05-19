<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    /*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

String search = request.getParameter("q");

Connection con = DriverManager.getConnection(
    "jdbc:derby://localhost:1527/ManSparsh","bns","bns");

PreparedStatement ps;

if(search != null && !search.trim().isEmpty()){
    ps = con.prepareStatement(
        "SELECT ID, HOSTEL_NAME FROM HOSTEL WHERE LOWER(HOSTEL_NAME) LIKE ? ORDER BY ID");
    ps.setString(1, "%" + search.toLowerCase() + "%");
} else {
    ps = con.prepareStatement(
        "SELECT ID, HOSTEL_NAME FROM HOSTEL ORDER BY ID");
}

ResultSet rs = ps.executeQuery();

StringBuilder html = new StringBuilder();

int count = 1;

while(rs.next()){
    html.append("<tr>");
    html.append("<td>").append(count++).append("</td>");
    html.append("<td>").append(rs.getInt("ID")).append("</td>");
    html.append("<td>").append(rs.getString("HOSTEL_NAME")).append("</td>");
    html.append("</tr>");
}

out.print(html.toString());
%>