/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//Variables
var moMainPageHandler;
var moTimerInterval = null;

window.addEventListener("resize", resizeAllTabs(0.8));
//////////////////////////////////////////////////////////////////////////////



function scrollTo(poObj){
   var x = jQuery(poObj).offset().top - 150;
   jQuery('html,body').animate({scrollTop: x}, 500,function(){$(poObj).transition('shake');}); 
   
}
function resizeAllTabs(pdPercentage){
    if(typeof moMainPageHandler != "undefined"){
        //for (var lsOptionId in moMainPageHandler.getOptionsHash().getItems()) {
            //$("#divTabPRBOption"+lsOptionId+"").outerHeight(window.innerHeight*pdPercentage+"px");
        //}
    }
}
function restoreAllTabsSize(){
    if ($('#divSessionMenu').is(":hidden")){
        resizeAllTabs(0.90);
    } else {
        resizeAllTabs(0.8);
    }
}
function resizeTab(pdPercentage,piOptionId){
    //$("#divTabPRBOption"+piOptionId+"").outerHeight(window.innerHeight*pdPercentage+"px");
}
function showExportOptions(psOptionId){
    $("#divExportOptions_"+psOptionId).show();
}
function requestSyncService(psPath,poParams){
    
      var lsResponse = "";
      var loRequest = $.ajax({
        type: "POST",
        url: psPath,
        data:poParams,
        cache: false,
        async: false,
        success: function(poData) {
            
            poData = poData.replace(/^\s+|\s+$/g, '');
            lsResponse = poData;
        },
        error: function(poResult) {
            lsResponse = "ERROR"+poResult.responseText;
        }
    });

    return lsResponse;
}
function hideHelpOption(){
    $("#divOptionHelpContainer").hide();
    restoreAllTabsSize();
}
function openHelpOption(){
    $("#divOptionHelpContainer").show();
}
function showHelpOption(psOptionId){
    if( $('#divOptionHelpContainer').is(":visible") ){
        hideHelpOption();
    } else {
        var loOption = moMainPageHandler.getSelectedOption(psOptionId);
        $("#divOptionHelpContainer").load(loOption.getUseHelp(),
            function(responseTxt, statusTxt, xhr){
                if(statusTxt == "error"){
                    $(this).html("<center><h3 class='ui header'>Lo sentimos, la p&aacute;gina ["+loOption.getUseHelp()+"]  no fu&eacute; localizada</h3><img src='Resources/Images/MainPage/close.png' width='50px'></center>");
                }
            });
       resizeAllTabs(0.6);
       openHelpOption();
       //$("#divOptionHelpContainer").outerHeight(window.innerHeight*0.2+"px");
    }
}
function printOption(psOptionId){
    try{
        $("#divTabPRBOption"+psOptionId)[0].contentWindow.printCustom();
    } catch(poError){
        var loFrmWin = $("#divTabPRBOption"+psOptionId)[0].contentWindow;
        loFrmWin.focus();
        loFrmWin.print();
    }
}
function exportXLSOption(psOptionId){
    try{
        $("#divTabPRBOption"+psOptionId)[0].contentWindow.exportXLSCustom();
     } catch(poError){
         
     }   
}
function exportCSVOption(psOptionId){
    try{
        $("#divTabPRBOption"+psOptionId)[0].contentWindow.exportCSVCustom();
    } catch(poError){
         
    }   
}
function exportPDFOption(psOptionId){
    try{
        $("#divTabPRBOption"+psOptionId)[0].contentWindow.exportPDFCustom();
    } catch(poError){
         
    }   
}

function requestAsyncService(psPath,poParams,psAction){
      var lsResponse = "";
      var loRequest = $.ajax({
        type: "POST",
        url: psPath,
        data:poParams,
        cache: false,
        async: true,
        success: function(poData) {
            poData = poData.replace(/^\s+|\s+$/g, '');
            eval(psAction.replace("response_text",poData));
        },
        error: function(poResult) {
            lsResponse = "ERROR"+poResult;
        }
    });

    return lsResponse;
}
function initAppHandler(){
    if(typeof moMainPageHandler == "undefined" || moMainPageHandler){
        moMainPageHandler = new MainPageHandler();
        moMainPageHandler.initHandler();
    }
}
function showMailConfirm(psMail,psId,psName){
        moMainPageHandler.showAlertWindow('&iquest;Deseas enviar un correo a '+psMail+' quien es el encargado de esta opci&oacute;n?','<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div><div id="btnAlertCancel" class="ui cancel red basic button">Cancelar</div>');
        $("#btnAlertOk").click(function(){sendMail(psMail,psId,psName);moMainPageHandler.hideAlertWindow()});
 };
 function sendMail(psMail,psId,psName){
     window.location.href="mailto:"+psMail+"?subject="+psId+" "+psName+"";
 }
 function closeTab(psId){
     $('#divTabPRBOptionHeader'+psId+'').remove();
     $('#divTabPRBOption'+psId+'').remove();
 }
 function validateTab(psId){
     if ($('#divTabPRBOption'+psId+'').length <= 0){
         return false;
     }
     return true;
 }
