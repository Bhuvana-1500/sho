public class AuthFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {}

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        if (httpRequest.getRemoteUser() == null) {
            // Redirect to Azure AD login page
            String tenantId = "30bf9f37-d550-4878-9494-1041656caf27";  // Replace with your actual tenant ID
            String clientId = "d3d001c4-4a33-49ae-9423-494e885c8797";  // Replace with your actual client ID
            String redirectUri = "https://bhuvanasho.azurewebsites.net/demosho"; // Ensure this matches your redirect URI
            String scope = "openid profile email";  // Add the required scopes
            String loginUrl = "https://login.microsoftonline.com/" + tenantId + "/oauth2/v2.0/authorize" +
                              "?client_id=" + clientId +
                              "&response_type=id_token" +
                              "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8") +
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
