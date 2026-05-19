<%@ page import="java.sql.*" %>
<%/*------PREVENT CACHE------*/   
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0); 
    %>
<%
String id = request.getParameter("id");

Connection con = null;
PreparedStatement ps = null;

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh",
        "bns",
        "bns"
    );

    String sql = "UPDATE referred_cases SET status='COMPLETED' WHERE student_id=?";

    ps = con.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(id));

    ps.executeUpdate();

    // wapas list pe
    response.sendRedirect("FacultyReferredCases.jsp");

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}finally{
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>