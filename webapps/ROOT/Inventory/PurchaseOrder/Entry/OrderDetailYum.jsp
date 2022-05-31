<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : OrderDetailYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : akg
# Objetivo        : Detalle de ORDENES DE COMPRA
# Fecha Creacion  : 14/Septiembre/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>
<%@page import="java.io.*" %>

<%
// Inicia plantilla
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation = request.getParameter("hidOperation");
    if (msOperation==null) return;
    String msMasterKeys = null;

    AbcCatalog moAbcCatalog = new AbcCatalog(out,request);
    moAbcCatalog.setMasterKeys(msMasterKeys);
    String msOrder="0";
    String msStore="0";
    try{
        msOrder=request.getParameter("hidStepOrder");
        msStore=request.getParameter("hidStepStore");
    }catch(Exception e){ }

    //out.println(getMainQuery(msOrder,msStore));

    moAbcCatalog.setQuery(getMainQuery(msOrder,msStore));
    moAbcCatalog.initParamsLength(16);
    moAbcCatalog.setFieldNames(new String[]{"conversion_factor","provider_id","unit_cost","provider_product_code","product_name","available_quantity","required","way_quantity","suggested","suggested_quantity","suggested_equivalent","unit_provider","unit_inventory","provider_price","provider_name"});
    moAbcCatalog.setTableTitleHeaders(new String[]{"","","","","","Existencia actual en sistema","Existencia actual en sistema","Existencia actual en sistema","Existencia actual en sistema","","","Esto estas pidiendo","Esto estas pidiendo","Esto estas pidiendo",""});
    moAbcCatalog.setTableTitles(new String[]{"","","","C&oacute;digo<br>Producto","Producto","Cantidad<br>Disponible","Pron&oacute;stico<br>Requerido","Producto<br>en tr&aacute;nsito","Pedido<br>Sugerido","CAPTURA POR<br>UNIDADES<br>INVENTARIO ","Equiv<br>Unidad<br>Prov","CAPTURA POR <br>PRESENTACION ","Pedido<br>Unidad<br>Inv","Costo","Proveedor"});
    moAbcCatalog.setInsertMode(new boolean[]{false,false,false,false,false,false,false,false,false,true,false,true,false,false,false});
    moAbcCatalog.setSearchMode(new String[]{"","","","","","","","","","","","","","",""});
    moAbcCatalog.setEditMode(new boolean[]{false,false,false,false,false,false,false,false,false,true,false,true,false,false,false});
    moAbcCatalog.setUpdateMode(new boolean[]{false,false,false,false,false,false,false,false,false,true,false,true,false,false,false});
    moAbcCatalog.setValidMode(new String[]{"R","R","R","R","R","R","R","R","R","R","R","R","R","R","R"});
    moAbcCatalog.setBlurMode(new boolean[]{false,false,false,false,false,false,false,false,false,true,false,true,false,false,false});
    moAbcCatalog.setFocusMode(new boolean[]{false,false,false,false,false,false,false,false,false,true,false,true,false,false,false});
    moAbcCatalog.setColorMode(new String[]{"","","","","","#66CCFF","#66CCFF","#66CCFF","#66CCFF","","","#CCFFFF","#CCFFFF","#CCFFFF",""});
    moAbcCatalog.setTypeMode(new String[]{"hidden","hidden","hidden","text","text","text","text","text","text","text","text","text","text","text","text"});
    moAbcCatalog.setFieldSizes(new String[]{"30","30","30","8","20","12","12","12","12","15","10","15","15","15","25"});
    moAbcCatalog.setSourceMode(new String[]{"","","","","","","","","","","","","","",""});
    moAbcCatalog.setOperations(new boolean[]{true,false,true,false});
    moAbcCatalog.setSrcDialogWidth(new String[]{"700","700","700","700","700","700","700","700","700","700","700","700","700","700","700"});
    moAbcCatalog.setSrcDialogHeight(new String[]{"450","450","450","450","450","450","450","450","450","450","450","450","450","450","450"});
    moAbcCatalog.setOnInsertCustomAction(true);
    moAbcCatalog.setInsertButtonText("Agregar Producto");

    if (msOperation.equals("U")) {
        updateTables(msMasterKeys,request,out);
    }
