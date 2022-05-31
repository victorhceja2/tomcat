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
    moRePrintTimer = setInterval('manageRePrint();', 3000);
    
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
        /*var lsQuery = " SELECT order_no,client_name,CEIL(CASE  WHEN EXTRACT(EPOCH FROM (CURRENT_TIME - start_time)) < 0 THEN 0 WHEN EXTRACT(EPOCH FROM (CURRENT_TIME - start_time)) >= 86400 THEN EXTRACT(EPOCH FROM (CURRENT_TIME - start_time)) - 86400 ELSE EXTRACT(EPOCH FROM (CURRENT_TIME - start_time)) END) ";
        lsQuery+="FROM dblink('hostaddr=10.10.10.37 dbname=db_prueba user=postgres','SELECT DISTINCT ON (order_no) order_no ,name, time FROM ordenes WHERE date = CURRENT_DATE')  ";
        lsQuery+="AS t(order_no CHARACTER VARYING(5),client_name CHARACTER VARYING(40),start_time TIME WITHOUT TIME ZONE) ";*/
        var lsQuery = " SELECT order_no,name,CEIL(CASE  WHEN EXTRACT(EPOCH FROM (CURRENT_TIME - time)) < 0 THEN 0 WHEN EXTRACT(EPOCH FROM (CURRENT_TIME - time)) >= 86400 THEN EXTRACT(EPOCH FROM (CURRENT_TIME - time)) - 86400 ELSE EXTRACT(EPOCH FROM (CURRENT_TIME - time)) END) ";
        lsQuery+="FROM (SELECT DISTINCT ON (order_no) order_no ,name, time FROM ordenes WHERE date = CURRENT_DATE) AS gm1  ";
        $.post(lsSrc,{psQuery:lsQuery, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                var maData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<maData.length;li++){
                    var lsOrderId = maData[li].split(DataUtils.getQueryColSpliter())[0];
                    var lsClientName = maData[li].split(DataUtils.getQueryColSpliter())[1];
                    var lsSeconds = maData[li].split(DataUtils.getQueryColSpliter())[2];
                    if(!loContext.getOrderHash().hasItem(lsOrderId) && !loContext.getOrderRemovedHash().hasItem(lsOrderId)){
                        var loOrderLabel = new OrderLabel(lsOrderId,lsClientName,lsSeconds);
                        loContext.moOrder.setItem(loOrderLabel.getOrderId(),loOrderLabel);
                        lbReprint = true;
                    }
                }
                
                if(lbReprint)loContext.printEmployee();
            }
        });
        
        
     };
     this.printEmployee = function(){
         var liTotal = this.getOrderHash().getItems().length;
         if(this.getOrderHash().getItems().length > 0){
            var loTable = document.getElementById("tblOrders");
            if(liTotal > 12)
                liTotal = 12;
            loTable.innerHTML = "";
            this.addHeader();
            for(var li=0;li<liTotal;li++){
                if(typeof this.getOrderHash().getArray()[li] != 'undefined')
                    this.getOrderHash().getArray()[li].printRow();
            }
            
       }
     }
     this.addHeader = function(){
         var loTable = document.getElementById("tblOrders");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        loTr.setAttribute("class", "cout_theader");
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        loTd1.setAttribute("width","30%");
        loTd2.setAttribute("width","30%");
        loTd3.setAttribute("width","30%");
        loTd1.innerHTML="ORDEN";
        loTd2.innerHTML="CLIENTE";
        loTd3.innerHTML="TIEMPO";
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
 
function OrderLabel(psOrderId,psOrderName,piSeconds) {
    this.msOrderId = psOrderId;
    this.msOrderName = psOrderName;
    this.miHour = Math.floor((piSeconds/60/60));
    this.miMinute = Math.floor((parseInt(piSeconds) - parseInt(parseInt(this.miHour)*60*60))/60);
    this.miSeconds = parseInt(piSeconds) - parseInt(parseInt(this.miHour)*60*60) - parseInt(parseInt(this.miMinute)*60);
    this.miTotalSeconds = piSeconds;
    var loContext = this;
    var moOrderTimerInterval;
    var moDispatchInterval;
    var moOrderStatusInterval;
    this.msObjId = "Order_"+this.msOrderId;
    
    
    clearInterval(moOrderTimerInterval);
    clearInterval(moOrderStatusInterval);
    clearInterval(moDispatchInterval);
    moOrderTimerInterval = setInterval(function(){ loContext.changeTime() }, 1000);
    moOrderStatusInterval = setInterval(function(){ loContext.validateOrderStatus() }, 3000);
    
    this.msStatus = 0;
    this.miServedCounter = 0;
    this.validateOrderStatus = function(){
        var lsSrc = "/smartE3/ccot/sus/OTService";
         $.post(lsSrc,{psAction:"getOrderStatus",psTicket:this.msOrderId },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "0" && poData != "")loContext.setStatus(parseInt(poData));
         });
    };
    this.getObjId = function(){
        return this.msObjId;
    };
    this.changeTime = function(){
        this.miSeconds++;
        this.miTotalSeconds++;
        if(parseInt(this.getSecond()) > 59){
            this.miMinute++;
            this.miSeconds=0;
        }
        if(parseInt(this.getMinute()) > 59){
            this.miHour++;
            this.miMinute=0;
        }
        if(parseInt(this.msStatus) < 3){
            if(parseInt(this.miTotalSeconds) >= 900){
                this.setStatus(2);
                $("#"+this.msObjId).addClass("order_label_red");
                $("#"+this.msObjId).removeClass("order_label_yellow");
                $("#"+this.msObjId).removeClass("order_label_green");
            } else if(parseInt(this.miTotalSeconds) >= 780){
                this.setStatus(1);
                $("#"+this.msObjId).addClass("order_label_yellow");
                $("#"+this.msObjId).removeClass("order_label_red");
                $("#"+this.msObjId).removeClass("order_label_green");
            } else {
                this.setStatus(0);
                $("#"+this.msObjId).addClass("order_label_green");
                $("#"+this.msObjId).removeClass("order_label_red");
                $("#"+this.msObjId).removeClass("order_label_yellow");
            }
            
        } else {
            $("#"+this.msObjId).removeClass("order_label_red");
            $("#"+this.msObjId).removeClass("order_label_yellow");
            $("#"+this.msObjId).removeClass("order_label_green");
            
            if(parseInt(this.msStatus) == 3)$("#"+this.msObjId).addClass("order_label_blue");
            if(parseInt(this.msStatus) == 5)$("#"+this.msObjId).addClass("order_label_cancel");
           clearInterval(moOrderTimerInterval);
           clearInterval(moOrderStatusInterval);
           moDispatchInterval = setInterval(function(){ loContext.increaseServedCounter() }, 1000);
        }
        this.updatePrintTime();
    };
    this.getOrderId = function(){
        return this.msOrderId;
    };
    
    this.increaseServedCounter = function(){
        this.miServedCounter++;
        if(parseInt(this.miServedCounter)>10){
            moAppHandler.getOrderRemovedHash().setItem(this.msOrderId,this);
            $("#"+this.msObjId).remove();
            moAppHandler.getOrderHash().removeItem(this.msOrderId);
            $("#"+this.msObjId).remove();
            clearInterval(moDispatchInterval);
            
            moAppHandler.printEmployee();
        } else {
            if(parseInt(this.msStatus) == 3){
                if($("#"+this.msObjId).hasClass("order_label_blue")){
                    $("#"+this.msObjId).removeClass("order_label_blue");
                    $("#"+this.msObjId).addClass("order_label_blue_inverted");
                }
                else{
                    $("#"+this.msObjId).removeClass("order_label_blue_inverted");
                    $("#"+this.msObjId).addClass("order_label_blue");
                }
            } else {
                if($("#"+this.msObjId).hasClass("order_label_cancel")){
                    $("#"+this.msObjId).removeClass("order_label_cancel");
                    $("#"+this.msObjId).addClass("order_label_cancel_inverted");
                }
                else{
                    $("#"+this.msObjId).removeClass("order_label_cancel_inverted");
                    $("#"+this.msObjId).addClass("order_label_cancel");
                }
                
            }
        }
    };
    this.setStatus = function(psStatus){
       this.msStatus = psStatus;
    };
    this.getHour = function(){
       return this.miHour;
    };
    this.getMinute = function(){
       return this.miMinute;
    };
    this.getSecond = function(){
       return this.miSeconds;
    };
    this.getTime = function(){
        if(this.getHour() == 0){
            return ((this.getMinute() < 10)?"0"+this.getMinute():this.getMinute())+":"+
                ((this.getSecond() < 10)?"0"+this.getSecond():this.getSecond());
        } else {
            return ((this.getHour() < 10)?"0"+this.getHour():this.getHour())+":"+
                    ((this.getMinute() < 10)?"0"+this.getMinute():this.getMinute())+":"+
                    ((this.getSecond() < 10)?"0"+this.getSecond():this.getSecond());
        }
    };
    this.updatePrintTime = function(){
      $("#time_"+this.msObjId).html(this.getTime());  
    };
    this.printRow = function(){
        var loTable = document.getElementById("tblOrders");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var loTd2 = loTr.insertCell(loTr.cells.length);
        var loTd3 = loTr.insertCell(loTr.cells.length);
        if(liId%2 == 0){
            loTr.setAttribute("class","order_label_pair");
        }
        loTr.setAttribute("id",this.msObjId);
        loTd1.setAttribute("width","30%");
        loTd2.setAttribute("width","30%");
        loTd3.setAttribute("width","30%");
        loTd1.innerHTML = this.msOrderId;
        loTd2.innerHTML = this.msOrderName;
        loTd3.innerHTML = this.getTime();
        loTd3.setAttribute("id","time_"+this.msObjId);
     
    };
}