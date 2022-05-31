<%-- 
    Document   : BioRestHandler
    Created on : 29/04/2019, 07:14:31 PM
    Author     : DAB1379
--%>
<%@page import="yum.e3.server.generals.utils.DataUtils"%>
<%
    String lsService = DataUtils.getValidValue(request.getParameter("psService"),"");
    String lsAction = DataUtils.getValidValue(request.getParameter("psAction"),"");
    String lsToken = "GhTTwAgnl%2BM99X7lca9I5IKbwKXkf7hCKO6xxUOhm8KBIsRMMKn9CYRnVg1BmxulJ4pWUPiYZu%2BOJmH/12Bb%2B2jqFi2BAILK2dSZNsBVD8h/4Qn4rurqZj7deZXfHreM";
    String lsStore = DataUtils.getValidValue(request.getParameter("psStore"),"");
    String lsIP =  DataUtils.getValidValue(request.getParameter("psIp"),"");
    String lsEmpId = DataUtils.getValidValue(request.getParameter("psEmpId"),"");
    String lsUser = DataUtils.getValidValue(request.getParameter("psUser"),"");
    String lsShowConfirm = DataUtils.getValidValue(request.getParameter("psShowConfirm"),"false");
    String lsConfirmMsg = DataUtils.getValidValue(request.getParameter("psConfirmMsg"),"¿Seguro que deseas realizar la acción?");
%>
<!DOCTYPE html>
<html>
    <head>
        <style>
          .loading {
                border: 1px solid #ccc;
                position:relative;
                width:300px;
                padding: 2px;
                z-index: 20001;
                height: auto;
            }
     </style>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>BioHandler</title>
        <script src="../js/jquery/jquery-1.6.2.min.js"></script>
         <script type="text/javascript">
           function getService(){
               var lsUrl;
               document.getElementById("divLoadingBio").style.visibility="visible";
               document.getElementById("divResult").style.visibility="hidden";
               
                var lbConfirmation = false;
               if('<%=lsShowConfirm%>' == "true")  {
                   lbConfirmation = confirm("<%=lsConfirmMsg%>");
               } else {
                   lbConfirmation = true;
               }
               if(lbConfirmation)   {
               
               
                    $(document).ready(function () {    

                             $.ajax({

                                    url: 'http://mexapp32/RESTBio/api/<%=lsService%>?psIp=<%=lsIP%>&psStore=<%=lsStore%>&psAction=<%=lsAction%>&psEmpId=<%=lsEmpId%>&psToken=<%=lsToken%>&psUser=<%=lsUser%>',
                                    
                                    
                                    type: 'GET',
                                    success: function (data) {
                                        document.getElementById("divLoadingBio").style.visibility="hidden";
                                        document.getElementById("spStatus").innerHTML=(data.Status)?"<font color=green>Ejecuci&oacute;n exitosa</font>":"<font color=red>Error</font>";
                                        document.getElementById("spMessage").innerHTML=data.Message;
                                        document.getElementById("divResult").style.visibility="visible";
                                    },
                                    error: function () {
                                        document.getElementById("divLoadingBio").style.visibility="hidden";
                                        document.getElementById("spStatus").innerHTML="<font color=red>Error</font>";
                                        document.getElementById("spMessage").innerHTML="Ocurrió un problema, por favor intenta nuevamente";
                                        document.getElementById("divResult").style.visibility="visible";
                                    }
                                });


                    });
                 } else {
                        document.getElementById("divLoadingBio").style.visibility="hidden";
                        document.getElementById("spStatus").innerHTML="<font color=yellow>Alerta</font>";
                        document.getElementById("spMessage").innerHTML="Cancelaste la acción";
                        document.getElementById("divResult").style.visibility="visible";
                        
                     }
           }
           
       </script>

    </head>
    <body onload="getService()">
         <div id="divLoadingBio" style ="position:absolute;visibility:hidden;"> 
            <div id="divLoadBio" class = "loading" align ="left">
                <div class="loadingIndicator"> 
                    <img src="/smartE3/images/e3/ui/explorer/loading.gif" width="32" height="32" />
                    <span id="spnLoadingMsg" class = "loadingMsg">Espere por favor... </span>
                    <br>
                    <br>
                </div> 
            </div> 
        </div>
        <div id="divResult">
            <table style="border:2px solid gray;">
                <tr style="border:1px solid gray">
                    <td style="background:#E9ECEE">Resultado</td>
                    <td>
                        <span id="spStatus"></span>
                    </td>
                </tr>
                 <tr style="heigth:200px;overflow:auto">
                    <td style="background:#E9ECEE">Detalle</td>
                    <td >
                        <span id="spMessage"></span>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
