<%-- 
    Document   : DashboardOp
    Created on : 2/09/2014, 05:14:11 PM
    Author     : DAB1379
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>

<html>
    <link href="CSS/OperationsDashboard.css" rel="stylesheet" type="text/css" />
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Tester Dashboard</title>
    </head>
    <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/excanvas.min.js"></script>
    <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.js"></script>
    <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.js"></script>
    <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.fillbetween.js"></script>
    <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.symbol.js"></script>
    <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.1.0.1.min.js"></script>
    <script type="text/javascript" src="/smartE3/resources/js/justgage/raphael.2.1.0.min.js"></script>
    <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.js"></script>
    
    
    <script>
    function print_traffic_ligth(piWidth,piHeight,piValue,piYellow,piGreen,psTitle){
        var lsHTML = "";
        var lsColor = "";
        var lsImg = "";
        var lsHeader = "";
        var lsFooter = "";
        lsHeader = "<div style='text-align:center;width:100%;heigth:10%;' class='trLigthHeader'>"+psTitle+"</div>";
        if(piValue <= piYellow)
            lsColor = "red";
        else if(piValue > piYellow && piValue <= piGreen)
            lsColor="yellow";
        else if(piValue > piGreen)
            lsColor="green";
        lsImg = "<img width='"+piWidth*(0.9)+"px' height='"+piHeight*(0.8)+"px' src='Images/OpDashboard/"+lsColor+"_traffic.png'></img>";
        lsFooter = "<div style='position:relative;text-align:center;width:"+piWidth*(0.9)+"px;height:10%;' class='trLigthFooter'>"+piValue+"</div>";
        lsHTML+= "<div style='position:relative;width:"+piWidth+"px;height="+piHeight+";border:solid 2px gray;border-radius:15px;background-color:white' ><center>";
        lsHTML+=lsHeader+lsImg+lsFooter;
        lsHTML+="<br></center></div>";
        return lsHTML;
    }
    function print_speedo(piWidth,piValue,psTitle){
        var lsHTML = "";
        var lsType = "";
        var lsImg = "";
        var lsHeader = "";
        var lsFooter = "";
        lsHeader = "<div style='text-align:center;width:100%;heigth:10%;' class='speedHeader'>"+psTitle+"</div>";
        if(piValue <= 0)
            lsType = "0";
        else if(piValue > 0 && piValue <= 10)
            lsType="10";
        else if(piValue > 10 && piValue <= 20)
            lsType="20";
        else if(piValue > 20 && piValue <= 30)
            lsType="30";
        else if(piValue > 30 && piValue <= 40)
            lsType="40";
        else if(piValue > 40 && piValue <= 50)
            lsType="50";
        else if(piValue > 50 && piValue <= 60)
            lsType="60";
        else if(piValue > 60 && piValue <= 70)
            lsType="70";
        else if(piValue > 70 && piValue <= 80)
            lsType="80";
        else if(piValue > 80 && piValue <= 90)
            lsType="90";
        else if(piValue > 90)
            lsType="100";
        
        lsImg = "<center><img width='"+piWidth*(0.9)+"px' height='"+piWidth*(0.9)+"px' src='Images/OpDashboard/speed_"+lsType+".png'></img></center>";
        lsFooter = "<div style='position:relative;text-align:center;width:90%;height:10%;' class='speedFooter'>"+piValue+"</div>";
        lsHTML+= "<div style='position:relative;width:"+piWidth+"px;height="+piWidth+";border:solid 2px gray;border-radius:15px;background-color:white' ><center>";
        lsHTML+=lsHeader+lsImg+lsFooter;
        lsHTML+="</center><br></div>";
        return lsHTML;
    }
    function print_poniter_bar(piValue,psTitle,piMin,piInterval){
        var liWidth = 200;
        var liInit = -17;
        var liFin = 178;
        var liLarge = 195;
        var liMax = piMin+(piInterval*2);
        var liPercent = ((piValue-piMin)*100)/(piInterval*2);
        var liPosition = (liLarge*liPercent)/100;
        if(piValue <= piMin)
            liPosition = liInit;
        else if(piValue >= liMax)
            liPosition = liFin;
        else{
            liPosition = liPosition+liInit;
        }
        var lsHTML = "";
        var lsImg = "";
        var lsHeader = "";
        var lsPointer = "";
        var lsValues = "";
        var lsFooter = "";
        
        lsValues = "<div style='position:relative;width:"+liWidth+"px;height="+liWidth*(0.1)+";' class='barValues'><table style='width:100%'><tr><td width=66px align=left>"+piMin+"</td><td width=66px align=center>"+(piMin+piInterval)+"</td><td width=66px align=right>"+liMax+"</td></tr></table></div>";
        lsHeader = "<div style='text-align:center;width:100%;heigth:10%;' class='barHeader'>"+psTitle+"</div>";
        lsPointer = "<div style='position:relative;top:"+liWidth*(0.05)+"px;left:"+liPosition+"px'><img width='"+liWidth*(0.2)+"px' height='"+liWidth*(0.2)+"px' src='Images/OpDashboard/pointer.png'></img></div>";
        lsImg = "<img width='"+liWidth+"px' height='"+liWidth*(0.1)+"px' src='Images/OpDashboard/bar.png'></img>";
        lsFooter = "<center><div style='position:relative;text-align:center;width:"+liWidth*(0.9)+"px;height:10%;' class='barFooter'>"+piValue+"</div></center>";
        lsHTML+= "<div style='position:relative;width:"+liWidth+"px;height="+liWidth*(0.4)+";border:solid 2px gray;border-radius:15px;background-color:white'>";
        lsHTML+=lsHeader+lsPointer+lsImg+lsValues+lsFooter;
        lsHTML+="<br></div>";
        return lsHTML;
        
    }
    function print_line(psDiv,poSaleDataSet,poMarkings,psBgColor){
        
	var loOptions = {            
             series: {
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
            }   
            
        };
      
	var plot = $.plot("#"+psDiv, poSaleDataSet,loOptions);
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
         		$("#tooltip").html(item.series.label + " " + x + " = " + y)
                 	.css({top: item.pageY+5, left: item.pageX+5})
			.fadeIn(200);
                } else {
			$("#tooltip").hide();
                }
            
	});        
    }
    function print_gage(psDiv,psTitle,piValue,piMin,piMax,piDisr,psLabel){
       var loGage = new JustGage({
       id: psDiv,
       value: piValue,
       min:piMin,
       max:piMax,
       title: psTitle,
       
       levelColorsGradient: false,
       label:psLabel,
       customSectors: [{
            color : "#FF0000",
            lo : -99999,
            hi : piDisr
        },{
            color : "#00FF00",
            lo : piDisr,
            hi : 99999
        }],
    counter: true
     });
    }
    function getDashboard(){
        document.getElementById("divPlantilla").innerHTML = print_traffic_ligth(100,250,80,40,80,"Plantilla");
        document.getElementById("divPlantilla1").innerHTML = print_traffic_ligth(100,250,90,40,80,"Plantilla");
        document.getElementById("divPlantilla2").innerHTML = print_traffic_ligth(100,250,20,40,80,"Plantilla");
        document.getElementById("divClientes").innerHTML = print_speedo(200,0,"Clientes < 30");
        document.getElementById("divClientes1").innerHTML = print_speedo(200,5,"Clientes < 14");
        document.getElementById("divBar").innerHTML = print_poniter_bar(5,"Clientes",-10,20);
        document.getElementById("divBar1").innerHTML = print_poniter_bar(15,"Utilidades1",-10,20);
        document.getElementById("divBar2").innerHTML = print_poniter_bar(35,"Utilidades2",0,50);
        document.getElementById("divBar3").innerHTML = print_poniter_bar(150,"Utilidades3",50,100);
        document.getElementById("divBar4").innerHTML = print_poniter_bar(15,"Utilidades4",-10,20);
        document.getElementById("divBar5").innerHTML = print_poniter_bar(3,"Utilidades5",0,20);
        print_gage("gauge","Clientes",20,0,150,30,"<10");
        var laSaleRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laSaleData = [[3, 5.0],[3, 8.3], [5, 2.0], [5, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [9, 1.3], [10, 16.3]];
        var loSaleDataSet = [
		{ id: "range", data: laSaleRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"VENTAS", label: "VENTAS", data: laSaleData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" }
	];
        var loSaleMarkings = [];
        print_line("divSales",loSaleDataSet,loSaleMarkings,"#3ADF00");
        var laTrxRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laTrxData = [[4, 5.0],[2, 8.3], [5, 3.0], [7, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [10, 1.3], [10, 16.3]];
        var loTrxDataSet = [
		{ id: "range", data: laTrxRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"TRANSACCIONES", label: "TRANSACCIONES", data: laTrxData, lines: { show: true },points: { symbol: "triangle" },dashes:{show:true}, color: "black" }
	];
        var loTrxMarkings = [];
        print_line("divTran",loTrxDataSet,loTrxMarkings,"#3ADF00");
        var laWPSADRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laWPSADData = [[4, 5.0],[2, 8.3], [5, 3.0], [7, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [10, 1.3], [10, 16.3]];
        var loWPSADDataSet = [
		{ id: "range", data: laWPSADRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"WPSA TRX DELIVERY", label: "WPSA TRX DELIVERY", data: laWPSADData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" }
	];
        var loWPSADMarkings = [];
        print_line("divWPSADel",loWPSADDataSet,loWPSADMarkings,"#3ADF00");
        var laWPSACRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laWPSACData = [[4, 5.0],[2, 8.3], [5, 3.0], [7, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [10, 1.3], [10, 16.3]];
        var loWPSACDataSet = [
		{ id: "range", data: laWPSACRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"WPSA TRX CARRY OUT", label: "WPSA TRX CARRY OUT", data: laWPSACData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" }
	];
        var loWPSADMarkings = [];
        print_line("divWPSACO",loWPSACDataSet,loWPSADMarkings,"#3ADF00");
        var laWPSADIRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laWPSADIData = [[4, 5.0],[2, 8.3], [5, 3.0], [7, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [10, 1.3], [10, 16.3]];
        var loWPSADIDataSet = [
		{ id: "range", data: laWPSADIRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"WPSA TRX DINE IN", label: "WPSA TRX DINE IN", data: laWPSADIData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" }
	];
        var loWPSADIMarkings = [];
        print_line("divWPSADI",loWPSADIDataSet,loWPSADIMarkings,"#3ADF00");
        var laSSACRanData = [[2, 5.0], [3, 7.3], [4, 2.0], [5, 6.5], [6, 5.7], [7, 5.6], [8, 4.6], [9, 1.3], [10, 15.3]];
        var laSSACData = [[4, 5.0],[2, 8.3], [5, 3.0], [7, 7.5], [7, 5.7], [7, 6.6], [7, 5.6], [10, 1.3], [10, 16.3]];
        var loSSACDataSet = [
		{ id: "range", data: laSSACRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"VTA SUGESTIVA CARRY", label: "VTA SUGESTIVA CARRY", data: laSSACData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" }
	];
        var loSSACMarkings = [];
        print_line("divSSCO",loSSACDataSet,loSSACMarkings,"#3ADF00");
        var laPeopleRanData = [];
        var laPeopleData = [[1, 59],[2, 63], [3, 58],[5, 70],[6, 50]];
        var loPeopleDataSet = [
		{ id: "range", data: laPeopleRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"HORAS IDEALES", label: "HORAS IDEALES", data: laPeopleData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" },
                { id:"HORAS REALES", label: "HORAS REALES", data: laPeopleRanData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "#3ADF00" },
                { id:"HORAS EXTRAS", label: "HORAS EXTRAS", data: laPeopleRanData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "#FF0000" }
	];
        var loPeopleMarkings = [
         {yaxis: { from: 0, to: 50 },xaxis:{from: 0.7, to: 1.3},color: "#3ADF00"},
         {yaxis: { from: 50, to: 90 },xaxis:{from: 0.7, to: 1.3},color: "#FF0000"},
         {yaxis: { from: 0, to: 60 },xaxis:{from: 1.7, to: 2.3},color: "#3ADF00"},
         {yaxis: { from: 60, to: 100 },xaxis:{from: 1.7, to: 2.3},color: "#FF0000"},
         {yaxis: { from: 0, to: 50 },xaxis:{from: 2.7, to: 3.3},color: "#3ADF00"},
         {yaxis: { from: 50, to: 70 },xaxis:{from: 2.7, to: 3.3},color: "#FF0000"}
         
        ];
        print_line("divPeople",loPeopleDataSet,loPeopleMarkings,"#FFFFFF");
        var laCoupRanData = [[1, 20], [2, 20], [3, 20], [4, 20], [5, 20], [6, 20], [7, 20], [8, 20], [9, 20], [10, 20], [11, 20]];
        var laCuopTPData = [[1, 59],[2, 23], [3, 58], [4, 18],[5, 70],[6, 14],[7, 50],[8, 33], [9, 58],[10, 85],[11, 50]];
        var laCuopSAData = [[1, 49],[2, 33], [3, 58], [4, 28],[5, 60],[6, 13],[7, 75],[8, 33], [9, 48],[10, 95],[11, 50]];
        var laCuopCXHData = [[1, 39],[2, 43], [3, 58], [4, 58],[5, 50],[6, 12],[7, 10],[8, 43], [9, 38],[10, 65],[11, 30]];
        var laCuopREEMBData = [[1, 29],[2, 53], [3, 58], [4, 48],[5, 30],[6, 11],[7, 20],[8, 53], [9, 28],[10, 70],[11, 20]];
        var laCuopLSMData = [[1, 19],[2, 63], [3, 58], [4, 38],[5, 20],[6, 10],[7, 26],[8, 63], [9, 18],[10, 10],[11, 10]];
        var loCuopDataSet = [
		{ id: "range", data: laCoupRanData, lines: { show: true, lineWidth: 0, fill: 1 },points: {show:false}, color: "rgb(255,50,50)" },
                { id:"TP", label: "TP", data: laCuopTPData, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "black" },
                { id:"SA", label: "SA", data: laCuopSAData, lines: { show: true },points: { symbol: "triangle" },dashes:{show:true}, color: "yellow" },
                { id:"CXH", label: "CXH", data: laCuopCXHData, lines: { show: true },points: { symbol: "square" },dashes:{show:true}, color: "brown" },
                { id:"REEMB", label: "REEMB", data: laCuopREEMBData, lines: { show: true },points: { symbol: "diamond" },dashes:{show:true}, color: "orange" },
                { id:"LSM", label: "LSM", data: laCuopLSMData, lines: { show: true },points: { symbol: "cross" },dashes:{show:true}, color: "blue" },
	];
        var loCoupMarkings = [];
        print_line("divCoup",loCuopDataSet,loCoupMarkings,"#3ADF00");
        
    }
</script>    
    <body style="background-color:#E6E6E6;background-image: url(Images/OpDashboard/background_header.png) " onload="getDashboard()">
    <center>
        <div style="width:100%;height:100px;background-image: url(Images/OpDashboard/background_header.png)">
            <center>
                <table>
                    <tr>
                        <td>
                            <img src="Images/OpDashboard/header.png" width="300px" />
                        </td>
                        <td>
                            <img src="Images/OpDashboard/ph.png" width="100px" />
                        </td>
                    </tr>
                </table>
                
                
            </center>
        </div>
        <table>
            
            <tr>
                <td>
                    <table>
                        <tr>
                            <td colspan="2" class="gradient">Ventas</td>
                        </tr>
                        <tr>
                            <td>
                                <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divSales" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                            <td>
                                <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divTran" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divWPSADel" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                            <td>
                                 <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divWPSACO" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                 <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divWPSADI" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                            <td>
                                <div style="background-color:white;width:260px;height:160px;border:solid 2px gray;border-radius:15px;">
                                    <center>
                                        <div id="divSSCO" style="background-color:white;width:250px;height:150px;margin-top: 5px;"></div>
                                    </center>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table>
                        <tr>
                            <td colspan="2" class="gradient">Clientes</td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divClientes"></div>
                            </td>
                            <td>
                                <div id="divClientes1"></div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div style="border:solid 2px gray;border-radius:15px;background-color: white" id="gauge"></div>
                            </td>    
                        </tr>
                        
                    </table>
                </td>
                <td>
                    <table>
                        <tr>
                            <td colspan="2" class="gradient">Utilidades</td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divBar1"></div>
                            </td>
                            <td>
                                <div id="divBar2"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divBar3"></div>
                            </td>
                             <td>
                                <div id="divBar4"></div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divBar5"></div>
                            </td>
                            <td>
                                <div id="divBar"></div>
                            </td>
                        </tr>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table>
                        <tr>
                            <td colspan="5" class="gradient">Gente</td>
                        </tr>
                        <tr>
                            <td>
                                <div id="divPlantilla"></div>
                            </td>
                            <td>
                                <div id="divPlantilla1"></div>
                            </td>
                            <td>
                                <div id="divPlantilla2"></div>
                            </td>
                            <td>
                                <div id="divPlantilla3"></div>
                            </td>
                             <td>
                                 <div style="background-color:white;width:410px;height:210px;border:solid 2px gray;border-radius:15px;">
                                     <center>
                                        <div id="divPeople" style="position:relative;margin-top: 5px;background-color:white;width:400px;height:200px;"></div>
                                     </center>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
               
                <td>
                    <table>
                        <tr>
                            <td colspan="5" class="gradient">Descuentos y Cupones</td>
                        </tr>
                        <tr>
                            <td>
                                 <div style="background-color:white;width:410px;height:210px;border:solid 2px gray;border-radius:15px;">
                                     <center>
                                        <div id="divCoup" style="position:relative;margin-top: 5px;background-color:white;width:400px;height:200px;"></div>
                                     </center>
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                </td>
            </tr>
        </table>
        
        
    </center>
    </body>
</html>
