<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : ChooseProductsYum.jsp
# Compa?ia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Seleccionar productos para ordenes de compra
# Fecha Creacion  : 15/Sep/2004
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>
<%@page contentType="text/html" %>
<%@page import="java.util.*, java.io.*, java.text.*"%>
<%@page import="generals.*" %>
<%@page import="jinvtran.inventory.*" %>
<%! 
AbcUtils moAbcUtils = new AbcUtils(); 
AplicationsV2 logApps = new AplicationsV2();
%>
<%@ include file="../Proc/PurchaseOrderLibYum.jsp" %>
<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    //AbcUtils moAbcUtils = new AbcUtils();
    String msOperation = request.getParameter("hidOperation");
    if (msOperation==null) return;
    String msMasterKeys = "";
    String msProvider="0";
    String msProduct="";
    String msStore="";
    String msSource="";
    String msParams="";
    try{
        msStore = request.getParameter("hidStore");
        //out.println("hidProv: " + request.getParameter("hidProv") + " cmbProv: " + request.getParameter("cmbProv"));
        msProduct = request.getParameter("txtProd");
        if(request.getParameter("hidProv").equals("0")||request.getParameter("hidProv").equals("")){
            msProvider = request.getParameter("cmbProv");
        }else{
            msSource = request.getParameter("hidSource");
            msProvider = request.getParameter("hidProv");
        }
    }catch(Exception e){}

    try{
         msParams=request.getParameter("hidSub");
         
    }catch(Exception moExcpetion){msParams="";}

    moHtmlAppHandler.setPresentation((msOperation.equals("B"))?"VIEWPORT":"PRINTER");
    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    moHtmlAppHandler.moReportTable.setNonLevelColor(moHtmlAppHandler.moReportTable.getStoreLevelColor());

    moHtmlAppHandler.msReportTitle = "Productos";
    moHtmlAppHandler.moReportTable.setTableHeaders("<p></p>|CVE<br>PROD<BR>PROV|NOMBRE|PRODUCTO|CATEGORIA|UNIDAD<br>MEDIDA|PRECIO|SUGERIDO",0,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("||||||##.##|#");
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }
%>

