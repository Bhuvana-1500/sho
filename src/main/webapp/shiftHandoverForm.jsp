<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ShiftHandover</title>
<!-- Include Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<!-- Include Quill JavaScript -->
<script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
<style>
    /* Your existing CSS styles */
</style>
<script>
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

        // Custom handler for "@" symbol
        quill.on('text-change', function(delta, oldDelta, source) {
            if (source === 'user') {
                var text = quill.getText();
                var lastIndex = text.lastIndexOf('@');
                if (lastIndex !== -1) {
                    var substr = text.substring(lastIndex + 1);
                    if (substr.length > 0) {
                        // Call function to fetch and display user suggestions
                        fetchUserSuggestions(substr);
                    } else {
                        // Hide suggestions if no text after "@"
                        hideUserSuggestions();
                    }
                } else {
                    // Hide suggestions if "@" not found
                    hideUserSuggestions();
                }
            }
        });
    });

    // Function to fetch user suggestions based on input
    function fetchUserSuggestions(query) {
        // Example: Replace with your actual Microsoft Graph API endpoint for user search
        var apiUrl = `https://graph.microsoft.com/v1.0/users?$filter=startswith(mail,'${query}')`;

        // Fetch API call
        fetch(apiUrl, {
            headers: {
                Authorization: 'Bearer <YOUR_ACCESS_TOKEN>',
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            // Process fetched data and display suggestions in a dropdown or list
            displayUserSuggestions(data.value);
        })
        .catch(error => {
            console.error('Error fetching user suggestions:', error);
        });
    }

    // Function to display user suggestions
    function displayUserSuggestions(users) {
        // Example: Replace with your actual implementation to display suggestions
        console.log('User Suggestions:', users);
        // Implement logic to show suggestions beneath Quill editor
    }

    // Function to hide user suggestions dropdown or list
    function hideUserSuggestions() {
        // Example: Replace with your actual implementation to hide suggestions
        console.log('Hide suggestions');
        // Implement logic to hide suggestions when no "@" symbol or no text after "@"
    }

    // Save Quill content to textarea on form submit
    function submitForm() {
        var editorContent = document.querySelector('textarea[name=com]');
        editorContent.value = quill.root.innerHTML;
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
                <select name="DepType" class="input-box">
                    <option value="security">Cyber Security</option>
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

    // Set the time zone to IST
    TimeZone istTimeZone = TimeZone.getTimeZone("Asia/Kolkata");
    Calendar calendar = Calendar.getInstance(istTimeZone);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    sdf.setTimeZone(istTimeZone);
    String timestamp = sdf.format(calendar.getTime());

    if (date1 != null && name1 != null && dep1 != null && shiftType != null && com1 != null && 
        !date1.isEmpty() && !name1.isEmpty() && !dep1.isEmpty() && !shiftType.isEmpty() && !com1.isEmpty()) { 
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
            ps.setString(6, timestamp);
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
