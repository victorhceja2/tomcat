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
        String isEmplFlg = "N";
        
        String emplID = " ";
        String emplPwd = " ";
        String emplName = " ";
        String permPed = "Y";
        String permCob = "Y";
        String valCve = "10";
        String nivPed = "10";
        String segLev = " ";
        String msEmpRFC = " ";
        
        boolean isEmplOk = false;
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation = request.getParameter("hidOperation");
    if (msOperation==null) return;
        String msEmployee = request.getParameter("cmbAsoc");
        if (msEmployee == null) return;
        
        
        msEmpRFC = msEmployee.split(" ")[0];
        
        try{
            if( msEmpRFC.length() < 0 && msEmployee != null )
                msEmpRFC = msEmployee.split(" ")[1];
        }catch(Exception e){return;}
        
        isEmplFlg = isInSUS( msEmpRFC );
        
        if( isEmplFlg.equals("Y") ){
            isEmplOk = true;
        } else if ( isEmplFlg.equals("N") ){
            isEmplOk = false;
        }
        
        String[] emplDataFMS = fillEmplData( msEmpRFC );
        String[] emplData = fillEmplDataSUS( msEmpRFC );
        
        
        try{
            if( isEmplOk ){
                emplData[0] = emplData[0].substring(4);
            }else{
                
                emplData[2] = emplDataFMS[1] + " " + emplDataFMS[3];
                if( emplDataFMS[1].length() > 5 )
                    emplData[0] = emplDataFMS[1].substring(0,4);
                else
                    emplData[0] = emplDataFMS[1];

                if( emplData[2].length() > 20 )
                    emplData[2] = emplData[2].substring(0,19);
                
                emplData[5] = "0";
                emplData[7] = "03";
            }
        }catch(Exception e){return;}
        
        
        
        String nameCC = getStoreName();
	String idCC = getStore();
        
        //HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
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
        
        <script>
            var isValidEmpl = <%= isEmplOk %>;
            
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
            
            function checkEmpty( ele ){
                var n = ele.value;
                if( n.length == 0 ){
                    alert ('El campo no puede estar vacio.' );
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
                if( document.frmGrid.txtPwd1.value != document.frmGrid.txtPwd2.value ){
                    alert('La contraseña no coincide.');
                    focusElement( "txtPwd1" );
                    focusElement( "txtPwd2" );
                    return(false);
                }else{
                    unfocusElement( "txtPwd1" );
                    unfocusElement( "txtPwd2" );
                }
                
                
                if( document.frmGrid.txtPwd1.value.length < 2  ){
                    alert('La contraseña debe contener al menos 2 caracteres');
                    focusElement( "txtPwd1" );
                    focusElement( "txtPwd2" );
                    return(false);
                }else{
                    unfocusElement( "txtPwd1" );
                    unfocusElement( "txtPwd2" );
                }
                
                if( document.frmGrid.txtTiempo.value.length == 0 ){
                    focusElement( "txtTiempo" );
                    errors = true;
                }else{
                    unfocusElement( "txtTiempo" );
                }
                
                if( document.frmGrid.txtID.value.length == 0 ){
                    focusElement( "txtID" );
                    errors = true;
                }else{
                    unfocusElement( "txtID" );
                }
                
                if( document.getElementById('cmbSecLev').value == "-1"){
                    errors = true;
                    focusElement( "cmbSecLev" );
                }else{
                    unfocusElement( "cmbSecLev" );
                }
                
                if( errors ){
                    alert('Se han encontrado errores. Verifique sus datos, por favor.');
                    return (false);
                }else{
                    myUpperCase( document.getElementById("txtID") );
                    document.frmGrid.submit();
                }
            }
            
            function selectCombos(){
                var seclevempl = <%= emplData[7] %>;
                var i;
                if( seclevempl != null && seclevempl != "" ){
                    var n ;
                    for(i = 1; i <= document.frmGrid.cmbSecLev.length; i++ ){
                        n = parseInt(document.frmGrid.cmbSecLev.options[i].value.split(" ", 1));
                        if ( n == parseInt(seclevempl) ){
                           document.frmGrid.cmbSecLev.options[i].selected = true;
                           return;
                        }
                    }
                }else{
                    return;
                }
            }
            
            function initData(){
                if ( isValidEmpl == true ){

                }else{
                    var ans = confirm('El empleado no esta dado del alta en SUS.\nDesea darlo de alta?');
                    if( ans == true ){
                        document.frmGrid.txtNombreCompleto.removeAttribute("readonly");
                        document.frmGrid.txtNombreCompleto.className = "input_cell";
                        document.frmGrid.txtID.removeAttribute("readonly");
                        document.frmGrid.txtID.className = "input_cell";
                    }else{
                        parent.loadFMSTab();
                    }
                }
                selectCombos();
            }
            
            
        </script>
        
    </head>
    
    <body bgcolor="white" onLoad="initData();">
        <div id="spiffycalendar" class="text">&nbsp;</div>
        <form name="frmGrid" id="frmGrid" method="post" action="EmployeePasswd.jsp">
            <table align="left" width="25%" border="0">
                <tr>
                    <td class="tr_title">
                        <input type='button' value='Actualizar' onClick="submitData()"/>
                        <input type="hidden" name="Pantalla" value="SUS"/>
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
                        <table align="left" width="50%" border="0">
                        <tr class="tr_text">
                            <td>ID de Usuario:</td>
                            <td align="left">
                                <input readonly="readonly" class="fixed_input_cell" type='text' id='txtID' name='txtID' size = '7' maxlength = '5' value="<%= emplData[0] %>" onchange="myUpperCase(this); checkEmpty(this);"/>
                            </td>
                            <td>No. Empleado:</td>
                            <td align="left">
                                <input readonly="readonly" class="fixed_input_cell" type='text' id='txtNoEmpl' name='txtNoEmpl' size = '8' maxlength = '6' onchange="myUpperCase(this);" value="<%= msEmpRFC %>"/>
                            </td>
                        </tr>
                        <tr class="tr_text">
                            <td>Contrase&ntilde;a:</td>
                            <td align="left">
                                <input class="input_cell" type='password' id='txtPwd1' name='txtPwd1' size = '6' maxlength = '4' onChange="checkEmpty(this);" value="<%= emplData[1] %>"/>
                            </td>
                            <td>Verificar contrase&ntilde;a:</td>
                            <td align="left">
                                <input class="input_cell" type='password' id='txtPwd2' name='txtPwd2' size = '6' maxlength = '4' onChange="checkEmpty(this);" value="<%= emplData[1] %>"/>
                            </td>
                        </tr>
                        <tr class="tr_text">
                            <td>Nombre completo:</td>
                            <td align="left" colspan="2">
                                <input class="fixed_input_cell" type='text' readonly="readonly" id='txtNombreCompleto' name='txtNombreCompleto' size = '22' maxlength = '20' value="<%= emplData[2] %>" onchange="myUpperCase(this)"/>
                            </td>
                        </tr>
                        </table>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>
                <tr>
                    <td class="tr_title">
                        Permisos
                    </td>
                </tr>
                <tr>
                    <td>
                        <table align="left" width=65%" border="0">
                
                            <tr class="tr_text" >
                                <td>Permiso para tomar pedidos</td>
                                <td align="left"> 
                                <select class="input_cell" id="cmbPedidos" name="cmbPedidos" size="1" class="combos" />
                                    <% if ( emplData[4].indexOf("Y") != -1 ) {%>
                                        <option selected>Y</option>
                                        <option>N</option>
                                    <% }else{ %>
                                        <option>Y</option>
                                        <option selected>N</option>
                                    <% }%>
                                </select>
                                </td>
                                <td>Permiso para cobrar</td>
                                <td align="left"> 
                                <select class="input_cell" id="cmbCobrar" name="cmbCobrar" size="1" class="combos" />
                                    <% if ( emplData[8].indexOf("Y") != -1 ) {%>
                                        <option selected>Y</option>
                                        <option>N</option>
                                    <% }else{ %>
                                        <option>Y</option>
                                        <option selected>N</option>
                                    <% }%>
                                </select>
                                </td>
                            </tr>
                            <tr class="tr_text" >
                                <td>Tiempo de validez de clave
                                    <br/>
                                    <small>[-1: indefinida, 0: por orden, xx: segundos (m&iacute;nimo 10 ]</small></td>
                                <td align="left">
                                    <input class="input_cell" type='text' id='txtTiempo' name='txtTiempo' size = '4' maxlength = '2' onchange="myUpperCase(this); isNumber(this)"  value="<%= emplData[5] %>"/>
                                </td>
                                <td>Nivel de seguridad</td>
                                <td align="left"> 
                                <select class="input_cell" id="cmbSecLev" name="cmbSecLev" size="1" class="combos" />
                                    <option value="-1" selected> -- Seleccione una opci&oacute;n -- </option>
                                    <% writeMenu(out, getDataSUS(1)); %>
                                </select>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>

