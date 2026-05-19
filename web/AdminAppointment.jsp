<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.regex.*" %>
<%@ page import="java.security.MessageDigest" %>
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
Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

String action = request.getParameter("action");
boolean actionSuccess = false;
String type = "";

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    con = DriverManager.getConnection("jdbc:derby://localhost:1527/ManSparsh","bns","bns");

    if(action != null){

        if(action.equals("status")){
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            ps = con.prepareStatement("UPDATE APPOINTMENT SET STATUS=? WHERE ID=?");
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();

            actionSuccess = true;
            type="status";
        }

        if(action.equals("delete")){
            int id = Integer.parseInt(request.getParameter("id"));

            ps = con.prepareStatement("DELETE FROM APPOINTMENT WHERE ID=?");
            ps.setInt(1, id);
            ps.executeUpdate();

            actionSuccess = true;
            type="delete";
        }

        if(action.equals("update")){
            int id = Integer.parseInt(request.getParameter("id"));
            String date = request.getParameter("date");
            String time = request.getParameter("time");

            ps = con.prepareStatement("UPDATE APPOINTMENT SET APPOINTMENT_DATE=?, TIME_SLOT=? WHERE ID=?");
            ps.setString(1, date);
            ps.setString(2, time);
            ps.setInt(3, id);
            ps.executeUpdate();

            actionSuccess = true;
            type="update";
        }
    }

}catch(Exception e){
    out.println("Error: "+e);
}
%>

<html>
<head>
<title>Admin Appointments</title>

<style>
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: #f4f6f9;
    overflow-x: hidden;
}
.sidebar {
    width:240px;
    background:rgba(30,42,72,0.95);
    color:white;
    padding:20px;
    position:fixed;
    height:100vh;
}
.sidebar h2 {
    text-align:center;
    color:#9ecbff;
    margin-bottom:30px;
}
.sidebar a {
    display:block;
    padding:12px;
    border-radius:8px;
    color:white;
    text-decoration:none;
    margin-bottom:10px;
    transition:0.3s;
}
.sidebar a:hover {
    background:#3d5af1;
}

