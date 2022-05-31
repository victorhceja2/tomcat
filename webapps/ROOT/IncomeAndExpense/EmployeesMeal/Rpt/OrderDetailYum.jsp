<%--
##########################################################################################################
# Nombre Archivo  : OrderDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : MCHA
# Objetivo        : Detalle Ordenes
# Fecha Creacion  : 10/Jul/2009
# Inc/requires    : ../Proc/CustomLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se
# pueda hacer uso de los metodos en la libreria CustomLibYum.jsp
##########################################################################################################
--%>

<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 
    String seq = "";
    String fec = "";
%>
<%
    try{
        fec = request.getParameter("fec");
        seq = request.getParameter("seq");
    }
    catch(Exception e){
       //tel = "0"; 
    }
%>

<script>
    var gaInvoiceDetail;
    var gaDataset = <%= getDataset() %>;

    if(gaDataset.length > 0)
        gaInvoiceDetail = gaDataset[0];
    else
        gaInvoiceDetail = new Array();
    
</script>

<FRAMESET rows="99%, 1%" border="0">
    <FRAME src="OrderDetailFrm.jsp?target=Preview&fecha=<%= fec %>&sequence=<%= seq%>" name="preview" frameborder="0">
    <FRAME src="OrderDetailFrm.jsp?target=Printer&fecha=<%= fec %>&sequence=<%= seq%>" name="printer" frameborder="0">
</FRAMESET>

<%!
    String getDataset(){
        String lsData;
        try{
            lsData = moAbcUtils.getJSResultSet(getQueryReport());
        }
        catch(Exception e){
            lsData = "new Array()";
        }
        return lsData;
    }

    String getQueryReport(){
           String lsQuery = "SELECT I.qty_sold, CC.cdesc,SB.bdesc, SS.sdesc," +
                         " case WHEN (select count(*) FROM gc_topp where date_id = '" + fec + "' AND gc_sequence = '" + seq + "'" +
                         " and it_seq = I.it_seq) = '0' THEN SP.pdesc WHEN (select count(*) FROM gc_topp WHERE date_id" +
                         " = '" + fec + "' AND gc_sequence = '" + seq + "' AND it_seq = I.it_seq) <> '0' THEN SP.pdesc || ' (' ||" +
                         " (SELECT get_toppings(" + seq + ",'" + fec + "',I.it_seq)) || ')' END," +
                         " I.gross_sold" +
                         " FROM gc_items I INNER JOIN sus_menu_items MI ON" +
                         " I.menu_item = MI.menu_item INNER JOIN sus_clss_codes" +
                         " CC on MI.classno = CC.classno INNER JOIN sus_base_codes SB ON MI.baseno = SB.baseno" +
                         " INNER JOIN sus_size_codes SS on MI.sizeno = SS.sizeno INNER JOIN" + 
                         " sus_prod_codes SP ON MI.prodno = SP.prodno WHERE date_id = '"+ fec +"' AND gc_sequence = "+ seq +""; 
        return(lsQuery);
    }
%>
