/// ventas.js

   
   //
   // Tabla de reportes de ventas
   //
   reps = new Array(12);

   reps[ 0]=new Rep("V","Ventas Diarias","dsales","D","0","gensus.s /usr/fms/op/bin/phasrp1.s");
   reps[ 1]=new Rep("V","Audit Cajero","cash","D","0","repcaja.s");
   reps[ 2]=new Rep("V","Comida Empleados","meal","D","0","phmealrp.S");
   reps[ 3]=new Rep("V","Cancelaciones Diarias","canx","D","0","phcanx.s");
   reps[ 4]=new Rep("V","Ventas por Hora","hour","D","0","");
   reps[ 5]=new Rep("V","Audit Eventos","audit","D","0","phaurp.s");
   reps[ 6]=new Rep("V","Tickets Abiertos","ug","D","0","phupgckrp.S");
   reps[ 7]=new Rep("V","Ventas Semanales","sales","S","0","/usr/fms/op/bin/phasrp1.s");
   reps[ 8]=new Rep("V","Cancel Semanales","scanx","S","0","");
   reps[ 9]=new Rep("V","Comida Emp. Sem.","smeal","S","0","");
   reps[10]=new Rep("V","Reporte Pagos","pagos","S","0","phpagos.s");
   reps[11]=new Rep("V","*Ventas por Periodo","psales","P","0","");


