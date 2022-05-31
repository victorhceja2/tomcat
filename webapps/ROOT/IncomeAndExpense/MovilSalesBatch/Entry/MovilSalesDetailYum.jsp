<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : MovilSalesDetailYum.jsp
# Compania        : Premium Restaurant Brands
# Autor           : Mario Chavez Ayala
# Objetivo        : Captura de Cierre de Lote de Apl. Moviles
# Fecha Creacion  : 8/Febrero/2019
# Inc/requires    : ../Proc/MovilSalesBatchLibYum.jsp
# Observaciones   : 
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<%@page import="java.io.*" %>
<%@page import="generals.*" %>

<%! 
    AbcUtils moAbcUtils;
    String bdate = "";
    String bdate_ = "";
    String today_s = "";
    int actual_hour;
    DateFormat formatter;
    long date_business;
    long date_actual;
    Date date;
    Date tmp_date;
    Calendar calendar;
    Calendar today;
%>

<% 
    moAbcUtils = new AbcUtils();
    date = new Date();
    calendar = new GregorianCalendar();
%>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/MovilSalesBatchLibYum.jsp" %>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Cierre de Venta de Aplicaciones M&oacute;viles", "Preview");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();

    actual_hour = calendar.get(Calendar.HOUR_OF_DAY); 

    today = Calendar.getInstance();
     
    formatter = new SimpleDateFormat("yy-MM-dd");

    today_s = formatter.format(today.getTime());
    try { tmp_date = formatter.parse(today_s); } catch (ParseException e) { System.out.println("Exception :"+e); }
    date_actual = tmp_date.getTime();

    bdate = getBusinessDate().trim();
    bdate_= bdate.substring(0,2)+"-"+bdate.substring(2,4)+"-"+bdate.substring(4,6);
    try { tmp_date = formatter.parse(bdate_); } catch (ParseException e) { System.out.println("Exception :"+e); }
    date_business = tmp_date.getTime();

    createTempTable(); 

    File file_name_txt  = new File("/usr/fms/op/rpts/movilsales/"+bdate_+".txt");