function goToPage(psTarget,psSrc,psId,psName,psOrg,pbUseOpts,psHelp,psConf){
    hideMenu();
    hideSearch();
    hideHelpOption();
    showLoading();
    var lsUrl = moMainPageHandler.getIntUrl();
    if(psTarget == "" || psTarget == "divMainContentPRB"){
        if (!validateTab(psId)){
            $('#divMainPRBTabSetHeader').append('<a id="divTabPRBOptionHeader'+psId+'" class="item" data-tab="'+psId+'">'+psName+'<i class="close big icon" onclick="closeTab('+psId+')"></i></a>');
            $('#divMainPRBTabSet').append('<div id="divTabPRBOption'+psId+'" class="ui bottom attached tab segment container" data-tab="'+psId+'"></div>');
            var loTabOption = new TabOption(psId,psName,psOrg,pbUseOpts,psHelp,psSrc,psConf);
            moMainPageHandler.addOption(psId,loTabOption);
            var lsTest = requestSyncService(DataUtils.getGeneralDataURL(),{
                    psService:DataUtils.getURLCallService(),
                    psRowSeparator:"",
                    psColSeparator:"", 
                    psUrl:lsUrl,
                    psConn:"jdbc/EYUMV2",
                    psQuery:"SELECT xml_data FROM [dbo].[op_gps_store_capture] WHERE store_id = "+moMainPageHandler.getStoreId()+" AND CONVERT(VARCHAR,date_id,103) = CONVERT(VARCHAR,GETDATE(),103) AND section_id = "+psId,
                    psServiceToSend:"executeRemoteQuery"
                });
            
            if(lsTest == ""){
                var lsForm=moMainPageHandler.getSectionContent(psId);

                $('#divTabPRBOption'+psId+'').html(lsForm);

                $('.ui.red.button').on('click',function(){
                    var lsSvy = $(this).parent().attr("survey");
                    var lsNo = $(this).parent().attr("number");
                    var lsSubNo = $(this).parent().attr("subnumber");
                    var lsManage = $(this).attr("manage");
                    var lsValue =  $(this).attr("value");
                    var lbReact = DataUtils.getValidBoolean($(this).parent().attr("react"),false);

                    if(lbReact){
                        $("#label_"+lsSvy+"_"+lsNo).removeClass("green");
                        $("#label_"+lsSvy+"_"+lsNo).addClass("red");
                        $("#label_"+lsSvy+"_"+lsNo).addClass("inverted");
                        //$("#label_"+lsSvy+"_"+lsNo).addClass("tertiary");

                    }
                    $("#error_"+lsSvy+"_"+lsNo+"_"+lsSubNo).hide();
                    $(this).parent().attr("value",lsValue);
                    $(this).parent().attr("time_id",DataUtils.getTime());
                    var laArray = lsManage.split(";");
                    for(var li=0;li<laArray.length;li++){
                        var lsItemId =laArray[li].split(":")[0];
                        var lsItemStatus =laArray[li].split(":")[1];
                        if(lsManage != ""){
                            if(lsItemStatus == "visible")
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").show();
                            else 
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").hide();
                        }
                    }

                });
                $('.ui.green.button').on('click',function(){
                    var lsSvy = $(this).attr("survey");
                    var lsNo = $(this).attr("number");
                    var lsSubNo = $(this).attr("subnumber");
                    var lsManage = $(this).attr("manage");
                    var lsValue =  $(this).attr("value");
                    var lbReact = DataUtils.getValidBoolean($(this).parent().attr("react"),false);
                    if(lbReact){
                        $("#label_"+lsSvy+"_"+lsNo).removeClass("red");
                        $("#label_"+lsSvy+"_"+lsNo).addClass("green");
                        $("#label_"+lsSvy+"_"+lsNo).addClass("inverted");
                        //$("#label_"+lsSvy+"_"+lsNo).addClass("tertiary");

                    }
                    $("#error_"+lsSvy+"_"+lsNo+"_"+lsSubNo).hide();
                    $(this).parent().attr("value",lsValue);
                    $(this).parent().attr("time_id",DataUtils.getTime());

                    var laArray = lsManage.split(";");
                    for(var li=0;li<laArray.length;li++){
                        var lsItemId =laArray[li].split(":")[0];
                        var lsItemStatus =laArray[li].split(":")[1];
                        if(lsManage != ""){
                            if(lsItemStatus == "visible")
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").show();
                            else 
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").hide();
                        }
                    }

                });
                $('input[type=text]').change(function () {
                    var lsSvy = $(this).parent().attr("survey");
                    var lsNo = $(this).parent().attr("number");
                    var lsSubNo = $(this).parent().attr("subnumber");
                    var lsValue = $(this).val();
                    var lsManage = $(this).parent().attr("manage");
                    var lbReact = DataUtils.getValidBoolean($(this).parent().attr("react"),false);
                    $(this).parent().attr("value",lsValue);
                    $(this).parent().attr("time_id",DataUtils.getTime());
                    if(lbReact){
                        if(lsValue == ""){
                            $("#label_"+lsSvy+"_"+lsNo).removeClass("green");
                            $("#label_"+lsSvy+"_"+lsNo).removeClass("inverted");
                        } else {
                            $("#error_"+lsSvy+"_"+lsNo+"_"+lsSubNo).hide();
                            $("#label_"+lsSvy+"_"+lsNo).addClass("green");
                            $("#label_"+lsSvy+"_"+lsNo).addClass("inverted");
                        }
                    }
                });
                   $('select').change(function () {
                    var lsSvy = $(this).parent().parent().attr("survey");
                    var lsNo = $(this).parent().parent().attr("number");
                    var lsSubNo = $(this).parent().parent().attr("subnumber");
                    var lsValue = $(this).val();
                    var lsManage = "";
                    if(lsValue.split("|").length > 1){
                        lsManage = lsValue.split("|")[1];
                    }
                    var lsValue = lsValue.split("|")[0];
                    var lbReact = DataUtils.getValidBoolean($(this).parent().parent().attr("react"),false);
                    $("#error_"+lsSvy+"_"+lsNo+"_"+lsSubNo).hide();
                    $(this).parent().parent().attr("value",lsValue);
                    $(this).parent().parent().attr("time_id",DataUtils.getTime());
                    if(lbReact){
                        if(lsValue == ""){
                            $("#label_"+lsSvy+"_"+lsNo).removeClass("green");
                            $("#label_"+lsSvy+"_"+lsNo).removeClass("inverted");
                        } else {
                            $("#label_"+lsSvy+"_"+lsNo).addClass("green");
                            $("#label_"+lsSvy+"_"+lsNo).addClass("inverted");
                        }
                    }
                    var laArray = lsManage.split(";");
                    for(var li=0;li<laArray.length;li++){
                        var lsItemId =laArray[li].split(":")[0];
                        var lsItemStatus =laArray[li].split(":")[1];
                        if(lsManage != ""){
                            if(lsItemStatus == "visible")
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").show();
                            else 
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").hide();
                        }
                    }
                });
                $('input[type=checkbox],input[type=radio]').click(function () {
                    var lsSvy = $(this).parent().parent().attr("survey");
                    var lsNo = $(this).parent().parent().attr("number");
                    var lsSubNo = $(this).parent().parent().attr("subnumber");
                    var lsManage = $(this).attr("manage");
                    var lbReact = DataUtils.getValidBoolean($(this).parent().parent().attr("react"),false);
                    $(this).parent().parent().attr("value","");
                    $(this).parent().parent().attr("time_id",DataUtils.getTime());
                    $("#error_"+lsSvy+"_"+lsNo+"_"+lsSubNo).hide();
                    if(lbReact){
                        var lbFlg = false;
                        $("input[name="+$(this).attr("name")+"]").each(
                            function(piIndex){
                                var lbChecked = $(this).is(':checked');
                                if(lbChecked){
                                    lbFlg = true;
                                    $(this).parent().parent().attr("value",$(this).parent().parent().attr("value")+$(this).attr("value")+",");
                                }
                                if(lbFlg){
                                    $("#label_"+lsSvy+"_"+lsNo).addClass("green");
                                    $("#label_"+lsSvy+"_"+lsNo).addClass("inverted");
                                 } else {
                                    $("#label_"+lsSvy+"_"+lsNo).removeClass("green");
                                    $("#label_"+lsSvy+"_"+lsNo).removeClass("inverted");
                                }
                            });
                     }
                     var laArray = lsManage.split(";");
                    for(var li=0;li<laArray.length;li++){
                        var lsItemId =laArray[li].split(":")[0];
                        var lsItemStatus =laArray[li].split(":")[1];
                        if(lsManage != ""){
                            if(lsItemStatus == "visible")
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").show();
                            else 
                                $("#label_"+lsSvy+"_"+lsNo+" > div[subnumber="+lsItemId+"]").hide();
                        }
                    }
                });
            } else {
                $("#divTabPRBOption"+psId).html('<div class="ui center aligned segment" ><h3>Tu formato ya ha sido enviado anteriormente el d&iacute;a de hoy</h3><img src="/smartE3/images/e3/ui/wco/confirm.png" width="100"/>');
            }
            //$('#divTabPRBOption'+psId+'').attr("src",psSrc);
            /*$('#divTabPRBOption'+psId+'').load(
                function(){ 
                    var lsObj = moMainPageHandler.getSelectedOption(psId);
                    moMainPageHandler.printOptionHeader(lsObj);
                    hideLoading();
                });*/
            
        }
        $('#divMainPRBTabSet .menu .item').tab('change tab', psId);
        hideLoading();
    }else if(psTarget == "_blank"){
        hideLoading();
        window.open(psSrc,psTarget);
    }else {
        hideLoading();
        moMainPageHandler.showAlertWindow("<center><h3 class='ui header'>Lo sentimos, el contenedor especificado  ["+psTarget+"] no es v&aacute;lido </h3><img src='Resources/Images/MainPage/close.png' width='50px'></center>",'<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div>' );
    }
}
function goMain(){
    moMainPageHandler.removeAllOptions();
    $(location).attr("href","GPSCapture.html");
};

