<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

// Check session
if (session.getAttribute("adminId") == null) {
    response.sendRedirect("AdminLogin.jsp");
    return;
}
%>

<%
int totalStudents = 0;
int totalCounselors = 0;
int totalFaculty = 0;
int totalAppointments = 0;
int pendingAppointments = 0;
int totalFeedback = 0;

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    Connection con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    Statement st = con.createStatement();

    // Total Students
    ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM STUDENT");
    if(rs1.next()) totalStudents = rs1.getInt(1);

    // Total Counselors
    ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM COUNSELOR");
    if(rs2.next()) totalCounselors = rs2.getInt(1);

    // Total Appointments
    ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM APPOINTMENT");
    if(rs3.next()) totalAppointments = rs3.getInt(1);

   

    // Feedback Count
    ResultSet rs5 = st.executeQuery("SELECT COUNT(*) FROM FEEDBACK");
    if(rs5.next()) totalFeedback = rs5.getInt(1);
    // Total Faculty
ResultSet rs6 = st.executeQuery("SELECT COUNT(*) FROM FACULTY");
if(rs6.next()) totalFaculty = rs6.getInt(1);

    con.close();

}catch(Exception e){
    out.println("Error: " + e);
}
%>
<!DOCTYPE html>
<html>
<head>
<title>ManSparsh Admin</title>
<style>
html, body {
    height: 100%;
    margin: 0;
    font-family: 'Segoe UI', Arial, sans-serif;
}
body {
    background:
        linear-gradient(rgba(0,0,0,0.45), rgba(0,0,0,0.45)),
        url("https://images.unsplash.com/photo-1521791136064-7986c2920216?auto=format&fit=crop&w=1920&q=90")
        no-repeat center center fixed;
    background-size: cover;
}
.layout { display:flex; min-height:100vh; backdrop-filter:blur(2px); }
.sidebar { width:240px; background:rgba(30,42,72,0.95); color:white; padding:20px; }
.sidebar h2 { text-align:center; color:#9ecbff; margin-bottom:30px; }
.sidebar a { display:block; padding:12px; border-radius:8px; color:white; text-decoration:none; margin-bottom:10px; transition:0.3s; }
.sidebar a:hover { background:#3d5af1; }

.main { flex:1; padding:20px 30px; display:flex; flex-direction:column; }
.card-link {
    text-decoration: none;
    color: inherit;
}

.card-link:hover .card {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 10px 22px rgba(0,0,0,0.3);
}
.topbar {
    display:flex;
    justify-content:flex-end;   /* ✅ moves profile to right */
    align-items:center;
   
    padding:12px 20px;
   
    margin-bottom:20px;
}
    background:rgba(255,255,255,0.9);
    padding:12px 20px;
    border-radius:14px; 
    margin-bottom:20px;
}


.profile {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 8px 18px;

    border-radius: 50px;   /* pill shape */

    background:rgba(30,42,72,0.95); color:white; padding:20px;
    color: white;

    font-weight: 500;
    font-size: 15px;

    box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    transition: 0.3s ease;
}

.profile:hover {
    transform: scale(1.05);
}
.profile img {
    width: 30px;
    height: 30px;
    border-radius: 50%;
}
.profile {
    display:flex;
    align-items:center;
    gap:12px;
    padding:6px 18px;
    border-radius:50px;

    background: linear-gradient(135deg, #6a5af9, #8b7bff);
    color:white;
}

.profile img {
    background: rgba(255,255,255,0.3);
    padding:6px;
    border-radius:50%;
}
.dropdown{
    position:fixed; top:70px; right:40px;
    background:white; box-shadow:0 4px 10px rgba(0,0,0,0.15);
    border-radius:8px; display:none; min-width:150px; z-index:1000;
}
.dropdown a{ display:block; padding:10px; text-decoration:none; color:#333; }
.dropdown a:hover{ background:#f0f0f0; }
.profile:hover .dropdown{ display:block; }

.cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:18px; margin-bottom:20px; }
.card {
    background:rgba(255,255,255,0.92); padding:22px; border-radius:16px;
    box-shadow:0 6px 15px rgba(0,0,0,0.2); text-align:center;
    transition:0.3s ease;
}
.card:hover {
    transform: translateY(-6px) scale(1.02);
    box-shadow: 0 10px 22px rgba(0,0,0,0.3);
}
.card h2{ margin:0; font-size:32px; color:#3d5af1; }
.card p{ margin-top:6px; font-size:14px; color:#555; }

.section{ display:grid; grid-template-columns:2fr 1fr; gap:20px; flex:1; }
.box{
    background:rgba(255,255,255,0.92); padding:20px; border-radius:16px;
    box-shadow:0 4px 12px rgba(0,0,0,0.2);
}

table{ width:100%; border-collapse:collapse; }
th,td{ padding:10px; border-bottom:1px solid #ddd; }
th{ background:#eef2ff; }

.status{ padding:5px 10px; border-radius:10px; font-size:12px; color:white; }
.confirmed{ background:#4caf50; }
.pending{ background:#ff9800; }
.completed{ background:#2196f3; }

footer{ text-align:center; color:white; margin-top:20px; font-size:14px; }
</style>
</head>

<body>
<div class="layout">

<div class="sidebar">
    <h2>ManSparsh Admin</h2>
    <a href="AdminManageUser.jsp">User Management</a>
    <a href="AdminAppointment.jsp">Appointments</a>
    <a href="AdminWorkshop.jsp">Workshops</a>
    <a href="AdminManageHostel.jsp">Hostel Management</a>
    <a href="AdminManageResources.jsp">Resources</a>
    <a href="AdminFeedback.jsp">Feedback</a>
    <a href="AdminLogout.jsp">Logout</a>
</div>

<div class="main">

<div class="topbar">
   

    <div class="profile">
        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Admin">
        <span><%= session.getAttribute("adminName") %></span>
    </div>
</div>

<div class="cards">

    <a href="AdminManageUser.jsp?type=student" class="card-link">
        <div class="card">
            <h2><%= totalStudents %></h2>
            <p>Total Students</p>
        </div>
    </a>

    <a href="AdminManageUser.jsp?type=counselor" class="card-link">
        <div class="card">
            <h2><%= totalCounselors %></h2>
            <p>Total Counselors</p>
        </div>
    </a>

    <a href="AdminManageUser.jsp?type=faculty" class="card-link">
        <div class="card">
            <h2><%= totalFaculty %></h2>
            <p>Total Faculty</p>
        </div>
    </a>

    <a href="AdminAppointment.jsp" class="card-link">
        <div class="card">
            <h2><%= totalAppointments %></h2>
            <p>Total Appointments</p>
        </div>
    </a>

   

    <a href="AdminFeedback.jsp" class="card-link">
        <div class="card">
            <h2><%= totalFeedback %></h2>
            <p>Feedback Received</p>
        </div>
    </a>

</div>

</div>
</div>
        <footer class="footer-desc">
             © 2026 ManSparsh Online Counseling &amp; Therapy. All rights reserved.
         </footer>
</body>
</html>
