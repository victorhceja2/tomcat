 <jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : InvoiceDetailYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : EZ
# Objetivo        : Muestra el detalle de una factura.
# Fecha Creacion  : 23/Mayo/2005
# Inc/requires    :
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>   

<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msNoteId;
    String msTarget;
    String msPrintOption;
%>
<%
    try
    {
        msNoteId = request.getParameter("noteId");
        msTarget = request.getParameter("target");
    }
    catch(Exception e)
    {
        msNoteId = "0";
        msTarget = "Preview";
    }


    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.setPresentation("VIEWPORT");
    moHtmlAppHandler.initializeHandler();
    moHtmlAppHandler.msReportTitle = "Contra recibo factura/remisi&oacute;n";
    moHtmlAppHandler.updateHandler();
    moHtmlAppHandler.validateHandler();
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/MathUtilsYum.js"></script>
        <script>
        var laInvoiceData = parent.gaInvoiceDetail;

        function fillInvoice()
        {
            if(laInvoiceData.length > 0)
            {
                var amount = parseFloat(laInvoiceData[4]);
                var tax    = parseFloat(laInvoiceData[6]);
                var total  = amount + tax;
                var tax_percent = Math.ceil(tax*100/amount) + '%';

                document.getElementById("note_id").innerHTML     = laInvoiceData[3];
                document.getElementById("supp_name").innerHTML   = laInvoiceData[0];
                document.getElementById("subacc_desc").innerHTML = laInvoiceData[1];
                document.getElementById("today").innerHTML       = laInvoiceData[2];
                document.getElementById("amount").innerHTML      = round_decimals(amount,2);
                document.getElementById("description").innerHTML = laInvoiceData[5];
                document.getElementById("tax_percent").innerHTML = tax_percent;
                document.getElementById("tax_value").innerHTML   = round_decimals(tax,2);
                document.getElementById("total").innerHTML       = round_decimals(total,2);
                document.getElementById("qty").innerHTML         = laInvoiceData[7];
                document.getElementById("consecutive").innerHTML = laInvoiceData[8];

            }
        }

        function executeReportCustom()
        {
            parent.printer.focus(); parent.printer.print();
        }
        </script>
    </head>

    <body bgcolor="white" onLoad="fillInvoice()">
    <jsp:include page = "/Include/GenerateHeaderYum.jsp">
        <jsp:param name="psPrintOption" value="<%= msPrintOption %>"/>
    </jsp:include>
    
        <script src="/Scripts/TooltipsYum.js"></script>

        <table align="left" width="98%" border="0">
        <tr>
            <td class="descriptionTabla" width="15%" nowrap>
                Centro de contribuci&oacute;n: 
            </td>
            <td class="descriptionTabla" width="85%">
                <b><%=getStore()%>&nbsp;<%=getStoreName()%></b>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="left">
                <br><br>
                <table border="0" width="100%" cellpadding="2">
                <tr>
                    <td class="detail-desc" width="25%">Folio:</td>
                    <td class="detail-cont" width="75%" id="consecutive"></td>
                </tr>
                <tr>
                    <td class="detail-desc" width="25%">Factura:</td>
                    <td class="detail-cont" width="75%" id="note_id"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Proveedor:</td>
                    <td class="detail-cont" id="supp_name"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Subcuenta:</td>
                    <td class="detail-cont" id="subacc_desc"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Piezas/Unidades:</td>
                    <td class="detail-cont" id="qty"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Fecha:</td>
                    <td class="detail-cont" id="today"></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="detail-desc">Importe sin iva:</td>
                    <td class="detail-cont" id="amount"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Iva:</td>
                    <td class="detail-cont" id="tax_value"></td>
                </tr>
                <tr>
                    <td class="detail-desc">Total:</td>
                    <td class="detail-cont" id="total"></td>
                </tr>
                <tr>
                    <td class="detail-desc" colspan="2">Iva aplicado: <span id="tax_percent"></span></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="detail-desc">Descripci&oacute;n:</td>
                    <td class="detail-cont" id="description"></td>
                </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <div class="subHeadB" id="errorMsg"></div>
            </td>
        </tr>
        </table>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
    </body>
</html>
