<%-- 
    Document   : MdwFrozenGraph
    Created on : 19/11/2015, 03:13:53 PM
    Author     : DAB1379
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<%
    String msDate= request.getParameter("psDate");
    String msType= request.getParameter("psType");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Frozen Graphic</title>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/excanvas.min.js"></script>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
        <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.min.js"></script>

        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.fillbetween.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.symbol.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.categories.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.navigate.min.js"></script>
        <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.barnumbers.enhanced.js"></script>

        <script>
            var msDate = '<%=msDate%>'
            var msType = '<%=msType%>'
    function getData(){
          var lsQuery;
            lsQuery = "";
            
            if(msType == "trx")
                lsQuery+=" SELECT date_id,trx_fcst,trx_frozen,trx_real,COALESCE((SELECT trx_real FROM op_mdw_main_data WHERE date_id =a.date_id-INTERVAL '1 year' ),0)";
            else if(msType == "pcs")
                lsQuery+=" SELECT date_id,pieces_fcst,CASE pieces_frozen WHEN 0 THEN (SELECT ppt_mng FROM op_gt_real_sist_mng WHERE date_id = a.date_id) ELSE pieces_frozen END,pieces_real,COALESCE((SELECT pieces_real FROM op_mdw_main_data WHERE date_id =a.date_id-INTERVAL '1 year' ),0)";
            lsQuery+=" FROM op_mdw_main_data a ";
            lsQuery+=" WHERE (";
            lsQuery+=" date_id = CAST('"+msDate+"' AS DATE)";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '7 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '14 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '21 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '28 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '35 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '42 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '49 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '56 day'";
            lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '63 day'";
            //
            //lsQuery+=" OR date_id = CAST('"+msDate+"' AS DATE) -INTERVAL '1 year'";
            lsQuery+=") ORDER BY date_id";
            
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery:lsQuery, psConnectionPool:"jdbc/storeEyumDBConnectionPool"},
          function(psData) {
            var laDataFcst = new Array();
            var laDataFrozen = new Array();
            var laDataReal = new Array();
            var loDateTicks = new Array();
            var laDataPastYear = new Array();
            var lsData = psData.replace(/\s/g,"");
            for(var li=0;li<lsData.split("_||_").length;li++){
                var lsRow = lsData.split("_||_")[li];
                var lsDate = lsRow.split("_|||_")[0];
                var lsFcst = lsRow.split("_|||_")[1];
                var lsFrozen = lsRow.split("_|||_")[2];
                var lsReal = lsRow.split("_|||_")[3];
                var lsLastYear = lsRow.split("_|||_")[4];
                loDateTicks.push([li,lsDate]);
                laDataFcst.push([lsDate,lsFcst]);
                laDataFrozen.push([lsDate,lsFrozen]);
                laDataReal.push([lsDate,lsReal]);
                laDataPastYear.push([lsDate,lsLastYear]);
            }
             var loPeopleMarkings = [
         {yaxis: { from: 0, to: 50 },xaxis:{from: 0, to: 1},color: "#BCF5A9"},
         {yaxis: { from: 50, to: 90 },xaxis:{from: 0, to: 1},color: "#F5A9A9"},
         {yaxis: { from: 0, to: 60 },xaxis:{from: 1, to: 2},color: "#BCF5A9"},
         {yaxis: { from: 60, to: 100 },xaxis:{from: 1, to: 2},color: "#F5A9A9"},
         {yaxis: { from: 0, to: 50 },xaxis:{from: 2, to: 3},color: "#BCF5A9"},
         {yaxis: { from: 50, to: 70 },xaxis:{from: 2, to: 3},color: "#F5A9A9"}
         
        ];
             var loDataSet = [
		{ id:"PRONOSTICO", label: "SISTEMA ", data: laDataFcst, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "blue" },
                { id:"CONGELADO", label: "CONGELADO ", data: laDataFrozen, lines: { show: true },points: { symbol: "triangle" },dashes:{show:true}, color: "green" },
                { id:"REAL", label: "REAL ", data: laDataReal, lines: { show: true },points: { symbol: "square" },dashes:{show:true}, color: "red" },
                { id:"PY", label: "PY ", data: laDataPastYear, lines: { lineWidth: 0,fill: true,show: true },points: {show:false},dashes:{show:true}, color: "#F5A9A9" }
            ];
            print_line("divMain",loDataSet,null,"#D8F6CE",loDateTicks);
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
                            font: '8 pt Arial',
                            fontColor: '#FF0000',
                            threshold: 0.25,
                            yAlign: function(y) { return y; },
                            yOffset: 5 
                        },
                        align: "center",
                        barWidth: 0.5,
                        vertical: true,
                        lineWidth: 1,
                     
                    },
                lines: { show: true, lineWidth: 2 },
                shadowSize: 0,
                points: {show: true
			}
            },
            grid: {
                backgroundColor:psBgColor,
                hoverable: true,
		clickable: true,
                markings: poMarkings
            },
            xaxis:{
                mode:"categories",
                tickLength:0,
                ticks:poTicks
                
            },
            legend: {
                show: false
            },
            zoom: {
		interactive: true
	    },
	    pan: {
		interactive: true
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
         		$("#tooltip").html("<b>"+item.series.id + "</b><br> Fecha:<b>" + poTicks[parseInt(x)][1] + " </b><br> Valor: <b>" + y+"</b>")
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
        <div id="divMain" style="position:relative;margin-top: 5px;background-color:white;width:880px;height:250px;"></div>
    <center><font color="red"><b>&#9632;Real</b></font>&nbsp;&nbsp;<font color="green"><b>&#9658;Congelado</b></font> &nbsp;&nbsp;<font color="blue"><b>&#9679;Pron&oacute;stico</b></font></center>
        <script>getData()</script>
    </body>
</html>
