<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
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
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh", "bns", "bns"
    );
    String action = request.getParameter("action");

if("hide".equals(action)){
    int id = Integer.parseInt(request.getParameter("id"));

    PreparedStatement hidePs = con.prepareStatement(
        "UPDATE BNS.FEEDBACK SET IS_VISIBLE = 0 WHERE FEEDBACK_ID = ?"
    );

    hidePs.setInt(1, id);
    hidePs.executeUpdate();
}
    String sql = "SELECT * FROM BNS.FEEDBACK WHERE IS_VISIBLE = 1 ORDER BY FEEDBACK_ID DESC";
    ps = con.prepareStatement(sql);
    rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Feedback | ManSparsh</title>

<style>
body{
    margin:0;
    font-family:Segoe UI;
    background:#f4f7fb;
    overflow-x:hidden;
}

/* SIDEBAR */
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
/* MAIN */
.main{
    margin-left:260px;   /* add extra space */
    padding:20px;
    width:calc(100% - 260px);  /* prevent overflow */
}
table{
    width:100%;
    min-width:1000px;   /* prevents squeezing */
    border-collapse:collapse;
    background:white;
    border-radius:10px;
    overflow:hidden;
    box-shadow:0 4px 10px rgba(0,0,0,0.08);
}
h2{
    color:#1f3c88;
}

/* TABLE */
table{
    width:100%;
    border-collapse:collapse;
    background:white;
    border-radius:10px;
    overflow:hidden;
    box-shadow:0 4px 10px rgba(0,0,0,0.08);
}

th, td{
    padding:12px;
    border-bottom:1px solid #eee;
    font-size:14px;
    text-align:center;
}

th{
    background:#1f3c88;
    color:white;
}

.btn{
    padding:6px 10px;
    border:none;
    border-radius:5px;
    cursor:pointer;
    font-size:12px;
}

.delete{
    background:red;
    color:white;
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

</head>

<body>
<div style="margin-bottom:10px;">
    <button onclick="goBack()" class="back-btn">
        <span class="arrow">←</span> Back
    </button>
</div>

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>ManSparsh Admin</h2>
    <a href="AdminManageUser.jsp">User Management</a>
    <a href="AdminAppointment.jsp">Appointments</a>
    <a href="workshop.jsp">Workshops</a>
    <a href="AdminManageHostel.jsp">Hostel Management</a>
    <a href="AdminManageResources.jsp">Resources</a>
    <a href="AdminFeedback.jsp">Feedback</a>
    <a href="AdminLogout.jsp">Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main">

<h2>Feedback</h2>

<table>
    <tr>
        <th>ID</th>
        <th>User ID</th>
        <th>Role</th>
        <th>Name</th>
        <th>Email</th>
        <th>Message</th>
        <th>Rating</th>
        <th>Date</th>
        <th>Action</th>
    </tr>

<%
while(rs.next()){
%>

<tr>
    <td><%= rs.getInt("FEEDBACK_ID") %></td>
    <td><%= rs.getInt("USER_ID") %></td>
    <td><%= rs.getString("USER_ROLE") %></td>
    <td><%= rs.getString("USER_NAME") %></td>
    <td><%= rs.getString("USER_EMAIL") %></td>
    <td><%= rs.getString("MESSAGE") %></td>
    <td><%= rs.getInt("RATING") %></td>
    <td><%= rs.getTimestamp("SUBMITTED_AT") %></td>

    <td>
        <form method="post" style="display:inline;">
    <input type="hidden" name="action" value="hide">
    <input type="hidden" name="id" value="<%= rs.getInt("FEEDBACK_ID") %>">
    <button class="btn delete">Delete</button>
</form>
    </td>
</tr>

<%
}
%>

</table>

</div>
<script>
function goBack(){
    window.location.href = "AdminDashboard.jsp";
}
</script>

</body>
</html>

<%
} catch(Exception e){
    out.println("Error: " + e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(con != null) con.close();
}
%>