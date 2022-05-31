 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>
 <%--
##########################################################################################################
# Nombre Archivo  : InvoiceMotoSNCapture.jsp
# Compañia        : Yum Brands Intl
# Autor           : Sergio Cuellar 
# Objetivo        : Captura de detalle de num de serie de motocicletas
# Fecha Creacion  : 01/Sep/2009
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

<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 
        String  msNotes;
        String msStoreId;
        String msTankCapacity;
        String msRequiredPer;
        String msRequiredLit;
        String msMargin;
        String msAcceptedLit;
        String msCurrentDateTime;
        String msRowNum;
%>
<%
    try
    {
          msNotes = request.getParameter("notes");
          msRowNum = request.getParameter("row");
    }
    catch(Exception e)
    {
       msNotes = "0"; 
           msRowNum = "0";
    }
                msStoreId = getStore();
                msCurrentDateTime = getCurrentDateTime();

%>
<html>
<head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPrinterYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ArrayUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/GasLibYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>

<!-- Script para mostrar dialogo de impresion -->

<script>

        function printWindow(){
                bV = parseInt(navigator.appVersion)
                if (bV >= 4) window.print()
        }

</script>

    <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
    <script language="javascript">

        liRows = '<%=msRowNum%>';

	var loGrid = new Bs_DataGrid('loGrid');

	var gaDataset = <%= getDataset() %>;

        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:15px;  background-color: transparent;' ";
	//var _class  = " class='descriptionTabla'";


	function initDataGrid(){
	    if(gaDataset.length > 0) {
	        for (var liRowId=0; liRowId<gaDataset.length; liRowId++) {
		    gaDataset[liRowId][0] = '<input type="checkbox" name="repair'+liRowId+'" '+
		                            'value="' + gaDataset[liRowId][0] + '"> ' +
					    '<span onClick="document.frmMotoSNCapture.repair'+liRowId+'.checked='+
					    '(!document.frmMotoSNCapture.repair'+liRowId+'.checked);">'+
					    gaDataset[liRowId][0]+' </span>';
		}

		props    = new Array(null);
		headers = new Array({text:'Seleccione las refacciones adquiridas:',width:'30%'});
                loGrid.isReport     = true;
		loGrid.setHeaders(headers);
		loGrid.setDataProps(props);
		loGrid.bHeaderFix   = false;
		loGrid.width        = '250';
		loGrid.height       = 30;
		loGrid.padding      = 5;
		loGrid.setData(gaDataset);
		loGrid.drawInto('goDataGrid');
	    }
	}
     
        function loadMotoSNPopup(){
            window.openDialog("InvoiceMotoSNCapture.jsp?notes=hola&row="+liRows,400,700);
        }


        function onClose(){
            if(document.frmMotoSNCapture.cmbSNMotos.value == ""){
                alert("Es necesario seleccionar un num. de serie");
                loadMotoSNPopup();
            }
        }

        function onAccept()
        {
	    var checkFound = 0;

	    var c_value = ' ';
	    
	    for (var counter=0; counter < gaDataset.length; counter++) {
	        if (eval("document.frmMotoSNCapture.repair"+counter+".checked==true")) {
		    checkFound = 1;
		    c_value = c_value + eval("document.frmMotoSNCapture.repair"+counter+".value") + ", ";
		}
	    }

	    if (checkFound == 0) {
	        alert("Por favor seleccione al menos una refacci\u00f3n");
	    } else {


            if(document.frmMotoSNCapture.cmbSNMotos.value != "" && document.frmMotoSNCapture.InputSNMoto.value == ""){
                //Actualiza el campo de descripcion en la ventana madre
                window.close();
                var lsFieldName = 'comment|'+<%= msRowNum %>;
                var lsFieldName2 = 'sn_moto|'+<%= msRowNum %>;

                top.opener.document.getElementById(lsFieldName).value="S/N Moto: "+document.frmMotoSNCapture.cmbSNMotos.value+
		                                                       " Refacciones: "+c_value;
                top.opener.document.getElementById(lsFieldName2).value=document.frmMotoSNCapture.cmbSNMotos.value;
                //top.opener.document.getElementById(lsFieldName).disabled=true;
            }
            if(document.frmMotoSNCapture.cmbSNMotos.value == "" && document.frmMotoSNCapture.InputSNMoto.value != ""){
                //Actualiza el campo de descripcion en la ventana madre
                window.close();
                var lsFieldName = 'comment|'+<%= msRowNum %>;
                var lsFieldName2 = 'sn_moto|'+<%= msRowNum %>;
                top.opener.document.getElementById(lsFieldName).value="S/N Moto: "+document.frmMotoSNCapture.InputSNMoto.value+
		                                                      " Refacciones: "+c_value;
                top.opener.document.getElementById(lsFieldName2).value= "**"+document.frmMotoSNCapture.InputSNMoto.value;
                //top.opener.document.getElementById(lsFieldName).disabled=true;
            }
	    if(document.frmMotoSNCapture.cmbSNMotos.value == "" && document.frmMotoSNCapture.InputSNMoto.value == "") {
                alert('Por favor seleccione un num. de serie o ingreselo');
            }
	    if(document.frmMotoSNCapture.cmbSNMotos.value != "" && document.frmMotoSNCapture.InputSNMoto.value != "") {
	        alert('Solo se puede ingresar un num. de serie.');
		document.frmMotoSNCapture.reset();
	    }
	    }
        }
        
    </script>
