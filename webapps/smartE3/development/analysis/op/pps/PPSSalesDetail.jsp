<%-- 
    Document   : PPSSalesDetail
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
        <title>PPS Sales Graphic</title>
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
                    $( "body" ).append( "<center><h1 style='color:gray'>"+lsName+"</h1></center><center><div id='divMain"+lsId+"' style='position:relative;margin-top: 5px;background-color:white;width:90%;height:250px;'></div></center> ");
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
            lsQuery+="SELECT hours, ";
            lsQuery+="COALESCE(TRUNC(SUM(CASE status_id WHEN 5 THEN b.total ELSE 0 END)/"+psAmount+",1),0)  status5, ";
            lsQuery+="COALESCE(TRUNC(SUM(CASE status_id WHEN 10 THEN b.total ELSE 0 END)/"+psAmount+",1),0)  status10, ";
            lsQuery+="COALESCE(TRUNC(SUM(CASE status_id WHEN 15 THEN b.total ELSE 0 END)/"+psAmount+",1),0)  status15, ";
            lsQuery+="COALESCE(TRUNC(SUM(CASE status_id WHEN 30 THEN b.total ELSE 0 END)/"+psAmount+",1),0)  status30 ";
            //lsQuery+="FROM (SELECT DISTINCT CAST(DATE_PART('hour',time_id) AS INTEGER) AS hours FROM op_mdw_product_data WHERE date_id IN ('<%=msDate%>')";
            lsQuery+="FROM (SELECT DISTINCT CAST(DATE_PART('hour',time_id) AS INTEGER) AS hours FROM op_mdw_product_data WHERE date_id IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member('<%=msDate%>'))";
            //lsQuery+="AND product_id = "+psProductId+" ";
            lsQuery+="AND product_id  = (SELECT product_id_ml FROM op_pps_product_mdw WHERE product_id = "+psProductId+") ";
            lsQuery+=" AND DATE_PART('hour',time_id) BETWEEN 9 AND 22 ";
            lsQuery+=") a ";
            lsQuery+="LEFT OUTER JOIN (  ";
            lsQuery+="SELECT * FROM dblink('"+psHost+" dbname=pps user=postgres',' ";
            lsQuery+="SELECT DATE_PART(''hour'',hour_id),status_id,SUM(trunc(CAST(quantity AS NUMERIC),2)) FROM op_pps_sold_detail WHERE product_id = "+psProductId+" AND date_id IN (SELECT CAST(date_id AS DATE) FROM ss_grl_fn_get_days_from_sql_member(''<%=msDate%>'')) GROUP BY DATE_PART(''hour'',hour_id),status_id ORDER BY 1,2; ') AS t( ";
            //lsQuery+="SELECT DATE_PART(''hour'',hour_id),status_id,SUM(CAST(quantity AS NUMERIC)) FROM op_pps_sold_detail WHERE product_id = "+psProductId+" AND date_id IN (''<%//=msDate%>'') GROUP BY DATE_PART(''hour'',hour_id),status_id ORDER BY 1,2; ') AS t( ";
            lsQuery+="hour_id DOUBLE PRECISION, ";
            lsQuery+="status_id INTEGER, ";
            lsQuery+="total NUMERIC ";
            lsQuery+=")) b ";
            lsQuery+="ON hours = b.hour_id ";
            lsQuery+="GROUP BY 1 ";
            lsQuery+="ORDER BY 1; ";

            
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
            psData = psData.replace(/^\s+|\s+$/g, '');
            if(psData != ""){
                var laDataFcst = new Array();
                var loDateTicks = new Array();
                var laDataFresh = new Array();
                var laDataOld = new Array();
                var laDataWaste = new Array();
                var laDataNot = new Array();

                var lsData = psData.replace(/\s/g,"");
                for(var li=0;li<lsData.split("_||_").length;li++){
                    var lsRow = lsData.split("_||_")[li];
                    var lsDate = lsRow.split("_|||_")[0];
                    var lsFresh = lsRow.split("_|||_")[1];
                    var lsOld = lsRow.split("_|||_")[2];
                    var lsWaste = lsRow.split("_|||_")[3];
                    var lsNot = lsRow.split("_|||_")[4];
                    loDateTicks.push([li,lsDate]);
                    laDataFresh.push([lsDate,lsFresh]);
                    laDataOld.push([lsDate,lsOld]);
                    laDataWaste.push([lsDate,lsWaste]);
                    laDataNot.push([lsDate,lsNot]);
                }

                 var loDataSet = [
                    { id:"FRESCO", label: "FRESCO ", data: laDataFresh,  color: "green" },
                    { id:"MEDIO", label: "MEDIO ", data: laDataOld,  color: "yellow" },
                    { id:"EXPIRADO", label: "EXPIRADO ", data: laDataWaste, color: "red" },
                    { id:"NO DISPONIBLE", label: "NO DISPONIBLE ", data: laDataNot,  color: "blue" }
                ];
                print_line("divMain"+psProductId,loDataSet,null,"#D8F6CE",loDateTicks);
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
    <body style=""onload="">
    <center><div style="background-color:red;width:100%;color:white;border-radius: 5px"><table width="100%"><tr><td>Fecha(s):<br><%=msDate%></td><td width="80%"><h3><img width="50" src="/smartE3/images/e3/ui/explorer/mdw.png"><br>DETALLE DE VENTAS</h3></td><td id="tdStoreData">&nbsp;</td></tr></table></div></center>
        <script>getStore();validateSystem()</script>
    </body>
</html>
