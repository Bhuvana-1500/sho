import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet("/fetchUserEmails")
public class AzureGraphAPIServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accessToken = getAccessToken(); // Implement this method to get the access token
        URL url = new URL("https://graph.microsoft.com/v1.0/users?$select=mail");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "Bearer " + accessToken);
        conn.setRequestProperty("Accept", "application/json");

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            Scanner scanner = new Scanner(url.openStream());
            StringBuilder responseStrBuilder = new StringBuilder();
            while (scanner.hasNext()) {
                responseStrBuilder.append(scanner.nextLine());
            }
            scanner.close();

            JsonObject jsonObject = JsonParser.parseString(responseStrBuilder.toString()).getAsJsonObject();
            JsonArray users = jsonObject.getAsJsonArray("value");
            JsonArray emails = new JsonArray();
            for (int i = 0; i < users.size(); i++) {
                JsonObject user = users.get(i).getAsJsonObject();
                emails.add(user.get("mail").getAsString());
            }

            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(emails.toString());
            out.flush();
        } else {
            response.sendError(responseCode, "Unable to fetch user emails");
        }
    }

    private String getAccessToken() {
        // Implement your logic to fetch the access token using client credentials flow
        return "YOUR_ACCESS_TOKEN";
    }
}
