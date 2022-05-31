<%--
##########################################################################################################
# Nombre Archivo  : index.jsp
# Compañia        : Premium Restaurant Brands
# Autor           : JPG
# Objetivo        : Balanceador de cargas para el eYum V3
# Fecha Creacion  : 30/Ago/2012
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="javax.naming.*"%>
<%@page import="java.util.*" %>
<%@page import="yum.e3.server.generals.*" %>

<%
    Context loContext = new InitialContext();
    String msURLtext = (String) loContext.lookup("java:comp/env/balancerRedirectURL");
    String msStorePorts = (String) loContext.lookup("java:comp/env/balancerStorePorts");
    String msOfficePorts = (String) loContext.lookup("java:comp/env/balancerOfficePorts");
    String msClientIp = request.getRemoteAddr();

    String msIsStore = AppServerHandler.getInstance().getIsStore();
    if (msIsStore.equals("true")) {
        response.sendRedirect("ePremiumMainPage.html" + getURLParams(request));
        return;
    }

    if (msClientIp.indexOf("127.0.0.") == 0) {
        response.sendRedirect("smartE3.html" + getURLParams(request));
        return;
    }

    boolean mbIsStore = (msClientIp.indexOf("10.114.") == 0 && msClientIp.indexOf("10.114.51.") == -1 && msClientIp.indexOf("10.114.50.1") == -1 && msClientIp.indexOf("10.114.50.15") == -1 && msClientIp.indexOf("10.114.201.") == -1) ? true : false;
    String msPageContent = "";
    WGet moWGet = new WGet();
    String msPort = "";
    Random moRnd = new Random();
    String msTestURL = "";
    String msURL = "";
    String maOfficePorts[] = msOfficePorts.split(",");
    String maStorePorts[] = msStorePorts.split(",");
    String maPorts[];
    ArrayList<String> moAttemps = new ArrayList<String>();

    maPorts = (mbIsStore) ? maStorePorts : maOfficePorts;

    do {
        msPort = maPorts[moRnd.nextInt(maPorts.length)];

        if (moAttemps.indexOf(msPort) == -1) {
            moAttemps.add(msPort);
        } else {
            continue;
        }

        msTestURL = "http://" + msURLtext + ":" + msPort + "/smartE3/balancerTester.jsp";
        msPageContent = moWGet.getPage(msTestURL);

        //out.println(msTestURL + "<br><br>");
    } while (msPageContent.equals("") && moAttemps.size() < maPorts.length);

    if (!msPageContent.equals("")) {
        msURL = "http://" + msURLtext + ":" + msPort + "/smartE3/smartE3.html" + getURLParams(request);
        response.sendRedirect(msURL);
        System.out.println("\nSe accedio a: " + msURL + "\ndesde: " + msClientIp);
    } else {
        out.println("<script>alert('Por el momento la intranet esta muy ocupada, por favor intenta nuevamente  en unos minutos');</script>");
    }
%>

<%!
    String getURLParams(HttpServletRequest poRequest) {
        Enumeration loParams = poRequest.getParameterNames();
        String lsURLParams = "";
        int liCounter = 0;
        while (loParams.hasMoreElements()) {
            String lsParamName = (String) loParams.nextElement();
            lsURLParams += (liCounter == 0) ? "?" : "&";
            lsURLParams += lsParamName + "=" + poRequest.getParameter(lsParamName);
            liCounter++;
        }

        return lsURLParams;
    }

%>



