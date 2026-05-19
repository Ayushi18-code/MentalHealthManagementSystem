<%@ page import="java.sql.*" %>
<%
    // Check session
if (session.getAttribute("studentId") == null) {
    response.sendRedirect("StudentLogin.jsp");
    return;
}
Integer studentId = (Integer) session.getAttribute("studentId");

if(studentId == null){
    response.sendRedirect("StudentLogin.jsp");
    return;
}

String idStr = request.getParameter("id");

if(idStr == null){
    response.sendRedirect("StudentAppointments.jsp");
    return;
}

Connection con = null;
PreparedStatement psCheck = null;
PreparedStatement psUpdate = null;
PreparedStatement psCancelCount = null;
PreparedStatement psBlock = null;
try {

    int appointmentId = Integer.parseInt(idStr);

    Class.forName("org.apache.derby.jdbc.ClientDriver");
    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    // 1?? Verify appointment belongs to this student AND is scheduled
    String checkSql =
        "SELECT status FROM appointment WHERE id=? AND student_id=?";

    psCheck = con.prepareStatement(checkSql);
    psCheck.setInt(1, appointmentId);
    psCheck.setInt(2, studentId);

    ResultSet rs = psCheck.executeQuery();

    if(rs.next()){

        String status = rs.getString("status");

        if("SCHEDULED".equals(status)){

            // 2?? Update status to CANCELLED_BY_STUDENT
            String updateSql =
                "UPDATE appointment SET status=?, meeting_link=NULL WHERE id=?";

            psUpdate = con.prepareStatement(updateSql);
            psUpdate.setString(1, "CANCELLED_BY_STUDENT");
            psUpdate.setInt(2, appointmentId);
            psUpdate.executeUpdate();
            String cancelSql =
    "SELECT COUNT(*) FROM appointment " +
    "WHERE student_id=? AND status='CANCELLED_BY_STUDENT' " +
    "AND appointment_date >= CAST({fn TIMESTAMPADD(SQL_TSI_DAY, -7, CURRENT_DATE)} AS DATE)";

psCancelCount = con.prepareStatement(cancelSql);
psCancelCount.setInt(1, studentId);

ResultSet rsCancel = psCancelCount.executeQuery();

int cancelCount = 0;
if(rsCancel.next()){
    cancelCount = rsCancel.getInt(1);
}
rsCancel.close();
if(cancelCount >= 4){

    java.util.Calendar cal = java.util.Calendar.getInstance();
    cal.add(java.util.Calendar.DAY_OF_MONTH, 3);

    java.sql.Date blockUntil =
        new java.sql.Date(cal.getTimeInMillis());

    String blockSql =
        "UPDATE student SET block_until=? WHERE student_id=?";

    psBlock = con.prepareStatement(blockSql);
    psBlock.setDate(1, blockUntil);
    psBlock.setInt(2, studentId);
    psBlock.executeUpdate();

    session.setAttribute("errorMsg",
        "Due to multiple bookings you are blocked till " + blockUntil);

} else if(cancelCount == 3){

    session.setAttribute("warningMsg",
        "You have cancelled multiple appointments. Continued cancellations may restrict booking.");

} else {

    session.setAttribute("successMsg",
        "Appointment cancelled successfully.");
}
        } else {

            session.setAttribute("errorMsg",
                "Only scheduled appointments can be cancelled.");
        }

    } else {

        session.setAttribute("errorMsg",
            "Invalid appointment.");
    }

    rs.close();

} catch(Exception e){

    session.setAttribute("errorMsg",
        "Cancellation failed: " + e.getMessage());

} finally {

    try{ if(psCheck!=null) psCheck.close(); }catch(Exception e){}
    try{ if(psUpdate!=null) psUpdate.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}

response.sendRedirect("StudentAppointments.jsp");
%>