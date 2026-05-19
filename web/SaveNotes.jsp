<%@ page import="java.sql.*" %>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String appointmentId = request.getParameter("appointmentId");

if(appointmentId == null || appointmentId.trim().equals("")){
    out.println("<h3 style='color:red'>Appointment ID missing</h3>");
    return;
}
Integer counselorId = (Integer) session.getAttribute("counselor_id");

// Get individual fields
String problematic = request.getParameter("problematicBehavior");
String intervention = request.getParameter("intervention");
String responseText = request.getParameter("response");
String targeted = request.getParameter("targetedBehavior");
String plan = request.getParameter("plan");

try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    // Check if already exists
    String checkSql = "SELECT note_id FROM SESSION_NOTES WHERE appointment_id=?";
    ps = conn.prepareStatement(checkSql);
    ps.setInt(1, Integer.parseInt(appointmentId));
    rs = ps.executeQuery();

    if(rs.next()){
        //  UPDATE
        String updateSql =
        "UPDATE SESSION_NOTES SET " +
        "problematic_behavior=?, targeted_Behavior=?, intervention=?, response=?, plan=? " +
        "WHERE appointment_id=?";
        ps = conn.prepareStatement(updateSql);
        ps.setString(1, problematic);
ps.setString(2, targeted);
ps.setString(3, intervention);
ps.setString(4, responseText);
ps.setString(5, plan);
ps.setInt(6, Integer.parseInt(appointmentId));
        ps.executeUpdate();

    } else {
        // ? INSERT
        String insertSql =
"INSERT INTO SESSION_NOTES " +
"(appointment_id, counselor_id, problematic_behavior, targeted_Behavior, intervention, response, plan) " +
"VALUES (?, ?, ?, ?, ?, ?, ?)";  
        ps = conn.prepareStatement(insertSql);
ps.setInt(1, Integer.parseInt(appointmentId));
ps.setInt(2, counselorId);
ps.setString(3, problematic);
ps.setString(4, targeted);
ps.setString(5, intervention);
ps.setString(6, responseText);
ps.setString(7, plan);

ps.executeUpdate();
    }

response.sendRedirect("addNotes.jsp?appointmentId=" + appointmentId + "&status=success");
}catch(Exception e){
    e.printStackTrace();   // prints full error in server console
    out.println("<h3 style='color:red;'>Error: "+e.getMessage()+"</h3>");
}
%>