<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.regex.*" %>
<%@ page import="java.security.MessageDigest" %>
<%!
public String hashPassword(String password) {
    try {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(password.getBytes("UTF-8"));

        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    } catch (Exception e) {
        return null;
    }
}
%>
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
Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

String type = request.getParameter("type");
if(type==null) type="student";

String action = request.getParameter("action");

boolean actionSuccess = false;
String errorMsg = "";

try{
Class.forName("org.apache.derby.jdbc.ClientDriver");

con = DriverManager.getConnection(
"jdbc:derby://localhost:1527/ManSparsh","bns","bns");
PreparedStatement hostelPs = con.prepareStatement(
    "SELECT hostel_name FROM hostel"
);
ResultSet hostelRs = hostelPs.executeQuery();

/* ================= ADD ================= */
if("add".equals(action)){
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    // STEP 1: CHECK IF EMAIL ALREADY EXISTS
PreparedStatement checkPs = con.prepareStatement(
    "SELECT * FROM " + type + " WHERE email=?"
);

checkPs.setString(1, email);
ResultSet checkRs = checkPs.executeQuery();
if(!type.equals("student")){
    if(!email.endsWith("@banasthali.in")){
        errorMsg = "Email must end with @banasthali.in";
    }
}
if(checkRs.next()){
    errorMsg = "⚠ This email is already in use. Try another.";
}
    String password = request.getParameter("password");
    String hashedPassword = hashPassword(password);
    String phone = request.getParameter("phone");
    String smartId = request.getParameter("smart_card_id");

    if(!name.matches("^(?!.*([A-Za-z])\\1\\1)[A-Za-z ]+$")){
    errorMsg = "Invalid Name";
}
// COMMON VALIDATIONS FOR ALL USERS

if(!name.matches("^(?!.*([A-Za-z])\\1\\1)[A-Za-z ]+$")){
    errorMsg = "Invalid Name";
}

String passPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$";

if(!password.matches(passPattern)){
    errorMsg = "Weak Password";
}
    if(type.equals("student")){
        if(!phone.matches("\\d{10}")){ out.println("Invalid Phone"); return; }

        String emailPrefix = email.split("@")[0].split("_")[0];

        ps=con.prepareStatement(
        "INSERT INTO student(name,email,password,phone,hostel,smart_card_id,created_by,created_date) VALUES(?,?,?,?,?,?,?,CURRENT_TIMESTAMP)");

        ps.setString(1,name);
        ps.setString(2,email);
        ps.setString(3, hashedPassword);
        ps.setString(4,phone);
        ps.setString(5,request.getParameter("hostel"));
        ps.setString(6,smartId);
        ps.setString(7,"ADMIN");

    } else{
        ps=con.prepareStatement(
        "INSERT INTO "+type+"(name,email,password,specialization,status,created_by,created_date) VALUES(?,?,?,?,?,?,CURRENT_TIMESTAMP)");

        ps.setString(1,name);
        ps.setString(2,email);
        ps.setString(3, hashedPassword);
        ps.setString(4,request.getParameter("specialization"));
        ps.setString(5,request.getParameter("status"));
        ps.setString(6,"ADMIN");
    }

    if(errorMsg.equals("")){
    ps.executeUpdate();
    actionSuccess = true;
}
}

/* ================= UPDATE ================= */
if("update".equals(action)){
    int id=Integer.parseInt(request.getParameter("id"));

   String password = request.getParameter("password");

if(type.equals("student")){

    if(password != null && !password.trim().equals("")){

        String hashedPassword = hashPassword(password);

        ps=con.prepareStatement(
        "UPDATE student SET name=?,email=?,password=?,phone=?,hostel=?,smart_card_id=? WHERE student_id=?");

        ps.setString(1,request.getParameter("name"));
        ps.setString(2,request.getParameter("email"));
        ps.setString(3,hashedPassword);
        ps.setString(4,request.getParameter("phone"));
        ps.setString(5,request.getParameter("hostel"));
        ps.setString(6,request.getParameter("smart_card_id"));
        ps.setInt(7,id);

    }else{

        ps=con.prepareStatement(
        "UPDATE student SET name=?,email=?,phone=?,hostel=?,smart_card_id=? WHERE student_id=?");

        ps.setString(1,request.getParameter("name"));
        ps.setString(2,request.getParameter("email"));
        ps.setString(3,request.getParameter("phone"));
        ps.setString(4,request.getParameter("hostel"));
        ps.setString(5,request.getParameter("smart_card_id"));
        ps.setInt(6,id);
    }
    } else{

    if(password != null && !password.trim().equals("")){

        String hashedPassword = hashPassword(password);

        ps=con.prepareStatement(
        "UPDATE "+type+" SET name=?,email=?,password=?,specialization=?,status=? WHERE "+type+"_id=?");

        ps.setString(1,request.getParameter("name"));
        ps.setString(2,request.getParameter("email"));
        ps.setString(3,hashedPassword);
        ps.setString(4,request.getParameter("specialization"));
        ps.setString(5,request.getParameter("status"));
        ps.setInt(6,id);

    }else{

        ps=con.prepareStatement(
        "UPDATE "+type+" SET name=?,email=?,specialization=?,status=? WHERE "+type+"_id=?");

        ps.setString(1,request.getParameter("name"));
        ps.setString(2,request.getParameter("email"));
        ps.setString(3,request.getParameter("specialization"));
        ps.setString(4,request.getParameter("status"));
        ps.setInt(5,id);
    }
} 

    ps.executeUpdate();
    actionSuccess = true;
}

/* ================= DELETE ================= */
if("delete".equals(action)){
    int id=Integer.parseInt(request.getParameter("id"));

    ps=con.prepareStatement("DELETE FROM "+type+" WHERE "+type+"_id=?");
    ps.setInt(1,id);
    ps.executeUpdate();

    actionSuccess = true;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>User Management</title>

<style>
body{margin:0;font-family:Segoe UI;background:#f4f7fb;}
.layout{display:flex;height:100vh;}
.sidebar{width:220px;background:#1e2a48;color:white;padding:20px;}
.sidebar a{display:block;padding:10px;color:white;text-decoration:none;}
.active{background:#3d5af1;}
.main{flex:1;padding:20px;}
.header{background:#2f4ea2;color:white;padding:12px;border-radius:10px;display:flex;justify-content:space-between;}
.add-btn{background:#28a745;color:white;padding:8px 14px;border:none;border-radius:6px;}

table{width:100%;background:white;margin-top:10px;border-collapse:collapse;}
th,td{padding:10px;text-align:center;border-bottom:1px solid #eee;}
th{background:#eef2ff;}

button{padding:6px 10px;border:none;border-radius:5px;cursor:pointer;}
.update-btn{background:#3d5af1;color:white;}
.delete{background:#e74c3c;color:white;}

.modal{
display:none;position:fixed;top:0;left:0;width:100%;height:100%;
background:rgba(0,0,0,0.6);justify-content:center;align-items:center;
}
.modal-content{
background:white;padding:25px;border-radius:12px;width:380px;
}
.modal input,select{width:100%;padding:10px;margin:8px 0;}
.save-btn{background:#28a745;color:white;}
.cancel-btn{background:#ccc;}
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

<div class="layout">

<div class="sidebar">

<h3 style="text-align:center; color:#9ecbff; margin-bottom:15px;">
    User Type
</h3>

<a href="?type=student" class="<%=type.equals("student")?"active":""%>">Students</a>
<a href="?type=counselor" class="<%=type.equals("counselor")?"active":""%>">Counselors</a>
<a href="?type=faculty" class="<%=type.equals("faculty")?"active":""%>">Faculty</a>

</div>
<div class="main">

<div class="header">
<span><%=type.toUpperCase()%> MANAGEMENT</span>
<button class="add-btn" onclick="openAdd()">+ Add User</button>
</div>

<table>

<tr>
<th>ID</th><th>Name</th><th>Email</th>
<%= type.equals("student") ? "<th>Phone</th><th>Hostel</th><th>Smart Card Id</th>" : "<th>Specialization</th><th>Status</th>" %>
<th>Action</th>
</tr>

<%
ps=con.prepareStatement("SELECT * FROM "+type);
rs=ps.executeQuery();

while(rs.next()){
%>

<tr>
<td><%=rs.getInt(type+"_id")%></td>
<td><%=rs.getString("name")%></td>
<td><%=rs.getString("email")%></td>

<% if(type.equals("student")){ %>
<td><%=rs.getString("phone")%></td>
<td><%=rs.getString("hostel")%></td>
<td><%=rs.getString("smart_card_id")%></td>
<% } else { %>
<td><%=rs.getString("specialization")%></td>
<td><%=rs.getString("status")%></td>
<% } %>

<td>
<button class="update-btn"
onclick="openUpdate(
'<%=rs.getInt(type+"_id")%>',
'<%=rs.getString("name")%>',
'<%=rs.getString("email")%>',
'<%= type.equals("student") ? rs.getString("phone") : "" %>',
'<%= type.equals("student") ? rs.getString("hostel") : "" %>',
'<%= type.equals("student") ? rs.getString("smart_card_id") : "" %>',
'<%= !type.equals("student") ? rs.getString("specialization") : "" %>',
'<%= !type.equals("student") ? rs.getString("status") : "" %>'
)">Update</button>
<button class="delete"
onclick="openDelete('<%=rs.getInt(type+"_id")%>')">Delete</button>
</td>

</tr>
<% } %>

</table>
</div>
</div>

<!-- MODAL -->
<div class="modal" id="formModal">
<div class="modal-content">

<h3 id="modalTitle">Add User</h3>

<form method="post" id="userForm" onsubmit="return validateForm(event)">
<input type="hidden" name="action" id="formAction">
<input type="hidden" name="id" id="userId">
<input type="hidden" name="type" value="<%=type%>">

<input name="name" id="name" placeholder="Name" required>
<input name="email" id="email" placeholder="Email" required>
<input name="password" id="password" placeholder="Password">
<input name="confirm_password" id="confirm_password" placeholder="Confirm Password">

<% if(type.equals("student")){ %>
<input name="phone" placeholder="Phone" required>
<select name="hostel" required>
    <option value="">-- Select Hostel --</option>

    <%
        while(hostelRs.next()){
            String hostelName = hostelRs.getString("hostel_name");
    %>
        <option value="<%=hostelName%>">
            <%=hostelName%>
        </option>
    <%
        }
    %>

</select>
<input name="smart_card_id" placeholder="Smart Card ID" required>
<% } else { %>
<input name="specialization" placeholder="Specialization">

<select name="status" required>
<option value="">--Select Status--</option>
<option>ACTIVE</option>
<option>INACTIVE</option>
<option>SUSPEND</option>
</select>
<% } %>

<div id="errorBox" style="color:red; font-size:14px; margin-bottom:10px;">
    <%= errorMsg %>
</div>

<button type="submit" class="save-btn">Submit</button>
<button type="button" onclick="closeModal()">Cancel</button>

</form>
</div>
</div>

<!-- DELETE MODAL -->
<div class="modal" id="deleteModal">
<div class="modal-content">
<form method="post">
<input type="hidden" name="action" value="delete">
<input type="hidden" name="id" id="deleteId">
<input type="hidden" name="type" value="<%=type%>">

<p>Are you sure you want to delete?</p>
<button class="delete">Yes</button>
<button type="button" onclick="closeDelete()">No</button>
</form>
</div>
</div>

<script>
function openAdd(){
    document.getElementById("formModal").style.display="flex";
    document.getElementById("modalTitle").innerText="Add User";
    document.getElementById("formAction").value="add";

    document.getElementById("userId").value="";
    document.getElementById("name").value="";
    document.getElementById("email").value="";
    document.getElementById("password").value="";
}
function openUpdate(id,name,email,phone,hostel,card,specialization,status){

    document.getElementById("formModal").style.display="flex";
    document.getElementById("modalTitle").innerText="Update User";
    document.getElementById("formAction").value="update";

    document.getElementById("userId").value=id;
    document.getElementById("name").value=name;
    document.getElementById("email").value=email;

    // STUDENT
    if(document.querySelector('[name="phone"]')){
        document.querySelector('[name="phone"]').value = phone;
    }

    if(document.querySelector('[name="hostel"]')){
        document.querySelector('[name="hostel"]').value = hostel;
    }

    if(document.querySelector('[name="smart_card_id"]')){
        document.querySelector('[name="smart_card_id"]').value = card;
    }

    // COUNSELOR / FACULTY
    if(document.querySelector('[name="specialization"]')){
        document.querySelector('[name="specialization"]').value = specialization;
    }

    if(document.querySelector('[name="status"]')){
        document.querySelector('[name="status"]').value = status;
    }
}
function closeModal(){document.getElementById("formModal").style.display="none";}
function openDelete(id){
    document.getElementById("deleteModal").style.display="flex";
    document.getElementById("deleteId").value=id;
}
function closeDelete(){document.getElementById("deleteModal").style.display="none";}
</script>

<!-- AUTO REFRESH FIX -->

<script>
function validateForm(event){
    if(event) event.preventDefault();
    const errorBox = document.getElementById("errorBox");

    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value.trim();
    const confirmPassword = document.getElementById("confirm_password").value.trim();
    errorBox.innerHTML = "";

    // STEP 1: check empty fields first
    if(!name || !email){
    errorBox.innerHTML = "Please fill required fields";
    return false;
}
   
    let cleanName = name.toLowerCase();

    let count = 1;
    let invalid = false;

    for(let i = 1; i < cleanName.length; i++){
        if(cleanName[i] === cleanName[i - 1]){
            count++;
            if(count >= 3){
                invalid = true;
                break;
            }
        } else {
            count = 1;
        }
    }

    if(invalid){
        errorBox.innerHTML = "Invalid Name";
        return false;
    }

    const userType = document.querySelector('[name="type"]').value;

// STUDENT → strict email
if(userType === "student"){
    let emailPattern = /^[a-zA-Z0-9]+_[a-zA-Z]+@banasthali\.in$/;

    if(!emailPattern.test(email)){
        errorBox.innerHTML = "Invalid Student Email";
        return false;
    }
}

// COUNSELOR / FACULTY → only domain check
else{
    if(!email.endsWith("@banasthali.in")){
        errorBox.innerHTML = "Email must end with @banasthali.in";
        return false;
    }
}
    let passPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;

if(password && !passPattern.test(password)){
    errorBox.innerHTML =
    "Password must be of 8 characters - uppercase, lowercase, numbers and special characters";
    return false;
}
// CONFIRM PASSWORD CHECK (NEW)
    if(password && password !== confirmPassword){
    errorBox.innerHTML = "Passwords do not match";
    return false;
}

// ONLY RUN FOR STUDENT
const phoneField = document.querySelector('[name="phone"]');
const smartIdField = document.querySelector('[name="smart_card_id"]');

if(phoneField && smartIdField){

    const phone = phoneField.value.trim();
    const smartId = smartIdField.value.trim();

    // PHONE CHECK
    if(!/^\d{10}$/.test(phone)){
        errorBox.innerHTML = "Invalid Phone Number";
        return false;
    }

    // SMART CARD CHECK
    let emailPrefix = email.split("@")[0].split("_")[0];

    if(smartId.toLowerCase() !== emailPrefix.toLowerCase()){
        errorBox.innerHTML = "Invalid Smart Card ID";
        return false;
    }
}
    document.getElementById("userForm").submit();
    return true;
}
</script>
<script>
<% if(!errorMsg.equals("")){ %>
    document.getElementById("formModal").style.display="flex";
<% } %>
function goBack(){
    window.location.href = "AdminDashboard.jsp";
}
</script>
</body>
</html>

<%
}catch(Exception e){
e.printStackTrace();
out.println("Error: "+e.getMessage());
}
%>