function validateAppHandler(){
    if(typeof moMainPageHandler  == "undefined" || moMainPageHandler == null){
        goMain();
        return false;
    } 
}
function parseXML(psXMLData){
    if (typeof window.DOMParser != "undefined") {
           return ( new window.DOMParser() ).parseFromString(psXMLData, "text/xml");
    } else if (typeof window.ActiveXObject != "undefined" && new window.ActiveXObject("Microsoft.XMLDOM")) {
        var loXMLParser = new window.ActiveXObject("Microsoft.XMLDOM");
        loXMLParser.async = "false";
        loXMLParser.loadXML(psXMLData);
        return loXMLParser;
    } else {
        moMainPageHandler.showAlertWindow("Tu navegador no cuenta con un parseador de XML",'<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div>');
        return null;
    }
}
function XMLResponse(psXMLResponse){
    
    this.mbSuccessResponse = false;
    this.msResponseXML = psXMLResponse;
    this.moDomObj = null;
    this.initDOMObj = function(){
        if (typeof window.DOMParser != "undefined") {
           this.setDomObj(( new window.DOMParser() ).parseFromString(this.msResponseXML, "text/xml"));
        } else if (typeof window.ActiveXObject != "undefined" && new window.ActiveXObject("Microsoft.XMLDOM")) {
            var loXMLParser = new window.ActiveXObject("Microsoft.XMLDOM");
            loXMLParser.async = "false";
            loXMLParser.loadXML(this.msResponseXML);
            this.setDomObj(loXMLParser);
        } else {
            moMainPageHandler.showAlertWindow("Tu navegador no cuenta con un parser de XML",'<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div>');
            this.setSuccess(false);
        }
    };
    
    this.getDomObj = function(){
        return this.moDomObj;
    };
    this.setDomObj = function(poObj){
        this.moDomObj = poObj;
        if(this.getStatus() == DataUtils.getErrStatus()){
            moMainPageHandler.showAlertWindow("Ocurri&oacute; el siguiente error:"+this.getData(),'<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div>');
            this.setSuccess(false);
        } 
        else if(this.getStatus() == DataUtils.getSuccStatus()){
            this.setSuccess(true);
        }
    };
    this.getData = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("data")[0].childNodes[0].nodeValue;
    };
    this.getType = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("type")[0].childNodes[0].nodeValue;
    };
    this.getDataNode = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("data")[0];
    };
    this.getStatus = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("status")[0].childNodes[0].nodeValue;
    };
    this.getDate = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("date_id")[0].childNodes[0].nodeValue;
    };
    this.getTime = function(){
        return this.getDomObj().getElementsByTagName("response")[0].getElementsByTagName("time_id")[0].childNodes[0].nodeValue;
    };
    this.setSuccess = function(pbValue){
        this.mbSuccessResponse = pbValue;
    };
    this.getSuccess = function(){
        return this.mbSuccessResponse;
    };
    this.initDOMObj();
    
}
function openMenu(){
    hideOptions();
    hideSearch();
    hideSessionMenu();
    moMainPageHandler.openMenuFunction("","","0");
    $('#divPRBMenu').sidebar('setting', 'closable', false);
    $('#divPRBMenu').sidebar('show');
}
function openSessionMenu(){
     $('#divSessionMenu').show();
     resizeAllTabs(0.8);
     $("#btnShowSessionMenu").hide();
}
function showBtmShowSession(){
    if ($('#divSessionMenu').is(":hidden")){
        $("#btnShowSessionMenu").show();
    }
}
function hideBtmShowSession(){
    if ($('#divSessionMenu').is(":hidden")){
        $("#btnShowSessionMenu").hide();
    }
}
function hideSessionMenu(){
     $('#divSessionMenu').hide();
}
function showSessionMenu(){
     
     $('#divSessionMenu').show();
     
}
function hideMenu(){
    showSessionMenu();
    $('#divPRBMenu').sidebar('hide');
}
function showLoading(){
    $('#divPRBLoading').addClass("active");
}
function hideLoading(){
    $('#divPRBLoading').removeClass("active");
}


function toogleMenu(){
    $('#divPRBMenu').sidebar('setting', 'closable', 'false');
    $('#divPRBMenu').sidebar('toggle');
     
}
function hideOptions(){
    $('#divPRBOptions').sidebar('hide');
}
function openOptions(psOptionId){
    hideMenu();
    hideSearch();
    $('#divPRBOptions').sidebar('show');
}
function toogleOptions(){
    $('#divPRBOptions').sidebar('toggle');
}
function toogleSearch(){
    $('#divPRBSearch').sidebar('toggle');
}
function openSearch(){
    hideOptions();
    hideMenu();
    $('#divPRBSearch').sidebar('show');
    moMainPageHandler.cleanSearch();
}
function hideSearch(){
    $('#divPRBSearch').sidebar('hide');
}
var DataUtils = {
    getQueryColSpliter : function() {
        return "_|_";
    },
    getQueryRowSpliter : function() {
        return "_||_";
    },
    getSingleTextSpliter : function() {
        return "_||_";
    },
    getGeneralDataURL : function(){
        return "/smartE3/DataService";
    },
    getXMLParamService : function(){
        return "getXMLParam";
    },
    getPromoFileService : function(){
        return "getPromoImg";
    },
    getisStoreService : function(){
        return "isStore";
    },
    getQueryDataService : function(){
        return "getQueryData";
    },
    getValidateLogOnService: function(){
        return "validateLogon";
    },
    getValidateSessionService: function(){
        return "validateSession";
    },
    getCloseSessionService: function(){
        return "closeSession";
    },
    getURLCallService: function(){
        return "sendURLRequest";
    },
    getValidBoolean : function(pbValue, pbDefault) {
        if(pbValue == null || typeof pbValue == "undefined")
            return pbDefault;
        if (pbValue.replace(/^\s+|\s+$/g, '')=="true" || pbValue.replace(/^\s+|\s+$/g, '')==true) 
            return true;
        else if (pbValue.replace(/^\s+|\s+$/g, '')=="false" || pbValue.replace(/^\s+|\s+$/g, '')==false)
          return false;
        
        else 
          return pbDefault
    },
    getValidValue : function(psValue, psDefaultValue) {
        return  (psValue!=null && typeof psValue != 'undefined')?psValue:psDefaultValue;
    },
    getValidNumber : function(psValue,pdDefault) {
        if (psValue.isNumber()) 
            return psValue*1;
        else
            return pdDefault;
    },
    getTime : function() {
        var lsTime = (new Date()).toTimeString();
        
        return lsTime.substring(0 ,5);
    },
    
    getUTCTime : function() {
        return (new Date()).valueOf();
    },
    getErrStatus : function() {
        return "ERROR";
    },
    getSuccStatus : function() {
        return "OK";
    },
    getInValidSessionStatus : function() {
        return "NO SESSION";
    },
    getValidSessionStatus : function() {
        return "HAS SESSION";
    },
    getDateWOD : function() {
        var loDate = new Date();
        
        var lsYear = loDate.getFullYear()+"";
        var lsMonth = "0" + (loDate.getMonth()+1);
        var lsDay = "0" + loDate.getDate();

        //var lsMonth = "0" + (loDate.getUTCMonth()+1);
        //var lsDay = "0" + loDate.getUTCDate();
        
        return lsYear + lsMonth.substring(lsMonth.length-2) + lsDay.substring(lsDay.length-2);
    }
} ;   

