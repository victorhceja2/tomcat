<%--
##########################################################################################################
# Nombre Archivo  : ExcepConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sandra Castro
# Objetivo        : Realiza la confirmacion de una Excepcion.
# Fecha Creacion  : 10/Octubre/2006
# Inc/requires    : ../Proc/ExcepLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos en la libreria TransferLibYum.jsp
##########################################################################################################
--%>

<%@ page contentType="text/html" %>
<%@ page import="generals.*" %>
<%@page import="java.util.*, java.io.*, java.text.*;"%>
<%@ include file="../Proc/ExcepLibYum.jsp" %>   

<%! 
	AbcUtils moAbcUtils;
	String msExcepId   = "";
	String msDocNum, msResponsible;
	boolean msExcepOk;
%>

<%
    try
    {
        moAbcUtils     = new AbcUtils(); 

	msDocNum   = request.getParameter("hidDocNum");
        msResponsible  = request.getParameter("txtResponsible");

        msExcepId   = getStepExcepId();
        msExcepOk   = excepOK(msExcepId,msResponsible);
    }
    catch(Exception e)
    {

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

        <script language="javascript">
            showWaitMessage();
        </script>

        <script src="../Scripts/ExcepLibYum.js"></script>
    </head>
    <body bgcolor="white" onLoad="submitFrames()" onUnload="doClose()">
        <table width="100%" cellpadding="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="595" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>

        <form name="mainform" action="../Rpt/ExcepDetailFrm.jsp">
            <input type="hidden" name="hidTarget">
		<input type="hidden" name="hidExcepId" value="<%= msExcepId %>">
		<input type="hidden" name="hidResponsible" value="<%= msResponsible %>">
		<input type="hidden" name="hidDocNum" value="<%=msDocNum%>">
        </form>
    </body>
</html>