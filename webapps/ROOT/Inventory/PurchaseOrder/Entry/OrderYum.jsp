<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrdenYum.jsp
# Compa?ia        : Yum Brands Intl
# Autor           : AKG/IF/SCP
# Objetivo        : Contenedor principal de la pantalla de captura de ?rdenes
# Fecha Creacion  : 14/Septiembre/2004
# Inc/requires    : 
# Modificaciones  : 
# Fecha           Programador     Observaciones
# 10/oct/_  Sandra Castro    Aniado la pestaña de excepciones y todo lo relacionado con eventos en ella
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Ordenes de Compra";
    AbcUtils moAbcUtils = new AbcUtils();
    //Query para llenar el combo de Ordenes/ Remisiones de la remision
    String msFillSubRem=moAbcUtils.queryToString(getOrderRemissionQuery(),"@","|");
    //out.println(getOrderRemiQuery());
    //Query para llenar el combo de Ordenes/ Remisiones de la recepcion
    String msFillOrd=moAbcUtils.queryToString(getOrderRemiQuery(),"@","|");
%>

<html>
    <head>
        <title>Captura de Ordenes de Compra</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>
	<style type = 'text/css'>
		#divWaitGSO{
                        position:absolute;
                        visibility:hidden;
                        width:200px;
                        height:auto;
                        background-color:#6B5D9C;
                        border:4px #FFCB31 solid;
                        text-align:center;
                        color:white;
                        font-family:Arial;
                        font-size:12pt;
	                z-index:10000
                }


                #divReceptionCtrls{
                        position:absolute;
                        visibility:hidden;
                        top:65px;
                        left:14px;
                        width:auto;
                        height:auto;
                        text-align:center;
	                z-index:10000
                }

		 #divRemissionCtrls{
                        position:absolute;
                        visibility:hidden;
                        top:65px;
                        left:14px;
                        width:auto;
                        height:auto;
                        text-align:center;
	                z-index:10000
                }
	</style>
    </head>

    <div id = 'divWaitGSO' name = 'divWaitGSO'>
        <center>
            <br>Generando pedido sugerido.<br><br>Espere por favor...<br><br>
        </center>
    </div>

    <script src="/Scripts/AbcUtilsYum.js"></script>
    <script src="/Scripts/ReportUtilsYum.js"></script>

    <script>
        var gaKeys = new Array('');
        var liRowCount=0;
	var liRowCountRecep=0;
        var lsProductoCodeLst='';
	var lsProductoCodeRecepLst='';
	var msLastTab = '1';
	var gsFillSubCmb = '<%=msFillOrd%>';
	var gsFillSubCmbRem = '<%=msFillSubRem%>';
	
        function centerDivWaitGSO() {
            document.getElementById('divWaitGSO').style.left = (Math.round(getWindowWidth()/2) - 135) + 'px';
            document.getElementById('divWaitGSO').style.top = (Math.round(getWindowHeight()/2) - 80) + 'px';
        }

        function printDetail() {
            executeDetail();
        }

        function adjustPageSettings() {
            adjustContainer(60,165);
        }

        function showHideControls(){
            showHideControl('divReceptionCtrls','hidden');
	        showHideControl('divRemissionCtrls','hidden');
	        showHideControl('divRepOrdCtrls','hidden');
		showHideControl('divExcepCtrls','hidden');
        }

        function loadFirstTab() {
            showHideControls();
	}

        function validateSearch() {
        	return(true);
        }


        function setValue() {
            var lsValue = dialogWin.returnedValue;
        }

        function openTrigger(){
          openDialog('./OrderTriggerYum.jsp',480,280,'');
        }

        function validOption(psTab) {
            var lbAnswer;
            var lsValor='';
            var laMessages = new Array('','','','');

            laMessages[0]='Tiene productos en el Pedido.\nSi cambia de pestania va a perder los datos de dicha oden.\n\nDesea cambiarse de pestania y perder sus cambios?';
	    laMessages[1]=' ';
            laMessages[2]='Tiene productos en la Recepcion.\nSi cambia de pestania va a perder los datos de dicha recepcion.\n\nDesea cambiarse de pestania y perder sus cambios?';
            laMessages[3]='Tiene productos en la Excepcion.\nSi cambia de pestania va a perder los datos de dicha excepcion.\n\nDesea cambiarse de pestania y perder sus cambios?';

            try{
                lsValor=frames['ifrDetail'].document.getElementById('chkRowControl|0').value;
            }catch(e){}

            if (lsValor!='') {
               lbAnswer=confirm(laMessages[msLastTab-1]);
               if (lbAnswer){
                    liRowCount=0;
                    liRowCountRecep=0;
                    lsProductoCodeLst="";
                    lsProductoCodeRecepLst="";
                } else {
                    return;
                }
            }

            showHideControls();

            switch (psTab){
		case '1': 	
			browseDetail('OrderDetailYum.jsp','OrderYum.jsp','1');
			openTrigger();
			break;
			
		case '2':	
			resetRemissionCmbs();
			showHideControl('divRemissionCtrls','visible');
			browseDetail('RemisDetailYum.jsp','OrderYum.jsp',psTab);
			break;

		case '3':
			resetReceptionCmbs();
			showHideControl('divReceptionCtrls','visible');
			browseDetail('RecepDetailYum.jsp','OrderYum.jsp',psTab);
			break;
		
		case '4':
			resetExcepCmbs();
			showHideControl('divExcepCtrls','visible');
			browseDetail('ExcepDetailYum.jsp','OrderYum.jsp',psTab);
			break;	
		case '5':
			resetReportCmbs();
			showHideControl('divRepOrdCtrls','visible');
			browseDetail('ShowOrdersYum.jsp','OrderYum.jsp',psTab);
			break;
            }
	    msLastTab = psTab;
        }

        function resetReceptionCmbs() {
        	document.frmMaster.cmbProv.selectedIndex = 0;
		document.frmMaster.cmbSub.length=1;
	}
	
	function resetRemissionCmbs() {
	       	document.frmMaster.cmbProvRem.selectedIndex = 0;
		document.frmMaster.cmbSubRem.length=1;
	}
	function resetReportCmbs() {
       		document.frmMaster.cmbProvRep.selectedIndex = 0;
	}
	function resetExcepCmbs() {
		document.frmMaster.cmbOrdRem.selectedIndex = 0;
	}
	

    function loadSubCmb()
    {
        //EZ
        var liRows = frames['ifrDetail'].document.getElementById('tblMdx').rows.length;
        var liCurrentPrv = frames['ifrDetail'].document.frmGrid.hidCurrentProvider.value;

        var loProv = window.document.frmMaster.cmbProv;
        var loSub = window.document.frmMaster.cmbSub;
        var lsFillOrd=gsFillSubCmb;
        var laRowData=lsFillOrd.split('@');
        var liPrv=loProv.options[loProv.selectedIndex].value;
        var liLocalCounter=1;

        //EZ: para validar que solo se reciba de un proveedor
        if(liRows>1 && loProv.selectedIndex!=liCurrentPrv)
		{
		    alert('No se permite hacer la recepcion de dos proveedores al mismo tiempo.');
			loProv.selectedIndex = liCurrentPrv;

		}
		else
		{

            document.frmMaster.cmbSub.length=1;
            for(i=0;i< laRowData.length;i++)
            {
                laColData=laRowData[i].split('|');
                if (laColData[0].indexOf(liPrv)>=0)
                {               
                   loSub.options[liLocalCounter]=new Option(laColData[1],laColData[0]) ;
                   liLocalCounter=liLocalCounter+1;
                }
            }

            //Carga limites de recepcion por proveedor
            document.frmRecep.providerId.value = liPrv;
            document.frmRecep.submit();
		}

    }

	function submitReception() {
           liRowCountRecep = 0;
           lsProductoCodeRecepLst='';

  	   if (document.frmMaster.cmbProv.selectedIndex == 0) {
        	alert('Debe seleccionar un proveedor para realizar la recepcion.');
             	document.frmMaster.cmbProv.focus();
             	return(false);
  	   }

	   if (document.frmMaster.cmbSub.selectedIndex == 0) {
        	alert('Debe seleccionar una orden para realizar la recepcion.');
             	document.frmMaster.cmbSub.focus();
             	return(false);
  	   }

	   browseDetail('RecepDetailYum.jsp','OrderYum.jsp','3');
	   return(true);
        }

	function loadSubCmbRemis(){
		var loProv = window.document.frmMaster.cmbProvRem;
		var loSub = window.document.frmMaster.cmbSubRem;
		var lsFillOrd=gsFillSubCmbRem;
		var laRowData=lsFillOrd.split('@');
		var liPrv=loProv.options[loProv.selectedIndex].value;

		var liLocalCounter=1;

		document.frmMaster.cmbSubRem.length=1;
		for(i=0;i< laRowData.length;i++){
			laColData=laRowData[i].split('|');
			if (laColData[0].indexOf(liPrv)>=0){
				loSub.options[liLocalCounter]=new Option(laColData[1],laColData[0]) ;
				liLocalCounter=liLocalCounter+1;
			}
           	}
	}

	function submitRemission() {
           liRowCountRecep = 0;
           lsProductoCodeRecepLst='';

  	   if (document.frmMaster.cmbProvRem.selectedIndex == 0) {
        	alert('Debe seleccionar un proveedor para consultar la remision.');
             	document.frmMaster.cmbProvRem.focus();
             	return(false);
  	   }

	  if (document.frmMaster.cmbSubRem.selectedIndex == 0) {
        	alert('Debe seleccionar una remision a consultar.');
             	document.frmMaster.cmbSubRem.focus();
             	return(false);
  	   }

	   browseDetail('RemisDetailYum.jsp','OrderYum.jsp','2');
	   return(true);
        }

	function submitReport() {
        liRowCountRecep = 0;
        lsProductoCodeRecepLst='';

        browseDetail('ShowOrdersYum.jsp','OrderYum.jsp','5');
        return true;

    }

	function submitLimits(){
		var liRows = frames['ifrDetail'].document.getElementById('bsDg_tableBs_DateGrid_0').rows.length;
		var loOrdRem = window.document.frmMaster.cmbOrdRem;
		var liCurrentOrdRem = frames['ifrDetail'].document.frmGrid.hidCurrentOrdRem.value;

		if(liRows>1 && loOrdRem.selectedIndex!=liCurrentOrdRem)
		{
			alert('No se permite hacer la captura de la excepcion de dos documentos distintos al mismo tiempo.');
			loOrdRem.selectedIndex = liCurrentOrdRem;
			return false;
		}
		//Carga limites de recepcion por proveedor para las excepciones
            document.frmRecep.providerId.value = "PFS";
            document.frmRecep.submit();
	}

    </script>

