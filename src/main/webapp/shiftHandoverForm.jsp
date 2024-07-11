<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ShiftHandover</title>
<!-- Include Quill CSS and JS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<style>
    /* Your CSS styles */
</style>
<script>
    window.onload = function() {
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('currentDate').value = today;
    }

    var quill;

    document.addEventListener('DOMContentLoaded', function() {
        quill = new Quill('#editor-container', {
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
    });

    // Save Quill content to textarea on form submit
    function submitForm() {
        var editorContent = document.querySelector('textarea[name=com]');
        editorContent.value = quill.root.innerHTML;

        // Get client's current time
        var clientTime = new Date().toLocaleTimeString('en-GB', { hour12: false });
        document.getElementById('clientTime').value = clientTime;

        document.querySelector('form').submit();
    }
</script>
</head>
<body>
<div class="container">
<center>
<form method="post" onsubmit="submitForm(); return false;">
    <h1>Shift Handover</h1>
    <table>
        <tr>
            <td>Date:</td>
            <td><input type="date" id="currentDate" name="date" class="input-box"></td>
        </tr>
        <tr>
            <td>Name:</td>
            <td><input type="text" name="name" value="<%= session.getAttribute("username") %>" class="input-box" readonly></td>
        </tr>
        <tr>
            <td>Department:</td>
            <td>
                <select class="input-box" name="DepType">
                    <option value="">--Select--</option>
                    <option value="Security">Security</option>
                    <option value="Networking">Networking</option>
                    <option value="CMS">CMS</option>
                    <option value="Data">Data</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Shift Type:</td>
            <td>
                <select name="shiftType" class="input-box">
                    <option value="Morning">Morning Shift</option>
                    <option value="Evening">Evening Shift</option>
                    <option value="Night">Night Shift</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Comments:</td>
            <td>
                <textarea name="com" style="display:none;"></textarea>
                <div id="quill-container">
                    <div id="editor-container" style="height: 300px;" class="input-box"></div>
                </div>
            </td>
        </tr>
    </table>
    <!-- Hidden input to store client's current time -->
    <input type="hidden" id="clientTime" name="clientTime">
    <center>
        <button type="button" class="btn" onclick="window.location.href='index.jsp'">Back</button>
        <input type="submit" class="btn" value="Submit">
    </center>
</form>

<%
    String date1 = request.getParameter("date");
    String name1 = request.getParameter("name");
    String dep1 = request.getParameter("DepType");
    String shiftType = request.getParameter("shiftType");
    String com1 = request.getParameter("com");
    String clientTime = request.getParameter("clientTime");

    if (date1 != null && name1 != null && dep1 != null && shiftType != null && com1 != null && 
        !date1.isEmpty() && !name1.isEmpty() && !dep1.isEmpty() && !shiftType.isEmpty() && !com1.isEmpty() && clientTime != null) { 
        String url = "jdbc:sqlserver://shodb.database.windows.net:1433;databaseName=shodb;user=bhuvana;password=Bhuvaneswari@15";
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
            ps.setString(6, clientTime); // Use 'clientTime' variable here for submissionTime
            int rs1 = ps.executeUpdate();
            if (rs1 > 0) {
                out.println("<center><p class='success-message'>Record Added..</p></center>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<center><p class='error-message'>An error occurred while processing your request.</p></center>");
        }
    } else {
        out.println("<center><p class='error-message'>Please Insert the Data...!!!</p></center>");
    }
%>
</center>
</div>
</body>
</html>
