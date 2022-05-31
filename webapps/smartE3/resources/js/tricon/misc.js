/////////////////////////////////////////////////////////////
// Funciones Miscelaneas
/////////////////////////////////////////////////////////////
  
   function registerCookie(name, value, horas) {
      var today = new Date();
      var expires = new Date();

      if ( horas == null || horas == 0 )
         expires = null;
      else
         expires.setTime(today.getTime() + 1000*60*60*horas);
      setCookie(name, value, expires);
   }

   function registerPriori( b ) {
      ga_priori.value = b.value;
      registerCookie(ga_priori.name, ga_priori.value, ga_priori.hrs_vigencia);
   }
   function registerAyuda( b ) {
      ga_ayuda.value = b.checked
      registerCookie(ga_ayuda.name, ga_ayuda.value, ga_ayuda.hrs_vigencia);
   }
   function registerBtext( b ) {
      b.checked = true;
      ga_btext.value = b.checked;
      registerCookie(ga_btext.name, ga_btext.value, ga_btext.hrs_vigencia);
   }
   function registerBexcel( b ) {
      if ( b.ckecked ) {
      // ga_bexcel.value = b.checked;
         alert("Funcion aun no implementada");
      } else
         alert("Funcion ya implementada");
      //registerCookie(ga_bexcel.name, ga_bexcel.value, ga_bexcel.hrs_vigencia);
   }
   function registerBgraf( b ) {
      if ( b.checked ) {
      // ga_bgraf.value = b.checked;
         alert("Funcion aun no implementada");
        // b.checked = false;
      }
      //registerCookie(ga_bgraf.name, ga_bgraf.value, ga_bgraf.hrs_vigencia);
   }
   
   function changePrioridad( bPrioridad ) {
      if ( bPrioridad.value == " Reportes basicos... " ) {
         bPrioridad.value = " Todos los reportes " ;
         p_prioridad = 0;
      } else {
         bPrioridad.value = " Reportes basicos... " ;
         p_prioridad = 1;
      }
      registerPriori( bPrioridad );
      history.go(0);  // recargar la pagina
   }

   /////////////////////////////////////////////////////////////////
   // p_prioridad es 1 cuando solo se desea ver los reportes basicos
   //             es 0 cuando se desea ver todos los reportes
   /////////////////////////////////////////////////////////////////

   var p_prioridad = 1;

   if ( getCookie(ga_priori.name) == " Todos los reportes " )
      p_prioridad = 0;
   else
      p_prioridad = 1;




   ////////////////////////////////////////////////// 
   //
   //  Funciones miscelaneas
   //
   ////////////////////////////////////////////////// 

   function show_help(strToSplit) {

      arrayOfStrings = strToSplit.split(":");
      
      // Abre una ventana para cada uno de los archivos de ayuda
      //
      for (i = 0; i < arrayOfStrings.length; i++) {
          winame = "wh" + arrayOfStrings[i] ;
          hoja = "/help/" + arrayOfStrings[i] + "_hlp.html"
          window.open(hoja,winame, "menubar=yes,toolbar=no,status=no,width=600,height=350,screenY=50,screenX=10,scrollbars=yes");
         
      }
   }


   function twodigits( n ) {
      // Esta funcion se usa en el armado de fechas tipo yy-mm-dd
      if ( n > 1000 )  { // Se trata de un año
         if ( n >= 2000 )
            n = n - 2000;
         else
            n = n - 1900;
      } else {
        if (n >= 100)
            n = n - 100;
      }
      return (n < 10) ? "0"+n : ""+n ;
   }

   function input_fecha() {
      var today   = new Date();
      var expires = new Date();
      var newfecha 
 
      if ( ga_dia_ini.value == null) {
         ga_dia_ini.value = twodigits(today.getYear())  + "-" +
                            twodigits(today.getMonth() + 1) + "-" +
                            twodigits(today.getDate());
      } else {
         ga_dia_ini.value = getCookie(ga_dia_ini.name);
      }
      newfecha = window.prompt("De la fecha en formato yy-mm-dd: ",  
                                       ga_dia_ini.value );
      if ( newfecha.length == 8 )
      {
         ga_dia_ini.value = newfecha;
         registerCookie(ga_dia_ini.name, ga_dia_ini.value, ga_dia_ini.hrs_vigencia);
      }
      window.location.reload();
   }


