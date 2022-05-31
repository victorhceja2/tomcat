<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : ITransferDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : EZM
# Objetivo        : Muestra el detalle (reporte) de una transferencia de entrada.
# Fecha Creacion  : 11/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="java.util.*, java.io.*, java.text.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%@ include file="../Proc/TransferLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils = new AbcUtils(); 
	AplicationsV2 logApps = new AplicationsV2();

	String msTransferId;
	String msTransferType;
%>

<%
    try{

		msTransferId   = request.getParameter("transferId");
		msTransferType = getTransferType(msTransferId);
    }
    catch(Exception e){
    
    }

%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>

        <div id="divWaitGSO" style="width:300px; height:150px"  class="wait-gso">
            <br><br>Espere por favor...<br><br>
        </div>

        <script src="/Scripts/HtmlUtilsYum.js"></script>

        <script>
            showWaitMessage();

            function submitFrame(frameName)
			{
                document.mainform.target = frameName;

				if(frameName=='preview')
                	document.mainform.hidTarget.value = "Preview";

				if(frameName=='printer')
                	document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
			}
			function submitFrames()
			{
				submitFrame('printer');
				setTimeout("submitFrame('preview')", 2000);
			}

        </script>
    </head>
	<body onLoad="submitFrames()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="525" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>
        <form name="mainform" action="TransferDetailFrm.jsp">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidTransferId"   value="<%= msTransferId %>">
            <input type="hidden" name="hidTransferType" value="<%= msTransferType %>">
        </form>
	</body>
</html>
