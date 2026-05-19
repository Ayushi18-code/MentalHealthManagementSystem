<%@ page import="java.sql.*" %>
<%
Integer counselorId = (Integer) session.getAttribute("counselor_id");
if(counselorId == null){
    response.sendRedirect("CounselorLogin.jsp");
    return;
}
String apptParam = request.getParameter("appointmentId");

if (apptParam == null || apptParam.trim().isEmpty()) {
    response.sendRedirect("CounselorAppointments.jsp");
    return;
}
int appointmentId = Integer.parseInt(apptParam);
int studentId = 0;
String chiefConcern = "";
int facultyId = 0;
Connection con = null;
PreparedStatement ps = null;
PreparedStatement ps1 = null;
PreparedStatement ps2 = null;
ResultSet rs = null;
try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh","bns","bns");
    ps1 = con.prepareStatement(
    "SELECT student_id, chief_concern FROM APPOINTMENT WHERE id=?"
);

ps1.setInt(1, appointmentId);
rs = ps1.executeQuery();

if(rs.next()){
    studentId = rs.getInt("student_id");
    chiefConcern = rs.getString("chief_concern");
}
PreparedStatement ps3 = con.prepareStatement(
    "SELECT faculty_id FROM faculty FETCH FIRST ROW ONLY"
);

ResultSet rs3 = ps3.executeQuery();

if(rs3.next()){
    facultyId = rs3.getInt("faculty_id");
}

rs3.close();
ps3.close();
if(rs != null) rs.close();
ps1.close();
ps = con.prepareStatement(
        "UPDATE APPOINTMENT SET status='REFERRED' WHERE id=? AND counselor_id=?"
    );
    ps.setInt(1, appointmentId);
    ps.setInt(2, counselorId);
    int updated = ps.executeUpdate();

if(updated == 0){
    throw new Exception("Update failed: appointment not found or not owned by counselor");
}
    ps2 = con.prepareStatement(
    "INSERT INTO referred_cases (appointment_id, student_id, counselor_id, faculty_id, chief_concern) " +
    "VALUES (?, ?, ?, ?, ?)"
);

ps2.setInt(1, appointmentId);
ps2.setInt(2, studentId);
ps2.setInt(3, counselorId);
ps2.setInt(4, facultyId);   // always 1
ps2.setString(5, chiefConcern);

ps2.executeUpdate();
ps2.close();

}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
finally{
    try{
        if(rs!=null) rs.close();
        if(ps1!=null) ps1.close();
        if(ps2!=null) ps2.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }catch(Exception e){}
}

response.sendRedirect("CounselorAppointments.jsp?msg=referred");
%>