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
    
    moRePrintTimer = setInterval('manageRePrint();', 60000);
    manageRePrint();
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
   this.msStoreName = "";
   this.msStoreId = "";
   this.init = function(){
       this.moOrder = new Hash();
   };
   this.setHour = function(piHour){
       this.miHour = piHour;
   };
   this.getOrderHash = function(){
       return this.moOrder;
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
   this.setStoreName = function(psStoreName){
       
       this.msStoreName = psStoreName;
       this.printStoreName();
   };
   this.printStoreName = function(){
       $("#tdStoreName").html(this.getStoreName());
   }
   this.setStoreId = function(psStoreId){
       this.msStoreId = psStoreId;
   };
   this.getStoreName = function(){
       return this.msStoreName;
   };
   this.getStoreId = function(){
       return this.msStoreId;
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
                loContext.initStoreData();
                adjustZoom(DataUtils.getValidValue(loContext.getParamValue("general_zoom"),DataUtils.getValidValue(location.search.split("adjust=")[1],"100")));
                
            }
            else{
                return false;
            }
        },"text");
    }
    this.initStoreData = function(){
        var loContext = this;
        $.post("/smartE3/DataService",{psQuery:"SELECT store_id,store_member FROM ss_org_cat_store ",psService:"getQueryData",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter()},
        function(psData) {
            psData = psData.replace(/^\s+|\s+$/g, '');
            if (psData != "") {
                loContext.setStoreId(psData.split(DataUtils.getQueryColSpliter())[0]);
                loContext.setStoreName(psData.split(DataUtils.getQueryColSpliter())[1]);
            }
        });
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
        this.validateOrderStatus();
        this.getDBValues();
    };
    this.getDBValues = function(){
         var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry="SELECT short_identifier,value,min_range,max_range FROM op_dbs_cat_coins_section a ";
        lsQry+="LEFT OUTER JOIN op_dbs_section_values b ";
        lsQry+="ON a.section_id = b.section_id AND b.date_id = CURRENT_DATE ";
        lsQry+="WHERE is_printed = '1' ";
        lsQry+="ORDER BY a.section_id";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                var laData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<laData.length;li++){
                    var lsFieldName = laData[li].split(DataUtils.getQueryColSpliter())[0];
                    var lsFieldValue = laData[li].split(DataUtils.getQueryColSpliter())[1];
                    var lsMin = laData[li].split(DataUtils.getQueryColSpliter())[2];
                    var lsMax = laData[li].split(DataUtils.getQueryColSpliter())[3];
                    /*if(lsFieldName == "prod_per")                        
                        loContext.print_gage(lsFieldName,"% PREPARACION < 14(min)",lsFieldValue,0,100,lsMin,"60 de 77");
                    else*/                      
                        loContext.setFieldValue(lsFieldName,lsFieldValue);
                    
                    if(lsMin != lsMax){
                        
                        if(parseFloat(lsMin) <= parseFloat(lsFieldValue.replace("%","").replace("%","")) && parseFloat(lsMax) >= parseFloat(lsFieldValue.replace("%","").replace("%",""))){
                            loContext.setFieldColor(lsFieldName,"value_green");
                            
                        } else {
                            loContext.setFieldColor(lsFieldName,"value_red");
                            
                        }
                            
                    }
                        
                }
            }
            
        );
    }
    this.print_gage = function(psDiv,psTitle,piValue,piMin,piMax,piDisr,psLabel){
       $("#"+psDiv).html("");
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
    };
    this.writeValuetoReg = function(psId,psValue){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry = "UPDATE op_dbs_section_values SET value = '"+psValue+"' WHERE section_id = "+psId+" AND date_id = CURRENT_DATE";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"executeDMLBatch" },
            function(poData) {
                
            });
    };
    this.validateOrderStatus = function(){
        var loContext = this;
        var lsSrc = "/smartE3/ccot/sus/OTService";
         $.post(lsSrc,{psAction:"getStoreDeliveryTime"},
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "")loContext.writeValuetoReg("5",poData);
         });
    };
    this.setFieldValue = function(psFieldName,psFieldValue){
        if(document.getElementById(psFieldName) != null)
            document.getElementById(psFieldName).innerHTML=psFieldValue;
    };
    this.setFieldColor = function(psFieldName,psFieldColor){
        if(document.getElementById(psFieldName) != null){
            $("#"+psFieldName).removeClass("value_red");
            $("#"+psFieldName).removeClass("value_green");
            $("#"+psFieldName).addClass(psFieldColor);
        }
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
 
