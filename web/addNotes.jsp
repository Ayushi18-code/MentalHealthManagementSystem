<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    /*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 
String appointmentId = request.getParameter("appointmentId");
if(appointmentId == null){
    out.println("<h3 style='color:red'>Invalid Access</h3>");
    return;
}
%>
<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

// Default values (important to avoid null issues)
String problematic = "";
String targeted = "";
String intervention = "";
String responseText = "";
String plan = "";

try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    conn = DriverManager.getConnection("jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    String sql = "SELECT * FROM SESSION_NOTES WHERE appointment_id=?";
    ps = conn.prepareStatement(sql);
    ps.setInt(1, Integer.parseInt(appointmentId));

    rs = ps.executeQuery();

    if(rs.next()){
        problematic = rs.getString("problematic_behavior");
        targeted = rs.getString("targeted_behavior");
        intervention = rs.getString("intervention");
        responseText = rs.getString("response");
        plan = rs.getString("plan");
    }

} catch(Exception e){
    e.printStackTrace();
}
%>
<html>
<style>
/* Form Styles - Matches your theme */
.notes-form-container {
    max-width: 800px; margin: 40px auto; padding: 40px;
    background: white; border-radius: 20px; box-shadow: 0 25px 50px rgba(0,0,0,0.15);
    font-family: Arial, sans-serif;
}

