<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : RecepDetailYum.jsp
# Compa�a        : Yum Brands Intl
# Autor           : akg
# Objetivo        : Detalle de Recepciones
# Fecha Creacion  : 10/Nov/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="java.math.*" %>
<%@page import="generals.*" %>

<%!
    AplicationsV2 logApps = new AplicationsV2();
%>


<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation = request.getParameter("hidOperation");
    String msPrv="";
    String msParam="";
    String msOrd="";
    String msRem="";
    String msRecep="";
    String msOrigen="";

try{
    AbcUtils moAbcUtils = new AbcUtils();
    msOrigen = request.getParameter("hidOrigen");
    if(msOrigen.equals("diff")){
        msRecep=request.getParameter("msStepRecep1");
    }else{
        msRecep=request.getParameter("msStepRecep");
    }
    int liTmp=msRecep.length();
    msPrv=moAbcUtils.queryToString("SELECT provider_id from op_grl_step_reception WHERE reception_id="+msRecep+"","","");
    //msOrd=moAbcUtils.queryToString("SELECT order_id from op_grl_step_reception WHERE reception_id="+msRecep+" AND order_id > 0","","");
    //msOrd=moAbcUtils.queryToString("SELECT order_id from op_grl_step_reception WHERE reception_id="+msRecep+" AND order_id >= 0","","");
    msOrd=moAbcUtils.queryToString("SELECT order_id from op_grl_step_reception WHERE reception_id="+msRecep+"","","");
    msRem=moAbcUtils.queryToString("SELECT remission_id from op_grl_step_reception WHERE reception_id="+msRecep+" AND remission_id > '0'","","");
}catch(Exception moExpetion){msRecep="";}
try{
    if (msRecep.equals("")){
        if (!request.getParameterValues("cmbProv").equals(null)){
            msPrv=request.getParameter("cmbProv");
            if(!request.getParameterValues("cmbSub").equals(null))
                msParam=request.getParameter("cmbSub");
logApps.writeInfo("msRecep:"+msRecep+"| cmbProv o msPrv:"+msPrv+"| cmbSub o msParam:"+msParam+"|");
            if (msParam.indexOf("-1_")<0){
                String maParam[]=msParam.split("_");
                msOrd=maParam[1];
                if ((maParam.length)>2)
                    msRem =maParam[2];
            }
        }else{
            msParam=request.getParameter("hidCustom1");
            String maParam[]=msParam.split("|");
            msPrv=maParam[0];
            if (maParam[1].indexOf("-1_")<0) msOrd=maParam[1];
            if (maParam[1].indexOf("-1_")<0) msRem=maParam[2];
logApps.writeInfo("Entro en el segundo");
        }
    }
logApps.writeInfo("msParam:"+msParam+"| msOrd:"+msOrd+"| msPrv:"+msPrv+"|");
}catch(Exception e){}

/**************************************************************************************************************/
String lsResponsible="";
try{
    lsResponsible=request.getParameter("hidTest");
    if (lsResponsible.equals("")) lsResponsible=lsResponsible;
}catch(Exception moException){lsResponsible="";}


    if (msOperation==null) return;
    String msMasterKeys = msPrv+'|'+msOrd+'|'+msRem;

    AbcCatalog moAbcCatalog = new AbcCatalog(out,request);
    moAbcCatalog.setMasterKeys(msMasterKeys);
    String msOrder="0";
    String msStore="0";
    String msProv="";
    msProv=request.getParameter("cmbProv");
    moAbcCatalog.setQuery(getMainQuery(msStore.trim(),msPrv.trim(),msOrd.trim(),msRem.trim(),msRecep.trim()));

    moAbcCatalog.initParamsLength(12);
    moAbcCatalog.setFieldNames(new String[]{"extra_fields","sequence","provider_product_code","product_name","received_quantity","recapture","difference_id","forwarding_id","unit_inventory","unit_price","subtotal","received_ori"});
    moAbcCatalog.setTableTitles(new String[]{"","Orden","C&oacute;digo<br>Producto","Producto","CAPTURA<br>CANTIDAD<br>RECIBIDA","RECAPTURA<br>CANTIDAD<br>RECIBIDA","C&oacute;digo<br>Discrepancia","Reenvio","Unidad<br>Inv","Precio<br>Unidad","Subtotal","&nbsp;"});
    moAbcCatalog.setInsertMode(new boolean[]{false,false,false,false,true,true,true,true,false,false,false,false});
    moAbcCatalog.setSearchMode(new String[]{"","","","","","","","","","","",""});
    moAbcCatalog.setEditMode(new boolean[]{false,false,false,false,true,true,true,true,false,false,false,false});
    moAbcCatalog.setUpdateMode(new boolean[]{false,false,false,false,true,true,true,true,false,false,false,false});
    moAbcCatalog.setBlurMode(new boolean[]{false,false,false,false,true,true,false,false,false,false,false,false});
    moAbcCatalog.setFocusMode(new boolean[]{false,false,false,false,true,true,false,false,false,false,false,false});
    moAbcCatalog.setColorMode(new String[]{"","","#66CCFF","#66CCFF","#CCFFFF","#CCFFFF","#CCFFFF","#CCFFFF","#66CCFF","#66CCFF","#66CCFF","#66CCFF"});
    moAbcCatalog.setTypeMode(new String[]{"hidden","text","text","text","text","text","select","select","text","text","check","hidden"});
    moAbcCatalog.setFieldSizes(new String[]{"15","3","13","25","20","20","15","15","8","8","10","20"});

    int case_id = 1;
    if(msOrd.equals("") && msRem.equals("")){
        case_id = 2;
    }else if(msOrd.equals("")||msOrd.equals("0") && !msRem.equals("")){
        case_id = 3;
    }else if(!msOrd.equals("") && !msOrd.equals("0") && msRem.equals("")){
        case_id = 4;
    }else{
        case_id = 5;
    }
    logApps.writeInfo("Case:"+case_id); 
    String msQueryDisc = "SELECT cd.difference_id, d.dif_desc FROM op_grl_cat_config_difference cd";
    msQueryDisc += " INNER JOIN op_grl_cat_difference d ON d.difference_id = cd.difference_id WHERE cd.case_id="+ case_id;
    msQueryDisc += " AND active_flag = 'Y' ORDER BY cd.sort_seq";

    String msQueryForw = "SELECT forwarding_id, forw_desc FROM op_grl_cat_forwarding ORDER BY 1 DESC";

    moAbcCatalog.setSourceMode(new String[]{"","","","","","",msQueryDisc,msQueryForw,"","","",""});
    moAbcCatalog.setOperations(new boolean[]{true,false,true,false});

    moAbcCatalog.setSrcDialogWidth(new String[]{"700","700","700","700","700","700","700","700","700","700","700","700"});
    moAbcCatalog.setSrcDialogHeight(new String[]{"450","450","450","450","450","450","450","450","450","450","450","450"});
    moAbcCatalog.setOnInsertCustomAction(true);
    moAbcCatalog.setInsertButtonText("Agregar Producto");

    /*Valores de Orden y remision*/
    if (msOperation.equals("U"))
    {
        msOrd="-1";
        msRem="-1";
        msPrv=request.getParameter("hidCustom1");
        msParam=request.getParameter("hidCustom2");
        
        if(!msParam.equals("_"))
        {
            String maParam[]=msParam.split("_");
            msOrd=maParam[0];
            if ((maParam.length)>1)
               msRem =maParam[1];
        }
        updateTables(msMasterKeys,request,out,msRem,msOrd);
    }

