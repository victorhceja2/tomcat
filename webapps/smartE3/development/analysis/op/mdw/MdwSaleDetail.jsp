<%-- 
    Document   : MdwSaleDetail
    Created on : 26/11/2015, 08:29:38 PM
    Author     : DAB1379
--%>
<% 
    String msDate = request.getParameter("psDate");
    String msHour = request.getParameter("psHour");
    String msType = request.getParameter("psType");
    String msProduct = request.getParameter("psProduct");
    String msTitle = "Ventas";
    
    if(msType.equals("trx"))msTitle="Transacciones";
%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Detalle de <%=msTitle%></title>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.min.js"></script>
        <style>
                .main_header{color:navy;background-color:#E6E6E6;border:1px solid gray;font-size:15px;font-weight:bold;box-shadow: 10px 10px 5px #888888;}
                .employee{background-color:#CEE3F6;font-size:10px}
                .total{background-color:#F3F781;font-size:10px;font-weight:bold}
                .forecast{text-align: center;background-color:#2E64FE;font-weight:bold;color:white;font-size:30px;border-radius: 5px;box-shadow: 10px 10px 5px #888888; }
                 .blocked {
                background-image: url("/smartE3/images/e3/ui/explorer/blocked.png");
                width: 100%;
                height: 100%;
                overflow: hidden; 
                top: 0px;
                left: 0px;
                z-index: 10000;
                text-align: center;
                position:absolute; 
                text-align: center;
                }
                td{
                    border-radius: 5px;
                }
        </style>    
    </head>
    <script>
        var msServerIp = (location.host).split(":")[0];
          function getDetailData(){
          var lsQuery;
            lsQuery = "";
            lsQuery+=" SELECT GGC.sequence_no,(SELECT destination_desc FROM gc_dest_codes WHERE destination = GGC.destination),CAST(printed_time AS TIME),CAST(GGC.gross_total/100 AS DECIMAL(10,2)),menu_item_id,qty,quantity,qty*quantity,(SELECT CAST(store_id AS TEXT)||'-'||store_desc FROM ss_cat_store LIMIT 1)";
            lsQuery+=" FROM op_sls_vw_tickets GGC ";
            lsQuery+=" INNER JOIN op_sls_vw_items GI ON (GI.sequence_no=GGC.sequence_no AND GI.order_date=GGC.order_date)";
            lsQuery+=" INNER JOIN op_mdw_product_menu_item PM ON REPLACE(GI.mnemonic,' ','') = REPLACE(PM.mnemonic,' ','') AND PM.product_id = <%=msProduct%>";                                                  
            lsQuery+=" WHERE ( GI.order_date= CAST('<%=msDate%>' AS DATE) ) AND GGC.cash_out_status IN ('C','N') AND GGC.cancel_status  = '' AND GGC.printed_time NOT IN ('','0')";
            if(<%=msHour%> != 99)lsQuery+=" AND DATE_PART('hour',CAST(printed_time AS TIME)) = <%=msHour%> ";
            lsQuery+=" ORDER BY GGC.sequence_no ";
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
              var lsData = psData.replace(/^\s+|\s+$/g, '');
               if(lsData != ""){
                   cleanRows();
                   var ldQtyProdTotal = 0;
                   var ldPriceTotal = 0;
                   
                   for(var li=0;li<lsData.split("_||_").length;li++){
                        var lsRow = lsData.split("_||_")[li];
                        var lsTicket = lsRow.split("_|||_")[0];
                        var lsDest = lsRow.split("_|||_")[1];
                        var lsTime = lsRow.split("_|||_")[2];
                        var lsPrice = lsRow.split("_|||_")[3];
                        var lsMItem = lsRow.split("_|||_")[4];
                        var lsQty = lsRow.split("_|||_")[5];
                        var lsQtyTicket = lsRow.split("_|||_")[6];
                        var lsQtyProd = lsRow.split("_|||_")[7];
                        var lsStore =  lsRow.split("_|||_")[8];
                        ldQtyProdTotal+=parseFloat(lsQtyProd);
                        ldPriceTotal+=parseFloat(lsPrice);
                        addRow(lsTicket,lsDest,lsTime,lsPrice,lsMItem,lsQty,lsQtyTicket,lsQtyProd,lsStore);
                    }
                    addRow("Total","","",ldPriceTotal.toFixed(2),"","","",ldQtyProdTotal.toFixed(2),lsStore);
                }
                document.getElementById("divBlocked").style.visibility="hidden";
          });
      }
       function getTrxDetailData(){
          var lsQuery;
          
            lsQuery = "";
            lsQuery+=" SELECT (SELECT CAST(store_id AS TEXT)||'-'||store_desc FROM ss_cat_store LIMIT 1),sequence_no,CAST(printed_time AS TIME)";
            lsQuery+=" FROM op_sls_vw_tickets GGC ";
            lsQuery+=" WHERE ( GGC.order_date=CAST('<%=msDate%>' AS DATE) ) AND GGC.cash_out_status IN ('C','N') AND GGC.cancel_status  = '' AND GGC.printed_time NOT IN ('','0')  ";
            if(<%=msProduct%> != 70)lsQuery+=" AND GGC.destination = '<%=msProduct%>'";
            lsQuery+=" AND (SELECT SUM(CASE WHEN mnemonic IN (SELECT mnemonic FROM op_mdw_product_menu_item WHERE product_id = 21) THEN 0 ELSE 1 END) ";
            lsQuery+=" FROM op_sls_vw_items WHERE sequence_no = GGC.sequence_no AND order_date = GGC.order_date) > 0";
            if(<%=msHour%> != 99)lsQuery+=" AND DATE_PART('hour',CAST(printed_time AS TIME)) = <%=msHour%> ";
            lsQuery+=" ORDER BY GGC.sequence_no ";
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
              var lsData = psData.replace(/^\s+|\s+$/g, '');
               if(lsData != ""){
                   cleanTrxRows();
                   var ldTotalTicket = 0;
                   for(var li=0;li<lsData.split("_||_").length;li++){
                        var lsRow = lsData.split("_||_")[li];
                        var lsStore = lsRow.split("_|||_")[0];
                        var lsTicket = lsRow.split("_|||_")[1];
                        var lsTime = lsRow.split("_|||_")[2];
                        ldTotalTicket++;
                        addTrxRow(lsTicket,lsTime,lsStore);
                    }
                    addTrxRow(ldTotalTicket.toFixed(2),"","Total");
                }
                document.getElementById("divBlocked").style.visibility="hidden";
          });
      }
      function addRow(psTicket,psDest,psTime,psPrice,psMItem,psQty,psQtyMItem,psQtyProd,lsStore){
        var loObj = document.getElementById("tblDetail");
        
        var liIndex = loObj.rows.length;
        var loTr = loObj.insertRow(liIndex);
        if(psTicket == "Total")
            loTr.setAttribute("class","total");
        else
            loTr.setAttribute("class","employee");
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        var loTd4 = loTr.insertCell(loTr.cells.length);
        var loTd5 = loTr.insertCell(loTr.cells.length);
        var loTd6 = loTr.insertCell(loTr.cells.length);
        var loTd7 = loTr.insertCell(loTr.cells.length);
        var loTd8 = loTr.insertCell(loTr.cells.length);
        var loTd9 = loTr.insertCell(loTr.cells.length);
        loTd1.innerHTML = lsStore;
        loTd2.innerHTML = psTicket;
        loTd3.innerHTML = psDest;
        loTd4.innerHTML = psTime;
        loTd5.innerHTML = "$"+psPrice;
        loTd6.innerHTML = psMItem;
        loTd7.innerHTML = psQty;
        loTd8.innerHTML = psQtyMItem;
        loTd9.innerHTML = psQtyProd;
        loTd3.onclick = function(){window.open("http://"+msServerIp+"/Auditoria/AudiReport/Entry/ShowAudiReport.jsp?txtDate=<%=msDate.substring(8,10)+"/"+msDate.substring(5,7)+"/"+msDate.substring(0,4)%>&txtTicket="+psTicket,"_blank","scrollbars=1,width=500, height=500");}
        
      }
      function addTrxRow(psTicket,psTime,lsStore){
        var loObj = document.getElementById("tblTrxDetail");
        
        var liIndex = loObj.rows.length;
        var loTr = loObj.insertRow(liIndex);
        if(lsStore == "Total")
            loTr.setAttribute("class","total");
        else
            loTr.setAttribute("class","employee");
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        loTd1.innerHTML = lsStore;
        loTd2.innerHTML = psTime;
        loTd3.innerHTML = psTicket;
        loTd3.onclick = function(){window.open("http://"+msServerIp+"/Auditoria/AudiReport/Entry/ShowAudiReport.jsp?txtDate=<%=msDate.substring(8,10)+"/"+msDate.substring(5,7)+"/"+msDate.substring(0,4)%>&txtTicket="+psTicket,"_blank","scrollbars=1,width=500, height=500");}
        
        
      }
      function cleanTrxRows(){
        var loObj = document.getElementById("tblTrxDetail");
        var liIndex = loObj.rows.length;
        var liCounter = liIndex -1 ;
        for(var lj=liCounter;lj>1;lj--){
            loObj.deleteRow(lj);
        }
    };
    function cleanRows(){
        var loObj = document.getElementById("tblDetail");
        var liIndex = loObj.rows.length;
        var liCounter = liIndex -1 ;
        for(var lj=liCounter;lj>1;lj--){
            loObj.deleteRow(lj);
        }
    };
        </script>
    <body>
        <div id="divBlocked" class="blocked" style="visibility:visible">
            <div class="blocked-content" >
            <div>
                <img id="" src="/smartE3/images/e3/ui/explorer/loading.gif" width="30" height="30"/>
                <br><font color=white>Cargando...</font>
            </div>
            </div>
        </div>
        <h1 class="forecast"><%=msTitle%></h1>
        <p style="width:100%;text-align: center;color:gray;font-weight: bold"><img id="" src="/smartE3/images/e3/ui/explorer/schedule_icon.png" width="20" height="20"/>&nbsp;&nbsp;<%=msDate%></p>
        <p style="width:100%;text-align: center;color:gray;font-weight: bold"><img id="" src="/smartE3/images/e3/ui/explorer/schedule.png" width="30" height="30"/>&nbsp;&nbsp;<%=(msHour.equals("99"))?"Total":msHour%></p>
        <%if(msType.equals("sale")){%>
        <center>
            <table id="tblDetail">
                <tr class="main_header">
                    <td>CC</td>
                    <td>Ticket</td>
                    <td>Destino</td>
                    <td>Hora</td>
                    <td>Total $</td>
                    <td>M. Item</td>
                    <td>Cantidad Ticket</td>
                    <td>Cantidad M. Item</td>
                    <td>Cantidad Producto</td>
                </tr>
            </table>
        </center>
        <%}else{%>
        <center>
            <table id="tblTrxDetail">
                <tr class="main_header">
                    <td>CC</td>
                    <td>Hora</td>
                    <td>Ticket</td>
                </tr>
            </table>
         </center>
        <%}%>
    </body>
    <script>
        if("<%=msType%>" == "sale")
            getDetailData();
        else
            getTrxDetailData();
    </script>
</html>
