<jsp:include page = '/Include/ValidateSessionYum.jsp'/>


<%--
############################################################################################
# Nombre Archivo  : ShowReportDiffFrmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Muestra el reporte de diferencias de una recepcion
# Fecha Creacion  : 22/Feb/05
# Inc/requires    : ../Proc/PurchaseOrderLibYum.jsp
# Modificaciones  :
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria PurchaseOrderLibYum.jsp
############################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="generals.*" %>

<%! AbcUtils moAbcUtils = new AbcUtils(); %>  
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>

<%
    String msRecepId;
    String msCSSFile;
    String msTarget;

    String lsNumRpt="";

    try{
        msRecepId   = request.getParameter("recepId");
        msTarget    = request.getParameter("target");
        msCSSFile   = "/CSS/DataGridReport"+msTarget+"Yum.css";
    }catch(Exception moExcpetion){
        msRecepId   = "0";
        msTarget    = "Preview";
    	msCSSFile   = "/CSS/DataGridReportPreviewYum.css";
    }


    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());

    moHtmlAppHandler.setPresentation("VIEWPORT");

    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());


    moHtmlAppHandler.msReportTitle = getCustomHeader("Consulta reporte de discrepancias ", msTarget);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

%>

<html>
    <head>
        <title>Reporte de diferencias</title>
        <link rel='stylesheet' type='text/css' href="/CSS/GeneralStandardsYum.css">
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>

        <script type="text/javascript" src='/Scripts/ReportUtilsYum.js'></script>
        <script type="text/javascript" src='/Scripts/AbcUtilsYum.js'></script>

		<script type="text/javascript" src="/Scripts/MiscLibYum.js"></script>
		<script type="text/javascript" src="/Scripts/DataGridClassYum.js"></script>
        
        <script type="text/javascript">

        var myGrid = new Bs_DataGrid('myGrid');

        function initDataGrid(){
   			myGrid.bHeaderFix = false;
        	myGrid.isReport = true;
	        myGrid.padding  = 4;        

            data = parent.data; 

            if(data.length > 0){
                mheaders = new Array(
			 {text:'&nbsp;', hclass:'empty'},
                         {text:'&nbsp;', hclass:'empty'},
                         {text:'Pedido',colspan:'4', align:'center',hclass:'center'},
                         {text:'Remisi&oacute;n', colspan:'4', align:'center', hclass:'right'},
                         {text:'&nbsp;', colspan: '3', hclass:'empty'});

                headers  = new Array(
			 {text:'-',width:'2%'},
                         {text:'Producto',width:'15%'},
                         {text:'C&oacute;digo Producto Solicitado',width:'5%',hclass:'left',bclass:'left'},
                         {text:'Cantidad Requerida',width:'5%'},
                         {text:'Equiv Unidad Inv',width:'12%'},
                         {text:'Costo',width:'5%', bclass:'right', hclass:'right'},
                         {text:'C&oacute;digo Producto Recibido', width:'5%'},
                         {text:'Cantidad Recibida', width:'6%'},
                         {text:'Equiv Unidad Inv',width:'12%'},
                         {text:'Costo', width:'5%',bclass:'right',hclass:'right'},
                         {text:'C&oacute;digo Discr', width:'13%'},
                         {text:'Diferencia Unid Prov', width:'5%'},
                         {text:'Diferencia Unid Inven', width:'10%'});

				myGrid.setMainHeaders(mheaders);
    			myGrid.setHeaders(headers);
	    		myGrid.setData(data);
		    	myGrid.drawInto('goDataGrid');
        	}
		}
		</script>	

    </head>

    <body bgcolor="white" onLoad="initDataGrid()">
	<jsp:include page = '/Include/GenerateHeaderYum.jsp'/>

	<table width="100%" align="center" border="0">
		<tr>
            <td class="descriptionTabla" width="16%" nowrap>
                Centro de contribuci&oacute;n:
            </td>
            <td class="descriptionTabla" width="84%">
                <%=getStore()%>&nbsp;<%=getStoreName()%>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                No. de Recepcion:
            </td>
            <td class="descriptionTabla">
                <%= msRecepId %>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <br>
               <div id="goDataGrid"></div>
            </td>
        </tr>
	</table>
    <br>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>


