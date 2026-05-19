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

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
String search = null;

search = request.getParameter("searchText");

if(search != null){
    search = search.trim();
}
try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/ManSparsh","bns","bns");
    con.setAutoCommit(true);
   
    //Add hostel
    if(request.getParameter("addHostel") != null){

    String name = request.getParameter("hostelName");

    if(name != null && !name.trim().equals("")){
        name = name.trim();

        // CHECK DUPLICATE
        PreparedStatement checkPs = con.prepareStatement(
            "SELECT 1 FROM HOSTEL WHERE LOWER(HOSTEL_NAME)=LOWER(?)");
        checkPs.setString(1, name);
        ResultSet checkRs = checkPs.executeQuery();

        if(!checkRs.next()){

            ps = con.prepareStatement(
                "INSERT INTO HOSTEL (HOSTEL_NAME) VALUES (?)");
            ps.setString(1, name);

            int rows = ps.executeUpdate();

            if(rows > 0){
                response.sendRedirect("AdminManageHostel.jsp?msg=added");
            }else{
                response.sendRedirect("AdminManageHostel.jsp?msg=error");
            }

        } else {
            // duplicate found
            response.sendRedirect("AdminManageHostel.jsp?msg=exists");
        }

        checkRs.close();
        checkPs.close();
        return;
    }
}

    // ================= DELETE HOSTEL =================
    if(request.getParameter("deleteId") != null){

        int id = Integer.parseInt(request.getParameter("deleteId"));

        ps = con.prepareStatement(
            "DELETE FROM HOSTEL WHERE ID=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();
        if(rows > 0){
            response.sendRedirect("AdminManageHostel.jsp?msg=deleted");
        }else{
            response.sendRedirect("AdminManageHostel.jsp?msg=error");
        }
        return;
    }

}catch(Exception e){
    e.printStackTrace();
out.println("Error: " + e);
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Hostel Management</title>

<style>
body{
    margin:0;
    font-family:Segoe UI;
    background:#f4f7fb;
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
.main{
    margin-left:240px;
    padding:30px;
}
.box{
    background:white;
    padding:20px;
    border-radius:10px;
    box-shadow:0 6px 18px rgba(0,0,0,0.1);
}
input{
    padding:8px;
    margin:5px;
}
button{
    padding:8px 12px;
    border:none;
    border-radius:5px;
    cursor:pointer;
}
.add{ background:#1f3c88; color:white; }
.delete{ background:red; color:white; }
table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
}
th,td{
    padding:10px;
    border-bottom:1px solid #ddd;
}
th{
    background:#eef2ff;
}
.msg{ color:red; }
.success{ color:green; }
/* POPUP BOX */
.popup{
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.2);
    padding: 15px 25px;
    display: none;
    z-index: 1000;
}
/* SUCCESS POPUP (GREEN) */
.successPopup{
    background: #e6ffed;
    border-left: 5px solid green;
}

/* ERROR POPUP (RED) */
.errorPopup{
    background: #ffe6e6;
    border-left: 5px solid red;
}
.successPopup p{
    color: green;
}

.errorPopup p{
    color: red;
}
.popup-content{
    text-align: center;
    font-size: 16px;
    color: #333;
}

.tick{
    font-size: 28px;
    color: green;
    margin-bottom: 5px;
}

/* Animation */
@keyframes fadeIn{
    from{ opacity:0; transform: translateY(-10px);}
    to{ opacity:1; transform: translateY(0);}
}
/* MODAL BACKGROUND */
.modal{
    display:none;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    justify-content:center;
    align-items:center;
    z-index:2000;
}

/* MODAL BOX */
.modal-content{
    background:white;
    padding:25px;
    border-radius:10px;
    text-align:center;
    width:300px;
    box-shadow:0 6px 20px rgba(0,0,0,0.3);
}

.modal-buttons{
    margin-top:15px;
}

.yesBtn{
    background:#1f3c88;
    color:white;
    padding:8px 15px;
    margin:5px;
    border:none;
    border-radius:5px;
}

.noBtn{
    background:gray;
    color:white;
    padding:8px 15px;
    margin:5px;
    border:none;
    border-radius:5px;
}
.searchBtn{
    background:#1f3c88;
    color:white;
    padding:8px 12px;
    border:none;
    border-radius:5px;
    cursor:pointer;
}

.searchBtn:hover{
    background:#163172;
}
.highlight{
    background:yellow;
    font-weight:bold;
    padding:2px;
    border-radius:3px;
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
let currentForm = null;

function openModal(event, form, message){
    event.preventDefault();
    currentForm = form;
    document.getElementById("confirmText").innerText = message;
    document.getElementById("confirmModal").style.display = "flex";
    return false;
}

function closeModal(){
    document.getElementById("confirmModal").style.display = "none";
    currentForm = null;
}

function proceedAction(){
    if(currentForm){
        let input = document.createElement("input");
        input.type = "hidden";
        input.name = "addHostel";
        input.value = "true";
        currentForm.appendChild(input);

        currentForm.submit();
    }
}

window.onload = function(){
    var msg = "<%= (request.getParameter("msg") != null ? request.getParameter("msg") : "") %>";
    var popup = document.getElementById("popupBox");

    if(msg != "null" && msg != ""){
        popup.style.display = "block";

        setTimeout(function(){
            popup.style.display = "none";
            window.history.replaceState({}, document.title, "AdminManageHostel.jsp");
        }, 1000);
    }
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
    <h2>ManSparsh Admin</h2>
    <a href="AdminManageUser.jsp">User Management</a>
    <a href="AdminAppointment.jsp">Appointments</a>
    <a href="workshop.jsp">Workshops</a>
    <a href="AdminManageHostel.jsp">Hostel Management</a>
    <a href="AdminManageResources.jsp">Resources</a>
    <a href="AdminFeedback.jsp">Feedback</a>
    <a href="AdminLogout.jsp">Logout</a>
</div>

<div class="main">
<div class="box">

<h2>Hostel Management</h2>

<%
String msg = request.getParameter("msg");
%>

    <div id="popupBox" class="popup
<%= ("added".equals(msg) || "deleted".equals(msg)) ? "successPopup" : "" %>
<%= ("exists".equals(msg) || "error".equals(msg)) ? "errorPopup" : "" %>">
    <div class="popup-content">

        <% if("added".equals(msg) || "deleted".equals(msg)) { %>
            <div class="tick">✔</div>
        <% } %>

        <% if("added".equals(msg)) { %>
            <p>Hostel added successfully!</p>

        <% } else if("deleted".equals(msg)) { %>
            <p>Hostel deleted successfully!</p>

        <% } else if("exists".equals(msg)) { %>
            <p>Hostel already exists!</p>

        <% } else if("error".equals(msg)) { %>
            <p>Something went wrong!</p>
        <% } %>

    </div>
</div>

<!-- ADD + SEARCH -->
<form id="addForm" method="post">
    <input type="text" name="hostelName" placeholder="Enter hostel name" required>

    <button type="button" class="add"
    onclick="openModal(event, this.form, 'Do you really want to add this hostel?')">
    Add
    </button>
</form>
<form method="post">
    <input type="text" id="searchBox" name="searchText"
placeholder="Search hostel..."
value="<%= search != null ? search : "" %>"
onkeyup="liveSearch()">
    <button type="submit" name="searchBtn" class="searchBtn">Search</button>
</form>
<!-- TABLE -->
<table>
<tr>
<th>S.No</th>
<th>ID</th>
<th>Hostel Name</th>
<th>Action</th>
</tr>

<%
String query;

if(search != null && !search.trim().isEmpty()){
    query = "SELECT ID, HOSTEL_NAME FROM HOSTEL WHERE LOWER(HOSTEL_NAME) LIKE ? ORDER BY ID";
    ps = con.prepareStatement(query);
    ps.setString(1, "%" + search.toLowerCase() + "%");
} else {
    query = "SELECT ID, HOSTEL_NAME FROM HOSTEL ORDER BY ID";
    ps = con.prepareStatement(query);
}

rs = ps.executeQuery();

    int count = 1;
    boolean found = false;

    while(rs.next()){
        found = true;
        String hostelName = rs.getString("HOSTEL_NAME");
if(hostelName == null) hostelName = "";
boolean isHighlight = search != null &&
    !search.trim().isEmpty() &&
    hostelName.toLowerCase().contains(search.toLowerCase());
%>
<tr>
<td><%= count++ %></td>
<td><%= rs.getInt("ID") %></td>
<td>
<%
String displayName = hostelName;

if(search != null && !search.trim().isEmpty()){
    String lowerName = hostelName.toLowerCase();
    String lowerSearch = search.toLowerCase();

    int index = lowerName.indexOf(lowerSearch);

    if(index >= 0){
        String before = hostelName.substring(0, index);
        String match = hostelName.substring(index, index + search.length());
        String after = hostelName.substring(index + search.length());

        displayName = before
            + "<span class='highlight'>" + match + "</span>"
            + after;
    }
}
%>

<%= displayName %>
</td>
<td>
        <form method="post" style="display:inline;" onsubmit="return openModal(event, this, 'Are you sure you want to delete this hostel?')">
        <input type="hidden" name="deleteId" value="<%= rs.getInt("ID") %>">
        <button type="submit" class="delete">Remove</button>
    </form>
</td>
</tr>

<%
    }

   
%>
</table>

</div>
</div>
<!-- CUSTOM CONFIRM MODAL -->
<div id="confirmModal" class="modal">
    <div class="modal-content">
        <p id="confirmText"></p>
        <div class="modal-buttons">
            <button type="button" onclick="proceedAction()" class="yesBtn">Yes</button>
            <button type="button" onclick="closeModal()" class="noBtn">No</button>
        </div>
    </div>
</div>
<script>
function goBack(){
    window.location.href = "AdminDashboard.jsp";
}
</script>

</body>
</html>