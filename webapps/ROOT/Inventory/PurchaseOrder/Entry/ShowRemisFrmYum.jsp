<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##############################################################################################
# Nombre Archivo  : ShowRemisFrmYum.jsp                                                      #
# Compañia        : Yum Brands Intl
# Autor           : EZ
# Objetivo        : Mostrar el detalle de una remision
# Fecha Creacion  : 17/Feb/05
# Inc/requires    : ../Proc/PurchaseOrderLibYum.jsp
# Modificaciones  :
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria PurchaseOrderLibYum.jsp
##############################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>

<%! AbcUtils moAbcUtils = new AbcUtils(); %> 
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>   

<%
    String msOrd;
    String msRem;
    String msTarget;
    String msCSSFile;

    try{
        msTarget  = request.getParameter("target");
        msRem     = request.getParameter("remissionId");
            
        msOrd     = getRemOrderId(msRem);
        msCSSFile = "/CSS/DataGridReport"+msTarget+"Yum.css";
    }
    catch(Exception e){
        msOrd = msRem = "";
        msTarget = "Preview";
        msCSSFile = "/CSS/DataGridReportPreviewYum.css";
    }
    
    String msPresentation = "VIEWPORT";

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation(msPresentation);
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Consulta de remisi&oacute;n ",msTarget);
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }
%>

<html>
    <head>
        <title>Detalle de la remisi&oacute;n</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="<%= msCSSFile %>"/>

        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
    
        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');

        function initDataGrid(){
   			loGrid.bHeaderFix = false;
        	loGrid.isReport   = true;
	        loGrid.padding    = 4;        
            
            var laDataset     = parent.gaDataset;
            
            if(laDataset.length > 0){
                laMheaders = new Array(
                		 {text:'&nbsp;', colspan: '2', hclass:'empty'},
                         {text:'Pedido',colspan:'4', align:'center',hclass:'center'},
                         {text:'Remisi&oacute;n', colspan:'4', align:'center', hclass:'right'},
                         {text:'&nbsp;', colspan: '2', hclass:'empty'});

                laHeaders  = new Array(
                		 {text:'&nbsp;',width:'5%'},
                         {text:'Producto',width:'30%'},
                         {text:'C&oacute;digo Producto Solicitado',width:'5%',hclass:'left',bclass:'left'},
                         {text:'Cantidad Solicitada',width:'5%'},
                         {text:'Equival Unidades Inven',width:'10%'},
                         {text:'Costo',width:'5%', bclass:'right', hclass:'right'},
                         {text:'C&oacute;digo Producto Remisi&oacute;n', width:'5%'},
                         {text:'Cantidad Remisi&oacute;n', width:'5%'},
                         {text:'Equival Unidades Inv',width:'10%'},
                         {text:'Costo', width:'5%',bclass:'right',hclass:'right'},
                         {text:'Dif Precio', width:'5%'},
                         {text:'Dif Unidades Inven', width:'10%'});    

				loGrid.setMainHeaders(laMheaders);
    			loGrid.setHeaders(laHeaders);
	    		loGrid.setData(laDataset);
		    	loGrid.drawInto('goDataGrid');
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
                <%=getStoreId()%>&nbsp;<%=getStoreName()%>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                N&uacute;mero de orden:
            </td>
            <td class="descriptionTabla">
                <%= msOrd %>
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla">
                N&uacute;mero de remisi&oacute;n:
            </td>
            <td class="descriptionTabla">
                <%= msRem %>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <br>
                <div id="goDataGrid"></div>
            </td>
        </tr>
    </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>

</html>

