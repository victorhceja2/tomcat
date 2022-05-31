   /////////////////////////////////////////////////////////////
   // Manejo de Cookies
   /////////////////////////////////////////////////////////////
   function Cookie(name, value, hrs_vigencia) {
      this.name         = name;
      this.value        = value;
      this.hrs_vigencia = hrs_vigencia;
   }
 
   function setCookie(name, value, expire ) {
      document.cookie=name + "=" + escape(value)
               + ((expire == null) ? "" : ("; expires=" + expire.toGMTString()));
   }

   function getCookie(name) {
      var search = name + "=";
      // if ( name == 'cbText' ) return 0;
      if (document.cookie.length > 0) { // if there are any cookies
         offset = document.cookie.indexOf(search);
         if (offset != -1) {
            offset += search.length;
            // set index of beginning of value
            end = document.cookie.indexOf(";", offset);
            // set index of end of cookie value
           if (end == -1)
              end = document.cookie.length;
           return unescape(document.cookie.substring(offset, end));
         }
      }
   }
  
   function registerCookie(name, value, horas) {
      var today = new Date();
      var expires = new Date();

      if ( horas == null || horas == 0 )
         expires = null;
      else
         expires.setTime(today.getTime() + 1000*60*60*horas);
      setCookie(name, value, expires);
   }


   ////////////////////////////////////////////////// 
   // definicion del reporte
   ////////////////////////////////////////////////// 
   function defReporte(name, descripcion, color ) {
      this.name        = name;
      this.descripcion = descripcion;
      this.color       = color;
      this.fc          = "#90FFDD";
      this.fsz         = "+2";
   }

   ////////////////////////////////////////////////// 
   //
   // Funciones relacionadas con los reportes
   //
   ////////////////////////////////////////////////// 
   function Rep(clasif, nombre, dir, dsp, prio, prog) {
      this.clasif = clasif;   // V ventas, I inv. O mano de obra P o E
      this.nombre = nombre;   // El nombre del reporte
      this.dir    = dir ;   // El directorio donde se encuentra
      this.dsp    = dsp ;   // D diario, S semana, P periodico
      this.prio   = prio;   // 0 todos, 1 basicos
      this.prog   = prog;   // programa generador
   }

   function reps_getNombre( i ) { return reps[i].nombre ; }
   function reps_getDir( i )    { return reps[i].dir ;    }
   function reps_getDsp( i )    { return reps[i].dsp ;    }
   function reps_getPrio( i )   { return reps[i].prio ;   }
   function reps_getProg( i )   { return reps[i].prog ;   }
   function reps_write(i) {
      if ( reps[i].prio == 1 ) colorLetra = "#007800" ; 
      if ( reps[i].prio == 2 ) colorLetra = "#FFFF00" ; 
      if ( reps[i].prio == 4 ) colorLetra = "#FF0000" ; 
      if ( reps[i].prio == 3 ) colorLetra = "#FF0000" ; 

      document.write('<font color="'+colorLetra+'"><input type="checkbox" name="cb'+i+ 
        	'" value="'+ i +'"><b>&nbsp;'+reps[i].nombre+'</b></input><br></font>');
   }

   function reps_val(i, p_dsp ) {
       if ( reps_getDsp(i) == p_dsp ) // &&  reps_getPrio(i) >= p_prioridad )
          return true;
       else
          return false;
   }
   function rpts_cancelar() {
      for (i = 0; i < document.myform.length; i++) 
         if ( document.myform.elements[i].checked ) 
              document.myform.elements[i].checked = false;
      return true;
   }


   function get_strReports() {
      var str_reports = "";
      var j = 0;

      // calcula los reportes a incluir
      //
      for (i = 0; i < document.myform.length; i++) {
         if ( document.myform.elements[i].checked ) {
               j = document.myform.elements[i].value;
               if ( 0 <= j && j < 100 )
                  if ( str_reports.length > 0 )
                      str_reports += ":" + reps_getDir(j);
                  else
                      str_reports = reps_getDir(j);
         }
      }
      return str_reports;
   }

