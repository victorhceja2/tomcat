<%--
##########################################################################################################
# Nombre Archivo  : ITransferConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Eduardo Zarate (laliux)
# Objetivo        : Realiza la confirmacion de una transferencia de entrada.
# Fecha Creacion  : 12/Julio/2005
# Inc/requires    : ../Proc/TransferLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*, java.text.*"%>
<%@ page import="generals.*"%>
<%@ page import="jinvtran.inventory.*"%>
<%@ include file="../Proc/TransferLibYum.jsp"%>

<%! 
    AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
    String msLocalStore   = "";
    String msRemoteStore  = "";
    String msTransferId   = "";
    String msTransferType = "";

    boolean msTransferOk;
%>

<%
    try
    {
        moAbcUtils     = new AbcUtils(); 

        msTransferType = "input";
        msLocalStore   = request.getParameter("hidLocalStore");
        msRemoteStore  = request.getParameter("hidRemoteStore");

        msTransferId   = getStepTransferId();
        

    }
    catch(Exception e)
    {
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }


    try{
    	registerTransfer(msRemoteStore, msTransferId, msLocalStore);
    	System.out.println("\n" + new Date() + ": Se confirmó la transferencia de entrada " + msTransferId + " solicitada al CC " + msRemoteStore);
    	logApps.writeInfo("\n" + new Date() + ": Se confirmó la transferencia de entrada " + msTransferId + " solicitada al CC " + msRemoteStore);
    	System.out.println("\n" + new Date() + ": Se confirmó la transferencia de entrada " + msTransferId + " solicitada al CC " + msRemoteStore);
    }catch (Exception e){
    	logApps.writeError("\n" + new Date() + ": ERROR " + e.getMessage() + " en " + e.getLocalizedMessage());
    	logApps.writeError("\tDetalle del Error " + e.toString() + ":");
    	for (StackTraceElement stack: e.getStackTrace()){
    		logApps.writeError("\t" + stack.toString());
    	}
    }
%>

<html>
<head>
<link rel="stylesheet" type="text/css"
	href="/CSS/GeneralStandardsYum.css" />
<link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css" />

<div id="divWaitGSO" style="width: 300px; height: 150px"
	class="wait-gso">
	<br> <br>Espere por favor...<br> <br>
</div>

<script src="/Scripts/HtmlUtilsYum.js"></script>

<script language="javascript">
	showWaitMessage();
</script>

<script src="../Scripts/TransferLibYum.js"></script>
</head>
<body bgcolor="white" onLoad="submitFrames()" onUnload="doClose(1)">
	<table width="100%" cellpadding="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="100%"><iframe name="preview" width="100%"
					height="595" frameborder="0"></iframe></td>
		</tr>
		<tr>
			<td width="100%"><iframe name="printer" width="100%" height="5"
					frameborder="0"></iframe></td>
		</tr>
	</table>
	<form name="mainform" action="../Rpt/TransferDetailFrm.jsp">
		<input type="hidden" name="hidTarget"> <input type="hidden"
			name="hidTransferId" value="<%=msTransferId%>"> <input
			type="hidden" name="hidTransferType" value="<%=msTransferType%>">
	</form>
</body>
</html>