<body onResize='adjustPageSettings();' bgcolor = 'white' OnLoad = 'loadFirstTab();'>
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>

    <form id = 'frmMaster' name = 'frmMaster' method = 'post' 
          action='OrderDetailYum.jsp' target='ifrProcess' >
    <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
    <input type='hidden' name='hidHasOrder' id='hidHasOrder' value='0'>

    <div id = 'divReceptionCtrls' name = 'divReceptionCtrls'>
        <table id = 'tblCapture' border = 0>
		    <tr>
                <td class = 'body'>
                    Proveedor:
                </td>
                <td>
                    <select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos' 
                            onChange='loadSubCmb();'>
				    <option value="-1" selected> -- Seleccione un Proveedor-- </option>
                            <% moAbcUtils.fillComboBox(out,getSuppQuery()); %>
                    </select>
                </td>
                <td class = 'body'>
                            &nbsp;
                </td>
                <td class = 'body'>
                    Pedidos/Remisiones:
                </td>
                <td>
                    <select id="cmbSub" name="cmbSub" size="1" class="combos"> 
                        <option value='-1'>-- Sin Pedido/Remision -- </option>
                    </select>
                </td>
                <td>
                    <input type = 'button' id = 'btnSubmit' name = 'btnSubmit' 
                           value = 'Mostrar' class = 'combos' onClick = 'submitReception();'>
                </td>
            </tr>
        </table>
    </div>

	<div id = 'divRemissionCtrls' name = 'divRemissionCtrls'>
   	    <table id = 'tblCapture' border = 0>
            <tr>
                <td class = 'body'>
                    Proveedor:
                </td>
				<td>
                    <select id = 'cmbProvRem' name = 'cmbProvRem' size = '1' 
                            class = 'combos' onChange='loadSubCmbRemis();'>
			        <option value="-1"selected> -- Seleccione un Proveedor-- </option>
                            <% moAbcUtils.fillComboBox(out,getSuppQuery()); %>
                    </select>
                </td>
                <td class = 'body'>
                    &nbsp;
                </td>
				<td class = 'body'>
                    Pedidos/Remisiones:
                </td>
				<td>
				    <select id = 'cmbSubRem' name = 'cmbSubRem' size = '1'  class = 'combos'>
				    <option value='-1'>-- Sin Pedido/Remision -- </option>
				    </select>
				</td>
				<td>
                    <input type = 'button' id = 'btnSubmitRem' name = 'btnSubmitRem' 
                           value = 'Mostrar' class = 'combos' onClick = 'submitRemission();'>
                </td>
            </tr>
        </table>
    </div>
            
    <div id = 'divRepOrdCtrls' name = 'divRepOrdCtrls'>
        <table width="96%" id = 'tblCapture' border="0">
		    <tr>
                <td class = 'body' width="70%"  align="right">
                     Proveedor:
                </td>
                <td width="30%">
                    <select id = 'cmbProvRep' name = 'cmbProvRep' size = '1' 
                            class = 'combos' onChange='submitReport();'>
				    <option value="-1" selected> -- Seleccione un Proveedor-- </option>
                            <% moAbcUtils.fillComboBox(out,getSuppQuery()); %>
                    </select>
                </td>

            </tr>
        </table>
    </div>
