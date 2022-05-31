<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrdenYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : AKG/IF
# Objetivo        : Contenedor principal de la pantalla de captura de órdenes
# Fecha Creacion  : 14/Septiembre/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Recepción de Ordenes de Compra";
    AbcUtils moAbcUtils = new AbcUtils();
%>

<html>
    <head>
        <title>Recepción de Orden de Compra</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>


    <script src="/Scripts/AbcUtilsYum.js"></script>
    <script src="/Scripts/GenerateCombo.js"></script>


    <script>
       var gaKeys = new Array('txtNumEmp');

        function printDetail() {
            executeDetail();
        }

        function adjustPageSettings() {
            adjustContainer(60,260);
        }

        

        function showDetail() {
            openDialog('ChooseProductsYum.jsp',640,480,setValue);
        }


        function setValue() {
            var lsValue = dialogWin.returnedValue;
            //alert(lsValue);
        }

function validar() {
  if (document.form1.type.selectedIndex == 0){
    alert("Debes seleccionar almenos la orden de compra");
    return (false);
}
 else{
  window.document.form1.sOrder.value = document.form1.type.options[document.form1.type.selectedIndex].text;
  window.document.form1.sRemission.value = document.form1.model.options[document.form1.model.selectedIndex].text;
  window.document.form1.submit();
  
   // showDetail();
    //alert(document.form1.make.options[document.form1.make.selectedIndex].text+"   "+document.form1.type.options[document.form1.type.selectedIndex].text+"    "+document.form1.model.options[document.form1.model.selectedIndex].text);
  }
}

function cadena(){
    //document.form1.valor = document.form1.model.options[document.form1.model.selectedIndex].text;
    alert("paso por aqui");
    return(true);
}


function newReception(){                                            
           window.document.form1.sOrder.value = '-1';
           window.document.form1.sRemission.value = '-1'; 
           document.form1.action='ReceptionDetailYum.jsp';
           document.form1.submit();                
        }

</script>




<script language="javascript">

var hide_empty_list=true;
addListGroup("remision", "proveedores");

addList("proveedores", "Selecciona Proveedor", "", "vacio");
   addList("vacio", "---------", "", "empty");
      addOption("empty", "---------", "");

<jsp:include page = 'RemissionCombo.jsp'/>



</script>


        
    </head>    

<body onload="initListGroup('remision', document.forms[0].make, document.forms[0].type, document.forms[0].model)" onResize='adjustPageSettings();' bgcolor = 'white' OnLoad = 'abcSearch();'>

<table align="center" cellpadding="0" cellspacing="0" border="0" width="90%">
<tr>
   <td>
         <form name='form1' target='testiframe2' action='ReceptionDetailYum.jsp'>
               <table align="center">
               <tr>
                 <td><input type="hidden" name="sOrder"></td>
                 <td><input type="hidden" name="sRemission"></td>
                 <td><select name="make" style="width:160px;"></select></td>
                 <td><select name="type" style="width:160px;"></select></td>
                 <td><select name="model" style="width:160px;"></select></td>
                 <td><input type="button" value="  Mostrar  " onclick='validar();'>
                 <td><input type="button" value="  Recepción Nueva  " onclick='newReception();'>
               </tr>
               </table>
         </form>
    </td>
</tr>
</table>


<iframe src="ReceptionDetailYum.jsp"
	id="testiframe2"
        name="testiframe2"
        style="width: 100%;
        height: 270px;
	margin-left: 0%;
	border: 0px solid #000000;"
></iframe>


</body>
</html>

