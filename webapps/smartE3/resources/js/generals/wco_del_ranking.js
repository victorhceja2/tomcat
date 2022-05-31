/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

//configuracion inicial
var moMainTimer = null;
var moRePrintTimer = null;
var moIterateTimer = null;
function setIntitialData(){
    moAppHandler.configureApplication();
    
}
function startMainTimer(){
    clearInterval(moMainTimer);
//    moAppHandler.setLayout();
    moMainTimer = setInterval('updateTime();', 1000);
}
function startIteratorTimer(){
    clearInterval(moIterateTimer);
//    moAppHandler.setLayout();
    moIterateTimer = setInterval('moAppHandler.iterateResult();', 10000);
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
    moRePrintTimer = setInterval('manageRePrint();', 10*60000);
    
}
function manageRePrint(){
    clearInterval(moIterateTimer);
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
   this.msStoreId = "";
   this.msOrgId = "";
   this.msDate = "";
   this.msZoom = "100";
   this.msUrlIntCon = "";
   this.miCounter = 1;
   this.maData = new Array();
   this.init = function(psStore,psOrg,psDate,psZoom){
       this.moOrder = new Hash();
       this.moOrderRemoved = new Hash();
       this.msStoreId = psStore;
       this.msOrgId = psOrg;
       this.msDate = psDate;
       this.msZoom = psZoom;
       
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
        
        moParams = new Hash();
        this.getRemoteServiceUrl();
        startMainTimer();
        adjustZoom(this.msZoom);

    }
    this.getCounter = function(){
        return this.miCounter;
    }
    this.setCounter = function(piValue){
        this.miCounter=piValue;
    }
     this.getRemoteServiceUrl = function(){
         var loContext = this;
         var lsSrc = "/smartE3/DataService";
         $.post(lsSrc,{psParam:"appParam_remoteIntranetQueryService",psService:"getXMLParam" },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "")loContext.setIntUrl(poData);
                manageIntervals();
         });
     };
     this.setIntUrl = function(psUrlIntCon){
        this.msUrlIntCon = psUrlIntCon;
     };
     this.getIntUrl = function(){
         return this.msUrlIntCon;
     };
     this.getParamValue = function(psParamName){
        if(moParams != null)
            return moParams.getItem(psParamName);
        else 
            return "";
    };
     this.loadData = function(){
        var loContext = this;
        var lsSrc = "/smartE3/DataService";
        var lsQuery = " SELECT * FROM DBO.op_wco_fn_deliver_dashboard_data('"+this.msOrgId+"','"+this.msStoreId+"','"+this.msDate+"') ";
        
        $.post(lsSrc,{
            psService:"sendURLRequest",
            psUrl:loContext.getIntUrl(),
            psRowSeparator:DataUtils.getQueryRowSpliter(),
            psColSeparator:DataUtils.getQueryColSpliter(), 
            psQuery:lsQuery,
            psServiceToSend:"executeRemoteQuery" },
            
          function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            loContext.cleanTable();
            $("#tdStoreName").html('');
            $("#tdPosition").html('');
            if(poData != ""){
                //var maData = poData.split(DataUtils.getQueryRowSpliter());
                loContext.maData = poData.split(DataUtils.getQueryRowSpliter());
                for(var li=0;li<loContext.maData.length;li++){
                    if(loContext.maData[li].split(DataUtils.getQueryColSpliter())[1] == loContext.msStoreId){
                        $("#tdStoreName").html('<img src="/smartE3/images/e3/ui/explorer/'+loContext.maData[li].split(DataUtils.getQueryColSpliter())[14]+'_big.png" width="60">'+loContext.maData[li].split(DataUtils.getQueryColSpliter())[13]);
                        $("#tdPosition").html(loContext.maData[li].split(DataUtils.getQueryColSpliter())[0]);
                    }
                }
                loContext.iterateResult();
                $("#tdDate").html('<font size="5px">'+loContext.msDate+'</font>');
                startIteratorTimer();
            }
        });
        
        
     };
     this.cleanTable = function(){
        var loTable = document.getElementById("tblRep");
        loTable.innerHTML = "";  
     };
     this.iterateResult = function(){
        var loContext = this;
        loContext.cleanTable()
        var liCounter = loContext.getCounter();
        
        var liTotal = this.maData.length;
        for(var li=(liCounter-1)*6;li<liCounter*6;li++){
            if(typeof this.maData[li] != 'undefined')
                loContext.printRow(this.maData[li]);
        }
        if((liCounter)*6 >= (liTotal))
            loContext.setCounter(1);
        else
            loContext.setCounter(liCounter+1);
     };
    this.getCounter = function(){
        return this.miCounter;
    };
    this.setCounter = function(piValue){
        this.miCounter=piValue;
    };
     this.printRow = function(psRow){
         var loContext = this;
        var lsPosition = psRow.split(DataUtils.getQueryColSpliter())[0];
        var lsStore = psRow.split(DataUtils.getQueryColSpliter())[1];
        var lsDel = psRow.split(DataUtils.getQueryColSpliter())[2];
        var lsProd = psRow.split(DataUtils.getQueryColSpliter())[3];
        var lsDrive = psRow.split(DataUtils.getQueryColSpliter())[4];
        var lsBelow = psRow.split(DataUtils.getQueryColSpliter())[5];
        var lsTotal = psRow.split(DataUtils.getQueryColSpliter())[6];
        var lsPer = psRow.split(DataUtils.getQueryColSpliter())[7];
        var lsResume = psRow.split(DataUtils.getQueryColSpliter())[8];
        var lsDelMeet = psRow.split(DataUtils.getQueryColSpliter())[9];
        var lsProdMeet = psRow.split(DataUtils.getQueryColSpliter())[10];
        var lsDriveMeet = psRow.split(DataUtils.getQueryColSpliter())[11];
        var lsPerMeet = psRow.split(DataUtils.getQueryColSpliter())[12];
        var lsStoreName = psRow.split(DataUtils.getQueryColSpliter())[13];
        var lsBrand = psRow.split(DataUtils.getQueryColSpliter())[14];
        
        var loTable = document.getElementById("tblRep");
        var liId = loTable.rows.length;
        var loTr = loTable.insertRow(liId);
        loTr.setAttribute("class","row");
        if(lsStore == this.msStoreId){
            loTr.setAttribute("class","selected");
        }
        var lsHtml = "";
        lsHtml+='<td class="position">';
           lsHtml+=''+lsPosition+' ';
        lsHtml+='</td>';
        lsHtml+='<td>';
            lsHtml+='<table>';
                lsHtml+='<tr>';
                    lsHtml+='<td>';
                        lsHtml+='&nbsp;';
                    lsHtml+='</td>';
                lsHtml+='</tr>';
                lsHtml+='<tr>';
                    lsHtml+='<td colspan="6" class="store">';
                        lsHtml+='<table>';
                            lsHtml+='<tr>';
                                lsHtml+='<td><img src="/smartE3/images/e3/ui/explorer/'+lsBrand.toLowerCase()+'_big.png" width="60"></td>';
                                lsHtml+='<td>'+lsStoreName+'</td>';
                            lsHtml+='</tr> ';
                        lsHtml+='</table>';
                    lsHtml+='</td>';
                    lsHtml+='<td rowspan="2" class="pie">';
                        lsHtml+='<div id="pie_'+liId+'" style="width:150px; height:100px"></div>';
                    lsHtml+='</td>   ';
                    
                    lsHtml+='<td colspan="2">';
                        lsHtml+='&nbsp;';
                    lsHtml+='</td>   ';
                    lsHtml+='<td rowspan="2" class="post">';
                        lsHtml+='<span>Resumen</span><br>'+lsResume;
                    lsHtml+='</td>';
                lsHtml+='</tr>';
                lsHtml+='<tr>';
                    lsHtml+='<td class="img">';
                        lsHtml+='<img src="/smartE3/images/e3/ui/wco/deliver.png" width="25"> < 30';
                    lsHtml+='</td>';
                    lsHtml+='<td class="per '+((lsDelMeet == "0")?"red":"green")+'">';
                        lsHtml+=lsDel+'%';
                    lsHtml+='</td>';
                    lsHtml+='<td class="img">';
                        lsHtml+='<img src="/smartE3/images/e3/ui/wco/pack.png" width="40"> < 14';
                    lsHtml+='</td>';
                    lsHtml+='<td class="per '+((lsProdMeet == "0")?"red":"green")+'">';
                        lsHtml+=lsProd+'%';
                    lsHtml+='</td>';
                     lsHtml+='<td class="img">';
                        lsHtml+='<img src="/smartE3/images/e3/ui/wco/drive.png" width="40"> < 19';
                    lsHtml+='</td>';
                    lsHtml+='<td class="per '+((lsDriveMeet == "0")?"red":"green")+'">';
                        lsHtml+=lsDrive+':00m';
                    lsHtml+='</td>';
                    lsHtml+='<td class="diag">';
                        lsHtml+=lsBelow+'/'+lsTotal;
                    lsHtml+='</td>';
                    //lsHtml+='<td class="per '+((lsPerMeet == "0")?"red":"green")+'">';
                        //lsHtml+=lsPer+'%';
                    //lsHtml+='</td>';
                lsHtml+='</tr>';

            lsHtml+='</table>';
        lsHtml+='</td>';
        loTr.innerHTML = lsHtml;
        $(document).ready(function () {
            //loContext.plotPie(liId,lsPer,((lsPerMeet == "0")?'red':'#01DF01'));
            loContext.printGauge("pie_"+liId,"",lsPer,0,100,((lsPerMeet == "0")?'100':'0'),'');
        });
    };
    this.plotPie = function(piId,psPer,psColor){
       var liEmpty = 0;
        if(100-parseInt(psPer) > 0){
            liEmpty = 100-parseInt(psPer);
        }
        
        var data = [
			{ label: "a",  data: parseInt(psPer), color:psColor},
			{ label: "b",  data: liEmpty, color:"transparent"}
		];
               
        $.plot('#pie_'+piId, data, {
            series: {
                pie: {
                    innerRadius: 0.5,
                    show: true
                }
            },
            legend: {
            show: false
            }
        });
    };
       
     this.printGauge = function (psDiv,psTitle,piValue,piMin,piMax,piDisr,psLabel){
       var loGage = new JustGage({
       id: psDiv,
       value: piValue,
       min:piMin,
       max:piMax,
       
       
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
 }
 