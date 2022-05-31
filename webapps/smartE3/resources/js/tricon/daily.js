// daily.js 

   var p_tipo = "D";  // reportes diarios

   /////////////////////////////////////////////////////////////
   // recupera las cookies diarias
   /////////////////////////////////////////////////////////////

   ga_dia     = new Cookie("ga_dia_d"    ,      "01",  8);
   ga_dia_ini = new Cookie("ga_dia_ini"  ,      "01",  8);
   ga_priori  = new Cookie("ga_priori_d" ,         1,  8);
   ga_ayuda   = new Cookie("ga_ayuda_d"  ,   "false",  8);
   ga_btext   = new Cookie("ga_btext_d"  ,   "true" ,  8);
   ga_bexcel  = new Cookie("ga_bexcel_d" ,   "false",  8);
   ga_bgraf   = new Cookie("ga_bgraf_d"  ,   "false",  8);

   function registerDia( s ) {
      ga_dia.value = s.options[s.selectedIndex].text;
      registerCookie(ga_dia.name, ga_dia.value, ga_dia.hrs_vigencia);
   }
   function registerDiaIni( s ) {
      ga_dia_ini.value = s.options[s.selectedIndex].text;
      registerCookie(ga_dia_ini.name, ga_dia_ini.value, ga_dia_ini.hrs_vigencia);
   }


   function new_doc_on_the_fly(winame,  p_prg_cgi, strReports, p_tge ) {
      //
      // Creat a new document on the fly
      //
      var ffly = new Date();
      var p_host = "";
      winame = winame + ffly.getSeconds();
      wFly = open("",winame ,"menubar=yes,toolbar=no,status=no,width=600,height=425,screenY=50,screenX=190,scrollbars=yes,resizable=1");
      wFly.document.open(); // Open document for input
      wFly.document.write('<!doctype html public "-//w3c//dtd html 4.0 transitional//en">');
      //wFly.document.write('<html> <head> </head> <body bgcolor="'+myrep.color+'">');
      wFly.document.write('<html> <head> </head> <body bgcolor="gray">');
      wFly.document.write('<h1> Autorun </h1>');
     
      p_host = (location.host).split(":")[0];  // p_host = wFly.location.host;
      //p_host ="192.168.110.219";
      wFly.document.write('<form name="myform" method="Post" action="http://'+ p_host +'/cgi-bin/'+ p_prg_cgi +'">');
      alert('http://'+ p_host +'/cgi-bin/'+ p_prg_cgi +'');
      //wFly.document.write('<input type="text"   name="txtDia"  value="'+ document.myform.selDia.options[document.myform.selDia.selectedIndex].text +'" ></input>');
      wFly.document.write('<input type="text"   name="txtDia"  value="14-09-08" ></input>');
      wFly.document.write('<input type="text"   name="txtSemana"   value="N" >sem</input>');
      wFly.document.write('<input type="text"   name="txtPeriodo"  value="N" >per</input>');
      wFly.document.write('<input type="text"   name="txtYear"     value="N" >year</input>');
      wFly.document.write('<input type="text"   name="txtReporte" value="');
      wFly.document.write(strReports);
      wFly.document.write('"    ></input>');
      wFly.document.write('<input type="text" name="txtNav" value="' + navigator.appName +'"></input> ');
      wFly.document.write('<p><input type="text" name="txtVer" value="' + navigator.appVersion +' size=70"></input> ');
      wFly.document.write('<p><input type="text" name="cbTipo" value="' + p_tge +'"></input> ');
      wFly.document.write('<p><input type="Submit" name="bSubmit"    value="Consultar"></input> ');
      wFly.document.write('</form>');
      wFly.document.write('</body> </html>');
      wFly.document.close();  // Cierra el documento
      wFly.document.myform.submit();
      
   }
   function print_daily_html( psReportPath, psReportName, psValue,psDate ) {
      var lsHTML = "";
      var ffly = new Date();
      var psHost = "";
      lsHTML+='<!doctype html public "-//w3c//dtd html 4.0 transitional//en">';
      
      lsHTML+='<html> <head> </head> <body bgcolor="gray">';
      lsHTML+='<h1> Autorun </h1>';
     
      psHost = (location.host).split(":")[0];  
      //psHost ="192.168.110.219";
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
