<jsp:include page = '/Include/ValidateSessionYum.jsp'/>


<%--
##########################################################################################################
# Nombre Archivo  : RecepDiffYum.jsp
# Compania        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Reporte de Diferencias
# Fecha Creacion  :
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>

<%
    String msRecep="";
    String msStepRecep="0";

    String lsPrv="";
    String lsNumRpt="";

    try{
        lsNumRpt=request.getParameter("txtNumRpt");
        if (lsNumRpt.equals("")) lsNumRpt=lsNumRpt;
    }catch(Exception moExcpetion){lsNumRpt="";}

    try{
        msRecep=request.getParameter("hidRecep");
        if (msRecep.equals("")) msRecep=msRecep;
    }catch(Exception e){
        msRecep="";
    }


    try{
        msStepRecep=request.getParameter("msStepRecep");
        if (msStepRecep.equals("")) msStepRecep=msStepRecep;
    }catch(Exception moExcpetion){msStepRecep="0";}


    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation ="";
    try{
        msOperation = request.getParameter("hidOperation");
    }catch(Exception e){}

    String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
    if (!msStepRecep.equals("0"))
       moHtmlAppHandler.setPresentation("PRINTER");
    else
       moHtmlAppHandler.setPresentation(msPresentation);

    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    String msFontMain = moHtmlAppHandler.moReportHeader.msFontMain;
    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";


    if (msStepRecep.equals("0"))
        moHtmlAppHandler.msReportTitle = getCustomHeader("Reporte de Discrepancias (Definitivo) ", msPresentation);
    else
        moHtmlAppHandler.msReportTitle = getCustomHeader("Confirmacion de Numero de Reporte ", msPresentation);

    moHtmlAppHandler.moReportTable.setTableHeaders("||Pedido|Pedido|Pedido|Pedido|Recepcion|Recepcion|Recepcion|Recepcion||| ",0,true);
    moHtmlAppHandler.moReportTable.setTableHeaders("-|Producto|Codigo<br>Producto<br>Solicitado|Cantidad<br>Requerida|Equiv<br>Unidad<br>Inv|Costo|Codigo<br>Producto<br>Recibido|Cantidad<br>Recibida|Equiv<br>Unidad<br>Inv|Costo|Codigo<br>Discr.|Differencia<br>Unid<br>Prov|Differencia<br>Unid<br>Inv",1,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("|||||||||||| ");
    moHtmlAppHandler.moReportTable.setFieldColors("#E6E6FA|#E6E6FA|#66CCFF|#66CCFF|#66CCFF|#66CCFF|#CCFFFF|#CCFFFF|#CCFFFF|#CCFFFF|#E6E6FA|#E6E6FA|#E6E6FA",2);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

%>

<html>
    <head>
        <title><%
	if (msStepRecep.equals("0"))
		out.println("Reporte de Discrepancias");
	else
		out.println("Confirmacion de Nmero de Reporte");
	%>
	</title>
        <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
    </head>
    <script src='/Scripts/ReportUtilsYum.js'></script>
    <script src='/Scripts/AbcUtilsYum.js'></script>
    <script>

        function handleOK() {

            if (opener && !opener.closed) {
                opener.dialogWin.returnFunc();
            } else {
                alert("Se ha cerrado la ventana principal.\n\nNo se realizaran cambios pormedio de este cuadro de dialogo.");
            }

            return(false);
        }

        function returnData(psParam) {
            parent.opener.dialogWin.returnedValue = psParam;
            handleOK();
            window.close();
        }

        function aceptData(){
            if (document.frm_confirm.txtNumRpt.length==0 || document.frm_confirm.txtNumRpt.value==""){
                alert('Para confirmar las diferencias, ingresa el nmero de Reporte del proveedor. \n Si no obtuviste el No. de reporte del proveedor, ingresa 0.');
                document.frm_confirm.txtNumRpt.focus();
                return(false);
            }else{
                executePageDW('PRINTER');
                document.frm_confirm.action='RecepDiffYum.jsp';
                document.frm_confirm.submit();
            }

        }

        function cancelData(){
            //document.frm_confirm.action='RecepDetailYum.jsp';
            //document.frm_confirm.target='ifrInnerDetail';
            //document.frm_confirm.submit();
            window.close();
        }

        function loadFunction() {
            if (opener) opener.blockEvents();
        }

    </script>
    <body  bgcolor = 'white' <%=moHtmlAppHandler.moReportHeader.getBodyStyle() %> >
            <% if (msPresentation.equals("VIEWPORT")) { %>
                    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
                        <jsp:param name = 'psPrintOption' value = 'yes'/>
                    </jsp:include>
            <% } else { %>
                    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
            <% } %>

            <%=msFontSub%>
	    	&nbsp;Centro de contribuci&oacute;n: <b><%=getStore()%>&nbsp;<%=getStoreName()%><br>
                &nbsp;No. Recepcion:<b><% if (!msRecep.equals("")) out.println(msRecep); else  out.println(msStepRecep); %></b>
            <%=msFontEnd%>
            <br>
            <form name ='frm_confirm' id ='frm_confirm' method='get'>
            <% try{
               AbcUtils moAbcUtils = new AbcUtils();
	       String lsDiscrepDescrip = getQueryDiscDesc();
            if (msStepRecep==null) msStepRecep="0";
                if (!msStepRecep.equals("0")){
			String lsUpdateQuery="UPDATE op_grl_reception SET report_num=? WHERE reception_id=?";
                  	moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsNumRpt.trim(),msStepRecep});
			out.println("<p class=descriptionTabla><b>Reporte del Proveedor Capturado:"+lsNumRpt+"</b></p>");
			moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msStepRecep));

			String lsDeleteQuery = "DELETE from op_grl_step_reception_detail";
			moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});
			lsDeleteQuery = "DELETE from op_grl_step_reception ";
			moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});
            }else {
                 lsPrv=moAbcUtils.queryToString("SELECT provider_id from op_grl_step_reception WHERE reception_id="+msRecep+"","","");
                 if (msPresentation.equals("VIEWPORT") || msPresentation.equals("")){ %>
                    <p class=descriptionTabla><b>Desea confirmar el nmero de Reporte del proveedor?</b>&nbsp;&nbsp;
                    </p>
                    <input type = 'hidden' name = 'msStepRecep' value ='<%=msRecep%>'>
                    <input type = 'hidden' name = 'hidOperation' value ='S'>
                    <input type = 'button' name = 'cmd_ok' value = '  Aceptar  ' OnClick = 'aceptData();'>
                    <!--input type = 'button' name = 'cmd_cancel' value = ' Cancelar ' OnClick = 'cancelData();'-->
                    &nbsp;&nbsp;
                    <font class=descriptionTabla>
                    No. Reporte del Proveedor: </font>
                    <input type = 'text'  name = 'txtNumRpt' id='txtNumRpt'  size = '15' >
                    <br><br>
                 <%
		 }else if (msPresentation.equals("PRINTER")){
                 %>
		 <a href="javascript:history.back();" class="mainsubtitle"> << Continuar con la captura del No. de Reporte del Proveedor. </a>

		  <br><br>

		 <%
                 }
                 moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msRecep)); //,lsDiscrepDescrip));
            %>
            <% }

             }catch(Exception moExcpetion) {
                moExcpetion.printStackTrace();
             }
            %>
            </form>

            <jsp:include page = '/Include/TerminatePageYum.jsp'/>

    </body>
