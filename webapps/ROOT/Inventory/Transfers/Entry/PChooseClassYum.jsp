<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.io.*, java.text.*"%>
<%@ page import="generals.*"%>
<%!
	AbcUtils moAbcUtils;
	AplicationsV2 logApps = new AplicationsV2();
	String lsClass;
	String lsTable;
	String lsMult;
%>

<%
	moAbcUtils = new AbcUtils();

	lsClass = request.getParameter("class");
	lsTable = request.getParameter("table");
	lsMult = request.getParameter("mult");
	String lsBase = "";
	String lsSize = "";
	String lsProd = "";
	String lsTopp = "";

	if (lsTable.equals("Bases")) {
		lsBase = "<select name=\"base\" id=\"base\">\n";
		lsBase += "<option value=\"0\"> Seleccione Base </option>\n";
		String query = "SELECT bsno, bsdesc FROM sus_base WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query Bases:" + query);
		String rsBase = moAbcUtils.queryToString(query, "|", ">");
		if (!rsBase.equals("")) {
			String[] arsBase = rsBase.split("\\|");
			for (String lBase : arsBase) {
				//logApps.writeInfo("lBase: [" + lBase + "]");
				String[] csBase = lBase.split(">");
				lsBase += "<option value=\"" + csBase[0] + "\"> "
						+ csBase[1] + " </option>\n";
			}
			lsBase += "</select>\n";
			//logApps.writeInfo(lsBase);
			out.print(lsBase);
		}

	}
	if (lsTable.equals("Sizes")) {
		lsSize = "<select name=\"sizes\" id=\"sizes\">\n";
		lsSize += "<option value=\"0\"> Seleccione tamaño </option>\n";
		String query = "SELECT szno, szdesc FROM sus_size WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query Tamanios:" + query);
		String rsSize = moAbcUtils.queryToString(query, "|", ">");
		if (!rsSize.equals("")) {
			String[] arsSize = rsSize.split("\\|");
			for (String lSize : arsSize) {
				//logApps.writeInfo("lSize: [" + lSize + "]");
				String[] csSize = lSize.split(">");
				lsSize += "<option value=\"" + csSize[0] + "\"> "
						+ csSize[1] + " </option>\n";
			}
			lsSize += "</select>\n";
			//logApps.writeInfo(lsSize);
			out.print(lsSize);
		}
	}
	if (lsTable.equals("Prod")) {
		lsProd = "<select name=\"prod\" id=\"prod\" onchange=\"validaProd('prod','Topp')\">\n";
		lsProd += "<option value=\"0\"> Seleccione producto </option>\n";
		String query = "SELECT prno, prdesc FROM sus_prod WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query Productos:" + query);
		String rsProd = moAbcUtils.queryToString(query, "|", ">");
		if (!rsProd.equals("")) {
			String[] arsProd = rsProd.split("\\|");
			for (String lProd : arsProd) {
				//logApps.writeInfo("lProd: [" + lProd + "]");
				String[] csProd = lProd.split(">");
				lsProd += "<option value=\"" + csProd[0] + "\"> "
						+ csProd[1] + " </option>\n";
			}
			lsProd += "</select>\n";
			//logApps.writeInfo(lsProd);
			out.print(lsProd);
		}
	}
	
	if (lsTable.equals("Prod2")) {
		lsProd = "<select name=\"prod2\" id=\"prod2\" onchange=\"validaProd('prod2','Topp2')\">\n";
		lsProd += "<option value=\"0\"> Seleccione producto 2</option>\n";
		String query = "SELECT prno, prdesc FROM sus_prod WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query Productos 2:" + query);
		String rsProd = moAbcUtils.queryToString(query, "|", ">");
		if (!rsProd.equals("")) {
			String[] arsProd = rsProd.split("\\|");
			for (String lProd : arsProd) {
				//logApps.writeInfo("lProd: [" + lProd + "]");
				String[] csProd = lProd.split(">");
				lsProd += "<option value=\"" + csProd[0] + "\"> "
						+ csProd[1] + " </option>\n";
			}
			lsProd += "</select>\n";
			//logApps.writeInfo(lsProd);
			out.print(lsProd);
		}
	}

	if (lsTable.equals("Topp")) {
		lsTopp = "<select name=\"topp\" id=\"topp\" ";
		lsTopp += lsMult.equals("false") ? "> \n<option value=\"0\"> Seleccione topping </option>\n"
				: "multiple onblur=\"validNumTopps('1')\">\n";
		String query = "SELECT tpno, tpdesc FROM sus_topp WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query toppings:" + query);
		String rsTopp = moAbcUtils.queryToString(query, "|", ">");
		if (!rsTopp.equals("")) {
			String[] arsTopp = rsTopp.split("\\|");
			for (String lTopp : arsTopp) {
				//logApps.writeInfo("lTopp: [" + lTopp + "]");
				String[] csTopp = lTopp.split(">");
				lsTopp += "<option value=\"" + csTopp[0] + "\"> "
						+ csTopp[1] + " </option>\n";
			}
			lsTopp += "</select>\n";
			//logApps.writeInfo(lsTopp);
			out.print(lsTopp);
		}
	}
	
	if (lsTable.equals("Topp2")) {
		lsTopp = "<select name=\"topps2\" id=\"topps2\" ";
		lsTopp += lsMult.equals("false") ? "> \n<option value=\"0\"> Seleccione topping </option>\n"
				: "multiple onblur=\"validNumTopps('2')\">\n";
		String query = "SELECT tpno, tpdesc FROM sus_topp WHERE clno='"
				+ lsClass + "' order by 1";
		logApps.writeInfo("Query toppings 2:" + query);
		String rsTopp = moAbcUtils.queryToString(query, "|", ">");
		if (!rsTopp.equals("")) {
			String[] arsTopp = rsTopp.split("\\|");
			for (String lTopp : arsTopp) {
				//logApps.writeInfo("lTopp: [" + lTopp + "]");
				String[] csTopp = lTopp.split(">");
				lsTopp += "<option value=\"" + csTopp[0] + "\"> "
						+ csTopp[1] + " </option>\n";
			}
			lsTopp += "</select>\n";
			//logApps.writeInfo(lsTopp);
			out.print(lsTopp);
		}
	}
%>