<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : NewEmployeeDetail.jsp
# Compania        : Premium Restaurant Brands
# Autor           : Erick Mejia (Stark)
# Objetivo        : Reemplazo de pantalla de empleados de FMS
# Fecha Creacion  : 23/Feb/2012
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/EmployeeLib.jsp" %>

<%! 
        AbcUtils moAbcUtils = new AbcUtils();
%>

<%
        String msOperation = request.getParameter("hidOperation");
        if (msOperation == null) return;
        //Default "S"

        String msEmployee = request.getParameter("cmbAsoc");
        if (msEmployee == null) return;
        
        String msEmpRFC = " ";
        msEmpRFC = msEmployee.split(" ")[0];
        
        try{
            if( msEmpRFC.length() < 0 && msEmployee != null )
                msEmpRFC = msEmployee.split(" ")[1];
            
        String tmpFile2="/tmp/webapp0.asc";
        FileWriter tmpF2 = new FileWriter( tmpFile2, false );
        PrintWriter pw2 = new PrintWriter(tmpF2);
        pw2.println( msEmpRFC );
        pw2.println( msOperation );
        tmpF2.close();
        }catch(Exception e){return;}
        
        String[] emplData = fillEmplData( msEmpRFC );
        
        ArrayList<String> tmpArrStr = getDataFMS(0);
        String[] emplTipos = tmpArrStr.toArray( new String[tmpArrStr.size()] );
        tmpArrStr = getDataFMS(2);
        String[] emplPuestos = tmpArrStr.toArray( new String[tmpArrStr.size()] );
        
        String nameCC = getStoreName();
	String idCC = getStore();
        
        HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
        moHtmlAppHandler.setPresentation("VIEWPORT");
        moHtmlAppHandler.initializeHandler();	
        moHtmlAppHandler.msReportTitle = getCustomHeader("New Employee", "frmGrid");
        moHtmlAppHandler.updateHandler();
        moHtmlAppHandler.validateHandler();

%>