%>

<html>
    <head>
        <div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
        <title>Detalle de Orden</title>
        <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
    </head>

    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>
    <script src="/Scripts/CalendarYum.js"></script>
    <script src="/Scripts/HtmlUtilsYum.js"></script>
    <script src="/Scripts/StringUtilsYum.js"></script>
    <script>
        var gaKeys = new Array('txtNumEmp');
        var unit1,unit2,unit3,unit4="";
        var qty="";

        function adjustPageSettings() 
        {
            adjustContainer(60,260);
        }

        function addSeparators(nStr, inD, outD, sep)
        {
                    nStr += '';
                    var dpos = nStr.indexOf(inD);
                    var nStrEnd = '';
                    if (dpos != -1) {
                            nStrEnd = outD + nStr.substring(dpos + 1, nStr.length);
                            nStr = nStr.substring(0, dpos);
                    }
                    var rgx = /(\d+)(\d{3})/;
                    while (rgx.test(nStr)) {
                            nStr = nStr.replace(rgx, '$1' + sep + '$2');
                    }
                    return nStr + nStrEnd.substring(nStrEnd.indexOf('.'),3);
        }

        function gridCustomSettings()
        {
            <%= "var liRem =\"" + (msRem.equals("")?"0":msRem)+ "\";" %>
            objFrm=document.getElementById("frmGrid");
            objTable = document.getElementById("tblMdx");
            for(i=0;i<objTable.rows.length-1; i++)
            {

                document.getElementById('chkRowControl|'+i).checked=true;
                document.getElementById('chkRowControl|'+i).value='2';

                if(liRem == 0)
                        document.getElementById('sequence|'+i).value= i + 1 ;
                        document.getElementById('unit_price|'+i).value=addSeparators(document.getElementById('unit_price|'+i).value,'.', '.', ',');
            }
        }

        function setReturnedCustomValues(psAllData){
            var lsControlDesc="extra_fields|sequence|provider_product_code|product_name|received_quantity|recapture|difference_id|forwarding_id|unit_inventory|unit_price|subtotal|received_ori";
            var laControls=lsControlDesc.split('|');
            var liNumRows = objTable.rows.length;
            var laRecords=psAllData.split('&');
            var laIndivRecord;
            if(psAllData.indexOf('&')<0){
                psAllData = psAllData.substring(0,psAllData.indexOf('|')+1)+(liNumRows)+"|"+psAllData.substring(psAllData.indexOf('|')+1, psAllData.length);
                laRecords=psAllData.split('&');
            }else{
                for(liCount=0; liCount <laRecords.length;liCount++){
                    laRecords[liCount]= laRecords[liCount].substring(0,laRecords[liCount].indexOf('|')+1) + (liNumRows) + "|" + laRecords[liCount].substring(laRecords[liCount].indexOf('|')+1, laRecords[liCount].length) ;
                    liNumRows++;
                }
            }
            var lsProdCode="";
            var lsProvider=parent.document.frmMaster.cmbProv.value;
            parent.lsProductoCodeRecepLst="";
            objFrm=document.getElementById("frmGrid");
            objTable = document.getElementById("tblMdx");
            for(i=0;i<objTable.rows.length-1; i++){
                   objInput1 = document.getElementById('provider_product_code|' + i);
                   if (objInput1!=null){
                        parent.lsProductoCodeRecepLst=parent.lsProductoCodeRecepLst+','+objInput1.value+lsProvider;
                   }
            }
            if (objTable.rows.length>1){
                    parent.liRowCountRecep=objTable.rows.length-1;
            }else{
                    parent.liRowCountRecep=0;
                    parent.lsProductoCodeRecepLst="";
            }
            for (var i=0;i< laRecords.length;i++){
                laIndivRecord=laRecords[i].split('|');
                if (parent.lsProductoCodeRecepLst.indexOf(laIndivRecord[2]+lsProvider)<0){
                    f_addRow(false);
                    parent.liRowCountRecep=parent.liRowCountRecep+1;
                    for (var x=0;x<=laIndivRecord.length-1;x++){
                    document.getElementById(laControls[x]+'|'+(parent.liRowCountRecep-1)).value=laIndivRecord[x];
                        if (laControls[x]=='provider_product_code')
                        parent.lsProductoCodeRecepLst=parent.lsProductoCodeRecepLst+','+laIndivRecord[x]+lsProvider;
                    }
                }
                <%String lsValueSelected = getValueDiff();%>
                <%= "var liRem =" + lsValueSelected + ";" %>
                document.getElementById('difference_id|' + (objTable.rows.length - 2)).selectedIndex = liRem;
                document.getElementById('forwarding_id|' + (objTable.rows.length - 2)).selectedIndex = "0";
            }
            if(objTable.rows.length > 1){
                document.frmGrid.hidCurrentProvider.value = parent.document.frmMaster.cmbProv.selectedIndex;
            }    
        }

        //EZ: para validar que solo se pueda hacer recepcion de un proveedor
        function createCurrentProvider()
        {
            var lsProv = parent.document.frmMaster.cmbProv.selectedIndex;
            addHidden(document.frmGrid, "hidCurrentProvider", lsProv);
        }

        function onFocusCustomControl(poControl) 
        {
            frmFocusAction(poControl);
        }

        function onInsertAction() 
        {
            var lsPrv=parent.document.frmMaster.cmbProv.value;
            var lsSub=parent.document.frmMaster.cmbSub.value;

            if (parent.document.frmMaster.cmbProv.selectedIndex==0)
            {
                alert('Debe seleccionar un proveedor para capturar una recepcion.');

            }
            else
            {
                if (parent.document.frmMaster.cmbSub.selectedIndex==0)
                    openDialog("SearchProductsYum.jsp?psStore="+<%=getStore()%>+"&psProv="+lsPrv+"&psSub="+lsSub+"&psSource=N&psRecep=1",1000,650,setReturnedData);
                else
                    openDialog("SearchProductsYum.jsp?psStore="+<%=getStore()%>+"&psProv="+lsPrv+"&psSub="+lsSub+"&psSource=R&psRecep=1",1000,650,setReturnedData);
            }

        }

        function validateGridCustom()
        {
            window.document.frmGrid.hidCustom1.value='<%=msProv%>';
            window.document.frmGrid.hidCustom2.value='<%=msOrd+'_'+msRem%>';
            objTable = document.getElementById("tblMdx");
            var lsProvider=parent.document.frmMaster.cmbProv.value;
	        var liCount=0;
	        var liTotQty=0;

            if (objTable.rows.length>1)
            {
                for(i=0;i<objTable.rows.length-1; i++)
                {
                    var lsQtyReceived = document.getElementById('received_quantity|'+i).value;
                    var isNegative    = (lsQtyReceived.search("-") != -1)?true:false;
                    lsQtyReceived = trim(lsQtyReceived);
                    lsQtyReceived = lsQtyReceived.substring(0,lsQtyReceived.indexOf(" "));

                    var lsQtyRequired = document.getElementById('received_ori|'+i).value;
                    var lsDiscrepancy = parseInt(document.getElementById('difference_id|'+i).value);
                    var lsForwarding  = parseInt(document.getElementById('forwarding_id|'+i).value);
                    var lsQtyRecapture = document.getElementById('recapture|'+i).value;
                    var lsPrvCode = document.getElementById('provider_product_code|'+i).value;
                    /*
                         EZ: fix, se valida que no se ingresen valores negativos
                    */
                    if(document.getElementById('chkRowControl|'+i).checked)
                    {
                        if(( lsProvider == "325" || lsProvider == "234" ) && ( lsPrvCode == "3020" || lsPrvCode == "3022" )){
                            liTotQty = liTotQty + lsQtyReceived/26;
                        }
                        if(( lsProvider == "325" || lsProvider == "234" ) && ( lsPrvCode == "YU17" || lsPrvCode == "YU18" )){
                            liCount++;
                        }
                        if(( lsProvider == "325" || lsProvider == "234" ) && lsPrvCode == "YU17" && Math.ceil(lsQtyReceived)  ==  Math.ceil(liTotQty) && liTotQty > 0 ){
                            liCount++;
                        }
                        if(( lsProvider == "325" || lsProvider == "234" ) && lsPrvCode == "YU18" && Math.ceil(lsQtyReceived)  ==  Math.ceil(liTotQty) && liTotQty > 0 ){
                            liCount++;
                        }
                        //if( lsQtyReceived == "0.00" || lsQtyReceived == "0" )
                        /*if(lsDiscrepancy == 0 && (lsQtyReceived == "0.00" || lsQtyReceived == "0"))
                        {
                            alert("Es necesario capturar el codigo de discrepancia cuando la cantidad recibida sea cero");
                            document.getElementById('difference_id|'+i).focus();
                            return(false);
                        }
                        else
                        {*/
                            if(isNegative)
                            {
                                alert("No se pueden ingresar valores negativos");
                                document.getElementById('received_quantity|'+i).focus();
                                return(false);
                            }
                        //}
                        if(lsDiscrepancy != 0 && (lsQtyReceived == "0.00" || lsQtyReceived == "0") && lsForwarding == 3)
                        {
                            alert("Es necesario capturar si se desea o no el reenvio");
                            document.getElementById('forwarding_id|'+i).focus();
                            return(false);
                        }
                        if(lsQtyRecapture == ''){
                        	alert("Es necesario recapturar la cantidad recibida");
                        	document.getElementById('recapture|'+i).focus();
                            return(false);
                        }else{
                        	lsQtyRecapture=lsQtyRecapture.substring(0, lsQtyRecapture.indexOf(" "));
                        	lfQtyReceived=lsQtyReceived.substring(0, lsQtyRecapture.indexOf(" "));
                        	if(lsQtyReceived != lsQtyRecapture){
                        		//alert("lfQtyReceived: ["+lsQtyReceived+"], lsQtyRecapture: [" + lsQtyRecapture + "]");
                        		if (lsQtyRecapture == "0" || lsQtyRecapture == "0.0" || lsQtyRecapture == "0.00" ){
                            		alert("Es necesario recapturar la cantidad recibida");
                                	document.getElementById('recapture|'+i).focus();
                                    return(false);
                            	}
                        	}
                        }
                    }

                    if(lsQtyRequired == "N/E"){
                        lsQtyRequired=0;
                    }

                    lsQtyReceived = parseFloat(lsQtyReceived);
                    lsQtyRequired = parseFloat(lsQtyRequired);
                    /*var lsComp = lsQtyRequired - lsQtyReceived;

                    /*if((document.getElementById('chkRowControl|'+i).checked) && (document.getElementById('chkRowControl|'+i).value) == 2){
                        if(lsComp !=0 && lsDiscrepancy == 0){
                            alert("Es necesario capturar el codigo de discrepancia cuando la cantidad recibida cambie");
                            focusElement('difference_id|'+i);
                            return(false);
                        }
                        if(lsComp !=0 && lsForwarding == 3){
                            alert("Es necesario seleccionar si se desea reenvio cuando el codigo de discrepancia sea diferente de Ninguno");
                            focusElement('forwarding_id|'+i);
                            return(false);
                        }
                    }*/
                } //for
		        //alert("Contador:"+liCount+" Total tapas y canastillas:"+liTotQty);
	            if( ( (lsProvider == "325" || lsProvider == "234")  && liCount  == "4" ) || ( (lsProvider != "325" && lsProvider != "234") || ( lsPrvCode == "2067" ) ) ){
                    return(true);
	            }else{

                    alert("Debe capturar "+Math.ceil(liTotQty)+" Tapas y "+Math.ceil(liTotQty)+" canastillas");
		        }
            }
        }

        function frmFocusAction(poControl)
        {
            var lsCtlName=poControl.name;
            var liPos=lsCtlName.substring(lsCtlName.indexOf("|")+1,lsCtlName.length);
            var lsCtlValue=poControl.value;
            var lsCtlValue1=document.getElementById('received_quantity|'+liPos).value;
            var lsCtlValue2=document.getElementById('unit_inventory|'+liPos).value;

            qty=lsCtlValue.substring(0,lsCtlValue.indexOf(" "));
            poControl.value=qty;
        }

        function onBlurCustomControl(poControl)
        {
                frmChgAction(poControl);
        }

        function frmChgAction(poControl) {
            var lsCtlName=poControl.name;
            var liPos=lsCtlName.substring(lsCtlName.indexOf("|")+1,lsCtlName.length);
            var lrFactorConv;
            var lsExtraFields=document.getElementById('extra_fields|'+liPos).value;

            var laExtraFields=lsExtraFields.split('_');
            var lsField1,lsField2;
            
            if (lsCtlName.indexOf("recapture")==0){
            	var lsQuantity = document.getElementById('received_quantity|'+liPos).value;
            	var lsQtyRecapture = document.getElementById('recapture|'+liPos).value;

            	if ( lsQtyRecapture == "" ){
            		alert("Por favor recaptura la cantidad recibida");
            		document.getElementById('recapture|'+liPos).focus();
            		return (false);
            	}
            	
            	if (isNaN(lsQtyRecapture.replace(",",""))){
            		alert("El campo Cantidad Recibida debe ser numerico.");
            		document.getElementById('recapture|'+liPos).value='';
            		document.getElementById('recapture|'+liPos).focus();
            		return (false);
            	}
            	lsField1=poControl.value;
            	document.getElementById('recapture|'+liPos).value=lsField1+'  '+laExtraFields[1];
            	var lfQuantity = parseFloat(lsQuantity.substring(0, lsQuantity.indexOf(" ")));
            	var lfQtyRecapture = parseFloat(lsQtyRecapture);
            	
            	if (lfQuantity != lfQtyRecapture){
            		alert("La cantidad recibida y la recaptura de la cantidad no coinciden, por favor valida que los valores sean correctos");
            		document.getElementById('received_quantity|'+liPos).focus();
            		return false;
            	}
            }

            if (lsCtlName.indexOf("received_quantity")==0) {
                liPos=lsCtlName.substr(lsCtlName.indexOf("|")+1,lsCtlName.length);
                lrFactorConv=laExtraFields[0];
                lsFieldCompare=document.getElementById('received_quantity|'+liPos).value;

                if (isNaN(lsFieldCompare.replace(",",""))) {
                    alert('El campo Cantidad Requerida  debe ser un numerico.');
                    document.getElementById('received_quantity|'+liPos).value='';
                    document.getElementById('received_quantity|'+liPos).focus();
                } else {
                    lsField1=poControl.value;

                    //Ez: limit reception
                    var lfQuantity   = parseFloat(lsField1.replace(",",""));
                    var lsProviderId = parent.document.frmMaster.cmbProv.value;
                    var lsProductId  = trim(document.getElementById('provider_product_code|'+liPos).value);
                    //var lfLimit      = top.ifrHelp.getLimitReception(lsProductId);
                    var lfLimit      = parent.parent.ifrHelp.getLimitReception(lsProductId);

                    //Si no tiene limite, o bien, si es un limite valido pasa.

                    if( lfQuantity > lfLimit && lfLimit != 0 ){
                        var lsMsg = 'Su limite m&aacute;ximo de este producto es de '+lfLimit+' ' + laExtraFields[1] + ' de '+
                                    document.getElementById('product_name|'+liPos).value + '. ' + ' esta seguro que desea hacerlo ' +
                                    'Verifique la cantidad que esta ingresando. ';

                        alert(lsMsg);
                        //document.getElementById('received_quantity|'+liPos).value='0 '+laExtraFields[1];
                       
                        //unfocusElement(goCurrentCtrl.id);
                        //focusElement(goLastCtrl.id);
                 	}

	                 document.getElementById('unit_inventory|'+liPos).value=lfQuantity*lrFactorConv;
	                 //document.getElementById('unit_inventory|'+liPos).value=lsField1.replace(",","")*lrFactorConv;
	                 document.getElementById('subtotal|'+liPos).value=lsField1.replace(",","")*document.getElementById('unit_price|'+liPos).value.replace(",","");
	                 document.getElementById('received_quantity|'+liPos).value=addSeparators(document.getElementById('received_quantity|'+liPos).value,'.','.',',');
	                 document.getElementById('unit_inventory|'+liPos).value=addSeparators(document.getElementById('unit_inventory|'+liPos).value,'.','.',','); 
	                 document.getElementById('unit_price|'+liPos).value=addSeparators(document.getElementById('unit_price|'+liPos).value,'.','.',',');
	                 document.getElementById('subtotal|'+liPos).value=addSeparators(document.getElementById('subtotal|'+liPos).value,'.','.',',');
	
	                 // Se agregan unidades
	                 document.getElementById('unit_inventory|'+liPos).value=document.getElementById('unit_inventory|'+liPos).value+' '+laExtraFields[2];
	                 document.getElementById('received_quantity|'+liPos).value=lsField1+'  '+laExtraFields[1];
               }
               document.getElementById('recapture|'+liPos).focus();
            }
        }
            
        function handleKeyEvents(poEvent, objUsed) {
        	goLastKeyEvent = poEvent;

        	var lsElement = objUsed.id;
        	liRowId = parseInt(lsElement.substring(lsElement.indexOf("|") + 1));
        	lsElement = lsElement.substr(0, lsElement.indexOf("|"));

        	liKeyCode = getKeyCode(poEvent);
        	liNumRows = getNumRows();
        	// alert("Tecla presionada: [" + poEvent.which + "], [" + liKeyCode + "]");

        	if (liKeyCode == 13 || liKeyCode == 40) {// <enter> o flecha hacia abajo
        		if (liNumRows > 1) { // Si hay mas de dos filas
        			// if (liRowId < (liNumRows - 1)) {
        				
   					if ((liNumRows - 1) == liRowId) {
   						lsCurrentElement = lsElement == "recapture" ? "difference_id|0"
   								: "recapture|" + liRowId;
   					} else {
   						if(lsElement == "received_quantity"){
   							lsCurrentElement = 'recapture|' + (liRowId);
   						}else if(lsElement == "recapture"){
   							lsCurrentElement = 'received_quantity|' + (liRowId + 1);
   						}
   					}

        			lsPreviousElement = lsElement.concat("|", liRowId);

        			// El elemento seleccionado
        			goCurrentCtrl = document.getElementById(lsCurrentElement);
        			// El elemento anterior seleccionado
        			goLastCtrl = document.getElementById(lsPreviousElement);

        			focusElement(lsCurrentElement);
        		}else{
        			lsCurrentElement = lsElement == "recapture" ? "difference_id|0"
								: "recapture|" + liRowId;
        			focusElement(lsCurrentElement);
        		}
        	}
        	if (liKeyCode == 38) { // Fecha hacia arriba
        		if (liNumRows > 1) { // Si hay mas de dos filas
        			if (liRowId > 0) {
        				lsCurrentElement = lsElement.concat("|", liRowId - 1);
        				lsPreviousElement = lsElement.concat("|", liRowId);

        				goCurrentCtrl = document.getElementById(lsCurrentElement);
        				goLastCtrl = document.getElementById(lsPreviousElement);

        				focusElement(lsCurrentElement);
        			}
        		}
        	}

        	return (liKeyCode);
        }
        
        </script>

    <body  bgcolor='white' onsubmit(); onLoad="createCurrentProvider()">
        <%
            moAbcCatalog.generatePage();
        %>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!

   String  getNumRecep(){
      AbcUtils moAbcUtils = new AbcUtils();
      String lsOrder="";
      lsOrder=moAbcUtils.queryToString("SELECT reception_id from op_grl_reception WHERE store_id="+getStore()+" ORDER BY reception_id DESC limit 1","","");

      if (lsOrder.equals(""))
         lsOrder="10000";
      else{
          int liOrder=Integer.parseInt(lsOrder)+1;
          lsOrder=String.valueOf(liOrder);
      }
     //DEBUG
    //logApps.writeInfo("order="+lsOrder);
      return(lsOrder);
   }

   String getStore(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_id from ss_cat_store ","","");


        return(lsStore);
   }

   String getDateTime(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsDate="";
	String lsQry="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance();
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay); 
        lsDate=lsDF.format(lsC1.getTime());
        //logApps.writeInfo(lsDate);
        lsQry = "SELECT DATE'"+lsDate+"' = date_limit FROM op_grl_set_date";
        if(moAbcUtils.queryToString(lsQry).equals("t")){// Si la es la fecha de tolerancia
	    lsQry = "SELECT TIMESTAMP'"+lsDate+"' < date_id FROM op_grl_set_date";
            if(moAbcUtils.queryToString(lsQry).equals("t")){// Si la hora es menor a la hora tolerada
	        lsQry = "SELECT to_char((TIMESTAMP'"+lsDate+"' - time_less), 'YYYY-MM-DD HH24:MI:SS') FROM op_grl_set_date";
                lsDate=moAbcUtils.queryToString(lsQry);
	    }
        }
	logApps.writeInfo("QRY_RecepDetailYum.jsp:"+lsDate);
        return(lsDate);
    }

    void updateTables(String psMasterKeys, HttpServletRequest poRequestHandler, JspWriter poOutputHandler, String psRem,String psOrd) {
        AbcUtils moAbcUtils = new AbcUtils();
        int liFlag = 0;
        double ldDiff = 0.0, ldReqQty = 0.0, ldRecQty = 0.0;
        Enumeration loParameters = poRequestHandler.getParameterNames();
        String msRem=psRem;
        String msOrd=psOrd;
        //String msPrv=psPrv;
        String lsParamName;
        String lsInsertQuery="";
        String lsFieldRecep = getNumRecep();
        String lsFieldStore= getStore();
        String lsFieldDate= getDateTime();
        String lsReqOrd, lsRecCode, lsReqCode;
        String [][] laReq,laQty;
	    Integer liTotQty = 0;

        try {
            String lsTmp="";
            String lsParam=poRequestHandler.getParameter("extra_fields|0");
            //poOutputHandler.println(lsParam);
            String laFieldExtra[]=lsParam.split("_");
            String lsFieldProv=laFieldExtra[5];
            String lsDeleteQuery = "DELETE from  op_grl_step_reception_detail WHERE reception_id=? ";
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{lsFieldRecep});

            lsDeleteQuery = "DELETE from  op_grl_step_reception WHERE reception_id=? ";
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{lsFieldRecep});

            lsDeleteQuery = "DELETE from  op_grl_step_difference WHERE reception_id=? ";
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{lsFieldRecep});

            if(lsFieldProv.trim().equals("PFS")){
                lsReqOrd = "SELECT od.provider_product_code as order_product,ltrim(to_char(od.prv_required_quantity, '9999990.99')) as qty_required FROM op_grl_order_detail od INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code AND p.provider_id = od.provider_id WHERE od.order_id = "+psOrd+"";
                //logApps.writeInfo("lsFieldProv:"+lsFieldProv+" lsReqOrd:"+lsReqOrd);
                laReq = moAbcUtils.queryToMatrix(lsReqOrd);
            }else{
                laReq = new String[0][0];
            }
            while(loParameters.hasMoreElements()) {
                lsParamName=(String)loParameters.nextElement();
                if (lsParamName.indexOf("chkRowControl")!=-1) {
                    String lsAction = poRequestHandler.getParameter(lsParamName);
                    String lsParamNumber = lsParamName.substring(lsParamName.indexOf('|')+1);
                    String lsOperation = "";
                    String lsField0 = poRequestHandler.getParameter("provider_product_code|" + lsParamNumber);
                    String lsField1 = poRequestHandler.getParameter("product_name|" + lsParamNumber);
                    String lsField2 = poRequestHandler.getParameter("received_quantity|" + lsParamNumber);
                    String lsField3 = poRequestHandler.getParameter("difference_id|" + lsParamNumber).replaceAll(",","");
                    String lsField4 = poRequestHandler.getParameter("forwarding_id|" + lsParamNumber).replaceAll(",","");
                    String lsField5 = poRequestHandler.getParameter("unit_inventory|" + lsParamNumber).replaceAll(",","");
                    String lsField6 = poRequestHandler.getParameter("unit_price|" + lsParamNumber).replaceAll(",","");
                    String lsField7 = poRequestHandler.getParameter("subtotal|" + lsParamNumber).replaceAll(",","");
                    String lsField8 = moAbcUtils.queryToString("SELECT CAST(document_type_id as varchar) from op_grl_cat_provider WHERE provider_id='"+lsFieldProv+"'","","");
                    String lsField9 = poRequestHandler.getParameter("sequence|" + lsParamNumber).replaceAll(",","");
                    /*if(lsFieldProv.equals("325") && (lsField0.equals("3022") || lsField0.equals("3020"))){
                        liTotQty = liTotQty + Integer.parseInt(lsField2.split(" ")[0]);
                        logApps.writeInfo("lsField2=Qty["+lsField2+"]  lsField0=prv_code["+lsField0+"] lsParamNumber["+lsParamNumber+"] liTotQty "+liTotQty);
		            }
                    if(lsFieldProv.equals("325") && lsField0.equals("YU17") && lsField0.equals("YU18")){
                        
		            }*/
                    String lsFieldDummy ="";
                    int  liFieldDummy =-1;
                    lsField2=lsField2.replaceAll(",","").substring(0,lsField2.indexOf(" "));
                    lsTmp=laFieldExtra[7];

                    if (lsAction.equals("2") || lsAction.equals("1")) {
                        if (liFlag==0){
                            if (lsTmp.indexOf("R")>=0)
                                lsInsertQuery = "INSERT INTO op_grl_step_reception (reception_id,store_id,document_num,document_type_id, remission_id,order_id,date_id,provider_id,report_num) VALUES("+lsFieldRecep.trim()+","+lsFieldStore.trim()+",'"+lsFieldDummy+"',"+lsField8+",'"+laFieldExtra[6]+"',"+psOrd+","+"to_timestamp('"+lsFieldDate+"','YYYY-MM-DD HH24:MI:SS'),'"+lsFieldProv.trim()+"','"+lsFieldDummy+"') ";
                            else
                                lsInsertQuery = "INSERT INTO op_grl_step_reception (reception_id,store_id,document_num,document_type_id, remission_id,order_id,date_id,provider_id,report_num) VALUES("+lsFieldRecep.trim()+","+lsFieldStore.trim()+",'"+lsFieldDummy+"',"+lsField8+",'"+liFieldDummy+"',"+psOrd+","+"to_timestamp('"+lsFieldDate+"','YYYY-MM-DD HH24:MI:SS'),'"+lsFieldProv.trim()+"','"+lsFieldDummy+"') ";
    //DEBUG
    logApps.writeInfo("QUERY:" + lsInsertQuery);
    //logApps.writeInfo("psRem:" + psRem + " psOrd: " + psOrd);
                            moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{});
                            liFlag=1;
    //DEBUG
    //logApps.writeInfo("\nRecepDetailYum(d).jsp");
    //logApps.writeInfo(lsInsertQuery);
                        }
/****************************INICIA CAMBIO PARA FORZAR EL CAMBIO DE DISCREPANCIA***********************************/
                        if (lsTmp.indexOf("R")>=0 && lsFieldProv.trim().equals("PFS")){
                            if(laReq.length > 1){
                                for(int i=0;i<laReq.length;i++){
                                    lsReqCode = lsField0.trim();
                                    lsRecCode = laReq[i][0].trim();
                                    if(lsReqCode.equals(lsRecCode)){ //El mismo provider_product_code
                                        ldReqQty = Float.parseFloat(laReq[i][1]); 
                                        ldRecQty = Float.parseFloat(lsField2); 
                                        ldDiff = ldReqQty-ldRecQty;
                                        if( ldDiff > 0.0 && lsField3.trim().equals("0") ){ // Negado
    logApps.writeInfo("lsFieldProv:"+lsFieldProv+" lsField2:"+ldRecQty+"| ldReqQty:"+ldReqQty+" ldDiff:"+ldDiff);
                                            lsField3 = "15";
                                            continue;
                                        }
                                        if( ldDiff < 0.0 ) {
                                            lsField3 = "17";
                                            continue;
                                        }
                                    }
                                }
                            }
                        }
/***************************FINALIZA CAMBIO PARA FORZAR EL CAMBIO DE DISCREPANCIA**********************************/
                        if(Integer.parseInt(psOrd) < -1) // Forzar en reenvio no hay reenvio
                            lsField4 = "4";

                        lsInsertQuery = "INSERT INTO op_grl_step_reception_detail(reception_id,store_id,provider_product_code,received_quantity,difference_id,unit_cost,provider_id, sort_num, forwarding_id) VALUES("+lsFieldRecep.trim()+","+lsFieldStore.trim()+",'"+lsField0.trim()+"',"+lsField2.trim()+",'"+lsField3.trim()+"',"+lsField6.trim()+",'"+lsFieldProv.trim()+"','"+lsField9 +"','"+lsField4 +"')";
                         moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{});
                         //DEBUG
                         //logApps.writeInfo("\nRecepDetailYum(a).jsp");
                         //logApps.writeInfo(lsInsertQuery);
                    }
                }
            }

            if (lsTmp.indexOf("R")>=0){
            	logApps.writeInfo("RecepDiffYumNew.jsp?hidRecep='+ escape("+lsFieldRecep+") + '&hidRem=' + escape("+laFieldExtra[6]+")");
                if(lsFieldProv.trim().equals("PFS")){
                    //Con remision  y proveedor PFS
                    poOutputHandler.println("<script>window.open('RecepDiffYumNew.jsp?hidRecep='+ escape("+lsFieldRecep+") + '&hidRem=' + escape(\""+laFieldExtra[6]+"\"),'auxWindow','height=650, width=1000, menubar=no,scrollbars=yes,resizable=yes'); </script>");
                }else{
                    //Con remision y otro proveedor (Esta condicion no se cumple)
                    poOutputHandler.println("<script>window.open('RecepConfirmYum.jsp?hidRecep='+ escape("+lsFieldRecep+") + '&hidRem=' + escape(\""+laFieldExtra[6]+"\"),'auxWindow','height=650, width=1000, menubar=no,scrollbars=yes,resizable=yes'); </script>");
                }
            }else{
                if(lsFieldProv.trim().equals("PFS")){
                    //Sin remision y proveedor PFS 
                    poOutputHandler.println("<script>window.open('RecepDiffYumNew.jsp?hidRecep='+ escape("+lsFieldRecep+") + '&hidRem=' + escape(-1),'auxWindow','height=650, width=1000, menubar=no,scrollbars=yes,resizable=yes'); </script>");
                }else{
                    //Sin remision y otro proveedor
                    poOutputHandler.println("<script>window.open('RecepConfirmYum.jsp?hidRecep='+ escape("+lsFieldRecep+") + '&hidRem=' + escape(-1),'auxWindow','height=650, width=1000, menubar=no,scrollbars=yes,resizable=yes'); </script>");
                }
            }
        } catch(Exception e) {
            //e.printStackTrace();
                        //DEBUG
                        //logApps.writeInfo("\nRecepDetailYum(b).jsp");
                        //logApps.writeInfo(e);
                        //logApps.writeInfo(lsInsertQuery);
        }
    }

    String getMainQuery(String  psStore,String psPrv,String psOrd,String psRem,String psRecep) {
        String lsQuery = "";
        AbcUtils moAbcUtils = new AbcUtils();
        String lsForwarding = "'3' as forwarding_id,";
        lsQuery = "DELETE FROM op_grl_invtran WHERE inv_id IN (SELECT inv_id FROM op_grl_cat_inventory WHERE family_id= '12800000' AND active_flag = 't')";
        moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
        lsQuery = "INSERT INTO op_grl_invtran SELECT inv_id, 1 FROM op_grl_cat_inventory WHERE family_id= '12800000' AND active_flag = 't'";
        moAbcUtils.executeSQLCommand(lsQuery, new String[]{});
        lsQuery = "";
        if (psRecep.equals("")){ //No tenemos numero de recepcion
	    if(!psOrd.equals("")){
	        if(Integer.parseInt(psOrd) < -1)
                    lsForwarding = "'4' as forwarding_id,";
            }

            if (!psRem.equals("") && !psRem.equals("-1")){ //Si tenemos remision
                logApps.writeInfo("Caso 1 No tenemos numero de recepcion, si tenemos remision:"+psRem);
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')||'_'|| m.unit_name||'_'||";
                lsQuery += " vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id ||'_'||";
                lsQuery += " p.provider_id ||'_'||(Case When r.remission_id IS NULL then '' else r.remission_id end)||'_R'||'_'||";
                lsQuery += " to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields,";
                lsQuery += " isnull(r.sort_num,0) as sequence,";
                lsQuery += " rtrim(ltrim(provider_product_code_remis)) as provider_product_code_remis,";
//                lsQuery += " p.provider_product_desc,ltrim(rtrim(to_char(required_quantity,'9999990.99')||' '||m.unit_name )) as required_quantity,";
                lsQuery += " p.provider_product_desc,ltrim(rtrim(to_char(0,'9999990.99')||' '||m.unit_name )) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                //lsQuery += " '0' as difference_id,'3' as forwarding_id,"; // Cambio para reenvios
                lsQuery += " (CASE WHEN CAST(required_quantity AS INTEGER) = 0 THEN '15' ELSE '0' END), "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When conversion_factor IS NULL then '0' else conversion_factor end)*";
//                lsQuery += " (Case When required_quantity IS NULL then '0' else required_quantity end), '9999990.99')||' '||vwm.unit_name )) as unit_inv,";
                lsQuery += " '0', '9999990.99')||' '||vwm.unit_name )) as unit_inv,";
                //lsQuery += " round(provider_price,2) as unit_cost,"; // Cambio para calculo de costo desde la compra
                lsQuery += " (CASE WHEN required_quantity > 0 THEN round(unit_cost/required_quantity,2) ELSE round(provider_price,2) END) as unit_cost,";
                lsQuery += " round(p.provider_price*required_quantity,2) as subtotal,";
                lsQuery += " ltrim(rtrim(to_char(0.00,'9999990.99'))) as required_ori";
                lsQuery += " FROM op_grl_remission_detail r";
                lsQuery += " INNER JOIN op_grl_cat_providers_product p";
                lsQuery += " ON r.provider_product_code_remis=p.provider_product_code AND r.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.remission_id ='"+psRem + "'";
                lsQuery += " ORDER BY 2 ASC";
            }else if ((psRem.equals(""))&& (!psOrd.equals(""))){ //Si tenemos orden, pero no remision
                logApps.writeInfo("Caso 2 No tenemos numero de recepcion, si tenemos orden:"+psOrd+", pero no remision");
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')||'_'||m.unit_name ||'_'||";
                lsQuery += " vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id ||'_'||";
                lsQuery += " p.provider_id ||'_'||(Case When r.order_id IS NULL then '0' else r.order_id end)||'_O'||'_'||";
                lsQuery += " to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields, 0,";
//MCA             lsQuery += " rtrim(ltrim(r.provider_product_code)),p.provider_product_desc,ltrim(rtrim(to_char(r.prv_required_quantity,'9999990.99')";
                lsQuery += " rtrim(ltrim(r.provider_product_code)),p.provider_product_desc,ltrim(rtrim(to_char(0,'9999990.99')";
                lsQuery += " ||' '|| m.unit_name )) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " '0' as difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char(";
//MCA             lsQuery += " (Case When r.inv_required_quantity IS NULL then '0' else r.inv_required_quantity end),";
                lsQuery += " 0,";
                lsQuery += " '9999990.99')||' '||vwm.unit_name)) as unit_inv,";
                //lsQuery += " round(provider_price,2) as unit_cost,";
                lsQuery += " round(unit_cost,2) as unit_cost,";
                lsQuery += " round(provider_price*prv_required_quantity,2) as subtotal,";
//MCA             lsQuery += " ltrim(rtrim(to_char(r.prv_required_quantity,'9999990.99'))) as required_ori";
                lsQuery += " ltrim(rtrim(to_char(0,'9999990.99'))) as required_ori";
                lsQuery += " FROM  op_grl_order_detail r";
                lsQuery += " INNER JOIN op_grl_cat_providers_product  p";
                lsQuery += " ON r.provider_product_code=p.provider_product_code";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=r.provider_unit";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.order_id ='"+psOrd + "'";
                lsQuery += " ORDER BY r.provider_product_code";
            }else{ //Si no tenemos ni orden, ni remision
                logApps.writeInfo("Caso 3 No tenemos recepcion, orden:"+psOrd+", ni remision:"+psRem);
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')||'_'||m.unit_name||'_'||";
                lsQuery += " vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id||'_'||";
                lsQuery += " p.provider_id ||'_'||(Case When r.order_id IS NULL then '0' else r.order_id end)||'_O'||'_'||";
                lsQuery += " to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields,0,";
                lsQuery += " rtrim(ltrim(r.provider_product_code)),p.provider_product_desc,";
                lsQuery += " ltrim(rtrim(to_char(r.prv_required_quantity,'9999990.99')||' '||m.unit_name)) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " '0' as difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When r.inv_required_quantity IS NULL then '0' else r.inv_required_quantity end), '9999990.99')";
                lsQuery += " ||' '|| vwm.unit_name )) as unit_inv,";
                lsQuery += " round(provider_price,2) as unit_cost,";
                lsQuery += " round(provider_price*prv_required_quantity,2) as subtotal,";
                lsQuery += " to_char(0,'9999990.99') as required_ori";
                lsQuery += " FROM  op_grl_order_detail r";
                lsQuery += " INNER JOIN op_grl_cat_providers_product  p";
                lsQuery += " ON r.provider_product_code=p.provider_product_code AND r.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=r.provider_unit";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.order_id=0";
                lsQuery += " ORDER BY r.provider_product_code";
            }
        }else{ // Tenemos numero de recepcion
            if (!psRem.equals("") && !psRem.equals("-1")){ //Trae remision
                logApps.writeInfo("Caso 4 Tenemos numero de recepcion y remision");
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')";
                lsQuery += " ||'_'|| m.unit_name ||'_'||vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id";
                lsQuery += " ||'_'||p.provider_id ||'_'||'" + psRem + "'||'_R'||'_'||";
                lsQuery += " to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields,";
                lsQuery += " isnull(rd.sort_num,0),";
                lsQuery += " rtrim(ltrim(p.provider_product_code)),";
                lsQuery += " p.provider_product_desc,";
                lsQuery += " ltrim(rtrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name )) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " rd.difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When conversion_factor IS NULL then '0' else conversion_factor end)*";
                lsQuery += " (Case When rd.received_quantity IS NULL then '0' else rd.received_quantity end), '9999990.99')||' '||vwm.unit_name))";
                //lsQuery += " as unit_inv, round(provider_price,2) as unit_cost,";
                lsQuery += " as unit_inv, (CASE WHEN required_quantity > 0 THEN round(rem.unit_cost/required_quantity,2) ELSE round(provider_price,2) END) as unit_cost,";
                lsQuery += " round(provider_price*rd.received_quantity,2) as subtotal,";
                lsQuery += " ltrim(rtrim(to_char(0.00,'9999990.99'))) as required_ori";
                lsQuery += " FROM  op_grl_step_reception re";
                lsQuery += " INNER JOIN op_grl_step_reception_detail rd ON rd.reception_id=re.reception_id";
                lsQuery += " INNER JOIN op_grl_remission_detail rem ON rem.provider_product_code_remis = rd.provider_product_code AND rem.provider_id = rd.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_providers_product p ON rd.provider_product_code=p.provider_product_code AND rd.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE re.provider_id ='"+ psPrv +"'";
                lsQuery += " AND rd.reception_id =" + psRecep;
                lsQuery += " AND rem.remission_id ='" + psRem + "'";
                lsQuery += " UNION";
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')";
                lsQuery += " ||'_'|| m.unit_name ||'_'||vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id ||'_'||p.provider_id";
                lsQuery += " ||'_'||'" + psRem + "'||'_R'||'_'||to_char";
                lsQuery += " ((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99'))) as extra_fields,";
                lsQuery += " isnull(rd.sort_num,0),";
                lsQuery += " rtrim(ltrim(p.provider_product_code)),";
                lsQuery += " p.provider_product_desc,";
                lsQuery += " ltrim(rtrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name )) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " rd.difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When conversion_factor IS NULL then '0' else conversion_factor end)*";
                lsQuery += " (Case When rd.received_quantity IS NULL then '0' else rd.received_quantity end),'9999990.99')||' '||vwm.unit_name))";
                lsQuery += " as unit_inv, round(provider_price,2) as unit_cost,";
                lsQuery += " round(provider_price*rd.received_quantity,2) as subtotal,";
                lsQuery += " to_char(CAST(0 as integer),'9999990.99') as required_ori";
                lsQuery += " FROM  op_grl_step_reception_detail  rd";
                lsQuery += " INNER JOIN op_grl_cat_providers_product  p ON rd.provider_product_code=p.provider_product_code";
                lsQuery += " INNER JOIN op_grl_cat_inventory i    ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE rd.provider_id ='" + psPrv + "'";
                lsQuery += " AND rd.reception_id =" + psRecep ;
                lsQuery += " AND rd.provider_product_code NOT IN(";
                lsQuery += " SELECT rem.provider_product_code_remis";
                lsQuery += " FROM op_grl_remission_detail rem";
                lsQuery += " WHERE rem.remission_id='" + psRem + "'";
                lsQuery += " )";
                lsQuery += " ORDER BY 2";
            }else if (!psOrd.equals("")){ // trae orden
                logApps.writeInfo("Caso 5 Tenemos numero de recepcion y trae orden" );
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')";
                lsQuery += " ||'_'||m.unit_name||'_'||vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id";
                lsQuery += " ||'_'||p.provider_id ||'_'||'" + psOrd + "'||'_O'||'_'||to_char";
                lsQuery += " ((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields,";
                lsQuery += " isnull(r.sort_num,0) as num_line,";
                lsQuery += " ltrim(rtrim(r.provider_product_code)),";
                lsQuery += " p.provider_product_desc,ltrim(rtrim(to_char(r.received_quantity,'9999990.99')||' '||m.unit_name)) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " r.difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When r.received_quantity IS NULL then '0' else r.received_quantity end), '9999990.99')";
                lsQuery += " ||' '||vwm.unit_name)) as unit_inv,";
                //lsQuery += " round(provider_price,2) as unit_cost,";
                lsQuery += " round(ord.unit_cost,2) as unit_cost,";
                lsQuery += " round(provider_price*received_quantity,2) as subtotal,";
                lsQuery += " ltrim(rtrim(to_char(ord.prv_required_quantity,'9999990.99'))) as required_ori";
                lsQuery += " FROM  op_grl_step_reception_detail r";
                lsQuery += " INNER JOIN op_grl_order_detail ord ON ord.provider_product_code = r.provider_product_code AND r.provider_id=ord.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_providers_product  p ON r.provider_product_code=p.provider_product_code AND r.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE r.store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.reception_id ="+psRecep ;
                lsQuery += " AND ord.order_id ="+psOrd;
                lsQuery += " UNION";
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')";
                lsQuery += " ||'_'||m.unit_name||'_'||vwm.unit_name ||'_'|| m.unit_id ||'_'|| vwm.unit_id";
                lsQuery += " ||'_'||p.provider_id ||'_'||'" + psOrd + "'||'_O'||'_'||to_char";
                lsQuery += " ((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') )) as extra_fields,";
                lsQuery += " isnull(r.sort_num,0) as num_line,";
                lsQuery += " ltrim(rtrim(r.provider_product_code)),";
                lsQuery += " p.provider_product_desc,ltrim(rtrim(to_char(r.received_quantity,'9999990.99')||' '||m.unit_name)) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += " r.difference_id, "+lsForwarding;
                lsQuery += " ltrim(rtrim(to_char((Case When r.received_quantity IS NULL then '0' else r.received_quantity end),'9999990.99')";
                lsQuery += " ||' '||vwm.unit_name)) as unit_inv,";
                lsQuery += " round(provider_price,2) as unit_cost,";
                lsQuery += " round(provider_price*received_quantity,2) as subtotal,";
                lsQuery += " to_char(CAST(0 as integer),'9999990.99') as required_ori";
                lsQuery += " FROM  op_grl_step_reception_detail r";
                lsQuery += " INNER JOIN op_grl_cat_providers_product p ON r.provider_product_code=p.provider_product_code AND r.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE r.store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.reception_id ="+psRecep ;
                lsQuery += " AND r.provider_product_code NOT IN(";
                lsQuery += " SELECT ord.provider_product_code";
                lsQuery += " FROM op_grl_order_detail ord";
                lsQuery += " WHERE ord.order_id=" + psOrd;
                lsQuery += " )";
                lsQuery += " ORDER BY 3";
            } else { //Sin orden y sin remision
                logApps.writeInfo("Caso 6");
                lsQuery += " SELECT ltrim(rtrim(to_char(p.conversion_factor,'9999990.99')||'_'||m.unit_name||'_'||";
                lsQuery += " vwm.unit_name ||'_'||m.unit_id||'_'|| vwm.unit_id ||'_'||";
                lsQuery += " p.provider_id ||'_'||(Case When r.reception_id IS NULL then '0' else r.reception_id end)||'_N'||'_'||";
                lsQuery += " to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'999999.99') ))as extra_fields,";
                lsQuery += " isnull(r.sort_num,0),";
                lsQuery += " r.provider_product_code,p.provider_product_desc,ltrim(rtrim(to_char(received_quantity,'9999990.99')";
                lsQuery += " ||' '||m.unit_name)) as required_quantity,";
                lsQuery += " '0.00'||' '||m.unit_name as recapture,";
                lsQuery += "'0' as difference_id, "+lsForwarding;
                lsQuery += "ltrim(rtrim(to_char((Case When conversion_factor IS NULL then '0' else conversion_factor end)*";
                lsQuery += "(Case When received_quantity IS NULL then '0' else received_quantity end), '9999990.99')||' '||vwm.unit_name)) as unit_inv,";
                lsQuery += "round(provider_price,2) as unit_cost,";
                lsQuery += "round(provider_price*received_quantity,2) as subtotal,";
                lsQuery += " to_char(0,'9999990.99') as required_ori";
                lsQuery += " FROM  op_grl_step_reception_detail r";
                lsQuery += " INNER JOIN op_grl_cat_providers_product  p";
                lsQuery += " ON r.provider_product_code=p.provider_product_code AND r.provider_id = p.provider_id";
                lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
                lsQuery += " INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure";
                lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure";
                lsQuery += " WHERE store_id="+getStore();
                lsQuery += " AND p.provider_id ='"+psPrv + "'";
                lsQuery += " AND r.reception_id ="+psRecep ;
                lsQuery += " ORDER BY r.provider_product_code";
            }
        }
        logApps.writeInfo("getMainQuery.lsQuery:\n" + lsQuery);
        return(lsQuery);
    }

    String getValueDiff(){
        int case_id = 5; //Es el caso de agnadir nuevos productos dentro de la tabla op_grl_cat_recep_cases
        String lsQuery = "";
        lsQuery += " SELECT difference_id from op_grl_cat_config_difference WHERE case_id=" + case_id;
        lsQuery += " ORDER BY sort_seq LIMIT 1";
        AbcUtils moAbcUtils = new AbcUtils();
        String lsSelectedDefault=moAbcUtils.queryToString(lsQuery,"","");
        return(lsSelectedDefault);
    }
%>
