<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : OrdenTrigggerYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Disparador de Pedido sugerido
# Fecha Creacion  : 27/Septiembre/2004
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
    moHtmlAppHandler.msReportTitle = "Generador de Pedido sugerido";
    ProcessInterface moProcessInterface = new ProcessInterface();
    String msSuggestedDate="";
    String msDia="";
    String msMes="";
    String msAnio="";
    int miStatus = 0;

    try{
        msSuggestedDate=request.getParameter("txtDate");
        if (msSuggestedDate==null) msSuggestedDate="";
        msDia=msSuggestedDate.substring(0,2);
        msMes=msSuggestedDate.substring(3,5);
        msAnio=msSuggestedDate.substring(8,10);
    }catch(Exception moException){}

    if (!msSuggestedDate.equals("")){
	String msCommand = "/usr/bin/ph/databases/purchase_order/bin/suggested.s";
	String msDate = msAnio+msMes+msDia;
	String maCommand[] = {msCommand,msDate};
        miStatus=moProcessInterface.executeProcess(maCommand);

    }

    if (miStatus==0) out.println("Proceso terminado con exito.");
%>

<html>
	<body onLoad = 'updateMasterForm();'>
		<script language = 'javascript'>
		
		function updateMasterForm() {
			var liStatus = '<%=miStatus %>';
			if (liStatus!='0') alert('Error en la generaciòn del Pedido Sugerido. Contacta con sistemas');
			parent.frames['ifrMainContainer'].showHideControl('divWaitGSO','hidden');
		}
			
		</script>
	</body>
</html>


