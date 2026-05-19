<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Sign Up – ManSparsh</title>
    <style>
        body {
            margin: 0;
            font-family: Arial;
            background: #f3f4f6;
        }

        /* SIGNUP FORM */
        .signup-container {
            max-width: 400px;
            margin: 100px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        input { 
            width: 100%; 
            padding: 12px; 
            margin: 10px 0; 
            box-sizing: border-box; 
            border: 1px solid #ddd; 
            border-radius: 4px;
        }

        button:not(.back-btn) { 
            background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%); 
            color: white; 
            padding: 14px; 
            width: 100%; 
            border: none; 
            cursor: pointer; 
            margin: 15px 0; 
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(79, 70, 229, 0.3);
        }

        button:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 8px 25px rgba(79, 70, 229, 0.4);
            background: linear-gradient(135deg, #4338CA 0%, #6D28D9 100%);
        }

        p {
            text-align: center;
            margin-top: 10px;
        }

        a { 
            color: #4F46E5; 
            text-decoration: none; 
        }

        a:hover { 
            text-decoration: underline; 
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

<!-- SIGNUP FORM -->
<div class="signup-container">
    <h2>Create Admin Account</h2>
        <form method="post" action="AdminSignupProcess.jsp" onsubmit="return false;">

        <label>Email:</label>
        <input type="email" id="email" name="adminEmail" required
       value="<%= request.getAttribute("enteredEmail") != null ? request.getAttribute("enteredEmail") : "" %>">

        <label>Name:</label>
        <input type="text" name="name" required
       value="<%= request.getAttribute("enteredName") != null ? request.getAttribute("enteredName") : "" %>">

        <label>Password:</label>
        <input type="password" id="password" name="password" required>

        <label>Confirm Password:</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required>

        <p id="passError" style="color:red; font-size:14px; display:none;">
        Passwords do not match
        </p>
        <p id="strengthError" style="color:red; font-size:14px; display:none;">
            Password must contain uppercase, lowercase, number & special character
        </p>
      
        <button type="button" onclick="submitForm()">Create Account</button>
        <%
        String err = (String)request.getAttribute("signupError");
        if(err!=null){
        %>
        <p style="color:red;font-weight:bold;"><%=err%></p>
        <%
        }
        %>

    </form>
    
</div>
<script>
function submitForm(){

    var pass = document.getElementById("password").value;
    var confirm = document.getElementById("confirmPassword").value;
    var strongPass = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$/;

    document.getElementById("passError").style.display="none";
    document.getElementById("strengthError").style.display="none";

    var serverError = "<%= request.getAttribute("signupError") %>";

    // First submit: no server message yet → go to server (email check)
    if(serverError === "" || serverError === "null"){
        document.forms[0].submit();
        return;
    }

    // Now email is OK → do password validation
    if(!strongPass.test(pass)){
        document.getElementById("strengthError").style.display="block";
        return;
    }

    if(pass !== confirm){
        document.getElementById("passError").style.display="block";
        return;
    }

    document.forms[0].submit();
}
function goBack(){
    window.location.href = "AdminLogin.jsp";
}
</script>
</body>
</html>