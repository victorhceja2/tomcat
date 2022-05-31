
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InventoryConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Realiza la confirmacion del cierre de inventario de criticos.
# Fecha Creacion  : 09/Enero/2006
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria InventoryLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ page import="jinvtran.inventory.utils.*" %>
<%@ include file="../Proc/InventoryLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msQdate;
	String msSales;
	String msSave;
	String msYear;
	String msPeriod;
	String msWeek;

	String laAttention[][];

	boolean msInventoryOk;
%>

<%
	try
	{
		moAbcUtils  = new AbcUtils(); 
		
		msYear        = request.getParameter("hidYear");
		msPeriod      = request.getParameter("hidPeriod");
		msWeek        = request.getParameter("hidWeek");
		msQdate     = request.getParameter("hidQdate");
		msSales     = request.getParameter("hidSales");
		msSave	    = request.getParameter("hidSave");
		
		laAttention   = attentionItems(msYear, msPeriod, msWeek, msQdate);
		msInventoryOk = saveChanges(msQdate, msSave);
	}
	catch(Exception e)
	{

	}

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = getCustomHeader("Resultado Actualizaci&oacute;n Inventario", "Printer");
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/TooltipsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>

        <div id="divWaitGSO" style="width:400px; height:150px"  class="wait-gso">
            <br><br>Espere por favor...<br><br>
        </div>

        <script src="/Scripts/HtmlUtilsYum.js"></script>

        <script language="javascript">
            function cerrar(psSaveType){
	    	if(psSaveType == '1'){
                    window.opener.location.href = 'InventoryDetailYum.jsp';
                    window.close();
		}
		else
		    window.close();
            }
	    function imprimir(){
		parent.frames["ifrPrinter"].focus();
		parent.frames["ifrPrinter"].print();
	    }

            showWaitMessage();
        </script>
    </head>
    <body bgcolor="white">
    <div style="overflow:auto;height:100%;">
	    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true"/>
	    </jsp:include>

		<table align="center" width="98%" border="0">
		<tr>
		    <td align="center" class="mainsubtitle">
        	<form name="frmConfirm">
		<input type="button" value="Imprimir comprobante" onclick="imprimir()">
		<%
		System.out.println("msSave["+msSave+"]");
		if("2".equals(msSave) || "T".equals(msSave)){
        	%>
			<input type="button" value="Cerrar ventana" onclick="cerrar('2')">
		<%
		}else{
		%>
			<input type="button" value="Cerrar ventana" onclick="cerrar('1')">
		<%
		}
            	if(msInventoryOk){
		%>
                	<br>
                	<tr><td align="center" class="mainsubtitle">El inventario de criticos ha sido guardado.</td><br></tr>
                	<br><br>
			&nbsp;&nbsp;		
        	<%
		   if( "2".equals(msSave) ){
	           %>
			<tr><td align="center" class="mainsubtitle"><b>&iexcl;Atenci&oacute;n&#33;</b> Los siguientes items tienen diferencias altas en dinero o cantidad.</td></tr>
		   <%
			try{
		  	   for(int rowId=0; rowId<laAttention.length; rowId++){
		    	      out.println("<b>"+laAttention[rowId][0]+"</b");
			   }
			}catch(Exception e){
				System.out.println("Exception InventoryConfirmYum ... " + e.toString());
			}
                   }
		}else{
    	            out.println("Problemas al guardar los datos del inventario. <br><br>");
		}
		%>	

        	</form>
		</td>
		</tr>
		<tr>
		   <td>
			<iframe name="ifrPrinter" src="../Rpt/InventoryReportFrm.jsp?&hidQdate=<%= msQdate %>&hidSales=<%= msSales %>&hidTarget=Printer" frameborder="0" width="800" height="10">
		   </td>
		</tr>

		</table>

        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
	</div>
    </body>
</html>