function go_graphics(strReports) {
k
      new_doc_on_the_fly("wGraf", "py/reportes.py", strReports, "Graf" )
}
function go_excel(strReports) {
      new_doc_on_the_fly("wExcel","py/reportes.py", strReports, "Excel" )
}
function go_text(strReports) {
      new_doc_on_the_fly("wText", "py/reportes.py", strReports, "Text" )
}

function go_imprimir() {
   var str_reports = "";  // string con los reportes a incluir

   str_reports = get_strReports();
   if ( str_reports.length == 0 ) {
         alert("Seleccione algun reporte");
         return false;
   }
   new_doc_on_the_fly("wText", "py/reportes.py", str_reports, "Print" )
   if ( document.myform.cbAyuda.checked )
         show_help(str_reports)
   return false;
}

function display_php() 
{
      var str_reports = "";
      var j = 0;

      // calcula los reportes a incluir
      //
      for (i = 0; i < document.myform.length; i++) {
         if ( document.myform.elements[i].checked ) {
               j = document.myform.elements[i].value;
               if ( 0 <= j && j < 100 ) {
//                  if ( str_reports.length > 0 )
//                      str_reports += ":" + reps_getDir(j);
                      if ( "tmp" ==  reps_getDir(j)) {
                           go_php( reps_getProg(j));
                      }
//                  else
//                     str_reports = reps_getDir(j);
               }
         }
      }
}
     
function go_php(programa)
{
  //###############################
  //#Parametros para reporte diario
  if (document.myform.selDia) {
    parm_ymd = document.myform.selDia.options[document.myform.selDia.selectedIndex].text;
    par_year="";
    par_period="";
    par_week="";
  }

  //############################################
  //#Parametros para reporte Semanal o Periodico
  if (document.myform.selYear) {
    par_year=document.myform.selYear.options[document.myform.selYear.selectedIndex].text;
  }
  if (document.myform.selPeriodo) {
    par_period=document.myform.selPeriodo.options[document.myform.selPeriodo.selectedIndex].text;
    parm_ymd="";
    par_week="";
  }
  if (document.myform.selSemana) {
    par_week=document.myform.selSemana.options[document.myform.selSemana.selectedIndex].text;
  }

  var ffly = new Date();
  winame = "phpWin" + ffly.getSeconds(); 
  wFly = open("",winame,"menubar=no,toolbar=no,status=no,width=900,height=425,screenY=50,screenX=190,scrollbars=yes,resizable=1");
  wFly.document.open(); // Open document for input
  wFly.document.write('<html> <head> </head> <body bgcolor="'+myrep.color+'">');
//  p_host= wFly.location.host;
  p_host= location.host;

  wFly.document.write('<form name="myform" method="Get" action="http://',p_host,'/php/Display.php">');
  wFly.document.write('<input type=hidden name=file value='+programa+'>');
  wFly.document.write('<input type=hidden name=date value='+parm_ymd+'>');
  wFly.document.write('<input type=hidden name=year value='+par_year+'>');
  wFly.document.write('<input type=hidden name=period value='+par_period+'>');
  wFly.document.write('<input type=hidden name=week value='+par_week+'>');
  wFly.document.write('</form>');
  wFly.document.write('</body> </html>');
  wFly.document.close();  // Cierra el documento
  wFly.document.myform.submit();
}

function go_reports() {
      var str_reports = "";  // string con los reportes a incluir

      str_reports = get_strReports();
      if ( str_reports.length == 0 ) {
         alert("Seleccione algun reporte");
         return false;
      }
      if ( str_reports.search(/tmp/) != -1) {
          str_reports = str_reports.replace(/tmp/,"");
         // Quita de str_reports tmpXXXXXXXX
         // parms = XXXXXXX
         // str_reports = str_reports - tmpXXXXXX
         display_php();
        if ( str_reports.length == 0 ) {
          return true;
        }
      }

      if ( document.myform.cbText.checked ) 
         go_text(str_reports);

      //if ( document.myform.cbExcel.checked ) 
      //   go_excel(str_reports);
      //if ( document.myform.cbGraf.checked ) 
      //   go_graphics(str_reports);
      //
      // Ayuda en linea
      //
      if ( document.myform.cbAyuda.checked )
         show_help(str_reports)
         
      return false;
}

