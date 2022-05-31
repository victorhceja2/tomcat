 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InvoiceEntryYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG/SC/EZ
# Objetivo        : Detalle de la facturación
# Fecha Creacion  : 28/Oct/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="generals.*" %>
<%@ page import="java.io.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils();  %>

<%! int giUpdates = 0; %>
<%! String gsNotes = ""; %>
<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());;

    String msOperation = request.getParameter("hidOperation");

    if (msOperation==null) return;


    String msMasterKeys = (msOperation.equals("B"))?request.getParameter("cmbProv")+ "|" + request.getParameter("cmbSub") + "|" + request.getParameter("hidSuppSubAccNames"):request.getParameter("hidMasterKeys");
    String msProvIVA = msMasterKeys.split("\\|")[0];
    String msProv = msProvIVA.split("_")[0];
    String msIVA = msProvIVA.split("_")[1];
    String msAccSub = msMasterKeys.split("\\|")[1];
    String msAcc = msAccSub.split("_")[0];
    String msSub = msAccSub.split("_")[1];
    String msSuppSubAccNames = msMasterKeys.split("\\|")[2];
    String msProvName = msSuppSubAccNames.split("_")[0];
    String msSubName = msSuppSubAccNames.split("_")[1];
    DateFormat moDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    String msCurrentDate = moDateFormat.format(new Date());
	//APS
//	boolean isGasInvoice = false;

    AbcCatalog moAbcCatalog = new AbcCatalog(out,request);
    moAbcCatalog.setMasterKeys(msMasterKeys);
    moAbcCatalog.setQuery(getMainQuery(msProv, msAcc,msSub ));
   
    moAbcCatalog.initParamsLength(10);
    moAbcCatalog.setFieldNames(new String[]{"supp_name","subacc_desc","today","note_id","amount","tax","qty","comment","sn_moto", "gas_extra_data"}); //Nombre de los campos
    moAbcCatalog.setTableTitles(new String[]{"Proveedor","SubCuenta","Fecha","Factura/Remisi\u00f3n","Importe sin IVA","IVA","Piezas o unidades recibidas","Descripci\u00f3n","", ""});
    moAbcCatalog.setEditMode(new boolean[]{false,false,false,false,false,false,false,false,false, false});
    moAbcCatalog.setInsertMode(new boolean[]{false,false,false,true,true,true,true,true,false, false});
    moAbcCatalog.setValidMode(new String[]{"","","","AR",".R",".R","9R","AR","", ""});
    moAbcCatalog.setColorMode(new String[]{"","","","#66CCFF","#66CCFF","#66CCFF","#66CCFF","#66CCFF","", ""}); 
    moAbcCatalog.setTypeMode(new String[]{"text","text","text","text","text","text","text","text","hidden", "hidden"});
    moAbcCatalog.setFieldSizes(new String[]{"25","25","10","10","10","10","10","45","20", "100"});
    moAbcCatalog.setOperations(new boolean[]{false,true,false,false,false});

    if (msOperation.equals("U")) 
        updateTables(request,out,moAbcCatalog, msProv, msAcc, msSub, msCurrentDate);
    else
    {
        giUpdates = 0;
        gsNotes   = "";
    }        

    String tax1 = "";
    String tax2 = "";
    String tax3 = "";
    String strLine;

    try {
        FileInputStream fstream = new FileInputStream("/usr/local/tomcat/webapps/ROOT/Files/taxes.txt");
	File            file    = new File("/usr/local/tomcat/webapps/ROOT/Files/taxes.txt");
	DataInputStream in      = new DataInputStream(fstream);
	BufferedReader  br      = new BufferedReader(new InputStreamReader(in));

	if (file.exists()) {
	    while ((strLine = br.readLine()) != null) {
	        StringTokenizer tokenizer = new StringTokenizer(strLine, "|");
		tax1 =  tokenizer.nextToken();
		tax2 =  tokenizer.nextToken();
		tax3 =  tokenizer.nextToken();
	    }
	}

	in.close();
    } catch (Exception e) {
        System.out.println("Error: " + e.getMessage());
    }

%>

