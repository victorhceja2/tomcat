<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : BillMasterYum.jsp
# Compania        : Yum Brands Intl
# Autor           : AKG/SC
# Objetivo        : Captura de Facturas en RSt
# Fecha Creacion  : 28/Oct/2004
# Inc/requires    :
# Modificaciones  : 27/Mayo/2005
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%
    AbcUtils moAbcUtils = new AbcUtils();
    String msFillAcc="hola";

    HtmlAppHandler moHtmlAppHandler;


    msFillAcc=moAbcUtils.queryToString(getVendorQuery(),"@","|");

    moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.initializeHandler();
    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    moHtmlAppHandler.msReportTitle = "Captura de Facturas";
 %>
<%!

    String getVendorQuery(){
	   String lsQuery=" SELECT rtrim(a.supp_id),cast(rtrim(b.acc_id) as Varchar)||'_'||cast(rtrim(b.sub_acc_id) as Varchar),rtrim(c.sub_acc_desc) ";
	   lsQuery+="FROM  op_gsv_cat_supplier a ";
           lsQuery+=" INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id ";
           lsQuery+=" INNER JOIN op_gsv_cat_sub_account c ";
           lsQuery+=" ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id";
	   return(lsQuery);

    }

    String getSuppQuery() {
        String lsQuery = "";
        lsQuery+= "SELECT cast(rtrim(supp_id) as varchar)||'_'||cast(tax as varchar),supp_name";
        lsQuery+= " FROM op_gsv_cat_supplier";
        lsQuery+= " order by supp_name  asc ";
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
    <script src="/Scripts/Chars.js"></script>

    <script>
        var gaKeys = new Array('txtDummie');

        function adjustPageSettings() {
            adjustContainer(60,210);
        }

        function loadFirstTab() {
            browseDetail('InvoiceEntryYum.jsp','InvoiceEntryYum.jsp','1');
	}

        function validateSearch() 
        {
            if (document.frmMaster.cmbProv.selectedIndex==0)
            {
	            alert("Por favor, seleccione un proveedor valido.");
                document.frmMaster.cmbProv.focus();
                return(false);
            }
	    
            if (document.frmMaster.cmbSub.selectedIndex==0)
            {
	    	    alert("Por favor, seleccione una subcuenta valida.");
    		    document.frmMaster.cmbSub.focus();
                return(false);
	        }

		    var loframe = window.frames['ifrDetail'];

		    if(loframe.document.getElementById('tblMdx'))
            {
			    var loTable = loframe.document.getElementById("tblMdx");

			    for(i=0;i<loTable.rows.length-1; i++)
                {
				    if(!loframe.document.getElementById('chkRowControl|'+i))
                    {
					    continue;
				    }
                    
				    if(loframe.document.getElementById('chkRowControl|'+i).value==2)
                    {
                        if(confirm( _oQuestion + 'Antes de cambiar de proveedor/subcuenta, desea guardar sus cambios' + _cQuestion))
                        {
                            loframe.f_submit_form();
                            document.frmMaster.cmbSub.selectedIndex=0;
                            //loframe.onInsertAction(false);
                            return false;
                        }    
                        else
                        {
                		    var loTable = loframe.document.getElementById("tblMdx");
                		    for(j=0; j<loTable.rows.length-1; j++)
                            {
            				    if(!loframe.document.getElementById('chkRowControl|'+j))
                                continue;
                                else
                                {
                                loframe.document.getElementById('chkRowControl|'+j).checked=false;
                                loframe.document.getElementById('chkRowControl|'+j).value='0';
                                }
                            }
                            loframe.f_submit_form();
                            document.frmMaster.cmbSub.selectedIndex=0;
                            return false;
                        } 
				    }
			    }
		    }


	    document.frmMaster.hidSuppSubAccNames.value = document.frmMaster.cmbProv.options[document.frmMaster.cmbProv.selectedIndex].text + "_" +document.frmMaster.cmbSub.options[document.frmMaster.cmbSub.selectedIndex].text;
            return(true);
        }


        function loadSubAcc() {
           var loProv = window.document.frmMaster.cmbProv;
           window.document.frmMaster.cmbSub.length=1;
           var loSub = window.document.frmMaster.cmbSub;
           var lsFillAcc='<%=msFillAcc%>';
           var laRowData=lsFillAcc.split('@');
           var liPrv=loProv.options[loProv.selectedIndex].value;
           liPrv=liPrv.substr(0,liPrv.indexOf('_'));
           var liLocalCounter=1;
           for(i=0;i< laRowData.length;i++){
               laColData=laRowData[i].split('|');
               if (laColData[0]==liPrv){
                    loSub.options[liLocalCounter]=new Option(laColData[2],laColData[1]) ;
                    liLocalCounter=liLocalCounter+1
                }
           }
        }

	function findVendor(){
		var loProv = window.document.frmMaster.cmbProv;
		var lsValue = window.document.frmMaster.txtFinder.value;
		if(lsValue == ""){
			alert("Por favor, capture una busqueda valida!");
			return;
		}

        lsValue = lsValue.toLowerCase();
        lsNewValue = lsValue.replace(/\s/,'.*');

		for(i=0;i< loProv.length;i++){
            lsProvName = loProv[i].text.toLowerCase();
            myExp = new RegExp(lsNewValue); //+".*");

            if(lsProvName.match(myExp))
            {
				loProv.selectedIndex = i;
				loadSubAcc();
				return;
            }

		}
		alert("No existe el proveedor para el criterio capturado.");
	}

    function addRecord()
    {
         if (document.frmMaster.cmbProv.selectedIndex==0)
            {
	            alert("Por favor, seleccione un proveedor valido.");
                document.frmMaster.cmbProv.focus();
                return(false);
            }
	    
            if (document.frmMaster.cmbSub.selectedIndex==0)
            {
	    	    alert("Por favor, seleccione una subcuenta valida.");
    		    document.frmMaster.cmbSub.focus();
                return(false);
	        }


		var loFrame = window.frames['ifrDetail'];
        loFrame.onInsertAction(false); 
    }
	function browseDetailCustom(psAction,psOppAction,psTabId) 
    {
		var loframe = window.frames['ifrDetail'];
		if(loframe.document.getElementById('tblMdx')){
			var loTable = loframe.document.getElementById("tblMdx");
			for(i=0;i<loTable.rows.length-1; i++){
				if(!loframe.document.getElementById('chkRowControl|'+i)){
					continue;
				}
				if(loframe.document.getElementById('chkRowControl|'+i).value==2){
					alert("Por favor, si desea guardar los cambios pulse el botón de actualizar.");
					loframe.document.getElementById('note_id|'+i).focus();
					return;
				}
			}
		}
                document.frmMaster.hidOperation.value = gsOppBrowse;
                document.frmMaster.action = psAction;
                document.frmMaster.target = 'ifrDetail';
                document.frmMaster.submit();
                document.frmMaster.action = psOppAction;
                document.frmMaster.target = 'ifrProcess' ;
                synchTab(psTabId);
    }
    function check_submit(poEvent, objUsed)
    {
       var liKeyCode = handleKeyEvents(poEvent, objUsed);
       if(liKeyCode == 13)
       {
        findVendor();
       }
    }
    </script>

    <body onResize='adjustPageSettings();' bgcolor = 'white'>
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'/>
        <table border='0' cellspacing='0' cellpadding='0' width='100%' ID='tbl_title'>
            <tr>
                <td align='left'>
                    <form id = 'frmMaster' name = 'frmMaster' method = 'post' action = 'InvoiceEntryYum.jsp' onSubmit="return false">
                        <input type='hidden' name='hidOperation' id='hidOperation' value='S'>
			<input type='hidden' name='hidSuppSubAccNames' id='hidSuppSubAccNames' value=''>
                        <table id = 'tblCapture' border = 0>
			    <tr>
                                <td class = 'body' >
					Proveedor:
				</td>
				<td class = 'body'>
					<input type='text' id = 'txtFinder' name = 'txtFinder' size='40' class = 'combos' onKeyDown="check_submit(event, this);">
				</td>
				<td class = 'body' colspan=5 align='left'>
					<input type = 'button' id = 'btnFinder' name = 'btnFinder' value = 'Buscar' class = 'combos' onClick = 'findVendor();'>
				</td>
			    </tr>
                            <tr>
                                <td class = 'body'>
                                    Proveedor:
                                </td>
                                <td>
                                    <select id = 'cmbProv' name = 'cmbProv' size = '1' class = 'combos' onChange='loadSubAcc();'>
				    <option value="-1"selected> -- Seleccione un Proveedor-- </option>
                                        <%
                                            moAbcUtils.fillComboBox(out,getSuppQuery());
                                        %>
                                    </select>
                                </td>
                                <td class = 'body'>
                                    Subcuenta:
                                </td>
                                <td>
                                    <select  id = 'cmbSub' name = 'cmbSub' size = '1' class = 'combos' onChange='loadFirstTab();' >
                                        <option value='-1'>-- Subcuentas--
                                    </select>
                                </td>
                                <td class = 'body'>
                                    &nbsp;&nbsp;
                                </td>
                                <td class = 'body'>
                                    <input type="button" value="Agregar" onClick="addRecord()">
                                </td>
                            </tr>
                        </table>
                    </form>
                </td>
            </tr>
	</table>
        <table border='0' cellspacing='0' cellpadding='0' width='95%' id='tblCourse'>
            <tr valign = 'top'>
                <td>
                    <br>
                    <div class='tabBox' style='clear:both'>
                        <div class='tabArea'>
                            <a class='tab' id ='1' href = 'javascript:loadFirstTab();'>Captura de Facturas</a>
                        </div>
                        <div class='tabMain'>
                            <div class='tabIframeWrapper'>
                                <iframe class='tabContent' name='ifrDetail' id='ifrDetail' marginWidth='8' marginHeight='8' frameBorder='0'></iframe>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        <script> adjustPageSettings(); </script>
    </body>
</html>

