<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : RecepSelectYum.jsp
# Compa?ia        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Selecci?n de Filtro para Recepciones
# Fecha Creacion  :12-Nov-04
# Inc/requires    :
# Modificaciones  :
# Fecha           Programador     Observaciones
# _____________________________________________
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%
    AbcUtils moAbcUtils = new AbcUtils();
    String msFillOrd="";

    HtmlAppHandler moHtmlAppHandler;

    //out.println(getOrderRemiQuery());
    msFillOrd=moAbcUtils.queryToString(getOrderRemiQuery(),"@","|");
    //out.println("asdasdasdas="+msFillOrd);
    moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    moHtmlAppHandler.msReportTitle = "Captura de Facturas";
 %>
<%!

    String getOrderRemiQuery(){

	   String lsQuery=" SELECT distinct  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar),cast(rtrim(o.order_id) as         Varchar)";
	   lsQuery+="FROM  op_grl_order_detail o ";
           lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id";
	   lsQuery+=" WHERE  o.order_id not in (SELECT DISTINCT order_id FROM op_grl_remission )";
	  lsQuery+=" AND  rtrim(ltrim(o.order_id)||'_'||ltrim(o.provider_id)) NOT IN (SELECT DISTINCT rtrim(ltrim(rp.order_id)||'_'||ltrim(rp.provider_id)) FROM op_grl_reception rp) ";

           lsQuery+=" UNION " ;
	   lsQuery+=" SELECT DISTINCT  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar)||'_'||cast(rtrim(r.remission_id) as         Varchar),cast(rtrim(o.order_id) as         Varchar)||'/'||cast(rtrim(r.remission_id) as         Varchar)";
	   lsQuery+="FROM  op_grl_order_detail o ";
           lsQuery+=" INNER JOIN op_grl_remission r ON r.order_id=o.order_id  AND r.provider_id=o.provider_id ";
	   lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id ";


	   return(lsQuery);

    }

    String getSuppQuery() {
        String lsQuery = "";
        lsQuery+= "SELECT ltrim(rtrim(provider_id)),name";
        lsQuery+= " FROM op_grl_cat_provider ";
        lsQuery+= " order by name  asc ";
  return(lsQuery);
  }

%>

<html>
    <head>
        <title>Captura de Facturas</title>
        <link rel='stylesheet' href='/CSS/GeneralStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/TabStandardsYum.css' type='text/css'>
	<link rel='stylesheet' href='/CSS/CalendarStandardsYum.css' type='text/css'>
    </head>

    <script src="/Scripts/AbcUtilsYum.js"></script>

    <script>
        var gaKeys = new Array('txtDummie');

        function adjustPageSettings() {
            adjustContainer(60,210);
        }


        function validateSearch() {
            if (document.frmMaster.cmbProv.selectedIndex==0) {
	        alert("Por favor, seleccione un proveedor v?lido.");
                document.frmMaster.cmbProv.focus();
                return(false);
            }
	    if (document.frmMaster.cmbSub.selectedIndex==0){
	    	alert("Por favor, seleccione una orden/remisi?n.");
    		document.frmMaster.cmbSub.focus();
                return(false);
	    }

		var loframe = window.frames['ifrDetail'];
		if(loframe.document.getElementById('tblMdx')){
			var loTable = loframe.document.getElementById("tblMdx");
			for(i=0;i<loTable.rows.length-1; i++){
				if(!loframe.document.getElementById('chkRowControl|'+i)){
					continue;
				}
				if(loframe.document.getElementById('chkRowControl|'+i).value==2){
					alert("Por favor, si desea guardar los cambios pulse el bot?n de actualizar.");
					loframe.document.getElementById('note_id|'+i).focus();
					return(false);
				}
			}
		}

            return(true);
        }


        function loadSubCmb() {
           var loProv = window.document.frmMaster.cmbProv;
           window.document.frmMaster.cmbSub.length=1;
           var loSub = window.document.frmMaster.cmbSub;
           var lsFillOrd='<%=msFillOrd%>';
           var laRowData=lsFillOrd.split('@');

           var liPrv=loProv.options[loProv.selectedIndex].value;
           var liLocalCounter=1;
           for(i=0;i< laRowData.length;i++){
               laColData=laRowData[i].split('|');
	       //alert("prv="+liPrv+" data=" +laColData[0]);
               if (laColData[0].indexOf(liPrv)>=0){
                   loSub.options[liLocalCounter]=new Option(laColData[1],laColData[0]) ;
		    //loSub.options[liLocalCounter]=new Option(laColData[2],laColData[2]) ;
                    liLocalCounter=liLocalCounter+1;
                }
           }
        }

        function sendVars(){
           parent.liRowCountRecep=0;
           parent.lsProductoCodeRecepLst="";
           if (document.frmMaster.cmbProv.value=='-1'){
             alert('Debe seleccionar un proveedor para realizar la recepción.');
             document.frmMaster.cmbProv.focus();
             return(false);
           }else
             document.frmMaster.submit();
           
       
        }

    </script>

    <body onResize='adjustPageSettings();' bgcolor = 'white'>
        <table border='0' cellspacing='0' cellpadding='0' width='100%' ID='tbl_title'>
            <tr>
                <td align='left'>
                    <form id = 'frmMaster' name = 'frmMaster' target='ifrInnerDetail' method = 'post' action = 'RecepDetailYum.jsp'  >
                        <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
                        <table id = 'tblCapture' border = 0>
			   <tr>
                                <td class = 'body'>
                                    Proveedor:
                                </td>
                                <td>
				<%  //out.println(getOrderRemiQuery());%>
                                    <select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos' onChange='loadSubCmb();'>
				    <option value="-1"selected> -- Seleccione un Proveedor-- </option>
                                        <%
                                            moAbcUtils.fillComboBox(out,getSuppQuery());
                                        %>
                                    </select>
                                </td>
                                <td class = 'body'>
                                    &nbsp;
                                </td>
                                <td class = 'body'>
                                    Ordenes/Remisiones:
                                </td>
                                <td>
                                    <select  id = 'cmbSub' name = 'cmbSub' size = '1' class = 'combos'  >
                                        <option value='-1'>-- Sin Orden/Remisión --
                                    </select>
                                </td>
                                <td>
                                    <input type = 'button' id = 'btnSubmit' name = 'btnSubmit' value = 'Mostrar' class = 'combos' onClick = 'sendVars();'>
                                </td>
                            </tr>
                        </table>
                    </form>
                </td>
            </tr>
	</table>
        <table border='0' cellspacing='0' cellpadding='0' width='100%' id='tblCourse'>
            <tr valign = 'top'>
                <td>
                    <br>
		<iframe src="RecepDetailYum.jsp"
			id="ifrInnerDetail"
			name="ifrInnerDetail"
			style="width: 100%;
			height: 270px;
			margin-left: 0%;
			border: 0px solid #000000;"
		></iframe>

                </td>
            </tr>
        </table>
        <script> adjustPageSettings(); </script>
    </body>
</html>



