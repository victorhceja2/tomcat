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
    manageIntervals();
    moMainTimer = setInterval('manageIntervals();', 60000);
    
}
function manageIntervals(){
    clearInterval(moRePrintTimer);
    moAppHandler.loadData();
    moRePrintTimer = setInterval('manageRePrint();', 15000);
    
}
function manageRePrint(){
    moAppHandler.printEmployee();
}

    	       				         
													  
	       
             
             
                
//////////////////////////////////////////////////////////////////////////////////////
//                                 AppHandler
/////////////////////////////////////////////////////////////////////////////////////
function AppHandler() {
   var moParams = null;
   var moEmployees = null;
   var miCounter = 1;
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
        return miCounter;
    }
    this.setCounter = function(piValue){
        miCounter=piValue;
    }
     this.getParamValue = function(psParamName){
        if(moParams != null)
            return moParams.getItem(psParamName);
        else 
            return "";
    }
     this.loadData = function(){
        var loContext = this;
        moEmployees = new Array();
        var lsSrc = "/smartE3/DataService";
        //var lsQry = "SELECT CAST(a.employee_id AS TEXT),SUBSTRING(employee_name FROM 1 FOR 8) ,SUBSTRING(paternal FROM 1 FOR 6),SUBSTRING(station_desc FROM 1 FOR 15),color_desc"+
        var lsQry = "SELECT CAST(a.employee_id AS TEXT),employee_name ,paternal ,station_desc AS desc,color_desc"+
        " ,COALESCE(CASE WHEN timein2 IS NULL THEN to_char(timein1,'HH24:MI') ELSE to_char(timein2,'HH24:MI') END,'--:--'),"+
        " COALESCE(CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END,'--:--'),"+
        " station_desc,CAST(d.sorter AS TEXT)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " INNER JOIN op_esp_vw_cat_employee c"+
        " ON a.employee_id = c.employee_id"+
        " INNER JOIN op_esp_cat_station d"+
        " ON a.station_id  = d.station_id"+
        " LEFT OUTER JOIN op_esp_cat_station_color e"+
        " ON d.color_id = e.color_id"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON a.date_id = f.date_id AND CAST(a.employee_id AS TEXT) = f.emp_num"+
        " WHERE a.date_id = CURRENT_DATE"+
        " AND value > 0"+
        " AND to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " UNION"+
        //" SELECT CAST(c.employee_id AS TEXT),SUBSTRING(employee_name FROM 1 FOR 8) ,SUBSTRING(paternal FROM 1 FOR 6),'NO ASIGNADA','white'"+
        " SELECT CAST(c.employee_id AS TEXT),employee_name  ,paternal,'NO ASIGNADA','white'"+
        " ,COALESCE(CASE WHEN timein2 IS NULL THEN to_char(timein1,'HH24:MI') ELSE to_char(timein2,'HH24:MI') END,'--:--'),"+
        " COALESCE(CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END,'--:--'),'ZZZ' AS station_desc,''"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND c.employee_id NOT IN ("+
        " SELECT employee_id"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.date_id = f.date_id"+
        " AND value > 0"+
        " )"+
        " AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ORDER BY 6,4"+
        " ;";
        $.post(lsSrc,{psQuery:lsQry, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            if(poData != ""){
                var maData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<maData.length;li++){
                    moEmployees.push(maData[li]);   
                }
                manageRePrint();
            }
            else{
                var loTable = document.getElementById("tblEmployee");
                loTable.innerHTML="";
                
            }
            loContext.getTotals();
            loContext.setHour();
	},"text");
     }
     this.printEmployee = function(){
         if(moEmployees.length > 0){
            var loTable = document.getElementById("tblEmployee");

            loTable.innerHTML="";
            var loContext = this;
            var liCounter = loContext.getCounter();
            var liTotal = moEmployees.length;
            for(var li=(liCounter-1)*12;li<liCounter*12;li++){
                if(typeof moEmployees[li] != 'undefined')
                    loContext.addRow(moEmployees[li]);
                
            }
            if((liCounter)*12 > (liTotal))
                loContext.setCounter(1);
            else
               loContext.setCounter(liCounter+1);
       }
     }
     this.setLayout = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry = "SELECT store_id FROM ss_cat_store ";
        $.post(lsSrc,{psQuery:lsQry, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '');
                   if(poData != ""){
                        document.getElementById("imgLayout").src="/smartE3/images/e3/ui/wco/layout.png";
                   }
               });
        
     }
     this.addRow = function(psData){
        var loTable = document.getElementById("tblEmployee");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        var loTd1 = loTr.insertCell(loTr.cells.length);
        var lsEmpNo = psData.split(DataUtils.getQueryColSpliter())[0];
        var lsName = psData.split(DataUtils.getQueryColSpliter())[1];
        var lsPaternal = psData.split(DataUtils.getQueryColSpliter())[2];
        var lsStation = psData.split(DataUtils.getQueryColSpliter())[3];
        var lsColor = psData.split(DataUtils.getQueryColSpliter())[4];
        var lsStartH = DataUtils.getValidValue(psData.split(DataUtils.getQueryColSpliter())[5],'--:--');
        var lsEndH = DataUtils.getValidValue(psData.split(DataUtils.getQueryColSpliter())[6],'--:--');
        var lsSorter = psData.split(DataUtils.getQueryColSpliter())[8];
        var lsConcept = 'Ausente';
        var lsColorDet='#F5A9A9';
        var lsImg = "cancel";
        if(lsStartH != '--:--'){
            if(lsEndH == '--:--'){
                //lsConcept="Entrada desde "+lsStartH;
                lsConcept=""+lsStartH+" a "+lsEndH;
                lsColorDet="#BEF781"; 
                lsImg="confirm";
            }
            else{
                //lsConcept="Ausente "+lsStartH+" a "+lsEndH;
                lsConcept=""+lsStartH+" a "+lsEndH;
                lsColorDet="#F5A9A9"; 
                lsImg="cancel";
            }
        }
        else{
             //lsConcept="Ausente "+lsStartH+" a "+lsEndH;
             lsConcept=""+lsStartH+" a "+lsEndH;
             lsColorDet="#F5A9A9"; 
             lsImg="cancel";
        }
        loTd1.innerHTML='<table style="width: 100%;">'+
                                    '<tr class="employee">'+
                                        '<td width="50px">'+
                                            '<img id="imgHeader" src="/smartE3/images/e3/ui/wco/user.png" width="50px" />'+
                                        '</td>'+
                                        '<td width="30px" style="color:'+lsColor+'">'+
                                            lsSorter+
                                        '</td>'+
                                        '<td width="370px" style="background-color: '+lsColor+';color:'+((lsStation == 'NO ASIGNADA')?'black':'white')+'">'+
                                            //lsEmpNo+" "+lsName+" "+lsPaternal+
                                            lsName+" "+lsPaternal+
                                        '</td>'+
                                        '<td width="50px">'+
                                            '<img id="imgHeader" src="/smartE3/images/e3/ui/wco/'+((lsStation == 'NO ASIGNADA')?'close.png':'station.png')+'" width="50px" />'+
                                        '</td>'+
                                        '<td '+((lsStation == 'NO ASIGNADA')?'style="color:red"':'style="color:black"')+' width="250px">'+
                                            lsStation+
                                        '</td>'+
                                        //'<td width="150px" style="background-color: '+lsColor+'">'+
                                        //'</td>'+
                                             '<td width="50px">'+
                                                     '<img id="imgHeader" src="/smartE3/images/e3/ui/wco/'+lsImg+'.png" width="50px" />'+
                                                     '</td>'+
                                                     '<td width="200px" style="font-size:20px;background-color: '+lsColorDet+'">'+
                                                          lsConcept+
                                                     '</td>'+
                                    '</tr>'+
                                   /* '<tr>'+
                                        '<td class="employee-detail" style="background-color: '+lsColorDet+'" colspan="5" align="center">'+
                                             '<table>'+
                                                 '<tr>'+
                                                     '<td>'+
                                                         '<img id="imgHeader" src="images/'+lsImg+'.png" width="30px" />'+
                                                     '</td>'+
                                                     '<td >'+
                                                          lsConcept+
                                                     '</td>'+
                                                 '</tr>'+
                                             '</table>'+
                                        '</td>'+
                                    '</tr>'+*/
                                '</table>';
        
    }
    this.getTotals = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry=" SELECT COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_vw_cat_employee c"+
        " LEFT OUTER JOIN pp_emp_check f"+
        " ON CAST(c.employee_id AS TEXT) = f.emp_num"+
        " WHERE f.date_id = CURRENT_DATE"+
        " AND CASE WHEN timeout2 IS NULL THEN CASE WHEN timein2 IS NOT NULL THEN to_char(timeout2,'HH24:MI') ELSE to_char(timeout1,'HH24:MI') END ELSE to_char(timeout2,'HH24:MI') END IS NULL"+
        " ),0),"+
        " COALESCE(("+
        " SELECT COUNT(employee_id)"+
        " FROM op_esp_employee_time_table a"+
        " INNER JOIN op_esp_cat_interval b"+
        " ON a.hour_id = b.hour_id"+
        " WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
        " AND a.date_id = CURRENT_DATE"+
        " AND value > 0),0)";
        $.post(lsSrc,{psQuery:lsQry, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '');
                   if(poData != ""){
                       var liBio = poData.split(DataUtils.getQueryColSpliter())[0];
                       var liPlan = poData.split(DataUtils.getQueryColSpliter())[1];
                       var lsColor = "green";
                       var lsStatus = "K4U";
                       var lsBrand = loContext.getParamValue("brand_id").replace(/^\s+|\s+$/g, '');
                       if(lsBrand == "PH"){
                           lsStatus = "Correcto";
                       }
                       if(parseInt(liBio)<parseInt(liPlan)){
                           lsColor="#FFBF00";
                           lsStatus="Ausencia";
                       }
                       else if(parseInt(liBio)>parseInt(liPlan)){
                           lsColor="red";
                           lsStatus="Excedido";
                       }
                       loContext.setReal("<font color="+lsColor+"> "+liBio+"</font>");
                       loContext.setIdeal("<font color="+lsColor+"> "+liPlan+"</font>");
                       loContext.setStatus("<font color="+lsColor+"><font size=6px>"+lsStatus+"</font></font>");
                   }
               });
    
    }
    this.setReal = function(psContent){
    
        document.getElementById("tdReal").innerHTML = psContent;
    }
    this.setHour = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQry="SELECT display_value||'-'||CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END "+
                  "FROM op_esp_Cat_interval  "+
                  "WHERE to_char(CURRENT_TIMESTAMP,'HH24:MI') >= display_value  "+
                   "AND to_char(CURRENT_TIMESTAMP,'HH24:MI') < CASE (SELECT by_hour FROM op_esp_Cat_schedule) WHEN '1' THEN rear_display_value_by_hour ELSE rear_display_value_by_half END ";
            $.post(lsSrc,{psQuery:lsQry, psService:"getQueryData",psConnectionPool:"jdbc/storeEyumDBConnectionPool",psRowSeparator:DataUtils.getQueryRowSpliter(),psColSeparator:DataUtils.getQueryColSpliter() },
                 function(poData) {
                   poData = poData.replace(/^\s+|\s+$/g, '');
                   if(poData != ""){
                        document.getElementById("tdHour").innerHTML = "<font size='6px'>"+poData+"</font>";
                    }
                    else
                        document.getElementById("tdHour").innerHTML = "<font size='6px'>00:00-00:00</font>";
                });
    }
    this.setIdeal = function(psContent){
        document.getElementById("tdIdeal").innerHTML = psContent;
    }
    this.setStatus = function(psContent){
        document.getElementById("tdStatus").innerHTML = psContent;
    }
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
 
