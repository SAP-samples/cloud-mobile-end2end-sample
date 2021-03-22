package com.sap.odata;

@javax.servlet.annotation.WebServlet(
    loadOnStartup = 0,
    urlPatterns = "/*")
public class MainServlet extends com.sap.odata.base.MainServletBase {
    private static final long serialVersionUID = 1L;

    public void init(javax.servlet.ServletConfig config) throws javax.servlet.ServletException {
        // For customization, see also: LogSettings, ProviderSettings, TestSettings.
        super.init(config);
    }
}