</html>

<%!

    String getQueryReport(String  psRecep) {
        String lsQuery = "";
	AbcUtils moAbcUtils = new AbcUtils();
 	String lsContNeg =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'","","");
	int liContNeg=Integer.parseInt(lsContNeg.trim());
	String lsContPos =moAbcUtils.queryToString("SELECT count(*) FROM op_grl_difference WHERE reception_id ="+psRecep + " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'","","");
	int liContPos=Integer.parseInt(lsContPos.trim());
	if(liContNeg > 0){
		lsQuery+= "SELECT '0' as control,product_name, order_product, qty_required, order_equivalent, ";
		lsQuery+= "to_char(ord_cost,'999999990.99') as ord_cost, recep_product, ";
		lsQuery+= "qty_received, recep_equivalent, to_char(recep_cost, '99999990.99') as recep_cost, ";
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '1' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_difference WHERE reception_id="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)='-'";
	}
	if(liContNeg > 0 && liContPos > 0){
 		lsQuery+= " UNION ";
		lsQuery+= "SELECT '2' as control ,' ',' ',' ',' ', ' ', ";
		lsQuery+= " ' ',' ',' ',' ','','','' ";
		lsQuery+= " UNION ";
	}
	if(liContPos > 0){
		lsQuery+= "SELECT '3' as control,product_name, order_product, qty_required, order_equivalent, ";
		lsQuery+= "to_char(ord_cost,'999999990.99') as ord_cost, recep_product, ";
		lsQuery+= "qty_received, recep_equivalent, to_char(recep_cost, '99999990.99') as recep_cost, ";
		lsQuery+= "dif_desc, dif_prv, dif_inv  FROM op_grl_difference WHERE reception_id ="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'";
		lsQuery+= " UNION ";
		lsQuery+= "SELECT '4' as control,' ',' ',' ','Total Orden:', '<b>' || to_char( sum(ord_cost), '99999990.99') || '</b>' as ord_cost, ";
		lsQuery+= " ' ',' ','Total Recepcion:','<b>' || to_char(sum(recep_cost), '999999990.99') || '</b>' as recep_cost,'','','' ";
		lsQuery+= "FROM op_grl_difference WHERE reception_id="+psRecep;
		lsQuery+= " AND substr(ltrim(rtrim(dif_prv)),1,1)!='-'";
		lsQuery+= " ORDER BY control ASC";
	}
	if(liContNeg == 0 && liContPos == 0){
		lsQuery+= "SELECT ' ' as control ,' ','<b>NO</b>','<b>HAY</b> ','<b>DIFERENCIAS</b> ', ' ', ";
		lsQuery+= " '<b>NO</b>','<b>HAY</b> ','<b>DIFERENCIAS</b> ',' ','<b>NO</b>','<b>HAY</b>',";
		lsQuery+= " '<b>DIFERENCIAS</b> ' ";
	}
	return(lsQuery);
}

   String getStore(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_id from ss_cat_store ","","");
        return(lsStore);
   }

   String getStoreName(){
        AbcUtils moAbcUtils = new AbcUtils();
        String lsStore=moAbcUtils.queryToString("SELECT store_desc from ss_cat_store ","","");
        return(lsStore);
   }

   String getCustomHeader(String psTitle, String psPresentation){
   	String lsHeader ="";
	String lsReportTitle="";
	String lsOthers ="";
   	if(psPresentation.equals("VIEWPORT")){
		lsReportTitle = "mainsubtitle";
		lsOthers = "descriptionTabla";
	}else{
		lsReportTitle = "mainsubtitlePrn";
		lsOthers = "descriptionTablaPrn";
	}
	lsHeader +=  "<table border='0' width='100%'>";
	lsHeader += "<tr>";
	lsHeader += "<td width='80%' class='" + lsOthers + "'>";
	lsHeader += "<b>Yum! Restaurants International</b>";
	lsHeader += "</td>";
	lsHeader += "<td width='20%' class='" + lsOthers +"'>";
	lsHeader += "<img src='/Images/Menu/yum_icons.gif'>";
	lsHeader += "</td>";
	lsHeader += "</tr>";
	lsHeader += "<tr><td colspan=2 class='" + lsOthers + "'>&nbsp;</td></tr>";
	lsHeader += "<tr>";
	lsHeader += "<td colspan=2 class='"+ lsReportTitle +"'>";
	lsHeader += psTitle;
	lsHeader += "</td>";
	lsHeader += "</tr>";
	lsHeader += "</table>";
	return(lsHeader);
   }

   String getDateTime(){
        String lsDate="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yy-MM-dd_hh:mm:ss";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance();
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay);

        lsDate=lsDF.format(lsC1.getTime());
        return(lsDate);
   }

   String getQueryDiscDesc(){
		int case_id = 7; //Es el de diferencia entre orden y recepcion, cuando el elemento de la orden no esta en la recepcion
    		String lsQuery = "";
		lsQuery += " SELECT d.dif_desc FROM op_grl_cat_difference d";
		lsQuery +=" INNER JOIN op_grl_cat_config_difference cd ON cd.difference_id = d.difference_id";
		lsQuery +=" WHERE case_id=" + case_id;
		lsQuery += " ORDER BY sort_seq LIMIT 1";
		AbcUtils moAbcUtils = new AbcUtils();
        	String lsSelectedDefault=moAbcUtils.queryToString(lsQuery,"","");
		return(lsSelectedDefault);
}

%>
