
<%--
##########################################################################################################
# Nombre Archivo  : DateTransactionsReportrpt.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate - Laliux
# Objetivo        : Mostrar reporte grafico de Transacciones generado en
#                 : DateTransactionsReportYum.jsp
# Fecha Creacion  : 03/Nov/05
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page import = "generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
 
<%! 
    HtmlAppHandler moHtmlAppHandler;
	AbcUtils moAbcUtils;
	String msPrintOption;
	String msMessage;
	String msGraphicTitle;
	String msGraphicSubtitle;
    String msGraphURL;
    String msTarget;
    String msDate;
    String msType;
    String msHeader;
%>

<%
    moAbcUtils = new AbcUtils();
	msGraphURL = request.getParameter("hidGraphURL");
	msTarget   = request.getParameter("hidTarget");
	msMessage  = request.getParameter("hidMsg");
    msDate     = request.getParameter("hidSelectedDate");
    msType     = request.getParameter("hidType");

    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";

	if(msGraphURL.equals("/Images/Generals/Transparent.gif"))
	{		
		msGraphicTitle    = "&nbsp";
		msGraphicSubtitle = "&nbsp";
	}
	else
	{
		msGraphicTitle    = getStore() +" &nbsp; "+ getStoreName() ;
		msGraphicSubtitle = "[Datos generados para el " + msDate + "]";
	}

	msHeader  = "&Iacute;ndice de transacciones";
	msHeader += msType.equals("date")?" por fecha":" por d&iacute;a";

    moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader(msHeader, msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();	

%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>

        <script type="text/javascript">
	    function completeTitle()
        {
            var currentYear = parseInt(parent.giSelectedYear);

            if(currentYear != 0)
            {
                var previousYear = currentYear - 1;
                var maintitle = document.getElementById("mainSubtitle");
                maintitle.innerHTML = maintitle.innerHTML + ' ' + currentYear + ' vs ' + previousYear;
			}	
       	}
        </script>
    </head>

    <body bgcolor="white" onLoad="completeTitle()">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp' />
	<br>
	<table align="center" width="80%" border="0" cellspacing="6">
        <tr>
            <td align="center">
                <span class="mainsubtitle"><%= msGraphicTitle %></span>
				<br>
                <span class="subheadB"><%= msGraphicSubtitle %></span>
                <br>
                <img src="<%= msGraphURL %>" border="0">
                <br><br>
            </td>
        </tr>
        <tr>
            <td align="center">
                <div class="subHeadB" id="msg"><%= msMessage %></div>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
