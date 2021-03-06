<%
    String lsArea = request.getParameter("psDepartment");
    
%>    
<html>
    <head>
        <title>Resultados encuesta
            </title>
        <style>
            //@import url(//fonts.googleapis.com/css?family=Open+Sans);
            body{font-family: 'Open Sans', sans-serif;}
            h1{color:orangered;text-align: center;
             font-family: 'Open Sans', sans-serif; background-color: #EAECEC;
            border-radius: 3px;}
            .rounded{
                border-radius: 3px;
                border:solid 3px gray;
                -webkit-print-color-adjust: exact;
            }
            .rounded_min{
                border-radius: 3px;
                border:solid 1px gray;
                -webkit-print-color-adjust: exact;
            }
             .rounded_max{
                width:600px;
                border-radius: 3px;
                border:solid 1px gray;
                -webkit-print-color-adjust: exact;
            }
            .section{
                font-weight: bold;
                color:#0FD9AB;
                width: 100%;
                background-color: #F2F7F6;
            }
            span{
                border-radius: 2px;
                border:solid 1px gray;
                 display: inline-block ;
                 -webkit-print-color-adjust: exact;
            }
        </style>
        <script language="javascript" type="text/javascript" src="results.js"></script>
        <script>
            var laSurveyArray = [];
            var laDepartmenteArray = [] ;
            var laSectionArray = [];
            var laQuestionArray = [];
            var laQuestionNameArray = [];
            var laTotalSectionArray = [];
            var laAnswerDescArray = [];
            
            laSurveyArray = [

    ];
         function getResults(){
		/*	
             for(var li=0;li<laResultArray.length;li++){
                 if(!checkIfExists(laDepartmenteArray,laResultArray[li][0])){
                     laDepartmenteArray.push(laResultArray[li][0]);
                 }
             }*/
             laDepartmenteArray.push('<%=lsArea%>');
			 
             for(var li=0;li<laResultArray.length;li++){
                 if(!checkIfExists(laSectionArray,laResultArray[li][5])){
                     laSectionArray.push(laResultArray[li][5]);
                 }
             }
             for(var li=0;li<laDepartmenteArray.length;li++){
                 laSurveyArray = [];
                 writeToDiv("<h1>"+laDepartmenteArray[li]+"</h1>");
                 for(var lk=0;lk<laResultArray.length;lk++){
                     if(laResultArray[lk][0] == laDepartmenteArray[li]){
                        if(!checkIfExists(laSurveyArray,laResultArray[lk][1])){
                            laSurveyArray.push(laResultArray[lk][1]);
                        }
                    } 
                 }
                 writeToDiv("<h2>Total de encuestas:"+laSurveyArray.length+"</h2>")
                 
                for(var lj=0;lj<laSectionArray.length;lj++){
                     var liSectionTotal = 0.0;
                     
                     writeToDiv("<br><br><div class='section'><b>"+laSectionArray[lj]+"</b></div>");
                     //Obtenemos arreglo de preguntas
                     laQuestionArray = [];
                     laQuestionNameArray = [];
                     for(var lk=0;lk<laResultArray.length;lk++){
                         if(laResultArray[lk][0] == laDepartmenteArray[li] && laResultArray[lk][5] == laSectionArray[lj]){
                            if(!checkIfExists(laQuestionArray,laResultArray[lk][3])){
                                laQuestionArray.push(laResultArray[lk][3]);
                                laQuestionNameArray.push(laResultArray[lk][7]);
                            }
                         }
                     }
                     //Evaluamos preguntas
                     
                     for(var lm=0;lm<laQuestionArray.length;lm++){
                        laAnswerDescArray = [];
                        var liMax = 0.0;
                        var liTotal = 0.0;
                        var laPerxRes = [];
                        for(var lk=0;lk<laResultArray.length;lk++){
                            if(laResultArray[lk][0] == laDepartmenteArray[li] && laResultArray[lk][5] == laSectionArray[lj] && laResultArray[lk][3] == laQuestionArray[lm]){
                                laAnswerDescArray[laResultArray[lk][4]] = laResultArray[lk][8];
                                liTotal = liTotal + parseFloat(laResultArray[lk][4]);
                                liMax = liMax + parseFloat(laResultArray[lk][6]);
                                laPerxRes[laResultArray[lk][4]]=((typeof laPerxRes[laResultArray[lk][4]] == "undefined")?0:parseFloat(laPerxRes[laResultArray[lk][4]]))+parseFloat(1);
                            }
                        }
                        var liPer = ((liTotal/liMax)*100);
                        liSectionTotal = liSectionTotal + liPer;

                        var lsColor = (liPer<50)?"#FF9090":(liPer<80)?"#F3FF67":"#8EFD59";
                                                
                        writeToDiv("<br>"+laQuestionNameArray[lm]);
                        writeToDiv("<div class='rounded_max'>");
                        var lsReference = "";
                        for(laRespKey in laPerxRes){
                            
                            var lsCColor = "";
                            if(laRespKey == 1){
                                lsCColor="#F78C8C";
                            } else if(laRespKey == 2){
                                lsCColor="#FC961B";
                            } else if(laRespKey == 3){
                                lsCColor="#EFE400";
                            } else if(laRespKey == 4){
                                lsCColor="#7AFC1B";
                            } else if(laRespKey == 5){
                                lsCColor="#06AFF9";
                            }
                            writeToDiv("<span style='width:"+(600*(laPerxRes[laRespKey]/laSurveyArray.length))+"px;background:"+lsCColor+";color:black;font-weight:bold'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+(laPerxRes[laRespKey]/laSurveyArray.length*100).toFixed(2)+"</span>");
                            lsReference+="<font color='"+lsCColor+"'><b>"+laAnswerDescArray[laRespKey]+"</b></font><br>";
                            //writeToDiv(laRespKey+"-->"+laPerxRes[laRespKey]/laSurveyArray.length+"<br>");
                        }
                        writeToDiv("</div><br>");
                        writeToDiv(lsReference);
                        writeToDiv("<br>Valor obtenido:"+liTotal+"<br> Valor M?ximo:"+liMax+"<br> Porcentaje: <div class='rounded_min' style='width:200px;'><div style='width:"+(200*(liPer/100))+"px;background:"+lsColor+";color:gray;font-weight:bold'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+(liPer).toFixed(2)+"</div></div>");
                    }
                    var liCurrentSectionValue = liSectionTotal/laQuestionArray.length;
                    var lsColor = (liCurrentSectionValue<50)?"#FF9090":(liCurrentSectionValue<80)?"#F3FF67":"#8EFD59";
                    writeToDiv("<br><b>Total por secci?n</b> <div class='rounded' style='width:300px;'><div style='width:"+(300*(liCurrentSectionValue/100))+"px;background:"+lsColor+";color:gray;font-weight:bold'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+(liCurrentSectionValue).toFixed(2)+"</div></div>");
                    
                    laTotalSectionArray[laSectionArray[lj]]=liSectionTotal/laQuestionArray.length;
                    
                    
                    
                 }
                 
                 writeToDiv("<h3>RESUMEN DE SECCIONES</h3>");
                 for(lsSectionName in laTotalSectionArray){
                     var lsColor = (laTotalSectionArray[lsSectionName]<50)?"#FF9090":(laTotalSectionArray[lsSectionName]<80)?"#F3FF67":"#8EFD59";
                     writeToDiv(lsSectionName+"<div class='rounded' style='width:300px;'><div style='width:"+(300*(laTotalSectionArray[lsSectionName]/100))+"px;background:"+lsColor+";color:gray;font-weight:bold'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+laTotalSectionArray[lsSectionName].toFixed(2)+"</div></div>");
                 }
                 writeToDiv("<h2>COMENTARIOS</h2>");
                    for(var lo=0;lo<laCommentArray.length;lo++){
                        if(laCommentArray[lo][0] == laDepartmenteArray[li] ){
                            writeToDiv("<p>"+laCommentArray[lo][2]+"</p>");
                        }
                    }
              
             }
             
            
         }      
         function writeToDiv(psHTML){
             document.getElementById("result").innerHTML = document.getElementById("result").innerHTML +psHTML;
         }
         function checkIfExists(poArray,psValue){
             for(var lj=0;lj<poArray.length;lj++){
                 if(poArray[lj] == psValue){
                     return true;
                 }
             }
             return false;
         }
        </script>
    </head>
    <body onload="getResults()">
        <div id="result" name="result">
            
        </div>
    </body>
</html>