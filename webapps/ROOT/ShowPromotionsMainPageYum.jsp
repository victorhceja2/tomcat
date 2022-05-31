
<%--
##########################################################################################################
# Nombre Archivo  : MainPageYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Página principal del WellcomePageYum (despliega resultados)
# Fecha Creacion  : 21/Abril/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>

<body class="FrameColor">
  <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>


    <!--body style = 'overflow:hidden'  onResize = 'adjustMainContainer()' class="FrameColor"-->
        <script language = 'javascript'>
            var miAppletWidth = 340;
            var msShowHide = 'show';
            var msShowHideW = 'hidden';
            var mbIsNN = (window.innerHeight)?true:false;
            var mbIsIE = !mbIsNN;


            function showPage(psCurrentPage,psTarget,psOptions) {
                document.frmMainContainer.action = psCurrentPage;
                document.frmMainContainer.target = psTarget;
                document.frmMainContainer.submit();
                updateOptions(psCurrentPage,psTarget,psOptions);
                if (psOptions!='')
                    showOptionsBar();
                else 
                    hideOptionsBar();
                adjustMainContainer();
            }

            function shootPage(psVarName) {
                var liValidator = gsMenuKeys.indexOf(psVarName);
                
                if (liValidator != -1) {
                    var loFuncName = eval(psVarName);
                    eval(loFuncName);
                }
                else
                    alert('No existe el reporte o la aplicación seleccionada');
            }

            function viewReport() {
                top.document.getElementById('aplOptions').executePage('VIEWPORT');
            }



            function exportReport() {
                top.document.getElementById('aplOptions').executePage('EXCEL');
            }

            function executeReport(psTarget, psPresentation) {
                lsOldTarget = document.frmMainContainer.target;
                document.frmMainContainer.target = psTarget;
                document.frmMainContainer.submit();
                document.frmMainContainer.target = lsOldTarget;
                changePercentStatus(0);
                if (psPresentation == 'VIEWPORT') showWaitWindow();
                top.document.getElementById('aplOptions').dummieFunction();
                hideOptionsBar();
                adjustMainContainer();
            }



            function updateOptions(psCurrentPage,psTarget,psOptions) {
                top.document.getElementById('aplOptions').updateRptOptions(psCurrentPage,psTarget,psOptions);
            }

            function setCurrentPage(psCurrentPage) {
                top.document.getElementById('aplOptions').setCurrentPage(psCurrentPage);
            }

            function showHideOptionsBar() {
                showHideOptions();
                adjustMainContainer();
            }



            function getWindowWidth() {
                    var liWindowWidth = (window.innerWidth)?window.innerWidth:document.body.clientWidth;
                    return(liWindowWidth);
            }

            function getWindowHeight() {
                    var liWindowHeight = (window.innerHeight)?window.innerHeight:document.body.clientHeight;
                    return(liWindowHeight);
            }

            function adjustMainContainer() {
                var liWindowHeight = getWindowHeight();
                var liWindowWidth = getWindowWidth();
                var liMCLeftMargin = (mbIsIE)?45:60;
                var liMBLeftMargin = (mbIsIE)?0:5;

                //document.getElementById('divOptions').style.height = liWindowHeight - 60;
                //document.getElementById('divMenuBar').style.width = liWindowWidth - liMBLeftMargin;
                document.getElementById('ifrMainContainer').style.width = liWindowWidth - (miAppletWidth + liMCLeftMargin);
                document.getElementById('ifrMainContainer').style.height = liWindowHeight - 60;
                if (mbIsIE) document.aplOptions.setSize(0,0);
            }

        </script>

            <table id = 'tblShowContainer' class="FrameColor" border = '0' width='100%'  height="100%" cellpadding=0 cellspacing=0 border=1 >
                <tr>
                    <td valign = 'top' align = 'center'>  
                                <font class="TextBodyDesc" size="2"><b>Promociones Marketing</b></font>
                     </td>
                </tr>
                <tr>
                    <td valign = 'top' align = 'center'>  
                                <img src='/Images/Wellcome/animated_promo_KFC_PH.gif' border='0' alt='Promociones YUM' width="260" height="360">
                     </td>
                </tr>
             </table>
            
</body>

