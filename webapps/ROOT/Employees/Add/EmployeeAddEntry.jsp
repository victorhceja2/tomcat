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
<%@ include file="../Edit/Proc/EmployeeLib.jsp" %>

<%! 
        AbcUtils moAbcUtils = new AbcUtils();
%>

<%
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
        <script src="../Edit/Scripts/CalendarFMS.js"></script>
        <script src="../Edit/Scripts/EmployeeBatch.js"></script>
        
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
                var fechNac = document.getElementById('txtFechNac').value;
				var fechEfec= document.getElementById('txtFechEfec').value;
                    
                if( document.getElementById('cmbTipEmpl').value == "-1" ){
                	errors = true;
                    focusElement( "cmbTipEmpl" );
                }else
                	unfocusElement( "cmbTipEmpl" );

                if( document.getElementById('cmbPuesto').value == "-1" ){
                    errors=true;
                    focusElement( "cmbPuesto" );
                }else
                	unfocusElement( "cmbPuesto" );

            	if( fechNac == "" || /^(0[1-9]|[12][0-9]|3[01])[/](0?[1-9]|1[012])[/](19|20)\d$/.test(fechNac)){
					errors=true;
					focusElement( "txtFechNac" );
                }else 
                	unfocusElement( "txtFechNac" );

            	if( fechEfec == "" || /^(0[1-9]|[12][0-9]|3[01])[/](0?[1-9]|1[012])[/](19|20)\d$/.test(fechEfec)){
					errors=true;
					focusElement( "txtFechEfec" );
                }else 
                	unfocusElement( "txtFechEfec" );
                
                rfcempl = rfcempl.replace(/^\s*|\s*$/g,"");
                if( rfcempl.length < 13 ){
                    errors = true;
                    focusElement( "txtRFC" );
                }else
                    unfocusElement( "txtRFC" );

                if( document.getElementById('txtNombre').value == "" ){
                    errors = true;
                    focusElement( "txtNombre" );
                }else
                	unfocusElement( "txtNombre" );

                if( document.getElementById('txtApPat').value == "" ){
                    errors = true;
                    focusElement( "txtApPat" );
                }else
                	unfocusElement( "txtApPat" );

                if( document.getElementById('txtApMat').value == "" ){
                    errors = true;
                    focusElement( "txtApMat" );
                }else
                	unfocusElement( "txtApMat" );
                
                if( document.getElementById('txtID').value == "" ){
                    errors = true;
                    focusElement( "txtID" );
                }else
                    unfocusElement( "txtID" );

                if( document.getElementById('txtNoEmpl').value != "" )
                    if( !( !isNaN(parseFloat( document.getElementById('txtNoEmpl').value )) && isFinite( document.getElementById('txtNoEmpl').value ) ) || parseInt( document.getElementById('txtNoEmpl').value ) < 0  ){
                        errors=true;
                        focusElement("txtNoEmpl");
                    }else{
                        unfocusElement("txtNoEmpl");
                    }
                else
                    unfocusElement('txtNoEmpl');
                                   
                if( errors ){
                    alert('Verifique sus datos, por favor.');
                    return (false);
                }else{
                    myUpperCase( document.getElementById("txtRFC") );
                    document.frmGrid.submit();
                }
            }

            function fillID(ele){
                document.getElementById('txtID').value=ele.value.slice(0,2);
            }

            function allDelete(){
   				frmGrid.reset();
       		}
        </script>
        
    </head>
    
    <body bgcolor="white">
        <div id="spiffycalendar" class="text">&nbsp;</div>
        <form name="frmGrid" id="frmGrid" method="post" action="../Edit/Entry/EmployeeVerifyID.jsp">
            <table align="left" width="25%" border="0">
                <tr>
                    <td class="tr_title">
                        <input type='button' value='Agregar' onClick="submitData()"/>
                        <input type='button' value='Limpiar' onClick="allDelete();" />
                        <input type="hidden" name="Pantalla" value="FMS"/>
                        <input type="hidden" name="Add" value="true">
                    </td>
                </tr>
            </table>
            <br>
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
                                <input class="input_cell" type='text' id='txtRFC' name='txtRFC' size = '15' maxlength = '13' onchange="myUpperCase(this)"/>
                            </td>

                            <td>No. Empleado:</td>
                            <td align="left">
                                <input class="input_cell" type='text' id='txtNoEmpl' name='txtNoEmpl' size = '6' maxlength = '6' onchange="isNumber(this);"/>
                            </td>
                            <td>&nbsp;</td><td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr class="tr_text">
                            <td>Ap. Paterno: </td>
                            <td align="left">
                                <input class="input_cell" type='text' id='txtApPat' name='txtApPat' size = '16' maxlength = '16' onchange="myUpperCase(this)"/>
                            </td>
                            <td>Ap. Materno: </td>
                            <td colspan="2" align="left">
                                <input class="input_cell" type='text' id='txtApMat' name='txtApMat' size = '16' maxlength = '16' onchange="myUpperCase(this)"/>
                            </td>
                            <td>Nombre(s): </td>
                            <td align="left">
                                <input class="input_cell" type='text' id='txtNombre' name='txtNombre' size = '16' maxlength = '16' onchange="myUpperCase(this);fillID(this);" />
                            </td>
                        </tr>
                        <tr class="tr_text">
                            <td>Fecha Nac.: </td>
                            <td align="left">
                                <input class = 'input_cell' type='text' id='txtFechNac' name='txtFechNac' size = '11' maxlength = '10' onclick="showCalendarFMS('frmMaster','txtFechNac','txtFechNac',100,10);"/>
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
                                <td align="left">
                                    <input  class="input_cell" type='text' id='txtFechEfec' name='txtFechEfec' size = '11' maxlength = '10' onclick="showCalendarFMS('frmMaster','txtFechEfec','txtFechEfec');"/>
                                </td>
                                <td>Tipo Empleado:</td>
                                <td align="left">
                                    <select class="input_cell" id="cmbTipEmpl" name="cmbTipEmpl" size="1" class="combos">
                                        <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                        <% writeMenu(out, getDataFMS(0)); %>
                                    </select>
                                </td>
                                <td>Puesto</td>
                                <td align="left">
                                    <select class="input_cell" id="cmbPuesto" name="cmbPuesto" size="1" class="combos" onchange="checkRepart()">
                                    <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                    <% writeMenu(out, getDataFMS(2)); %>
                                    </select>
                                </td>
                            </tr>
                            <tr class="tr_text" >
                                <td>ID:</td>
                                <td align="left">
                                    <input class="input_cell" type='text' id='txtID' name='txtID' size = '3' maxlength = '2' onchange="myUpperCase(this);"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>

