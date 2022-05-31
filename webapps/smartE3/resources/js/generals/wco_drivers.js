/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//configuracion inicial
var moMainTimer = null;
var moRePrintTimer = null;
function setIntitialData(){
    moAppHandler.configureApplication();
    manageIntervals();
}
function startMainTimer(){
    clearInterval(moMainTimer);
//    moAppHandler.setLayout();
    moMainTimer = setInterval('updateTime();', 1000);
}
function updateTime(){
    var loDate = new Date();
    moAppHandler.setHour(loDate.getHours());
    moAppHandler.setMinute(loDate.getMinutes());
    moAppHandler.setSeconds(loDate.getSeconds());
    $("#tdHour").html(((moAppHandler.getHour()<10)?"0"+moAppHandler.getHour():moAppHandler.getHour())+":"+((moAppHandler.getMinute()<10)?"0"+moAppHandler.getMinute():moAppHandler.getMinute()));
}
function manageIntervals(){
    clearInterval(moRePrintTimer);
    moAppHandler.loadData();
    moRePrintTimer = setInterval('manageRePrint();', 60000);
    
}
function manageRePrint(){
    moAppHandler.loadData();
}
function resizeTable(){
    $("#divMainTable").height(window.innerHeight*0.96+"px");
}
    	       				         
													  
	       
             
             
                
//////////////////////////////////////////////////////////////////////////////////////
//                                 AppHandler
/////////////////////////////////////////////////////////////////////////////////////
function AppHandler() {
   this.moParams = null;
   this.miCounter = 1;
   this.miHour = 0;
   this.miMinute = 0;
   this.miSeconds = 0;
   this.moOrder = null;
   this.moOrderRemoved = null;
   this.init = function(){
       this.moOrder = new Hash();
       this.moOrderRemoved = new Hash();
   };
   this.setHour = function(piHour){
       this.miHour = piHour;
   };
   this.getOrderHash = function(){
       return this.moOrder;
   };
   this.getOrderRemovedHash = function(){
       return this.moOrderRemoved;
   };
   this.setMinute = function(piMinute){
       this.miMinute = piMinute;
   };
   this.setSeconds = function(piSecond){
       this.miSeconds = piSecond;
   };
   this.getHour = function(){
       return this.miHour;
   };
   this.getMinute = function(){
       return this.miMinute;
   };
   this.getSeconds = function(){
       return this.miSeconds;
   };
   this.configureApplication = function() {
        var loContext = this;
        moParams = new Hash();
        $.post("/smartE3/DataService",{psQuery:"SELECT 'brand_id',company_id FROM ss_org_cat_company ORDER BY 1 ",psService:"getQueryData",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter()},
        function(psData) {
            psData = psData.replace(/^\s+|\s+$/g, '');
            if (psData != "") {
                for(var li=0;li<psData.split(DataUtils.getQueryRowSpliter()).length;li++){
                    moParams.setItem(psData.split(DataUtils.getQueryRowSpliter())[li].split(DataUtils.getQueryColSpliter())[0],psData.split(DataUtils.getQueryRowSpliter())[li].split(DataUtils.getQueryColSpliter())[1]);
                }
                loContext.setImgData();
                adjustZoom(DataUtils.getValidValue(loContext.getParamValue("general_zoom"),DataUtils.getValidValue(location.search.split("adjust=")[1],"100")));
                
            }
            else{
                return false;
            }
        },"text");
    }
    this.getCounter = function(){
        return this.miCounter;
    }
    this.setCounter = function(piValue){
        this.miCounter=piValue;
    }
     this.getParamValue = function(psParamName){
        if(moParams != null)
            return moParams.getItem(psParamName);
        else 
            return "";
    };
     this.loadData = function(){
        var loContext = this;
        var lbReprint = false;
        var lsSrc = "/smartE3/DataService";
        var lsQuery = " SELECT driver_code, ";
        lsQuery+="COALESCE(CASE COUNT(sequence_no) WHEN 0 THEN 0 ELSE COALESCE(SUM(CASE WHEN delivery_time <= promise_time THEN 1 ELSE 0 END),0)*100/COUNT(sequence_no) END,0), ";
        lsQuery+="COALESCE(COUNT(sequence_no),0), ";
        lsQuery+="COALESCE(AVG(delivery_time),0),SUM(CASE WHEN delivery_time <= promise_time THEN 1 ELSE 0 END) ";
        lsQuery+="FROM ( ";
        lsQuery+="SELECT sequence_no,a.driver_code||'- '||COALESCE(c.employee_name||' '||c.paternal,'CLV DE REP NO ASIGNADA') AS driver_code, ";
        lsQuery+="extract(epoch from ((CAST(order_date AS TEXT)||' '||to_char(CAST(CASE promise_time WHEN '0' THEN CAST(CAST(CASE LENGTH(printed_time) WHEN 5 THEN '0'||printed_time ELSE printed_time END AS TIME)+INTERVAL'30 minutes' AS TEXT) ELSE CASE LENGTH(promise_time) WHEN 5 THEN '0'||promise_time ELSE promise_time END END AS TIME),'HH24:MI'))::TIMESTAMP - (CAST(order_date AS TEXT)||' '||to_char(CAST(CASE LENGTH(printed_time) WHEN 5 THEN '0'||printed_time ELSE printed_time END AS TIME),'HH24:MI'))::TIMESTAMP))/60 AS promise_time, ";
        lsQuery+="(extract(epoch from ((CAST(order_date AS TEXT)||' '||to_char(CAST(CASE LENGTH(served_time) WHEN 5 THEN '0'||served_time ELSE served_time END AS TIME),'HH24:MI'))::TIMESTAMP - (CAST(order_date AS TEXT)||' '||to_char(CAST(CASE LENGTH(printed_time) WHEN 5 THEN '0'||printed_time ELSE printed_time END  AS TIME),'HH24:MI'))::TIMESTAMP))/60)+ ";
        lsQuery+="((extract(epoch from ((CAST(order_date AS TEXT)||' '||to_char(CAST(CASE LENGTH(cashed_time) WHEN 5 THEN '0'||cashed_time ELSE cashed_time END AS TIME),'HH24:MI'))::TIMESTAMP - (CAST(order_date AS TEXT)||' '||to_char(CAST(CASE LENGTH(served_time) WHEN 5 THEN '0'||served_time ELSE served_time END AS TIME),'HH24:MI'))::TIMESTAMP))/60)/ ";
        lsQuery+="(CASE CAST(dispatch_batch AS INTEGER) WHEN 1 THEN 2  ELSE 2+((CAST(dispatch_batch AS INTEGER)-1)*0.5) END)*(CASE CAST(dispatch_sequence AS INTEGER) WHEN 1 THEN 1  ELSE 1+((CAST(dispatch_sequence AS INTEGER)-1)*0.5) END)) AS delivery_time ";
        lsQuery+="FROM op_sls_ticket_data a ";
        lsQuery+="LEFT OUTER JOIN ss_grl_driver_code b ";
        lsQuery+="ON REPLACE(a.driver_code,' ','') = REPLACE(b.driver_code,' ','') ";
        lsQuery+="LEFT OUTER JOIN ss_cat_emp_sorpi c ";
        lsQuery+="ON b.employee_id = c.employee_id ";
        lsQuery+="WHERE order_date IN (CURRENT_DATE) ";
        lsQuery+="AND cancel_status  = '' ";
        lsQuery+="AND rtrim(printed_time,' ') NOT IN ('0','') ";
        lsQuery+="AND rtrim(cashed_time,' ') NOT IN ('0','') ";
        lsQuery+="AND rtrim(served_time,' ') NOT IN ('0','') ";
        lsQuery+="AND rtrim(promise_time,' ') NOT IN ('0','') ";
        lsQuery+="AND destination='2' ";
        lsQuery+=") AS gm1 ";
        lsQuery+="GROUP BY driver_code ";
        lsQuery+="ORDER BY 2 DESC LIMIT 15;";
        $.post(lsSrc,{psQuery:lsQuery, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                
                var loTable = document.getElementById("tblRep");
                loTable.innerHTML = "";
                loContext.addHeader();
                var maData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<maData.length;li++){
                    var lsDriver = maData[li].split(DataUtils.getQueryColSpliter())[0];
                    var lsPercent = maData[li].split(DataUtils.getQueryColSpliter())[1];
                    var lsTotal = maData[li].split(DataUtils.getQueryColSpliter())[2];
                    var lsTime = maData[li].split(DataUtils.getQueryColSpliter())[3];
                    var lsTotalTT = maData[li].split(DataUtils.getQueryColSpliter())[4];
                    
                    loContext.printRow(lsDriver,lsPercent+"%",lsTotal+"/"+lsTotalTT,parseFloat(lsTime).toFixed(2));
                        
                }
            }
        });
        
        
     };
     this.printRow = function(psDriver,psPercent,psTotal,psTime){
        var loTable = document.getElementById("tblRep");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        var loTd4 = loTr.insertCell(loTr.cells.length);
        var lsColor="";
        var lsFColor="";
        if(liId%2 == 0){
            loTr.setAttribute("class","order_label_pair letter_rep");
        } else {
            loTr.setAttribute("class","letter_rep");
        }
        loTr.setAttribute("id",this.msObjId);
        loTd1.setAttribute("width","45%");
        loTd2.setAttribute("width","10%");
        loTd3.setAttribute("width","25%");
        loTd4.setAttribute("width","10%");
        
        loTd1.innerHTML = psDriver;
        loTd1.setAttribute("class","driver");
        if(psDriver.indexOf("CLV DE REP NO ASIGNADA") != -1){
            loTd1.setAttribute("class","driver value_red");
            loTd1.innerHTML = loTd1.innerHTML+"<img src='/smartE3/images/e3/ui/explorer/alert.gif' width='30px'>"
        }
        else {
            loTd1.setAttribute("class","driver");
        }
        
        loTd2.innerHTML = psTotal;
        loTd3.innerHTML = psPercent;
        if(parseFloat(psPercent.replace("%","")) >= 90){
            lsColor="#40FF00";
            lsFColor="black";
        } else if(parseFloat(psPercent.replace("%","")) >= 80){
            lsColor="#FFFF00";
            lsFColor="black";
        } else {
            lsColor="red";
            lsFColor="black";
        }
        loTd3.innerHTML = "<div style='position:relative;top:0px;'><div style='position:absolute;top:-20px;width:"+psPercent+";background-color:"+lsColor+"'>&nbsp;</div><div style='color:"+lsFColor+";position:absolute;top:-20px;width:100%;'>"+psPercent+"</div></div>";
        loTd4.innerHTML = psTime;
    };
     this.addHeader = function(){
         var loTable = document.getElementById("tblRep");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        loTr.setAttribute("class", "cout_theader");
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        var loTd4 = loTr.insertCell(loTr.cells.length);
        loTd1.setAttribute("width","45%");
        loTd2.setAttribute("width","10%");
        loTd3.setAttribute("width","25%");
        loTd4.setAttribute("width","10%");
        loTd1.innerHTML="REPARTIDOR";
        loTd2.innerHTML="TOT/T.P";
        loTd3.innerHTML="% EN T.PROMESA";
        loTd4.innerHTML="T. PROM (min)";
     };
     
     this.setImgData = function(){
        var lsBrand = this.getParamValue("brand_id").replace(/^\s+|\s+$/g, '');
        if(lsBrand == "PH"){
            document.getElementById("imgHeader").src = "/smartE3/images/e3/ui/wco/ph.png";
        }
        else if(lsBrand == "KFC"){
            document.getElementById("imgHeader").src = "/smartE3/images/e3/ui/wco/kfc.png";
        }
        else if(lsBrand == "KFCS"){
            document.getElementById("imgHeader").src = "/smartE3/images/e3/ui/wco/kfcs.png";
        }
        else if(lsBrand == "PHE"){
            document.getElementById("imgHeader").src = "/smartE3/images/e3/ui/wco/phe.png";
        }
        startMainTimer();
    }

 }
 