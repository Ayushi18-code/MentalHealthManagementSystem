<%@ page contentType="text/html; charset=UTF-8" %>
<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

String email = request.getParameter("email");
if(email == null || email.trim().equals("")){
    response.sendRedirect("AdminForgotPassword.jsp");
    return;
}
String msg = request.getParameter("msg");
%>

<!DOCTYPE html>
<html>
<head>
<title>Reset Password</title>
<style>
body{background:#f3f4f6;font-family:Arial;}
.box{
    max-width:400px;
    margin:120px auto;
    background:white;
    padding:30px;
    border-radius:12px;
    box-shadow:0 0 20px rgba(0,0,0,0.2);
}
input{width:100%;padding:12px;margin:10px 0;}
button{width:100%;padding:14px;background:#6f63ff;color:white;border:none;border-radius:8px;}
.msg{color:red;text-align:center;font-weight:bold;}
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
    width: auto; 
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
<div class="box">
<h2>Reset Password</h2>

<form method="post" action="AdminResetPasswordProcess.jsp">
    <input type="hidden" name="email" value="<%= email %>">

    <label>OTP</label>
    <input type="text" name="otp" required>

    <label>New Password</label>
    <input type="password" name="password" required>

    <label>Confirm Password</label>
    <input type="password" name="confirm" required>

    <button type="submit">Update Password</button>
</form>

<% if(msg!=null){ %>
<div class="msg"><%= msg %></div>
<% } %>

</div>
<script>
function goBack(){
            window.location.href = "AdminForgotPassword.jsp";
        }
</script>
</body>
</html>
