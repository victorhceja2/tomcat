<%--
############################################################
# Nombre Archivo  : InventoryReportYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Quetzalcoatl Pantoja Hinojosa
# Objetivo        : .
# Fecha Creacion  : 18/Ago/09
# Inc/requires    :
# Modificaciones  :
############################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>

<%! AbcUtils moAbcUtils = new AbcUtils();
    String lsDay;
    %>

<link href="../../CSS/GeneralStandardsYum.css" type="text/css" rel="stylesheet">
<html>
	<head>
		<script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
	</head>
<style  TYPE="text/css"> 
        <!--
       body
       {
           font-size: 11px;
           font-family: Verdana, Arial, Helvetica, sans-serif; 
       }
       ul ul li
       {
           font-size: 11px;
           font-decoration: italic;
       }
       .detail-desc
       {
           background-color: #E6E6FA;
           color: #000099;
           font-size:   11px;
           font-weight: bold;
           font-family: Verdana, Arial, Helvetica, sans-serif; 
           padding-left: 10px;
       }
       .detail-cont
       {
           background-color: #EFEFEF;
           font-size:   18px;
           color: #000099;
           font-family: Verdana, Arial, Helvetica, sans-serif; 
           padding-left: 5px;
       }
       .avisos
       {
           background-color:#a91616;
	   border=1;
           margin: 2px 5px 0 0; 
           font-size:   11px;
           font-color:  #FF0000;
           color: #000099;
           font-family: Verdana, Arial, Helvetica, sans-serif; 
           padding-left: 5px;
       }
</style> 
	<body class="text" onLoad="doAction()" style="margin-left: 0px; margin-right: 0px">
	     <p class="detail-cont" align="center" font size="20pt" >Bienvenido a la p&aacute;gina soporte t&eacute;cnico</p>
	     <p class="detail-desc" align="center">En esta p&aacute;gina encontrar&aacute;s guias gr&aacute;ficas con las que te podr&aacute;s ayudar en caso de alg&uacute;na eventualidad en el sistema o simplemente como referencia mientras recibes apoyo por parte de nuestros expertos en soporte t&eacute;cnico.</p>

        <table class="body">
        <tr>
           <td WIDTH="70%" valign="top" >

   	      <p class="Combos">Opciones:</p>
	   	     <ul>
   	        	<li><a href="http://192.168.101.228/php/requestDispatcher.php?action=getReports&&cc=<%=getStore()%>" ><font color="#880808" size="4px" >** Consulta aqu&iacute; el status de tus reportes escalados a 2do y 3er nivel por el equipo de soporte **</font></a><br></li>
   	        	<!--<li><a href="http://trac.prb.net/php/requestDispatcher.php?action=getReports&&cc=<%=getStore()%>" ><font color="#880808" size="4px" >** Consulta aqu&iacute; el status de tus reportes escalados a 2do y 3er nivel por el equipo de soporte **</font></a><br></li>-->
   	     		</ul>
   	     </p>
   	      <p class="Combos">Claves del servicio de Inf&iacute;nitum M&oacute;vil para clientes:</p>
	            <div valign="botton" >
         	      <iframe name ='ifrMainContainer' id ='ifrMainContainer' src="http://192.168.101.228/php/requestDispatcher.php?action=getTelmex" height="60px" width = '100%' frameborder = '0' ></iframe>
         	   </div>
   	     </p>
   	   <p class="Combos">Guias gr&aacute;ficas:
	   	     <ul>
	   	        <li><a href="Manual/infinitum/ConexionInfinitum.html">Manual de conexion de infinitum</a><br></li>
	   	        <li><a href="Manual/terminales/seleccionaTerminal.html">Manual de conexion de terminales</a><br></li>
	   	        <li><a href="Manual/whozz/whozz_calling.html">Manual de conexion de whozz calling</a><br></li>
			<li><a href="Manual/trac/trac.html">Manual de consulta de reportes escalados</a><br></li>
			<li><a href="http://192.168.101.228/php/Manual_790_y_725.pdf">Manual 790 y 725 para restaurantes</a><br></li>
	   	     </ul>
			</p>
           </td>
	        <td WIDTH="30%" rowspan="2" >
	   	     <p class="detail-desc" align="center">&#191;SABIAS QUE?<br>
			     <br>
			     * El equipo de soporte t&eacute;cnico de sistemas esta integrado por ocho personas.<br><br>
			     * Te damos servicio los 365 d&iacute;as del a&ntilde;o. En un horario de martes a domingo de las 08:00  A.M a las 00:00 del &iacute;a siguiente y los lunes 	de 	las 08:00 A.M a las 02:00 A.M del martes.<br><br>
			     * Apoyamos a todos los restaurantes de KFC y PH del pa&iacute;s incluyendo nuestras franquicias.<br><br>
			     * Cuando tengas cualquier problema con tu sistema lo puedes reportar a la Ext.1333, y un consultor se comunicara a tu restaurante lo antes posible.<br><br>
			     <br>
			     Equipo de Soporte T&eacute;cnico en Sistemas.<br>
			     Yum Restaurants Internacional M&eacute;xico.<br>
			     </p>
	        </td>
        </tr>
	<tr>
	   <td>
	   <div id="avisos" valign="botton" >
	      <iframe name ='ifrMainContainer' id ='ifrMainContainer' src="http://trac.prb.net/php/requestDispatcher.php?action=getAd&&cc=<%=getStore()%>" height="80px" width = '100%' frameborder = '1' bordercolor="#E6E6FA" color="#E6E6FA" ></iframe>
	   </div>
	   <td>
	   </td>
	</tr>
        </table>

	</body>
</html>


