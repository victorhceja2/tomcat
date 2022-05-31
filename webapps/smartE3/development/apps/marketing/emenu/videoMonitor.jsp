<%-- 
    Document   : videoMonitor
    Created on : 25/05/2015, 11:00:39 AM
    Author     : DAB1379
--%>

<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>
<%
    String msScreenID = request.getParameter("psScreenID");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>JSP Page</title>
        <script type="text/javascript">
            function load()
            {   
                var lsVideoNames;
                var lsArrayList = window.parent._e3_gaArrayList;
                var lsID = <%=msScreenID%>;
                
                for(var i=0;i<lsArrayList.length;i++){
                    if(lsArrayList[i][0]==lsID)
                        lsVideoNames=lsArrayList[i][1];
                     //document.getElementById("prueba").innerHTML = lsVideoNames[0][0];   
                }
                var lsVideoSize = window.parent._e3_gaVideoSize;
                document.getElementById("video1").src = "/smartE3/development/apps/marketing/emenu/video/"+lsVideoNames[0][0];
                document.getElementById("video1").style.width = lsVideoSize+"px"; 
                //document.getElementById("prueba").innerHTML = lsVideoNames[0][1];
            }
            //<h1 id="prueba"></h1>
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body onload="load()"> 
        
<video id="video1" onended="videoEnded()" onclick="playPause()" autoplay>
</video>

<script> 
    var count=0;
    var lsVideoNames;
                var lsArrayList = window.parent._e3_gaArrayList;
                var lsID = <%=msScreenID%>;
                
                for(var i=0;i<lsArrayList.length;i++){
                    if(lsArrayList[i][0]==lsID)
                        lsVideoNames=lsArrayList[i][1];
                     //document.getElementById("prueba").innerHTML = lsVideoNames;   
                }
    var loVideoList = lsVideoNames.length;
    var myVideo = document.getElementById("video1");
    var loVideoRepeat = lsVideoNames[0][1];
    
    function playPause() { 
        if (myVideo.paused) 
            myVideo.play(); 
        else 
            myVideo.pause(); 
    } 
    function videoEnded(){
        if(loVideoRepeat>0){
            loVideoRepeat--;
            myVideo.play();
        }
        else{   
            count++;
            loVideoRepeat = lsVideoNames[count%loVideoList][1];
            myVideo.src = "/smartE3/development/apps/marketing/emenu/video/"+lsVideoNames[count%loVideoList][0];
            myVideo.play();
        }
    }
</script> 
</body> 
</html>
