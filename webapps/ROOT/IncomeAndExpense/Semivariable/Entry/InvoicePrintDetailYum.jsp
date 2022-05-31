<%@ page import="generals.AbcUtils" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils(); 

    String msNotes;
	String msIsGas;
	String msDifference;
	String msTankCapacity;
	String msYumLoadPer;
	String msProvLoadPer;
%>
<%
    try
    {
        msNotes = request.getParameter("notes");
		msIsGas = request.getParameter("isGas");
    }
    catch(Exception e)
    {
       msNotes = "'0'"; 
	   msIsGas = "false";
    }
	if(msIsGas.equals("true")){
		msTankCapacity = getTankCapacity(getStore());
	}
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
    </head>
    <body bgcolor="white">
        <table align="left" width="100%" border="0">
        <tr>
            <td colspan="2">
                &nbsp;Contra recibo factura/remisi&oacute;n
            </td>
        </tr>
        <tr>
            <td class="descriptionTabla" width="20%">
                &nbsp; Centro de contribuci&oacute;n: 
            </td>
            <td class="descriptionTabla" width="80%">
                <b><%=getStore()%>&nbsp;<%=getStoreName()%></b>
            </td>
        </tr>


<%        
    String data[][] = moAbcUtils.queryToMatrix(getQueryReport());

    for(int liRowId=0; liRowId<data.length; liRowId++)
    {
        float amount  = Float.parseFloat(data[liRowId][4]);
        float tax   = Float.parseFloat(data[liRowId][6]);
        float total = amount + tax;
        double taxPercent = Math.ceil(tax * 100 / amount);
		try{
			if(msIsGas.equals("true")){
				float difference = Float.parseFloat(data[liRowId][7]) - Float.parseFloat(data[liRowId][5]);
				msDifference = Integer.toString((int)difference);
				double yumLoadPercent = Math.ceil((Float.parseFloat(data[liRowId][5])/Integer.parseInt(msTankCapacity))*100);
				msYumLoadPer =  Double.toString(yumLoadPercent);
				double provLoadPercent = Math.ceil((Float.parseFloat(data[liRowId][7])/Integer.parseInt(msTankCapacity))*100);
				msProvLoadPer = Double.toString(provLoadPercent);
			}
		}catch(Exception e){
			;
		}
%>
        <tr>
            <td colspan="2" align="left">
                <br><br>
                <table border="0" width="100%" cellpadding="2">
                <tr>
                    <td class="detail-desc" width="25%">Folio:</td>
                    <td class="detail-cont" width="75%" id="folio"><%= data[liRowId][8] %></td>
                </tr>
                <tr>
                    <td class="detail-desc" width="25%">Factura:</td>
                    <td class="detail-cont" width="75%" id="note_id"><%= data[liRowId][3] %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Proveedor:</td>
                    <td class="detail-cont" id="supp_name"><%= data[liRowId][0] %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Subcuenta:</td>
                    <td class="detail-cont" id="subacc_desc"><%= data[liRowId][1] %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Piezas/Unidades:</td>
                    <td class="detail-cont" id="qty"><%= data[liRowId][7] %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Fecha:</td>
                    <td class="detail-cont" id="today"><%= data[liRowId][2] %></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="detail-desc">Importe sin iva:</td>
                    <td class="detail-cont" id="amount"><%= amount %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Iva:</td>
                    <td class="detail-cont" id="tax_value"><%= tax %></td>
                </tr>
                <tr>
                    <td class="detail-desc">Total:</td>
                    <td class="detail-cont" id="total"><%= total %></td>
                </tr>
                <tr>
                    <td class="detail-desc" colspan="2">Iva aplicado: <%= taxPercent + "%" %></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td class="detail-desc">Descripci&oacute;n:</td>
                    <td class="detail-cont" id="description"><%= data[liRowId][5] %></td>
                </tr>
				<% if(msIsGas.equals("true")){ %>
				<br>
						<tr>
							<td class="detail-desc">Capacidad de tanque:</td>
							<td class="detail-cont" id="tankcapacity"><%= msTankCapacity %> litros </td>
						</tr>
						<tr>
							<td class="detail-desc">Carga yum:</td>
							<td class="detail-cont" id="yumload"><%= data[liRowId][5] %> litros &nbsp;&nbsp; (<%=msYumLoadPer%> %)</td>
						</tr>
						<tr>
							<td class="detail-desc">Carga proveedor:</td>
							<td class="detail-cont" id="provload"><%= data[liRowId][7] %> litros &nbsp;&nbsp; (<%=msProvLoadPer%> %)</td>
						</tr>
								<tr>
							<td class="detail-desc">Diferencia:</td>
							<td class="detail-cont" id="difference"><%= msDifference %> litros</td>
						</tr>
				<% } %>
                <tr>
                    <td class="detail-desc" colspan="2"><br><br>Estimado proveedor para cualquier modificaci&oacute;n de sus datos, favor de marcar la ext. 1246</td>
                </tr>
		<tr>
		    <td class="detail-desc" colspan="2"><%@ include file='mensaje.jsp' %></td>
		</tr>
                </table>
                <br>
            </td>
        </tr>

    <%
    }
    %>
        </table>


<%!
    String getQueryReport()
    {
        String lsQuery = "";
 	    lsQuery += "SELECT rtrim(a.supp_name) as supp_name, rtrim(c.sub_acc_desc) as subacc_desc, ";
        lsQuery += "cap_date as today, gsvn.note_id, gsvn.amount, gsvn.comment as description, ";
        lsQuery += "gsvn.tax, gsvn.qty, gsvn.consecutive ";
        lsQuery += "FROM  op_gsv_cat_supplier a ";
        lsQuery += "INNER JOIN op_gsv_supp_subacc b ON a.supp_id=b.supp_id ";
        lsQuery += "INNER JOIN op_gsv_cat_sub_account c ON b.sub_acc_id=c.sub_acc_id AND b.acc_id=c.acc_id ";
	    lsQuery += "INNER JOIN op_gsv_note gsvn ON ";
        lsQuery += "(b.supp_id=gsvn.supp_id AND b.sub_acc_id=gsvn.sub_acc_id AND b.acc_id=gsvn.acc_id) ";
        lsQuery += "WHERE gsvn.note_id IN (" + msNotes + ")";
        
        return(lsQuery);
    }
	String getTankCapacity(String psStoreId){
		String lsQuery = "SELECT capacity from op_gsv_gas WHERE " +
			"store_id=" + psStoreId;
		return moAbcUtils.queryToString(lsQuery);
	}
%>