%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
        <div id='popupcalendar' class='text' style='z-index:100006; position:absolute;'></div>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/CalendarYum.js"></script>
    
        <script src="../Scripts/MovilSalesBatchYum.js"></script>

        <script type="text/javascript">

        var loGrid = new Bs_DataGrid('loGrid');
        var totGrid = new Bs_DataGrid('totGrid');
        var gaDataset = <%= getDataset() %>; 
        


        function getTotals()
        {
           var totalTarjetas = 0.0;
           var ticketAverage = 0.0;
           var totalTrans    = 0;
           var SUStot = <%= getMovilSalesTotalSUS() %>;
           var totalCanc = 0.0;

            for(var liRowId=0; liRowId<giNumRows; liRowId++)
            {
                var lsMonto= "monto|"+liRowId;
                var lsTrans= "trans|"+liRowId;
                var lsCanc = "canc|"+liRowId;
                var noTerminal  = liRowId+1;
                var lsDesc      = "idterminal|"+liRowId;
                var liMonto     = document.getElementById(lsMonto).value;
                var liTrans     = document.getElementById(lsTrans).value;
                var liCanc      = document.getElementById(lsCanc).value;
                var regexMonto  = /\d+\.\d+/;
                
                if(isEmpty(liMonto))
                {
                   alert ('Ingresar valor del monto para la venta movil '+noTerminal);
                   focusElement(lsMonto);
                   return(false);
                }
                else
                {
                   //if (liMonto.match(regexMonto) == null)
                   if (isNaN(liMonto))
                   {
                      alert ('Ingresar un valor numerico valido para el monto, ejemplo 34.00');
                      focusElement(lsMonto);
                      return(false)
                   }
                }

                if(isEmpty(liCanc))
                {
                   alert ('Ingresar valor del monto para el total de cancelaciones de este agregador.');
                   focusElement(lsCanc);
                   return(false);
                }
                else
                {
                   //if (liMonto.match(regexMonto) == null)
                   if (isNaN(liCanc))
                   {
                      alert ('Ingresar un valor numerico valido para el monto, ejemplo 0.00');
                      focusElement(lsCanc);
                      return(false)
                   }
                }

                if(parseFloat(liCanc) > parseInt(liMonto))
                {
                   alert('No puedes tener ingresado un monto de cancelaciones mayor al de la venta m\u00f3vil favor de revisar');
                   focusElement(lsCanc);
                   return(false);
                }

                if(parseFloat(liMonto) >  0.0)
                {
                   if(parseInt(liTrans) == 0)
                   {
                      alert('No puedes tener ingresado un monto de $'+liMonto+' con cero transacciones en venta m\u00f3vil '+noTerminal+' favor de revisar');
                      focusElement(lsTrans);
                      return(false);
                   }
                }
                
                if(parseFloat(liMonto) == 0 && parseInt(liTrans) > 0)
                {
                   alert('El monto debe ser diferente a cero si tienes registrada(s) '+liTrans+' transaccion(es)');
                   focusElement(lsMonto);
                   return(false);
                }

                ticketAverage = parseFloat(liMonto) / parseFloat(liTrans);

                if(ticketAverage < 60 || ticketAverage > 360) {
                   alert('Los datos son correctos? Puedes revisar los tickets una vez mas');
                }
                
                totalTarjetas += parseFloat(liMonto);
                totalTrans    += parseInt(liTrans);
                totalCanc     += parseInt(liCanc);
            }

            totalTarjetas = totalTarjetas.toFixed(2);
            totalCanc     = totalCanc.toFixed(2);
            SUStot        = SUStot.toFixed(2);

            document.getElementById("totalCC").value  = "$"+totalTarjetas; 
            document.getElementById("totalSUS").value = "$"+SUStot; 
            document.getElementById("totalCanc").value = "$"+totalCanc;

            if(SUStot == 0 && totalTarjetas != 0)
            {
                alert('No hay tickets registrados en SUS con venta de aplicaciones m\u00f3viles. Favor de revisar');
                return(false);
            }

            if(totalTarjetas != SUStot)
            {
                alert("Los montos no coinciden.\nPuede corregir o guardar esos montos.\nSe enviara correo a su Gerente de Area y a Ingresos\navisando de esa diferencia cuando haga click en 'Guardar y confirmar datos'");
            }

        }

        function popup(url,name,windowWidth,windowHeight)
        {
            myleft=(screen.width)?(screen.width-windowWidth)/2:100;
            mytop=(screen.height)?(screen.height-windowHeight)/2:100;
            properties = "width="+windowWidth+",height="+windowHeight+",scrollbars=yes, top="+mytop+",left="+myleft+", menubar=no, toolbar=no";
            window.open(url,name,properties)
        }


        function submitUpdate()
        {
	    var SUStot = <%= getMovilSalesTotalSUS() %>;
	    var totalTarjetas = 0.0;
            var ticketAverage = 0.0;
            var totalTrans    = 0;
            var totalCanc     = 0.0;

            for(var liRowId=0; liRowId<giNumRows; liRowId++)
            {
                var lsMonto= "monto|"+liRowId;
                var lsFecha= "fecha|"+liRowId;
                var lsHora = "hora|"+liRowId;
                var lsTrans= "trans|"+liRowId;
                var lsCanc = "canc|"+liRowId;

                var noTerminal = liRowId+1;

                var liMonto     = document.getElementById(lsMonto).value;
                var liFecha     = document.getElementById(lsFecha).value;
                var liHora      = document.getElementById(lsHora).value;
                var liTrans     = document.getElementById(lsTrans).value;
                var liCanc      = document.getElementById(lsCanc).value;

                var regexMonto  = /^(\d{1,3},?(\d{3},?)*\d{3}(\.\d{0,2})?|\d{1,3}(\.\d{0,2})?|\.\d{1,2}?)$/;
                var regexHora   = /^([0-1][0-9]|2[0-3]):[0-5][0-9]$/;

                   if(isEmpty(liMonto))
                   {
                      alert ('Ingresar valor del monto para la venta m\u00f3vil '+noTerminal);
                      focusElement(lsMonto);
                      return(false);
                   }
                   else
                   {
                      //if (liMonto.match(regexMonto) == null) 
                      if (regexMonto.test(liMonto) == null) 
                      {
                         alert ('Ingresar un valor numerico valido para el monto, ejemplo 34.00');
                         focusElement(lsMonto);
                         return(false);
                      }
                   }  

                   if(isEmpty(liFecha))
                   {
                      alert ('Ingresar valor de fecha para la venta m\u00f3vil '+noTerminal);
                      focusElement(lsFecha);
                      return(false);
                   }
                   if(isEmpty(liTrans))
                   {
                       alert ('Ingresar valor de numero de transacciones hechas en la venta m\u00f3vil '+noTerminal);
                       focusElement(lsTrans);
                       return(false);
                   }
                   else
                   {
                       if(isNaN(liTrans))
                       {
                          alert ('Ingresar valor de numero de transacciones hechas en la venta m\u00f3vil '+noTerminal);
                          focusElement(lsTrans);
                          return(false);
                       }
                   }
                   if(isEmpty(liHora))
                   {
                      alert ('Ingresar valor de Hora para la venta m\u00f3vil '+noTerminal);
                      focusElement(lsHora);
                      return(false);
                   }
                   else
                   {
                      if (liHora.match(regexHora) == null) 
                      {
                         alert ('Ingresar un valor de hora valido, ejemplo 03:45');
                         focusElement(lsHora);
                         return false;
                      }
                   }
                   if(parseFloat(liMonto) >  0.0 && parseInt(liTrans) == 0)
                   {
                      alert('No puedes tener ingresado un monto de $'+liMonto+' con cero transacciones en la venta m\u00f3vil '+noTerminal+' favor de revisar');
                      focusElement(lsTrans);
                      return(false);
                   }

                   if(parseFloat(liMonto) == 0 && parseInt(liTrans) > 0)
                   {
                      alert('El monto debe ser diferente a cero si tienes registrada(s) '+liTrans+' transaccion(es)');
                      focusElement(lsMonto);
                      return(false);
                   }

                   if(isEmpty(document.getElementById("totalSUS").value))
                   {
                      getTotals();
                   }

		   totalTarjetas += parseFloat(liMonto);
		   totalTrans    += parseInt(liTrans);
		   totalCanc     += parseFloat(liCanc);

            }

	    totalTarjetas = totalTarjetas.toFixed(2);
            totalCanc     = totalCanc.toFixed(2);
            SUStot        = SUStot.toFixed(2);

            document.getElementById("totalCC").value  = "$"+totalTarjetas;
            document.getElementById("totalSUS").value = "$"+SUStot;
            document.getElementById("totalCanc").value = "$"+totalCanc;



            if(SUStot == 0 && totalTarjetas != 0)
            {
                alert('No hay tickets registrados en SUS con venta de aplicaciones m\u00f3viles. Favor de revisar');
                return(false);
            }

            if(totalTarjetas != SUStot)
            {
                alert("Los montos no coinciden.\nPuede corregir o guardar esos montos.\nSe enviara correo a su Gerente de Area y a Ingresos\navisando de esa diferencia cuando haga click en 'Guardar y confirmar datos'");
            }

            addHidden(document.frmGrid,'numRows', giNumRows);
            addHidden(document.frmGrid,'totalSUS', document.getElementById("totalSUS").value);
            addHidden(document.frmGrid,'totalCC',document.getElementById("totalCC").value);
            addHidden(document.frmGrid,'totalCanc',document.getElementById("totalCanc").value);

            document.frmGrid.submit();

        }

	function confirmation() {
	    var answer = confirm("Para realizar su cierre de dispositivos m\u00f3viles, es necesario hacer los dep\u00f3sitos de venta de dispositivos m\u00f3viles correspondientes en el sistema antes de ingresarlos en este reporte, de lo contrario, pueden surgir diferencias en montos, las cuales ser\u00E1n reportadas en un correo. Ya ingresaste los dep\u00f3sitos de dispositivos m\u00f3viles en el sistema?");
             
	    if(answer) {
	        initDataGrid('input');
	    } else {
	        alert ("Favor de realizar sus dep\u00f3sitos de dispositivos m\u00f3viles el sistema antes de continuar");
		window.parent.location = "http://localhost";
	    }

        }    

        </script>
    </head>

    <body bgcolor="white" onLoad="confirmation();">

        <% if(((date_actual == date_business) && actual_hour >= 20) || (date_business < date_actual)) {%>

        <% if(!file_name_txt.exists()) { %>

        <form name="frmGrid" id="frmGrid" method="post" action="MovilSalesPasswd.jsp">

        <table align="left" style="width: 384px;" width="90%" border="0">
        <tr class="bsTotals">
            <td>
                <h2>Fecha de Negocio: <%=bdate_%></h2>
            </td>
        <tr>
        <tr>
            <td style="width: 203px;">
                <input type="button" value="Obtener montos totales" onClick="getTotals()">
                <input type="button" value="Guardar y confirmar datos" onClick="submitUpdate()">
            </td>
        </tr>
        <tr>
            <td>
                <div id="goDataGrid"></div>
            </td>
        </tr>
        <tr>
            <td>
                <div id="goTotalsGrid"></div>
            </td>
        </tr>
        </table>
        </form>

        <% } else { %>

        <table align="left" style="width: 384px;" width="90%" border="0">
        <tr class="bsDb_tr_header">
            <td>
                Ya fue cerrada la venta de dispositivos m&oacute;viles de para la fecha de negocio: <%=bdate_%>
            </td>
        <tr>
        </table>

        <% } %>
        <% } else { %>
        <table align="left" style="width: 384px;" width="90%" border="0">
        <tr class="bsDb_tr_header">
            <td>
                Puede hacer su cierre de ingresos de aplicaciones m&oacute;viles para la fecha de negocio: <%=bdate_%> a partir de las 20 hrs.
            </td>
        <tr>
        </table>
        <% } %>


    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>

<%!
    String getDataset()
    {
        return moAbcUtils.getJSResultSet(getCCMovils());
    }


%>
