<%--
##########################################################################################################
# Nombre Archivo  : SearchMainPageYum.jsp
# Compa?ia        : Yum Brands Intl
# Autor           : ARM
# Objetivo        : Busqueda del Directorio YUM
# Fecha Creacion  : 23/abril/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
# 27/Abr/2004       JPG             Mejoras visuales y ajustes para liberaci?n
# 17/Ago/2009       QPH             Se aniade la seccion de Soporte Tecnico
# 16/Abr/2010       SCV             Liga a reporteador
##########################################################################################################
--%>


<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%@page import="java.io.*" %>
<%
    HtmlAppHandler moSessionAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    //String[] cmd = { "/bin/sh", "-c", "/sbin/ifconfig eth0 | grep inet | awk '{print $2}' | sed 's/addr://'" };
    String[] cmd = { "/usr/bin/ph/isFranq.sh" };
    String s = "";

    try {
        Process p = Runtime.getRuntime().exec(cmd);
        BufferedReader stdInput = new BufferedReader(new
        InputStreamReader(p.getInputStream()));
        s = stdInput.readLine();
    } catch (IOException e) {
        System.out.println("Error al ejecutar el comando: ");
        e.printStackTrace(); 
    }
%>
    <script>
        var miMenuStatus='1';
        var maColors = new Array('#D2E4FC','#D6EFB6','#FEF7BC','#F7F3FF','#E6E6E6');
        var msShowLoginW = 'hidden';
        var msShowMiniHelpW = 'hidden';

        function gotoReporteador(){
             document.frmMainContainer.target='_blank';
             document.frmMainContainer.action='http://<%=s%>/reporteador';
             document.frmMainContainer.submit();
        }

        function gotoEyum(){
             document.frmMainContainer.target='_blank';
             document.frmMainContainer.action='http://www.yummexico.net';
             document.frmMainContainer.submit();
        }

        function setTabActive(psSearch) {
            document.getElementById('tblSearch').style.backgroundColor=maColors[psSearch-1];
            synchTab(psSearch);
        }

        function synchTab(ls_tab_name) {
            var elList,i;
            elList = document.getElementsByTagName("A");
            for (i = 0; i < elList.length; i++)
                if (elList[i].id == ls_tab_name) {
                    elList[i].className += " activeTab";
                    elList[i].blur();
                }
                else {
                    if (elList[i].name.length==1)
                        elList[i].className = "tab";
                }
        }

        function showLoginWindow() {
            msShowLoginW = 'visible';
            document.frmLogon.hidLoginSession.value = 'new';
            showHideControl('divLogin',msShowLoginW);
            parent.document.frmLogon.txtUser.focus();
            hideIframes();
        }


        function hideLoginWindow() {
            msShowLoginW = 'hidden';
            showHideControl('divLogin',msShowLoginW);
            showIframes();
        }

        function accessReports(){
            <%if (moSessionAppHandler==null) { %>
                showLoginWindow();
                document.frmLogon.txtUser.focus();
            <% }else{    %>
                 document.frmLogon.hidLoginSession.value = 'old';
                 document.frmLogon.target='_top';
                 document.frmLogon.action='/ValidateLogonYum.jsp';
                 document.frmLogon.submit();
            <% } %>
        }

        function setOptionKey(lsReport){
           top.document.frmLogon.hidLoginOptions.value=lsReport;
           <%if (moSessionAppHandler==null) { %>
               top.showLoginWindow();
               top.document.frmLogon.txtUser.focus();
           <% }else{    %>
                top.document.frmLogon.hidLoginSession.value = 'old';
                top.document.frmLogon.target='_top';
                top.document.frmLogon.action='/ValidateLogonYum.jsp';
                top.document.frmLogon.submit();
           <% } %>
        }

        function hideIframes() {
            if (mbIsIE5 || mbIsIE5_5) {
                showHideControl('ifrSegment2','hidden');
                showHideControl('ifrSegment3','hidden');
                showHideControl('ifrSegment4','hidden');
                showHideControl('ifrMainContainer','hidden');
            }
        }

        function showIframes() {
            if (mbIsIE5 || mbIsIE5_5) {
                showHideControl('ifrSegment2','visible');
                showHideControl('ifrSegment3','visible');
                showHideControl('ifrSegment4','visible');
                showHideControl('ifrMainContainer','visible');
            }
        }

        </script>
        <center>
            <form name='frmMainContainer' method='post' onSubmit='return submitSearch();'>
            <!-- <input type='hidden' name='hidType' value = '1'>  -->
            <table id = 'tblSearchOpts' border = '0' class = 'tabMain' width = '100%'>
                <tr>
                    <td valign = 'top' align = 'left' colspan=2>
                        <div class='tabBox' style='clear: both' id='tabBox'>
                            <div class=tabArea id=tabArea>
                            <a href = 'javascript:accessReports();' title='Restaurantes' class='tab' id ='1' name = '1'>e-Reports</a>
                            <% if (s.equals("0")) { %>
                                <a href = 'javascript:gotoEyum();' title='Ir a e-Premium' class='tab' id ='2' name = '2'>e-Premium</a>
                            <% } else { %>
                                <a href = 'http://www.yum.com.mx' target='_blank' title='Ir a e-Premium' class='tab' id ='2' name = '2'>e-Premium</a>
                            <% } %>
                            <!--<a href = 'javascript:gotoReporteador();' title='Ir a Reporteador' class='tab' id ='3' name = '3'>Reporteador</a>-->
                            <a href = 'reporteador/wt_main.html' target ='ifrMainContainer' title='Ir a Reporteador' class='tab' id ='4' name = '4'>Reporteador</a>
                            <a href = 'Support/MainSupportPage.jsp' target='ifrMainContainer' title='Soporte Tecnico' class='tab' id ='3' name    = '3'>Soporte Tecnico</a>
                            <a href = 'http://yrisurvey.studiosdallas.com' target='_blank' title='Encuesta CER' class='tab' id ='3' name  = '3'>Encuesta CER</a>
                            <!--<a href = 'http://www.securedatacollection.com/project/PRB360' target='_blank' title='Medicion 360' class='tab' id ='5' name  = '3'>Medici&oacute;n 360</a>-->
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class = '' valign = 'top' align = 'left'>
                        <table id = 'tblLogos' border = '0' width = '100%'>
                            <tr bgcolor = '#D2E4FC' >
                                <td  valign = 'center' align = 'center'>
                                    <img src = '/Images/Wellcome/yum_icon.gif' border = '0'>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <img src = '/Images/Wellcome/kfc_icon.gif' border = '0'>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <img src = '/Images/Wellcome/ph_icon.gif' border = '0'>
                                </td>
                            </tr>
                            <!--<tr>
                                <td align="center">
                                    <a href = 'http://www.securedatacollection.com/project/PRBEmployeeSurvey2014' target='_blank' title='Voz de campeones' id ='6' name  = '3'>
                                    <img src = '/Images/Wellcome/VOC_logo.jpg' border = '0'>
                                    </a>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
                                <!--</td>
                                <td align="center">-->
                                    <!--<a href = 'http://www.securedatacollection.com/project/PRBLeadershipSurvey2014' target='_blank' title='Valoracion de lideres' id ='6' name  = '3'>
                                    <img src = '/Images/Wellcome/VL_logo.jpg' border = '0'>
                                    </a>
                                </td>
                            </tr>-->
                            <tr>
                                <td >
                                    <iframe name ='ifrMainContainer' id ='ifrMainContainer' src ='Support/Advise/MainAdvice.jsp' height='800px'  width = '100%' frameborder = '0'></iframe>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </form>
            </table>
        </center>

