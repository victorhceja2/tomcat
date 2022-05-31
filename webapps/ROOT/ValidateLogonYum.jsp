<%@page contentType="text/html"%>
<%@page import="generals.*"%>

<%  
    HtmlAppHandler moSession = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    AbcUtils moAbcUtils = new AbcUtils();
    String msLoginSession = request.getParameter("hidLoginSession");
    String msLoginOptions = request.getParameter("hidLoginOptions");
    String msUserIdFrm = request.getParameter("txtUser");
    String msPasswordFrm = request.getParameter("txtPassword");
    String msUserId;
    String msPassword;
    String msUserType;
    UserSecurityData moSecurityData;

    msLoginSession = (msLoginSession!=null)?msLoginSession:"new";
    
    if (moSession==null) {
        session = request.getSession(true);
        msUserId = msUserIdFrm;
        msPassword = msPasswordFrm;
    } else {
        if (msLoginSession.equals("new")) {
            msUserId = msUserIdFrm;
            msPassword = msPasswordFrm;
        } else {
            msUserId = moSession.moUserData.getUserId();
            msPassword = moSession.moUserData.getPassword();
        }
    }

    msUserType = moAbcUtils.queryToString("SELECT (SELECT ldap_user FROM ss_cat_user WHERE user_id = '" + msUserId + "')","","");
    
    if (msUserType==null) { response.sendRedirect("LogonErrorYum.html"); return; }

    if (msUserType.equals("0"))
        moSecurityData = new UserSecurityData(msUserId,msPassword);
    else {
        RadiusSession moRadiusSession = new RadiusSession();
        if (moRadiusSession.validateUser(msUserId,msPassword))
            moSecurityData = new UserSecurityData(msUserId);
        else {
            response.sendRedirect("LogonErrorYum.html");
            return;
        }
    }

    moSecurityData.setUserLoginOptions(msLoginOptions);
    if (moSecurityData.fillUserData()) {
        synchronized (application) {
            HtmlAppHandler moHtmlAppHandler = (moSession == null)?new HtmlAppHandler(request.getHeader("user-agent")):moSession;
            moSecurityData.setPassword(msPassword);
            moHtmlAppHandler.setUserData((UserData)moSecurityData);
            moHtmlAppHandler.updateHandler("");
            session.setAttribute(request.getRemoteAddr(),moHtmlAppHandler);
            session.setMaxInactiveInterval(10800);
            if (!moSecurityData.getLoginOptionsStatus())  {
                %>
                    <script> 
                        var miAnswer = confirm('Usted no tiene acceso a la opción seleccionada, desea continuar?');
                        if (!miAnswer) 
                            document.location.href = 'WelcomeYum.jsp';
                        else
                            document.location.href = 'MainPageYum.jsp';
                    </script>
                <%
            } else {
                String lsParameters = (msLoginOptions!=null && !msLoginOptions.equals(""))?"?psLoginOptions=" + msLoginOptions:"";
                response.sendRedirect("MainPageYum.jsp" + lsParameters);
            }
        }
    }
    else {
        session.invalidate();
        response.sendRedirect("LogonErrorYum.html");
    }
%>
