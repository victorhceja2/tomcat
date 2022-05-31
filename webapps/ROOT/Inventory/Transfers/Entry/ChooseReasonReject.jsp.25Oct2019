<%@ page contentType="text/html"%>
<%@ page import="java.util.*, java.io.*, java.text.*" %>
<%@ page import="generals.*" %>
<%@ page import="jinvtran.inventory.*" %>
<%! 
    AbcUtils moAbcUtils; 
	AplicationsV2 logApps = new AplicationsV2();
%> 
<%@ include file="../Proc/TransferLibYum.jsp" %>

<%
    moAbcUtils = new AbcUtils();
    String loTransferId = request.getParameter("lsTransId");
    String msUser = request.getParameter("hidUser").split(" ")[0];
    logApps.writeInfo("USER Reject: " + msUser);
    logApps.writeInfo("transferencia seleccionada: " + loTransferId);
    String query="SELECT * FROM op_grl_cat_reject_transfer WHERE reject_id > 0";
    String loRejects=moAbcUtils.queryToString(query,">",",");
    HashMap<String,String> loDescRejects = new HashMap<String,String>();
    if (loRejects.contains(">")){
      String []loRowsReject=loRejects.split(">");
      for(String loRowReject : loRowsReject){
	    String []loReject=loRowReject.split(",");
	    loDescRejects.put(loReject[0],loReject[1]);
      }
    }else{
      String []loReject=loRejects.split(",");
      loDescRejects.put(loReject[0],loReject[1]);
    }
%>

<html>
    <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
    <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
    <style>
        .textP{ 
            color: #000099;
            font-family: Arial, Helvetica, Verdana, sans-serif; 
            font-size: 14px;
            font-weight: bold;
            padding-top: 6px;
        }
        .maintitleLocal { 
            color:red; 
            font-family: Verdana; 
            font-style:normal; 
            font-weight: 
            bold; font-size: 14pt
        }
        .textGhost{ 
            color: #FFFFFF;
            font-family: Arial, Helvetica, Verdana, sans-serif; 
            font-size: 11px;
        }


    </Style>
    <head>
        <title>Transferencias</title>
    </head>
    
    <script src="/Scripts/RemoteScriptingYum.js"></script>
    
    <script>
      function closeWindow(lsResult){
    if(lsResult == "OK"){
      window.close();
    }
   // else{
   //   alert ('No se pudo rechazar la transferencia');
   // }
      }
      
      function submitReject(){
    var loRzReject=document.frmReject.rzRejct.value;
    if( loRzReject != "-1" ){
      var loParmsReject= loRzReject + ',' + <%=loTransferId%> + ',' + <%=msUser%>;
      jsrsExecute("RemoteMethodsYum.jsp", closeWindow, "updateReject", loParmsReject);
          }else{
      alert('Debe seleccionar una raz&oacute;n de rechazo');
          }
      }
      
    </script>
    <body bgcolor = 'white' OnLoad = ''>
    <form id="frmReject" name="frmReject">
    <p class="maintitleLocal">Confirmacion de rechazo del traspaso</p>
    <p class="textP">Por favor seleccione la raz&oacute;n por la que se rechaza la transferencia tome en cuenta que se cancelara el traspaso en ambos restaurantes.</p>
    <br>
    <div id="tableSelect" align="center">
      <table width="100%" id="tblSelect" align="center">
    <tr>
      <td>
        <p class="textGhost">&nbsp;</p>
      </td>
      <td align="center">
        <select id="rzRejct" name="rzRejct" size="1" class="combos" onChange="">
          <option value="-1" selected>-- Seleccione una opci&oacute;n --</option>
          <%
        writeOptions(out,loDescRejects);
          %>
        </select>
      </td>
    </tr>
    <tr>
      <td colspan="1">
        <div id="buttons">
          <td align="center">
          <input type="button" id="btnReject" name="btnReject" onClick="submitReject()" value="Aceptar" class="combos"/>
          <input type="button" id="btnCancel" name="btnCancel" onClick="closeWindow('OK')" value="Cancelar" class="combos"/>
          </td>
        </div>
      </td>
    </tr>
      </table>
    </div>
    
    </form>
    </body>
</html>
