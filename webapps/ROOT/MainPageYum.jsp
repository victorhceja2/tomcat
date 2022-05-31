<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : MainPageYum.jsp
# Companiaia      : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Pagina principal del e-Yum
# Fecha Creacion  : 29/Enero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%@page import="java.io.*" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msLoginOptions=request.getParameter("psLoginOptions");
    String msOnLoadAction = (msLoginOptions!=null)?"shootPage(\"" + msLoginOptions + "\"); ":"";

%>

<html>
    <head>
        <title>e-Premium Main Page</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/Chars.js"></script>
        <style type='text/css'>
            #divMainContainer{position:absolute; visibility:visible; background-color:white; overflow:no; top:34; height:auto; left: 6; width:auto; z-index:1}
            #divOptions{position:relative; visibility:show; overflow:auto; left:0px; top:0px; width:340; z-index:2}
            #divWait{
                        position:absolute;
                        visibility:show;
                        width:200px;
                        height:auto;
                        background-color:#6B5D9C;
                        border:4px #FFCB31 solid;
                        text-align:center;
                        color:white;
                        font-family:Arial;
                        font-size:12pt;
                        <%=((moHtmlAppHandler.moClientData.clientIsIE())?"filter:alpha(opacity=90);filter:progid:DXImageTransform.Microsoft.Alpha(opacity=90);-moz-opacity:0.9;":"") %>
                        z-index:3
                    }
        </style>
    </head>

    <div id = 'divWait' name = 'divWait'>
        <center>
            <br>Cargando p&aacute;gina.<br>Espere por favor...<br><br>
            <form id = 'frmWait' name = 'frmWait'>
                <input type = 'text' id = 'txtPercent' name = 'txtPercent' maxlength = '4' size = '4' value = '0%' class = 'options' style='border: solid rgb(0,0,0) 0px; background-color:#6B5D9C; foreground-color;white'>
            </form>
        </center>
    </div>

    <script> 

        function centerDivWait() {
            document.getElementById('divWait').style.left = (Math.round(getWindowWidth()/2) - 135) + 'px';
            document.getElementById('divWait').style.top = (Math.round(getWindowHeight()/2) - 80) + 'px';
        }
        
        centerDivWait(); 
    </script>

    <body bgcolor = 'LightSteelBlue' style = 'overflow:hidden; ' onLoad = 'onLoadFunction();' onResize = 'adjustMainContainer()'>
        <jsp:include page = '/Include/GenerateMenuYum.jsp'/>
        <script language = 'javascript'>
            var miAppletWidth = 340;
            var msShowHide = 'show';
            var msShowHideW = 'visible';
            var mbIsNN = (window.innerHeight)?true:false;
            var mbIsIE = !mbIsNN;
            var miPercentStatus = 0;
            var msOptions = '';
            var msOptionExceptions = '';
            var moMenuTimer;

            changePercentStatus(miPercentStatus+=30);

            function onLoadFunction() {
                showHideOptionsBar();
                showHideControl('splitButton','hidden');
                loadHelpPage(0);
                <%=msOnLoadAction %>
                hideWaitWindow();
                if (mbIsNN) moMenuTimer = window.setInterval('setCloseMenuHandler();',2500);
            }

            function setCloseMenuHandler() {
                Mtimer=setTimeout("closeAllMenusCustom();",timegap*4);
            }

            function closeAllMenusCustom() {
                closeallmenus();
                resetShM();
            }
           
            function handleProxyException() {
                //alert('Ocurrio un error al intentar realizar esta operaci�n, \n La causa probable es que este activado un servidor proxy en su navegador. \n\n Contacte a su administrador para que le indique como solucionar este problema.');
                document.location.href = 'WelcomeYum.jsp';
            }

            function changePercentStatus(piPercent) {
                document.frmWait.txtPercent.value = piPercent + '%';
            }

            function showPage(piOptionId,psCurrentPage,psTarget,psOptions, psOptionKey, psOptionGroup,psOptionExceptions) {
                updateOptions(piOptionId,psTarget,psOptions,psOptionExceptions);
                loadHelpPage(piOptionId);
                document.frmMainContainer.action = psCurrentPage;
                document.frmMainContainer.target = psTarget;
                document.frmMainContainer.hidOptionKey.value = psOptionKey;
                document.frmMainContainer.hidOptionGroup.value = psOptionGroup;
                document.frmMainContainer.hidOrderOptions.value = '';
                document.frmMainContainer.submit();
                closeAllMenusCustom();
                msOptions = psOptions;
                msOptionExceptions = psOptionExceptions;
               
                if (psOptions=='null' || psOptions=='') //Not report
                {
                    showHideControl('splitButton','hidden');
                    hideOptionsBar();
                }    
                else 
                {
                    showHideControl('splitButton','visible');
                    showOptionsBar();
                }

                adjustMainContainer();

                <!--EZ-->
                showHideControl('extraFields','hidden');
            }

            function shootPage(psVarName) {
                var liValidator = gsMenuKeys.indexOf(psVarName);
                
                if (liValidator != -1) {
                    var loFuncName = eval(psVarName);
                    eval(loFuncName);
                } else
                    alert('No existe el reporte o la aplicaci'+_oAccute+'n seleccionada');
            }

            function executeReportFromJS(psPresentation) {
                if (msOptions!='' || msOptionExceptions!='') {
                    document.getElementById('aplOptions').executePage(psPresentation);
                    return(false);
                } else {
                    if (document.getElementById('ifrMainContainer').document.getElementById('ifrDetail') && psPresentation=='PRINTER') {
                        document.getElementById('ifrMainContainer').printDetail();
                        return(false);
                    } else {
                        alert('Esta opci'+_oAccute+'n no se puede aplicar en este contexto');
                        return(false);
                    }
                }
            }

            function searchReport() {
                document.getElementById('aplOptions').searchReport();
                return(false);
            }

            function executeReport(psTarget, psPresentation) {
                lsOldTarget = document.frmMainContainer.target;
                document.frmMainContainer.target = psTarget;
                document.frmMainContainer.submit();
                document.frmMainContainer.target = lsOldTarget;
                changePercentStatus(0);
                if (psPresentation == 'VIEWPORT') showWaitWindow();
                hideOptionsBar();
                adjustMainContainer();

                //EZ
                resetTimeOptions();
            }

            function showWaitWindow() {
                msShowHideW = 'visible';
                showHideControl('divWait',msShowHideW);
            }

            function hideWaitWindow() {
                msShowHideW = 'hidden';
                showHideControl('divWait',msShowHideW);
            }

            function updateOptions(psCurrentPage,psTarget,psOptions,psOptionExceptions) {
                document.getElementById('aplOptions').updateRptOptions(psCurrentPage,psTarget,psOptions,psOptionExceptions);
            }

            function setCurrentPage(psCurrentPage) {
                document.getElementById('aplOptions').setCurrentPage(psCurrentPage);
            }

            function showHideOptionsBar() {
                showHideOptions();
                adjustMainContainer();
            }

            function showHideOptionsBarFromTB() {
                if (msShowHideW!='hidden') return(false);
                showHideOptionsBar();
                return(false);
            }

            function showHideOptions() {
               
                if (msShowHide == 'hidden')
                    showOptionsBar();
                else
                    hideOptionsBar();
            }   

            function showHideHelpW() {
                showHideHelpWS((document.getElementById('ifrHelp').style.visibility == 'visible')?'hidden':'visible');
            }

            function showHideHelpWS(psStatus) {
                if (document.getElementById('ifrHelp').style.visibility == psStatus) return;
                document.getElementById('ifrHelp').style.visibility = psStatus
                adjustMainContainer();
            }

            function loadHelpPage(piOptionId) {
                var lsHelpConfig;
                var lsHelpPage;
                var lsHelpAutoDisp;

                if (typeof maHelpOptions[piOptionId] == 'string') {
                    lsHelpConfig = maHelpOptions[piOptionId];
                    lsHelpPage = lsHelpConfig.split(',')[0];
                    lsHelpAutoDisp = lsHelpConfig.split(',')[1];
                    document.getElementById('ifrHelp').href = '/Help/Entry/HelpContainerYum.jsp?psHelpPage=' + lsHelpPage;
                    if (lsHelpAutoDisp==1) showHideHelpWS('visible');
                } else {
                    document.getElementById('ifrHelp').href = '/Help/Entry/HelpContainerYum.jsp';
                    showHideHelpWS('hidden');
                }
            }
            
            function showOptionsBar() {
                miAppletWidth = 340;
                msShowHide = 'visible';
                showHideControl('divOptions',msShowHide);
                document.getElementById('divOptions').style.width = miAppletWidth;
            }

            function hideOptionsBar() {
                miAppletWidth = 1;
                msShowHide = 'hidden';
                showHideControl('divOptions',msShowHide);
                document.getElementById('divOptions').style.width = miAppletWidth;
            }

            function adjustMainContainer() {
                var liWindowHeight = getWindowHeight();
                var liWindowWidth = getWindowWidth();
                var liMCLeftMargin = (mbIsIE)?45:30; //EZ
                var liMBLeftMargin = (mbIsIE)?0:5;
                var liIfrProcHeight = (document.getElementById('ifrProcess').style.visibility == 'visible')?150:0;
                var liIfrHelpHeight = (document.getElementById('ifrHelp').style.visibility == 'visible')?150:0;

                centerDivWait();
                
                document.getElementById('divOptions').style.height = liWindowHeight - 60;
                document.getElementById('divMenuBar').style.width = liWindowWidth - liMBLeftMargin;
                document.getElementById('ifrMainContainer').style.width = liWindowWidth - (miAppletWidth + liMCLeftMargin);
                document.getElementById('ifrMainContainer').style.height = liWindowHeight - liIfrProcHeight - liIfrHelpHeight - 38;

                if (liIfrProcHeight != 0) {
                    document.getElementById('ifrProcess').style.width = document.getElementById('ifrMainContainer').style.width;
                    document.getElementById('ifrProcess').style.top = liWindowHeight - liIfrProcHeight - 55;
                }

                if (liIfrHelpHeight != 0) {
                    document.getElementById('ifrHelp').style.width = document.getElementById('ifrMainContainer').style.width;
                    document.getElementById('ifrHelp').style.top = liWindowHeight - liIfrHelpHeight - 55;
                }

                if (mbIsIE) {
                    document.aplOptions.setSize(0,0); 
                    document.aplOptions.requestFocus(); 
                }
            }

        //EZ
        function setTimeOptions(piYear, piPeriod, piWeek, piDay)
        {
            document.getElementById('hidSelectedYear').value   = piYear;
            document.getElementById('hidSelectedPeriod').value = piPeriod;
            document.getElementById('hidSelectedWeek').value   = piWeek;
            document.getElementById('hidSelectedDay').value    = piDay;
        }
        // EZ
        function setReportType(piReportType)
        {
            document.getElementById('hidReportType').value = piReportType;
        }
        function resetTimeOptions()
        {
            setTimeOptions(0,0,0,0);
            setReportType(0); //none
        }
        function getSelectedMonth()
        {
            return document.getElementById('aplOptions').getSelectedMonth();
        }

    
        </script>
        <br>
        <form id = 'frmMainContainer' name = 'frmMainContainer' method = 'post' target = 'ifrMainContainer'>
        <div id = 'divMainContainer'>
        <table id = 'tblMainContainer' cellpadding='0' cellspacing='2' border='0' width='100%' bgcolor = 'gainsboro'>
            <tr>
                <td valign = 'top' align = 'left' bgcolor = 'white'>
                    <iframe name = 'ifrMainContainer' id = 'ifrMainContainer' src = '/MainHelpYum.html' width = '600' height = '500' frameborder = '0'></iframe><br>
                    <iframe name = 'ifrProcess' id = 'ifrProcess' style = 'position:absolute; visibility:hidden' width = '600' height = '148'></iframe>
                    <iframe name = 'ifrHelp' id = 'ifrHelp' src = 'BlankYum.html' style = 'position:absolute; visibility:hidden' width = '600' height = '148' scrolling = 'no'></iframe>
                </td>
                <td valign = 'top' bgcolor = 'gainsboro'>
                    <div id="splitButton"><a href = '' OnClick = 'return showHideOptionsBarFromTB()'><img src = '/Images/Menu/showhide_button.gif' border='0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br></div>
                    <%  if (moHtmlAppHandler.moClientData.clientIsIE()) { %>
                        <a href = '' OnClick = 'return executeReportFromJS("VIEWPORT");'><img src = '/Images/Menu/execute_button.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br>
                        <a href = '' OnClick = 'return executeReportFromJS("PRINTER");'><img src = '/Images/Menu/print_button.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br>
                        <a href = '' OnClick = 'return executeReportFromJS("EXCEL");'><img src = '/Images/Menu/excel_button.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br>
                    <% } %>
                    <a href = '' OnClick = 'return searchReport();'><img src = '/Images/Menu/search_rpt_button.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br>
                    <a href = 'javascript:top.location.href = "/WelcomeYum.jsp"'><img src = '/Images/Menu/home_button.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=10);'></img></a><br><br>
                    <a href = 'javascript:showHideHelpW();'><img src = '/Images/Menu/help_icon.gif' border = '0' onLoad = 'changePercentStatus(miPercentStatus+=5);'></img></a><br><br>
                </td>
                <td valign = 'top' align = 'right' bgcolor = '#EEEEEE'>
                    <div id='divOptions'>

                        <applet id = 'aplOptions' name = 'aplOptions' codebase = '/applets' code='YumCalendarApplet.class' archive = 'YumCalendar.jar' width='340' height='315' alt = 'No corrio el applet' mayscript>
                            <param name = 'psUserLevel' value = '<%=moHtmlAppHandler.moUserData.getUsrLevel().trim() %>'>
                            <param name = 'psUserOptions' value = '<%=moHtmlAppHandler.moUserData.getOrgLevel().trim() %>'>
                            <param name = 'psUserAgent' value = '<%=request.getHeader("user-agent") %>'>
                        </applet>

                        <!--EZ-->
                        <div id="extraFields"></div>
                    </div>
                </td>
            </tr>
        </table>
        </div>
            <input type = 'hidden' id = 'hidOptionKey' name = 'hidOptionKey' value = ''>
            <input type = 'hidden' id = 'hidOptionGroup' name = 'hidOptionGroup' value = ''>
            <input type = 'hidden' id = 'hidOrderOptions' name = 'hidOrderOptions' value = ''>

            <!--EZ-->
            <input type="hidden" id="hidSelectedYear"   name="hidSelectedYear"   value="0">
            <input type="hidden" id="hidSelectedPeriod" name="hidSelectedPeriod" value="0">
            <input type="hidden" id="hidSelectedWeek"   name="hidSelectedWeek"   value="0">
            <input type="hidden" id="hidSelectedDay"    name="hidSelectedDay"    value="0">
            <input type="hidden" id="hidReportType"     name="hidReportType"     value="0">
        </form>
    </body>
</html>

<%@ include file="/Include/InventoryLibYum.jsp" %>
<%
    /**
    Se actualiza el uso ideal del dia actual en el archivo de inventario de FMS
    */
    updateIdealUse();

    /**
    Se cargan los movimientos financieros del dia. El valor principal que 
     se utiliza en esta aplicacion es la venta neta.
    */
    loadFinantialMov();
%>
