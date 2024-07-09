import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.GenericServlet;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import javax.servlet.annotation.WebServlet;

@WebServlet("/MySrevlet")
public class MySrevlet extends GenericServlet {

    private String query;
    private Connection connect;
    private ResultSet rs;
    private PreparedStatement ps;
    private String query1;
    private String url = "jdbc:sqlserver://bhuvanaserver.database.windows.net:1433;databaseName=db-bhuvana-eus;user=bhuvana;password=Bhuvaneswari@15";

    @Override
    public void service(ServletRequest req, ServletResponse res) throws ServletException, IOException {
        String date = req.getParameter("date");
        String name = req.getParameter("name");
        String dep = req.getParameter("dep");
        String com = req.getParameter("com");
        String date1 = req.getParameter("dates");
        String name1 = req.getParameter("names");
        PrintWriter out = res.getWriter();
        res.setContentType("text/html");

        query = "INSERT INTO snp VALUES (?, ?, ?, ?)";
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connect = DriverManager.getConnection(url);
            ps = connect.prepareStatement(query);
            ps.setString(1, date);
            ps.setString(2, name);
            ps.setString(3, dep);
            ps.setString(4, com);
            int rs1 = ps.executeUpdate();
            if (rs1 > 0) {
                out.println("<center><h1 style='color:green;'>Record Added..</h1></center>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (date1 != null && name1 != null) {
            query = "SELECT * FROM snp WHERE date = ? AND name = ?";
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connect = DriverManager.getConnection(url);
                ps = connect.prepareStatement(query);
                ps.setString(1, date1);
                ps.setString(2, name1);
                rs = ps.executeQuery();

                out.println("<center><h1 style='color:pink;'>Your details based on your date and name:</h1></center>");
                out.println("<center><table border='1'>");
                out.println("<tr><th>Date</th><th>Name</th><th>Department</th><th>Comments</th></tr>");

                while (rs.next()) {
                    String dt = rs.getString("date");
                    String nm = rs.getString("name");
                    String dp = rs.getString("department");
                    String co = rs.getString("comments");
                    out.println("<tr>");
                    out.println("<td>" + dt + "</td>");
                    out.println("<td>" + nm + "</td>");
                    out.println("<td>" + dp + "</td>");
                    out.println("<td>" + co + "</td>");
                    out.println("</tr>");
                }

                out.println("</table></center>");

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