<!--Modificacion para aniadir excepciones-->
<div id = 'divExcepCtrls' name = 'divReceptionCtrls'>
	 <table width="96%" id = 'tblCapture' border="0">
		    <tr>
                <td class = 'body' width="70%"  align="right">
                     Numero de pedido:
                </td>
                <td width="30%">
                    <select id = 'cmbOrdRem' name = 'cmbOrdRem' size = '1' 
                            class = 'combos' onChange="submitLimits();">
				    <option value="-1" selected> -- Seleccione un Pedido/Remision-- </option>
                            <% moAbcUtils.fillComboBox(out,getOrdRemisQuery()); %>
                    </select>
                </td>

            </tr>
        </table>
</div>
<!--Modificacion para aniadir excepciones-->
    </form>

    <form action="RecepLimitsYum.jsp" name="frmRecep" target="ifrHelp">
        <input type="hidden" name="providerId">
    </form>
    
    <table border="0" cellspacing='0' cellpadding='0' width='96%' id='tblCourse'>
    <tr valign = 'top'>
        <td width="100%">
            <div width="100%">
                <div class='tabArea'>
                	<a class='tab' id ='1' href = 'javascript:validOption("1")'>Pedido</a>
                	<a class='tab' id ='2' href = 'javascript:validOption("2")'>Remisi&oacute;n</a>
			<a class='tab' id ='3' href = 'javascript:validOption("3")'>Recepci&oacute;n</a>
			<a class='tab' id ='4' href = 'javascript:validOption("4")'>Excepciones</a>
			<a class='tab' id ='5' href = 'javascript:validOption("5")'>Consultas</a>
                </div>
                <div class='tabMain'> 
                    <div class='tabIframeWrapper'>
                        <iframe class='tabContent' name='ifrDetail' id='ifrDetail' 
                                marginWidth='4' marginHeight='8' frameBorder='0'></iframe>
                    </div>
                </div>
            </div>
        </td>
    </tr>
    </table>
    <script> adjustPageSettings(); </script>