</head>
<!--<body onLoad="initDataGrid(true);">-->
<!--<body onload="javascript:document.getElementById('beginPer').focus();document.getElementById('beginPer').select()" onUnload="clearFields()"> -->
<!--<body onUnload="onClose();"> -->
<body onLoad="initDataGrid('input');">
    <p class="mainsubtitle">
        N&uacute;mero de serie de la motocicleta
    </p>

        <font class = 'descriptionTabla'>Fecha: &nbsp;<b><%= msCurrentDateTime %></b></font>
        &nbsp;&nbsp;&nbsp;&nbsp;        
        <p align="center" class="subHeadB">
        Favor de ingresar el n&uacute;mero de serie de la moto
    </p>
    <form name='frmMotoSNCapture' id= 'frmMotoSNCapture'>
                        <table id = 'tblMdx' name = 'tblMdx' border = '0'>
                        <tr class="bsTotals">
                            <td class="descriptionTabla">
                                Num. de Serie: 
                            </td>
                            <td>
                            <select id = 'cmbSNMotos' name ='cmbSNMotos' size = '1' class ='combos'>
                                 <option value="">-- Seleccione --</option>
                                 <%
                                     moAbcUtils.fillComboBox(out,"SELECT serial_num_moto,serial_num_moto FROM ss_cat_snmoto");
                                 %>
                            </select>
                            </td>
                         </tr>
			 <tr class="bsTotals">
			     <td class="descriptionTabla">
			         Otro:
			     </td>
			     <td>
			         <input class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; background-color: #66CCFF;' OnBlur = "onBlurControl(this,false);"   size='22' maxlength = '18'  type='text' id='InputSNMoto' name='InputSNMoto'>
			     </td>
			 </tr>
                        </table>
	    <div class='descriptionTabla' id="goDataGrid"></div>
	    <br>
            <center>
            <input type="button" id="btnAceptar" name="btnAceptar" value="Aceptar" onClick="onAccept()">
	    </center>
        </p>
    </form>
</body>
</html>

<%!
    String getCurrentDateTime(){
        String lsQuery = "select to_char(now(),'yyyy-mm-dd HH24:MI:SS')";
        return moAbcUtils.queryToString(lsQuery);
    }

    String getDataset(){
        //String lsQuery = "SELECT repair_name from ss_cat_repairs ORDER by repair_name";
        String lsQuery = "SELECT repair_desc FROM ss_cat_repairs_moto";
        return moAbcUtils.getJSResultSet(lsQuery);
    }
%>
