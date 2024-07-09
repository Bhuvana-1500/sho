<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
    // Invalidate the session
    session.invalidate();

    // Azure AD configuration
    String tenantId = "30bf9f37-d550-4878-9494-1041656caf27";  // Replace with your actual tenant ID
    String clientId = "b0da856b-17ed-46b5-b2e4-73a7f46b72cb";  // Replace with your actual client ID
    String redirectUri = "https://javaterraform.azurewebsites.net/demosho";  // Replace with your actual redirect URI
    String scope = "openid profile email";  // Add the required scopes

    // Construct the login URL
    String loginUrl = "https://login.microsoftonline.com/" + tenantId + "/oauth2/v2.0/authorize" +
                      "?client_id=" + clientId +
                      "&response_type=id_token" +
                      "&redirect_uri=" + redirectUri +
                      "&scope=" + scope +
                      "&response_mode=fragment" +
                      "&nonce=" + java.util.UUID.randomUUID().toString();

    // Azure AD logout URL with post_logout_redirect_uri set to the login URL
    String logoutUrl = "https://login.microsoftonline.com/" + tenantId + "/oauth2/v2.0/logout" +
                       "?post_logout_redirect_uri=" + java.net.URLEncoder.encode(loginUrl, "UTF-8");

    // Redirect the response to the logout URL
    response.sendRedirect(logoutUrl);
%>
