<%-- 
    Document   : PPSCookDetail
    Created on : 26/04/2016, 01:11:57 PM
    Author     : DAB1379
--%>


<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%
    String msDate= request.getParameter("psDate");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>PPS Availability Graphic</title>
        <link rel="stylesheet" type="text/css" href="/smartE3/resources/css/pps_reports.css" media="screen" />
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/excanvas.min.js"></script>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.min.js"></script>

        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.fillbetween.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.symbol.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.categories.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.orderBars.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.navigate.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.barnumbers.enhanced.js"></script>

        <script>
            var msDate = '<%=msDate%>'
    function getStore(){
        var lsQuery = "SELECT store_id,store_desc,(SELECT LOWER(company_id) FROM ss_org_cat_company) FROM ss_org_cat_store";
        $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeDBConnectionPool"},
          function(psData) {
              if(psData != ""){
                  var lsId = psData.split("_|||_")[0];
                  var lsName = psData.split("_|||_")[1];
                  var lsCo = psData.split("_|||_")[2];
                  psData = psData.replace(/^\s+|\s+$/g, '');
                $( "#tdStoreData" ).append("<img src='/smartE3/images/e3/ui/explorer/"+lsCo+"_big.png' width='100px' /><br>"+lsId+" "+lsName );
            }
          });
    }
    function validateSystem(){
        var lsQuery = "SELECT CASE  WHEN param_value = '1' THEN 'true' ELSE 'false' END FROM it_grl_store_config_param WHERE param_desc = 'use_pps'";
        $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
              psData = psData.replace(/^\s+|\s+$/g, '');
              if(psData == "true"){
                  getProducts();
              }
              else{
                  $( "body" ).append( "<img width='200px' src='/smartE3/images/e3/ui/schedule/unavailable.png'/><h3>Tu restaurante no cuenta con PPS</h3>");
              }
          });
    }
    function getProducts(){
        var lsQuery = "SELECT product_id,product_name,unit_amount FROM op_pps_Cat_product WHERE active = '1'";
        $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
              psData = psData.replace(/^\s+|\s+$/g, '');
              if(psData != ""){
                  for(var li=0;li<psData.split("_||_").length;li++){
                    var lsRow = psData.split("_||_")[li];
                    var lsId = lsRow.split("_|||_")[0];
                    var lsName = lsRow.split("_|||_")[1];
                    var lsUnits = lsRow.split("_|||_")[2];
                    $( "body" ).append( "<center><h1 style='color:gray'>"+lsName+"</h1></center><center><div id='divMain"+lsId+"' style='position:relative;margin-top: 5px;background-color:white;width:90%;height:250px;'></div> </center>");
                    getData(lsId,lsUnits,"");
                }
             } else{
                       $( "body" ).append( "<img width='200px' src='/smartE3/images/e3/ui/schedule/opt_btn.png'/><h3>No se encontró información de productos</h3>");
             }
              
          });
    }
   
    function getData(psProductId,psAmount,psHost){
         var lsQuery;
            lsQuery = "";
            lsQuery+="SELECT hours,COALESCE(SUM(CASE type WHEN 5 THEN b.total ELSE 0 END),0) total_sold, ";
            lsQuery+="COALESCE(SUM(CASE type WHEN 10 THEN b.total ELSE 0 END),0)  total_cooked, ";
            lsQuery+="COALESCE(SUM(CASE type WHEN 15 THEN b.total ELSE 0 END),1) total_wasted ";
            lsQuery+="FROM (SELECT DISTINCT CAST(DATE_PART('hour',time_id) AS INTEGER) AS hours ";
            lsQuery+=" FROM op_mdw_product_data WHERE date_id IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member('<%=msDate%>'))  ";
            lsQuery+="AND product_id  = (SELECT product_id_ml FROM op_pps_product_mdw WHERE product_id = "+psProductId+")  AND DATE_PART('hour',time_id) BETWEEN 9 AND 22 ) a ";
            lsQuery+="LEFT OUTER JOIN (  ";
            lsQuery+="SELECT hour_id,total,5 AS type FROM dblink('"+psHost+" dbname=pps user=postgres',' SELECT DATE_PART(''hour'',hour_id),SUM(trunc(CAST(quantity AS NUMERIC),2))  ";
            lsQuery+="FROM op_pps_sold_detail WHERE product_id = "+psProductId+" AND date_id IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member(''<%=msDate%>'')) GROUP BY 1 ORDER BY 1,2; ') ";
            lsQuery+="AS t( hour_id DOUBLE PRECISION, total NUMERIC ) ";
            lsQuery+="UNION ";
            lsQuery+="SELECT hour_id,total,10 AS type FROM dblink('"+psHost+" dbname=pps user=postgres',' SELECT DATE_PART(''hour'',hour_id),SUM(trunc(CAST(quantity AS NUMERIC),2))  ";
            lsQuery+="FROM op_pps_cooked_detail WHERE product_id = "+psProductId+" AND date_id IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member(''<%=msDate%>'')) GROUP BY 1 ORDER BY 1,2; ') ";
            lsQuery+="AS t( hour_id DOUBLE PRECISION, total NUMERIC ) ";
            lsQuery+="UNION ";
            lsQuery+="SELECT hour_id,total,15  FROM dblink('"+psHost+" dbname=pps user=postgres',' ";
            lsQuery+="SELECT DATE_PART(''hour'',date_id),SUM(TRUNC(CAST(amount AS NUMERIC),2)) FROM op_pps_relay WHERE CAST(date_id AS DATE) IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member(''<%=msDate%>'')) AND product_id = "+psProductId+" AND status = 20 GROUP BY 1 ') AS t( ";
            lsQuery+="hour_id DOUBLE PRECISION, ";
            lsQuery+="total NUMERIC ";
            lsQuery+=")";
            lsQuery+="ORDER BY 3,1 ";
            lsQuery+=") b ON hours = b.hour_id GROUP BY 1 ORDER BY 1;  ";


            
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
            psData = psData.replace(/^\s+|\s+$/g, '');
            if(psData != ""){
                var laDataTick = new Array();
                var laDataSold = new Array();
                var laDataCooked = new Array();
                var laDataWasted = new Array();
                var lsAvaiable = 0;
                var laAvailable = new Array();
                
                var lsData = psData.replace(/\s/g,"");
                for(var li=0;li<lsData.split("_||_").length;li++){
                    var lsRow = lsData.split("_||_")[li];
                    var lsValue = lsRow.split("_|||_")[0];
                    var lsSold = lsRow.split("_|||_")[1];
                    var lsCooked = lsRow.split("_|||_")[2];
                    var lsWasted = lsRow.split("_|||_")[3];
                    laDataTick.push([li,lsValue]);
                    laDataSold.push([lsValue,(lsSold/psAmount).toFixed(1)]);
                    laDataCooked.push([lsValue,(lsCooked/psAmount).toFixed(1)]);
                    laDataWasted.push([lsValue,(lsWasted/psAmount).toFixed(1)]);
                    if(lsAvaiable < 0)
                        laAvailable.push([lsValue,0]);
                    else
                        laAvailable.push([lsValue,Math.round(lsAvaiable/psAmount * 10)/10]);
                    lsAvaiable+=parseFloat(lsCooked)-parseFloat(lsSold)-parseFloat(lsWasted);
                    
                }

                 var loDataSet = [
                     { id:"DISPONIBLE", label: "DISPONIBLE ", data: laAvailable,  color: "orange" },
                    { id:"COCINADO", label: "COCINADO ", data: laDataCooked,  color: "blue" },
                    { id:"VENDIDO", label: "VENDIDO ", data: laDataSold,  color: "green" },
                    { id:"MERMA", label: "MERMA ", data: laDataWasted,  color: "red" }
                    
                ];
                print_line("divMain"+psProductId,loDataSet,null,"#D8F6CE",laDataTick);
            }
            else{
                if(psHost == "")
                    getData(psProductId,psAmount,"hostaddr=10.10.10.33");
                else
                    $( "#divMain"+psProductId ).append( "<center><img width='200px' src='/smartE3/images/e3/ui/explorer/opt_btn.PNG'/><h3>No se encontr&oacute; sinformaci&oacute;n, verifica que el servidor del PPS est&eacute; ne l&iacute;nea y exista venta la fecha consultada</h3></center>");
            }
        },"text");
    }
    function print_line(psDiv,poDataSet,poMarkings,psBgColor,poTicks){
        if(typeof poTicks == "undefined"){
            poTicks= [];
        }
        if(typeof poMarkings == "undefined"){
            poMarkings= [];
        }
	var loOptions = {            
             series: {
                   bars: {
                        numbers: {
                            show: true,
                            font: '7pt Arial',
                            fontColor: 'black',
                            threshold: 0.25,
                            yAlign: function(y) { if(y > 0)return y.toFixed(2); },
                            yOffset: 5,
                            xOffset:5
                        },
                       show: true,
                        barWidth: 0.15,
                        align: "center",
                        order: 1
                    }
                },
            grid: {
                hoverable: true,
		clickable: true,
                markings: poMarkings
            },
            xaxis:{
                mode:"categories",
                tickLength:5,
                ticks:poTicks
                
                
            },
            legend: {
                show: true
            },
            zoom:{
                interactive: false
            },
            pan: {
		interactive: false
	    }
            
            
        };  
        var plot = $.plot("#"+psDiv, poDataSet,loOptions);
        $("<div id='tooltip'></div>").css({
			position: "absolute",
			display: "none",
			border: "1px solid #fdd",
			padding: "2px",
			"background-color": "#fee",
			opacity: 0.80
		}).appendTo("body");
        $("#"+psDiv).bind("plothover", function (event, pos, item) {
                var str = "(" + pos.x.toFixed(2) + ", " + pos.y.toFixed(2) + ")";
         	$("#hoverdata").text(str);
                if (item && item.series.id != "range") {
                    	var x = item.datapoint[0].toFixed(2),
			y = item.datapoint[1].toFixed(2);
         		$("#tooltip").html("<b>"+item.series.id + "</b><br> Hora:<b>" + poTicks[Math.round(x)][1] + " </b><br> Valor: <b>" + y+"</b>")
                 	.css({top: item.pageY+5, left: item.pageX+5})
			.fadeIn(200);
                } else {
			$("#tooltip").hide();
                }
            
	});        
    }
  
    
        </script>
    </head>
    <body onload="">
    <center><div style="background-color:red;width:100%;color:white;border-radius: 5px"><table width="100%"><tr><td>Fecha(s):<br><%=msDate%></td><td width="80%"><h3><img width="50" src="/smartE3/images/e3/ui/explorer/mdw.png"><br>DETALLE DE DISPONIBILIDAD</h3></td><td id="tdStoreData">&nbsp;</td></tr></table></div></center>
        
        <script>getStore();validateSystem();</script>
    </body>
</html>