</body>
</html>

<%!

String getOrderRemiQuery(){
        String lsQuery=" SELECT distinct rtrim(CAST(p.provider_id AS VARCHAR))||'_'||rtrim(CAST(o.order_id AS VARCHAR)) as uno,rtrim(CAST(o.order_id AS VARCHAR))";
	lsQuery+=" FROM  op_grl_order_detail o";
        lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id";
	lsQuery+=" WHERE  o.order_id not in (SELECT DISTINCT order_id FROM op_grl_remission )";
	lsQuery+=" AND rtrim(ltrim(CAST(o.order_id AS VARCHAR))||'_'||ltrim(CAST(o.provider_id AS VARCHAR))) NOT IN ";
	lsQuery+=" (SELECT DISTINCT rtrim(ltrim(CAST(rp.order_id AS VARCHAR))||'_'||ltrim(CAST(rp.provider_id AS VARCHAR))) FROM op_grl_reception rp)";
	lsQuery+=" UNION " ;
	lsQuery+=" SELECT trim(p.provider_id)||'_'||rtrim(CAST(r.order_id AS VARCHAR))||'_'||rtrim(CAST(r.remission_id AS VARCHAR)) as uno,";
	lsQuery+=" rtrim(CAST(r.order_id AS VARCHAR))||'/'||rtrim(CAST(r.remission_id AS VARCHAR))";
	lsQuery+=" FROM op_grl_cat_provider p";
	lsQuery+=" INNER JOIN op_grl_remission r ON r.provider_id = p.provider_id";
	lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception re WHERE re.store_id = r.store_id AND re.remission_id = r.remission_id)";
	lsQuery+= "ORDER BY uno DESC";
	return(lsQuery);
}

