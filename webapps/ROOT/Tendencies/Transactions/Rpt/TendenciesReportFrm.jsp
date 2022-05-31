

<%@ page import = "java.io.BufferedReader" %>
<%@ page import = "java.io.FileReader" %>
<%@ page import = "java.io.File" %>

<%@ page import = "generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/TendenciesLibYum.jsp" %>
 
<%! 
    HtmlAppHandler moHtmlAppHandler;
	AbcUtils moAbcUtils;
	String msPrintOption;
	String msMessage;
	String msGraphicTitle;
    String msGraphURL;
    String msTarget;
    String msReportOk;
    String msCSSFile;
%>

<%
    moAbcUtils    = new AbcUtils();
	msTarget      = request.getParameter("hidTarget");
	msMessage     = request.getParameter("hidMessage");
	msReportOk    = request.getParameter("hidReportOk");

    if(msTarget.equals("Preview"))
    {
        msPrintOption = "yes";
        msCSSFile = "/CSS/DataGridReportPreviewYum.css";
    }    
    else
    {
        msPrintOption = "no";
        msCSSFile = "/CSS/DataGridReportPrinterYum.css";
    }    

    if(msMessage.equals("NA"))
        msMessage = "&nbsp";
    else
        msMessage = "<div class='detail-cont'><p>" + msMessage + "</p></div>";

    moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("&Iacute;ndice de transacciones por tendencia diaria",msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();	
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>
        <style type="text/css">
        <!--
            pre		{ font-size : 10px; color : #000099; font-family: "Courier New", Courier, mono;}
        -->
        </style>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>

        <script type="text/javascript">
            var loGrid   = new Bs_DataGrid('loGrid');


        function initDataGrid()
        {        
            loGrid.bHeaderFix = false;
            loGrid.isReport   = true;
	        loGrid.padding    = 4;

			var laDataset = parent.gaDataset;
	       
			if(laDataset.length > 0)
            {
                mheaders  = new Array(
                         {text:'&nbsp; ',width:'20%', hclass:'right', bclass: 'right'},
                         {text:'<pre>COMIDA</pre>', width:'25%', align: 'center', hclass:'right', bclass:'right'},
                         {text:'<pre>CENA</pre>', width:'25%', align: 'center', hclass:'right', bclass:'right'},
                         {text:'&nbsp;', width:'10%', hclass: 'right', bclass: 'right'},
                         {text:'<pre>  INDICE TX</pre>', width:'20%'}
                         );

                headers  = new Array(
                         {text:'<pre>  FECHA </pre>',width:'20%', hclass:'right', bclass: 'right'},
                         {text:'<pre>  EI   CO   DV   TOT  R</pre>', width:'25%', align: 'center', hclass:'right', bclass:'right'},
                         {text:'<pre>  EI   CO   DV   TOT  R</pre>', width:'25%', align: 'center', hclass:'right', bclass:'right'},
                         {text:'<pre>  TOTAL</pre>', width:'10%', hclass: 'right', bclass: 'right'},
                         {text:'<pre>  (REAL/GERENTE) </pre>', width:'20%'}
                         );

                loGrid.setMainHeaders(mheaders);
                loGrid.setHeaders(headers);
				loGrid.setData(laDataset);

                loGrid.drawInto('goDataGrid');
            }
        }

	        function executeReportCustom()
        	{
            	parent.printer.focus(); parent.printer.print();
        	}


        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid()">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true"/>
    </jsp:include>
	<br>
	<table width="90%" border="0" cellspacing="6">
        <tr>
            <td>
                <div id="goDataGrid"></div>
            </td>
        </tr>
    </table>
    <br>
	<table align="center" width="70%" border="0" cellspacing="6">
        <tr>
            <td align="center">
                <%= msMessage %>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