<html>
    <head>
        <title>Formato de captura</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridInputYum.css"/>
        <link rel='stylesheet' type="text/css" href='/CSS/CalendarStandardsYum.css'/>
        <link rel="stylesheet" type="text/css" href="../CSS/spiffyCal.css"/>
        <link rel='stylesheet' type="text/css" href='/CSS/TabStandardsYum.css' />
        
        
        <div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>
        
        <style>
            .tr_title{
                font-size:   11px;
                color: #800000;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: left;
            }
            .tr_text{
                font-size:   11px;
                color: #000099;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-weight: bold;
                text-align: right;
            }
            .disabled_label{
                font-size:   11px;
                color: #C0C0C0;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                text-align: right;
            }
            .input_cell{
                border: 1px solid blue;
                font-size:   12px;
                color: #000099;
                background-color: #E0FFFF;
            }
            .fixed_input_cell{
                border: 1px solid white;
                font-size:   12px;
                color: #00008B;
                background-color: #E6E6FA;
                text-align: right;
            }
        </style>
        
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/CalendarYum.js"></script>
        <script src="../Scripts/CalendarFMS.js"></script>
        <script src="../Scripts/EmployeeBatch.js"></script>
        
        <script type="text/javascript" >
            var loGrid = new Bs_DataGrid('loGrid');
            var totGrid = new Bs_DataGrid('totGrid');
                
            function checkRepart(){
                var x = document.getElementById("txtNoLic");
                var y = document.getElementById("txtVencLic");
                if( document.getElementById("cmbPuesto").value == "57 6 Repartidor" ){
                    x.removeAttribute('readonly');
                    y.removeAttribute('readonly');
                    document.getElementById("labNoLic").className = "tr_text";
                    document.getElementById("labVencLic").className = "tr_text";
                }else{
                    x.value = "";
                    y.value = "";
                    x.setAttribute('readonly', 'readonly');
                    y.setAttribute('readonly', 'readonly');
                    document.getElementById("labNoLic").className = "disabled_label";
                    document.getElementById("labVencLic").className = "disabled_label";
                }
            }

	    function checkClave(){
		var x = document.getElementById("txtCLAVE");
		console.log(document.getElementById('cmbNivSeg').value);
		if ( document.getElementById('cmbNivSeg').value.split(" ", 1) == "3" ) {
		    x.removeAttribute('readonly');
		    document.getElementById("labClave").className = "tr_text";
		}else{
		    x.value = "";
		    x.setAttribute('readonly', 'readonly');
		    document.getElementById("labClave").className = "disabled_label";
		}
	    }
            
            function myUpperCase( ele ) {
                var n = ele.value;
                ele.value = n.toUpperCase();
            }
            
            function checkLength( ele, lShbe ){
                myUpperCase( ele );
                var n = ele.value;
                if( n.length < lShbe ){
                    alert ('La longitud del campo debe ser de '+ lShbe + ' caracteres.' );
                    focusElement( ele.id );
                    return -1;
                }else{
                    unfocusElement( ele.id );
                    return 0;
                }
            }
            
            function isNumber( ele ) {
                var n = ele.value;
                if( n != "" )
                    if( !( !isNaN(parseFloat(n)) && isFinite(n) ) || parseInt(n) < 0  ){
                        alert ('Tipo de datos incorrecto.');
                        focusElement( ele.id );
                    }else{
                        unfocusElement( ele.id );
                    }
                else
                    unfocusElement( ele.id );
            }
            
            function submitData(){
                var errors = false;
                var rfcempl = document.getElementById('txtRFC').value;
                var noempl = document.getElementById('txtNoEmpl').value;
                
                if( document.frmGrid.txtID.value.length > 2 ){
                    focusElement( "txtID" );
                    document.frmGrid.txtID.value = document.frmGrid.txtID.value.substring(0,2);
                    errors = true;
                }else{
                    unfocusElement( "txtID" );
                }
                
                if( document.frmGrid.txtNo.value.length > 4 ){
                    focusElement( "txtNo" );
                    document.frmGrid.txtNo.value = document.frmGrid.txtNo.value.substring(0,4);
                    errors = true;
                }else{
                    unfocusElement( "txtNo" );
                }
                
                if( document.frmGrid.txtCP.value.length > 5 ){
                    focusElement( "txtCP" );
                    document.frmGrid.txtCP.value = "";
                    errors = true;
                }else{
                    unfocusElement( "txtCP" );
                }
                
                if( document.getElementById('cmbTipEmpl').value == "-1" || document.getElementById('cmbNivSeg').value == "-1" 
                    || document.getElementById('cmbPuesto').value == "-1" )
                    errors = true;
                
                rfcempl = rfcempl.replace(/^\s*|\s*$/g,"");
                if( rfcempl.length < 13 ){
                    errors = true;
                    focusElement( "txtRFC" );
                }else
                    unfocusElement( "txtRFC" );
                
                
                if( noempl.length < 0 ){
                    errors = true;
                }
                
                if( document.getElementById('txtNoLic').getAttribute('readonly') != 'readonly' )
                    if( document.getElementById('txtNoLic').value.length < 1 ){
                        focusElement( "txtNoLic" );
                        errors = true;
                    }               
		if ( document.getElementById('txtCLAVE').getAttribute('readonly') != 'readonly' )
                    if( document.getElementById('txtCLAVE').value.length != 2 ){
			console.log(document.getElementById('txtCLAVE').value.length);
                        focusElement( "txtCLAVE" );
                        errors = true;
                    }
                if( errors ){
                    alert('Verifique sus datos, por favor.');
                    return (false);
                }else{
                    myUpperCase( document.getElementById("txtRFC") );
                    document.frmGrid.submit();
                }
            }
            
            function selectCombos(){
                var rfcempl = document.frmGrid.txtRFC.value;
                var tipempl = <%= emplData[14] %>;
                var puestoempl = <%= emplData[17] %>;
                var secLevEmpl = <%= emplData[21] %>;
                var i;
                
                if( rfcempl.length < 13 ){
                    var x = document.getElementById("txtRFC");
                    document.frmGrid.txtRFC.value = "";
                    x.removeAttribute('readonly');
                    x.className = "input_cell";
                }
                    
                if( tipempl != null && puestoempl != null && secLevEmpl != null ){
                    var n ;
                    for(i = 1; i < document.frmGrid.cmbTipEmpl.length; i++ ){
                        n = document.frmGrid.cmbTipEmpl.options[i].value.split(" ", 1);
                        if ( n == tipempl ){
                           document.frmGrid.cmbTipEmpl.options[i].selected = true;
                        }
                    }
                    for(i = 1; i < document.frmGrid.cmbPuesto.length; i++ ){
                        n = document.frmGrid.cmbPuesto.options[i].value.split(" ", 1);
                        if ( n == puestoempl ){
                           document.frmGrid.cmbPuesto.options[i].selected = true;
                        }
                    }
                    for(i = 1; i < document.frmGrid.cmbNivSeg.length; i++ ){
                        n = document.frmGrid.cmbNivSeg.options[i].value.split(" ", 1);
                        if ( n == secLevEmpl ){
                           document.frmGrid.cmbNivSeg.options[i].selected = true;
                        }
                    }
                    checkRepart();
                    checkClave();
                }else{
                    return;
                }
            }
        </script>
        
    </head>
    
    <body bgcolor="white" onLoad="selectCombos()">
        <div id="spiffycalendar" class="text">&nbsp;</div>
        <form name="frmGrid" id="frmGrid" method="post" action="EmployeeVerifyID.jsp">
            <%if( msOperation != null ){ %>
            <table align="left" width="25%" border="0">
                <tr>
                    <td class="tr_title">
                        <input type='button' value='Actualizar' onClick="submitData()"/>
                        <input type="hidden" name="Pantalla" value="FMS"/>
                    </td>
                </tr>
            </table>
            
            <br>
            <table align="left" width="90%" border="0">
                <tr>
                    <td class="tr_title">
                        Informaci&oacute;n personal
                    </td>
                </tr>
                <tr>
                    <td>
                        <table align="left" width="95%" border="0">
                        <tr class="tr_text">
                            <td>RFC: </td>
                            <td align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtRFC' name='txtRFC' size = '15' maxlength = '13' onchange="myUpperCase(this)" value="<%= emplData[0] %>"/>
                            </td>

                            <td>No. Empleado:</td>.
                            <td align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtNoEmpl' name='txtNoEmpl' size = '6' maxlength = '6' onchange="isNumber(this); checkLength(this,6)" value="<%= msEmpRFC %>"/>
                            </td>
                            <td>&nbsp;</td><td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr class="tr_text">
                            <td>Ap. Paterno: </td>
                            <td align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtApPat' name='txtApPat' size = '16' maxlength = '16' onchange="myUpperCase(this)" value="<%= emplData[3] %>"/>
                            </td>
                            <td>Ap. Materno: </td>
                            <td colspan="2" align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtApMat' name='txtApMat' size = '16' maxlength = '16' onchange="myUpperCase(this)" value="<%= emplData[4] %>"/>
                            </td>
                            <td>Nombre(s): </td>
                            <td align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtNombre' name='txtNombre' size = '16' maxlength = '16' onchange="myUpperCase(this)" value="<%= emplData[1] %>"/>
                            </td>
                        </tr>
                        <tr class="tr_text">
                            <td>Fecha Nac.: </td>
                            <td align="left">
                                <input class="fixed_input_cell" readonly="readonly" type='text' id='txtFechNac' name='txtFechNac' size = '11' maxlength = '10'  value="<%= emplData[10] %>"  readonly/>
                            </td>
                            <td>Sexo:</td>
                            <td align="left"> 
                                <select class="input_cell" id="cmbSexo" name="cmbSexo" size="1" class="combos" />
                                <% if ( emplData[11].indexOf("F") != -1 ) {%>
                                    <option>M</option>
                                    <option selected>F</option>
                                <% }else{ %>
                                    <option selected>M</option>
                                    <option>F</option>
                                <% }%>
                                </select>
                            </td>
                        </tr>
                        <tr class="tr_text">
                            <td>Calle: </td>
                            <td align="left">
                                <input class="input_cell" type='text' id='txtCalle' name='txtCalle' size = '16' maxlength = '17' value="<%= emplData[6] %>" onchange="myUpperCase(this)"/>
                            </td>
                            <td>No: </td>
                            <td align="left">
                                <input class='input_cell' type='text' id='txtNo' name='txtNo' size = '4' maxlength = '4' value="<%= emplData[5] %>" onchange="myUpperCase(this)"/>
                            </td>
                            <td>C.P.:</td>
                            <td align="left">
                                <input class='input_cell' type='text' id='txtCP' name='txtCP' size = '5' maxlength = '5' value="<%= emplData[8] %>" onchange="isNumber(this)" />
                            </td>
                            <td>Tel: 
                                <input class='input_cell' type='text' id='txtTel' name='txtTel' size = '9' maxlength = '10' value="<%= emplData[9] %>" onchange="isNumber(this)" />
                            </td>
                        </tr>
                        </table>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td class="tr_title">
                        Informaci&oacute;n laboral
                    </td>
                </tr>
                <tr>
                    <td>
                        <table align="left" width="95%" border="0">
                
                            <tr class="tr_text" >
                                <td>Fecha Efectiva:</td>
                                <td width="10%" align="left">
                                    <input  class="fixed_input_cell" readonly="readonly" type='text' id='txtFechEfec' name='txtFechEfec' size = '11' maxlength = '10' value="<%= emplData[13] %>" readonly/>
                                </td>
                            </tr>
                            <tr class="tr_text" >
                                <td>ACC:</td>
                                <td align="left">
                                    <input class="fixed_input_cell" readonly="readonly" type='text' id='txtACC' name='txtACC' size = '2' maxlength = '1' onchange="myUpperCase(this);" value="<%= emplData[1].charAt(0) %>"/>
                                </td>
                                <td>ID:</td>
                                <td align="left">
                                    <input class="input_cell" type='text' id='txtID' name='txtID' size = '3' maxlength = '2' onchange="myUpperCase(this);" value="<%= emplData[20] %>"/>
                                </td>
                                <td class="disabled_label" id='labClave' name='labClave'>CLAVE:</td>
                                <td align="left">
                                    <input class="input_cell" readonly="readonly" type="password" id='txtCLAVE' name='txtCLAVE' size = '3' maxlength = '2' onchange="myUpperCase(this);" value="<%= emplData[22] %>"/>
                                </td>
				<td>DRV:</td>
				<td align="left">
				<input class="input_cell" type='text' id='txtDRV' name='txtDRV' size = '3' maxlength = '2' onchange="myUpperCase(this);" value="<%= emplData[7] %>"/>
				</td>
                            </tr>
                            <tr class="tr_text" >
                                <td>Tipo Empleado:</td>
                                <td align="left">
                                    <select class="input_cell" id="cmbTipEmpl" name="cmbTipEmpl" size="1" class="combos">
                                        <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                        <% writeMenu(out, getDataFMS(0)); %>
                                    </select>
                                </td>
                                <td>Nivel Seguridad:</td>
                                <td id="combNivelSeg" align="left">
                                    <select class="input_cell" id="cmbNivSeg" name="cmbNivSeg" size="1" class="combos" onchange="checkClave()" >
                                    <!-- <select class="input_cell" id="cmbNivSeg" name="cmbNivSeg" size="1" class="combos" > -->
                                        <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                        <% writeMenu(out, getDataFMS(1)); %>
                                    </select>
                                </td>
                            </tr>
                            <tr class="tr_text">
                                <td enable="false">Puesto</td>
                                <td align="left">
                                    <select class="input_cell" id="cmbPuesto" name="cmbPuesto" size="1" class="combos" onchange="checkRepart()">
                                    <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                    <% writeMenu(out, getDataFMS(2)); %>
                                    </select>
                                </td>
                                <td class="disabled_label" id='labNoLic' name='labNoLic'>No. Licencia</td>
                                <td align="left">
                                    <input readonly="readonly" class='input_cell' type='text' id='txtNoLic' name='txtNoLic' size = '20' maxlength = '20' value="<%= emplData[18] %>"/>
                                </td>
                                <td class="disabled_label" id='labVencLic' name='labVencLic'>Vencimiento Licencia:</td>
                                <td width="10%" align="left">
                                    <input  class="input_cell" readonly="readonly" type='text' id='txtVencLic' name='txtVencLic' size = '11' maxlength = '10' value="<%= emplData[19] %>" onclick="showCalendarFMS('frmMaster','txtVencLic','txtVencLic');" onfocus="showCalendarFMS('frmMaster','txtVencLic','txtVencLic');" readonly/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <% } %>
        </form>
    </body>
</html>

