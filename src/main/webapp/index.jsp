<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ShiftHandover</title>
<style>
    @font-face {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    body {
        color: navy;
        font-size: 1.2em; /* Increased font size for all text */
        font-family: 'Apotos', sans-serif; /* Use Apotos font */
        font-weight: bold; /* Make text bold */
    }
    h1 {
        font-size: 2em;
        background-color: darkblue;
        color: white;
        padding: 10px;
        border-radius: 5px;
    }
    .btn {
        height: 130px;
        width: 160px; /* Increased width */
        padding: 10px 20px;
        margin: 10px;
        background-color: lightsteelblue; /* Match the div background color */
        border: 2px solid darkgrey; /* Increased border width */
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s;
        color: navy;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Use Apotos font */
        font-size: 1.0em; /* Decreased font size for button text */
        font-weight: bold; /* Make button text bold */
    }
    .btn:hover {
        background-color: #ccc;
        color: white;
    }
    .top-right-container {
        position: absolute;
        top: 10px;
        right: 230px;
        text-align: right;
    }
    .top-right-container .btn {
        height: auto;
        width: auto;
        padding: 5px 10px;
        margin: 0;
        border: none;
        background-color: transparent;
        color: navy;
        font-size: 16px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Use Apotos font */
    }
    .top-right-container .btn:hover {
        background-color: transparent;
        color: navy;
        text-decoration: underline;
    }
    .center-content {
        text-align: center;
        margin-top: 150px;
    }
    .button-container {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 20px;
    }
    .sign-out-btn {
        background-color: darkblue;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Use Apotos font */
    }
    .sign-out-btn:hover {
        background-color: #0056b3;
    }
    .welcome-text {
        font-size: 1.5em; /* Increased font size for the welcome message */
    }
</style>
</head>
<body>
<div style="height:700px; width:700px; margin:auto; background-color:lightsteelblue; border-radius:15px; padding:50px;">
<div class="top-right-container">
    <%
        String user = request.getRemoteUser();
        if (user != null) {
            session.setAttribute("username", user);
            out.println("<span>" + user + "</span><br><br>"); 
            out.println("<div><button class='sign-out-btn' onclick=\"window.location.href='logout.jsp'\">Sign Out</button></div>");
        }
    %>
</div>
<center>
<div class="center-content">
    <h1>Welcome to Service Portal</h1>
    <%
           
            out.println("<span>Welcome, " + user + "!</span><br><br>");
            out.println("<span class='welcome-text'>Welcome, " + user + "!</span><br><br>");
            out.println("<div class='button-container'>");
            out.println("<button class='btn' onclick=\"window.location.href='shiftHandoverForm.jsp'\">Shift Handover Form</button>");
            out.println("<button class='btn' onclick=\"window.location.href='searchDetailsForm.jsp'\">Search Details</button>");
            out.println("</div>");
        
    %>
</div>
</center>
</div>
</body>
</html>