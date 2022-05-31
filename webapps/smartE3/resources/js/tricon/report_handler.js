/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


 function print_daily_html( psReportPath, psReportName, psValue,psDate ) {
      var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
      psHost = (location.host).split(":")[0]; 
      //psHost ="192.168.110.219";
      if(psValue == "Print"){
        lsHTML+='<form name="frmMaster" method="Post" target="_blank" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
        psValue="Text";
     }else
          lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
      lsHTML+='<input type="text"   name="txtDia"  value="'+psDate+'" ></input>';
      lsHTML+='<input type="text"   name="txtSemana"   value="N" >sem</input>';
      lsHTML+='<input type="text"   name="txtPeriodo"  value="N" >per</input>';
      lsHTML+='<input type="text"   name="txtYear"     value="N" >year</input>';
      lsHTML+='<input type="text"   name="txtReporte" value="';
      lsHTML+=psReportName;
      lsHTML+='"    ></input>';
      lsHTML+='<input type="text" name="txtNav" value="' + navigator.appName +'"></input> ';
      lsHTML+='<p><input type="text" name="txtVer" value="' + navigator.appVersion +' size=70"></input> ';
      lsHTML+='<p><input type="text" name="cbTipo" value="' + psValue +'"></input> ';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
      
   }
   
   function print_weekly_html( psReportPath, psReportName, psValue,psYear, psPeriod, psWeek ) {
      var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0]; 
      //psHost ="192.168.110.219";
      if(psValue == "Print"){
        lsHTML+='<form name="frmMaster" method="Post" target="_blank" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
        psValue="Text";
      }else
          lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
    
      lsHTML+='<input type="text"   name="txtDia"  value="N" ></input>';
      lsHTML+='<input type="text"   name="txtSemana"   value="'+psWeek+'" >sem</input>';
      lsHTML+='<input type="text"   name="txtPeriodo"  value="'+psPeriod+'" >per</input>';
      lsHTML+='<input type="text"   name="txtYear"     value="'+psYear+'" >year</input>';
      lsHTML+='<input type="text"   name="txtReporte" value="';
      lsHTML+=psReportName;
      lsHTML+='"    ></input>';
      lsHTML+='<input type="text" name="txtNav" value="' + navigator.appName +'"></input> ';
      lsHTML+='<p><input type="text" name="txtVer" value="' + navigator.appVersion +' size=70"></input> ';
      lsHTML+='<p><input type="text" name="cbTipo" value="' + psValue +'"></input> ';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
      
   }
     function printML(psDate){
        var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0];  
      //psHost ="192.168.110.219";
      lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/php/Display.php?file=./modelodelabor/history.php&date='+psDate+'&year=&period=&week=">';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
       
   }
   function printPron(psDate){
        var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0];  
      //psHost ="192.168.110.219";
      lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/php/Display.php?file=./pronens/pronostico.php&date='+psDate+'&year=&period=&week=">';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
       
   }
   function printHP(psDate){
        var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0];  
      //psHost ="192.168.110.219";
      lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/php/Display.php?file=./hpedidos/hpedidos.php&date='+psDate+'&year=&period=&week=">';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
       
   }
   function printWHP(psYear,psPeriod,psWeek){
        var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0];  
      //psHost ="192.168.110.219";
      lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/php/Display.php?file=./whpedidos/whpedidos.php&date=&year='+psYear+'&period='+psPeriod+'&week='+psWeek+'">';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
       
   }
   
    function print_periodically_html( psReportPath, psReportName, psValue,psYear, psPeriod ) {
      var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0]; 
      //psHost ="192.168.110.219";
      if(psValue == "Print"){
        lsHTML+='<form name="frmMaster" method="Post" target="_blank" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
        psValue="Text";
      }else
          lsHTML+='<form name="frmMaster" method="Post" action="http://'+ psHost +'/cgi-bin/'+ psReportPath +'">';
    
      lsHTML+='<input type="text"   name="txtDia"  value="N" ></input>';
      lsHTML+='<input type="text"   name="txtSemana"   value="04" >sem</input>';
      lsHTML+='<input type="text"   name="txtPeriodo"  value="'+psPeriod+'" >per</input>';
      lsHTML+='<input type="text"   name="txtYear"     value="'+psYear+'" >year</input>';
      lsHTML+='<input type="text"   name="txtReporte" value="';
      lsHTML+=psReportName;
      lsHTML+='"    ></input>';
      lsHTML+='<input type="text" name="txtNav" value="' + navigator.appName +'"></input> ';
      lsHTML+='<p><input type="text" name="txtVer" value="' + navigator.appVersion +' size=70"></input> ';
      lsHTML+='<p><input type="text" name="cbTipo" value="' + psValue +'"></input> ';
      lsHTML+='<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ';
      lsHTML+='</form>';
      lsHTML+='</body> </html>';
      return lsHTML;
      
   }
