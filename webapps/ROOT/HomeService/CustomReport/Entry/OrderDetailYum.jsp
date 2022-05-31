<%--
##########################################################################################################
# Nombre Archivo  : OrderDetailYum.jsp
# Compania        : Yum Brands Intl
# Autor           : GAR
# Objetivo        : Detalle Orden Clinetes
# Fecha Creacion  : 14/Feb/2008
# Inc/requires    : ../Proc/CustomLibYum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se
# pueda hacer 
#                   uso de los metodos en la libreria CustomLibYum.jsp
##########################################################################################################
--%>

<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 
    String tel = "";
	String seq = "";
	String fec = "";
	String fre = "";
	String nam = "";
%>
<%
    try{
        tel = request.getParameter("tel");
		fec = request.getParameter("fec");
		seq = request.getParameter("seq");
		fre = request.getParameter("fre");
		nam = request.getParameter("nomb");

		if(Integer.parseInt(fre) > 7){
			fre = "7";
		}
	}
    catch(Exception e){
       //tel = "0"; 
    }
%>

<script>
	var gaInvoiceDetail;
    var gaDataset = <%= getDataset() %>;
	var gaDatasetU = <%= getDatasetU() %>;
	var gaDatasetC = <%= getDatasetC() %>;


	if(gaDataset.length > 0)
        gaInvoiceDetail = gaDataset[0];
    else
        gaInvoiceDetail = new Array();

	if(gaDatasetU.length > 0)
		gaInvoiceDetailU = gaDatasetU[0];
	else
		gaInvoiceDetailU = new Array();
	
	 if(gaDatasetC.length > 0)
	 	gaInvoiceDetailC = gaDatasetC[0];
	else
	   	gaInvoiceDetailC = new Array();
						 
		
</script>

<FRAMESET rows="99%, 1%" border="0">
	<FRAME src="OrderDetailFrm.jsp?target=Preview&noteId=<%= tel %>&nombre=<%= nam %>&fecha=<%= fec %>" name="preview" frameborder="0">
    <FRAME src="OrderDetailFrm.jsp?target=Printer&noteId=<%= tel %>&nombre=<%= nam %>&fecha=<%= fec %>" name="printer" frameborder="0">
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
   		String lsQuery = "select I.qty_sold, CC.cdesc,SB.bdesc," +
						 " case WHEN (select count(*) from gc_topp where date_id = '" + fec + "' and gc_sequence = '" + seq + "'" +
						 " and it_seq = I.it_seq) = '0' THEN SP.pdesc WHEN (select count(*) from gc_topp where date_id" +
						 " = '" + fec + "' and gc_sequence = '" + seq + "' and it_seq = I.it_seq) <> '0' THEN SP.pdesc || ' (' ||" +
						 " (select get_toppings(" + seq + ",'" + fec + "',I.it_seq)) || ')' end," +
						 " I.gross_sold" +
						 " from sus_clients C inner join gc_delivery D on C.store_id = D.store_id and" +
						 " C.client = D.client AND D.client = '" + tel + "' AND D.gc_sequence = '" + seq + "' AND" +
					     " D.date_id = '"+ fec + "' inner join gc_items I on D.store_id = I.store_id AND" +
						 " D.date_id = I.date_id AND D.gc_sequence = I.gc_sequence inner join sus_menu_items MI on" +
						 " I.menu_item = MI.menu_item inner join sus_clss_codes" +
						 " CC on MI.classno = CC.classno inner join sus_base_codes SB on MI.baseno = SB.baseno inner" +
						 " join sus_size_codes SS on MI.sizeno = SS.sizeno inner" + 
						 " join sus_prod_codes SP on MI.prodno = SP.prodno";
        return(lsQuery);
    }

	String getDatasetU(){
		String lsDataU;
		try{
			lsDataU = moAbcUtils.getJSResultSet(getQueryReportU());
		}
		catch(Exception e){
			lsDataU = "new Array()";
		}
		return lsDataU;
	}
	
	String getQueryReportU(){
		String lsQueryU = "select case WHEN C.promo_allowance <> '0.00' THEN " +
					      " (select coupon_code from gc_items g inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and" + 
						  " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and g.date_id = D.date_id and g.gc_sequence = D.gc_sequence inner join" +
						  " gc_coupon_codes cc on c.coupon_id = cc.coupon_id limit 1)" +
						  " end as coupon, to_char(D.date_id, 'DD-Mon-YYYY')," +
						  " (C.gross_sold - C.promo_allowance) as total" +
						  " ,D.date_id, D.gc_sequence, D.client, '" + fre + "' as frecu, '" + nam + "' as nombre" +
						  " from gc_delivery D inner join" +
						  " gc_guest_checks C" +
						  " on D.store_id = C.store_id and D.date_id = C.date_id and D.gc_sequence = C.gc_sequence and" +
						  " D.client = '" + tel + "' order by D.date_id desc, D.gc_sequence desc limit " + fre;
		return(lsQueryU);
	}

	String getDatasetC(){
		String lsDataC;
		try{
			lsDataC = moAbcUtils.getJSResultSet(getQueryReportC());
		}
		catch(Exception e){
			lsDataC = "new Array()";
		}
		System.out.println(lsDataC);
		return lsDataC;
	}

	String getQueryReportC(){
		String lsQueryC = "select (cc.coup_desc || '-' || cc.err_message) as descri, c.gross from gc_items g" +
						  " inner join gc_coupons c on g.store_id = c.store_id and g.date_id = c.date_id and" + 
						  " g.gc_sequence = c.gc_sequence and g.it_seq = c.it_seq and" +
						  " g.date_id = '" + fec + "' and g.gc_sequence = '" + seq + "' inner join" +
						  " gc_coupon_codes cc on c.coupon_id = cc.coupon_id";
		return(lsQueryC);
	}
%>