%>

<html>
    <head>
        <div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
        <title>Detalle de Pedido</title>
        <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
   </head>
   <script>
    
	//AGREGO GAR
	var gaDataset = <%= getDatasetl() %>;
	function getLimitReceptionl(psProductId){
		var lfLimit = 0;
		if(gaDataset.length > 0){
			for(liRowId=0;liRowId<gaDataset.length;liRowId++){
				var lsProduct = gaDataset[liRowId][0];
				var lsLimit = gaDataset[liRowId][1];
				if(rtrim(ltrim(psProductId)) == rtrim(ltrim(lsProduct))){
					lfLimit = parseFloat(lsLimit);
					break;
				}
			}
		}
		return lfLimit;
	}
	
	function getDataset(){
		return gaDataset;
	}
	
	function ltrim(str){
		return  str.replace(/^[ ]+/, ''); 
	}
	
	function rtrim(str){
		return str.replace(/[ ]+$/, ''); 
	}
	
	//+++++++++++++++++++++++++++++
    
    function trim(pString){
        return pString.replace(/(^\s*)|(\s*$)/g,'');
    }

    function adjustPageSettings(){
        adjustContainer(60,260);
    }

    function addSeparators(nStr, inD, outD, sep){
        nStr += '';
        var dpos = nStr.indexOf(inD);
        var nStrEnd = '';
        if (dpos != -1)
        {
                nStrEnd = outD + nStr.substring(dpos + 1, nStr.length);
                nStr = nStr.substring(0, dpos);
        }
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(nStr))
        {
                nStr = nStr.replace(rgx, '$1' + sep + '$2');
        }

        return nStr + nStrEnd.substring(nStrEnd.indexOf('.'),3);
    }

    function gridCustomSettings(){
        objFrm=document.getElementById("frmGrid");
        objTable = document.getElementById("tblMdx");

        if (objTable.rows.length>2)
        {
            for(i=0;i<objTable.rows.length-2; i++)
            {
                document.getElementById('chkRowControl|'+i).checked=true;
                document.getElementById('chkRowControl|'+i).value=2;
                document.getElementById('provider_price|'+i).value=addSeparators(document.getElementById('provider_price|'+i).value,'.', '.', ',');
           }
        }
    }

    function setReturnedCustomValues(psAllData){
        var lsControlDesc ="provider_product_code|product_name|available_quantity|required|";
        lsControlDesc += "way_quantity|suggested|suggested_quantity|suggested_equivalent|";
        lsControlDesc += "unit_provider|unit_inventory|provider_price|provider_name|";
        lsControlDesc += "conversion_factor|provider_id|unit_cost";

        var laControls=lsControlDesc.split('|');
        var laRecords=psAllData.split('&');
        var laIndivRecord;
        var lsProdCode="";
        var lsRepeatString="";

        parent.lsProductoCodeLst="";            
        objFrm = document.getElementById("frmGrid");
        objTable = document.getElementById("tblMdx");

        for(i=0;i<objTable.rows.length-1; i++){
           objInput1 = document.getElementById('provider_product_code|' + i);
           objInput2 = document.getElementById('provider_name|' + i);
           if (objInput1!=null)
           {
                parent.lsProductoCodeLst=parent.lsProductoCodeLst+','+objInput1.value+objInput2.value;
           }
        }

        if (objTable.rows.length>2)
            parent.liRowCount=objTable.rows.length-2;

        for (var i=0;i< laRecords.length;i++){
            laIndivRecord=laRecords[i].split('|');
            if (trim(parent.lsProductoCodeLst).indexOf(trim(laIndivRecord[0])+trim(laIndivRecord[11]))<0)
            {
                f_addRow(false);
                parent.liRowCount=parent.liRowCount+1;

                for (var x=0;x<=laIndivRecord.length-1;x++)
                {
                    document.getElementById(laControls[x]+'|'+(parent.liRowCount-1)).value=laIndivRecord[x];

                    if (laControls[x]=='provider_product_code')
                       parent.lsProductoCodeLst=parent.lsProductoCodeLst+','+laIndivRecord[x]+laIndivRecord[11];
                }
            }
        }
    }

    function validateGridCustom()
    {
        objTable = document.getElementById("tblMdx");
        if (objTable.rows.length==2)
        {
            alert("Por favor agregue los productos que desee ordenar")
            return(false);
        }
        if (objTable.rows.length>2)
        {
            for(i=0;i<objTable.rows.length-2; i++)
            {
                var lsQtyRequerida = document.getElementById('suggested_quantity|'+i).value;
                var lsQtyProv = document.getElementById('unit_provider|'+i).value;

                if(lsQtyRequerida.substring(0,lsQtyRequerida.indexOf(" ")) == "0.00" || 
                   lsQtyRequerida.substring(0,lsQtyRequerida.indexOf(" ")) == 0)
                {
                    if(document.getElementById('chkRowControl|'+i).checked)
                    {
                        alert("Es necesario capturar la cantidad requerida ó el pedido en unidad de proveedor de todos los productos");
                        document.getElementById('suggested_quantity|'+i).focus();
                        return(false);
                    }
                }
                else
                {
                    if( (document.getElementById('chkRowControl|'+i).checked) && 
                        (lsQtyRequerida.charAt(0) == "-"))
                    {
                        alert("No se deben ingresar cantidades negativas.");
                        document.getElementById('suggested_quantity|'+i).focus();
                        return(false);
                    }    
                }
            }

        return(true);
        }
    }
    </script>

    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>
    <script src="/Scripts/CalendarYum.js"></script>

    <body   OnResize = 'adjustTableSize();' bgcolor='white'>
    <%
            moAbcCatalog.generatePage();
        %>
   
    <script>
        var lsUnit1,lsUnit2,lsUnit3,lsUnit4="";
        var qty="";

        function onFocusCustomControl(poControl) {
            frmFocusAction(poControl);
        }

        function onInsertAction() {
           openDialog("SearchProductsYum.jsp?psStore="+<%=getStore()%>,1000,650,setReturnedData);
        }

        function frmFocusAction(poControl){
           var lsCtlName=poControl.name;
           var liPos=lsCtlName.substring(lsCtlName.indexOf("|")+1,lsCtlName.length);
           var lsCtlValue=poControl.value;
           var lsCtlValue1=document.getElementById('suggested_quantity|'+liPos).value;
           var lsCtlValue2=document.getElementById('suggested_equivalent|'+liPos).value;
           var lsCtlValue3=document.getElementById('unit_provider|'+liPos).value;
           var lsCtlValue4=document.getElementById('unit_inventory|'+liPos).value;

           qty=lsCtlValue.substring(0,lsCtlValue.indexOf(" "));
           poControl.value=qty;
           lsUnit1=lsCtlValue1.substring(lsCtlValue1.indexOf(" ")+1,lsCtlValue1.length);
           lsUnit2=lsCtlValue2.substring(lsCtlValue2.indexOf(" ")+1,lsCtlValue2.length);
           lsUnit3=lsCtlValue3.substring(lsCtlValue3.indexOf(" ")+1,lsCtlValue3.length);
           lsUnit4=lsCtlValue4.substring(lsCtlValue4.indexOf(" ")+1,lsCtlValue4.length);

        }

        function onBlurCustomControl(poControl) {
            frmChgAction(poControl);
        }

        function frmChgAction(poControl){
        	var lsCtlName=poControl.name;
            	var liPos;
            	var lrFactorConv;
            	var lsField1,lsField2,lsfield3,lsfield4;

		//AGREGO GAR
		liPos=lsCtlName.substr(lsCtlName.indexOf("|")+1,lsCtlName.length);
		var lsProductId  = trim(document.getElementById('provider_product_code|'+liPos).value);
		var lfLimit = getLimitReceptionl(lsProductId);
		//++++++++++++++++++++++++++++++++++

            	if (lsCtlName.indexOf("suggested_quantity")==0){
                	liPos=lsCtlName.substr(lsCtlName.indexOf("|")+1,lsCtlName.length);
                	lrFactorConv=document.getElementById('conversion_factor|'+liPos).value;
                	lsFieldCompare=document.getElementById('suggested_quantity|'+liPos).value;
                	if (isNaN(lsFieldCompare.replace(",",""))){
                    		alert('El campo Cantidad Requerida  debe ser un numérico.');
                    		document.getElementById('suggested_quantity|'+liPos).value='';
                    		document.getElementById('suggested_quantity|'+liPos).focus();
                	}
                	else{
                    		lsField1=poControl.value;
                    		//AGREGO GAR
				var evalua = lsField1.replace(",","")/lrFactorConv;
				//+++++++++++++++++++++++++++++++++++++++
				
				document.getElementById('suggested_equivalent|'+liPos).value=lsField1.replace(",","")/lrFactorConv;
		    		/* Cambio para bachoco */
		    		if ( lsField1.replace(",","")/lrFactorConv == 0.01 ){
                       			document.getElementById('unit_provider|'+liPos).value=Math.floor(document.getElementById('suggested_equivalent|'+liPos).value);
		    		} 
				else{
                       			document.getElementById('unit_provider|'+liPos).value=Math.ceil(document.getElementById('suggested_equivalent|'+liPos).value);
		    		}
                    		lsfield3=document.getElementById('unit_provider|'+liPos).value;
                    		document.getElementById('unit_inventory|'+liPos).value=lsfield3.replace(",","")*lrFactorConv;                         
                    		document.getElementById('provider_price|'+liPos).value=lsfield3.replace(",","")*document.getElementById('unit_cost|'+liPos).value;     
                       		// Agrego formato
                    		document.getElementById('suggested_equivalent|'+liPos).value=addSeparators(document.getElementById('suggested_equivalent|'+liPos).value,'.','.', ',');                                               
                    		document.getElementById('suggested_quantity|'+liPos).value=addSeparators(document.getElementById('suggested_quantity|'+liPos).value,'.','.',',');                        
                    		document.getElementById('unit_provider|'+liPos).value=addSeparators(document.getElementById('unit_provider|'+liPos).value,'.','.',','); 
                    		document.getElementById('provider_price|'+liPos).value=addSeparators(document.getElementById('provider_price|'+liPos).value,'.','.',',');                                               
                    		document.getElementById('unit_inventory|'+liPos).value=addSeparators(document.getElementById('unit_inventory|'+liPos).value,'.','.',',');
              			//AGREGO GAR
            			document.getElementById('suggested_quantity|'+liPos).value=document.getElementById('suggested_quantity|'+liPos).value+" "+lsUnit1;
            			document.getElementById('suggested_equivalent|'+liPos).value=document.getElementById('suggested_equivalent|'+liPos).value+" "+lsUnit2;
            			document.getElementById('unit_provider|'+liPos).value=document.getElementById('unit_provider|'+liPos).value+" "+lsUnit3;
				document.getElementById('unit_inventory|'+liPos).value=document.getElementById('unit_inventory|'+liPos).value+" "+lsUnit4;
				//++++++++++++++++++++++++++++++++++++++++++++++++++

				if(lfLimit > 0){
					if(evalua > lfLimit){		
						var lsMsg = 'El limite de Pedido es de '+lfLimit+' ' + lsUnit2 + ' de '+ document.getElementById('product_name|'+liPos).value + '. ' + 'Estas seguro de querer ingresar una cantidad superior. ';
						alert(lsMsg);
					}
				}
			}
            	}

            	if (lsCtlName.indexOf("unit_provider")==0){
                	liPos=lsCtlName.substr(lsCtlName.indexOf("|")+1,lsCtlName.length); 
                	lrFactorConv=document.getElementById('conversion_factor|'+liPos).value;  
                	lsFieldCompare=document.getElementById('unit_provider|'+liPos).value;
                	if (isNaN(lsFieldCompare.replace(",",""))){
                    		alert('El campo Pedido Unidad Prov  debe ser un numérico.');
                    		document.getElementById('unit_provider|'+liPos).value='';
                    		document.getElementById('unit_provider|'+liPos).focus();
                	}
                	else{    
                    		lsField1=document.getElementById('unit_provider|'+liPos).value;             
                    		document.getElementById('suggested_quantity|'+liPos).value=lsField1.replace(",","")*lrFactorConv;  
                    		document.getElementById('suggested_equivalent|'+liPos).value=lsField1.replace(",","");                     
                    		document.getElementById('unit_inventory|'+liPos).value=lsField1.replace(",","")*lrFactorConv;                         
                    		document.getElementById('provider_price|'+liPos).value=lsField1.replace(",","")*document.getElementById('unit_cost|'+liPos).value;                                                
                    		// Agrego formato
                    		document.getElementById('suggested_equivalent|'+liPos).value=addSeparators(document.getElementById('suggested_equivalent|'+liPos).value, '.', '.', ',');                                               
                    		document.getElementById('provider_price|'+liPos).value=addSeparators(document.getElementById('provider_price|'+liPos).value, '.', '.', ',')                                               
                    		document.getElementById('suggested_quantity|'+liPos).value=addSeparators(document.getElementById('suggested_quantity|'+liPos).value,'.', '.', ',');                        
                    		document.getElementById('unit_provider|'+liPos).value=addSeparators(document.getElementById('unit_provider|'+liPos).value,'.', '.', ','); 
                    		document.getElementById('unit_inventory|'+liPos).value=addSeparators(document.getElementById('unit_inventory|'+liPos).value,'.', '.', ',');
                    		document.getElementById('unit_provider|'+liPos).value=addSeparators(document.getElementById('unit_provider|'+liPos).value, '.', '.', ',');   
            			//AGREGO GAR
				document.getElementById('suggested_quantity|'+liPos).value=document.getElementById('suggested_quantity|'+liPos).value+" "+lsUnit1;
            			document.getElementById('suggested_equivalent|'+liPos).value=document.getElementById('suggested_equivalent|'+liPos).value+" "+lsUnit2;
            			document.getElementById('unit_provider|'+liPos).value=document.getElementById('unit_provider|'+liPos).value+" "+lsUnit3;
           	 		document.getElementById('unit_inventory|'+liPos).value=document.getElementById('unit_inventory|'+liPos).value+" "+lsUnit4;
				//+++++++++++++++++++++++++++++++++++++++++++++++
				
				if(lfLimit > 0){
					if(lsField1 > lfLimit){
						var lsMsg = 'El limite de Pedido es de '+lfLimit+' ' + lsUnit2 + ' de '+ document.getElementById('product_name|'+liPos).value + '. ' + 'Estas seguro de querer ingresar una cantidad superior. ';
						alert(lsMsg);
					}
				}
            		}
		}
    	}

        </script>
        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!

   String  getNumOrder(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsOrder="0";
        return(lsOrder);
   }

   String getStore(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_id from ss_cat_store ","","");
        return(lsStore);
   }

   String getDateTime(){
        String lsDate="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance(); 
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay); 
        
        lsDate=lsDF.format(lsC1.getTime());
        return(lsDate);
    }

    void updateTables(String psMasterKeys, HttpServletRequest poRequestHandler, JspWriter poOutputHandler) {
        AbcUtils moAbcUtils = new AbcUtils();
        int liFlag=0;
        Enumeration loParameters = poRequestHandler.getParameterNames();
        String lsParamName;
        String lsInsertQuery="";
        String lsFieldOrder = getNumOrder();
        String lsFieldStore= getStore();
        String lsFieldDate= getDateTime();

        try {
            String lsDeleteQuery = "DELETE from  op_grl_step_order_detail";
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});            

            lsDeleteQuery = "DELETE from  op_grl_step_order ";
            moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

            while(loParameters.hasMoreElements()) {
                lsParamName=(String)loParameters.nextElement();
                if (lsParamName.indexOf("chkRowControl")!=-1) {
                    String lsAction = poRequestHandler.getParameter(lsParamName);                    
                    String lsParamNumber = lsParamName.substring(lsParamName.indexOf('|')+1);

                    String lsField0 = poRequestHandler.getParameter("provider_product_code|" + lsParamNumber);
                    String lsField1 = poRequestHandler.getParameter("provider_id|" + lsParamNumber);
                    String lsField2 = poRequestHandler.getParameter("product_name|" + lsParamNumber);
                    String lsField3 = poRequestHandler.getParameter("available_quantity|" + lsParamNumber).replaceAll(",","");
                    String lsField4 = poRequestHandler.getParameter("required|" + lsParamNumber).replaceAll(",","");
                    String lsField5 = poRequestHandler.getParameter("suggested|" + lsParamNumber).replaceAll(",","");
                    String lsField6 = poRequestHandler.getParameter("suggested_quantity|" + lsParamNumber).replaceAll(",","");
                    String lsField7 = poRequestHandler.getParameter("suggested_equivalent|" + lsParamNumber).replaceAll(",","");
                    String lsField8 = poRequestHandler.getParameter("unit_provider|" + lsParamNumber).replaceAll(",","");
                    String lsField9 = poRequestHandler.getParameter("unit_inventory|" + lsParamNumber).replaceAll(",","");
                    String lsField10 = poRequestHandler.getParameter("provider_price|" + lsParamNumber).replaceAll(",","");
                    String lsField11 = poRequestHandler.getParameter("provider_name|" + lsParamNumber);
                    String lsField12 = poRequestHandler.getParameter("unit_cost|" + lsParamNumber).replaceAll(",","");
                    String lsFieldProvMeasure=lsField1;

            if (lsField1.indexOf(",")>0)
                        lsFieldProvMeasure=lsField1.substring(lsField1.indexOf(",")+1,lsField1.length());
                    //DEBUG
                    System.out.println("lsField9 = " + lsField1);

                    if (lsField1.indexOf(",")>0)
                        lsField1=lsField1.substring(0,lsField1.indexOf(","));
                        
                    if (lsField10.indexOf(".")>0)                        
                        lsField10=lsField10.replaceAll(",","").substring(0,lsField10.indexOf(".")+2);

                    if (lsField6.indexOf(" ")>0)
                        lsField6=lsField6.substring(0,lsField6.indexOf(" "));
                    if (lsField7.indexOf(" ")>0)
                        lsField7=lsField7.substring(0,lsField7.indexOf(" "));
                    if (lsField8.indexOf(" ")>0)
                        lsField8=lsField8.substring(0,lsField8.indexOf(" "));
                    if (lsField9.indexOf(" ")>0)
                       lsField9=lsField9.substring(0,lsField9.indexOf(" "));

                    if (lsAction.equals("2")) {
                        if (liFlag==0){
                            lsInsertQuery = "INSERT INTO op_grl_step_order (order_id,store_id,date_id) VALUES(?,?,?) ";
                            moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{lsFieldOrder,lsFieldStore,lsFieldDate});
                            liFlag=1;                            
                        
                        }
                        lsInsertQuery = "INSERT INTO op_grl_step_order_detail(order_id,store_id,provider_product_code,provider_id,provider_unit,unit_cost,inv_required_quantity,prv_required_quantity) VALUES("+lsFieldOrder+","+lsFieldStore+",'"+lsField0+"','"+lsField1+"','"+lsFieldProvMeasure+"',"+lsField12+","+lsField6+","+lsField8+")";
                        moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{});

                     }
                 }
             }

	int liNumItems = getNumItems();
	     poOutputHandler.println("<script>window.open('OrderConfirmYum.jsp?hidStore='+ escape("+lsFieldStore+") + '&hidOrder=' + escape("+lsFieldOrder+")+ '&piNumItems=' + escape("+liNumItems+") ,'auxWindow','height=650, width=1000, menubar=no,scrollbars=yes,resizable=yes');</script>");

		//poOutputHandler.println("<script>window.open('Test.jsp?hidStore='+ escape("+lsFieldStore+") + '&hidOrder=' + escape("+lsFieldOrder+"),'auxWindow','height=250, width=350, menubar=no,scrollbars=yes,resizable=yes, statusbar=yes, toolbar=no,left=300, top=200');</script>");


        } catch(Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            System.out.println(lsInsertQuery);
    }
    }

    String getMainQuery(String psOrder,String  psStore)
    {
        String lsQry = "";
        lsQry += " SELECT";
        lsQry += " p.conversion_factor,";
        lsQry += " Rtrim(Ltrim(p.provider_id))||','||cast(p.provider_unit_measure as varchar),";
        lsQry += " p.provider_price,";
        lsQry += " Rtrim(Ltrim(p.provider_product_code)) as provider_product_code,";
	lsQry += " Rtrim(Ltrim(i.inv_desc||'/'||p.provider_product_desc)) as product_name,";
        lsQry += " Ltrim(to_char((Case When s.available_quantity IS NULL then '0' else s.available_quantity end),'9999990.99')||' '||rtrim(m.unit_name)) AS available_quantity,";
        lsQry += " Ltrim((to_char(isnull(s.required,0),'9999990.99')||' '||rtrim(m.unit_name))) as required,";
        lsQry += " ltrim(to_char(isnull(w.way_quantity,0),'9999990.99')||' '||rtrim(m.unit_name)) as way_quantity ,";
        lsQry += " Ltrim((to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99')||' '||rtrim(m.unit_name))) as suggested,";
        lsQry += " Ltrim((to_char((Case When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end),'9999990.99')||' '||rtrim(m.unit_name))) AS suggested_quantity,";
        lsQry += " Ltrim((to_char((Case When od.inv_required_quantity IS NULL then '0' else od.inv_required_quantity end)/(Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end),'9999990.99')||' '||rtrim(m1.unit_name))) as suggested_equivalent,";
        lsQry += " Ltrim((to_char(CEIL((Case When od.prv_required_quantity IS NULL  then '0' else od.prv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name))) as unit_provider,";
        lsQry += " Ltrim(to_char(CEIL((Case When od.prv_required_quantity IS NULL  then '0' else od.prv_required_quantity end)*(Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end)),'9999990.99')||' '||rtrim(m.unit_name)) as unit_inventory,";
	    lsQry += " Ltrim(to_char(ROUND((Case When od.prv_required_quantity IS NULL  then '0' else od.prv_required_quantity end)*(Case When p.provider_price IS NULL  then '0' else p.provider_price end)),'9999990.99')) as provider_price,";
        lsQry += " prv.name as provider_name";
        lsQry += " FROM op_grl_step_order_detail od";
        lsQry += " INNER JOIN op_grl_step_order o ON o.order_id = od.order_id AND o.store_id = od.store_id";
        lsQry += " INNER JOIN op_grl_cat_providers_product p ON ";
        lsQry += " (p.provider_product_code=od.provider_product_code AND p.provider_id=od.provider_id)";
        lsQry += " INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id";
        lsQry += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
        lsQry += " LEFT JOIN op_grl_suggested_order s ON ";
        lsQry += " (s.store_id=o.store_id and s.inv_id=p.inv_id AND s.order_id=0)";
        lsQry += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = i.inv_unit_measure";
        lsQry += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = p.provider_unit_measure";
        lsQry += " LEFT JOIN op_grl_way_order w ON ";
        lsQry += " (w.provider_product_code=od.provider_product_code AND w.order_id=0)";
        lsQry += " WHERE o.store_id="+psStore+" AND o.order_id="+psOrder+" ";
        lsQry += " ORDER BY 5 asc, 6 asc";

    return(lsQry);
}

int getNumItems(){
	String lsQuery = "";
	AbcUtils loAbcUtils = new AbcUtils();
	lsQuery += "SELECT COUNT(provider_id) from op_grl_step_order_detail WHERE order_id=0";
	return Integer.parseInt(loAbcUtils.queryToString(lsQuery,"",""));
}
	//AGREGA GAR
	AbcUtils moAbcUtils = new AbcUtils();
	String getDatasetl(){
		String lsQry;
		lsQry = "SELECT trim(provider_product_code),trim(CAST(limit_quantity AS CHAR(8))) FROM op_grl_reception_limits";
		return moAbcUtils.getJSResultSet(lsQry);
	}
	//++++++++++++++++++++
%>