.main {
    margin-left: 260px;   /* pushes content right */
    padding: 20px;
}
.card {
    background: white;
    border-radius: 8px;
    overflow-x: auto;   /* allows horizontal scroll if needed */
}
table {
    width: 100%;
    border-collapse: collapse;
    min-width: 900px;   /* prevents shrinking */
}
.header { background: #2f4f9d; color: white; padding: 15px; border-radius: 8px 8px 0 0; }
.card { background: white; border-radius: 8px; overflow: hidden; }

table { width: 100%; border-collapse: collapse; }
th, td { padding: 12px; }
th { background: #e9edf5; color: #2f4f9d; }
tr:hover { background: #f1f5ff; }

.status { padding: 5px 10px; border-radius: 5px; font-size: 12px; }
.scheduled { background: #d4edda; color: #155724; }
.pending { background: #fff3cd; color: #856404; }
.cancelled { background: #f8d7da; color: #721c24; }

button { padding: 6px 10px; margin: 2px; border: none; border-radius: 5px; cursor: pointer; }
.approve { background: green; color: white; }
.reject { background: orange; }
.delete { background: red; color: white; }
.edit { background: blue; color: white; }

/* MODALS */
.modal {
    display:none;
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background: rgba(0,0,0,0.5);
    backdrop-filter: blur(5px);
    z-index:999;
}

.modal-box {
    background:white;
    width:420px;
    margin:8% auto;
    padding:25px;
    border-radius:12px;
}

.modal-box input {
    width:100%;
    padding:10px;
    margin-top:5px;
    border-radius:6px;
    border:1px solid #ccc;
}

.modal-box label {
    margin-top:10px;
    display:block;
}

.modal-actions {
    margin-top:20px;
    display:flex;
    justify-content:space-between;
}

.primary { background:#3b82f6; color:white; }
.secondary { background:#ccc; }

.confirm-box {
    background:white;
    width:300px;
    margin:15% auto;
    padding:20px;
    text-align:center;
    border-radius:10px;
}

.yes-btn { background:green; color:white; padding:8px 15px; }
.no-btn { background:red; color:white; padding:8px 15px; }
.back-btn{
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
    transition:all 0.3s ease;
    box-shadow:0 3px 8px rgba(0,0,0,0.2);
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
.mode {
    padding:5px 10px;
    border-radius:5px;
    font-size:12px;
    background:#e3f2fd;
    color:#0d47a1;
}
.back-btn{
    position: fixed;
    top: 20px;
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

<script>
let formToSubmit=null;

function openEdit(id,date,time){
    document.getElementById("editId").value=id;
    document.getElementById("editDate").value=date;
    document.getElementById("editTime").value=time;
    document.getElementById("editModal").style.display="block";
}

function closeModal(){
    document.getElementById("editModal").style.display="none";
}

function openConfirm(msg, form){
    document.getElementById("confirmText").innerText=msg;
    document.getElementById("confirmModal").style.display="block";
    formToSubmit=form;
    return false;
}

function proceedAction(){
    document.getElementById("confirmModal").style.display="none";
    formToSubmit.submit();
}

function closeConfirm(){
    document.getElementById("confirmModal").style.display="none";
}
</script>

</head>

<body>
<div style="margin-bottom:10px;">
    <button onclick="goBack()" class="back-btn">
        <span class="arrow">←</span> Back
    </button>
</div>

<div class="sidebar">
 <!-- BACK BUTTON (ADD THIS) -->
<div style="margin-bottom:10px;">
    <button onclick="goBack()" class="back-btn">
        ←
    </button>
</div>
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
<div class="card">
<div class="header">All Appointments</div>

<table>
<tr>
<th>ID</th>
<th>Student</th>
<th>Counselor</th>
<th>Date</th>
<th>Time</th>
<th>Status</th>
<th>Preferred Mode</th>
</tr>

<%
try{
 String query="SELECT a.ID, s.NAME student_name, c.NAME counselor_name, a.APPOINTMENT_DATE, a.TIME_SLOT, a.STATUS, a.PREFERRED_MODE FROM APPOINTMENT a, STUDENT s, COUNSELOR c WHERE a.STUDENT_ID=s.STUDENT_ID AND a.COUNSELOR_ID=c.COUNSELOR_ID";

    ps=con.prepareStatement(query);
    rs=ps.executeQuery();

    while(rs.next()){
        int id=rs.getInt("ID");
        String date=rs.getDate("APPOINTMENT_DATE").toString();
        String time=rs.getString("TIME_SLOT");
        String status=rs.getString("STATUS");
%>

<tr>
<td><%=id%></td>
<td><%=rs.getString("student_name")%></td>
<td><%=rs.getString("counselor_name")%></td>
<td><%=date%></td>
<td><%=time%></td>

<td>
<span class="status
<%= status.equalsIgnoreCase("SCHEDULED") ? "scheduled" :
    status.equalsIgnoreCase("REQUESTED") ? "pending" : "cancelled" %>">
<%=status%>
</span>
</td>

<td>
    <%= rs.getString("PREFERRED_MODE") %>
</td>
</tr>

<%
    }
}catch(Exception e){
    e.printStackTrace();   // shows error in server console
    out.println("Error: " + e.getMessage());
}

%>

</table>
</div>
</div>

<!-- EDIT MODAL -->
<div id="editModal" class="modal">
<div class="modal-box">
<h2>Edit Appointment</h2>

<form method="post" onsubmit="return openConfirm('Update appointment?',this)">
<input type="hidden" name="id" id="editId">
<input type="hidden" name="action" value="update">

<label>Date</label>
<input type="date" name="date" id="editDate">

<label>Time</label>
<input type="text" name="time" id="editTime">

<div class="modal-actions">
<button type="submit" class="primary">Update</button>
<button type="button" class="secondary" onclick="closeModal()">Cancel</button>
</div>
</form>

</div>
</div>

<!-- CONFIRM MODAL -->
<div id="confirmModal" class="modal">
<div class="confirm-box">
<p id="confirmText">Are you sure?</p>
<br>
<button onclick="proceedAction()" class="yes-btn">Yes</button>
<button onclick="closeConfirm()" class="no-btn">No</button>
</div>
</div>

<script>
<% if(actionSuccess){ %>
window.location.href = window.location.pathname + "?type=<%=type%>";
<% } %>
     function goBack(){
    window.location.href = "AdminDashboard.jsp";
}
</script>

</body>
</html>
