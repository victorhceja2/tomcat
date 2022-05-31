<%-- 
    Document   : ePremiumMainPage
    Created on : 22/12/2014, 01:35:48 PM
    Author     : DAB1379
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <link rel="icon" href="images/e3/ui/explorer/main_page/favicon.ico" type="image/x-icon" />
        
        <title>e-Premium Main Page</title>
    </head>
    <link rel="stylesheet" type="text/css" href="resources/css/main_page.css" media="screen" />
    <script type="text/javascript" src="resources/js/flot/jquery.min.js"></script>
    <script>
    var msServerIp = "127.0.0.1";
    document.oncontextmenu=new Function("return false");
    function openUtilsLink(psUrl,piEmbed,psContent){
        var lsUrl = psUrl.replace("_app_server_ip_","http://"+msServerIp);
        if(piEmbed == "true"){
            manageDivLink(true,lsUrl,psContent);
        }
        else{
            var win = window.open(lsUrl, '_blank');
            win.focus();
        }
    }
    function initPage(){
        getServerIp();
    }
    function getServerIp(){
          $.post("/smartE3/DataService",{psService: "getServerIp"},
          function(psData) {
            msServerIp = psData.replace(/\s/g,"");
            //msServerIp = "192.168.110.219";
            updateAllData();
        },"text");
    }
    function upperCase(poObj){
        poObj.value = poObj.value.toUpperCase();
    }
    function  updateAllData(){
          var lsBirthDayQuery = "SELECT html_content.*"
          lsBirthDayQuery+=" FROM dblink('dbname=dbeyum',";
          lsBirthDayQuery+=" 'SELECT html_data FROM ss_grl_vw_daily_birthday ORDER BY sorter";
          lsBirthDayQuery+=" ')AS html_content(code varchar(8000));";
          var lsAnivQuery = "SELECT html_content.*";
          lsAnivQuery+=" FROM dblink('dbname=dbeyum',";
          lsAnivQuery+=" 'SELECT html_data FROM ss_grl_vw_daily_aniversary ORDER BY sorter";
          lsAnivQuery+=" ')AS html_content(code varchar(8000));";
          var lsDateQuery = "SELECT html_data FROM ss_grl_vw_daily_date";
          var lsUtilsQuery =  "SELECT content_desc,link,is_new,embed,COALESCE(icon,'') AS icon FROM ss_grl_main_content ";
          lsUtilsQuery+="WHERE active = '1' ";
          lsUtilsQuery+="ORDER BY is_new DESC,content_desc ";
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsBirthDayQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"",psColSeparator:""},
                function(psData) {
                    if(psData != ""){
                        document.getElementById("divBirthday").innerHTML = psData;
                    }
                },"text");
                
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsAnivQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"",psColSeparator:""},
                function(psData) {
                    if(psData != ""){
                        document.getElementById("divAniversary").innerHTML = psData;
                    }
                },"text");
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsDateQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"",psColSeparator:""},
                function(psData) {
                    if(psData != "")
                        document.getElementById("divDate").innerHTML = psData;
                },"text");
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsUtilsQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"_||_",psColSeparator:"_|||_"},
                function(psData) {
                    var lsData = psData;
                    if(lsData != ""){
                        var lsHTML = "<table width='100%' >";
                        for(var li=0;li<lsData.split("_||_").length;li++){
                            var lsRow = lsData.split("_||_")[li];
                            lsHTML+="<tr  height='30px'>";
                            lsHTML+="<td class='btn-utils' >";
                            lsHTML+="<center>";
                            
                            lsHTML+="<img src='images/e3/ui/explorer/main_page/"+((lsRow.replace(/\s/g,"").split("_|||_")[4] == "")?"tack.png":lsRow.split("_|||_")[4])+"' width='20'>";
                            lsHTML+="</center>";
                            lsHTML+="</td>";
                            lsHTML+="<td class='txt-utils' onclick=openUtilsLink('"+lsRow.split("_|||_")[1]+"','"+lsRow.split("_|||_")[3]+"',this.innerHTML)>";
                            lsHTML+="<table>";
                            lsHTML+="<tr>";
                            lsHTML+="<td>";
                            if(lsRow.split("_|||_")[2] == "true")
                                lsHTML+="<img src='images/e3/ui/explorer/main_page/new.png' width='30'>";
                            lsHTML+="</td>";
                            lsHTML+="<td height='30px' >";
                            lsHTML+=lsRow.split("_|||_")[0];
                            lsHTML+="</td>";
                            lsHTML+="</tr>";
                            lsHTML+="</table>";
                            lsHTML+="</td>";
                            lsHTML+="</tr>";
                        }
                        document.getElementById("divUtils").innerHTML = lsHTML;
                    }
                },"text");      
      }
      function getBirthdayData(){
          var lsBirthDayQuery = "SELECT html_content.*"
          lsBirthDayQuery+=" FROM dblink('dbname=dbeyum',";
          lsBirthDayQuery+=" 'SELECT html_data FROM ss_grl_vw_daily_birthday ORDER BY sorter";
          lsBirthDayQuery+=" ')AS html_content(code varchar(8000));";
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsBirthDayQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"_||_",psColSeparator:""},
                function(psData) {
                    
                    if(psData.replace(/\s/g,"") != ""){
                        var lsHTML = '<table width="585px">'
                        for(var li=0;li<psData.split("_||_").length;li++){
                            lsHTML+= '<tr class="btn-container" ><td><img src="images/e3/ui/explorer/main_page/pointer.png" width=20px /></td><td >'+psData.split("_||_")[li].replace("-","")+'</td></tr>';
                        }
                        lsHTML+="</table>"
                        document.getElementById("divBirthdayBig").innerHTML = lsHTML;
                        
                    }
                },"text");
      }
        function getAniversaryData(){
          var lsAnivQuery = "SELECT html_content.*";
          lsAnivQuery+=" FROM dblink('dbname=dbeyum',";
          lsAnivQuery+=" 'SELECT html_data FROM ss_grl_vw_daily_aniversary ORDER BY sorter";
          lsAnivQuery+=" ')AS html_content(code varchar(8000));";
          $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsAnivQuery, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"_||_",psColSeparator:""},
                function(psData) {
                    if(psData.replace(/\s/g,"") != ""){
                        var lsHTML = '<table width="585px">'
                        for(var li=0;li<psData.split("_||_").length;li++){
                            lsHTML+= '<tr class="btn-container" ><td><img src="images/e3/ui/explorer/main_page/pointer.png" width=20px /></td><td >'+psData.split("_||_")[li].replace("-","")+'</td></tr>';
                        }
                        lsHTML+="</table>"
                        document.getElementById("divAniversaryBig").innerHTML = lsHTML;
                    }
                },"text");
      }
      function openLink(piOption){
          if(piOption == 1){
              location.href="smartE3.html"
          }
          else{
              location.href="http://www.prb.net";
          }
          
      }
      function manageDivAniversary(pbShow){
          if(pbShow){
              document.getElementById("divAniversaryComplete").style.visibility="visible"
              getAniversaryData();
          }
          else
              document.getElementById("divAniversaryComplete").style.visibility="hidden"
      }
      function manageDivBirthday(pbShow){
          if(pbShow){
              document.getElementById("divBirthdayComplete").style.visibility="visible"
              getBirthdayData();
          }
          else{
              document.getElementById("divBirthdayComplete").style.visibility="hidden"
          }
      }
       function manageDivAlert(pbShow,psContent){
          if(pbShow){
              document.getElementById("divAlertComplete").style.visibility="visible"
              document.getElementById("divAlertText").innerHTML=psContent;
          }
          else{
              document.getElementById("divAlertComplete").style.visibility="hidden"
              document.getElementById("divAlertText").innerHTML="";
          }
      }
     
      function manageDivLink(pbShow,psUrl,psContent){
          
          if(pbShow){
              document.getElementById("divLink").style.visibility="visible";
              document.getElementById("divLink").style.width=screen.width+"px";
              document.getElementById("divLink").style.height=screen.height+"px";
              document.getElementById("ifrLink").src=psUrl;
              document.getElementById("ifrLink").style.width=screen.width*0.85+"px";
              document.getElementById("ifrLink").style.height=screen.height*0.70+"px";
              document.getElementById("tdLinkContent").innerHTML="<table><tr><td><img src='images/e3/ui/explorer/main_page/tack.png' width=50px/></td><td class='big'>"+psContent+"</td></tr></table>";
              
          }
          else{
              document.getElementById("divLink").style.visibility="hidden"
              document.getElementById("ifrLink").src="about:blank";
          }
      }
      function manageSize(){
          document.getElementById("divBirthdayComplete").style.width=screen.width+"px";
          document.getElementById("divBirthdayComplete").style.height=screen.height+"px";
          document.getElementById("divAniversaryComplete").style.width=screen.width+"px";
          document.getElementById("divAniversaryComplete").style.height=screen.height+"px";
      }
      function searchContent(){
          var loText = document.getElementById("txtSearch");
          if(loText.value == ""){
              addAlert("Por favor escribe el contenido que deseas buscar",loText.focus());
          }
          else{
              var lsSearchQry="SELECT * FROM ss_grl_fn_main_search('"+loText.value+"')";
              $.post("/smartE3/DataService",{psService: "getQueryData", psQuery: lsSearchQry, psConnectionPool: "jdbc/storeDBConnectionPool",psRowSeparator:"",psColSeparator:""},
                function(psData) {
                    document.getElementById("divMainSearchContent").innerHTML = '<center><table width="100%">'+psData+'</table></center>';
                },"text");
              
          }
      }
      function addAlert(psMsg,psFunction){
          //alert(psMsg);
          manageDivAlert(true,psMsg);
          eval(psFunction);
      }
    </script>
    <body onload="initPage();" onresize="manageSize();">
        <center>
            <div id="divBirthdayComplete" ondblclick="manageDivBirthday(false);" class="blocked">
                <center>
                <div id="divBirthdayContent" class="content">
                    <center>
                    <table>
                        <tr class="btn-container">
                            <td>
                               <img src="images/e3/ui/explorer/main_page/present.png" width="538px"/> 
                               
                            </td>
                            <td>
                               <img src="images/e3/ui/explorer/main_page/close.png" onmouseover='this.src="images/e3/ui/explorer/main_page/close_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/close.png"' onclick="manageDivBirthday(false);" width="50px"/>  
                            </td>
                        </tr>
                    </table>
                    <table  style="overflow:auto;">
                        <tr>
                            <td>
                                <div id="divBirthdayBig" class="medium" style="width:605px;height:390px;overflow:auto;">
                                
                                </div>
                            </td>
                        </tr>
                    </table>
                    </center>
                </div>
                </center>
            </div>
            <div id="divAniversaryComplete"  ondblclick="manageDivAniversary(false);"  class="blocked">
                <center>
                 <div id="divAniversaryContent"  class="content">
                     <center>
                    <table>
                        <tr class="btn-container">
                            <td>
                               <img src="images/e3/ui/explorer/main_page/aniversary.png" width="538px"/> 
                            </td>
                            <td>
                               <img src="images/e3/ui/explorer/main_page/close.png"  onmouseover='this.src="images/e3/ui/explorer/main_page/close_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/close.png"' onclick="manageDivAniversary(false);" width="50px"/>  
                            </td>
                        </tr>
                    </table>
                    <table style="overflow:auto;">
                        <tr>
                            <td>
                                <div id="divAniversaryBig" class="medium"  style="width:605px;height:390px;overflow:auto;">
                                
                                </div>
                            </td>
                        </tr>
                    </table>
                    </center>
                </div>
                </center>
            </div>
            <div id="divLink"  ondblclick="manageDivLink(false,'');" class="blocked">
                <center>
                 <div id="divLinkContent"  class="link" >
                     <center>
                    <table>
                        <tr class="btn-container">
                            <td id="tdLinkContent">
                               <!--img src="images/e3/ui/explorer/main_page/tack.png" width="538px"/--> 
                               
                            </td>
                            <td>
                               <img src="images/e3/ui/explorer/main_page/close.png"  onmouseover='this.src="images/e3/ui/explorer/main_page/close_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/close.png"' onclick="manageDivLink(false,'');" width="50px"/>  
                            </td>
                        </tr>
                    </table>
                    <table style="overflow:auto;">
                        <tr>
                            <td>
                                <iframe id="ifrLink" name="ifrLink" src="" style="width:100%;height:100%;overflow:auto;">
                                </iframe>
                            </td>
                        </tr>
                    </table>
                    </center>
                </div>
                </center>
            </div>
            <div id="divAlertComplete" ondblclick="manageDivAlert(false,'');" class="blocked">
                 <center>
                     <div id="divAlertContent"  class="alert" >
                         <div style="margin-top:50px;height:180px;" class="medium" id="divAlertText">
                             &nbsp;
                         </div>
                         <div style="margin-bottom:10px">
                             <img src="images/e3/ui/explorer/main_page/accept.png"  onmouseover='this.src="images/e3/ui/explorer/main_page/accept_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/accept.png"' onclick="manageDivAlert(false,'');"/>
                         </div>
                     </div>
                 </center>
            </div>
            <div id="divHeader" class="main-div">
                <table style="width:100%" rowspan="0" >
                    <tr valign="bottom" class="text-header" style='width:910px' height="113px">
                        <td colspan="5" height="110px" style='width:910px' align="center">
                            <table bgcolor="#FF5B16" style='width:905px;height:110px'  cellpadding="0" cellspacing="0">
                                <tr>
                                    <td colspan="5">
                                        <img src="Images/MainPage/header_altern.png" width="905px" height='115px' usemap="#Map"/>
                                    </td>
                                </tr>
                                <tr style='height:30px'  > 
                                    <td colspan="5" background="Images/MainPage/headLine.jpg">
                                        <table>
                                            <tr>
                                                <td class='header-btn' onclick="openLink(1)" >
                                                    e-Premium
                                                </td>
                                                <td  class='header-btn' onclick="openLink(2)">
                                                    Intranet
                                                </td>
                                                <td class='header-btn' onclick="openLink(3)">
                                                    e-Reportes
                                                </td>    
                                                
                                               
                                            </tr>
                                            
                                        </table>
                                    </td>
                                    
                                    
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <center>
                                <table class="border">
                                    <tr class="btn-container">
                                        <td>
                                            <center>
                                                <img src="images/e3/ui/explorer/main_page/calendar.png" width="140px"/>
                                            </center>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='2'>
                                             <div id="divDate" style="display:block; overflow:hidden; height:109px; width:290px;">
                                                
                                            </div>
                                        </td>
                                    </tr>
                                    
                                </table>
                            </center>
                        </td>
                         <td>
                            <table class="border">
                                <tr  class="btn-container">
                                   <td>
                                        <center>
                                            <img src="images/e3/ui/explorer/main_page/aniversary.png" width="210px"/>
                                        </center>
                                    </td>
                                    
                                </tr>
                                <tr>
                                        <td colspan='2'>
                                             <div id="divAniversary" class="block_mini">
                                                
                                            </div>
                                        </td>
                                </tr>
                                 <tr>
                                        <td align="right">
                                           <img src="images/e3/ui/explorer/main_page/plus.png"  onmouseover='this.src="images/e3/ui/explorer/main_page/plus_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/plus.png"'  onclick="manageDivAniversary(true);" width="20px"/> 
                                        </td>
                                </tr>    
                            </table>
                        </td>
                         <td>
                            <table class="border">
                                <tr  class="btn-container">
                                   <td>
                                        <center>
                                            <img src="images/e3/ui/explorer/main_page/present.png" width="200px" height="40px"/>
                                        </center>
                                    </td>
                                    
                                </tr>
                                <tr>
                                        <td colspan='2'>
                                             <div id="divBirthday" class="block_mini">
                                                
                                            </div>
                                        </td>
                                </tr>
                                 <tr>
                                        <td align="right">
                                           <img src="images/e3/ui/explorer/main_page/plus.png"  onmouseover='this.src="images/e3/ui/explorer/main_page/plus_hover.png"' onmouseout='this.src="images/e3/ui/explorer/main_page/plus.png"' onclick="manageDivBirthday(true);" width="20px"/> 
                                        </td>
                                 </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td>
                             <table class="utils">
                                <tr  class="btn-container">
                                   <td>
                                        <img src="images/e3/ui/explorer/main_page/utils.png" width="200px"/>
                                    </td>
                                    
                                </tr>
                                <tr  >
                                        <td colspan='2'>
                                             <div id="divUtils" style="display:block; overflow:hidden; height:340px; width:290px;">
                                                 
                                            </div>
                                        </td>
                                    </tr>
                            </table>
                        </td>
                        <td colspan="2">
                            <div class="main-search" id="divMainSearchContent" style="display:block; overflow:auto; height:400px; width:600px;">
                                <center>
                                    <br>
                                    <br>
                                    <br>
                                    <br>
                                    <br>
                                    <br>
                                <table>
                                    <tr class="medium">
                                        <td align="center">
                                            Escribe lo que deseas y presiona el bot&oacute;n<br><br><br><img src="images/e3/ui/explorer/main_page/search.png" width="200"/>
                                        </td>    
                                    </tr>
                                </table>
                                </center>
                            </div>
                            
                        </td>
                    </tr>
                </table>
                
            </div>
            <br>
            <div class='footer' id='divFooter'><img src="images/e3/ui/explorer/main_page/footer.png"/></div>
         
        </center>
    
    </body>
    <script>
        manageDivAniversary(false);
        manageDivBirthday(false);
        manageDivLink(false);
        manageDivAlert(false);
    </script>
</html>
