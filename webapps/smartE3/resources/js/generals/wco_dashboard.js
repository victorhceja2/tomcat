//////////////////////////////////////////////////////////////////////////////////////
//                                 Generales
/////////////////////////////////////////////////////////////////////////////////////
var moMainTimer = null;
var moHourTimer = null;

function startMainTimer(){
    clearInterval(moMainTimer);
    clearInterval(moHourTimer);
    //manageIntervals();
    manageHourIntervals();
    moAppHandler.getAbsStore();
    moMainTimer = setInterval('manageIntervals();', 3*60000);
    moHourTimer = setInterval('manageHourIntervals();', 60*60000);
}
function setIntitialData(){
    moAppHandler.setImgData();
}
function manageIntervals(){
    moAppHandler.loadData();
}
function manageHourIntervals(){
    moAppHandler.loadHourData();
}

//////////////////////////////////////////////////////////////////////////////////////
//                                 AppHandler
/////////////////////////////////////////////////////////////////////////////////////
function AppHandler() {
   var moParams = null;
   var moDataSet = null;
   var moTicks = null;
   var miSaleAcum = 0;
   var miWSaleAcum = 0;
   var miWTrxAcum = 0;
   var miWFcstSaleAcum = 0;
   var miWFcstTrxAcum = 0;
   var miWFcstResSaleAcum=0;
   var miWFcstResTrxAcum = 0;
   var miHDTotal=0;
   var miAUTOTotal=0;
   var miMOSTTotal=0;
   var msCompany="";
   var msStore="";
   var miJumboMin = 0;
   var miJumboMax = 0;
   var miAgrandaMin = 0;
   var miAgrandaMax = 0;
   var miDeliciaMin = 0;
   var miDeliciaMax = 0;
   
   var msUrlIntCon="http://192.168.109.70:7072/servlet/generals.servlets.StoreDataService";
   var msUrlMasterCon="http://192.168.110.198:8080/smartE3/DataService";
    this.setImgData = function(){
        var lsBrand = this.getParamValue("brand_id").replace(/^\s+|\s+$/g, '')
        document.getElementById("imgHeader").src = "/smartE3/images/e3/ui/dbs/kfc.png";
        startMainTimer();
    };
     this.getParamValue = function(psParamName){
        if(moParams != null)
            return moParams.getItem(psParamName);
        else 
            return "";
    };
     this.loadData = function(){
         this.cleanDataSet();
         this.cleanTicks();
         this.getPeopleData();
         this.getRepData();
         this.getPeopleGraphData();
     };
     this.loadHourData = function(){
         this.getRemoteServiceUrl();
         
     };
     this.getAbsStore = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQuery="SELECT store_id,(SELECT company_id FROM dblink('dbname=dbsec user=postgres','SELECT company_id FROM ss_org_cat_company') AS t(company_id TEXT)) FROM ss_cat_store";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQuery,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    
                    loContext.getAbsData(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.setStore(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.setCompany(poData.split(DataUtils.getQueryColSpliter())[1]);
                    loContext.getRanking();
                }
            });
     };
     this.getRemoteServiceUrl = function(){
         var loContext = this;
         var lsSrc = "/smartE3/DataService";
         $.post(lsSrc,{psParam:"appParam_remoteIntranetQueryService",psService:"getXMLParam" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "")loContext.setIntUrl(poData);
         });
         $.post(lsSrc,{psParam:"appParam_remoteMasterQueryService",psService:"getXMLParam" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != "")loContext.setMasterUrl(poData);
                loContext.getSemis();
         });
     };
     this.getRanking = function(){
       var loContext = this;
       var lsSrc = "/smartE3/DataService";
       var lsUrl = loContext.getMasterUrl();
       var lsQry="";
       lsQry+="SELECT ";
       lsQry+="'<font color=''#01DF01''>'||CAST(rank AS TEXT)||'</font><img src=''/smartE3/images/e3/ui/schedule/'||CASE WHEN rank IN (1,2,3) THEN 'certificate.png' ELSE 'error.png' END ||''' width=''15''/><span '||CASE store_id WHEN "+this.getStore()+" THEN ' style=''background-color:#F2F5A9''' ELSE '' END||'>'||store_desc||' ('|| CAST(CASE WHEN total < 0 THEN 0 ELSE total END AS TEXT) ||')</span><br>', ";
       lsQry+="store_id,store_desc,CASE WHEN total < 0 THEN 0 ELSE total END AS total ,rank  ";
       lsQry+="FROM ( ";
       lsQry+="SELECT a.store_id,store_desc,FLOOR(SUM(total)) AS total,DENSE_RANK() OVER(ORDER BY SUM(total) DESC)  AS rank, ROW_NUMBER() OVER(ORDER BY SUM(total) DESC) AS row_control ";
       lsQry+="FROM op_dbs_coins_earned a ";
       lsQry+="INNER JOIN it_grl_v3_store_control b ";
       lsQry+="ON a.store_id = b.store_id AND brand_id = '"+this.getCompany()+"' ";
       lsQry+="INNER JOIN ss_org_cat_store c ";
       lsQry+="ON a.store_id = c.store_id ";
       lsQry+="WHERE a.date_id = CAST(CURRENT_DATE - INTERVAL '1 day' AS DATE) ";
       lsQry+="GROUP BY a.store_id,store_desc,brand_id ";
       lsQry+=") AS gm1 ";
       lsQry+="WHERE store_id = "+this.getStore()+" ";
       lsQry+="OR row_control IN (1,2,3) ";
       lsQry+="ORDER BY rank LIMIT 4";
       $.post(lsSrc,{psUrl:lsUrl,
                    psConnectionPool: "jdbc/masterStoreDBConnectionPool",
                    psRowSeparator:DataUtils.getQueryRowSpliter(),
                    psColSeparator:DataUtils.getQueryColSpliter(), 
                    psQuery:lsQry,
                    psService:"sendURLRequest",
                    psServiceToSend:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != ""){
                    document.getElementById("tdRank").innerHTML = "";
                    var laData = poData.split(DataUtils.getQueryRowSpliter());
                    for(var li=0;li<laData.length;li++){
                        var lsStore= laData[li].split(DataUtils.getQueryColSpliter())[1];
                        var lsRankData = laData[li].split(DataUtils.getQueryColSpliter())[0];
                        var lsCoins = laData[li].split(DataUtils.getQueryColSpliter())[3];
                        if(lsStore == loContext.getStore()){
                            //document.getElementById("tdCoins").innerHTML='<font size="7px">'+lsCoins +'</font>';
                            document.getElementById("tdRank").innerHTML=document.getElementById("tdRank").innerHTML+"<b><font color=red>&rarr;</font></b>&nbsp;"+lsRankData+"<span>";
                        } else {
                            document.getElementById("tdRank").innerHTML=document.getElementById("tdRank").innerHTML+lsRankData;
                        }
                        
                    }
                }
            });
       
       
         
     };
     this.setCompany = function(psCompany){
         msCompany = psCompany;
     };
     this.getCompany = function(){
         return msCompany;
     };
     this.setStore = function(psStore){
         msStore = psStore;
     };
     this.getStore = function(){
         return msStore;
     };
     this.setIntUrl = function(psUrlIntCon){
         msUrlIntCon = psUrlIntCon;
     };
     this.getIntUrl = function(){
         return msUrlIntCon;
     };
     this.setMasterUrl = function(psUrlMasterCon){
         msUrlMasterCon = psUrlMasterCon;
     };
     this.getMasterUrl = function(){
         return msUrlMasterCon;
     };
     
     this.getAbsData = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getAbsData" },
            function(poData) {
             poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != ""){
                    var loObj= document.getElementById("abs");
                    loObj.innerHTML=poData;
                    if(parseFloat(poData) > 4){
                        loContext.changeRed(loObj);
                    }else{
                        loContext.changeGreen(loObj);
                    }
                    loContext.writeValuetoReg("40",poData);
                }
            });
        
     };
     this.getSemis = function(){
        var loContext = this;
        
        var lsSrc = "/smartE3/DataService";
        var lsQuery="SELECT store_id FROM ss_cat_store";
        $.post(lsSrc,{type: "POST",psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQuery,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.getSemisIdeal(poData);
                    
                }
            });
     };
     this.getSemisData = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getSemisData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    document.getElementById("semis_real").innerHTML = "$"+poData;
                }
                loContext.getWeekSalesAcum(psStore);
            });
     };
     this.getWeekSalesAcum = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getWeekSalesAmount" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setWSalesAcum(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.setWTrxAcum(poData.split(DataUtils.getQueryColSpliter())[1]);
                    loContext.getWeekFcstAcum(psStore);
                }
            });
     };
       this.getWeekFcstAcum = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getWeekFcstAcum" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setWFcstSalesAcum(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.setWFcstTrxAcum(poData.split(DataUtils.getQueryColSpliter())[1]);
                    
                }
                loContext.getWeekResFcstAcum(psStore);
            });
     };
     this.getWeekResFcstAcum = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getWeekResFcstAcum" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setWFcstResSalesAcum(poData.split(DataUtils.getQueryColSpliter())[0]);
                    loContext.setWFcstResTrxAcum(poData.split(DataUtils.getQueryColSpliter())[1]);
                    
                }
                loContext.loadData();
            });
     };
     this.getSemisIdeal = function(psStore){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getSemisIdeal" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setSalesAcum(poData);
                }
                loContext.getSemisData(psStore);
            });
     };
     this.setSalesAcum = function(piValue){
         miSaleAcum = piValue;
     };
     this.getSalesAcum = function(){
         return miSaleAcum;
     };
     this.setWSalesAcum = function(piValue){
         miWSaleAcum = piValue;
     };
     this.getWSalesAcum = function(){
         return miWSaleAcum;
     };
     this.setWFcstSalesAcum = function(piValue){
         miWFcstSaleAcum = piValue;
     };
     this.getWFcstSalesAcum = function(){
         return miWFcstSaleAcum;
     };
     this.setWTrxAcum = function(piValue){
         miWTrxAcum = piValue;
     };
     this.getWTrxAcum = function(){
         return miWTrxAcum;
     };
     this.setWFcstTrxAcum = function(piValue){
         miWFcstTrxAcum = piValue;
     };
     this.getWFcstTrxAcum = function(){
         return miWFcstTrxAcum;
     };
      this.setWFcstResSalesAcum = function(piValue){
         miWFcstResSaleAcum = piValue;
     };
     this.getWFcstResSalesAcum = function(){
         return miWFcstResSaleAcum;
     };
     this.setWFcstResTrxAcum = function(piValue){
         miWFcstResTrxAcum = piValue;
     };
     this.getWFcstResTrxAcum = function(){
         return miWFcstResTrxAcum;
     };
     this.cleanDataSet = function(){
         moDataSet = new Array();
     };
     this.cleanTicks = function(){
         moTicks = new Array();
     };
     this.getDataSet = function(){
         return moDataSet;
     };
     this.addDataSet = function(poValue){
         this.getDataSet().push(poValue);
     };
     this.getTicks = function(){
         return moTicks;
     };
     this.addTicks = function(poValue){
         this.getTicks().push(poValue);
     };
     this.getPeopleData = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND (position_name NOT LIKE '%REPARTIDOR%' AND position_name NOT LIKE '%REPARTO%' AND position_name NOT LIKE '%DOMICILIO%')"+
        " AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ),0),"+
        " COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.employee_id IN (SELECT employee_id FROM op_esp_vw_cat_employee UNION SELECT -9999)"+
        " AND a.station_id NOT IN (SELECT station_id FROM op_esp_cat_station WHERE station_desc LIKE '%REPARTIDOR%')"+
        " AND a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                       var liBio = poData.split(DataUtils.getQueryColSpliter())[0];
                       var liPlan = poData.split(DataUtils.getQueryColSpliter())[1];
                       
                       loContext.setPosRealTd(liBio);
                       loContext.setPosIdealValue(liPlan);
                       loContext.setPosDifValue(liBio-liPlan);
                       loContext.validateScheduleRealiced();
                   }
               });
    
    };
    this.validateScheduleRealiced = function(){
       var loContext = this;
       var lsSrc = "/smartE3/DataService";
       var lsQry=" SELECT COALESCE((SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " WHERE a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                       if(poData == "0"){
                           $("#divWarn").css({"position":"absolute","top":"0px","background": "url('../../../../images/e3/ui/dbs/schd_not.png') 50% no-repeat","background-size":"contain","width":"95%","height":"100%"});
                           $("#divWarn").show();
                       }else{
                           $("#divWarn").hide();
                       }
                           
                   }
               }
         );
                   
    };
    this.getRepData = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND (position_name LIKE '%REPARTIDOR%' OR position_name LIKE '%REPARTO%' OR position_name LIKE '%DOMICILIO%')"+
        " AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ),0),"+
        " COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.employee_id IN (SELECT employee_id FROM op_esp_vw_cat_employee UNION SELECT -9999)"+
        " AND a.station_id IN (SELECT station_id FROM op_esp_cat_station WHERE station_desc LIKE '%REPARTIDOR%')"+
        " AND a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                       var liBio = poData.split(DataUtils.getQueryColSpliter())[0];
                       var liPlan = poData.split(DataUtils.getQueryColSpliter())[1];
                       loContext.setRepRealTd(liBio);
                       loContext.setRepIdealValue(liPlan);
                       loContext.setRepDifValue(liBio-liPlan);
                       loContext.getProdValue(liBio,liPlan);
                   }
                   loContext.getCashData();
               });
    
    };
    this.getCashData = function(){
          var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND (emp_num IN (SELECT CAST(employee_id AS VARCHAR) FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE CAST(date_id AS DATE) = CURRENT_DATE AND station_id  IN (SELECT station_id FROM op_esp_cat_station WHERE station_desc LIKE '%CAJERO%') AND value > 0"+
        " AND to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END)"+
        " ) AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ),0),"+
        " COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.employee_id IN (SELECT employee_id FROM op_esp_vw_cat_employee UNION SELECT -9999)"+
        " AND a.station_id IN (SELECT station_id FROM op_esp_cat_station WHERE station_desc LIKE '%CAJERO%')"+
        " AND a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                       var liBio = poData.split(DataUtils.getQueryColSpliter())[0];
                       var liPlan = poData.split(DataUtils.getQueryColSpliter())[1];
                       loContext.setCashRealTd(liBio);
                       loContext.setCashIdealValue(liPlan);
                       loContext.setCashDifValue(liBio-liPlan);
                       loContext.getTrainData();
                   }
               });
    };
    this.getTrainData = function(){
          var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND (emp_num IN (SELECT CAST(employee_id AS VARCHAR) FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE CAST(date_id AS DATE) = CURRENT_DATE AND value > 0"+
        " AND CAST(employee_id AS TEXT)||'_'||CAST(station_id AS TEXT) IN (SELECT CAST(employee_id AS TEXT)||'_'||CAST(station_id AS TEXT) FROM op_esp_employee_certification WHERE change_date IS NOT NULL AND change_date > CURRENT_DATE AND level = 10) "+
        " AND to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END)"+
        " ) AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ),0),"+
        " COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.employee_id IN (SELECT employee_id FROM op_esp_vw_cat_employee UNION SELECT -9999)"+
        " AND CAST(a.employee_id AS TEXT)||'_'||CAST(station_id AS TEXT) IN (SELECT CAST(employee_id AS TEXT)||'_'||CAST(station_id AS TEXT) FROM op_esp_employee_certification WHERE change_date IS NOT NULL AND change_date > CURRENT_DATE  AND level = 10) "+
        " AND a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                       var liBio = poData.split(DataUtils.getQueryColSpliter())[0];
                       var liPlan = poData.split(DataUtils.getQueryColSpliter())[1];
                       loContext.setFieldValue("tdEmpRealTrain",liBio);
                       loContext.setFieldValue("tdEmpIdealTrain",liPlan);
                       
                   }
               });
    };
    
    this.getProdValue = function(piBio,piPlan){
        
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE((SELECT value FROM op_esp_src_data WHERE date_id = CURRENT_DATE AND src_name = 'TX TOT' AND hour_id = DATE_PART('hour',CURRENT_TIME)),0)"
         $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                 if(poData != ""){
                     loContext.getProdIdTd().innerHTML = ((piPlan+parseFloat(loContext.getPosIdealTd().innerHTML))==0)?0:(poData/(piPlan+parseFloat(loContext.getPosIdealTd().innerHTML))).toFixed(2);
                     loContext.getProdRealTd().innerHTML = ((piBio+parseFloat(loContext.getPosRealTd().innerHTML))==0)?0:(poData/(piBio+parseFloat(loContext.getPosRealTd().innerHTML))).toFixed(2);
                     //var liDif = parseFloat(loContext.getProdRealTd().innerHTML) - parseFloat(loContext.getProdIdTd().innerHTML);
                     //loContext.getProdDifTd().innerHTML= (liDif).toFixed(2);
                     //if(liDif != 0){
                       //loContext.changeRed(loContext.getProdDifTd());
                     //}else{
                        //loContext.changeGreen(loContext.getProdDifTd());
                    //}
                 }
            });
    }
    this.setPosIdealValue = function(piValue){
        this.getPosIdealTd().innerHTML=piValue;
    };
    this.setPosRealTd = function(piValue){
        this.getPosRealTd().innerHTML=piValue;
    };
    this.setPosDifValue = function(piValue){
      var loObj = this.getPosDifTd();
      loObj.innerHTML=piValue;
      if(piValue != 0){
          this.changeRed(loObj);
      }else{
          this.changeGreen(loObj);
      }
    };
    this.getPosIdealTd = function(){
        return document.getElementById("tdPosIdeal");
    };
    this.getPosRealTd = function(){
        return document.getElementById("tdPosReal");
    };
    this.getPosDifTd = function(){
        return document.getElementById("tdPosDif");
    };
    this.getCashIdealTd = function(){
        return document.getElementById("tdCashIdeal");
    };
    this.getCashRealTd = function(){
        return document.getElementById("tdCashReal");
    };
    this.getCashDifTd = function(){
        return document.getElementById("tdCashDif");
    };
    this.getProdIdTd = function(){
        return document.getElementById("tdProdIdeal");
    };
    this.getProdRealTd = function(){
        return document.getElementById("tdProdReal");
    };
    this.getProdDifTd = function(){
        return document.getElementById("tdProdDif");
    };
    this.getAgranda = function(){
        return document.getElementById("agranda");
    };
    this.getJumbo = function(){
        return document.getElementById("jumbo");
    };
    this.getDelicia = function(){
        return document.getElementById("delicia");
    };
     this.setCashIdealValue = function(piValue){
        this.getCashIdealTd().innerHTML=piValue;
    };
    this.setCashRealTd = function(piValue){
        this.getCashRealTd().innerHTML=piValue;
    };
    this.setCashDifValue = function(piValue){
      var loObj = this.getCashDifTd();
      loObj.innerHTML=piValue;
      if(piValue != 0){
          this.changeRed(loObj);
      }else{
          this.changeGreen(loObj);
      }
    };
    this.setRepIdealValue = function(piValue){
        this.getRepIdealTd().innerHTML=piValue;
    };
    this.setRepRealTd = function(piValue){
        this.getRepRealTd().innerHTML=piValue;
    };
    this.setRepDifValue = function(piValue){
      var loObj = this.getRepDifTd();
      loObj.innerHTML=piValue;
      if(piValue != 0){
          this.changeRed(loObj);
      }else{
          this.changeGreen(loObj);
      }
    };
    this.setHDTotal = function(piValue){
        miHDTotal = piValue;
    };
    this.getHDTotal = function(){
        return miHDTotal;
    };
    this.setAUTOTotal = function(piValue){
        miAUTOTotal = piValue;
    };
    this.getAUTOTotal = function(){
        return miAUTOTotal;
    };
    this.setMOSTTotal = function(piValue){
        miMOSTTotal = piValue;
    };
    this.getMOSTTotal = function(){
        return miMOSTTotal;
    };
    this.getRepIdealTd = function(){
        return document.getElementById("tdRepIdeal");
    };
    this.getRepRealTd = function(){
        return document.getElementById("tdRepReal");
    };
    this.getRepDifTd = function(){
        return document.getElementById("tdRepDif");
    };
    this.changeRed = function(poObj){
        poObj.setAttribute("class","redvalue");
    };
    this.changeGreen = function(poObj){
        poObj.setAttribute("class","greenvalue");
    };
    this.getPeopleGraphDiv = function(){
        return document.getElementById("divGraph");
    };
    this.getPeopleGraphData = function(){
         var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT year_no,week_no,"+
        "CASE COALESCE(SUM(value),0)*(CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN 1 ELSE 0.5 END) WHEN 0 THEN 0 ELSE COALESCE((SELECT SUM(without_icecream) FROM op_mdw_trx_data WHERE CAST(date_id AS DATE) IN (SELECT CAST(date_id AS DATE) FROM ss_cat_time WHERE year_no = a.year_no AND week_no = a.week_no)),0)/(COALESCE(SUM(value),0)*(CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN 1 ELSE 0.5 END)) END "+
        "FROM ss_cat_time a "+
        "LEFT OUTER JOIN op_esp_employee_time_table b "+
        "ON a.date_id = b.date_id WHERE "+
        "CAST(year_no AS TEXT)||CAST(week_no AS TEXT) IN ( "+
        //"SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE  "+
        //"UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '7 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '14 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '21 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '27 day' "+
        ") ";
        
        lsQry+="AND station_id IN (SELECT station_id FROM op_esp_cat_station WHERE brand_id = '"+this.getCompany()+"') ";
        
        lsQry+="GROUP BY year_no,week_no ";
        lsQry+="ORDER BY 1,2;";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                    var laData = poData.split(DataUtils.getQueryRowSpliter());
                    var laDataArray = new Array();
                    for(var li=0;li<laData.length;li++){
                        var lsYear= laData[li].split(DataUtils.getQueryColSpliter())[0];
                        var lsWeek= laData[li].split(DataUtils.getQueryColSpliter())[1];
                        var lsValue= laData[li].split(DataUtils.getQueryColSpliter())[2];
                        laDataArray.push([lsYear+'-'+lsWeek,lsValue]);
                        loContext.addTicks([li,lsYear+'-'+lsWeek]);
                        if(li==(laData.length-1))loContext.setFieldValue("tpph_id_last_week",parseFloat(lsValue).toFixed(2));
                    }
                    loContext.addDataSet({ id:"IDEAL", label: "TPHH IDEAL", data: laDataArray, lines: { show: true },points: { symbol: "circle" },dashes:{show:true}, color: "green" });
                    
                   }
                   loContext.getRealGraphData();
               });
        
        
        var laSaleRanData = [['YTD',10948233.39],['45',206408.33],['46',267738.57],['47',214424.28],['48',247578.64],];
        var laSaleData = [['YTD',9834772.22],['45',193748.16],['46',250149.40],['47',193261.32],['48',238182.57],];
        var loSaleTicks = [['0','YTD'],['1','45'],['2','46'],['3','47'],['4','48'],];
        var loSaleDataSet = [
		
                { id:"REAL", label: "HORAS REALESREAL", data: laSaleRanData, lines: { show: true },points: { symbol: "square" },dashes:{show:true}, color: "blue" }
	];
     this.printPeopleGraphData(this.getPeopleGraphDiv().id,loSaleDataSet,null,"#FAFAFA",loSaleTicks);   
    };
    this.getRealGraphData = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT year_no,week_no,"+
        "CASE SUM(ISNULL(DATE_PART('hour', timeout1 - timein1),0)+ISNULL(DATE_PART('hour', timeout2 - timein2),0)) WHEN 0 THEN 0 ELSE COALESCE((SELECT SUM(without_icecream) FROM op_mdw_trx_data WHERE CAST(date_id AS DATE) IN (SELECT CAST(date_id AS DATE) FROM ss_cat_time WHERE year_no = b.year_no AND week_no = b.week_no)),0)/SUM(ISNULL(DATE_PART('hour', timeout1 - timein1),0)+ISNULL(DATE_PART('hour', timeout2 - timein2),0)) END "+
        "FROM op_esp_vw_cat_employee c "+
        "INNER JOIN pp_emp_check f "+
        "ON CAST(c.employee_id AS TEXT) = f.emp_num "+
        "INNER JOIN ss_cat_time b "+
        "ON f.date_id = b.date_id AND "+
        "CAST(year_no AS TEXT)||CAST(week_no AS TEXT) IN ( "+
        //"SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE  "+
        //"UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '7 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '14 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '21 day' "+
        "UNION "+
        "SELECT CAST(year_no AS TEXT)||CAST(week_no AS TEXT) FROM ss_cat_time WHERE date_id = CURRENT_DATE - INTERVAL '27 day' "+
        ") ";
        if(this.getCompany() == "KFC" || this.getCompany() == "FKFC" ){
             lsQry+="AND employee_id IN ( SELECT employee_id FROM op_esp_employee_time_table WHERE station_id IN (2,4,5,6,8,9,11,12,13,14,16,17,18)) ";
        } else if(this.getCompany() == "COKFC"){
            lsQry+="AND employee_id IN ( SELECT employee_id FROM op_esp_employee_time_table WHERE station_id IN (7,2,28,29,5,27,3,1)) ";
        }
        lsQry+="GROUP BY year_no,week_no ";
        lsQry+="ORDER BY 1,2;";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '')
                   if(poData != ""){
                    var laData = poData.split(DataUtils.getQueryRowSpliter());
                    var laDataArray = new Array();
                    for(var li=0;li<laData.length;li++){
                        var lsYear= laData[li].split(DataUtils.getQueryColSpliter())[0];
                        var lsWeek= laData[li].split(DataUtils.getQueryColSpliter())[1];
                        var lsValue= laData[li].split(DataUtils.getQueryColSpliter())[2];
                        laDataArray.push([lsYear+'-'+lsWeek,lsValue]);
                        if(li==(laData.length-1))loContext.setFieldValue("tpph_re_last_week",parseFloat(lsValue).toFixed(2));
                        //loContext.addTicks([li,lsYear+'-'+lsWeek]);
                    }
                    loContext.addDataSet({ id:"REAL", label: "TPHH REAL", data: laDataArray, lines: { show: true },points: { symbol: "square" },dashes:{show:true}, color: "blue" });
                   }
                   loContext.printPeopleGraphData(loContext.getPeopleGraphDiv().id,loContext.getDataSet(),null,"#FAFAFA",loContext.getTicks());   
                   loContext.getAllMixedData();
               });
     
    };
    
    this.printPeopleGraphData = function (psDiv,poSaleDataSet,poMarkings,psBgColor,poTicks){
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
                            font: '8pt Arial',
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
            yaxis:{
                max:5,
                min:1,
                ticks:[[1,1],[1.5,1.5],[2,2],[2.5,2.5],[3,3],[3.5,3.5],[4,4],[4.5,4.5],[5,5]]
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
         		$("#tooltip").html(item.series.label + " " + (item.series.data[parseInt(x)])[0] + " = " + y)
                 	.css({top: item.pageY+5, left: item.pageX+5})
			.fadeIn(200);
                } else {
			$("#tooltip").hide();
                }
            
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
    this.getAllMixedData = function(){
        var loContext = this;
        loContext.setRanges();
        var lsSrc = "/smartE3/DataService";
        var lsQry="SELECT short_identifier,value FROM op_dbs_cat_coins_section a ";
        lsQry+="LEFT OUTER JOIN op_dbs_section_values b ";
        lsQry+="ON a.section_id = b.section_id AND b.date_id = CURRENT_DATE ";
        lsQry+="WHERE is_printed = '1' ";
        lsQry+="ORDER BY a.section_id";
        
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                var laData = poData.split(DataUtils.getQueryRowSpliter());
                var liJumboMin = loContext.getJumboMin();
                var liJumboMax = loContext.getJumboMax();
                var liAgrandaMin = loContext.getAgrandaMin();
                var liAgrandaMax = loContext.getAgrandaMax();
                var liDeliciaMin = loContext.getDeliciaMin();
                var liDeliciaMax = loContext.getDeliciaMax();
                for(var li=0;li<laData.length;li++){
                    var lsFieldName = laData[li].split(DataUtils.getQueryColSpliter())[0];
                    var lsFieldValue = laData[li].split(DataUtils.getQueryColSpliter())[1];
                    
                    if(lsFieldName == "hd")                        
                        loContext.printHDGage(lsFieldValue);
                    else if(lsFieldName == "auto")                        
                        loContext.printAUTOGage(lsFieldValue);
                    else if(lsFieldName == "most")                       
                        loContext.printMOSTGage(lsFieldValue);
                    else if(lsFieldName == "cook_mon_type" && lsFieldValue == "ALOHA")                       
                        loContext.getAlohaStore();
                    else if(lsFieldName == "cook_mon_type" && lsFieldValue == "KVS")                       
                        loContext.setKVSData();
                    else if(lsFieldName == "cook_mon_type" && lsFieldValue == "PKDS")                       
                        continue;
                    else if(lsFieldName == "cook_mon_type"){                       
                        continue;
                    }
                    else if(lsFieldName == "missing")                        
                        loContext.setFieldValue(lsFieldName,(lsFieldValue>0)?0:lsFieldValue);
                    else if(lsFieldName == "sales"){     
                        //lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWSalesAcum())+parseFloat(loContext.getWFcstResSalesAcum());
                        lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWSalesAcum());
                        loContext.setFieldValue(lsFieldName,(lsFieldValue<0)?"$0":"$"+lsFieldValue);
                        
                    }
                    else if(lsFieldName == "trx"){                        
                        //lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWTrxAcum())+parseFloat(loContext.getWFcstResTrxAcum());
                        lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWTrxAcum());
                        loContext.setFieldValue(lsFieldName,(lsFieldValue<0)?0:lsFieldValue);
                    }
                    else if(lsFieldName == "sales_py"){     
                        //lsFieldValue=parseFloat(lsFieldValue);
                        //lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWFcstSalesAcum());
                        lsFieldValue=parseFloat(loContext.getWFcstSalesAcum());
                        loContext.setFieldValue(lsFieldName,(lsFieldValue<0)?"$0":"$"+lsFieldValue);
                    }
                    else if(lsFieldName == "trx_py"){
                        //lsFieldValue=parseFloat(lsFieldValue);
                        //lsFieldValue=parseFloat(lsFieldValue)+parseFloat(loContext.getWFcstTrxAcum());
                        lsFieldValue=parseFloat(loContext.getWFcstTrxAcum());
                        loContext.setFieldValue(lsFieldName,(lsFieldValue<0)?0:lsFieldValue);
                    }
                    else if(lsFieldName == "hd_tot"){
                        loContext.setHDTotal(lsFieldValue);
                    } 
                    else if(lsFieldName == "auto_tot"){
                        loContext.setAUTOTotal(lsFieldValue);
                    } 
                    else if(lsFieldName == "most_tot"){
                        loContext.setMOSTTotal(lsFieldValue);
                    } 
                    else if(lsFieldName == "tdProdDif"){
                        
                        if(parseFloat(lsFieldValue) > 0){
                            lsFieldValue = parseFloat(lsFieldValue)*24; 
                            loContext.setFieldValue(lsFieldName,"$"+lsFieldValue);
                            loContext.changeRed(loContext.getProdDifTd());
                        }
                        else{
                            loContext.setFieldValue(lsFieldName,"$0");
                            loContext.changeGreen(loContext.getProdDifTd());
                        }
                    }
                    else if(lsFieldName == "jumbo"){
                        if(parseInt(lsFieldValue) >= liJumboMin && parseInt(lsFieldValue) <= liJumboMax)
                            loContext.changeGreen(loContext.getJumbo());
                        else
                            loContext.changeRed(loContext.getJumbo());
                        loContext.setFieldValue(lsFieldName, lsFieldValue);
                    }
                    else if(lsFieldName == "agranda"){
                        if(parseInt(lsFieldValue) >= liAgrandaMin && parseInt(lsFieldValue) <= liAgrandaMax)
                            loContext.changeGreen(loContext.getAgranda());
                        else
                            loContext.changeRed(loContext.getAgranda());
                        loContext.setFieldValue(lsFieldName, lsFieldValue);
                    }
                    else if(lsFieldName == "delicia"){
                        if(parseInt(lsFieldValue) >= liDeliciaMin && parseInt(lsFieldValue) <= liDeliciaMax)
                            loContext.changeGreen(loContext.getDelicia());
                        else
                            loContext.changeRed(loContext.getDelicia());
                        loContext.setFieldValue(lsFieldName, lsFieldValue);
                    }
                    else{
                        loContext.setFieldValue(lsFieldName,lsFieldValue);
                    }
                }
                loContext.operateValues();
            }
            
        );
    };
    
    this.setRanges = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var liAgMin;
        var liAgMax;
        var liJumMin;
        var liJumMax;
        var liDelMin;
        var liDelMax;
        
        var lsQry = "SELECT  gm1.min_range AS jb_min, gm1.max_range AS jb_max, ";
            lsQry += "gm2.min_range AS del_min, gm2.max_range AS del_max, ";
            lsQry += "gm3.min_range AS ag_min, gm3.max_range AS ag_max ";
            lsQry += "FROM( ";
            lsQry += "  SELECT 1 AS id, min_range, max_range ";
            lsQry += "  FROM op_dbs_cat_coins_section ";
            lsQry += "  WHERE section_id = 6 "; // Jumbos
            lsQry += ") gm1 ";
            lsQry += "JOIN ( ";
            lsQry += "  SELECT 1 AS id, min_range, max_range ";
            lsQry += "  FROM op_dbs_cat_coins_section ";
            lsQry += "  WHERE section_id = 8 "; // Delicias
            lsQry += ") gm2 ON (gm1.id = gm2.id) ";
            lsQry += "JOIN ( ";
            lsQry += "  SELECT 1 AS id, min_range, max_range ";
            lsQry += "  FROM op_dbs_cat_coins_section ";
            lsQry += "  WHERE section_id = 7 "; // Agrandas
            lsQry += "  ) gm3 ON (gm2.id = gm3.id)";
            
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData" },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '');
                   var laData = poData.split(DataUtils.getQueryRowSpliter());
                   
                   liJumMin = laData[0].split(DataUtils.getQueryColSpliter())[0];
                   liJumMax = laData[0].split(DataUtils.getQueryColSpliter())[1];
                   liDelMin = laData[0].split(DataUtils.getQueryColSpliter())[2];
                   liDelMax = laData[0].split(DataUtils.getQueryColSpliter())[3];
                   liAgMin = laData[0].split(DataUtils.getQueryColSpliter())[4];
                   liAgMax = laData[0].split(DataUtils.getQueryColSpliter())[5];
                   
                   loContext.setJumboMin(liJumMin);
                   loContext.setJumboMax(liJumMax);
                   loContext.setAgrandaMin(liAgMin);
                   loContext.setAgrandaMax(liAgMax);
                   loContext.setDeliciaMin(liDelMin);
                   loContext.setDeliciaMax(liDelMax);
               }
         );
    };
    this.setJumboMin = function(psValue){
        miJumboMin = psValue;
    }
    this.setJumboMax = function(psValue){
        miJumboMax = psValue;
    }
    this.setAgrandaMin = function(psValue){
        miAgrandaMin = psValue;
    }
    this.setAgrandaMax = function(psValue){
        miAgrandaMax = psValue;
    }
    this.setDeliciaMin = function(psValue){
        miDeliciaMin = psValue;
    }
    this.setDeliciaMax = function(psValue){
        miDeliciaMax = psValue;
    }
    this.getJumboMin = function(){
        return miJumboMin;
    }
    this.getJumboMax = function(){
        return miJumboMax;
    }
    this.getAgrandaMin = function(){
        return miAgrandaMin;
    }
    this.getAgrandaMax = function(){
        return miAgrandaMax;
    }
    this.getDeliciaMin = function(){
        return miDeliciaMin;
    }
    this.getDeliciaMax = function(){
        return miDeliciaMax;
    }
    this.printHDGage = function(psValue){
        this.setFieldValue("hd","");
        print_gage("hd","HD<30min",psValue,0,100,94,this.getHDTotal());
    };
    this.printAUTOGage = function(psValue){
        this.setFieldValue("auto","");
        print_gage("auto","AUTO<2:30min",parseFloat(psValue),0,100,89,this.getAUTOTotal());
    };
    this.printMOSTGage = function(psValue){
        this.setFieldValue("most","");
        print_gage("most","MOST<2:30min",parseFloat(psValue),0,100,89,this.getMOSTTotal());
        this.writeValuetoReg("12",psValue);
    };
    this.setEfRange = function(poObj){
        if(parseFloat(poObj.innerHTML.replace("%","")) > 103 || parseFloat(poObj.innerHTML.replace("%","")) < 97){
            this.changeRed(poObj);
        }
        else{
            this.changeGreen(poObj);
        }
    }
    this.hideValue = function(psObjId){
        $('#'+psObjId).hide();
        $('#'+psObjId+"_label").hide();
    };
    this.operateValues = function(){
        
        document.getElementById("semis_ideal").innerHTML = "$"+(((parseFloat(this.getSalesAcum())+parseFloat(document.getElementById("sales").innerHTML.replace("$","")))*0.032).toFixed(2)).toString();
        var loTrxObj = document.getElementById("trx_dif");
        var loSaleObj = document.getElementById("sales_dif");
        var loSaleResObj = document.getElementById("sales_res");
        var loSemiObj = document.getElementById("semis_dif");
        var loEmpMeal = document.getElementById("empl_meal");
        var loHeadEf = document.getElementById("head_ef");
        var loBgEf = document.getElementById("bgcrunch_ef");
        var loSupEf = document.getElementById("supr_ef");
        var loFavEf = document.getElementById("fav_ef");
        var loBisEf = document.getElementById("biscuit_ef");
        var loTenEf = document.getElementById("tender_ef");
        var loSaladEf = document.getElementById("salad_ef");
        var loDressEf = document.getElementById("dress_ef");
        var loMashEf = document.getElementById("mash_ef");
        if(this.getCompany() == "KFC" || this.getCompany() == "KFCS" || this.getCompany() == "FKFC"){
            this.hideValue(loSaladEf.id);
            this.hideValue(loDressEf.id);
            this.hideValue(loMashEf.id);
        } else if(this.getCompany() == "COKFC"){
            this.hideValue(loBgEf.id);
            this.hideValue(loSupEf.id);
            this.hideValue(loFavEf.id);
            this.hideValue(loTenEf.id);
        }
        this.setEfRange(loHeadEf);
        this.setEfRange(loBgEf);
        this.setEfRange(loSupEf);
        this.setEfRange(loFavEf);
        this.setEfRange(loBisEf);
        this.setEfRange(loTenEf);
        this.setEfRange(loSaladEf);
        this.setEfRange(loDressEf);
        this.setEfRange(loMashEf);
        
        //var liTrxDif = parseInt(document.getElementById("trx").innerHTML)-parseInt(document.getElementById("trx_py").innerHTML);
        var liTrxDif = (parseFloat(parseFloat(document.getElementById("trx").innerHTML)+parseFloat(this.getWFcstResTrxAcum()))*100/(parseFloat(document.getElementById("trx_py").innerHTML))).toFixed(2);
        
        //var liSaleDif = "$"+(parseInt(document.getElementById("sales").innerHTML.replace("$",""))-parseInt(document.getElementById("sales_py").innerHTML.replace("$",""))).toString();
        var liSaleDif = (parseFloat(parseFloat(document.getElementById("sales").innerHTML.replace("$",""))+parseFloat(this.getWFcstResSalesAcum()))*100/(parseFloat(document.getElementById("sales_py").innerHTML.replace("$","")))).toFixed(2);
        if(parseFloat(document.getElementById("sales_py").innerHTML.replace("$","")) == 0) {liSaleDif=100;liTrxDif=100;}
        var liSemiDif = (parseInt(document.getElementById("semis_ideal").innerHTML.replace("$",""))-parseInt(document.getElementById("semis_real").innerHTML.replace("$",""))).toString();
        loSaleResObj.innerHTML = "$"+((parseFloat(document.getElementById("sales").innerHTML.replace("$",""))-parseFloat(document.getElementById("sales_py").innerHTML.replace("$",""))).toFixed(2)).toString();
        if(liTrxDif < 100)
            this.changeRed(loTrxObj);
        else
            this.changeGreen(loTrxObj);
        if(liSaleDif < 100)
            this.changeRed(loSaleObj);
        else
            this.changeGreen(loSaleObj);
         if(parseFloat(liSemiDif.replace("$","")) < 0)
            this.changeRed(loSemiObj);
        else
            this.changeGreen(loSemiObj);
        loTrxObj.innerHTML = liTrxDif+"%";
        loSaleObj.innerHTML = liSaleDif+"%";
        loSemiObj.innerHTML = "$"+liSemiDif;
        if(parseInt(loEmpMeal.innerHTML.split("/")[0]) > parseInt(loEmpMeal.innerHTML.split("/")[1]))
            this.changeRed(loEmpMeal);
        else
            this.changeGreen(loEmpMeal);
        
        this.writeValuetoReg("41",liSaleDif);
        this.writeValuetoReg("42",liTrxDif);
        this.writeValuetoReg("43",liSemiDif);
        this.getCoins();
        
    };
    this.setFieldValue = function(psFieldName,psFieldValue){
        if(document.getElementById(psFieldName) != null)
            document.getElementById(psFieldName).innerHTML=psFieldValue;
    };
     this.getAlohaStore = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQuery="SELECT store_id FROM ss_cat_store";
        $.post(lsSrc,{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQuery,psService:"getQueryData" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '')
                if(poData != ""){
                    loContext.setAlohaData(poData);
                }
            });
     };
    this.getCoins = function(){
        var loContext = this;
        var lsQry=""; 
        lsQry+="SELECT CASE WHEN SUM(CASE WHEN CAST(REPLACE(value,'%','') AS NUMERIC) BETWEEN min_range AND max_range THEN coins_amount ELSE substract_amount*(-1) END) < 0 THEN 0 ELSE FLOOR(SUM(CASE WHEN CAST(REPLACE(value,'%','') AS NUMERIC) BETWEEN min_range AND max_range THEN coins_amount ELSE substract_amount*(-1) END)) END AS calculated_value ";
	lsQry+="FROM op_dbs_section_values a ";
	lsQry+="INNER JOIN op_dbs_cat_coins_section b ";
	lsQry+="ON a.section_id= b.section_id ";
	lsQry+="WHERE is_evaluable = '1' ";
	lsQry+="AND periodicity IN  ('D','W','P') ";
	lsQry+="AND value <> '' ";
	lsQry+="AND a.date_id = CURRENT_DATE-INTERVAL '0 day' ";
	lsQry+="AND  ";
	lsQry+="( ";
		lsQry+="(periodicity = 'D') OR ";
		lsQry+="(periodicity = 'W' AND CURRENT_DATE-INTERVAL '0 day' IN ( ";
			lsQry+="SELECT CAST(MAX(date_id) AS DATE)  FROM ss_cat_time  ";
			lsQry+="WHERE year_no||'|'||week_no IN ( ";
				lsQry+="SELECT year_no||'|'||week_no FROM ss_cat_time  ";
				lsQry+="WHERE date_id = CURRENT_DATE-INTERVAL '0 day' ";
			lsQry+=") ";
		lsQry+=")) OR ";
		lsQry+="(periodicity = 'P' AND CURRENT_DATE-INTERVAL '0 day' IN ( ";
			lsQry+="SELECT CAST(MAX(date_id) AS DATE)  FROM ss_cat_time  ";
			lsQry+="WHERE year_no||'|'||period_no IN ( ";
				lsQry+="SELECT year_no||'|'||period_no FROM ss_cat_time  ";
				lsQry+="WHERE date_id = CURRENT_DATE-INTERVAL '0 day' ";
			lsQry+=") ";
		lsQry+="))  ";
	lsQry+=")";
        $.post("/smartE3/DataService",{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData"},
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '')
            if(poData != ""){
                document.getElementById("tdCoins").innerHTML='<font size="7px">'+poData+'</font>';
            }
          });
         
    };
    this.setAlohaData = function(psStore){
        var loContext = this;
        var lsQry="";
        
        var lsSrc = "/smartE3/DataService";
        var lsUrl = loContext.getIntUrl();
        $.post(lsSrc,{psService:"sendURLRequest",psUrl:lsUrl,psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psStore:psStore,psServiceToSend:"getAlohaData" },
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                    loContext.setMOSTTotal(poData.split(DataUtils.getQueryColSpliter())[1]);
                    loContext.printMOSTGage(poData.split(DataUtils.getQueryColSpliter())[0]);
                }
            else{
                    loContext.setMOSTTotal(0);
                    loContext.printMOSTGage(0);
                }
	},"text");
    }
    this.setKVSData = function(){
        var loContext = this;
        var lsQry="";
        lsQry+="SELECT under1*100/total_tickets,total_tickets FROM ( ";
            lsQry+="SELECT under1 ";
            lsQry+="- COALESCE( ";
            lsQry+="( ";
            lsQry+="SELECT under1 FROM op_kvs_timetable a ";
            lsQry+="WHERE idtime_transaction IN (  ";
            lsQry+="        SELECT idtime_transaction FROM op_kvs_time_transaction ";
            lsQry+="        WHERE CAST(query_time AS DATE) < CURRENT_DATE  ";
            lsQry+="        ORDER BY query_time DESC LIMIT 1  ";
            lsQry+="        )  ";

            lsQry+="),0 ";
            lsQry+=") AS under1 ";
            lsQry+=",  ";
            lsQry+="total_tickets ";
            lsQry+="- COALESCE( ";
            lsQry+="( ";
            lsQry+="SELECT total_tickets FROM op_kvs_timetable a ";
            lsQry+="WHERE idtime_transaction IN (  ";
            lsQry+="        SELECT idtime_transaction FROM op_kvs_time_transaction ";
            lsQry+="        WHERE CAST(query_time AS DATE) < CURRENT_DATE  ";
            lsQry+="        ORDER BY query_time DESC LIMIT 1  ";
            lsQry+="        )  ";
            lsQry+="),0) ";
            lsQry+="AS total_tickets ";
            lsQry+="FROM op_kvs_timetable a ";
            lsQry+="WHERE idtime_transaction IN (  ";
            lsQry+="        SELECT idtime_transaction FROM op_kvs_time_transaction ";
            lsQry+="        WHERE CAST(query_time AS DATE) = CURRENT_DATE  ";
            lsQry+="        ORDER BY query_time DESC LIMIT 1  ";
            lsQry+="        )  ";
            lsQry+=") AS gm1 ";

         $.post("/smartE3/DataService",{psConnectionPool: "jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter(), psQuery:lsQry,psService:"getQueryData"},
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                    loContext.setMOSTTotal(poData.split(DataUtils.getQueryColSpliter())[1]);
                    loContext.printMOSTGage(poData.split(DataUtils.getQueryColSpliter())[0]);
                }
            else{
                    loContext.printMOSTGage(0);
                    loContext.setMOSTTotal(0);
                }
	},"text");
    }
}
//////////////////////////////////////////////////////////////////////////////////////
//                                 Funciones para gr�ficas
/////////////////////////////////////////////////////////////////////////////////////

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
    
