<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>SearchDetails</title>
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
        height: 50px;
        width: 300px;
        margin: auto; /* Center the heading */
    }
    .input-box {
        width: 300px;
        padding: 10px;
        border: 2px solid navy;
        border-radius: 5px;
    }
    table {
        border-collapse: collapse;
        width: 100%;
        border: 2px solid darkblue;
    }
    .tb1 {
        border: 0px;
    }
    th, td {
        padding: 8px;
        text-align: center;
        border: 1px solid darkblue;
        vertical-align: top; /* Align text to the top */
    }
    th {
        background-color: darkblue;
        color: white;
    }
    form {
        text-align: left;
    }
    table input[type="date"], table input[type="text"], table select {
        width: calc(100% - 18px);
        padding: 6px;
        margin: 0;
        box-sizing: border-box;
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
        width: auto; /* Allow container to expand based on content */
        max-width: 1000px; /* Limit maximum width */
        margin: auto;
        background-color: lightsteelblue;
        border-radius: 15px;
        padding: 20px;
        overflow-x: auto; /* Enable horizontal scrolling if needed */
    }
    .green-text {
        color: green;
    }
    .comments {
        word-wrap: break-word; /* Break long words */
        max-width: 300px; /* Set maximum width */
       /* max-height: 100px; /* Set maximum height */
        /*overflow-y: auto; /* Add vertical scroll if text exceeds height */
        /*overflow-x: auto; /* Hide horizontal scroll if any */
    }
</style>
<script>
    window.onload = function() {
        var today = new Date().toISOString().split('T')[0];
        document.getElementsByName('startDate')[0].value = today;
        document.getElementsByName('endDate')[0].value = today;
    };
</script>
</head>
<body>
<div class="container">
    <center>
    <div style="width:300px;">
    <form method="post">
        <h1>Search Your Details</h1><br>
        <center>
        <table class="tb1">
            <tr>
                <td>Start Date:</td>
                <td><input type="date" class="input-box" name="startDate"></td>
            </tr>
            <tr>
                <td>End Date:</td>
                <td><input type="date" class="input-box" name="endDate"></td>
            </tr>
            <tr>
                <td>Name:</td>
                <td><input type="text" class="input-box" name="name"></td>
            </tr>
            <tr>
                <td>Shift Type:</td>
                <td>
                    <select class="input-box" name="shiftType">
                        <option value="">--Select--</option>
                        <option value="Morning">Morning Shift</option>
                        <option value="Evening">Evening Shift</option>
                        <option value="Night">Night Shift</option>
                    </select>
                </td>
            </tr>
        </table>
    </center> <br> <br>
        <center>
            <button type="button" onclick="window.location.href='index.jsp'" class="btn">Back</button>
            <input type="submit" value="Search" class="btn">
        </center>
    </form>
    </div>
    </center>

    <%
    boolean searchPerformed = request.getParameter("startDate") != null || request.getParameter("endDate") != null || request.getParameter("name") != null || request.getParameter("shiftType") != null;
    if (searchPerformed) {
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String name = request.getParameter("name");
        String shiftType = request.getParameter("shiftType");

        StringBuilder query = new StringBuilder("SELECT * FROM snp WHERE 1=1");
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND date >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND date <= ?");
        }
        if (name != null && !name.isEmpty()) {
            query.append(" AND name LIKE ?");
        }
        if (shiftType != null && !shiftType.isEmpty()) {
            query.append(" AND shiftType = ?");
        }

        try {
            String url = "jdbc:sqlserver://reactmvp.database.windows.net:1433;databaseName=bhuvanasho;user=reactadmiuser;password=An1ku2sh3@123;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection connect = DriverManager.getConnection(url);
            PreparedStatement ps = connect.prepareStatement(query.toString());
            
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate);
            }
            if (name != null && !name.isEmpty()) {
                ps.setString(paramIndex++, "%" + name + "%");
            }
            if (shiftType != null && !shiftType.isEmpty()) {
                ps.setString(paramIndex++, shiftType);
            }

            ResultSet rs = ps.executeQuery();

            if (!rs.isBeforeFirst()) { // Check if ResultSet is empty
                out.println("<center><h2 style='color:red;'>Record not found</h2></center>");
            } else {
                out.println("<center><h2 class='green-text'>Your details based on your search:</h2></center>");
                out.println("<center><form method='post'><table border='1' class='tb1'>");
                out.println("<tr><th>Date</th><th>Name</th><th>Department</th><th>Shift Type</th><th>Comments</th><th>Time of Submission</th></tr>");

                while (rs.next()) {
                    String id = rs.getString("id");
                    String dt = rs.getString("date");
                    String nm = rs.getString("name");
                    String dp = rs.getString("department");
                    String st = rs.getString("shiftType");
                    String co = rs.getString("comments");
                    Time ts = rs.getTime("submissionTime"); // Changed to Time to only show time
                    out.println("<tr>");
                    out.println("<td><input type='hidden' name='id' value='" + id + "'>" + dt + "</td>");
                    out.println("<td>" + nm + "</td>");
                    out.println("<td>" + dp + "</td>");
                    out.println("<td>" + st + "</td>");
                    out.println("<td><div class='comments'>" + co + "</div></td>");
                    out.println("<td>" + ts + "</td>");
                    out.println("</tr>");
                }
                out.println("</table></form></center>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<center><h2 style='color:red;'>An error occurred while processing your request</h2></center>");
        }
    }
    %>
</div>
</body>
</html>