function TabOption(psOptionId,psOptionName,psOptionOrg,pbUseOpts,pbUseHelp,psType,psConfig){
    this.msOptionId=psOptionId;
    this.msOptionName=psOptionName;
    this.msOptionOrg=psOptionOrg;
    this.mbUseOpts=pbUseOpts;
    this.mbUseHelp=pbUseHelp;
    this.msType=psType;
    this.msConfig=psConfig;
    
    this.getOptionId = function(){
      return this.msOptionId;  
    };
    this.getOptionName = function(){
      return this.msOptionName;  
    };
    this.getOptionOrg = function(){
      return this.msOptionOrg;  
    };
    this.getUseOpts = function(){
      return this.mbUseOpts;  
    };
    this.getUseHelp = function(){
      return this.mbUseHelp;  
    };
    this.getType = function(){
      return this.msType;  
    };
    this.getConfig = function(){
      return this.msConfig;  
    };
}
function MainPageHandler(){
    this.mbIsStore = false;
    this.msStoreId = "";
    this.msStoreName = "";
    this.msCompany = "";
    this.msUser = "";
    this.msEmpId = "";
    this.msMail = "";
    this.msUserLevel = "";
    this.msUserOptions = "";
    this.mbLogged = false;
    this.moOptionsHash = new Hash();
    this.msUrlIntCon = "http://192.168.109.70:7072/servlet/generals.servlets.StoreDataService";
    this.msXMLMenu = "";
    this.addOption = function(psId,poMenuOption){
      this.moOptionsHash.setItem(psId,poMenuOption);  
    };
    this.removeOption = function(psId){
      this.moOptionsHash.removeItem(psId);
    };
    this.removeAllOptions = function(){
        this.moOptionsHash.removeAll();
    };
    this.getSelectedOption = function(psId){
        var lsId = psId.toString().replace("divTabPRBOption","");
        return this.moOptionsHash.getItem(lsId);
    };
    this.getOptionsHash = function(){
        return this.moOptionsHash;
    };
    this.getOptionsHashArray = function(){
        return this.moOptionsHash.getArray();
    };
    this.isLoggedIn = function(){
        return this.mbLogged;
    };
    this.setUserData = function(psUser,psEmpId,psMail,psUserLevel,psUserOptions){
        this.msUser = psUser;
        this.msEmpId = psEmpId;
        this.msMail = psMail;
        this.msUserLevel = psUserLevel;
        this.msUserOptions = psUserOptions;
        this.mbLogged = true;
    };
    this.clearUserData = function(){
        this.msUser = "";
        this.msEmpId = "";
        this.msMail = "";
        this.msUserLevel = "";
        this.msUserOptions = "";
        this.mbLogged = false;
    };
    this.initHandler = function(){
        clearInterval(moTimerInterval);
        moTimerInterval = setInterval('moMainPageHandler.updateTime();', 10000);
        this.updateTime();
        this.initHRefListenner();
        this.getStoreData();
        //this.initSnow();
    };
    this.updateTime = function(){
        var loDate = new Date();
        var liYear = loDate.getFullYear();
        var liMonth = loDate.getMonth();
        var liDate = loDate.getDate();
        var liMinute = loDate.getMinutes();
        var liHour = loDate.getHours();
        $("#spnDateTime").html(liYear+"/"+liMonth+"/"+liDate+" "+liHour+":"+((liMinute<10)?"0"+liMinute:liMinute));
        $("#divMainPRBTabSet > div[id^='divTabPRBOption']").each(function (key,element){ 
             var lsOptionId  = $(this).attr('id');
             var lsOptionNo = lsOptionId.replace("divTabPRBOption","");
             lsOptionId = lsOptionId.replace("divTabPRBOption","container_");
             $("#"+lsOptionId+" > div[id^='label_"+lsOptionNo+"'] ").each(function (key,element){ 
                 var lsLabelId  = $(this).attr('id');
                 var lsLabelHourId = lsLabelId.replace("label_","hour_");
                 var lsTimeLabel = $("#"+lsLabelHourId).html();
                 var lsHourLabel = lsTimeLabel.split(":")[0];
                 var lsMinLabel = lsTimeLabel.split(":")[1];
                 if(parseInt(lsHourLabel) > parseInt(liHour)){
                    $("#"+lsLabelId+"_time_btn").removeClass("orange");
                    $("#"+lsLabelId+"_time_btn").addClass("blue");
                 } else if(parseInt(lsHourLabel) == parseInt(liHour)){
                     if(parseInt(lsMinLabel) >= parseInt(liMinute)){
                        $("#"+lsLabelId+"_time_btn").removeClass("orange");
                        $("#"+lsLabelId+"_time_btn").addClass("blue");
                     } else {
                        $("#"+lsLabelId+"_time_btn").removeClass("blue");
                        $("#"+lsLabelId+"_time_btn").addClass("orange");
                     }
                     
                 } else {
                    $("#"+lsLabelId+"_time_btn").removeClass("blue");
                    $("#"+lsLabelId+"_time_btn").addClass("orange");
                 }

             }); 
        }); 
    
    };
    this.submitCapture = function(psObjId){
        var lsOptionNo = psObjId.replace("btn_submit_","");
        $("#"+psObjId).addClass("loading");
        showLoading();
        if(this.validateCapture(lsOptionNo)){
            if(this.saveCapture(lsOptionNo)){
                $("#divTabPRBOption"+lsOptionNo).html('<div class="ui center aligned segment" ><h3>Tu formato ha sido enviado con &eacute;xito</h3><img src="/smartE3/images/e3/ui/wco/confirm.png" width="100"/>');
            } else {
                this.showAlertWindow("Ocurri&oacute; un error al intentar guardar el formato, por favor intenta nuevamente",'<div id="btnAlertOk" class="ui ok green basic button">Aceptar</div>');
            }
        }
        hideLoading();
        $("#"+psObjId).removeClass("loading");
        
    };
    this.validateCapture = function(psOptionNo){
        var lbReturn=true;
        $("#divMainPRBTabSet > #divTabPRBOption"+psOptionNo+" > #container_"+psOptionNo+" > div[id^='label_"+psOptionNo+"'] >  div[id^='question_"+psOptionNo+"'] ").each(
            function (key,element){
                var lbRequired = DataUtils.getValidBoolean($(this).attr("mandatory"),false);
                var lsValue = DataUtils.getValidValue($(this).attr("value"),"");
                var lsDisplay = DataUtils.getValidValue($(this).css('display'),"");
                var lsSurvey = DataUtils.getValidValue($(this).attr('survey'),"");
                var lsNumber = DataUtils.getValidValue($(this).attr('number'),"");
                var lsSubNumber = DataUtils.getValidValue($(this).attr('subnumber'),"");
                if(lbRequired && lsDisplay != "none"){
                    if(lsValue == ""){
                        $(this).addClass("error");
                        $("#error_"+lsSurvey+"_"+lsNumber+"_"+lsSubNumber).show();
                        scrollTo(this);
                        
                        lbReturn=false;
                        return false;
                    } else {
                        $("#error_"+lsSurvey+"_"+lsNumber+"_"+lsSubNumber).hide();
                        $(this).removeClass("error");
                    }
                }
            }
        );
        return lbReturn;
    };
    this.saveCapture = function(psOptionNo){
        var loContext = this;
        var lsUrl = loContext.getIntUrl();
        var lsXMLData = "<data_container><form_capture id=\""+psOptionNo+"\" time_id=\""+DataUtils.getTime()+"\" date_id=\""+DataUtils.getDateWOD()+"\" >";
        $("#divMainPRBTabSet > #divTabPRBOption"+psOptionNo+" > #container_"+psOptionNo+" > div[id^='label_"+psOptionNo+"']").each(
                function (key,element){
                    var lsDesc = $(this).children("p").html();
                    var lsSectionId = $(this).children("p").attr("id");
                    var lsHour = $(this).children().children("span").html();
                    lsXMLData+="<section id=\""+lsSectionId+"\" hour=\""+lsHour+"\">";
                    lsXMLData+="<title><![CDATA["+lsDesc+"]]></title>";
                    $(this).children("div[id^='question_"+psOptionNo+"']").each(
                        function (key,element){
                            var lsValue = DataUtils.getValidValue($(this).attr("value"),"");
                            var lsTime = DataUtils.getValidValue($(this).attr("time_id"),"");
                            var lsDisplay = DataUtils.getValidValue($(this).css('display'),"");
                            var lsSubNumber = DataUtils.getValidValue($(this).attr('subnumber'),"");
                            var lsPlaceHolder = DataUtils.getValidValue($(this).children().attr('placeholder'),"");
                            lsXMLData+="<question id=\""+lsSubNumber+"\" display=\""+lsDisplay+"\" time_id=\""+lsTime+"\">";
                            lsXMLData+="<answer><![CDATA["+lsValue+"]]></answer>";
                            lsXMLData+="<placeholder><![CDATA["+lsPlaceHolder+"]]></placeholder>";
                            lsXMLData+="</question>";
                        }    
                    );
                    lsXMLData+="</section>";
                }
        );
        lsXMLData+= "</form_capture></data_container>";
        
        var lsInsert = requestSyncService(DataUtils.getGeneralDataURL(),{
                    psService:DataUtils.getURLCallService(),
                    psRowSeparator:"",
                    psColSeparator:"", 
                    psUrl:lsUrl,
                    psConnectionPool:"jdbc/EYUMV2",
                    psQuery:"INSERT INTO [op_gps_store_capture](store_id,date_id,section_id,xml_data) VALUES ("+this.getStoreId()+",GETDATE(),"+psOptionNo+",'"+lsXMLData+"');",
                    psServiceToSend:"executeRemoteProc"
                });
        if(lsInsert == "OK")
            return true;
        else 
            return false;
        
    };
    this.doSearch = function(){
       $("#secSearch").show();
    };
    this.getStoreData = function(){
        showLoading(); 
        //var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getisStoreService()}));
        var lsQuery="SELECT store_id,store_desc,(SELECT company_id FROM dblink('dbname=dbsec user=postgres','SELECT company_id FROM ss_org_cat_company') AS t(company_id TEXT)) FROM ss_cat_store";
        var lsResponse = requestSyncService(DataUtils.getGeneralDataURL(),{
                    psService:DataUtils.getQueryDataService(),
                    psQuery:lsQuery,
                    psConnectionPool: "jdbc/storeEyumDBConnectionPool",
                    psRowSeparator:DataUtils.getQueryRowSpliter(),
                    psColSeparator:DataUtils.getQueryColSpliter()
                });
        if(lsResponse == ""){
            this.showAlertWindow("No encontramos informaci&oacute;n de tu restaurante, por favor ingresa nuevamente, si el problema persiste comun&iacute;cate a sistemas",'<div id="btnAlertOk" class="ui ok green basic button" onclick="goMain()">Reintentar</div>',false);
        } else {
            this.setStoreId(lsResponse.split(DataUtils.getQueryColSpliter())[0]);
            this.setStoreName(lsResponse.split(DataUtils.getQueryColSpliter())[1]);
            this.setCompany(lsResponse.split(DataUtils.getQueryColSpliter())[2]);
            this.getRemoteServiceUrl();
            this.printUserId();
        }
        this.setIsStore(true);
        this.hideIfStoreOptions();
    };
    this.validateLogOn = function(){
        var lsForm = '#frmLogin.ui.form';
        var lsUser = $(lsForm).form('get value', 'txtUser');
        var lsPass = $(lsForm).form('get value', 'txtPassword');
        if(lsUser == "" || lsPass == "")return;
        var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getValidateLogOnService(),txtUser:lsUser,txtPassword:lsPass}));
        if(loResponse.getSuccess()){
            $(lsForm).form('clear');
            this.hideLoginWindow();
            this.parseUserData(loResponse.getDataNode());
        } else{
            $(lsForm).form('clear');
            this.showAlertWindow("Las claves no son v&aacute;lidas, por favor intenta nuevamente",'<div id="btnAlertOk" class="ui ok green basic button" onclick="moMainPageHandler.showLoginWindow()">Reintentar</div><div id="btnAlertCancel" class="ui cancel red basic button">Cancelar</div>');
        }
    };
    this.restoreSession = function(){
        var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getValidateLogOnService(),hidLoginSession:"old"}));
        if(loResponse.getSuccess()){
            this.parseUserData(loResponse.getDataNode());
        } else{
            $(lsForm).form('clear');
            this.showAlertWindow("Las claves no son v&aacute;lidas, por favor intenta nuevamente",'<div id="btnAlertOk" class="ui ok green basic button" onclick="moMainPageHandler.showLoginWindow()">Reintentar</div><div id="btnAlertCancel" class="ui cancel red basic button">Cancelar</div>');
        }
    };
    this.closeSession = function(){
        var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getCloseSessionService()}));
        if(loResponse.getSuccess()){
            this.clearUserData();
            this.removeAllOptions();
            goMain();
            delete this;
        } 
    };
    this.functionArray = function(){
        
    };
    this.cleanSearch = function(){
        var loContext = this;
        $('#divPRBSearch').html(' <div class="item"><div id="hide-search-sidebar" class="button"><font color=white>Cerrar<i class="close icon"></i></font></div></div>');
        $('#hide-search-sidebar').click(function() {
                  hideSearch();
         });
        $('#divPRBSearch').append('<div class="ui input"><input type="text" id="txtMainMenuSearchPRB" placeholder="Buscar..."></div>');
        $('#txtMainMenuSearchPRB').blur(function(){
            loContext.searchMenuOption(this.value);
        });
        $('#divPRBSearch').append('<h4 class="ui white horizontal inverted divider header"><i class="list layout icon"></i>Resultados</h4>');
    };
    this.searchMenuOption = function(psFilter){
        var loContext = this;
        showLoading();  
        var poDataNode = parseXML(this.getMenuXML());
        this.cleanSearch();
         
        var liOptionsLength = poDataNode.getElementsByTagName("menu_options")[0].getElementsByTagName("option").length;
        for(var liOptionCounter=0;liOptionCounter<liOptionsLength;liOptionCounter++){
            var loCurrentOption = poDataNode.getElementsByTagName("menu_options")[0].getElementsByTagName("option")[liOptionCounter];
            var lsId = DataUtils.getValidValue(loCurrentOption.getAttribute("id"),"");
            var lsLevel = DataUtils.getValidValue(loCurrentOption.getAttribute("level"),"0");
            var lsOrg = DataUtils.getValidValue(loCurrentOption.getAttribute("org"),"");
            var lsName = DataUtils.getValidValue(loCurrentOption.getAttribute("name"),"");
            var lsTarget = DataUtils.getValidValue(loCurrentOption.getAttribute("target"),"");
            var lsSrc = DataUtils.getValidValue(loCurrentOption.getAttribute("src"),"");
            var lsOwner = DataUtils.getValidValue(loCurrentOption.getAttribute("owner"),"");
            var lbUseOpts = DataUtils.getValidBoolean(loCurrentOption.getAttribute("use_options"),false);
            var lsHelp = DataUtils.getValidValue(loCurrentOption.getAttribute("use_help"),"");
            var lsConf = DataUtils.getValidValue(loCurrentOption.getAttribute("xml_conf"),"");
            if(lsName.toString().toLowerCase().indexOf(psFilter.toLowerCase()) != -1){
                if(lsSrc != ""){
                   $('#divPRBSearch').append( '<a href="javascript:void(0)" id="menu_option_'+lsId+'_'+lsOrg+'_'+lsLevel+'" class="item">'+lsName+((lsSrc != "")?'':'<i class="angle right icon"></i>')+((lsOwner == "")?'':'<i id="icon_owner_'+lsId+'" class="mail outline icon"></i>')+'</a>');
                   $('#menu_option_'+lsId+'_'+lsOrg+'_'+lsLevel).attr("onclick","goToPage('"+lsTarget+"','"+lsSrc+"','"+lsId+"','"+lsName+"','"+lsOrg+"',"+lbUseOpts+",'"+lsHelp+"','"+lsConf+"')");
                   
                   if(lsOwner != ""){
                       $('#icon_owner_'+lsId).attr("oncontextmenu","showMailConfirm('"+lsOwner+"','"+lsId+"','"+lsName+"')");
                   }
                        
                } 
               
            }
        }
        hideLoading();
    };
    this.getRemoteServiceUrl = function(){
        var loContext = this;
        var lsSrc = DataUtils.getGeneralDataURL();
        $.post(lsSrc,{psParam:"appParam_remoteIntranetQueryService",psService:DataUtils.getXMLParamService() },
            function(poData) {
                poData = poData.replace(/^\s+|\s+$/g, '');
                if(poData != "")loContext.setIntUrl(poData);
                loContext.setXMLMenuData();
        });
    };
    this.setIntUrl = function(psUrlIntCon){
         this.msUrlIntCon = psUrlIntCon;
    };
    this.getIntUrl = function(){
        return this.msUrlIntCon;
    };
    this.setXMLMenuData = function(){
        var loContext = this;
        var lsUrl = loContext.getIntUrl();
        var lsTest = requestSyncService(DataUtils.getGeneralDataURL(),{
                    psService:DataUtils.getURLCallService(),
                    psRowSeparator:"",
                    psColSeparator:"", 
                    psUrl:lsUrl,
                    psConn:"jdbc/EYUMV2",
                    psQuery:"SELECT dbo.[op_gps_fn_get_store_menu]("+this.getStoreId()+")",
                    psServiceToSend:"executeRemoteQuery"
                });
        this.msXMLMenu=lsTest;
        hideLoading();
    };
    this.getSectionContent = function(psOptionSelected){
         var loContext = this;
        var lsUrl = loContext.getIntUrl();
        var lsTest = requestSyncService(DataUtils.getGeneralDataURL(),{
                    psService:DataUtils.getURLCallService(),
                    psRowSeparator:"",
                    psColSeparator:"", 
                    psUrl:lsUrl,
                    psConn:"jdbc/EYUMV2",
                    psQuery:"SELECT dbo.[op_gps_fn_get_section_content]("+psOptionSelected+")",
                    psServiceToSend:"executeRemoteQuery"
                });
        return lsTest;
    };
    this.getMenuXML = function(){
         /*var lsTest = '<?xml version="1.0" encoding="ISO-8859-1"?>'+
        '<menu_options>'+
        '<option level="0" org="10" id="1" name="Opcion 1" target="" src="" owner="" use_options="false"/>'+
        '<option level="1" org="1005" id="1" name="Tester_1" target="" src="Templates/ABCGridPanel.html" owner="david.barrera@prb.com.mx" use_options="true" type="ABCGridPanel" xml_conf="sql_query_example" use_help="Templates/HelpTemplate.html"/>'+
        '<option level="1" org="1015" id="10" name="ABCMDGridPanel" target="" src="Templates/ABCMDGridPanel.html" owner="david.barrera@prb.com.mx" use_options="true" type="ABCMDGridPanel" xml_conf="sql_query_example" use_help="Templates/HelpTemplate.html"/>'+
        '<option level="1" org="1010" id="3" name="Opcion 1.2" target="" src="" owner="" use_options="false"/>'+
        '<option level="2" org="101005" id="4" name="Tester" target="" src="Tester.html" owner="" use_options="false" type="HTMLReportPanel" xml_conf="sql_html_query_example" use_help="Tester_q1.html"/>'+
        '<option level="0" org="20" id="5" name="Opcion 2" target="" src="" owner="" use_options="false"/>'+
        '<option level="1" org="2005" id="6" name="Opcion 2.1" target="_blank" src="http://www.yahoo.com" owner="david.barrera@prb.com.mx" use_options="true"/>'+
        '<option level="1" org="2010" id="7" name="Opcion 2.2" target="" src="" owner="" use_options="false"/>'+
        '<option level="2" org="201005" id="8" name="Opcion 2.2.1" target="" src="" owner="" use_options="false"/>'+
        '<option level="3" org="20100505" id="9" name="Opcion 2.2.1.1" target="" src="Tester2.html" owner="" use_options="false"/>'+
        '<option level="3" org="20100510" id="10" name="Opcion 2.2.1.2" target="_blank" src="Tester.html" owner="" use_options="false"/>'+
        '</menu_options>';*/
       
        return this.msXMLMenu;
    };
    this.openMenuFunction = function(psFilter,psSelectedOrg,psSelectedLevel){
          var loContext = this;
        
        var poDataNode = parseXML(this.getMenuXML());
        $('#divPRBMenu').html(' <div class="item"><div id="hide-sidebar" class="button"><font color=white>Cerrar<i class="close red icon"></i></font></div></div>');
        $('#hide-sidebar').click(function() {
                  hideMenu();
         });
         if(psSelectedLevel != "0"){
            $('#divPRBMenu').append( '<a class="item" id="btn_startmenu_0_'+psSelectedOrg+'_'+psSelectedLevel+'">Ir al inicio <i class="angle teal double left icon"></i></a>');
            $('#btn_startmenu_0_'+psSelectedOrg+'_'+psSelectedLevel).click(function() {
                loContext.openMenuFunction("","","0");
            });
            $('#divPRBMenu').append( '<a class="red item" id="btn_backmenu_0_'+psSelectedOrg+'_'+psSelectedLevel+'">Atr&aacute;s <i class="arrow red circle outline left icon"></i></a>');
            $('#btn_backmenu_0_'+psSelectedOrg+'_'+psSelectedLevel).click(function() {
                            var lsClickId = DataUtils.getValidValue(this.id.split("_")[2]);
                            var lsClickOrg = DataUtils.getValidValue(this.id.split("_")[3]);
                            var lsClickLevel = DataUtils.getValidValue(this.id.split("_")[4]);
                            loContext.openMenuFunction("",lsClickOrg.substring(0,lsClickOrg.length - 2),(parseInt(lsClickLevel)-1).toString());
                    });
        }
         
        var liOptionsLength = poDataNode.getElementsByTagName("menu_options")[0].getElementsByTagName("option").length;
        for(var liOptionCounter=0;liOptionCounter<liOptionsLength;liOptionCounter++){
            var loCurrentOption = poDataNode.getElementsByTagName("menu_options")[0].getElementsByTagName("option")[liOptionCounter];
            var lsId = DataUtils.getValidValue(loCurrentOption.getAttribute("id"),"");
            var lsLevel = DataUtils.getValidValue(loCurrentOption.getAttribute("level"),"0");
            var lsOrg = DataUtils.getValidValue(loCurrentOption.getAttribute("org"),"");
            var lsName = DataUtils.getValidValue(loCurrentOption.getAttribute("name"),"");
            var lsTarget = DataUtils.getValidValue(loCurrentOption.getAttribute("target"),"");
            var lsSrc = DataUtils.getValidValue(loCurrentOption.getAttribute("src"),"");
            var lsOwner = DataUtils.getValidValue(loCurrentOption.getAttribute("owner"),"");
            var lbUseOpts = DataUtils.getValidBoolean(loCurrentOption.getAttribute("use_options"),false);
            var lsHelp = DataUtils.getValidValue(loCurrentOption.getAttribute("use_help"),"");
            var lsConf = DataUtils.getValidValue(loCurrentOption.getAttribute("xml_conf"),"");
            if(psSelectedLevel == lsLevel && lsOrg.indexOf(psSelectedOrg) === 0 && lsName.toString().toLowerCase().indexOf(psFilter.toLowerCase()) != -1){
                $('#divPRBMenu').append( '<a href="javascript:void(0)" id="menu_option_'+lsId+'_'+lsOrg+'_'+lsLevel+'" class="item">'+lsName+((lsSrc != "")?'':'<i class="angle yellow right icon"></i>')+((lsOwner == "")?'':'<i id="icon_owner_'+lsId+'" class="edit orange outline icon"></i>')+'</a>');
                 //if(lsOwner != ""){
                       //$('#icon_owner_'+lsId).attr("oncontextmenu","showMailConfirm('"+lsOwner+"','"+lsId+"','"+lsName+"')");
                   //}
                if(lsSrc == ""){
                    $('#menu_option_'+lsId+'_'+lsOrg+'_'+lsLevel).click(function() {
                            var lsClickId = DataUtils.getValidValue(this.id.split("_")[2]);
                            var lsClickOrg = DataUtils.getValidValue(this.id.split("_")[3]);
                            var lsClickLevel = DataUtils.getValidValue(this.id.split("_")[4]);
                            loContext.openMenuFunction("",lsClickOrg,(parseInt(lsClickLevel)+1).toString());
                    });
                        
                } else {
                    $('#menu_option_'+lsId+'_'+lsOrg+'_'+lsLevel).attr("onclick","goToPage('"+lsTarget+"','"+lsSrc+"','"+lsId+"','"+lsName+"','"+lsOrg+"',"+lbUseOpts+",'"+lsHelp+"','"+lsConf+"')");
                    
                }
               
            }
        }
    };
    this.printOptionHeader = function(poObj){
        var lsHeaderString = '';
        lsHeaderString+='<div class="ui mini fixed menu">';
        lsHeaderString+='<div class=" inverted item">';
        lsHeaderString+='<i class="browser teal icon"></i>'+poObj.getOptionName()+''; //Title
        lsHeaderString+='</div>';
        lsHeaderString+='<div class="right mini menu">';
        if(poObj.getUseOpts()){
            lsHeaderString+='<div class="item" onclick="parent.openOptions('+poObj.getOptionId()+');"><i class="options inverted blue icon"></i>Opciones</div>';
        }
        lsHeaderString+='<div class="item"  onclick="parent.printOption('+poObj.getOptionId()+')" id="btnPrint_'+poObj.getOptionId()+'"><i class="print red icon"></i>Imprimir</div>';
        //lsHeaderString+='<div class="item" id="btnExport_'+poObj.getOptionId()+'" onclick="showExportOptions('+poObj.getOptionId()+')" data-html="';
        //lsHeaderString+='<button class=\'ui button\'><div class=\'item\'><img id=\'btnExportXLS_'+poObj.getOptionId()+'\' class=\'ui small button  circular image\' src=\'Resources/Images/Templates/xls_icon.png\'>XLS</div></div><img id=\'btnExportCSV_'+poObj.getOptionId()+'\' class=\'ui button small circular image\' src=\'Resources/Images/Templates/csv_icon.png\'><img id=\'btnExportPDF_'+poObj.getOptionId()+'\' class=\'ui button small circular image\' src=\'Resources/Images/Templates/pdf_icon.png\'>';
        //lsHeaderString+='<div id=\'exportToolBar_'+poObj.getOptionId()+'\' class=\'ui horizontal list\'><a onclick=parent.exportXLSOption('+poObj.getOptionId()+'); id=\'btnExportXLS_'+poObj.getOptionId()+'\' class=\'ui image label item\'><img src=\'Resources/Images/Templates/xls_icon.png\'>XLS</a><a onclick=parent.exportCSVOption('+poObj.getOptionId()+') id=\'btnExportCSV_'+poObj.getOptionId()+'\' class=\'ui image label item\'><img src=\'Resources/Images/Templates/csv_icon.png\'>CSV</a><a onclick=parent.exportPDFOption('+poObj.getOptionId()+') id=\'btnExportPDF_'+poObj.getOptionId()+'\' class=\'ui image label item\'><img src=\'Resources/Images/Templates/pdf_icon.png\'>PDF</a></div>';
        //lsHeaderString+='"><i class="download green icon"></i>Exportar</div>';
        lsHeaderString+='<div class="ui dropdown menu">  <div class="ui mini simple dropdown item">    Exportar    <i class="dropdown icon"></i>    <div class="menu">      <div class="ui image label item" onclick=parent.exportXLSOption('+poObj.getOptionId()+');><img src=\'/Resources/Images/Templates/xls_icon.png\'>XLS</div>      <div class="item" onclick=parent.exportCSVOption('+poObj.getOptionId()+')><img src=\'/Resources/Images/Templates/csv_icon.png\'>CSV</div>      <div class="item" onclick=parent.exportPDFOption('+poObj.getOptionId()+')><img src=\'/Resources/Images/Templates/pdf_icon.png\'>PDF</div>    </div>  </div></div>';
        if(poObj.getUseHelp() != "")lsHeaderString+='<div class="item" onclick="parent.showHelpOption('+poObj.getOptionId()+')"><i class="help yellow icon"></i>Ayuda</div>';
        lsHeaderString+='</div>';
        lsHeaderString+='</div>';
        
        $("#divTabPRBOption"+poObj.getOptionId()+"").contents().find("#divHeader").append(lsHeaderString);
          /*$("#btnExport_"+poObj.getOptionId()).popup({
              on:'click',
              hoverable:true
          });*/
          
          
             
    };
    this.parseUserData = function(poDataNode){
        var lsUser = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("user_id")[0].childNodes[0].nodeValue;
        var lsEmpId = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("employee_id")[0].childNodes[0].nodeValue;
        var lsEmail = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("email")[0].childNodes[0].nodeValue;
        var lsLevel = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("user_level")[0].childNodes[0].nodeValue;
        var lsOptions = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("user_options")[0].childNodes[0].nodeValue;
        var lsSelection = poDataNode.getElementsByTagName("user_data")[0].getElementsByTagName("option_selected")[0].childNodes[0].nodeValue;
        this.setUserData(lsUser,lsEmpId,lsEmail,lsLevel,lsOptions);
        //$(location).attr("href","MainPagePRB.html");
        $("#bdyMain").load("MainPagePRB.html");
        $("#bdyMain").css("overflow","hidden");
        if(lsSelection != ""){
            alert("Entramos opcion"+lsSelection);
        }
        
    };
    this.setStoreId = function(psStore){
        this.msStoreId = psStore;
    };
    this.getStoreId = function(){
        return this.msStoreId;
    };
    this.setStoreName = function(psStoreName){
        this.msStoreName = psStoreName;
    };
    this.getStoreName = function(){
        return this.msStoreName;
    };
    this.setCompany = function(psCompany){
        this.msCompany = psCompany;
    };
    this.getCompany = function(){
        return this.msCompany;
    };
    this.setIsStore = function(pbValue){
        this.mbIsStore = pbValue;
    };
    this.getIsStore = function(){
        return this.mbIsStore;
    };
    this.loadPromoImg = function(){
        var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getPromoFileService()}));
        var lsImgData = loResponse.getData();
        
        for (var li = 0; li < lsImgData.split(DataUtils.getSingleTextSpliter()).length-1; li ++) { 
            var lsImg = lsImgData.split(DataUtils.getSingleTextSpliter())[li];
            $("#divReelImg").append( '<center><div class="slide"><a href = "Resources/Images/Promotions/New/'+lsImg+'" target=_blank><img src="Resources/Images/Promotions/New/'+lsImg+'" height="300" align="center" alt="Promo<%=li%>" border=0 /></a></div></center>');
        }
    };
    this.printUserId = function(){
        $("#spnUserLabel").html(this.getStoreName());
    };
    this.getUserId = function(){
      return this.msUser;
    };
    this.initSnow = function(){
        $(document).ready( function(){
            $.fn.snow({
            minSize: 40, 
            maxSize: 70, 
            newOn: 1250, 
            flakeColor: '#00FFFF' 
            });
         });
    };
    this.showAlertWindow = function(psMsg,psBtns,pbClosable){
         if(pbClosable == null)pbClosable=true;
        $('#divAlert').modal('setting', 'closable', pbClosable);
        $('#divAlert').modal('setting', 'transition', 'shake')
        $('#divAlert').modal('show');
        $('#divAlertMsg').html(psMsg);
        $('#divAlertAction').html(psBtns);
    };
    this.hideAlertWindow = function(){
        $('#divAlert').modal('hide');
    };
    this.validateSession = function(){
        var loResponse = new XMLResponse(requestSyncService(DataUtils.getGeneralDataURL(),{psService:DataUtils.getValidateSessionService()}));
        return loResponse;
    };
    this.showLoginWindow = function(){
        if(this.validateSession().getData() == DataUtils.getInValidSessionStatus()){
            $('#divLogin').modal('show');
        } else{
            this.restoreSession();
        }
            
    };
    this.hideLoginWindow = function(){
        $('#divLogin').modal('hide');
    };
    this.initHRefListenner  = function (){ 
        $(function () {
            $('a[href^="#"]').click(function(event) {
                var lsID = $(this).attr("href");
                var liOffset = 20;
                var loTarget = $(lsID).offset().top - liOffset;
                $('html, body').animate({scrollTop:loTarget}, 500);
                    event.preventDefault();
                });
            }
        );
    };  
    this.hideIfStoreOptions = function(){
        var loContext = this;
        $(document).ready(function(){
            if(loContext.getIsStore()){
                $('#liRecpts').hide();
                $('#one').hide();
            }
            
        });
        
    };
                    
}


