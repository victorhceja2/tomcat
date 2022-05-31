<%--
##########################################################################################################
# Nombre Archivo  : GenerateHeaderYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : JSP para generar los encabezados de los reportes de la plantilla
# Fecha Creacion  : 29/Enero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>   
<%! AbcUtils moAbcUtils; %>
<%
	moAbcUtils = new AbcUtils();

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());

    String msOptionKey      = request.getParameter("hidOptionKey");
    String msOptionGroup    = request.getParameter("hidOptionGroup");
    String msPrintOption    = request.getParameter("psPrintOption");
    String msExcelOption    = request.getParameter("psExcelOption");
    String msHideParamsFlag = request.getParameter("psHideParamsFlag");
	String msStoreName	    = request.getParameter("psStoreName");
     
    String msReportTitle    = moHtmlAppHandler.msReportTitle;
    String msPresentation   = moHtmlAppHandler.getPresentation();
    String msOrgLevel       = moHtmlAppHandler.moReportParameters.getOrgLevelDis();
    String msOrgStruct      = moHtmlAppHandler.moReportParameters.getOrgStructDis();
    String msTimeLevel      = moHtmlAppHandler.moReportParameters.getTimeLevelDis();
    String msTimeStruct     = moHtmlAppHandler.moReportParameters.getTimeStructDis();
    String msOrgStatus      = moHtmlAppHandler.moReportParameters.getOrgStatusDis();

    String msFontMain = moHtmlAppHandler.moReportHeader.msFontMain;
    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";

    DateFormat moDateFormat = new SimpleDateFormat("EEEE, MMMM dd, yyyy. kk:mm:ss a");
    String msCurrentDate = moDateFormat.format(new Date());

    if (msOptionKey==null || msOptionGroup==null) {
        msOptionKey = "";
        msOptionGroup = "0";
    } else {
        msOptionGroup = (!msPresentation.equals("EXCEL"))?msOptionGroup:"0";
        msOptionKey = "(" + getGroupIcon(Integer.parseInt(msOptionGroup)) + msOptionKey + ")";
    }

%>

    <table id="mainHeader" width="99%" border="0" align="center">
        <tr>
            <td>
                <table id = 'tblHeader' width="100%" border="0" cellspacing="3" cellpadding="0">
                    <tr>
                        <td>
                            <%=msFontMain %> <%=msReportTitle %> <%= msFontEnd %>
                            <!-- antes rriba <%=msFontMain %> <%=msOptionKey %> <%=msFontEnd %> -->
                        </td>
                    </tr>

                    <%
                        if (!msOrgLevel.equals("") && msOrgLevel != null && !msPresentation.equals("") && msHideParamsFlag==null) {
                            %>
                                <tr>
                                    <td>
                                        <%=msFontSub %>  <% out.print(msOrgLevel + ": <b>" + msOrgStruct + "</b>"); %> <%=msFontEnd %>
                                    </td>
                                </tr>
                            <%
                        }

                        if (!msTimeLevel.equals("") && msTimeLevel != null && !msPresentation.equals("") && msHideParamsFlag==null) {
                            %>
                                <tr>
                                    <td>
                                        <%=msFontSub %>  <% out.print(msTimeLevel + ": <b> " + msTimeStruct + "</b>" ); %> <%=msFontEnd %>
                                    </td>
                                </tr>
                            <%
                        }

                        if (!msOrgStatus.equals("") && msOrgStatus!=null && !msPresentation.equals("") && msHideParamsFlag==null) {
                            %>
                                <tr>
                                    <td>
                                        <%=msFontSub %>  <% out.print("Status de stores: <b> " + msOrgStatus + "</b>"); %> <%=msFontEnd %>
                                    </td>
                                </tr>
                            <%
                        }
                    %>

                    <tr>
                        <td>
                            <%=msFontSub %>Fecha: &nbsp;<b><%= msCurrentDate %></b><%=msFontEnd %> 
                        </td>
                    </tr>
					<% if(msStoreName != null && msStoreName.equals("true")) { %>
					<tr>
						<td>
							<%= msFontSub %>
							Centro de contribuci&oacute;n: &nbsp;
							<b><%= getStoreName(getStoreId()) %></b>
							<%=msFontEnd %> 
						</td>
					</tr>
					<% } %>
					
                </table>
            </td>
            
            <% if ((msPrintOption!=null && msPrintOption.equals("yes")) || msExcelOption!=null) { %>
            <td valign = 'top' align = 'center' width = '10%'>
            			<table id = 'tblHeader' width="100%" border = '0'>
						<tr>
						<td>
                        <%=(msPrintOption!=null)?"<a href = 'javascript:executePageDW(\"PRINTER\");'><img src = '/Images/Menu/print_button.gif' border = '0'></img></a>":"" %> 
                        <%=(msExcelOption!=null)?"<a href = 'javascript:executePageDW(\"EXCEL\");'><img src = '/Images/Menu/excel_button.gif' border = '0'></img></a>":"" %> 
						</td>
						</tr>
						</table>
            </td>
            <% } %>
        </tr>
    </table>

<%!

    String getGroupIcon(int piGroup) {
        String lsGroupIcon = "";
        String lsStrReturn;

        switch (piGroup) {
            case 10: lsGroupIcon = "operations_button.gif";     break;
            case 20: lsGroupIcon = "marketing_button.gif";      break;
            case 30: lsGroupIcon = "rdqa_button.gif";           break;
            case 40: lsGroupIcon = "finance_button.gif";        break;
            case 50: lsGroupIcon = "rh_button.gif";             break;
            case 60: lsGroupIcon = "options_button.gif";        break;
        }
        lsStrReturn = (!lsGroupIcon.equals(""))?"<img src = '/Images/Menu/" + lsGroupIcon + "'>&nbsp;":"";
        return(lsStrReturn);
    }


%>