<html>
    <head>
        <title><%=moHtmlAppHandler.msReportTitle %></title>
        <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
    </head>
    <script src="/Scripts/ReportUtilsYum.js"></script>
    <script src="/Scripts/AbcUtilsYum.js"></script>
    <script>

        var msAllData = '';
        var msOriginalRowColor = '#E6E6FA';
        var msSelectRowColor   = 'tomato';

    function checkUncheckAll(poElement) {
            var mrSugQuantity=0;            
            var msName=poElement.name;

            for (var z = 0; z < document.frmSelection.elements.length; z++) {
              mrSugQuantity=0;      
              if (poElement.name=='chkSuggested'){
                    mrSugQuantity=document.frmSelection.elements[z].name;
                    mrSugQuantity=mrSugQuantity.substring(mrSugQuantity.lastIndexOf("_")+1,mrSugQuantity.length);

                if (document.frmSelection[z].type == 'checkbox' && document.frmSelection.chkSuggested.checked==true) {
                    if (document.frmSelection.elements[z].name!='chkSuggested' && document.frmSelection.elements[z].name!='chkAll'){
                        if (mrSugQuantity>0 && poElement.checked==true && document.frmSelection.elements[z].checked==false){
                            document.frmSelection.elements[z].click();
                            }
                     }
                }else if (document.frmSelection.chkSuggested.checked==false && document.frmSelection.elements[z].name!='btnCancelar'  && document.frmSelection.elements[z].name!='btnAceptar' &&  document.frmSelection.elements[z].name!='chkAll'){
                        if (mrSugQuantity>0){
                            //document.frmSelection.elements[z].checked = false;
                              document.frmSelection.elements[z].click();
                        }
                }
              }else if (poElement.name=='chkAll'){    
                if (document.frmSelection[z].type == 'checkbox' && document.frmSelection.chkAll.checked==true) {
                    if (document.frmSelection.elements[z].name!='chkSuggested' && document.frmSelection.elements[z].name!='chkAll'){
                        if (poElement.checked==true && document.frmSelection.elements[z].checked==false){
                            document.frmSelection.elements[z].click();
                        }
                     }
                }else if (document.frmSelection.chkAll.checked==false  && document.frmSelection.elements[z].name!='btnCancelar'  && document.frmSelection.elements[z].name!='btnAceptar' && document.frmSelection.elements[z].name!='chkSuggested' && document.frmSelection.elements[z].name!='chkAll'){
                              document.frmSelection.elements[z].click();
                }
             }
          }
       }

        function selectProduct(psObject,psList) {
	    var arrList = psList.split("|");
	    var tmpList = "";
	    for (var elem=0; elem < arrList.length; elem++){
	    	if(elem == 3){
		    tmpList += arrList[3]+"|"+arrList[3]+"|";
		}else{
		    tmpList += arrList[elem]+"|";
		}
	    }
	    psList = tmpList;
            if (psObject.checked==true){
                if (msAllData==""){
                    msAllData = psList;
                }else{
                    msAllData = msAllData+"&"+psList;
                }
            }else{
                if (msAllData.indexOf('&')>0){
                    msAllData=msAllData.replace('&'+psList,'');
                    msAllData=msAllData.replace(psList + '&','');
                }else{
                    msAllData=msAllData.replace(psList,'');
                }
            }

            loRow = document.getElementById(psObject.id).parentNode.parentNode.parentNode;
            if(loRow.nodeName == "TR")
               selectRow(loRow);
        }

    function selectRow(poRow)
    {
        lsColorBG = poRow.style.backgroundColor;
        if(lsColorBG != msSelectRowColor){
            poRow.style.backgroundColor=msSelectRowColor; 
        }else{
            poRow.style.backgroundColor=msOriginalRowColor;
        }
    }

       function findProduct(psProv,psProd){
            var lsName="";
            var msProd=psProd;
            var liValue=0;
            for (var z = 0; z < document.frmSelection.elements.length; z++) {
               lsName=document.frmSelection.elements[z].name;
               if (lsName.indexOf('optProduct')==0 && lsName.indexOf(msProd.toUpperCase())>=0){
                    liValue=getControlYpos(lsName)-90;
                    if ((msAgent.indexOf("msie") != -1) && (msAgent.indexOf("opera") == -1)){
                      document.getElementById('divReport').scrollTop=liValue;
                    }else{
                      document.getElementById('findHelp').scrollTop=liValue;
		    }
            break;
               }
            }
        }

    </script>
    <body id = 'findHelp' bgcolor = 'white' <%=moHtmlAppHandler.moReportHeader.getBodyStyle() %> >
    <%
    Date lsInitDate = new Date();
    double llInitTime=lsInitDate.getTime();
    %>
    <form id='frmSelection' name='frmSelection' method='post'>
    <table border='0' cellspacing='0' cellpadding='0' align='left' width='100%'>
        <tr valign='top'>
            <td width='10%'>
                <input type = 'button' name="btnAceptar" class = 'combos' value = 'Aceptar' OnClick = 'returnData(msAllData);top.window.close();'>
            </td>
            <td width='10%'>
                <input type = 'button' name="btnCancelar" class = 'combos' value = 'Cancelar' OnClick = 'top.window.close();'>
            </td>
            <td width='10%'>
                &nbsp;
            </td>
            <td width='35%' class='descriptionTabla' >
                <input type = 'checkbox' name="chkSuggested" id="chkSuggested" value = '0' OnClick = 'checkUncheckAll(this);'><b>Seleccionar solo productos de Sugerido</b>&nbsp;
            </td>
            <td width='35%' class='descriptionTabla' align='top'>
                <input type = 'checkbox'  name="chkAll" id="chkAll" value = '0' OnClick = 'checkUncheckAll(this);'><b>Seleccionar Todos</b>
            </td>
          </tr>
     </table>

     <br><br>

        <% if (msOperation.equals("P")) {  moHtmlAppHandler.setPresentation(""); %>
            <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
            <br>
        <% moHtmlAppHandler.setPresentation("PRINTER"); } %>
        <% 
        if (moHtmlAppHandler.getPresentation().equals("")) { moHtmlAppHandler.initializeHandler(); return; }
    moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msProvider,msStore,msSource,msParams));
    if (!msProduct.equals("")){
        out.println("<script>findProduct('"+msProvider+"','"+msProduct+"'); </script>");
    }

        %>

   </form>

        <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    <%
    Date lsEndDate = new Date();
    double llEndTime=lsEndDate.getTime();
    float llDifference = (float)((llEndTime - llInitTime)/1000); //Tiempo que tarda en cargar la p???ina
    String pattern="0.000";
    DecimalFormat myFormatter = new DecimalFormat(pattern);
    String lsDifference;
    lsDifference = myFormatter.format(llDifference);
    String lsDateTime = getToday(); //Obtiene a que fecha y hora es cargada la p???ina
    String laPartsDate[]=lsDateTime.split(" ");
    String lsFlagProvider="";
    String lsFlagOrigen="R";
    if(!msProvider.equals("0")){
        lsFlagProvider = "F";
    }
    if(msSource.equals("")){
        lsFlagOrigen="O";
    }
    //Escribir en un archivo el tiempo que tarda en cargar la p???ina
    try{
        FileWriter lftemp = new FileWriter("/usr/fms/op/rpts/choosetime/" + laPartsDate[0] + ".txt", true);
        lftemp.write(msStore + "|" + lsDateTime + "|" + lsDifference + "|" + lsFlagOrigen + "|" + lsFlagProvider);
        lftemp.write('\n');
        lftemp.close();
    }catch(EOFException e){logApps.writeInfo("Final de Stream");}
    %>
    </body>
