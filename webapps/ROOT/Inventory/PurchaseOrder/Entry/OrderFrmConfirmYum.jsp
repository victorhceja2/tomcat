<FRAMESET rows="99%, 1%" border="0">
      <FRAME src="OrderConfirmYum.jsp?hidStore=<%= request.getParameter("hidStore") %>&hidOrder=<%= request.getParameter("hidOrder") %>&target=Preview" name="preview" frameborder="0">
      <FRAME src="OrderConfirmYum.jsp?hidStore=<%= request.getParameter("hidStore") %>&hidOrder=<%= request.getParameter("hidOrder") %>&target=Printer" name="printer" frameborder="0">
</FRAMESET>
