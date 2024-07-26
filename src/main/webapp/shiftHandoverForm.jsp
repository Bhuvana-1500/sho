<%@ page import="java.util.TimeZone" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ShiftHandover</title>
<!-- Include jQuery and jQuery UI CSS and JS -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- Include Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Include Quill JavaScript -->
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        font-weight: bold;
    }
    h1 {
        background-color: darkblue;
        color: white;
        padding: 10px;
        border-radius: 5px;
    }
    .input-box {
        width: 400px; /* Increased width for long comments */
        padding: 10px;
        border: 2px solid navy;
        border-radius: 5px;
    }
    .btn {
        background-color: darkblue;
        color: white;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s;
    }
    .btn:hover {
        background-color: navy;
    }
    .container {
        height: 700px;
        width: 700px;
        margin: auto;
        background-color: lightsteelblue;
        border-radius: 15px;
        padding: 50px;
    }
    table {
        margin: auto;
    }
    .message {
        font-size: 1.2em;
    }
    .success-message {
        color: green;
    }
    .error-message {
        color: red;
    }
    .ql-editor {
        min-height: 200px; /* Minimum height for Quill editor */
        background-color: white; /* White background for Quill editor */
    }
    #quill-container {
        border: 2px solid darkblue; /* Dark blue border for entire Quill container */
        border-radius: 5px;
        padding: 10px;
    }
    .ql-toolbar.ql-snow {
        border: none; /* Remove default border */
    }
    .ql-container.ql-snow {
        border: none; /* Remove default border */
    }
</style>
<script>
    $(document).ready(function() {
        var today = new Date().toISOString().slice(0, 10);
        document.getElementById('currentDate').value = today;

        var quill = new Quill('#editor-container', {
            theme: 'snow',
            modules: {
                toolbar: [
                    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
                    ['bold', 'italic', 'underline', 'strike'],
                    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                    ['link', 'image', 'video'],
                    ['clean']
                ]
            }
        });

        function submitForm() {
            var quillContent = document.querySelector('.ql-editor').innerHTML; // Corrected selector
            document.getElementById('editorContent').value = quillContent;
            document.querySelector('form').submit();
        }

        document.querySelector('.btn[value="Submit"]').addEventListener('click', submitForm);
    });
</script>
</head>
<body>
<div class="container">
<form method="post">
    <center><h1>Shift Handover</h1></center>
    <table>
        <tr>
            <td>Date:</td>
            <td><input type="date" id="currentDate" name="date" class="input-box" required></td>
        </tr>
        <tr>
            <td>Name:</td>
            <td><input type="text" name="name" value="<%= session.getAttribute("username") %>" class="input-box" readonly></td>
        </tr>
        <tr>
            <td>Department:</td>
            <td>
                <select name="DepType" class="input-box" required>
                    <option value="security">Cyber Security</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Shift Type:</td>
            <td>
                <select name="shiftType" class="input-box" required>
                    <option value="Morning">Morning Shift</option>
                    <option value="Evening">Evening Shift</option>
                    <option value="Night">Night Shift</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Comments:</td>
            <td>
                <textarea name="com" id="editorContent" style="display:none;"></textarea>
                <div id="quill-container">
                    <div id="editor-container" style="height: 300px;" class="input-box"></div>
                </div>
            </td>
        </tr>
    </table>
    <center>
        <button type="button" class="btn" onclick="window.location.href='index.jsp'">Back</button>
        <input type="button" class="btn" value="Submit">
    </center>
</form>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String date1 = request.getParameter("date");
        String name1 = request.getParameter("name");
        String dep1 = request.getParameter("DepType");
        String shiftType = request.getParameter("shiftType");
        String com1 = request.getParameter("com");

        // Set the time zone to IST
        TimeZone istTimeZone = TimeZone.getTimeZone("Asia/Kolkata");
        Calendar calendar = Calendar.getInstance(istTimeZone);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sdf.setTimeZone(istTimeZone);
        String timestamp = sdf.format(calendar.getTime());

        if (date1 != null && name1 != null && dep1 != null && shiftType != null && com1 != null && 
            !date1.isEmpty() && !name1.isEmpty() && !dep1.isEmpty() && !shiftType.isEmpty() && !com1.isEmpty()) { 
            String url = "jdbc:sqlserver://bhuvanasho.database.windows.net:1433;databaseName=shodb;user=bhuvana;password=Bhuvaneswari@15";
            String query = "INSERT INTO dbo.snp (date, name, department, shiftType, comments, submissionTime) VALUES (?, ?, ?, ?, ?, ?)";
            
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                Connection connect = DriverManager.getConnection(url);
                PreparedStatement ps = connect.prepareStatement(query);
                ps.setString(1, date1);
                ps.setString(2, name1);
                ps.setString(3, dep1);
                ps.setString(4, shiftType);
                ps.setString(5, com1);
                ps.setString(6, timestamp);

                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    out.println("<center><p class='message success-message'>Data submitted successfully.</p></center>");
                } else {
                    out.println("<p class='message error-message'>Error: Data could not be saved.</p>");
                }

                ps.close();
                connect.close();
            } catch (Exception e) {
                out.println("<p class='message error-message'>Error: " + e.getMessage() + "</p>");
                e.printStackTrace(new PrintWriter(out)); // Wrap JspWriter with PrintWriter
            }
        } else {
            out.println("<center><p class='message error-message'>Please Insert the Data...!!!</p></center>");
        }
    }
%>

</div>
</body>
</html>
