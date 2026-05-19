<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 
%>
<!DOCTYPE html>
<html>
<head>
<title>Verify OTP - ManSparsh</title>
<style>
body{
    font-family: Arial;
    background:#eef1ff;
}
.box{
    width:350px;
    margin:120px auto;
    background:white;
    padding:30px;
    border-radius:10px;
    box-shadow:0 0 15px rgba(0,0,0,0.1);
}
input,button{
    width:100%;
    padding:12px;
    margin-top:15px;
}
button :not(.back-btn){
    background:#6f63ff;
    color:white;
    border:none;
    font-size:16px;
    cursor:pointer;
}
.resend{
    margin-top:10px;
    text-align:center;
}
.error {
    color:red;
    text-align:center;
    margin-top:10px;
}
.success {
    color:green;
    text-align:center;
    margin-top:10px;
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
<h2>Verify OTP</h2>

<p>OTP has been sent to your email</p>

<!-- Show friendly error message -->
<%
    String error = request.getParameter("error");
    if("invalid".equals(error)) {
%>
    <div class="error">Invalid or expired OTP. Please try again.</div>
<%
    } else if ("resent".equals(error)) {
%>
    <div class="success">OTP has been resent to your email.</div>
<% } %>

<form action="VerifyOtpProcess.jsp" method="post">
    <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
    <input type="text" name="otp" placeholder="Enter OTP" required>
    <button type="submit">Verify</button>
</form>

<div class="resend">
    <a href="ResendOtp.jsp?email=<%= request.getParameter("email") %>">Resend OTP</a>
</div>

</div>
<script>
function goBack(){
            window.location.href = "StudentSignup.jsp";
        }
        </script>
</body>
</html>
