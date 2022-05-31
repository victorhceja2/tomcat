<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ReportsYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Mostrar las ordenes de compra mas recientes
# Fecha Creacion  : 14/Febrero/2005
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>
<%@page import="jinvtran.inventory.*" %>
<%@page import="java.util.*, java.io.*, java.text.*"%>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>   

<%
    String msProv;
    try{
        msProv=request.getParameter("cmbProvRep");
    }
    catch(Exception e){
        msProv="-1";
    }

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Pedidos m&aacute;s recientes","Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
    
        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');

        function initDataGrid(){        
            loGrid.bHeaderFix = false;

			var laDataset = <%= moAbcUtils.getJSResultSet(getQueryReport(msProv)) %>;
			
			if(laDataset.length > 0){
                mheaders = new Array(
                         {text:'Pedido',colspan:'2', align:'center', hclass:'right'},
                         {text:'Remisi&oacute;n', align:'center', hclass:'right'},
                         {text:'Recepci&oacute;n', colspan:'6', align:'center'});

                headers  = new Array(
                         {text:'Num orden',width:'10%', sort:true},
                         {text:'Fecha ',width:'11%', sort:true, hclass:'right', bclass:'right'},
                         {text:'Num pedido', width:'10%', sort:true, hclass:'right', bclass:'right'},
                         {text:'Num recepci&oacute;n ID',  width:'13%', sort: true},
                         {text:'Num pedido', sort:true, width:'10%'},
                         {text:'Fecha ', width:'11%', sort:true},
                         {text:'Reporte diferencias', width:'10%', sort:true},
                         {text:'Reporte reenvio', width:'10%', align:'left'},
                         {text:'Responsable', width:'15%', align:'left'} );

                links    = new Array(
                         {key:0, baseUrl:'ShowOrderYum.jsp?orderId='},
                         null,
                         {key:2, baseUrl:'ShowRemisYum.jsp?remissionId='},
                         {key:3, baseUrl:'ShowRecepYum.jsp?recepId='}, 
                         null,
                         null,
                         {key:3, baseUrl:'ShowReportDiffYum.jsp?recepId='},
                         {key:3, baseUrl:'ShowForwardYum.jsp?recepId='},
			 null);
    
                props    = new Array(
                         {onclick:'loGrid.openlink'},
                         null,
                         {onclick:'loGrid.openlink'},
                         {onclick:'loGrid.openlink'},
                         null,
                         null,
                         {onclick:'loGrid.openlink'},
                         {onclick:'loGrid.openlink'},
			 null);

                tooltips = new Array(
                         {text: 'Ver detalle de la orden [0]', width: 150},
                         null,
                         {text: 'Ver detalle de la remisi&oacute;n [2]'},
                         {text: 'Ver detalle de la recepci&oacute;n [3]', width: 100},
                         null,
                         null,
                         {text: 'Ver reporte de diferencias', width: 100},
                         {text: 'Ver reporte de reenvios', width: 100},
			 null);
                         
                loGrid.setMainHeaders(mheaders);
                loGrid.setHeaders(headers);
                loGrid.setDataProps(props);
                loGrid.setLinks(links);
                loGrid.setTooltips(tooltips);
                loGrid.setData(laDataset);        
                loGrid.drawInto('goDataGrid');
            }
        }
        </script>
    </head>

    <body bgcolor="white" onLoad="initDataGrid()">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>

        <script src="/Scripts/TooltipsYum.js"></script>

        <table align="center" width="98%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                Centro de contribuci&oacute;n: 
            </td>
            <td class="descriptionTabla" width="85%">
                <b><%=getStore()%>&nbsp;<%=getStoreName()%></b>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
                <br><br>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!

	String getQueryReport(String psProv)
	{
		//Ordenes abiertas
        String lsQuery = "SELECT distinct(text(ord.order_id)) AS order_id, to_char(ord.date_id, 'DD/Mon/YYYY') as order_date_id, rem.remission_id as remission_id, '', '', '','','','' FROM op_grl_order ord INNER JOIN op_grl_order_detail ordd ON ord.order_id=ordd.order_id LEFT JOIN op_grl_remission rem ON ord.order_id = rem.order_id WHERE ord.date_id > (current_date - interval '70 days') AND ord.order_id NOT IN(SELECT order_id FROM op_grl_reception ORDER BY date_id DESC LIMIT 15)";

        if(psProv.compareTo("-1") != 0)
        lsQuery += " AND ordd.provider_id='"+psProv+"'";

        lsQuery += " UNION \n";
                
        //Recepciones con orden y sin remision
        lsQuery += "SELECT text(ord.order_id) AS order_id, to_char(ord.date_id, 'DD/Mon/YYYY') " +
		   "AS order_date_id, '' as remission_id, text(rcp.reception_id), rcp.document_num, " +
		   "to_char(rcp.date_id, 'DD/Mon/YYYY') AS recep_date_id, " +
                   "get_report_num(rcp.reception_id,'Sin reporte') AS rep_dif, " + 
		   "get_forwarding(rcp.reception_id,'Sin reenvio') AS reenvio, responsible FROM op_grl_reception rcp " +
		   "INNER JOIN op_grl_order ord ON ord.order_id = rcp.order_id WHERE " +
		   "rcp.date_id > (current_date - interval '70 days') AND rcp.remission_id = '-1' ";

        if(psProv.compareTo("-1") != 0)
        lsQuery += " AND rcp.provider_id='"+psProv+"'";

        lsQuery += " UNION \n";

        //Recepciones con orden y con remision
        lsQuery += " SELECT text(ord.order_id) AS order_id, to_char(ord.date_id, 'DD/Mon/YYYY') as order_date_id, rem.remission_id, text(rcp.reception_id), rcp.document_num, to_char(rcp.date_id, 'DD/Mon/YYYY') AS recep_date_id, get_report_num(rcp.reception_id,'Sin reporte') AS rep_dif, get_forwarding(rcp.reception_id,'Sin reenvio') AS reenvio, responsible FROM op_grl_reception rcp INNER JOIN op_grl_remission rem ON rcp.remission_id = rem.remission_id INNER JOIN op_grl_order ord ON rem.order_id = ord.order_id WHERE rcp.date_id > (current_date - interval '70 days') ";
        if(psProv.compareTo("-1") != 0)
            lsQuery += "AND rcp.provider_id='"+psProv+"'";


		lsQuery += " UNION \n ";

		//Recepciones sin orden (y sin remision)
		lsQuery += "SELECT 'NA' AS order_id,'' AS orde_date_id, '' AS remision_id, " +
				   "text(rcp.reception_id), rcp.document_num, " +
				   "to_char(rcp.date_id, 'DD/Mon/YYYY') AS recep_date_id, " +
				   "'' AS rep_dif, '' AS reenvio, responsible FROM op_grl_reception rcp " +
				   "WHERE rcp.date_id > (current_date - interval '70 days') AND " +
				   "rcp.order_id = -1 AND rcp.remission_id = '-1' " ;

        if(psProv.compareTo("-1") != 0)
            lsQuery += "AND rcp.provider_id='"+psProv+"'";

        lsQuery += "ORDER BY order_id DESC";

        return(lsQuery);

	}
%>
