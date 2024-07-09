import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AuthFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (httpRequest.getRemoteUser() == null) {
            // Redirect to Azure AD login page
            String tenantId = "30bf9f37-d550-4878-9494-1041656caf27";  // Replace with your actual tenant ID
            String clientId = "b0da856b-17ed-46b5-b2e4-73a7f46b72cb";  // Replace with your actual client ID
            String redirectUri = httpRequest.getRequestURL().toString();
            String scope = "openid profile email";  // Add the required scopes
            String loginUrl = "https://login.microsoftonline.com/" + tenantId + "/oauth2/v2.0/authorize" +
                              "?client_id=" + clientId +
                              "&response_type=id_token" +
                              "&redirect_uri=" + redirectUri +
                              "&scope=" + scope +
                              "&response_mode=fragment" +
                              "&nonce=" + java.util.UUID.randomUUID().toString();
            httpResponse.sendRedirect(loginUrl);
        } else {
            chain.doFilter(request, response);
        }
    }

    public void destroy() {}
}
