
<%@ page import = "generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
 
<%! 
    HtmlAppHandler moHtmlAppHandler;
	AbcUtils moAbcUtils;
	String msPrintOption;
	String msMessage;
	String msGraphicTitle;
    String msGraphURL;
    String msTarget;
%>

<%
    moAbcUtils = new AbcUtils();
	msGraphURL = request.getParameter("graphURL");
	msTarget   = request.getParameter("target");
	msMessage  = request.getParameter("msMsg");

    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";

	if(msGraphURL.equals("/Images/Generals/Transparent.gif"))
		msGraphicTitle = "&nbsp";
	else
		msGraphicTitle = getStore() +" &nbsp; "+ getStoreName();

    moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Congelado hist&oacute;rico de piezas por transacci&oacute;n",msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();	
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>

        <script type="text/javascript">
	        function executeReportCustom()
        	{
            	parent.printer.focus(); parent.printer.print();
        	}
        </script>
    </head>

    <body bgcolor="white">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp' />
	<br>
	<table align="center" width="80%" border="0" cellspacing="6">
        <tr>
            <td class="subHeadB" align="center">
                <b><%= msGraphicTitle %></b>
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