.form-title {
    text-align: center; color: #4a5568; font-size: 2.2em; margin-bottom: 10px;
    background: linear-gradient(135deg, #6f63ff, #8b7eff); -webkit-background-clip: text; -webkit-text-fill-color: transparent;
}

.form-section {
    margin-bottom: 25px;
}

.form-label {
    display: block; margin-bottom: 8px; font-weight: 600; color: #475569;
    font-size: 15px;
}

.form-textarea {
    width: 100%; min-height: 120px; padding: 16px; border: 2px solid #e2e8f0;
    border-radius: 12px; font-size: 16px; font-family: Arial, sans-serif;
    resize: vertical; transition: all 0.3s;
    box-sizing: border-box;
}

.form-textarea:focus {
    outline: none; border-color: #6f63ff; box-shadow: 0 0 0 3px rgba(111,99,255,0.1);
    transform: translateY(-2px);
}

.file-upload-area {
    border: 2px dashed #cbd5e1; border-radius: 16px; padding: 40px; text-align: center;
    background: #f8fafc; transition: all 0.3s; cursor: pointer;
    margin-bottom: 25px;
}

.file-upload-area:hover {
    border-color: #6f63ff; background: #f0f4ff; transform: translateY(-3px);
}

.file-upload-area.dragover { border-color: #6f63ff; background: #e0e7ff; }

.file-info { color: #64748b; font-size: 14px; margin-top: 12px; }

.form-buttons {
    display: flex; gap: 15px; justify-content: center; margin-top: 35px;
}

.btn {
    padding: 14px 32px; border: none; border-radius: 12px; font-size: 16px;
    font-weight: 600; cursor: pointer; transition: all 0.3s;
    text-decoration: none; display: inline-block; text-align: center;
}

.btn-primary {
    background: linear-gradient(135deg, #6f63ff, #8b7eff); color: white;
}

.btn-primary:hover { transform: translateY(-2px); box-shadow: 0 15px 30px rgba(111,99,255,0.4); }

.btn-secondary {
    background: #f1f5f9; color: #475569; border: 2px solid #e2e8f0;
}

.btn-secondary:hover { background: #e2e8f0; transform: translateY(-2px); }
      body{ margin:0; font-family:Arial, sans-serif; background:#f4f6fb; }

.navbar{
    background:#6f63ff; height:60px; display:flex;
    align-items:center; justify-content:space-between;
    padding:0 40px; color:white; position:relative;
}

.logo{ font-size:26px; font-weight:bold; }
.nav-right{ display:flex; align-items:center; gap:20px; }

.nav-links a{
    color:white; text-decoration:none; margin:0 12px; font-size:16px;
}

.student-mini{
    display:flex; align-items:center; gap:8px;
    background:rgba(255,255,255,0.2); padding:5px 12px;
    border-radius:20px; cursor:pointer; position:relative;
}

.student-mini img{ width:30px; height:30px; border-radius:50%; }

.profile-dropdown{
    display:none; position:absolute; top:45px; right:0;
    background:white; min-width:200px; border-radius:12px;
    box-shadow:0 12px 30px rgba(0,0,0,0.25); overflow:hidden; z-index:1000;
}

.profile-dropdown a{
    display:block; padding:12px 18px; text-decoration:none;
    color:#333; font-size:15px;
}

.profile-dropdown a:hover{ background:#f1f5f9; }
/* PURE CSS DROPDOWN - No JavaScript */
.profile-section {
    position: relative;
    cursor: pointer;
}



/* HOVER OUT DELAY (Smooth) */
.profile-section {
    --close-delay: 0.2s;
}



.profile-dropdown a {
    display: block;
    padding: 16px 20px;
    color: #475569;
    text-decoration: none;
    font-weight: 500;
    font-size: 15px;
    border-bottom: 1px solid #f8fafc;
    transition: all 0.2s;
}

.profile-dropdown a:last-child { border-bottom: none; }

.profile-dropdown a:hover {
    background: linear-gradient(90deg, #f8fafc, #f1f5f9);
    color: #6f63ff;
    padding-left: 28px;
}
/* MAGIC: SHOW WHEN CHECKBOX CHECKED */
.profile-section #profileToggle:checked ~ .profile-dropdown {
    display: block;
    opacity: 1;
    transform: translateY(0);
}
.toggle-checkbox {
    position: absolute;
    opacity: 0;
    width: 0;
    height: 0;
}

/* RESPONSIVE */
@media (max-width: 768px) {
    .profile-dropdown {
        right: auto;
        left: 0;
        min-width: 200px;
    }
}

.container { max-width: 1400px; margin: 0 auto; }
        h1 { text-align: center; color:#4a5568; margin-bottom: 20px; font-size: 2.5em; }

  html, body {
  height: 100%;
  margin: 0;
}

.page-wrapper {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
main {
  flex: 1;
}
.footer-desc {
    max-width: 100vw;
    margin: 0 auto;
    font-size: 16px;
    line-height: 1.7;
    text-align: center;
    background: #6f63ff;
    color: white;
    display: flex;
    justify-content: center;   /* Horizontal centering of flex items */

}
.back-btn{
    position: fixed;
    top: 80px;
    left: 20px;
    display:flex;
    align-items:center;
    gap:8px;
    background:linear-gradient(135deg, #3d5af1, #1e2a48);
    color:white;
    border:none;
    padding:8px 14px;
    border-radius:8px;
    font-size:14px;
    font-weight:500;
    cursor:pointer;
    z-index: 9999;
}

.back-btn .arrow{
    font-size:16px;
    transition:transform 0.3s ease;
}

.back-btn:hover{
    background:linear-gradient(135deg, #2f4ea2, #16213e);
    transform:translateY(-2px);
    box-shadow:0 6px 12px rgba(0,0,0,0.3);
}

.back-btn:hover .arrow{
    transform:translateX(-4px);
}
</style>
<body>
    <div style="margin-bottom:10px;">
    <button onclick="goBack()" class="back-btn">
        <span class="arrow"></span> Back
    </button>
</div>
      <!-- NAVBAR -->
<div class="navbar">
    <div class="logo">ManSparsh</div>

     <div class="nav-right">
        <div class="nav-links">
            <a href="CounselorDashboard.jsp">Home</a>
            <a href="CounselorAboutUs.jsp">About Us</a>
            <a href="CounselorFeatures.jsp#">Features</a>
            <a href="CounselorContactUs.jsp">Contact</a>
        </div>

    <div class="profile-section">
        <input type="checkbox" id="profileToggle" class="toggle-checkbox">
        <label for="profileToggle" class="student-mini">
            <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Profile">
            <span><%= session.getAttribute("counselorName") != null ? session.getAttribute("counselorName") : "Peer Counselor" %></span>
        </label>
        <div class="profile-dropdown" id="profileDropdown">
            <a href="<%= request.getContextPath() %>/CounselorEditProfile.jsp">Edit Profile</a>
            <a href="<%= request.getContextPath() %>/CounselorHelp.jsp">Help</a>
            <a href="<%= request.getContextPath() %>/feedback.jsp">Send Feedback</a>
            <a href="<%= request.getContextPath() %>/Home Page.jsp">Logout</a>
        </div>
    </div>

    </div>

    </div>
<div class="notes-form-container">
    <h2 class="form-title">Clinical Documentation </h2>
    <p style="text-align:center; color:#64748b; margin-bottom:35px;">Document Subject's progress comprehensively</p>
     <%
String status = request.getParameter("status");
if("success".equals(status)){
%>
    <div style="
        background:#dcfce7;
        color:#166534;
        padding:15px;
        border-radius:10px;
        margin-bottom:20px;
        text-align:center;
        font-weight:600;">
        Notes saved successfully!
    </div>
<%
}
%>
       <form method="post" action="SaveNotes.jsp">
    <input type="hidden" name="appointmentId" value="<%= appointmentId %>">

    <div class="form-section">
        <label class="form-label">Problematic Behavior</label>
        <textarea name="problematicBehavior" class="form-textarea"placeholder="Describe patient's problematic behavior..." ><%= problematic != null ? problematic : "" %></textarea>
    </div>
       
        <div class="form-section">
            <label class="form-label">Targeted Behavior</label>
            <textarea name="targetedBehavior" class="form-textarea" placeholder="Describe targeted or positive patient behavior..."><%= targeted != null ? targeted : "" %></textarea>
        </div>
       
        <div class="form-section">
            <label class="form-label">Intervention</label>
            <textarea name="intervention" class="form-textarea" placeholder="Interventions applied during session..."><%= intervention != null ? intervention : "" %></textarea>
        </div>
       
        <div class="form-section">
            <label class="form-label">Response</label>
            <textarea name="response" class="form-textarea" placeholder="Patient's response to interventions..."><%= responseText != null ? responseText : "" %></textarea>
        </div>
       
        <div class="form-section">
            <label class="form-label">Plan</label>
            <textarea name="plan" class="form-textarea" placeholder="Next steps and follow-up plan..."><%= plan != null ? plan : "" %></textarea>
        </div>
       
        <div class="form-buttons">
            <button type="submit" class="btn btn-primary">Save</button>
        </div>
    </form>
</div>

    <footer class="footer-desc">
             © 2026 ManSparsh Online Counseling &amp; Therapy. All rights reserved.
         </footer>
        <script>
function goBack(){
    window.location.href = "CounselorDashboard.jsp";
}
</script>
</body>
</html>