<html>
    <head>
        <title>Captura de facturas</title>
        <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
    </head>
    <script src='/Scripts/RemoteScriptingYum.js'></script>
    <script src='/Scripts/Chars.js'></script>
    <script>
        var liUpdates = <%= giUpdates %>;
        var lsNotes   = "<%= gsNotes %>";
        var gsProvId  = "<%= msProv %>";
        var giLastInserted = 0;

        function printDialog()
        {
            if(liUpdates>0){
				//APS
				loTable = document.getElementById("tblMdx");
				liRows = loTable.rows.length - 2;
				var subcuenta = document.getElementById('subacc_desc|'+liRows).value = '<%=msSubName%>';
				if(subcuenta=="GAS"){
	                openDialog("InvoicePrintYum.jsp?notes="+lsNotes+"&isGas=true",370,220);
				}else{
	                openDialog("InvoicePrintYum.jsp?notes="+lsNotes+"&isGas=false",370,220);
				}
			}
        }

/*****************************
    function gridCustomSettings(){
                objFrm=document.getElementById("frmGrid");
                objTable = document.getElementById("tblMdx");
                    for(i=0;i<objTable.rows.length-1; i++){
                        document.getElementById('chkRowControl|'+i).checked=true;
                        document.getElementById('chkRowControl|'+i).value=2;
                         //document.getElementById('suggested_equivalent|'+i).value=addSeparators(document.getElementById('suggested_equivalent|'+i).value, '.', '.', ',');
                        document.getElementById('provider_price|'+i).value=addSeparators(document.getElementById('provider_price|'+i).value,'.', '.', ',');
                    }
        }

	******************************/

	function onAfterInsertCustomAction(){
		loTable = document.getElementById("tblMdx");
		liRows = loTable.rows.length - 2;
		document.getElementById('supp_name|'+liRows).value = '<%=msProvName%>';
		document.getElementById('subacc_desc|'+liRows).value = '<%=msSubName%>';
		document.getElementById('today|'+liRows).value = '<%=msCurrentDate%>';
        //Tamanio maximo del campo descripcion
        document.getElementById('comment|'+liRows).maxLength = 150;
        document.getElementById('note_id|'+liRows).setAttribute("onBlur","onBlur=validateNoteId("+liRows+")");
        giLastInserted = liRows;
			var subcuenta = 		document.getElementById('subacc_desc|'+liRows).value = '<%=msSubName%>';
			//APS Se abre ventana de captura de gas indicando la fila del registro de facturas
			if(subcuenta=='GAS'){
				openDialog("InvoiceGasCapture.jsp?notes=hola&row="+liRows,400,350);
			}
			//Motos
			if(subcuenta.search(/transporte/i) != -1){
				//openDialog("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows,400,700);
				window.open("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows,"SN","toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=400,height=700,left = 520,top = 100");
			}
	}
	function loadGasPopup(){
		openDialog("InvoiceGasCapture.jsp?notes=hola&row="+giLastInserted,400,350);
	}
	function loadMotoSNPopup(){
		//openDialog("InvoiceMotoSNCapture.jsp?notes=hola&row="+giLastInserted,400,700);
		window.open("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows, "SN", "toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=400,height=700,left = 520,top = 100");
	}
	function continueValidation(psResult)
    {
        var loEntry = document.getElementById('note_id|'+giLastInserted);

        if(psResult == "TRUE")
        {
            var lsMesg  = 'El n'+_uAccute+'mero de factura/remisi'+_oAccute+'n ';
            lsMesg += loEntry.value + ' ya existe para este proveedor.';
            lsMesg += ' Verificarlo! ';
            alert(lsMesg);
            focusElement(loEntry.id);
            return false;
        }
        else
        {
            unfocusElement(loEntry.id);
            return true;
        }
    }
    function validateNoteId(piRowId)
    {
        var lsNoteId = document.getElementById('note_id|'+piRowId).value;
        var params   = Array(lsNoteId, gsProvId);

        giLastInserted = piRowId;
	    jsrsExecute("RemoteMethodsYum.jsp", continueValidation, "noteExists", params);
    }

	function validateGridCustom(){
		liIVA ='<%=msIVA%>';
		loTable = document.getElementById("tblMdx");
		var subcuenta = document.getElementById('subacc_desc|'+giLastInserted).value;

		for(i=0;i<loTable.rows.length-1; i++)
        {
			if(!document.getElementById('chkRowControl|'+i)){
				continue;
			}
			if(document.getElementById('chkRowControl|'+i).value==2)
            {
                var loQty       = document.getElementById('qty|'+i);
                var loAmount    = document.getElementById('amount|'+i);
                var loTax       = document.getElementById('tax|'+i);
                var loSNMoto    = document.getElementById('sn_moto|'+i);
                var loDescrip   = document.getElementById('comment|'+i);
                var dec_number  = /[^0-9.]/;
                var int_number  = /[^0-9]/;

		var chars_not_allowed = /[\|\!\"\#\%\&\'\?\}\{\^\`\[\]]/ig;

		loDescrip.value = loDescrip.value.replace(chars_not_allowed,""); 
  
                importe  = parseFloat(loAmount.value);
                impuesto = parseFloat(loTax.value);
  
                //tasa1 = importe * 0; //Tasa de 0%
                tasa1 = importe * <%=tax1%>; //Tasa de 0%
                //tasa2 = importe * 0.1; //Tasa de 10%
                tasa2 = importe * <%=tax2%> //Tasa de 10%
                //tasa3 = importe * 0.15; //Tasa de 15%
                tasa3 = importe * <%=tax3%>; //Tasa de 15%

                if((impuesto != tasa1) && (impuesto <=(tasa2 - 0.1) || 
                    impuesto >=(tasa2 + 0.1)) && ((impuesto <=(tasa3 - 0.1) || 
                    impuesto >=(tasa3 + 0.1))))
                {
   	                alert("Impuesto no coincide con importe");
                    focusElement('tax|'+i);
                	
	                return(false);
                }

                if (loQty.value.search(int_number)>=0 || loQty.value=="")
                {
                    alert ("Piezas/Unidades es un numero invalido");
                    focusElement('qty|'+i);
                    return(false);
                }
		if(subcuenta=='MTTO. EQ. TRANSPORTE' || subcuenta =='MANTTO. EQ. TRANSPORTE' || subcuenta =='MTTO. EQ. DE TRANSPORTE'){
		    if(loSNMoto.value == "N/E") {
		        alert("Favor de ingresar un num. de serie para la motocicleta");
			//openDialog("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows,400,700);
		        window.open("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows,"SN", "toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=400,height=700,left = 520,top = 100");
			return(false);
		    }
		}
			}
		}
		if(subcuenta=='GAS'){
				alert("Recuerde apuntar en la nota del proveedor de gas la carga según Yum a mano");
		}
		return(true);
	}
    </script>
    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>
    <script src="/Scripts/CalendarYum.js"></script>

    <body onLoad = 'parent.adjustPageSettings(); printDialog();' OnResize = 'adjustTableSize();' bgcolor='white'>

        <%
            moAbcCatalog.generatePage();
        %>

    </body>
</html>

<%!

    String getSequenceId()
    {
        return moAbcUtils.queryToString("SELECT next_noteid()","","");
    }

    /*Returns a String with the format DDDYY for the current date*/
    String getDateId()
    {
        Calendar calendar = Calendar.getInstance();
        Integer dayOfYear = new Integer(calendar.get(Calendar.DAY_OF_YEAR));

        DateFormat moDateFormat = new SimpleDateFormat("yy");
        String lsCurrentYear = moDateFormat.format(new Date());

        return Str.padZero(dayOfYear.toString(), 3) + lsCurrentYear;
    }

    String getMainQuery(String psProv, String psAcc, String psSub)
    {
        String lsQuery = "";
        lsQuery += " SELECT rtrim(a.supp_name) as supp_name, rtrim(c.sub_acc_desc) as subacc_desc, ";
        lsQuery += " CURRENT_DATE as today, d.note_id, d.amount, d.tax, d.qty, d.comment, d.sn_moto, d.gas_extra_data";
        lsQuery += " FROM  op_gsv_cat_supplier a ";
        lsQuery += " INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id ";
        lsQuery += " INNER JOIN op_gsv_cat_sub_account c ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id";
	    lsQuery += " INNER JOIN op_gsv_note d ON b.supp_id=d.supp_id AND b.sub_acc_id=d.sub_acc_id AND b.acc_id=d.acc_id";
        lsQuery += " WHERE  d.cap_date=CURRENT_DATE ORDER BY d.cap_date DESC";
        
        return(lsQuery);
    }

    void updateTables(HttpServletRequest poRequestHandler, JspWriter poOutputHandler, AbcCatalog poAbcCatalog, String psProvId, String psAccId, String psSubId, String psCurrentDate) {
        AbcUtils moAbcUtils = new AbcUtils();
        Enumeration loParameters = poRequestHandler.getParameterNames();
        String lsClientIP = poRequestHandler.getRemoteAddr();
        String lsParamName;
        String laFieldNames[] = poAbcCatalog.getFieldNames();
        boolean lbFlagUpdate = false;

        gsNotes = "";
        giUpdates = 0;

        try {
            while((lsParamName=(String)loParameters.nextElement())!=null) {
                if (lsParamName.indexOf("chkRowControl")!=-1) {
                    String lsAction = poRequestHandler.getParameter(lsParamName);
                    String lsParamNumber = lsParamName.substring(lsParamName.indexOf('|')+1);
                    String lsOperation = "";


		            String lsNoteId  = poRequestHandler.getParameter("note_id|" + lsParamNumber);
                    String lsAmount  = poRequestHandler.getParameter("amount|" + lsParamNumber);
        		    String lsTax     = poRequestHandler.getParameter("tax|" + lsParamNumber);
		            String lsQty     = poRequestHandler.getParameter("qty|" + lsParamNumber);
        		    String lsComment = poRequestHandler.getParameter("comment|" + lsParamNumber);
        		    String lsSNMoto  = poRequestHandler.getParameter("sn_moto|" + lsParamNumber);
        		    String lsExtraGas= poRequestHandler.getParameter("gas_extra_data|" + lsParamNumber);

			    if( lsSNMoto.equals("N/E") ) {
			        lsSNMoto = "VACIO";
		            } 
                            if( lsExtraGas.equals("N/E") ) {
			        lsExtraGas = "VACIO";
			    }
			   
					String lsUnit    = Str.padZero(getStoreId(), 3);
                    String lsSeqId   = Str.padZero(getSequenceId(), 2);
                    String lsFolio   = lsUnit + getDateId() + lsSeqId;

                    if (lsAction.equals("2")) 
                    {
                        String lsUpdateQuery = "INSERT INTO op_gsv_note(note_id,supp_id, acc_id,  sub_acc_id, amount, tax, qty, comment,cap_date, consecutive, sn_moto, gas_extra_data) VALUES(?,?,?,?,?,?,?,?,CURRENT_DATE,?,?,?)";

			String laParams[] = {lsNoteId,psProvId, psAccId, psSubId, lsAmount, lsTax , lsQty , lsComment, lsFolio, lsSNMoto, lsExtraGas};

                        moAbcUtils.executeSQLCommand(lsUpdateQuery,laParams);
                        
                        giUpdates++;
                        gsNotes = gsNotes + "'" + lsNoteId + "',";

                        //Append to ASCII File
    //UNIT|NOTE_ID|NOTE_TAX|NOTE_QTY|NOTE_DATE|SUPP_ID|NOTE_DESC|ACC_SUB_ACC|NOTE_COMMENT|NOTE_AMOUNT|
    //21|ez001|15.00|120.00|2005-04-27|100916| Esta es la descripcion de la factura ez001|6620.004|VACIO|100.00|

                        DateFormat loDateFormat = new SimpleDateFormat("yy-MM-dd");
                        String lsCurrentDate    = loDateFormat.format(new Date());
                        String lsPathShell      = "/usr/local/tomcat/webapps/ROOT/Scripts/invoice.s";
                        String lsFile           = "/usr/fms/op/rpts/fact/"+lsCurrentDate+".txt";
                        String lsRecord         = lsUnit + "|" + lsNoteId + "|" + lsTax + "|" + lsQty + "|"  ;
                        lsRecord += psCurrentDate + "|" + psProvId + "|" + lsComment + "|" + psAccId + "." + psSubId ;
                        lsRecord += "|VACIO|" + lsAmount + "|" + lsFolio + "|" + lsSNMoto + "|";
                        String laCommand[]      = {lsPathShell, lsFile, lsRecord};

                        try {
                            Process loStatus= Runtime.getRuntime().exec(laCommand);
                        } 
                        catch(Exception poException) {
                            System.out.println("Error en la generación del registro en archivo ASCII.");
                        }
			// Write gas file
			if (!lsExtraGas.equals("VACIO")) {
			    lsRecord         = lsUnit + "|" + lsNoteId + "|" + lsExtraGas + "\n";
			    try {
			        FileWriter fstream = new FileWriter("/usr/fms/op/rpts/fact/"+lsCurrentDate+".gas", true);
			        BufferedWriter out = new BufferedWriter(fstream);
			        out.write(lsRecord);
			        out.close();
			    } catch (Exception e) {
			        System.out.println("Error en la generacion del registro en archivo ASCII.");
			    }
			}
                    }
                }
            }
            
        } catch(Exception e) {}

        if(giUpdates > 0)
        {
            gsNotes = gsNotes.substring(0, gsNotes.length() - 1);
            System.out.println("gsNotes: " + gsNotes);
        }
    }
%>