////////////////////////////////////////////////////////////////////////////////////////////////
//////////                           HASH
////////////////////////////////////////////////////////////////////////////////////////////////
function Hash() {
	//Miembros publicos
	this.miLength = 0;
	this.maItems = new Array();

	//Constructor
	for (var li = 0; li < arguments.length; li+=2) {
		if (typeof(arguments[li + 1]) != 'undefined') {
			this.maItems[arguments[li]] = arguments[li + 1];
			this.miLength++;
		}
	}
        
        this.getLength = function() {
            return this.miLength;
        }
        
        this.hasItems = function() {
            return this.getLength()>0;
        }
   
	this.removeItem = function(psKey) {
		var msValue;
               if (typeof(this.maItems[psKey]) != 'undefined') {
			this.miLength--;
			msValue = this.maItems[psKey];
			delete(this.maItems[psKey]);
		}
	   
		return msValue;
	}

	this.getItem = function(psKey) {
            return this.maItems[psKey];
	}
        
        this.getItems = function() {
            return this.maItems;
        }
        
        this.getArray = function() {
            var laData = new Array();
            var liIndex = 0;
            
            for (var lsKey in this.maItems) {
                laData[liIndex++] = this.maItems[lsKey];
            }
            
            return laData;
        }

        this.getFirstKey = function() {
            var lsKey;

            for (lsKey in this.maItems) { break; }

            return lsKey;
        }
            
        this.getLastKey = function() {
            var lsLastKey = "-1";
            
            for (var lsKey in this.maItems) {
                lsLastKey = lsKey;
            }
            
            return lsLastKey;
        }

        this.getFirst = function() {
            var lsKey;
            for (lsKey in this.maItems) {break;}

            return this.getItem(lsKey);
        }

        this.getLast = function() {
            var lsKey;
            for (lsKey in this.maItems) {}

            return this.getItem(lsKey);
        }


	this.hasItem = function(psKey) {
		return(typeof(this.maItems[psKey]) != 'undefined');
	}

	this.setItem = function(psKey, psValue) {
		if (typeof(psValue) != 'undefined') {
			if (!this.hasItem(psKey)) {
				this.miLength++;
			}

			this.maItems[psKey] = psValue;
		}
	   
		return(psValue);
	}
        
        this.removeAll = function() {
            this.miLength = 0;
            this.maItems = new Array();
        }
        
        this.addItemsFromHash = function(poHash) {
            if (poHash==null) return;
            
            for (var lsKey in poHash.maItems) {
                if (!this.hasItem(lsKey)) this.setItem(lsKey, poHash.maItems[lsKey]);
            }
        }
        
        this.setItemsFromHash = function(poHash) {
            this.removeAll();
            if (poHash==null) return;
            this.addItemsFromHash(poHash);
        }
        
        this.setArrayItem = function(psKey, poValue) {
		if (typeof(poValue) != 'undefined') {
			if (!this.hasItem(psKey)) {
				this.miLength++;
				this.maItems[psKey] = new Array();
			}

			this.maItems[psKey].push(poValue);
		}
	   
		return(poValue);
	}
            
        this.toString = function() {
            var lsKey;
            var lsString = "{";
            
            for (lsKey in this.maItems) {
                lsString+=lsKey + "=" + this.maItems[lsKey] + ","
            }
            
            return lsString + "}";
        }
}