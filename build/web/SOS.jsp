<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 
%>
<!DOCTYPE html>
<html>
<head>
<title>Emergency Support | ManSparsh</title>

<style>
body{
    margin:0;
    font-family:"Segoe UI", Arial, sans-serif;
    background:linear-gradient(135deg,#6f63ff,#a78bfa);
    min-height:100vh;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#1e293b;
}

/* Glass Card */
.glass-card{
    width:90%;
    max-width:600px;
    padding:40px;
    border-radius:20px;
    background:rgba(255,255,255,0.15);
    backdrop-filter:blur(18px);
    -webkit-backdrop-filter:blur(18px);
    border:1px solid rgba(255,255,255,0.25);
    box-shadow:0 20px 50px rgba(0,0,0,0.2);
    text-align:center;
    animation:fadeIn 0.6s ease;
}

@keyframes fadeIn{
    from{opacity:0; transform:translateY(20px);}
    to{opacity:1; transform:translateY(0);}
}

/* Heading */
.title{
    font-size:28px;
    font-weight:700;
    color:white;
    margin-bottom:10px;
}

.subtitle{
    color:#e0e7ff;
    font-size:15px;
    margin-bottom:30px;
    line-height:1.6;
}

/* Contact Card */
.contact{
    background:rgba(255,255,255,0.2);
    border-radius:16px;
    padding:25px;
    margin-bottom:25px;
    backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.2);
    transition:all 0.3s ease;
}

.contact:hover{
    transform:translateY(-4px);
    box-shadow:0 15px 35px rgba(0,0,0,0.2);
}

.name{
    font-size:20px;
    font-weight:600;
    color:white;
}

.role{
    font-size:13px;
    color:#e0e7ff;
    margin-bottom:15px;
}

/* Call Button */
.call-btn{
    display:inline-block;
    background:white;
    color:#6f63ff;
    padding:12px 28px;
    border-radius:30px;
    text-decoration:none;
    font-weight:600;
    transition:all 0.3s ease;
}

.call-btn:hover{
    background:#ede9fe;
    transform:scale(1.05);
}

/* Back button */
.back-btn{
    position:absolute;
    top:20px;
    left:20px;
    background:rgba(255,255,255,0.2);
    color:white;
    border:none;
    padding:8px 14px;
    border-radius:8px;
    cursor:pointer;
    backdrop-filter:blur(10px);
    border:1px solid rgba(255,255,255,0.3);
    transition:0.3s;
}

.back-btn:hover{
    background:rgba(255,255,255,0.35);
}

/* Footer note */
.note{
    font-size:13px;
    color:#e0e7ff;
    margin-top:10px;
}
</style>
</head>

<body>
<div style="margin-bottom:10px;">
    <button onclick="goBack()" class="back-btn">
        <span class="arrow"></span> Back
    </button>
</div>

<div class="glass-card">

    <div class="title">Emergency Support</div>

    <div class="subtitle">
        If you are feeling unsafe, anxious, or overwhelmed, please call one campus support contacts below immediately.
    </div>

    <div class="contact">
        <div class="name">Dr. Anu Raj Singh</div>
        <div class="role">Faculty Psychologist</div>

        <a href="tel:9887374811" class="call-btn">
             Call Now
        </a>

        <div class="note">Available for urgent student support</div>
    </div>

</div>

<script>
function goBack(){
    window.location.href = "StudentDashboard.jsp";
}
</script>

</body>
</html>
