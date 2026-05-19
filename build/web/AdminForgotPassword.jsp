<%@ page contentType="text/html; charset=UTF-8" %>
<%
    /*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

String msg = request.getParameter("msg");
String emailVal = request.getParameter("email");
if(emailVal == null) emailVal = "";
boolean isInvalid = "Invalid email".equals(msg);
%>
<!DOCTYPE html>
<html>
<head>
<title>Forgot Password</title>

<style>
body{
    margin:0;
    font-family:Arial;
    background:#f3f4f6;
}
.box{
    max-width:400px;
    margin:120px auto;
    background:white;
    padding:30px;
    border-radius:12px;
    box-shadow:0 0 25px rgba(0,0,0,0.15);
}
h2{text-align:center;}
input{
    width:100%;
    padding:12px;
    margin:10px 0;
    border:1px solid #ddd;
    border-radius:5px;
}
button{
    width:100%;
    padding:14px;
    border:none;
    background:#6f63ff;
    color:white;
    border-radius:8px;
    font-size:16px;
    cursor:pointer;
}
button:hover{background:#5a52d5;}
.msg{
    text-align:center;
    margin-top:10px;
    color:red;
    font-weight:bold;
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
    <h2>Forgot Password</h2>

    <form method="post" action="AdminForgotPasswordProcess.jsp">

    <label>Email:</label>
    <input type="email" name="email"
    value="<%= emailVal %>"
    required>

    <button type="submit">Send OTP</button>
</form>

    <% if(msg != null){ %>
        <div class="msg"><%= msg %></div>
    <% } %>
</div>
<script>
function goBack(){
            window.location.href = "AdminLogin.jsp";
        }
        </script>
</body>
</html>
