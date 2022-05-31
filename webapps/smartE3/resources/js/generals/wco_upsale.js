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
    moRePrintTimer = setInterval('manageRePrint();', 120000);
    
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
   this.msStore = "";
   this.miSeconds = 0;
   this.moOrder = null;
   this.moOrderRemoved = null;
   this.msUrlIntCon="http://192.168.109.70:7072/servlet/generals.servlets.StoreDataService";
   this.upsaleArray=null;
   this.init = function(){
       this.moOrder = new Hash();
       this.moOrderRemoved = new Hash();
       this.getRemoteServiceUrl();
       
   };
   this.getRemoteServiceUrl = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        $.post(lsSrc,{psParam:"appParam_remoteIntranetQueryService",psService:"getXMLParam" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "")loContext.setIntUrl(poData);
                loContext.getStoreData();
            }
        );
    };
   this.getUpsaleConfig = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        this.upsaleArray = new Array();
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:this.getStore(),psServiceToSend:"getPHUpsaleConfig" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != ""){
                    var laData = poData.split(DataUtils.getQueryRowSpliter());
                    for(var li=0;li<laData.length;li++){
                        loContext.upsaleArray.push("'"+laData[li]+"'");
                    }
                }
                manageIntervals();
        });  
       
   };
   this.setHour = function(piHour){
       this.miHour = piHour;
   };
    this.setIntUrl = function(psUrlIntCon){
         this.msUrlIntCon = psUrlIntCon;
     };
    this.getIntUrl = function(){
         return this.msUrlIntCon;
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
        $.post("/smartE3/DataService",{psQuery:"SELECT 'brand_id',company_id,(SELECT store_id FROM ss_org_cat_store) FROM ss_org_cat_company ORDER BY 1 ",psService:"getQueryData",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter()},
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
    };
    this.getStoreData = function(){
         var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQuery="SELECT store_id FROM ss_cat_store";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQuery,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setStore(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.getUpsaleConfig();
                }
            });
    }
    this.setStore = function(psStore){
         this.msStore = psStore;
     };
     this.getStore = function(){
         return this.msStore;
     };
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
        var lsSrc = "/smartE3/DataService";
        var lsQuery = " SELECT emp_code,";
		lsQuery+=" COALESCE(SUM(upsale_flag),0),";
		lsQuery+=" COALESCE(COUNT(sequence_no),0),";
		lsQuery+=" COALESCE(CASE COUNT(sequence_no) WHEN 0 THEN 0 ELSE COALESCE(SUM(upsale_flag),0)*100/COUNT(sequence_no) END,0)";
		lsQuery+=" FROM (";
		lsQuery+=" SELECT sequence_no,RTRIM(a.order_emp_code)||' - '||c.employee_name||' '||c.paternal AS emp_code,CASE WHEN sequence_no IN (";
		lsQuery+=" 	SELECT DISTINCT a.sequence_no";
		lsQuery+=" 	FROM op_sls_ticket_data a";
		lsQuery+=" 	INNER JOIN op_sls_item_data b";
		lsQuery+=" 	ON a.sequence_no = b.sequence_no AND a.order_date = b.order_date";
		lsQuery+=" 	WHERE a.order_date = CURRENT_DATE";
		lsQuery+=" 	AND mnemonic IN ("+this.upsaleArray+")";
		lsQuery+=" ) THEN 1 ELSE 0 END AS upsale_flag";
		lsQuery+=" FROM op_sls_ticket_data a";
		lsQuery+=" INNER JOIN pp_employees b";
		lsQuery+=" ON REPLACE(a.order_emp_code,' ','') = REPLACE(b.sus_id,' ','')";
		lsQuery+=" INNER JOIN (";
		lsQuery+=" SELECT employee_id,employee_name,paternal,maternal FROM ss_cat_emp_sorpi";
		lsQuery+=" UNION";
		lsQuery+=" SELECT employee_id,employee_name,paternal,maternal FROM ss_cat_emp_sarpi)";
		lsQuery+="  c";
		lsQuery+=" ON b.emp_num  = CAST(c.employee_id AS TEXT)";
		lsQuery+=" WHERE order_date IN (CURRENT_DATE)";
		lsQuery+=" AND cancel_status  = ''";
		lsQuery+=" AND rtrim(printed_time,' ') NOT IN ('0','')";
		lsQuery+=" AND rtrim(cashed_time,' ') NOT IN ('0','')";
		lsQuery+=" AND rtrim(served_time,' ') NOT IN ('0','')";
		lsQuery+=" AND rtrim(promise_time,' ') NOT IN ('')";
		lsQuery+=" ) AS gm1";
		lsQuery+=" GROUP BY emp_code";
		lsQuery+=" ORDER BY 4 DESC LIMIT 15;";
        $.post(lsSrc,{psQuery:lsQuery, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                
                var loTable = document.getElementById("tblSug");
                loTable.innerHTML = "";
                loContext.addHeader();
                var maData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<maData.length;li++){
                    var lsDriver = maData[li].split(DataUtils.getQueryColSpliter())[0];
                    var lsPercent = maData[li].split(DataUtils.getQueryColSpliter())[3];
                    var lsTotal = maData[li].split(DataUtils.getQueryColSpliter())[2];
                    var lsTotalTT = maData[li].split(DataUtils.getQueryColSpliter())[1];
                    
                    loContext.printRow(lsDriver,lsPercent+"%",lsTotal+"/"+lsTotalTT);
                        
                }
            }
            
        });
        
        
     };
     this.printRow = function(psDriver,psPercent,psTotal){
        var loTable = document.getElementById("tblSug");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        var lsColor="";
        var lsFColor="";
        if(liId%2 == 0){
            loTr.setAttribute("class","order_label_pair letter_rep");
        } else {
            loTr.setAttribute("class","letter_rep");
        }
        loTr.setAttribute("id",this.msObjId);
        loTd1.setAttribute("width","45%");
        loTd2.setAttribute("width","15%");
        loTd3.setAttribute("width","35%");
        
        loTd1.innerHTML = psDriver;
        loTd1.setAttribute("class","driver");
        if(psDriver == "CLV DE EMP NO ENCONTRADA"){
            loTd1.setAttribute("class","driver value_red");
            loTd1.innerHTML = loTd1.innerHTML+"<img src='/smartE3/images/e3/ui/explorer/alert.gif' width='30px'>"
        }
        else {
            loTd1.setAttribute("class","driver");
        }
        
        loTd2.innerHTML = psTotal;
        loTd3.innerHTML = psPercent;
        if(parseFloat(psPercent.replace("%","")) >= 75){
            lsColor="#40FF00";
            lsFColor="black";
        } else if(parseFloat(psPercent.replace("%","")) >= 60){
            lsColor="#FFFF00";
            lsFColor="black";
        } else {
            lsColor="red";
            lsFColor="black";
        }
        loTd3.innerHTML = "<div style='position:relative;top:0px;'><div style='position:absolute;top:-20px;width:"+psPercent+";background-color:"+lsColor+"'>&nbsp;</div><div style='color:"+lsFColor+";position:absolute;top:-20px;width:100%;'>"+psPercent+"</div></div>";
    };
     this.addHeader = function(){
         var loTable = document.getElementById("tblSug");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        loTr.setAttribute("class", "cout_theader");
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        loTd1.setAttribute("width","45%");
        loTd2.setAttribute("width","15%");
        loTd3.setAttribute("width","35%");
        loTd1.innerHTML="EMPLEADO";
        loTd2.innerHTML="TOT/VTA.SUGES";
        loTd3.innerHTML="% ORDENES";
        
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
 