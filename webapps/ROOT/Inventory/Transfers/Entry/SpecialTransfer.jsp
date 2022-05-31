<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="generals.*"%>
<%!
	AplicationsV2 logApps = new AplicationsV2();
	String lsTransferId = "";
	String lsTransferIdDest = "";
	String lsResponsible = "";
	String lsConfirm = "";
	String lsConfComm = "";
	String lsStoreDest = "";
	String lsDateId = "";%>
<%
	try {
		lsTransferId = request.getParameter("transfer_id");
		lsTransferIdDest = request.getParameter("transfer_id_dest");
		lsResponsible = request.getParameter("responsible");
		lsConfirm = request.getParameter("confirm");
		lsConfComm = request.getParameter("confirm_comments");
		lsStoreDest = request.getParameter("store_dest");
		lsDateId = request.getParameter("confirm_date");
	} catch (Exception e) {
		lsTransferId = request.getParameter("null");
		lsTransferIdDest = request.getParameter("null");
		lsResponsible = request.getParameter("null");
		lsConfirm = request.getParameter("null");
		lsConfComm = request.getParameter("null");
		lsStoreDest = request.getParameter("null");
		lsDateId = request.getParameter("null");
	}
	logApps.writeInfo("Datos recibidos en SpecialTransfer.jsp:");
	logApps.writeInfo("\tLocal Transfer ID:" + lsTransferId);
	logApps.writeInfo("\tNeighbor Transfer ID: " + lsTransferIdDest);
	logApps.writeInfo("\tResponsible: " + lsResponsible);
	logApps.writeInfo("\tConfirm: [" + lsConfirm + "]");
	logApps.writeInfo("\tReason Reject: [" + lsConfComm + "]");
	logApps.writeInfo("\tNeighbor Store: [" + lsStoreDest + "]");
	logApps.writeInfo("\tDate confirm: [" + lsDateId + "]");
	logApps.writeInfo("---------------------------------------------------\n");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Special Transfer</title>
</head>
<body>
	<jsp:include page="/SpecialTransfer" flush="true">
		<jsp:param value="<%=lsTransferId%>" name="transfer_id" />
		<jsp:param value="<%=lsTransferIdDest%>" name="transfer_id_dest" />
		<jsp:param value="<%=lsResponsible%>" name="responsible" />
		<jsp:param value="<%=lsConfirm%>" name="confirm" />
		<jsp:param value="<%=lsConfComm%>" name="confirm_comments" />
		<jsp:param value="<%=lsStoreDest%>" name="store_dest" />
		<jsp:param value="<%=lsDateId%>" name="confirm_date" />
	</jsp:include>
	<a style="color: red"><%=request.getParameter("message") != null ? request
					.getParameter("message") : ""%></a>
</body>
</html>