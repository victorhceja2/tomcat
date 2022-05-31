<jsp:include page = '/Include/ValidateSessionYum.jsp'/>
<%--
##########################################################################################################
# Nombre Archivo  : TextPromFormDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Mario Chávez Ayala     
# Objetivo        : Mostrar el detalle del formato de captura de ar este valor.
# Fecha Creacion  : 24/Febrero/2006
# Inc/requires    : ../Proc/HouseholdLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria HouseholdLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@page import="java.util.*" %>
<%@page import="generals.*" %>
<%@page import="java.io.*" %>

<%! 
    AbcUtils moAbcUtils = new AbcUtils();;
%>

<%@ include file="/Include/CommonLibYum.jsp" %>

<%
        HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
        moHtmlAppHandler.setPresentation("VIEWPORT");
        moHtmlAppHandler.initializeHandler();	
        moHtmlAppHandler.msReportTitle = getCustomHeader("House Hold Volanteo", "frmGrid");
        moHtmlAppHandler.updateHandler();
        moHtmlAppHandler.validateHandler();

	String nameCC = getStoreName();
	String idCC = getStore();
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <link rel="stylesheet" type="text/css" href="/CSS/DataGridDefaultYum.css"/>
		<style>
                   .supTit{
                   color: #000099;
                   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
		   }
                   .entry{
                   background-color: #FFFFFF;
                   color: #000099;
                   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 0px;
                   }
                   .entryin{
                   background-color: #FFFFFF;
                   color: #000099;
                   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   border-top: 0px;
                   border-left: 0px;
                   border-right: 0px;
	           }
                   .entryex{
                   background-color: #FFFFFF;
                   color: #000099;
                   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   border-top: 0px;
                   border-left: 0px;
                   border-right: 0px;
                   }
	    	   .show{
		   background-color: #CCCCFF;
		   color: #000099;
		   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 1px solid #CCCCFF;
                   border-bottom: 1px solid #CCCCFF;
                   }
                   .showin{
                   background-color: #CCCCFF;
                   color: #000099;
                   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   font-weight: bold;
                   border-top: 0px;
                   border-left: 0px;
                   border-right: 0px;
                   border-bottom: 1px solid #CCCCFF;
                   }
		   .cel_right{
                   border-left: 1px solid #000000;
		   color: #000099;
		   font-size: 9px;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   }
		   .cel_down{
                   border-top: 1px solid #000000;
                   }
		   .gray_cel{
                   background-color: #BBBBCC;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 1px solid #BBBBCC;
                   border-bottom: 1px solid #BBBBCC;
		   }
		  .gray_celin{
                   border: 0px;
	           background-color: #BBBBCC;
                   border-right: 1px #BBBBCC;
                   border-bottom: 1px #BBBBCC;
                   }
		   .titlea{ 
                   background-color: #DDDDFF;
                   color: #000099;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
                   font-size: 9px;
                   font-weight: bold;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 0px;
                   border-bottom: 0px;
                   padding-top: 6px;
                   }

		   .titleb{
                   background-color: #DDDDDD;
                   color: #000099;
                   font-family: Arial, Helvetica, Verdana, sans-serif; 
		   font-size: 9px;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 0px;
                   padding-top: 6px;
		   }
		   .tab_print{
                   border: 1px solid #000000;
                   background-color: #EEEEFF;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 0px;
                   border-bottom: 0px;
                   }
		   .tab_printin{
                   border: 0px;
                   background-color: #EEEEFF;
                   border-top: 0px;
                   border-left: 0px;
                   border-right: 0px;
                   }
                   .left_border{
                   border: 1px;
                   background-color: #CCFFFF;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 1px solid #000000;
                   }
                   .ageb{
                   border: 1px;
                   background-color: #EEEEFF;
                   border-top: 1px solid #000000;
                   border-left: 1px solid #000000;
                   border-right: 0px;
                   border-bottom: 0px;
                   }
                   .agebin{
                   border: 1px;
                   background-color: #EEEEFF;
                   border-top: 0px;
                   border-left: 0px;
                   border-right: 0px;
                   border-bottom: 0px;
                   }
			
		</style>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/MiscLibYum.js"></script>
        <script src="/Scripts/DataGridClassYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script type="text/javascript">

		var data=<%= moAbcUtils.getJSResultSet(getQryAgeb()) %>;

        function getHouse(loEntry){
		   var ageb=loEntry.value;
    	   var agebUpper=loEntry.value.toUpperCase();
 		   var objId="";
		   var agebInd=loEntry.value.indexOf("-");
		   var Id="";
		  
           for(i=0;i<data.length;i++){  /* Modifica en caso de que metan minusculas o la dejen en blanco*/
              house=data[i];
              if(agebUpper == house[0]){
                 objId = loEntry.id + "B";
                 document.getElementById(objId).value = house[1];
                 document.getElementById(loEntry.id).value = agebUpper;
	          }else{
                 if (ageb == ""){
                    document.getElementById(objId).value = "";
				 }
              }
		   }
		   for(k=11;k<58;k++){  /* Verifica que no le metan datos repetidos de ageb*/
			  if(k==18 || k==19 || k==20 || k==28 || k==29 || k==30 || k==38 || k==39 || k==40 || k==48 || k==49 || k==50){
			     continue;
			  }
		      Id="dex" + k;
              IdIndex="" + Id + "B";
              if(loEntry.id != Id && loEntry.value==document.getElementById(Id).value && loEntry.value != "" && loEntry.value != null){
                 document.getElementById(loEntry.id).value = "";
                 document.getElementById(objId).value = "";
			  }
              if(loEntry.id != Id && agebUpper != house[0] && loEntry.value != "" && loEntry.value != null && agebInd < 1 ){
                 objId = loEntry.id + "B";
                 document.getElementById(objId).value = "";
                 document.getElementById(loEntry.id).value = "";
			  }
		   }
		   tot=0;
           for(h=11;h<58;h++){ /* Barre para obtener la suma de los house hold*/
			  if(h==18 || h==19 || h==20 || h==28 || h==29 || h==30 || h==38 || h==39 || h==40 || h==48 || h==49 || h==50){
			     continue;
			  }
			  ind="dex" + h + "B";
              num=parseInt(document.getElementById(ind).value);
              if(!isNaN(num)){
			     tot+=parseInt(document.getElementById(ind).value);
		      }
		   }
		   document.getElementById("IndexC").value = tot;
		}

        function submitDelete(){
           lsVal=document.frmGrid.index1.value;
		   txt="Seguro que desea borrar los datos\n"
		   txt+="se borraran en todos los campos "+lsVal+"\n"
		   confirm(txt);
        }

        var cc=<%= moAbcUtils.getJSResultSet(getCC()) %>;
		function putCC(){
		  var centro="centro";
		  nameCC=cc[0];
          document.getElementById(centro).value = nameCC; 
		}

        </script>
    </head>

    <body bgcolor="white">
      <form name="frmGrid" id="frmGrid" >
	  <table width="90%" border="0" ><tr valign=top ><td width="90%">
          <table width="100%" border="0" cellspacing=0 cellpadding=0 >
		  <tr>
		    <td class="supTit" width="10%">&nbsp;Sucursal&nbsp;<%=idCC%></td>
			<td class="supTit" width="10%" >&nbsp;<%=nameCC%></td>
			<td width="10%" ></td>
			<td class="supTit" width="10%">&nbsp;&nbsp;&nbsp;Promoci&oacute;n</td>
			<td class="entryex" width="10%" ><input class="entryex" type="text" size="8"></td>
			<td width="10%" >&nbsp;</td>
			<td class="supTit" width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Vigencia</td>
			<td class="entryex" width="10%" ><input class="entryex" type="text" size="8"></td>
			<td class="supTit" width="20%" colspan="2" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Volanteo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td width="1%" >&nbsp;</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td class="cel_down">&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td class="cel_down">&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td class="cel_down">&nbsp;</td>
		    <td class="entry">&nbsp;Interno</td>
		    <td class="entry">&nbsp;Externo&nbsp;&nbsp;&nbsp;</td>
			<td class="cel_right" >&nbsp;</td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		    <td class="cel_down">&nbsp;</td>
		    <td class="cel_down">&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
                  <tr>
		    <td class="titlea" >&nbsp;SEM PROM</td>
		    <td class="titlea" >&nbsp;SEM YUM</td>
		    <td class="titleb" >&nbsp;Jueves</td>
		    <td class="titlea" >&nbsp;Index (LW)</td>
		    <td class="titleb" >&nbsp;Viernes</td>
		    <td class="titlea" >&nbsp;Index (LW)</td>
		    <td class="titleb" >&nbsp;Sábado</td>
		    <td class="titlea" >&nbsp;Index (LW)</td>
		    <td class="titlea" >&nbsp;AGEBS&nbsp;Co-Relación</td>
		    <td class="titlea" >&nbsp;House hold</td>
		    <td class="cel_right" >&nbsp;</td>
                 </tr>
                 <tr>
		  <%
		    for(int i=1;i<8;i++){
			    
                out.println(
                    "<td class='titlea' >&nbsp;SEM " + i + "</td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index1" + i + "'   ></td>"
                    +"<td class='tab_print' nowrap><input class='tab_printin' type='text' size='8' id='Index2" + i + "' ></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index3" + i + "'   ></td>"
                    +"<td class='tab_print' nowrap><input class='tab_printin' type='text' size='8' id='Index4" + i + "' ></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index5" + i + "'   ></td>"
                    +"<td class='tab_print' nowrap><input class='tab_printin' type='text' size='8' id='Index6" + i + "' ></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index7" + i + "'   ></td>"
                    +"<td class='ageb' nowrap><input class='agebin' type='text' name='dex1" + i + "' size='14' id='dex1" + i + "' maxlength=4 onBlur=getHouse(this); ></td>"
		    +"<td class='show' nowrap><input class='showin' type='text' name='dex1" + i + "B' size='10' Id='dex1" + i + "B' maxlength=5 readonly></td>"
                    +"<td class='cel_right'>&nbsp;</td>"
    		      +"</tr>"
    		      +"<tr>"
                    +"<td class='entry' nowrap><input  class='entryin' type='text' size='8' id='Index8" + i + "'   ></td>"
                    +"<td class='titlea'>&nbsp;Nombre</td>"
                    +"<td class='entry' nowrap><input  class='entryin' type='text' size='8' id='Index9" + i + "'   ></td>"
    	            +"<td class='titlea'>&nbsp;Index (LW)</td>"
                    +"<td class='entry' nowrap><input  class='entryin' type='text' size='8' id='Index10" + i + "'   ></td>"
                    +"<td class='titlea'>&nbsp;Index (LW)</td>"
                    +"<td class='entry' nowrap><input  class='entryin' type='text' size='8' id='Index11" + i + "'   ></td>"
                    +"<td class='titlea'>&nbsp;Index (LW)</td>" 
                    +"<td class='ageb' nowrap><input class='agebin' type='text' name='dex2" + i + "' size='14' id='dex2" + i + "' maxlength=4 onBlur=getHouse(this); ></td>"
		    +"<td class='show' nowrap><input class='showin' type='text' name='dex2" + i + "B' size='10' Id='dex2" + i + "B' maxlength=5 readonly></td>"
                    +"<td class='cel_right'>&nbsp;</td>"
                  +"</tr>"
                  +"<tr>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index12" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index13" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index14" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='ageb' nowrap><input class='agebin' type='text' name='dex3" + i + "' size='14' id='dex3" + i + "' maxlength=4 onBlur=getHouse(this); ></td>"
		    +"<td class='show' nowrap><input class='showin' type='text' name='dex3" + i + "B' size='10' Id='dex3" + i + "B' maxlength=5 readonly></td>"
	            +"<td class='cel_right'>&nbsp;</td>"
                  +"</tr>"
	          +"<tr class='bsDg_td_row_zebra_1'>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index15" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index16" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='ageb' nowrap><input class='agebin' type='text' name='dex4" + i + "' size='14' id='dex4" + i + "' maxlength=4 onBlur=getHouse(this); ></td>"
		    +"<td class='show' nowrap><input class='showin' type='text' name='dex4" + i + "B' size='10' Id='dex4" + i + "B' maxlength=5 readonly></td>"
	            +"<td class='cel_right'>&nbsp;</td>"
    	         +"</tr>"
    	         +"<tr>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index17" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='entry' nowrap><input class='entryin' type='text' size='8' id='Index18" + i + "'   ></td>"
	            +"<td class='gray_cel' ><input class='gray_celin' type='text' size='8' readonly></td>"
                    +"<td class='ageb' nowrap><input class='agebin' type='text' name='dex5" + i + "' size='14' id='dex5" + i + "' maxlength=4 onBlur=getHouse(this); ></td>"
		    +"<td class='show' nowrap><input class='showin' type='text' name='dex5" + i + "B' size='10' Id='dex5" + i + "B' maxlength=5 readonly></td>"
	            +"<td class='cel_right'>&nbsp;</td>"
                    +"</tr>"
	        );
		    }
             out.println(
			    "<tr>"
				+"<td class='cel_down' nowrap>&nbsp;</td><td class='cel_down' nowrap>&nbsp;</td>"
				+"<td class='cel_down' nowrap>&nbsp;</td><td class='cel_down' nowrap>&nbsp;</td>"
				+"<td class='cel_down' nowrap>&nbsp;</td><td class='cel_down' nowrap>&nbsp;</td>"
				+"<td class='cel_down' nowrap>&nbsp;</td><td class='cel_down' nowrap>&nbsp;</td>"
				+"<td class='show' ><input class='showin' type='text' size='17' value='  Total HH  ' readonly></td>"
				+"<td class='show' nowrap><input class='showin' type='text' name='IndexC' Id='IndexC' size='10' maxlength=7 readonly></td>"
				+"<td class='cel_right'>&nbsp;</td>"
			    +"</tr>" 
				+"<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td class='cel_down'>&nbsp;</td><td class='cel_down'>&nbsp;</td></tr>"
			  );
		%>

        </table>
      </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
<%!

	String getQryAgeb(){
      String lsQuery = "";
	  lsQuery+="SELECT ";
	  lsQuery+="ageb_id, house_hold ";
	  lsQuery+="FROM op_hh_ageb ";
	  //lsQuery+="WHERE ageb_id =" + lsAgeb_id + " ";

	  return(lsQuery);
	}
   
    String getCC(){
	  String lsQry="";
	  lsQry+="SELECT store_desc, store_id FROM ss_cat_store ";
	  return(lsQry);
	}

%>