</html>

<%!
String getQueryReport(String psProv,String psStore, String psSource,String psParams ) {

    loadCurrentInvtranItems(true);
    String lsQuery = "";
    String lsFlag="0";
    String lsTypeDoc="";
    String lsNumDoc="-1";
    if(psSource.equals("R"))
    {
        String laParams[]=psParams.split("_");
        try{
            lsNumDoc=laParams[2];
            lsTypeDoc="R";
        }catch(Exception moExcpetion){
            lsNumDoc=laParams[1];
            lsTypeDoc="O";
        }
logApps.writeInfo("lsTypeDoc:"+lsTypeDoc);
        if(lsTypeDoc.equals("R")){// Viene de una Remision con validacion contra invtran
            lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
            lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' ";
            lsQuery += "onClick = ''selectProduct(this,\"'|| ";
            lsQuery += "LTRIM( to_char((Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end),'9999990.99'))";
            lsQuery += "||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||m.unit_id||'_'||vwm.unit_id||'_'||p.provider_id";
            lsQuery += "||'_'||'"+lsNumDoc+"'||'_R'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|' ";
            lsQuery += "||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))";
            lsQuery += "||' '||rtrim(m.unit_name)|| '|' || '0' || '|' || '3' || '|' || LTRIM(to_char(CEIL(isnull(s.suggested_quantity,0)/isnull(p.conversion_factor,0)),'9999990.99'))";
            lsQuery += "||' '||rtrim(vwm.unit_name)|| '|' ||LTRIM(to_char(isnull(p.provider_price,0),'9999990.99'))|| '|' ";
            lsQuery += "||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'), ";
            lsQuery += "p.provider_product_code, Ltrim(prv.name), ";
            lsQuery += "p.provider_product_desc, c.family_desc as category, ";
            lsQuery += "m.unit_name, ROUND(p.provider_price,2), ";
            lsQuery += "CAST('0.00' as varchar) ";
            lsQuery += "FROM op_grl_cat_providers_product p ";
            lsQuery += "INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
            lsQuery += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
            lsQuery += "INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
            lsQuery += "INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id ";
            lsQuery += "LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
            lsQuery += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
            lsQuery += "WHERE p.active_flag <> 0 ";
            if (!psProv.equals("0")){
                lsQuery += " AND prv.provider_id='"+psProv.trim() +"' ";
                lsFlag="1";
            }
            //lsQuery += "ORDER BY p.provider_product_code ASC ";
            lsQuery += "UNION ";

            lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
            lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' ";
            lsQuery += "onClick = ''selectProduct(this,\"'|| ";
            lsQuery += "LTRIM( to_char((Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end),'9999990.99'))";
            lsQuery += "||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||m.unit_id||'_'||vwm.unit_id||'_'||p.provider_id";
            lsQuery += "||'_'||'"+lsNumDoc+"'||'_R'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|' ";
            lsQuery += "||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))";
            lsQuery += "||' '||rtrim(m.unit_name)|| '|' || '0' || '|' || '3' || '|' || LTRIM(to_char(CEIL(isnull(s.suggested_quantity,0)/isnull(p.conversion_factor,0)),'9999990.99'))";
            lsQuery += "||' '||rtrim(vwm.unit_name)|| '|' ||LTRIM(to_char(isnull(p.provider_price,0),'9999990.99'))|| '|' ";
            lsQuery += "||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'), ";
            lsQuery += "p.provider_product_code, Ltrim(prv.name), ";
            lsQuery += "p.provider_product_desc, c.family_desc as category, ";
            lsQuery += "m.unit_name, ROUND(p.provider_price,2), ";
            lsQuery += "CAST('0.00' as varchar) ";
            lsQuery += "FROM op_grl_cat_providers_product p ";
            lsQuery += "INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
            lsQuery += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
            lsQuery += "INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
            lsQuery += "INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id ";
            lsQuery += "LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
            lsQuery += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
            lsQuery += "WHERE p.active_flag <> 0 AND i.family_id = '12800000' ";
            if (!psProv.equals("0")){
                lsQuery += " AND prv.provider_id='"+psProv.trim() +"' ";
                lsFlag="1";
            }
            //lsQuery += "ORDER BY p.provider_product_code ASC ";
            lsQuery += "ORDER BY 2 ASC ";

        }
        else if(lsTypeDoc.equals("O")) // Viene de una Orden con validacion de invtran
        {
            lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
            lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' onClick = ''selectProduct(this,\"'|| ";
            lsQuery +="LTRIM( to_char((Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end),'9999990.99'))||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||cast(m.unit_id as char)||'_'||cast(vwm.unit_id as char)||'_'||cast(p.provider_id as char)||'_'||'"+lsNumDoc+"'||'_O'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||' '||rtrim(m.unit_name)||'|'||'0'||'|' || '3' || '|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end)/(Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99'))||' '||rtrim(vwm.unit_name)||'|'||LTRIM(to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'), ";
            lsQuery += " p.provider_product_code, Ltrim(prv.name), ";
            lsQuery += " p.provider_product_desc, c.family_desc as category, ";
            lsQuery += " m.unit_name, ROUND(p.provider_price,2), ";
            lsQuery += " CAST('0.00' as varchar)";
            lsQuery += " FROM op_grl_cat_providers_product p ";
            lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
            lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
            lsQuery += " INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
            lsQuery += " INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id ";
            lsQuery += " LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
            lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
            lsQuery += " WHERE p.active_flag<>0";
            if (!psProv.equals("0")){
                lsQuery += " AND prv.provider_id='"+psProv.trim() +"'";
                lsFlag="1";
            }
            //lsQuery += " ORDER BY p.provider_product_code ASC ";
            lsQuery += " UNION ";
            lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
            lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' onClick = ''selectProduct(this,\"'|| ";
            lsQuery +="LTRIM( to_char((Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end),'9999990.99'))||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||cast(m.unit_id as char)||'_'||cast(vwm.unit_id as char)||'_'||cast(p.provider_id as char)||'_'||'"+lsNumDoc+"'||'_O'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||' '||rtrim(m.unit_name)||'|'||'0'||'|' || '3' || '|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end)/(Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99'))||' '||rtrim(vwm.unit_name)||'|'||LTRIM(to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'), ";
            lsQuery += " p.provider_product_code, Ltrim(prv.name), ";
            lsQuery += " p.provider_product_desc, c.family_desc as category, ";
            lsQuery += " m.unit_name, ROUND(p.provider_price,2), ";
            lsQuery += " CAST('0.00' as varchar)";
            lsQuery += " FROM op_grl_cat_providers_product p ";
            lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
            lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
            lsQuery += " INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
            lsQuery += " INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id ";
            lsQuery += " LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
            lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
            lsQuery += " WHERE p.active_flag<>0 AND i.family_id = '12800000' ";
            if (!psProv.equals("0")){
                lsQuery += " AND prv.provider_id='"+psProv.trim() +"'";
                lsFlag="1";
            }
            lsQuery += " ORDER BY 2 ASC ";
        }
    }else if(psSource.equals("N")){ // Recepcion sin orden ni remision con validacion para invtran
             lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
             lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' onClick = ''selectProduct(this,\"'|| ";
             lsQuery +="LTRIM( to_char((Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end),'9999990.99'))||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||cast(m.unit_id as varchar)||'_'||cast(vwm.unit_id as varchar)||'_'||cast(p.provider_id as varchar)||'_'||'"+lsNumDoc+"'||'_N'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))||' '||rtrim(m.unit_name)||'|'||'0'||'|' || '3' || '|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/(Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99'))||' '||rtrim(vwm.unit_name)|| '|' ||LTRIM(to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'),  ";
             lsQuery += "p.provider_product_code, Ltrim(prv.name), ";
             lsQuery += "p.provider_product_desc, c.family_desc as category, ";
             lsQuery += "m.unit_name, ROUND(p.provider_price,2), ";
             lsQuery += "CAST('0.00' as varchar) ";
             lsQuery += "FROM ";
             lsQuery += "op_grl_cat_providers_product p INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
             lsQuery += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
             lsQuery += "INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
             lsQuery += "INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id ";
             lsQuery += "LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
             lsQuery += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
             lsQuery += "WHERE p.active_flag<>0 ";
             if (!psProv.equals("0")){
                 lsQuery += "AND prv.provider_id='"+psProv.trim() +"' ";
                 lsFlag="1";
             }
             //lsQuery += " ORDER BY p.provider_product_code ASC ";
             lsQuery += " UNION ";
             lsQuery += "SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))|| ";
             lsQuery += "''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'||RTRIM(UPPER(p.provider_product_desc))||'_'||LTRIM(to_char((Case When s.suggested_quantity IS NULL  then '0' else s.suggested_quantity end),'9999990.99'))||''' onClick = ''selectProduct(this,\"'|| ";
             lsQuery +="LTRIM( to_char((Case When p.conversion_factor IS NULL  then '0' else p.conversion_factor end),'9999990.99'))||'_'||rtrim(m.unit_name)||'_'||rtrim(vwm.unit_name)||'_'||cast(m.unit_id as varchar)||'_'||cast(vwm.unit_id as varchar)||'_'||cast(p.provider_id as varchar)||'_'||'"+lsNumDoc+"'||'_N'||'|'||RTRIM(p.provider_product_code)||'|'||RTRIM(p.provider_product_desc)||'|'||LTRIM(to_char((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end),'9999990.99'))||' '||rtrim(m.unit_name)||'|'||'0'||'|' || '3' || '|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/(Case When p.conversion_factor IS NULL then '0' else p.conversion_factor end)),'9999990.99'))||' '||rtrim(vwm.unit_name)|| '|' ||LTRIM(to_char((Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'|'||LTRIM(to_char(CEIL((Case When s.suggested_quantity IS NULL then '0' else s.suggested_quantity end)/p.conversion_factor)*(Case When p.provider_price IS NULL then '0' else p.provider_price end),'9999990.99'))||'\")''>'),  ";
             lsQuery += "p.provider_product_code, Ltrim(prv.name), ";
             lsQuery += "p.provider_product_desc, c.family_desc as category, ";
             lsQuery += "m.unit_name, ROUND(p.provider_price,2), ";
             lsQuery += "CAST('0.00' as varchar) ";
             lsQuery += "FROM ";
             lsQuery += "op_grl_cat_providers_product p INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
             lsQuery += "INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
             lsQuery += "INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
             lsQuery += "INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id ";
             lsQuery += "LEFT OUTER JOIN op_grl_suggested_order s ON s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0 ";
             lsQuery += "INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure ";
             lsQuery += "WHERE p.active_flag<>0 AND i.family_id = '12800000' ";
             if (!psProv.equals("0")){
                 lsQuery += "AND prv.provider_id='"+psProv.trim() +"' ";
                 lsFlag="1";
             }
             //lsQuery += " ORDER BY p.provider_product_code ASC ";
             lsQuery += " ORDER BY 2 ASC ";
    }
    else// Orden de Compra, sin discrepancia
    {
        lsQuery += " SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'|| ";
        lsQuery += " RTRIM(Ltrim(p.provider_product_code))||'_'||RTRIM(UPPER(i.inv_desc||'/'||p.provider_product_desc))||'_'|| ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity, w.way_quantity),'9999990.99'))|| ";
        lsQuery += " ''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'|| ";
        lsQuery += " RTRIM(UPPER(i.inv_desc||'/'||p.provider_product_desc))||'_'||LTRIM(to_char(isnull(s.suggested_quantity,0),'9999990.99'))|| ''' ";
        lsQuery += " onClick = ''selectProduct(this,\"'|| ";
        lsQuery += " ltrim(rtrim(p.provider_product_code))||'|'||i.inv_desc||'/'||p.provider_product_desc|| '|' || ";
        lsQuery += " LTRIM(to_char(isnull(available_quantity,0),'9999990.99'))||' '||vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(isnull(s.required,0),'9999990.99'))||' '|| vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(isnull(w.way_quantity,0),'9999990.99')) ||' '|| vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99'))||' '||vwm.unit_name|| '|' || ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99'))||' '|| rtrim(vwm.unit_name) || '|' ||";
        lsQuery += " LTRIM(to_char(ROUND(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0),2),'9999990.99'))||' '|| ";
        lsQuery += " rtrim(m.unit_name)||'|'|| ";
        lsQuery += " LTRIM(to_char(CEIL(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0)),'9999990.99'))||' '|| m.unit_name ||'|'||";
        lsQuery += " CEIL(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0))*(p.conversion_factor)||' '|| rtrim(vwm.unit_name) || '|'||";
        lsQuery += " LTRIM(to_char(CEIL(difference(s.suggested_quantity,w.way_quantity)/p.conversion_factor)* isnull(p.provider_price,0),'9999990.99'))|| '|' ||";
        lsQuery += " Ltrim(prv.name)||'|'||LTRIM(to_char(conversion_factor,'9999990.99'))|| '|' ||";
        lsQuery += " rtrim(prv.provider_id||','|| p.provider_unit_measure)|| '|' ||";
        lsQuery += " LTRIM(to_char(provider_price,'9999990.99'))||'\")''>'),  ";
        lsQuery += " Rtrim(Ltrim(p.provider_product_code)), Rtrim(Ltrim(prv.name)), ";
        lsQuery += " i.inv_desc||'/'||p.provider_product_desc, c.family_desc as category, ";
        lsQuery += " m.unit_name, ROUND(p.provider_price,2), ";
        lsQuery += " difference(s.suggested_quantity,w.way_quantity) as suggested ";
        lsQuery += " FROM  ";
        lsQuery += " op_grl_cat_providers_product p INNER JOIN op_grl_cat_inventory i  ON i.inv_id=p.inv_id ";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure ";
        lsQuery += " INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id ";
        lsQuery += " INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id INNER JOIN op_grl_invtran inv ON i.inv_id=inv.inv_id ";
        lsQuery += " LEFT JOIN op_grl_suggested_order s ON ";
        lsQuery += " (s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0) ";
        lsQuery += " LEFT JOIN op_grl_way_order w ON ";
        lsQuery += " (w.provider_product_code=p.provider_product_code AND w.order_id=0)";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure  ";
        lsQuery += " WHERE i.active_flag<>'f' ";
        lsQuery += " AND p.active_flag=1";
         
        if (!psProv.equals("0"))
        {
            lsQuery += " AND prv.provider_id='"+psProv.trim() +"'";
            lsFlag="1";
        }
        //lsQuery += " ORDER BY prv.name ASC, i.inv_desc ASC ";
        lsQuery += " UNION ";
        lsQuery += " SELECT ('<input type = ''checkbox'' name = ''optProduct'||(RTRIM(i.inv_id))||'_'|| ";
        lsQuery += " RTRIM(Ltrim(p.provider_product_code))||'_'||RTRIM(UPPER(i.inv_desc||'/'||p.provider_product_desc))||'_'|| ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity, w.way_quantity),'9999990.99'))|| ";
        lsQuery += " ''' id = ''optProduct'||RTRIM(i.inv_id)||'_'||RTRIM(p.provider_product_code)||'_'|| ";
        lsQuery += " RTRIM(UPPER(i.inv_desc||'/'||p.provider_product_desc))||'_'||LTRIM(to_char(isnull(s.suggested_quantity,0),'9999990.99'))|| ''' ";
        lsQuery += " onClick = ''selectProduct(this,\"'|| ";
        lsQuery += " ltrim(rtrim(p.provider_product_code))||'|'||i.inv_desc||'/'||p.provider_product_desc|| '|' || ";
        lsQuery += " LTRIM(to_char(isnull(available_quantity,0),'9999990.99'))||' '||vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(isnull(s.required,0),'9999990.99'))||' '|| vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(isnull(w.way_quantity,0),'9999990.99')) ||' '|| vwm.unit_name || '|' || ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99'))||' '||vwm.unit_name|| '|' || ";
        lsQuery += " LTRIM(to_char(difference(s.suggested_quantity,w.way_quantity),'9999990.99'))||' '|| rtrim(vwm.unit_name) || '|' ||";
        lsQuery += " LTRIM(to_char(ROUND(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0),2),'9999990.99'))||' '|| ";
        lsQuery += " rtrim(m.unit_name)||'|'|| ";
        lsQuery += " LTRIM(to_char(CEIL(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0)),'9999990.99'))||' '|| m.unit_name ||'|'||";
        lsQuery += " CEIL(difference(s.suggested_quantity,w.way_quantity)/isnull(p.conversion_factor,0))*(p.conversion_factor)||' '|| rtrim(vwm.unit_name) || '|'||";
        lsQuery += " LTRIM(to_char(CEIL(difference(s.suggested_quantity,w.way_quantity)/p.conversion_factor)* isnull(p.provider_price,0),'9999990.99'))|| '|' ||";
        lsQuery += " Ltrim(prv.name)||'|'||LTRIM(to_char(conversion_factor,'9999990.99'))|| '|' ||";
        lsQuery += " rtrim(prv.provider_id||','|| p.provider_unit_measure)|| '|' ||";
        lsQuery += " LTRIM(to_char(provider_price,'9999990.99'))||'\")''>'),  ";
        lsQuery += " Rtrim(Ltrim(p.provider_product_code)), Rtrim(Ltrim(prv.name)),  ";
        lsQuery += " i.inv_desc||'/'||p.provider_product_desc, c.family_desc as category,  ";
        lsQuery += " m.unit_name, ROUND(p.provider_price,2),  ";
        lsQuery += " difference(s.suggested_quantity,w.way_quantity) as suggested ";
        lsQuery += " FROM  ";
        lsQuery += " op_grl_cat_providers_product p INNER JOIN op_grl_cat_inventory i  ON i.inv_id=p.inv_id  ";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure   ";
        lsQuery += " INNER JOIN op_grl_cat_provider prv ON prv.provider_id=p.provider_id    ";
        lsQuery += " INNER JOIN op_grl_cat_family c ON c.family_id=i.family_id   ";
        lsQuery += " LEFT JOIN op_grl_suggested_order s ON ";
        lsQuery += " (s.store_id="+psStore.trim()+" AND s.inv_id=p.inv_id AND s.order_id=0) ";
        lsQuery += " LEFT JOIN op_grl_way_order w ON ";
        lsQuery += " (w.provider_product_code=p.provider_product_code AND w.order_id=0)";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id=i.inv_unit_measure  ";
        lsQuery += " WHERE i.active_flag<>'f' AND i.family_id = '12800000' ";
        lsQuery += " AND p.active_flag=1";
         
        if (!psProv.equals("0"))
        {
            lsQuery += " AND prv.provider_id='"+psProv.trim() +"'";
            lsFlag="1";
        }
        lsQuery += " ORDER BY 3,4 ASC ";

    }
        return(lsQuery);
    }

    String getToday(){
        String lsQuery = "";
        String lsToday = "";
        AbcUtils loAbcUtils = new AbcUtils();
        lsQuery += "SELECT to_char(timestamp 'now','YY-MM-DD HH24:MI:SS')";
        lsToday = loAbcUtils.queryToString(lsQuery,"","");
        return(lsToday);
    }

    
%>
