<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%
   String msOrgId=(request.getParameter("psOrgId")==null)?"":request.getParameter("psOrgId");
   String msStoreId=(request.getParameter("psStore")==null)?"":request.getParameter("psStore");
   String msDate=(request.getParameter("psDate")==null)?"":request.getParameter("psDate");
   String msZoom=(request.getParameter("psZoom")==null)?"":request.getParameter("psZoom");
   
%>
<html>
    <head>
        <style>
		 
	
	    </style>  
            <title>World Class Operations</title>
            <link rel="icon" href="/smartE3/images/e3/ui/wco/store.png" type="image/x-icon" />
            <link rel="stylesheet" type="text/css" href="/smartE3/resources/css/posit_generals.css" media="screen" />
            <link rel="stylesheet" type="text/css" href="/smartE3/resources/css/delivery_ranking.css" media="screen" />
	    <script type="text/javascript" src="/smartE3/resources/js/jquery/jquery-1.6.2.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.pie.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.1.0.1.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/justgage/raphael.2.1.2.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/generals/utils.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/generals/wco_del_ranking.js"></script>
            <script>
             var moAppHandler = new AppHandler();
             moAppHandler.init('<%=msStoreId%>','<%=msOrgId%>','<%=msDate%>','<%=msZoom%>');
                  
            function adjustZoom(piZoom){  
                document.body.style.zoom=""+piZoom.trim()+"%";
            }
            
            </script>
    
        </head>
    <body style="background:#F2F2F2" onload="setIntitialData()" onresize="resizeTable();">
        <div id="divMainTable" style="background: white">
        <table id="tdMainTable" style="width:100%;background: white">
            <tr class="header">
                <td colspan="2" align="center">
                    <table style="width: 100%">
                         <tr>
                            
                            <td rowspan="2" width="300">
                                LIDERES EN DOMICILIO
                            </td>
                            <td  rowspan="2" id="tdDate" width="150">
                                <font size="7px"></font> 
                            </td>
                            <td width="70" rowspan="2" align="rigth">
                                <img  src="/smartE3/images/e3/ui/wco/clock_pos.png" width="40px" />
                            </td>
                            <td  rowspan="2" id="tdHour" width="100">
                                <font size="5px">0:00</font> 
                            </td>
                            <td id="tdStoreName" width="250">
                                
                            </td>
                            <td width="150" rowspan="2" align="rigth">
                                <table>
                                    <tr>
                                        <td>
                                        <center><span id="tdPosition"></span></center>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <img  src="/smartE3/images/e3/ui/wco/podium.png" width="100%" />
                                        </td>
                                    </tr>
                                </table>
                                
                            </td>
                        </tr>
                        <!--tr>
                         
                            <td width="60" align="rigth">
                                <img id="imgHeader" src="smartE3/images/e3/ui/wco/fp.png" width="60px" />
                                <font size="3px">Número<br>(Huella)</font>
                               
                            </td>
                          
                            <td width="50" align="left">
                               <img id="imgHeader" src="smartE3/images/e3/ui/wco/plan.png" width="70px" />
                                <font size="3px">Número(Horarios)</font>
                            </td>
                        </tr-->
                      
                    </table>
                </td>
            </tr>
            <tr id="tdOrderContainer">
              
                <td>
                    
                    <table id="tblRep" style="background: white;width: 100%;height:100%;overflow-y: auto; border-collapse: collapse;" align="top">
                     
                    
                     
                        
                    </table>
                    <script>
                        resizeTable();
                    </script>    
                </td>
                
            </tr>
            

        </table>
            </div>
    </body>
  
</html>
