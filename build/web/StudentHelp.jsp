<%@ page contentType="text/html;charset=UTF-8" %>
<%
/*------PREVENT CACHE------*/   
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0); 

// Check session
if (session.getAttribute("studentId") == null) {
    response.sendRedirect("StudentLogin.jsp");
    return;
}
%>
<html>
<head>
<title>Help & Support</title>

<style>
* {
    box-sizing: border-box;
    transition: all 0.15s ease-in-out;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
     background: linear-gradient(135deg, #ede9fe, #e0ecff, #f5f3ff);
    margin: 0;
}

.container {
    max-width: 900px;
    margin: 50px auto;
    padding: 0 20px;
}

.header {
    background: rgba(255, 255, 255, 0.85);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(99, 102, 241, 0.1);
    padding: 28px;
    border-radius: 18px;
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
    margin-bottom: 25px;
    text-align: center;
}

.header h2 {
    margin: 0 0 10px;
    color: #1e3a8a;
    font-size: 26px;
}

.grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.card {
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.06);
    transition: all 0.25s ease;
    border: 1px solid transparent;
}

.card::before {
    content: "";
    display: block;
    width: 4px;
    height: 30px;
    background: linear-gradient(to bottom, #6366f1, #2563eb);
    border-radius: 4px;
    margin-bottom: 10px;
}

.card:hover {
    transform: translateY(-6px) scale(1.01);
    box-shadow: 0 12px 28px rgba(37, 99, 235, 0.15);
    border: 1px solid rgba(99, 102, 241, 0.2);
}

.card h3 {
    margin: 0 0 8px;
    color: #1f2937;
}

.card p {
    font-size: 14px;
    color: #6b7280;
}

.faq {
    margin-top: 30px;
    background: white;
    padding: 22px;
    border-radius: 16px;
    box-shadow: 0 8px 22px rgba(0,0,0,0.06);
}

.faq h3 {
    margin-bottom: 12px;
    color: #1e3a8a;
}

.faq-item {
    padding: 12px 0;
    border-bottom: 1px solid #e5e7eb;
    font-size: 14px;
    cursor: pointer;
}

.faq-item:hover {
    background: rgba(99, 102, 241, 0.05);
    padding-left: 8px;
    border-radius: 8px;
}

.feedback {
    margin-top: 8px;
}

.feedback button {
    border: none;
    background: #eef2ff;
    padding: 5px 10px;
    margin-left: 6px;
    border-radius: 8px;
    cursor: pointer;
}

.feedback button:hover {
    background: #6366f1;
    color: white;
}

#suggestions {
    background: #ffffff;
    padding: 15px;
    border-radius: 12px;
    margin-top: 15px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.05);
    border: 1px solid #e5e7eb;
}

.contact {
    margin-top: 30px;
    text-decoration: none;
    background: linear-gradient(to right, #4f46e5, #2563eb);
    color: white;
    padding: 26px;
    border-radius: 16px;
    text-align: center;
    box-shadow: 0 10px 25px rgba(37, 99, 235, 0.3);
}

.contact a {
    color: white;
    font-weight: bold;
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
<div class="container">

<div class="header">
<h2>Help & Support</h2>
</div>

<div class="grid">

<div class="card" onclick="location.href='<%= request.getContextPath() %>/StudentEditProfile.jsp'">
<h3>Account Help</h3>
<p>Manage login, password, and profile settings.</p>
</div>

<div class="card" onclick="location.href='<%= request.getContextPath() %>/StudentAppointments.jsp'">
<h3>Appointments</h3>
<p>Booking, rescheduling, and cancellation support.</p>
</div>

<div class="card" onclick="location.href='<%= request.getContextPath() %>/PrivacyAndSecurity.jsp'">
<h3>Privacy & Security</h3>
<p>Understand how your data is protected.</p>
</div>
</div>

<div class="faq">
<h3>Frequently Asked Questions</h3>

<div class="faq-item">
<b>How do I reset my password?</b><br>
Go to Account → Edit Profile .
<div class="feedback">
<span>Was this helpful?</span>
<button onclick="handleFeedback(this)">&#128077;</button>
<button onclick="handleFeedback(this)">&#128078;</button>
</div>
</div>

<div class="faq-item">
<b>Can I download Resources</b><br>
We are working upon it.For now you can only view them on our Website.
<div class="feedback">
<span>Was this helpful?</span>
<button onclick="handleFeedback(this)">&#128077;</button>
<button onclick="handleFeedback(this)">&#128078;</button>
</div>
</div>

<div class="faq-item">
<b>How can I contact support?</b><br>
Use the contact section below.
<div class="feedback">
<span>Was this helpful?</span>
<button onclick="handleFeedback(this)">&#128077;</button>
<button onclick="handleFeedback(this)">&#128078;</button>
</div>
</div>
</div>
<div class="contact">
<h3>Need more help?</h3>
<p>Email us at <a href="mailto:mansparshhelp@gmail.com" class="email-link">mansparshhelp@gmail.com</a></p>
<p style="margin-top:10px;">
<a href="TermsAndConditions.jsp">Terms & Conditions</a> |
<a href="PrivacyPolicy.jsp">Privacy Policy</a>
</p>
</div>

</div>

<script>
// Accordion
document.querySelectorAll('.faq-item').forEach(item => {
    const parts = item.innerHTML.split("<br>");
    const question = parts[0];
    const rest = parts.slice(1).join("<br>");

    item.innerHTML = question;

    const answer = document.createElement("div");
    answer.innerHTML = rest;
    answer.style.display = "none";
    answer.style.marginTop = "8px";

    item.appendChild(answer);

    item.addEventListener("click", () => {
        answer.style.display = (answer.style.display === "none") ? "block" : "none";
        showSuggestions(question);
    });
});

// Feedback
function handleFeedback(btn) {
    btn.parentElement.innerHTML = "Thanks for your feedback!";
}

// Suggestions
//const faqList = [
//    "How do I reset my password?",
//    "Why am I not receiving notifications?",
//    "How can I contact support?"
//];

function showSuggestions(current) {
    const box = document.getElementById("suggestions");
//    box.innerHTML = "<b>Related Questions:</b>";

    faqList.forEach(q => {
        if (!current.includes(q)) {
            const p = document.createElement("p");
            p.textContent = q;
            box.appendChild(p);
        }
    });
}
function goBack(){
    window.location.href = "StudentDashboard.jsp";
}
</script>

</body>
</html>