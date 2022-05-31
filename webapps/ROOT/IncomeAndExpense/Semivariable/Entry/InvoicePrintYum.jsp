<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msNotes;
	String msIsGas;
%>
<%
    try
    {
        msNotes = request.getParameter("notes");
		msIsGas = request.getParameter("isGas");
    }
    catch(Exception e)
    {
       msNotes = "0"; 
	   msIsGas = "false";
    }
%>
<FRAMESET rows="90%,1%" border="0">
      <FRAME src="InvoicePrintMessageYum.jsp?target=Preview&notes=<%= msNotes %>&isGas=<%=msIsGas%>" name="preview" frameborder="0">
      <FRAME src="InvoicePrintDetailYum.jsp?target=Printer&notes=<%= msNotes %>&isGas=<%=msIsGas%>" name="printer" frameborder="0">
</FRAMESET>
