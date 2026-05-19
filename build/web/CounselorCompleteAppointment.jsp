<%@ page import="java.sql.*" %>
<%
String id = request.getParameter("id");
Connection conn = null;
PreparedStatement ps = null;
try {
    // Load Derby Driver
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    // Connect Database
    conn = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh",
        "bns",
        "bns"
    );
    // Update Status
    String sql =
    "UPDATE APPOINTMENT SET status='COMPLETED' WHERE id=?";

    ps = conn.prepareStatement(sql);

    ps.setInt(1, Integer.parseInt(id));

    ps.executeUpdate();

    // Redirect Back
    response.sendRedirect("CounselorCaseDetails.jsp");

}
catch(Exception e){

    out.println("Error: " + e.getMessage());

}
finally{

    if(ps!=null) ps.close();
    if(conn!=null) conn.close();

}

%>