String getOrderRemissionQuery(){
	String lsQuery = "SELECT trim(p.provider_id)||'_'||rtrim(CAST(r.order_id AS VARCHAR))||'_'||rtrim(CAST(r.remission_id AS VARCHAR)),";
	lsQuery+=" rtrim(CAST(r.order_id AS VARCHAR))||'/'||rtrim(CAST(r.remission_id AS VARCHAR))";
	lsQuery+=" FROM op_grl_cat_provider p";
	lsQuery+=" INNER JOIN op_grl_remission r ON r.provider_id = p.provider_id";
	lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception re WHERE re.store_id = r.store_id AND re.remission_id = r.remission_id)";
	return(lsQuery);
}

    String getSuppQuery() {
        String lsQuery = "";
        lsQuery+= "SELECT ltrim(rtrim(provider_id)),name";
        lsQuery+= " FROM op_grl_cat_provider ";
	lsQuery+= " WHERE active_flag = 't' ";
        lsQuery+= " order by name  asc ";
	return(lsQuery);
  }

String getOrdRemisQuery(){
	String lsQuery = "";
	String lsProviderId="PFS";
	int liInterval = 72;

	lsQuery += " SELECT document_num, document_num "+
		"FROM op_grl_reception " +
		" WHERE rtrim(ltrim(document_num)) NOT IN(SELECT substr(document_num,1,6) FROM op_grl_exception) " +
		" AND provider_id = '" + lsProviderId +"'" +
		" AND date_id > (SELECT timestamp 'now()' - interval '" + liInterval +" hours')";
	return(lsQuery);
}
%>

