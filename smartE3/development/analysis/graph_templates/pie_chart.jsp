<%@page import="yum.e3.server.generals.utils.DataUtils"%>
<%
    String lsTitle = DataUtils.getValidValue(request.getParameter("psTitle"),"");
    String lsData = DataUtils.getValidValue(request.getParameter("psData"),"");
    String lsToolTip = DataUtils.getValidValue(request.getParameter("psToolTip"),"");
    String lsDLFmt = DataUtils.getValidValue(request.getParameter("psDataLabelFmt"),"");
    String lsSerieName = DataUtils.getValidValue(request.getParameter("psSerieName"),"");
    String lsDesc = DataUtils.getValidValue(request.getParameter("psDesc"),"");
    String lsBuildTable = DataUtils.getValidValue(request.getParameter("psBuildTable"),"false");
    

%>
<html>
	<head>
            <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300&display=swap" rel="stylesheet">
	<style>
		.highcharts-figure, .highcharts-data-table table {
			min-width: 320px; 
			max-width: 800px;
			margin: 1em auto;
		}

		.highcharts-data-table table {
			font-family: Verdana, sans-serif;
			border-collapse: collapse;
			border: 1px solid #EBEBEB;
			margin: 10px auto;
			text-align: center;
			width: 100%;
			max-width: 500px;
		}
		.highcharts-data-table caption {
			padding: 1em 0;
			font-size: 1.2em;
			color: #555;
		}
		.highcharts-data-table th {
			font-weight: 600;
			padding: 0.5em;
		}
		.highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption {
			padding: 0.5em;
		}
		.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) {
			background: #f8f8f8;
		}
		.highcharts-data-table tr:hover {
			background: #f1f7ff;
		}
                .highcharts-description{
                    font-family: 'Open Sans', sans-serif;
                }

		input[type="number"] {
			min-width: 50px;
		}
	</style>
	
	<script src="https://code.highcharts.com/highcharts.js"></script>
	<script src="https://code.highcharts.com/modules/exporting.js"></script>
	<script src="https://code.highcharts.com/modules/export-data.js"></script>
	<script src="https://code.highcharts.com/modules/accessibility.js"></script>
	
	</head>
	<body>
		
		
	<figure class="highcharts-figure">
		<div id="container"></div>
                <center>
		<p class="highcharts-description">
                   <%=lsDesc%>
		</p>
                </center>
                <%if(lsBuildTable.equals("true")){%>
                <center>
                <table id="tblData" style="text-align:center;border-collapse:collapse;border:1px solid gray;font-family: 'Open Sans', sans-serif;">
                    
                </table>
                <script>
                    var lsData = <%=lsData%>;
                    var liTotal = 0;
                    var loTbl = document.getElementById("tblData");
                    var loRow = loTbl.insertRow(loTbl.rows.length);
                    loRow.style="font-weight:bold;background:#FF5D00;color:white;border-collapse:collapse;border:1px solid gray;";
                    var loFirst = loRow.insertCell(0);
                    loFirst.style="border-collapse:collapse;border:1px solid gray;";
                    var loSecond = loRow.insertCell(1);
                    loSecond.style="border-collapse:collapse;border:1px solid gray;";
                    loFirst.innerHTML = "Categor&iacute;a";
                    loSecond.innerHTML = "<%=lsSerieName%>";
                    var liIdx = 0;
                    for (var lsPoint in lsData) {
                        liIdx++;
                        if (lsData.hasOwnProperty(lsPoint)) {
                          var loRow = loTbl.insertRow(loTbl.rows.length);
                          if(liIdx%2 == 0){
                                loRow.style="background:#D3D0CE"
                          }
                          var loFirst = loRow.insertCell(0);
                          loFirst.style="border-collapse:collapse;border:1px solid gray;";
                          var loSecond = loRow.insertCell(1);
                          loSecond.style="border-collapse:collapse;border:1px solid gray;";
                          loFirst.innerHTML = lsData[lsPoint].name;
                          loSecond.innerHTML = lsData[lsPoint].y;
                          liTotal+=lsData[lsPoint].y;
                        }
                    }
                    loRow = loTbl.insertRow(loTbl.rows.length);
                    loRow.style="font-weight:bold;background:#BDF67C";
                    loFirst = loRow.insertCell(0);
                    loFirst.style="border-collapse:collapse;border:1px solid gray;";
                    loSecond = loRow.insertCell(1);
                    loSecond.style="border-collapse:collapse;border:1px solid gray;";
                    loFirst.innerHTML = "Total";
                    loSecond.innerHTML = liTotal;
                </script>
                </center>
                <%}%>
	</figure>
	
	<script>
		
		Highcharts.chart("container", {
			chart: {
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false,
				type: "pie"
			},
			title: {
				text: "<%=lsTitle%>"
			},
			tooltip: {
				pointFormat: "<%=lsToolTip%>"
			},
			accessibility: {
				point: {
					valueSuffix: "%"
				}
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: "pointer",
					dataLabels: {
						enabled: true,
						format: "<%=lsDLFmt%>"
					}
				}
			},
			series: [{
				name: "<%=lsSerieName%>",
				colorByPoint: true,
				data: <%=lsData%>
			}]
		});
	
	</script>
	</body>
	</html>