<%@ page import="java.sql.*" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
String role = request.getParameter("role"); // student / counselor

Connection con = null;

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    String column = "student".equals(role) ? "student_joined" : "counselor_joined";
    PreparedStatement ps = con.prepareStatement(
        "UPDATE appointment SET " + column + "=? WHERE id=?" +
", meeting_start_time = CASE WHEN meeting_start_time IS NULL THEN CURRENT_TIMESTAMP ELSE meeting_start_time END " +
"WHERE id=?");
    PreparedStatement ps3 = con.prepareStatement(
"UPDATE appointment SET meeting_start_time=CURRENT_TIMESTAMP " +
"WHERE id=? AND meeting_start_time IS NULL"
);
ps3.setInt(1, id);
ps3.executeUpdate();
ps3.close();
    ps.setBoolean(1, true);
    ps.setInt(2, id);
    ps.executeUpdate();

    // GET LINK
    PreparedStatement ps2 = con.prepareStatement(
        "SELECT meeting_link FROM appointment WHERE id=?");
    ps2.setInt(1, id);
    ResultSet rs = ps2.executeQuery();

    if(rs.next()){
        String link = rs.getString("meeting_link");
        response.sendRedirect(link);
    }

}catch(Exception e){
    out.println("Error: "+e.getMessage());
}
%>