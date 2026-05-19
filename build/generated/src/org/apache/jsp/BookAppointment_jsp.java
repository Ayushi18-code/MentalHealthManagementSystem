package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.sql.*;
import java.util.*;
import java.util.UUID;

public final class BookAppointment_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\n');
      out.write('\n');

    /*------PREVENT CACHE------*/   
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0); 
    String studentName = (String) session.getAttribute("studentName");
    String studentEmail = (String) session.getAttribute("studentEmail");
    if(studentEmail == null){
        response.sendRedirect("StudentLogin.jsp");
        return;
    }
    String rescheduleIdStr = request.getParameter("rescheduleId");
    String editIdStr = request.getParameter("editId");
    Integer editId = null;
    if(editIdStr != null){
        try{
            editId = Integer.parseInt(editIdStr);
        }catch(Exception e){}
    }
    Integer rescheduleId = null;
    if(rescheduleIdStr != null){
        try{
            rescheduleId = Integer.parseInt(rescheduleIdStr);
        }catch(Exception e){}
    }
    String message = "";
    String dobVal = request.getParameter("dob");
    String smartCardVal = request.getParameter("smartCard");
    String appointmentDateVal = request.getParameter("appointmentDate");
    String phoneVal = request.getParameter("phone");
    String hostelVal = request.getParameter("hostel");
    String modeVal = request.getParameter("mode");
    String slotVal = request.getParameter("slot");
    String[] concernsVal = request.getParameterValues("concern[]");
    String otherTextVal = request.getParameter("otherText");
    String editSlot="";
    String editMode="";
    String editDate="";
    String editConcern="";
    if(editId != null){
        try{
            Connection conEdit = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/ManSparsh","bns","bns");
            PreparedStatement psEdit = conEdit.prepareStatement(
                "SELECT appointment_date, time_slot, preferred_mode, chief_concern " +
                "FROM appointment WHERE id=? AND status='SCHEDULED'"
            );
            psEdit.setInt(1, editId);
            ResultSet rsEdit = psEdit.executeQuery();
            if(rsEdit.next()){
                editDate = rsEdit.getDate("appointment_date").toString();
                editSlot = rsEdit.getString("time_slot");
                editMode = rsEdit.getString("preferred_mode");
                editConcern = rsEdit.getString("chief_concern");
            }
            conEdit.close();
        }catch(Exception e){}
    }
    String dbDob="";
    String dbSmart="";
    String dbPhone="";
    String dbHostel="";
    try{
    Connection conFetch = DriverManager.getConnection(
    "jdbc:derby://localhost:1527/ManSparsh","bns","bns");
    PreparedStatement psFetch = conFetch.prepareStatement(
    "SELECT dob, smart_card_id, phone, hostel FROM student WHERE email=?");
    psFetch.setString(1, studentEmail);
    ResultSet rsFetch = psFetch.executeQuery();
    if(rsFetch.next()){
        if(rsFetch.getDate("dob")!=null)
            dbDob = rsFetch.getDate("dob").toString();
        dbSmart = rsFetch.getString("smart_card_id");
        dbPhone = rsFetch.getString("phone");
        dbHostel = rsFetch.getString("hostel");
    }
    conFetch.close();
    }catch(Exception e){}
    boolean hasScheduledAppointment = false;
    try{
    Connection conCheck = DriverManager.getConnection(
    "jdbc:derby://localhost:1527/ManSparsh","bns","bns");
    PreparedStatement psCheck = conCheck.prepareStatement(
    "SELECT COUNT(*) FROM appointment " +
    "WHERE student_id=(SELECT student_id FROM student WHERE email=?) " +
    "AND status='SCHEDULED' AND appointment_date >= CURRENT_DATE"
    );
    psCheck.setString(1, studentEmail);
    ResultSet rsCheck = psCheck.executeQuery();
    if(rsCheck.next()){
        if(rsCheck.getInt(1) > 0){
            hasScheduledAppointment = true;
        }
    }
    conCheck.close();
    }catch(Exception e){}
        if(request.getParameter("submit") != null)
        {
            String emailPrefix = studentEmail.split("@")[0];   
            String validSmartCard = emailPrefix.split("_")[0]; 
            if(smartCardVal == null || 
               !smartCardVal.equalsIgnoreCase(validSmartCard)){
                    message = "<div class='error'>Invalid Smart Card ID</div>";
        }
        else if(phoneVal == null || !phoneVal.matches("\\d{10}")){
            message = "<div class='error'>Phone number must be exactly 10 digits</div>";
    }
    else
    {
        String dob = request.getParameter("dob");
        String appointmentDate = request.getParameter("appointmentDate");
        java.sql.Date apptDate = java.sql.Date.valueOf(appointmentDate);
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(apptDate);
        int dayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
        String phone = request.getParameter("phone");
        String hostel = request.getParameter("hostel");
        String mode = request.getParameter("mode");
        String slot = request.getParameter("slot");
        if(dayOfWeek == java.util.Calendar.TUESDAY){
            message = "<div class='error'>Tuesday is a holiday. Please select another date.</div>";
        } 
        else{
            String[] concerns = request.getParameterValues("concern[]");
            String chiefConcern = "";
            if(concerns != null)
            {
                StringBuilder sb = new StringBuilder();
                for(String c : concerns){
                    if(c.equals("Other")){
                        sb.append("Other(").append(otherTextVal).append(")");
                    }
                    else{
                        sb.append(c);
                    }
                    sb.append(", ");
                }
                chiefConcern = sb.substring(0, sb.length()-2);
            }
            try
            {
                Connection con = DriverManager.getConnection("jdbc:derby://localhost:1527/ManSparsh","bns","bns");
                PreparedStatement ps1 = con.prepareStatement("SELECT student_id FROM STUDENT WHERE email=?");
                ps1.setString(1, studentEmail);
    ResultSet rs = ps1.executeQuery();
    int studentId = 0;
    if(rs.next()){
        studentId = rs.getInt("student_id");
    }
    PreparedStatement psCheckBlock = con.prepareStatement(
        "SELECT block_until FROM student WHERE student_id=?"
    );
    psCheckBlock.setInt(1, studentId);
    ResultSet rsBlock = psCheckBlock.executeQuery();
    if(rsBlock.next()){
        java.sql.Date blockUntil = rsBlock.getDate("block_until");
        if(blockUntil != null){
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

            if(today.before(blockUntil)){
                message =
                "<div class='block-box'>" +
                "You are blocked until <b>" + blockUntil + "</b>" +
                "</div>";
                con.close();
                return;
            }
        }
    }
    PreparedStatement psCancel = con.prepareStatement(
        "SELECT COUNT(*) FROM appointment " +
        "WHERE student_id=? AND status='CANCELLED_BY_STUDENT' " +
        "AND appointment_date >= CAST({fn TIMESTAMPADD(SQL_TSI_DAY, -7, CURRENT_DATE)} AS DATE)"
    );
    psCancel.setInt(1, studentId);
    ResultSet rsCancel = psCancel.executeQuery();
    int cancelCount = 0;
    if(rsCancel.next()){
        cancelCount = rsCancel.getInt(1);
    }
    if(cancelCount >= 4){
        Calendar blockCal = Calendar.getInstance();
        blockCal.add(Calendar.DAY_OF_MONTH, 3);
        java.sql.Date blockUntil =
            new java.sql.Date(blockCal.getTimeInMillis());
        PreparedStatement psBlock = con.prepareStatement(
            "UPDATE student SET block_until=? WHERE student_id=?"
        );
        psBlock.setDate(1, blockUntil);
        psBlock.setInt(2, studentId);
        psBlock.executeUpdate();
        message = "<script>showBlockModal('" + blockUntil + "');</script>";
        con.close();
        return;
    }
                PreparedStatement checkFuture = con.prepareStatement(
                    "SELECT COUNT(*) FROM appointment " +
                    "WHERE student_id=? AND status='SCHEDULED' AND appointment_date >= CURRENT_DATE"
                );
                checkFuture.setInt(1, studentId);
                ResultSet rsFuture = checkFuture.executeQuery();
                int futureCount = 0;
                if(rsFuture.next()){
                    futureCount = rsFuture.getInt(1);
                }
                if(editId != null){
                    PreparedStatement checkCurrent = con.prepareStatement(
                        "SELECT COUNT(*) FROM appointment WHERE id=? AND student_id=? AND status='SCHEDULED'"
                    );
                    checkCurrent.setInt(1, editId);
                    checkCurrent.setInt(2, studentId);
                    ResultSet rsCurrent = checkCurrent.executeQuery();
                    if(rsCurrent.next() && rsCurrent.getInt(1) > 0){
                        futureCount--;  
                    }
                }
                if(futureCount > 0 && editId == null){
                    message = "<div class='error'>You already have a scheduled upcoming appointment.</div>";
                    con.close();
                    return;
                }
                if(rescheduleId != null)
                {
                    PreparedStatement checkOld = con.prepareStatement("SELECT status FROM appointment WHERE id=? AND student_id=?");
                    checkOld.setInt(1, rescheduleId);
                    checkOld.setInt(2, studentId);
                    ResultSet rsOld = checkOld.executeQuery();
                    if(rsOld.next())
                    {
                        String oldStatus = rsOld.getString("status");
                        if(!"SCHEDULED".equals(oldStatus)){
                            message = "<div class='error'>Only scheduled appointments can be rescheduled.</div>";
                            con.close();
                            return;
                        }
                    PreparedStatement psUpdateOld = con.prepareStatement("UPDATE appointment SET status='RESCHEDULED' WHERE id=? AND status='SCHEDULED'");
                        psUpdateOld.setInt(1, rescheduleId);
                        psUpdateOld.executeUpdate();
                    } 
                    else 
                    {
                        message = "<div class='error'>Invalid appointment selected.</div>";
                        con.close();
                        return;
                    }
                }
                String counselorIdStr = request.getParameter("counselorId");
                if(counselorIdStr == null || counselorIdStr.trim().isEmpty())
                {
                    message = "<div class='error'>Please select a valid time slot.</div>";
                }
                else
                {
                            int counselorId = Integer.parseInt(counselorIdStr);
                            PreparedStatement slotCheck;
                            if(editId != null){
                                slotCheck = con.prepareStatement(
                                    "SELECT COUNT(*) FROM appointment " +
                                    "WHERE counselor_id=? AND appointment_date=? AND time_slot=? " +
                                    "AND status='SCHEDULED' AND id<>?"
                                );
                                slotCheck.setInt(1, counselorId);
                                slotCheck.setDate(2, java.sql.Date.valueOf(appointmentDate));
                                slotCheck.setString(3, slot);
                                slotCheck.setInt(4, editId);
                            }
                            else{
                                slotCheck = con.prepareStatement(
                                    "SELECT COUNT(*) FROM appointment " +
                                    "WHERE counselor_id=? AND appointment_date=? AND time_slot=? " +
                                    "AND status='SCHEDULED'"
                                );
                                slotCheck.setInt(1, counselorId);
                                slotCheck.setDate(2, java.sql.Date.valueOf(appointmentDate));
                                slotCheck.setString(3, slot);
                            }

                            ResultSet rsSlot = slotCheck.executeQuery();

                            if(rsSlot.next() && rsSlot.getInt(1) > 0){
                                message = "<div class='error'>This time slot is already booked.</div>";
                                con.close();
                                return;
                            }
                            PreparedStatement updateStudent = con.prepareStatement(
                            "UPDATE student SET dob=?, smart_card_id=?, phone=?, hostel=? WHERE student_id=?"
                            );
                            updateStudent.setDate(1, java.sql.Date.valueOf(dob));
                            updateStudent.setString(2, smartCardVal);
                            updateStudent.setString(3, phone);
                            updateStudent.setString(4, hostel);
                            updateStudent.setInt(5, studentId);
                            updateStudent.executeUpdate();
                            String meetingLink = null;
                            if("VIDEO_CALL".equalsIgnoreCase(mode)){
                                meetingLink = "https://meet.google.com/" +
                                        UUID.randomUUID().toString().substring(0,10);
                            }
                            if(editId != null)
                            {
                                PreparedStatement psUpdate = con.prepareStatement(
                                    "UPDATE appointment SET " +
                                    "counselor_id=?, appointment_date=?, preferred_mode=?, time_slot=?, chief_concern=?, meeting_link=? " +
                                    "WHERE id=? AND status='SCHEDULED'"
                                );
                                psUpdate.setInt(1, counselorId);
                                psUpdate.setDate(2, java.sql.Date.valueOf(appointmentDate));
                                psUpdate.setString(3, mode);
                                psUpdate.setString(4, slot);
                                psUpdate.setString(5, chiefConcern);
                                psUpdate.setString(6, meetingLink);
                                psUpdate.setInt(7, editId);
                                psUpdate.executeUpdate(); 
                            }
                            else{
                                PreparedStatement ps = con.prepareStatement(
                                "INSERT INTO APPOINTMENT " +
                                "(student_id, counselor_id, appointment_date, preferred_mode, time_slot, chief_concern, status, created_at, meeting_link, student_joined, counselor_joined) " +
                                "VALUES(?,?,?,?,?,?, 'SCHEDULED', CURRENT_TIMESTAMP, ?, FALSE, FALSE)"
                                );

                                ps.setInt(1, studentId);
                                ps.setInt(2, counselorId);
                                ps.setDate(3, java.sql.Date.valueOf(appointmentDate));
                                ps.setString(4, mode);
                                ps.setString(5, slot);
                                ps.setString(6, chiefConcern);
                                ps.setString(7, meetingLink);
                                ps.executeUpdate();  
                            }
                            response.sendRedirect("StudentAppointments.jsp");
                            return;
                    }
                    con.close();
                    }catch(Exception e)
                    {
                        message = "<div class='error'>"+e.getMessage()+"</div>";
                    }
                }
            }
    }

      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("<title>Book Appointment | ManSparsh</title>\n");
      out.write("\n");
      out.write("<style>\n");
      out.write("body {\n");
      out.write("    margin: 0;\n");
      out.write("    font-family: Arial, sans-serif;\n");
      out.write("    background: url(\"https://images.unsplash.com/photo-1521737604893-d14cc237f11d?auto=format&fit=crop&w=1600&q=80\")\n");
      out.write("                center / cover no-repeat fixed;\n");
      out.write("    min-height: 100vh;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".dashboard-bg {\n");
      out.write("    min-height: 100vh;\n");
      out.write("    display: flex;\n");
      out.write("    justify-content: center;\n");
      out.write("    align-items: flex-start;\n");
      out.write("    padding: 80px 20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".container {\n");
      out.write("    width: 500px;\n");
      out.write("    max-width: 95%;\n");
      out.write("    background: rgba(255,255,255,0.95);\n");
      out.write("    padding: 40px 30px;\n");
      out.write("    border-radius: 20px;\n");
      out.write("    box-shadow: 0 25px 50px rgba(0,0,0,0.3);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".form-title {\n");
      out.write("    text-align: center;\n");
      out.write("    font-size: 26px;\n");
      out.write("    font-weight: bold;\n");
      out.write("    color: #2563eb;\n");
      out.write("    margin-bottom: 20px;\n");
      out.write("}\n");
      out.write("\n");
      out.write("label { font-weight: 600; color: #333; }\n");
      out.write("\n");
      out.write("input, select {\n");
      out.write("    width: 100%;\n");
      out.write("    padding: 12px;\n");
      out.write("    margin: 6px 0 14px;\n");
      out.write("    border-radius: 8px;\n");
      out.write("    border: 1px solid #ccc;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".checkbox-group {\n");
      out.write("    display: grid;\n");
      out.write("    grid-template-columns: repeat(2,1fr);\n");
      out.write("    gap: 6px;\n");
      out.write("    margin-bottom: 14px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".checkbox-label {\n");
      out.write("    display: flex;\n");
      out.write("    align-items: center;\n");
      out.write("    gap: 8px;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".checkbox-label input {\n");
      out.write("    width: 18px;\n");
      out.write("    height: 18px;\n");
      out.write("    accent-color: #2563eb;\n");
      out.write("}\n");
      out.write("\n");
      out.write("button:not(.back-btn){\n");
      out.write("    width: 100%;\n");
      out.write("    padding: 14px;\n");
      out.write("    background: #2563eb;\n");
      out.write("    border: none;\n");
      out.write("    color: white;\n");
      out.write("    font-size: 16px;\n");
      out.write("    border-radius: 25px;\n");
      out.write("    cursor: pointer;\n");
      out.write("}\n");
      out.write("\n");
      out.write("button:hover { background: #1e40af; }\n");
      out.write("\n");
      out.write(".success { text-align: center; color: green; font-weight: bold; }\n");
      out.write(".error { text-align: center; color: red; font-weight: bold; }\n");
      out.write(".modal {\n");
      out.write("    display: none;\n");
      out.write("    position: fixed;\n");
      out.write("    z-index: 999;\n");
      out.write("    left: 0;\n");
      out.write("    top: 0;\n");
      out.write("    width: 100%;\n");
      out.write("    height: 100%;\n");
      out.write("    background: rgba(0,0,0,0.5);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".modal-content {\n");
      out.write("    background: white;\n");
      out.write("    padding: 25px;\n");
      out.write("    border-radius: 12px;\n");
      out.write("    width: 350px;\n");
      out.write("    text-align: center;\n");
      out.write("    position: absolute;\n");
      out.write("    top: 50%;\n");
      out.write("    left: 50%;\n");
      out.write("    transform: translate(-50%, -50%);\n");
      out.write("    box-shadow: 0 10px 30px rgba(0,0,0,0.3);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".modal-content p {\n");
      out.write("    font-size: 16px;\n");
      out.write("    margin-bottom: 20px;\n");
      out.write("    color: #333;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".modal-content button {\n");
      out.write("    padding: 10px 20px;\n");
      out.write("    border: none;\n");
      out.write("    background: #2563eb;\n");
      out.write("    color: white;\n");
      out.write("    border-radius: 20px;\n");
      out.write("    cursor: pointer;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".modal-content button:hover {\n");
      out.write("    background: #1e40af;\n");
      out.write("}\n");
      out.write(".modal-content {\n");
      out.write("    animation: fadeIn 0.3s ease;\n");
      out.write("}\n");
      out.write("\n");
      out.write("@keyframes fadeIn {\n");
      out.write("    from { opacity: 0; transform: translate(-50%, -60%); }\n");
      out.write("    to { opacity: 1; transform: translate(-50%, -50%); }\n");
      out.write("}\n");
      out.write(".warning-box {\n");
      out.write("    position: fixed;\n");
      out.write("    top: 50%;\n");
      out.write("    left: 50%;\n");
      out.write("    transform: translate(-50%, -50%);\n");
      out.write("    \n");
      out.write("    background: #fef3c7;\n");
      out.write("    color: #92400e;\n");
      out.write("\n");
      out.write("    padding: 20px 30px;\n");
      out.write("    border-radius: 12px;\n");
      out.write("    font-weight: 600;\n");
      out.write("    text-align: center;\n");
      out.write("\n");
      out.write("    box-shadow: 0 10px 30px rgba(0,0,0,0.3);\n");
      out.write("    z-index: 2000;\n");
      out.write("}\n");
      out.write(".block-box {\n");
      out.write("    position: fixed;\n");
      out.write("    top: 50%;\n");
      out.write("    left: 50%;\n");
      out.write("    transform: translate(-50%, -50%);\n");
      out.write("    \n");
      out.write("    background: #fee2e2;\n");
      out.write("    color: #991b1b;\n");
      out.write("\n");
      out.write("    padding: 20px 30px;\n");
      out.write("    border-radius: 12px;\n");
      out.write("    font-weight: 600;\n");
      out.write("    text-align: center;\n");
      out.write("\n");
      out.write("    box-shadow: 0 10px 30px rgba(0,0,0,0.3);\n");
      out.write("    z-index: 2000;\n");
      out.write("}\n");
      out.write(".back-btn{\n");
      out.write("    position: fixed;\n");
      out.write("    top: 20px;\n");
      out.write("    left: 20px;\n");
      out.write("    display:flex;\n");
      out.write("    align-items:center;\n");
      out.write("    gap:8px;\n");
      out.write("    background:linear-gradient(135deg, #3d5af1, #1e2a48);\n");
      out.write("    color:white;\n");
      out.write("    border:none;\n");
      out.write("    padding:8px 14px;\n");
      out.write("    border-radius:8px;\n");
      out.write("    font-size:14px;\n");
      out.write("    font-weight:500;\n");
      out.write("    cursor:pointer;\n");
      out.write("    z-index: 9999;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".back-btn .arrow{\n");
      out.write("    font-size:16px;\n");
      out.write("    transition:transform 0.3s ease;\n");
      out.write("}\n");
      out.write("\n");
      out.write(".back-btn:hover{\n");
      out.write("    background:linear-gradient(135deg, #2f4ea2, #16213e);\n");
      out.write("    transform:translateY(-2px);\n");
      out.write("    box-shadow:0 6px 12px rgba(0,0,0,0.3);\n");
      out.write("}\n");
      out.write("\n");
      out.write(".back-btn:hover .arrow{\n");
      out.write("    transform:translateX(-4px);\n");
      out.write("}\n");
      out.write("</style>\n");
      out.write("</head>\n");
      out.write("\n");
      out.write("<body>\n");
      out.write("    <div style=\"margin-bottom:10px;\">\n");
      out.write("    <button onclick=\"goBack()\" class=\"back-btn\">\n");
      out.write("        <span class=\"arrow\">←</span> Back\n");
      out.write("    </button>\n");
      out.write("</div>\n");
      out.write("<div class=\"dashboard-bg\">\n");
      out.write("<div class=\"container\">\n");
      out.write("\n");
      out.write("<div class=\"form-title\">Book Appointment</div>\n");
      out.print( message );
      out.write("\n");
      out.write("<form method=\"post\" onsubmit=\"return validateAppointment();\">\n");
      out.write("<label>Student Name</label>\n");
      out.write("<input type=\"text\" value=\"");
      out.print( studentName );
      out.write("\" readonly>\n");
      out.write("\n");
      out.write("<label>Email</label>\n");
      out.write("<input type=\"text\" value=\"");
      out.print( studentEmail );
      out.write("\" readonly>\n");
      out.write("\n");
      out.write("<label>Smart Card ID</label>\n");
      out.write("<input type=\"text\" name=\"smartCard\"\n");
      out.write("       placeholder=\"Enter your Smart Card ID\" \n");
      out.write("       value=\"");
      out.print( smartCardVal!=null?smartCardVal:(dbSmart!=null?dbSmart:"") );
      out.write("\"\n");
      out.write("       required>\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<label>Date of Birth</label>\n");
      out.write("<input type=\"date\" name=\"dob\" \n");
      out.write("       value=\"");
      out.print( dobVal!=null?dobVal:(dbDob!=null?dbDob:"") );
      out.write("\" required>\n");
      out.write("\n");
      out.write("<label>Appointment Date</label>\n");
      out.write("       ");

    java.util.Calendar calMin = java.util.Calendar.getInstance();
    calMin.add(java.util.Calendar.DAY_OF_MONTH, 1); // +1 day (tomorrow)
    String minDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(calMin.getTime());

      out.write("\n");
      out.write("\n");
      out.write("<input type=\"date\" name=\"appointmentDate\" \n");
      out.write("min=\"");
      out.print( minDate );
      out.write("\"\n");
      out.write("value=\"");
      out.print( appointmentDateVal != null ? appointmentDateVal : (editId!=null?editDate:"") );
      out.write("\" \n");
      out.write("required>\n");
      out.write("<p style=\"font-size:13px;color:#666;\">* Tuesday is a holiday. Appointments cannot be booked on Tuesday.</p>\n");
      out.write("\n");
      out.write("<label>Phone</label>\n");
      out.write("<input type=\"text\" name=\"phone\" pattern=\"\\d{10}\" maxlength=\"10\" title=\"Enter exactly 10 digits\" value=\"");
      out.print( phoneVal!=null?phoneVal:(dbPhone!=null?dbPhone:"") );
      out.write("\" required>\n");
      out.write("\n");
      out.write("<label>Hostel</label>\n");
      out.write("<select name=\"hostel\" required>\n");
      out.write("    <option value=\"\">Select Hostel</option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Bai Shiksha Kutir".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Bai Shiksha Kutir\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Soudh".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Soudh\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Vishwa Needam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Vishwa Needam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Nilaya".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Nilaya\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Bhuwnam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Bhuwnam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Niwas".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Niwas\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Niketan".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Niketan\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Ayatan".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Ayatan\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Vihar".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Vihar\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Dham".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Dham\n");
      out.write("    </option>\n");
      out.write("    \n");
      out.write("    <option ");
      out.print( "Shri Shanta Nikunj".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Nikunj\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Puram".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Puram\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Paleyam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Paleyam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Alaya".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Alaya\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Geham".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Geham\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Niveshanam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Niveshanam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Ajiram".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Ajiram\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Gangotri".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Gangotri\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Vasam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Vasam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Ayanam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Ayanam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Pattnam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Pattnam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Lok".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Lok\n");
      out.write("    </option>\n");
      out.write("    \n");
      out.write("    <option ");
      out.print( "Shri Shanta Nagram".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Nagram\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Kulam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Kulam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Neri".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Neri\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Gram".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Gram\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Puri".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Puri\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Peetham".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Peetham\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Nigam".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Nigam\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Vatika".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Vatika\n");
      out.write("    </option>\n");
      out.write("    <option ");
      out.print( "Shri Shanta Aagar".equals(hostelVal!=null?hostelVal:dbHostel)?"selected":"" );
      out.write(">\n");
      out.write("        Shri Shanta Aagar\n");
      out.write("    </option>\n");
      out.write("</select>\n");
      out.write("\n");
      out.write("<label>Preferred Mode</label>\n");
      out.write("<select name=\"mode\" required>\n");
      out.write("    <option value=\"\">Select Mode</option>\n");
      out.write("    <option value=\"VIDEO_CALL\" \n");
      out.write("    ");
      out.print( "VIDEO_CALL".equals(modeVal!=null?modeVal:editMode)?"selected":"" );
      out.write(">Video Call</option>\n");
      out.write("    <option value=\"PHONE_CALL\" \n");
      out.write("    ");
      out.print( "PHONE_CALL".equals(modeVal!=null?modeVal:editMode)?"selected":"" );
      out.write(">Phone Call</option>\n");
      out.write("    <option value=\"IN_PERSON\" \n");
      out.write("    ");
      out.print( "IN_PERSON".equals(modeVal!=null?modeVal:editMode)?"selected":"" );
      out.write(">In-Person</option>\n");
      out.write("</select>\n");
      out.write("\n");
      out.write("<label>Time Slot</label>\n");
      out.write("<select name=\"slot\" id=\"slot\" required>\n");
      out.write("    <option value=\"\">Select Appointment Date First</option>\n");
      out.write("</select>\n");
      out.write("\n");
      out.write("<input type=\"hidden\" name=\"counselorId\" id=\"counselorId\">\n");
      out.write("\n");
      out.write("<label>Chief Concern</label>\n");
      out.write("<div class=\"checkbox-group\">\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Appetite\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Appetite")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Appetite")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Appetite\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Family Conflict\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Family Conflict")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Family Conflict")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Family Conflict\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Interpersonal Relations\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Interpersonal Relations")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Interpersonal Relations")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Interpersonal Relations\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Burnout\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Burnout")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Burnout")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Burnout\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Emotional Breakdown\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Emotional Breakdown")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Emotional Breakdown")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Emotional Breakdown\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Concentration\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Concentration")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Concentration")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Concentration\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Time Management\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Time Management")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Time Management")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Time Management\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Stress\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Stress")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Stress")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Stress\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Career\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Career")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Career")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Career\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Academic\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Academic")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Academic")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Academic\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Sleep\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.equals("Sleep")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Sleep")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Sleep\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<label class=\"checkbox-label\">\n");
      out.write("<input type=\"checkbox\" name=\"concern[]\" value=\"Other\" id=\"otherChk\"\n");

if(concernsVal != null){
    for(String c: concernsVal){
        if(c.startsWith("Other")) out.print("checked");
    }
}
else if(editId!=null && editConcern!=null && editConcern.contains("Other(")){
    out.print("checked");
}

      out.write("\n");
      out.write("> Other\n");
      out.write("</label>\n");
      out.write("\n");
      out.write("<div id=\"otherBox\" style=\"display:none; margin-top:8px;\">\n");
      out.write("<textarea name=\"otherText\" id=\"otherText\"\n");
      out.write("placeholder=\"Enter (max 20 chars)\"\n");
      out.write("maxlength=\"20\"\n");
      out.write("style=\"width:100%;padding:10px;border-radius:8px;border:1px solid #ccc;\">");
      out.print( 
editId!=null && editConcern!=null && editConcern.contains("Other(")
? editConcern.substring(editConcern.indexOf("Other(")+6, editConcern.indexOf(")"))
: "" );
      out.write("</textarea>\n");
      out.write("\n");
      out.write("<div style=\"font-size:12px;color:#666;text-align:right;\">\n");
      out.write("<span id=\"charCount\">0</span>/20\n");
      out.write("</div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<button type=\"submit\" name=\"submit\">Submit Request</button>\n");
      out.write("</form>\n");
      out.write("<div id=\"customModal\" class=\"modal\">\n");
      out.write("  <div class=\"modal-content\">\n");
      out.write("    <p>⚠️ You already have a scheduled appointment.</p>\n");
      out.write("    <button type=\"button\" onclick=\"closeModal()\">OK</button>\n");
      out.write("  </div>\n");
      out.write("</div>\n");
      out.write("</div>\n");
      out.write("</div>\n");
      out.write("    \n");
      out.write("    <script>\n");
      out.write("        const otherChk = document.getElementById(\"otherChk\");\n");
      out.write("        const otherBox = document.getElementById(\"otherBox\");\n");
      out.write("        const otherText = document.getElementById(\"otherText\");\n");
      out.write("        const charCount = document.getElementById(\"charCount\");\n");
      out.write("\n");
      out.write("        otherChk.addEventListener(\"change\", function(){\n");
      out.write("            if(this.checked){\n");
      out.write("                otherBox.style.display = \"block\";\n");
      out.write("                otherText.required = true;\n");
      out.write("            }else{\n");
      out.write("                otherBox.style.display = \"none\";\n");
      out.write("                otherText.value = \"\";\n");
      out.write("                charCount.innerText = \"0\";\n");
      out.write("                otherText.required = false;\n");
      out.write("            }\n");
      out.write("        });\n");
      out.write("\n");
      out.write("        otherText.addEventListener(\"input\", function(){\n");
      out.write("            charCount.innerText = this.value.length;\n");
      out.write("        });\n");
      out.write("        // Show Other automatically in edit mode\n");
      out.write("window.addEventListener(\"load\", function(){\n");
      out.write("    ");
 if(editId!=null && editConcern!=null && editConcern.contains("Other(")){ 
      out.write("\n");
      out.write("        otherBox.style.display = \"block\";\n");
      out.write("        otherText.required = true;\n");
      out.write("        charCount.innerText = otherText.value.length;\n");
      out.write("    ");
 } 
      out.write("\n");
      out.write("});\n");
      out.write("    </script>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("const appointmentDate = document.querySelector(\"input[name='appointmentDate']\");\n");
      out.write("const slotSelect = document.getElementById(\"slot\");\n");
      out.write("const counselorInput = document.getElementById(\"counselorId\");\n");
      out.write("\n");
      out.write("appointmentDate.addEventListener(\"change\", function(){\n");
      out.write("\n");
      out.write("    if(this.value === \"\"){\n");
      out.write("        slotSelect.innerHTML = \"<option value=''>Select Appointment Date First</option>\";\n");
      out.write("        slotSelect.disabled = true;\n");
      out.write("        return;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    fetch(\"GetAvailableSlots.jsp?date=\" + this.value + \"&editId=");
      out.print( editId != null ? editId : 0 );
      out.write("\")\n");
      out.write("    .then(res => res.text())\n");
      out.write("    .then(data => {\n");
      out.write("\n");
      out.write("        slotSelect.innerHTML = data;\n");
      out.write("        slotSelect.disabled = false;\n");
      out.write("\n");
      out.write("        ");
 if(editId != null){ 
      out.write("\n");
      out.write("        const oldSlot = \"");
      out.print( editSlot );
      out.write("\";\n");
      out.write("\n");
      out.write("        for(let i=0;i<slotSelect.options.length;i++){\n");
      out.write("\n");
      out.write("            if(slotSelect.options[i].value === oldSlot){\n");
      out.write("\n");
      out.write("                slotSelect.selectedIndex = i;\n");
      out.write("\n");
      out.write("                counselorInput.value =\n");
      out.write("                    slotSelect.options[i].getAttribute(\"data-counselor\");\n");
      out.write("\n");
      out.write("                break;\n");
      out.write("            }\n");
      out.write("        }\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("\n");
      out.write("    })\n");
      out.write("    .catch(err => {\n");
      out.write("        slotSelect.innerHTML = \"<option>Error loading slots</option>\";\n");
      out.write("        console.error(err);\n");
      out.write("    });\n");
      out.write("\n");
      out.write("});\n");
      out.write("\n");
      out.write("slotSelect.addEventListener(\"change\", function () {\n");
      out.write("\n");
      out.write("    const selectedOption = this.options[this.selectedIndex];\n");
      out.write("\n");
      out.write("    const cid = selectedOption.getAttribute(\"data-counselor\");\n");
      out.write("\n");
      out.write("    counselorInput.value = cid ? cid : \"\";\n");
      out.write("\n");
      out.write("});\n");
      out.write("\n");
      out.write("window.addEventListener(\"load\", function(){\n");
      out.write("\n");
      out.write("    if(appointmentDate.value !== \"\"){\n");
      out.write("        appointmentDate.dispatchEvent(new Event('change'));\n");
      out.write("    }\n");
      out.write("\n");
      out.write("});\n");
      out.write("</script>\n");
      out.write("<script>\n");
      out.write("var hasScheduledAppointment = ");
      out.print( hasScheduledAppointment );
      out.write(";\n");
      out.write("function validateAppointment(){\n");
      out.write("    var phone = document.querySelector(\"input[name='phone']\").value;\n");
      out.write("    if(!/^\\d{10}$/.test(phone)){\n");
      out.write("        alert(\"Invalid phone number\");\n");
      out.write("        return false;\n");
      out.write("    }\n");
      out.write("    var editId = ");
      out.print( editId != null ? editId : 0 );
      out.write(";\n");
      out.write("\n");
      out.write("    if(hasScheduledAppointment && editId == 0){\n");
      out.write("        document.getElementById(\"customModal\").style.display = \"block\";\n");
      out.write("        return false;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    return true;\n");
      out.write("}\n");
      out.write("function closeModal(){\n");
      out.write("    document.getElementById(\"customModal\").style.display = \"none\";\n");
      out.write("}\n");
      out.write("window.onclick = function(event) {\n");
      out.write("    const modal = document.getElementById(\"customModal\");\n");
      out.write("    if (event.target === modal) {\n");
      out.write("        modal.style.display = \"none\";\n");
      out.write("    }\n");
      out.write("}\n");
      out.write("function showWarningModal(){\n");
      out.write("    alert(\"⚠️ You have cancelled multiple appointments. Continued cancellations may restrict booking.\");\n");
      out.write("}\n");
      out.write("function showBlockModal(date){\n");
      out.write("    alert(\"Due to repeated cancellations, booking is restricted until \" + date);\n");
      out.write("}\n");
      out.write("function goBack(){\n");
      out.write("    window.location.href = \"StudentDashboard.jsp\";\n");
      out.write("}\n");
      out.write("</script>\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
