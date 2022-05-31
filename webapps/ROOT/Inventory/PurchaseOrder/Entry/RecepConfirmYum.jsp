<jsp:include page = '/Include/ValidateSessionYum.jsp'/>


<%--
##########################################################################################################
# Nombre Archivo  : RecepConfirmYum.jsp
# Compania        : Yum Brands Intl
# Autor           : AKG
# Objetivo        : Confirmacion de recepcion
# Fecha Creacion  :
# Inc/requires    :
# Modificaciones  : Eduardo Zarate (laliux)
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page contentType="text/html"%>
<%@page import="generals.*" %>
<%@page import="java.util.*, java.io.*, java.text.*;"%>

<%@ include file="/Include/CommonLibYum.jsp" %>   
<%@ include file="../../../Employees/Edit/Proc/EmployeeLib.jsp" %>
<%! AbcUtils moAbcUtils = new AbcUtils();  

    String stripAccents(String psInput) {
        String lsAscii  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 _";
        String lsNuevo = "                              ";
        char[] laName = psInput.toCharArray();
        char[] laAscii= lsAscii.toCharArray();
        char[] laNuevo= lsNuevo.toCharArray();
        String lsOutput = psInput;
        for (int i=0; i<laName.length; i++) {
            int pos = lsAscii.indexOf(laName[i]);
            if(pos > -1){
                System.out.println("No vamos a limpiar esto["+laName[i]+"]");
                laNuevo[i] = laName[i];
            }else{
                System.out.println("Vamos a limpiar esto:"+laName[i]+" Por nada");
                //laName[i] = laNull[0];
            }
        }//for i
        return new String(laNuevo);
    }

    ArrayList<String> getEmployees() {
                ArrayList<String> maEmployees = new ArrayList<String>();
                String queryEmployees = "SELECT emp_num || ' ' || last_name || ' ' || last_name2 || ' ' || name, last_name "
                                + "FROM pp_employees WHERE sus_id <> 'NULL' "
                                + "AND cast (emp_num as integer) > 0 "
                                + "AND security_level ='01' order by 2";
                String[] laEmployees = moAbcUtils.queryToString(queryEmployees, ">",
                                ",").split(">");
                for (String employee : laEmployees) {
                        String lstEmployee = employee.split(",")[0];
                        maEmployees.add(lstEmployee);
                }
                return maEmployees;
        }

%>

<%
    String msRecep="";
    String msStepRecep="0";

    String msRem="";
    String lsPrv="";
    String lsDocNum="";
    String lsResponsible="";

    try{
        lsDocNum=request.getParameter("txtDocNum");
        if (lsDocNum.equals("")) lsDocNum=lsDocNum;
    }catch(Exception moExcpetion){lsDocNum="";}

    try{
        lsResponsible=request.getParameter("cmbEmpl").length()>30?request.getParameter("cmbEmpl").substring(0,30):request.getParameter("cmbEmpl");
        System.out.println("ANTES: lsResponsible["+lsResponsible+"]");
        lsResponsible=stripAccents(lsResponsible);
        System.out.println("DESPUES: lsResponsible["+lsResponsible+"]");
        
        if (lsResponsible.equals("")) lsResponsible=lsResponsible;
    }catch(Exception moExcpetion){lsResponsible=""; System.out.println("EmplEx: " + request.getParameter("cmbEmpl"));}

    try{
        msRecep=request.getParameter("hidRecep");
        if (msRecep.equals("")) msRecep=msRecep;
    }catch(Exception e){msRecep="";}

    try{
        msRem=request.getParameter("hidRem");
        if (msRem.equals("")) msRem=msRem;
    }catch(Exception e){msRem="";}

    try{
        msStepRecep=request.getParameter("msStepRecep");
        if (msStepRecep.equals("")) msStepRecep=msStepRecep;
    }catch(Exception moExcpetion){msStepRecep="0";}

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    String msOperation ="";
    try{
        msOperation = request.getParameter("hidOperation");
    }catch(Exception e){}

    String msPresentation = (msOperation==null)?"VIEWPORT":msOperation;
    if (!msStepRecep.equals("0"))
        moHtmlAppHandler.setPresentation("VIEWPORT");
    else
       moHtmlAppHandler.setPresentation(msPresentation);

    moHtmlAppHandler.initializeHandler();

    response.setContentType(moHtmlAppHandler.moReportHeader.getContentType());
    response.setHeader(moHtmlAppHandler.moReportHeader.getContentDisposition(),moHtmlAppHandler.moReportHeader.getAtachedFile());
    String msFontMain = moHtmlAppHandler.moReportHeader.msFontMain;
    String msFontSub = moHtmlAppHandler.moReportHeader.msFontSub;
    String msFontEnd = "</font>";


    if (msStepRecep.equals("0"))
        moHtmlAppHandler.msReportTitle = getCustomHeader("Revisi&oacute;n de Recepci&oacute;n ","Printer");
    else
        moHtmlAppHandler.msReportTitle = getCustomHeader("Confirmacion de Recepcion","Printer");

    moHtmlAppHandler.moReportTable.setTableHeaders("Orden|Codigo Producto|Producto|Cantidad<br>Recibida|Discrepancia|Unidad<br>Inv|Precio<br>Unit|Subtotal",0,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("|||||||###,###.##");
    moHtmlAppHandler.moReportTable.setFieldColors("#E6E6FA|#E6E6FA|#E6E6FA|#66CCFF|#66CCFF|#E6E6FA|#E6E6FA|#E6E6FA",2);
    moHtmlAppHandler.validateHandler();

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

%>

<html>
    <head>
        <title>
        <%
        if (msStepRecep.equals("0"))
            out.println("Revision de Recepcion");
        else
            out.println("Confirmacion de Recepcion");
        %>
        </title>
        <link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
        <script src='/Scripts/ReportUtilsYum.js'></script>
        <script src='/Scripts/AbcUtilsYum.js'></script>
        <script src='/Scripts/RemoteScriptingYum.js'></script>

        <!-- Para tener control en el "doble-click" -->
        <script src='/Scripts/DoubleClickYum.js'></script>

        <script language="javascript">

        var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana

        //Para checar si existe el numero de documento
        function continueAceptData(psResult) {
            var lsResponsible = ignoreSpaces(document.frm_confirm.cmbEmpl.value);
            if(psResult == "DocExists") {
                alert("El numero de pedido de proveedor ya existe.");
                document.frm_confirm.txtDocNum.value="";
                document.frm_confirm.txtDocNumC.value="";
                document.frm_confirm.txtDocNum.focus();
                document.frm_confirm.btnAceptar.disabled = false;
                return (false);
            }
            
            if(psResult == "ErrCred"){
          alert('El empleado seleccionado y la clave de empleado ingresada no coinciden, favor de verificar');
          document.frm_confirm.txtPass.value="";
          document.frm_confirm.cmbEmpl.focus();
          document.frm_confirm.btnAceptar.disabled = false;
          return (false);
            }else{
          jsrsExecute("RemoteMethodsYum.jsp", continueAceptData1, "getLastNumDoc");
         }
        }

     function continueAceptData1(psResult){
          var lsNumDoc = ignoreSpaces(document.frm_confirm.txtDocNum.value)
          var lsPrv = ignoreSpaces(document.frm_confirm.hidPrv.value); // Le quitamos TODOS los espacios incluyendo los de en medio
          var lsRem= ignoreSpaces(document.frm_confirm.hidRem.value);
          if(lsPrv =="PFS" && lsRem =="-1"){
               if( lsNumDoc < psResult){
                    lsMsg = "El ultimo numero de pedido de PFS capturado es: " + psResult + " y el nuevo: " + lsNumDoc + " es menor. Esto es correcto?";
                    if(confirm(lsMsg)){
                         giWinControlClose=1;
                         opener.parent.liRowCountRecep=0;
                         opener.parent.lsProductoCodeRecepLst="";
                         document.frm_confirm.action='RecepConfirmYum.jsp';
                         document.frm_confirm.submit();
                    }else{
                         document.frm_confirm.txtDocNum.value="";
                         document.frm_confirm.txtDocNumC.value="";
                         document.frm_confirm.txtDocNum.focus();
                         document.frm_confirm.btnAceptar.disabled = false;
                    }
               }else{
                    giWinControlClose=1;
                    opener.parent.liRowCountRecep=0;
                    opener.parent.lsProductoCodeRecepLst="";
                    document.frm_confirm.action='RecepConfirmYum.jsp';
                    document.frm_confirm.submit();
               }
          }else{
               giWinControlClose=1;
               opener.parent.liRowCountRecep=0;
               opener.parent.lsProductoCodeRecepLst="";
               document.frm_confirm.action='RecepConfirmYum.jsp';
               document.frm_confirm.submit();
          }
     }

        function handleOK() {

            if (opener && !opener.closed) {
                opener.dialogWin.returnFunc();
            } else {
                alert("Se ha cerrado la ventana principal.\n\nNo se realizaran cambios por medio de este cuadro de dialogo.");
            }

            return(false);
        }

        function returnData(psParam) {
            parent.opener.dialogWin.returnedValue = psParam;
            handleOK();
            window.close();
        }

        function trim(string)
        {
            return string.replace(/(^\s*)|(\s*$)/g,'');
        }

        function ignoreSpaces(string)
        {
            var temp = "";
            string = '' + string;
            splitstring = string.split(" ");
            for(i = 0; i < splitstring.length; i++)
            temp += splitstring[i];
            return temp;
        }

     function LTrim(VALUE){
          var w_space = String.fromCharCode(32);
          if(v_length < 1){
               return"";
          }
          var v_length = VALUE.length;
          var strTemp = "";
          
          var iTemp = 0;
          
          while(iTemp < v_length){
               if(VALUE.charAt(iTemp) == w_space){
               }
               else{
                    strTemp = VALUE.substring(iTemp,v_length);
                    break;
               }
               iTemp = iTemp + 1;
          }
          return strTemp;
     } 

     function RTrim(VALUE){
          var w_space = String.fromCharCode(32);
          var v_length = VALUE.length;
          var strTemp = "";
          if(v_length < 0){
               return"";
          }
          var iTemp = v_length -1;
          
          while(iTemp > -1){
               if(VALUE.charAt(iTemp) == w_space){
               }
               else{
               strTemp = VALUE.substring(0,iTemp +1);
               break;
               }
               iTemp = iTemp-1;
          }
          return strTemp;
     
     }


     function aceptData(){
          document.frm_confirm.btnAceptar.disabled = true;
     
          var lsDocumentNum = ignoreSpaces(document.frm_confirm.txtDocNum.value); // Le quitamos TODOS los espacios incluyendo los de en medio
          var lsDocumentNumC = ignoreSpaces(document.frm_confirm.txtDocNumC.value); // Le quitamos TODOS los espacios incluyendo los de en medio
          var lsPrv = ignoreSpaces(document.frm_confirm.hidPrv.value); // Le quitamos TODOS los espacios incluyendo los de en medio
     
          var lsStepRecep   = document.frm_confirm.msStepRecep.value;
          var laParams      = new Array(4);
          var lsEmpl = document.frm_confirm.cmbEmpl.value;
          var lsPass = document.frm_confirm.txtPass.value;
          laParams[0] = lsDocumentNum;
          laParams[1] = lsStepRecep;
          laParams[2] = lsEmpl;
          laParams[3] = lsPass;
     
          if(lsDocumentNum.length==0||lsDocumentNum==""){
               alert('Para confirmar la recepcion, ingrese el numero de pedido del proveedor. Puede ser factura o remision.');
               document.frm_confirm.txtDocNum.value="";
               document.frm_confirm.txtDocNum.focus();
          
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }
          if(lsPrv == "PFS"){
               if(!(numericS(lsDocumentNum))){
                    alert("Ingrese un numero de documento que solo contenga numeros. No se permite ningun otro caracter ni espacios en blanco.");
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();     
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }
               if(lsDocumentNum.length>10){
                    alert("El numero de documento no debe tener mas de 10 digitos.");
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();     
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }
               if(lsDocumentNum<0){
                    alert("El numero de documento debe ser mayor a 0.");
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();     
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }
               /*if(lsDocumentNum.length<10){
                    alert("El numero de documento debe ser de 10 digitos.");
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();     
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }
               if(lsDocumentNum<2000000000 || lsDocumentNum>3000000000){
                    alert("El numero de documento debe iniciar con 2");
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();     
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }*/
          }else{
               if(!(alphanumeric(lsDocumentNum))){
                    document.frm_confirm.txtDocNum.value="";
                    document.frm_confirm.txtDocNumC.value="";
                    document.frm_confirm.txtDocNum.focus();
                    alert("Ingrese un numero de documento que solo contenga letras y/o numeros. No se permite ningun otro caracter ni espacios en blanco.");
                    document.frm_confirm.btnAceptar.disabled = false;
                    return(false);
               }
          }
     
          if(lsDocumentNumC.length==0||lsDocumentNumC==""){
               alert('Para confirmar la recepcion, ingrese la confirmacion del numero de pedido del proveedor. Debe ser igual al No. de Pedido.');
               document.frm_confirm.txtDocNumC.value="";
               document.frm_confirm.txtDocNumC.focus();
          
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }

          if( lsEmpl == "-1" ){
               alert('Debe seleccionar un empleado para continuar');
               document.frm_confirm.cmbEmpl.focus();
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }

          if( lsPass == "" ){
               alert('Debe ingresar su contrasena para continuar');
               document.frm_confirm.txtPass.focus();
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }

          if(lsDocumentNum != lsDocumentNumC){
               alert('El numero de Pedido y su confirmacion no son iguales. Por favor, reingresa la informacion.');
               document.frm_confirm.txtDocNum.value="";
               document.frm_confirm.txtDocNumC.value="";
               document.frm_confirm.txtDocNum.focus();
          
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }
          else{
               //jsrsExecute("RemoteMethodsYum.jsp", continueValidation, "validateCredentials",laParams);
               jsrsExecute("RemoteMethodsYum.jsp", continueAceptData, "validateCredentialsAndDocument", laParams);
          }
     }
     
     function continueValidation (psResult){
          if (psResult == "ERROR"){
               alert('El empleado y la contrasena no coinciden, favor de verificar');
               document.frm_confirm.cmbEmpl.focus();
               document.frm_confirm.btnAceptar.disabled = false;
               return(false);
          }else{
               
          }
     }

        function cancelData(){
            document.frm_confirm.action='RecepDetailYum.jsp';
            document.frm_confirm.target='ifrDetail';
            document.frm_confirm.submit();
            window.close();
        }

        function loadFunction()
        {
            if (opener) opener.blockEvents();
        }

        function doClose()
        {
            if(giWinControlClose==0)
                cancelData();
        }

        function showRecep(psStepRecep, psDocNum)
        {
            opener.parent.resetRemissionCmbs();
            opener.parent.location.href='OrderYum.jsp';

            location.href = 'ShowRecepYum.jsp?recepId='+psStepRecep+'&docNum='+psDocNum;
        }

     function alphabetic(c){
          var alfa = "ABCDEFGHIJKLMNOPQRSTUWXYZabcdefghijklmnopqrstuvxyz";
          return(alfa.indexOf(c) != - 1);
     }
     
     /* dice si el caracter car es numerico */
     function numeric(c){
          var num = "0123456789";
          return(num.indexOf(c) != - 1);
     }
     
     /* dice si la cadena s es alfanumerica*/
     function alphanumeric(s){
          for (i = 0; i < s.length; i++){
               var c = s.charAt(i);
               if (! (numeric(c) || alphabetic(c) ) ){
                    return false;
               }
          }
          return true;
     }

     function numericS(s){
          for (i = 0; i < s.length; i++){
               var c = s.charAt(i);
               if (! (numeric(c) ) ){
                    return false;
               }
          }
          return true;
     }


     
        </script>
    </head>
    <body onUnload="doClose()" bgcolor = 'white' OnLoad = 'loadFunction();' OnResize='adjustTableSize();'>

    <% 
    try
    {
        if (msStepRecep==null) msStepRecep="0";

        if (!msStepRecep.equals("0")) //Se confirma la recepcion
        {
            String lsDateTime = getToday();
            String msCont = existRecep(msStepRecep);
            if(!msCont.equals("0"))
            {
                System.out.println("No voy a ejecutar el codigo de operaciones en la BDD ni archivos");
                try{
                    FileWriter lftemp = new FileWriter("/tmp/RecepConfirm.log", true);
                    lftemp.write(lsDateTime + ": No se ejecuta la operacion porque " + msStepRecep + " ya existe dentro de la BDD");
                    lftemp.write('\n');
                    lftemp.close();
                }
                catch(Exception e)
                {
                    System.out.println("Exception " + e);
                }
                //EZ: pasar a la pantalla de impresion de recepcion, no cerrar la ventana
                //out.println("alert('Error en la confirmacion de la recepcion. Contacta a sistemas.');");
                //out.println("window.close();");
                out.println("<script>");
                out.println("showRecep('"+msStepRecep+"', '"+lsDocNum+"'); ");
                out.println("</script>");
            }
            else
            {
                System.out.println ("Hago las operaciones de confirmacion!!");
                try
                {
                    FileWriter lftemp = new FileWriter("/tmp/RecepConfirm.log", true);
                    lftemp.write(lsDateTime +": Se realizan las operaciones para: " + msStepRecep);
                    lftemp.write('\n');
                    lftemp.close();
                }
                catch(Exception e)
                {
                    System.out.println("Final de Stream");
                }

                out.println("<script>"); //SCRIPT se cierra al final del IF
                out.println("giWinControlClose=1");

                String lsUpdateQuery="UPDATE op_grl_step_reception SET document_num=UPPER(?), responsible=?";
          System.out.println("Responsible: " + lsResponsible.trim() + ", num_doc= " + lsDocNum);
                moAbcUtils.executeSQLCommand(lsUpdateQuery,new String[]{lsDocNum.trim(), lsResponsible.trim()});

                String lsInsertQuery = "INSERT INTO op_grl_reception "+
                                       "SELECT * from op_grl_step_reception WHERE reception_id=? ";
                moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{msStepRecep});

                lsInsertQuery = "INSERT INTO op_grl_reception_detail "+
                                "SELECT * from op_grl_step_reception_detail WHERE  reception_id=?  ";
                moAbcUtils.executeSQLCommand(lsInsertQuery,new String[]{msStepRecep});

                /*
                    Carga las cantidades de productos recibidas en la tabla de
                    inventario.
                */
                lsInsertQuery = "SELECT add_reception_inv("+msStepRecep+")";
                moAbcUtils.queryToString(lsInsertQuery);

                // Borramos lo que estaba en la tabla temporal
                String lsDeleteQuery = "DELETE from op_grl_step_reception_detail  ";   
                moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

                lsDeleteQuery = "DELETE from op_grl_step_reception ";         
                moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

                lsDeleteQuery = "DELETE from op_grl_step_difference  ";   
                moAbcUtils.executeSQLCommand(lsDeleteQuery,new String[]{});

                /*Inserta registros en tabla de diferencias*/
                insertIntoDifference(msStepRecep, moAbcUtils);

                String lsOrdQuery ="SELECT order_id FROM op_grl_reception WHERE " +
                                   "reception_id ="+msStepRecep;
                String msOrd=moAbcUtils.queryToString(lsOrdQuery);

                String lsResult=getQueryAux(msStepRecep);
                String lsDiscrepCode = getQueryDiscCode();

                if(!lsResult.equals(""))
                {
                    if (lsResult.indexOf("@")!=-1)
                    {
                        String laResult[]=lsResult.split("@");
                        for(int i=0; i < laResult.length; i++)
                        {
                            String lsUpdateQueryAux = "UPDATE op_grl_reception_detail SET "+
                                                      "difference_id=? WHERE reception_id=? " +
                                                      "AND provider_product_code =?";
                            moAbcUtils.executeSQLCommand(lsUpdateQueryAux,
                                                  new String[]{lsDiscrepCode,msStepRecep,laResult[i]});
                        }
                    }
                    else
                    {
                        String lsUpdateQueryAux="UPDATE op_grl_reception_detail SET difference_id=? " +
                                                "WHERE reception_id=? "+
                                                "AND provider_product_code =?";
                        moAbcUtils.executeSQLCommand(lsUpdateQueryAux,
                                                  new String[]{lsDiscrepCode,msStepRecep,lsResult});
                    }
                }
                
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd kk:mm:ss");
                Calendar c= Calendar.getInstance();
                
                String lsInsertAudit="INSERT INTO op_grl_audit_events VALUES ("
                   + "(SELECT (CASE WHEN max(audit_id) IS NULL THEN 0 ELSE max(audit_id) END)+1 from op_grl_audit_events),"
                   + msStepRecep + ","
                   + "'RECEPCION',"
                   + "(SELECT date_id FROM op_grl_reception WHERE reception_id='" + msStepRecep +"'),"
                   + "'" + sdf.format(c.getTime()) + "',"
                   + "(SELECT responsible FROM op_grl_reception WHERE reception_id='" + msStepRecep +"'))";
          System.out.println("lsInsertAudit:\n" + lsInsertAudit);
          moAbcUtils.executeSQLCommand(lsInsertAudit);
                //Se guarda el archivo de la recepcion
                String lsPathShell ="/usr/local/tomcat/webapps/ROOT/Scripts/PGDBUtils.s";
                String lsPath="/usr/bin/ph/3w_recepcion/"+getDateTime()+".txt";
                String laCommand[] ={lsPathShell,"true", 
                getQueryRecepFile(msStepRecep,getStore()),lsPath,getStore(),msStepRecep};

                try
                {
                    Process loStatus= Runtime.getRuntime().exec(laCommand);
                }
                catch(Exception poException)
                {
                     out.println("alert('Error en la generacion del Reporte de Discrepancias.')");
                }

          
                if(!msOrd.equals("-1")&&!msOrd.equals("0")) //Si existe una orden
                {
                    //Se guarda el registro de diferencias order-recepcion
                    lsPathShell ="/usr/local/tomcat/webapps/ROOT/Scripts/PGDBUtils.s";
                    lsPath="/usr/bin/ph/3w_discord/"+getDateTime()+".txt";
                    String laCommandDifOrd[] ={lsPathShell, "false", 
                           getQueryDifOrdRecep(msStepRecep, msOrd, getStore()),lsPath};
                  
                    try
                    {
                        Process loStatus = Runtime.getRuntime().exec(laCommandDifOrd);                  
                    }
                    catch(Exception poException)
                    {
                        out.println("alert('Error en la generacion del archivo de diferencias order-recepcion Contacta a sistemas.')");
                    }
                }

                if(!msRem.equals("-1")&&!msRem.equals(""))//Si existe una remision
                {
                    //Se guarda el registro de diferencias remision-recepcion
                    lsPathShell ="/usr/local/tomcat/webapps/ROOT/Scripts/PGDBUtils.s";
                    lsPath="/usr/bin/ph/3w_discrem/"+getDateTime()+".txt";
                    String laCommandDifRem[] ={lsPathShell, "false", 
                           getQueryDifRemRecep(msStepRecep, msRem, getStore()),lsPath};
                  
                    try
                    {
                        Process loStatus= Runtime.getRuntime().exec(laCommandDifRem);
                    }
                    catch(Exception poException)
                    {
                        out.println("alert('Error en la generacion del archivo remision-recepcion. Contacta a sistemas.')");
                    }
                }

                //Actualización de los número límite de recepción
                lsPathShell ="/usr/bin/ph/update_reception_limits.s";
                //String lsPath="/usr/bin/ph/3w_recepcion/"+getDateTime()+".txt";
                String laCommandUpdLimitRecep[] ={lsPathShell,"true"};

                try
                {
                    Process loStatus= Runtime.getRuntime().exec(laCommandUpdLimitRecep);
                }
                catch(Exception poException)
                {
                     out.println("alert('Error en la actualizacion de limites')");
                }

            %>
                showRecep('<%= msStepRecep %>', '<%= lsDocNum %>');
            </script>
        <%
            }//Fin de la validacion de existencia de la recepcion para que no se duplique en los archivos
        }//FIN IF se confirma recepcion
        else
        {
          lsPrv=moAbcUtils.queryToString("SELECT provider_id from op_grl_step_reception WHERE reception_id="+msRecep+"","","");

            //Se muestra lo que va en la recepcion antes de la confirmacion
        %>
            <jsp:include page="/Include/GenerateHeaderYum.jsp">
              <jsp:param name="psStoreName" value="true"/>
            </jsp:include>

            <form name ="frm_confirm" id ="frm_confirm" method="get">
          <%if(lsPrv.trim().equals("PFS")){%>
          <!-- Tabla para insertar la imagen para el número de documento-->
          <table width="800" border="0" align="center" cellspacing="0" cellpadding="0">
          <tr>
               <td colspan=3><img src="/Inventory/PurchaseOrder/Img/r1c123.jpg" ></td>
          </tr>
          <tr>
               <td rowspan=2><img src="/Inventory/PurchaseOrder/Img/r23c1.jpg"  valign="top"></td>
               <td width="100%">
               <% if (msRem.equals("") || msRem.equals("-1")){%>
                         <input type="text" name="txtDocNum" id="txtDocNum" size="15" maxlength="15">
                      <%}else{%>
                         <input type="text" name="txtDocNum" id="txtDocNum" size="15" value="<%=msRem%>" READONLY class ="tdBgColor">
                      <% }%></td>
               <td><img src="/Inventory/PurchaseOrder/Img/r2c3.jpg" valign="top"></td>
          </tr>
          <tr>
               <td colspan=2><img src="/Inventory/PurchaseOrder/Img/r3c23.jpg" valign="top"></td>
          </tr>
          </table>
          <!-- Fin de la tabla para insertar la imagen para el número de documento-->
          <%}else{%>
          <table width="99%" border="0" align="center" cellspacing="5">
          <tr>
               <td class=descriptionTabla width="15%" nowrap>No.Pedido:</td>
               <td class=descriptionTabla width="85%">
               <% if (msRem.equals("") || msRem.equals("-1")){%>
                    <input type="text" name="txtDocNum" id="txtDocNum" size="15" maxlength="15">
               <%}else{%>
                    <input type="text" name="txtDocNum" id="txtDocNum" size="15" value="<%=msRem%>" READONLY class ="tdBgColor">
               <% }%>
               </td>
          </tr>
          </table>
          <%}%>
            <table width="99%" border="0" align="center" cellspacing="5">
            <tr>
            <td class=descriptionTabla width="15%" nowrap>
                Confirma No. de pedido:
            </td>
            <td class=descriptionTabla width="85%">
            <% if (msRem.equals("") || msRem.equals("-1")){%>
                    <input type="text" name="txtDocNumC" id="txtDocNumC" size="15" maxlength="15" >
            <%}else{%>
                    <input type="text" name="txtDocNumC" id="txtDocNumC" size="15" value="<%=msRem%>" READONLY class ="tdBgColor">
            <% }%>
            </td>
            </tr>
            <tr>
            <td class="descriptionTabla">Quien captura:</td>
            <td class="descriptionTabla">
            <!--input type = "text" name = "txtResponsible" id="txtResponsible" size="30"-->
         <select id="cmbEmpl" name="cmbEmpl" onChange="document.frm_confirm.txtPass.value=''; document.frm_confirm.txtPass.focus();">
         <option value="-1">Seleccione un empleado</option>
         <%
              writeMenu(out, getEmployees());
         %>
         </select>
            </td>
            </tr>
         <tr>
              <td class="descriptionTabla">Contrase&ntilde;a:</td>
          <td class="descriptionTabla">
              <input type="password" name="txtPass" id="txtPass" size="30">
          </td>
         </tr>
            <tr>
                <td colspan="2" class="descriptionTabla">
                    <b>Desea confirmar la recepcion?</b>
                    <input type="hidden" name="msStepRecep" value="<%= msRecep %>">
                    <input type="hidden" name="hidRem" value="<%= msRem %>">
              <input type='hidden' name='hidOrigen' value='confirm'>
              <input type='hidden' name='hidPrv' value='<%=lsPrv.trim()%>'>
                    <input type="hidden" name="hidOperation" value="S">
                    <input type="button" name="btnAceptar" value="Aceptar" 
                    onclick="handleClick(event.type,'aceptData()');" 
                    ondblclick="handleClick(event.type,'aceptData()')">
                    <input type="button" name="cmd_cancel" value=" Cancelar " OnClick = "cancelData();">
                </td>
            </tr>

            </table>
            </form>
        <%
          moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport(msRecep, lsPrv));
        }//FIN ELSE
    }
    catch(Exception e)
    {
        System.out.println("RecepConfirm exception ... " + e.toString());
    }
        %>
            <jsp:include page = '/Include/TerminatePageYum.jsp'/>
        
    </body>
</html>

<%!
    String getQueryReport(String  psRecep, String psPrvId) {
        String lsQuery = "";

        AbcUtils moAbcUtils = new AbcUtils();
        lsQuery += "SELECT MAX(sort_num) FROM op_grl_step_reception_detail WHERE reception_id = '" + psRecep + "'";
        int liSeq=Integer.parseInt(moAbcUtils.queryToString(lsQuery,"",""))+1;

        lsQuery ="";
        lsQuery += " SELECT ";
        lsQuery += " isnull(rd.sort_num,0),";
        lsQuery += " rd.provider_product_code,p.provider_product_desc,";
        lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name),dif_desc,";
        lsQuery += " Ltrim(to_char(rd.received_quantity*p.conversion_factor,'9999990.99')||' '||mm.unit_name), ";
        lsQuery += " Ltrim(to_char(unit_cost,'9999990.99')) as unit_cost, ";
        lsQuery += " Ltrim(to_char(ROUND((rd.received_quantity*unit_cost),2),'9999990.99'))";
        lsQuery += " FROM ";
        lsQuery += " op_grl_step_reception r ";
        lsQuery += " INNER JOIN op_grl_step_reception_detail  rd ON r.reception_id=rd.reception_id ";
        lsQuery += " INNER JOIN op_grl_cat_providers_product p ON rd.provider_product_code=p.provider_product_code AND rd.provider_id=p.provider_id";
        lsQuery += " LEFT JOIN op_grl_cat_difference d ON d.difference_id=rd.difference_id ";
        lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id ";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p.provider_unit_measure";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure mm ON mm.unit_id = i.inv_unit_measure ";
        lsQuery += " WHERE r.reception_id ='"+psRecep+"'";
        lsQuery += " AND p.provider_id = '" + psPrvId +"'";
        lsQuery += " UNION ";

        lsQuery += "SELECT ";
        lsQuery += liSeq + ", ";
        lsQuery += "CAST('&nbsp;' as varchar) as provider_product_code,CAST('' as char) as inv_desc,";
        lsQuery += "CAST('' as char),CAST('' as char),";
        lsQuery += "CAST('' as char), ";
        lsQuery += "' <b>TOTAL:</b>' as unit_cost, ";
        lsQuery += "to_char(ROUND(SUM((Case  When rd.received_quantity = Null then 0 else rd.received_quantity end)*rd.unit_cost),2),'9999990.99')";
        lsQuery += " FROM ";
        lsQuery += " op_grl_step_reception_detail rd ";
        lsQuery += " WHERE rd.reception_id ='"+psRecep+"'";

        lsQuery += " ORDER BY 1 ASC";

        return(lsQuery);
    }

    String getQueryRecepFile(String psRecep,String psStore){
        String lsQuery="SELECT r.reception_id, r.document_num, r.remission_id, r.order_id, r.store_id, r.date_id, ";
        lsQuery+=" r.provider_id,p.inv_id,p.stock_code_id, rd.provider_product_code, rd.received_quantity, p.provider_unit_measure, ";
        lsQuery+=" rd.difference_id,r.document_type_id, r.report_num, rd.unit_cost, rd.forwarding_id ";
        lsQuery+=" FROM";
        lsQuery+=" op_grl_reception r";
        lsQuery+=" LEFT JOIN op_grl_reception_detail rd ON rd.reception_id = r.reception_id and rd.store_id=r.store_id";
        lsQuery+=" LEFT JOIN op_grl_cat_providers_product p ON p.provider_id =rd.provider_id AND p.provider_product_code = rd.provider_product_code";
        lsQuery+=" WHERE r.reception_id="+psRecep;
        lsQuery+=" AND r.store_id="+psStore;
        return(lsQuery);
    }

    String getQueryDifOrdRecep(String psRecep,String psStore, String psDiscrepCode){
       AbcUtils moAbcUtils = new AbcUtils();
       String lsOrd=moAbcUtils.queryToString("SELECT ltrim(rtrim(CAST(order_id AS CHAR(6)))) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
       String lsQuery="SELECT "; //Productos en remision y en recepcion
       lsQuery+="r.reception_id as reception_id, ";
       lsQuery+="r.document_num as document_num, ";
       lsQuery+="r.remission_id as remission_id, ";
       lsQuery+="r.order_id as order_id, ";
       lsQuery+="r.store_id as store_id, ";
       lsQuery+="r.date_id as date_id, ";
       lsQuery+="p.inv_id as inv_id, ";
       lsQuery+="rd.provider_id as provider_id, ";
       lsQuery+="p.stock_code_id as order_stock_code_id, ";
       lsQuery+="p.provider_product_code as order_provider_product_code, ";
       lsQuery+="p1.stock_code_id as recep_stock_code_id, ";
       lsQuery+="p1.provider_product_code as recep_provider_product_code, ";
       lsQuery+="rd.received_quantity as received_quantity, ";
       lsQuery+="p1.provider_unit_measure as provider_unit, ";
       lsQuery+="rd.difference_id as difference_id, ";
       lsQuery+="r.report_num as report_num, ";
       lsQuery+="rd.forwarding_id as forwarding_id ";
       lsQuery+=" FROM op_grl_order_detail od   ";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.order_id=od.order_id ";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code) ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code AND p.provider_id=rd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code AND p1.provider_id=rd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id ";
       lsQuery+=" WHERE rd.reception_id ='"+psRecep+"'";
       lsQuery+=" AND (rd.received_quantity -od.prv_required_quantity) <> 0  ";
       lsQuery+=" \n UNION  \n";
       /**** Productos que estan en la orden y en la recepcion con diferente codigo de proveedor*/
       lsQuery+=" SELECT";
       lsQuery+=" r.reception_id as reception_id,";
       lsQuery+=" r.document_num as document_num,";
       lsQuery+=" r.remission_id as remission_id,";
       lsQuery+=" r.order_id as order_id,";
       lsQuery+=" r.store_id as store_id,";
       lsQuery+=" r.date_id as date_id,";
       lsQuery+=" p1.inv_id,";
       lsQuery+=" rd.provider_id as provider_id,";
       lsQuery+=" p1.stock_code_id as order_stock_code_id,";
       lsQuery+=" od.provider_product_code as provider_product_code_order,";
       lsQuery+=" p1.stock_code_id as recep_stock_code_id,";
       lsQuery+=" rd.provider_product_code as provider_product_code_recep,";
       lsQuery+=" rd.received_quantity as received_quantity,";
       lsQuery+=" p1.provider_unit_measure as provider_unit,";
       lsQuery+=" rd.difference_id as difference_id,";
       lsQuery+=" r.report_num as report_num,";
       lsQuery+=" rd.forwarding_id as forwarding_id ";

       /*lsQuery+=" FROM op_grl_cat_providers_product p1"; // Habia un error estaba trayendo los codigos de otros productos 
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p2 ON p2.inv_id = p1.inv_id";
       lsQuery+=" INNER JOIN op_grl_order_detail od ON od.provider_product_code = p1.provider_product_code AND od.provider_id = p1.provider_id";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON rd.provider_product_code = p2.provider_product_code AND rd.provider_id = p2.provider_id";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.reception_id=rd.reception_id";
       lsQuery+=" INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
       lsQuery+=" WHERE p1.provider_product_code <> p2.provider_product_code";*/

       lsQuery+=" FROM op_grl_reception_detail rd"; // Esta seccion ya esta arreglada
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p1 ON rd.provider_product_code = p1.provider_product_code AND rd.provider_id = p1.provider_id";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.reception_id = rd.reception_id";
       lsQuery+=" INNER JOIN op_grl_order_detail od ON od.order_id = r.order_id"; 
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p2 ON od.provider_product_code = p2.provider_product_code AND od.provider_id = p2.provider_id";
       lsQuery+=" AND p1.inv_id = p2.inv_id AND p1.provider_product_code <> p2.provider_product_code";
       lsQuery+=" AND rd.reception_id = '" + psRecep + "'";
       lsQuery+=" \n UNION  \n";
       lsQuery+=" SELECT";//Productos en recepcion que no estan en la orden
       lsQuery+=" r.reception_id as reception_id,";
       lsQuery+=" r.document_num as document_num,";
       lsQuery+=" r.remission_id as remission_id,";
       lsQuery+=" r.order_id as order_id,";
       lsQuery+=" r.store_id as store_id,";
       lsQuery+=" r.date_id as date_id,";
       lsQuery+=" p.inv_id as inv_id,";
       lsQuery+=" rd.provider_id as provider_id,";
       lsQuery+=" CAST('' as char) as stock_code_id_ord,";
       lsQuery+=" CAST('' as char) as provider_product_code_ord,";
       lsQuery+=" p.stock_code_id as stock_code_id_rec,";
       lsQuery+=" p.provider_product_code as provider_product_code_rec,";
       lsQuery+=" rd.received_quantity as received_quantity,";
       lsQuery+=" p1.provider_unit_measure as provider_unit,";
       lsQuery+=" rd.difference_id as difference_id,";
       lsQuery+=" r.report_num as report_num, ";
       lsQuery+=" rd.forwarding_id as forwarding_id ";
       lsQuery+=" FROM op_grl_reception r";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id )";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rd.provider_product_code AND p.provider_id = rd.provider_id";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code AND p1.provider_id = rd.provider_id";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id";
       lsQuery+=" INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
       lsQuery+=" WHERE rd.reception_id = '" + psRecep + "'";
       lsQuery+=" AND p1.inv_id NOT IN (";
       lsQuery+=" SELECT p2.inv_id";
       lsQuery+=" FROM op_grl_order_detail od";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = od.provider_product_code";
       lsQuery+=" WHERE od.order_id=" + lsOrd;
       lsQuery+=" )";

       lsQuery+=" \n UNION  \n";
       lsQuery+=" SELECT";//Productos en orden que no estan en la recepcion negados
       lsQuery+=" r.reception_id as reception_id,";
       lsQuery+=" r.document_num as document_num,";
       lsQuery+=" r.remission_id as remission_id,";
       lsQuery+=" o.order_id as order_id,";
       lsQuery+=" o.store_id as store_id,";
       lsQuery+=" r.date_id as date_id,";
       lsQuery+=" i.inv_id as inv_id,";
       lsQuery+=" od.provider_id,";
       lsQuery+=" p.stock_code_id as order_stock_code_id,";
       lsQuery+=" p.provider_product_code as provider_product_code_ord,";
       lsQuery+=" CAST('' as char) as stock_code_id_rec,";
       lsQuery+=" CAST('' as char) as provider_product_code_rec,";
       lsQuery+=" CAST ('0' as integer) as received_quantity,";
       lsQuery+=" CAST('' as char) as provider_unit,";
       lsQuery+=" CAST('15' as  varchar) as difference_id,";
       lsQuery+=" r.report_num as report_num, ";
       lsQuery+=" '3' as forwarding_id ";
       lsQuery+=" FROM op_grl_order o";
       lsQuery+=" FULL OUTER JOIN op_grl_reception r ON r.order_id = o.order_id";
       lsQuery+=" INNER JOIN op_grl_order_detail od ON od.order_id = o.order_id";
       lsQuery+=" FULL OUTER JOIN op_grl_reception_detail rd ON rd.provider_product_code = od.provider_product_code";
       lsQuery+=" AND rd.provider_id = od.provider_id AND r.reception_id = rd.reception_id";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code AND p.provider_id = od.provider_id";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
       lsQuery+=" WHERE r.reception_id= '" + psRecep + "'";
       lsQuery+=" AND p.inv_id NOT IN";
       lsQuery+=" (SELECT p2.inv_id";
       lsQuery+=" FROM op_grl_reception_detail rd";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = rd.provider_product_code AND p2.provider_id = rd.provider_id";
       lsQuery+=" WHERE rd.reception_id='" + psRecep + "')";
       return(lsQuery);
    }

    String getQueryDifRemRecep(String psRecep, String psRem, String psStore){

       //Productos que aparecen en remision, pero la cantidad recibida es diferente.
       String lsQuery="SELECT ";
       lsQuery+="r.reception_id as reception_id, ";
       lsQuery+="r.document_num as document_num, ";
       lsQuery+="r.remission_id as remission_id, ";
       lsQuery+="r.order_id as order_id, ";
       lsQuery+="r.store_id as store_id, ";
       lsQuery+="r.date_id as date_id, ";
       lsQuery+="p.inv_id as inv_id, ";
       lsQuery+="rd.provider_id as provider_id, ";
       lsQuery+="p.stock_code_id as rem_stock_code_id, ";
       lsQuery+="p.provider_product_code as rem_provider_product_code, ";
       lsQuery+="p1.stock_code_id as recep_stock_code_id, ";
       lsQuery+="p1.provider_product_code as recep_provider_product_code, ";
       lsQuery+="rd.received_quantity as received_quantity, ";
       lsQuery+="p1.provider_unit_measure as provider_unit, ";
       lsQuery+="d.difference_id as difference_id, ";
       lsQuery+="r.report_num as report_num, ";
       lsQuery+="rd.forwarding_id as forwarding_id ";
       lsQuery+=" FROM op_grl_remission_detail rmd   ";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.remission_id=rmd.remission_id ";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=rmd.provider_product_code_remis) ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rmd.provider_product_code_remis AND p.provider_id = rmd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code AND p1.provider_id = rd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id ";
       lsQuery+=" WHERE rd.reception_id ='"+psRecep+"'";
       lsQuery+=" AND (rd.received_quantity != rmd.required_quantity) ";

       lsQuery+=" \n UNION \n ";
     
       //Productos que aparecen en recepcion, pero no en la remision
       lsQuery+=" SELECT  ";
       lsQuery+="r.reception_id as reception_id, ";
       lsQuery+="r.document_num as document_num, ";
       lsQuery+="r.remission_id as remission_id, ";
       lsQuery+="r.order_id as order_id, ";
       lsQuery+="r.store_id as store_id, ";
       lsQuery+="r.date_id as date_id, ";
       lsQuery+="p.inv_id as inv_id, ";
       lsQuery+="rd.provider_id as provider_id, ";
       lsQuery+="CAST('' as char) as rem_stock_code_id, ";
       lsQuery+="CAST('' as char) as rem_provider_product_code, ";
       lsQuery+="p.stock_code_id as stock_code_id_rec, ";
       lsQuery+="p.provider_product_code as provider_product_code_rec, ";
       lsQuery+="rd.received_quantity as received_quantity, ";
       lsQuery+="p1.provider_unit_measure as provider_unit, ";
       lsQuery+="d.difference_id as difference_id, ";
       lsQuery+="r.report_num as report_num, ";
       lsQuery+="rd.forwarding_id as forwarding_id ";
       lsQuery+=" FROM op_grl_reception r ";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id ) ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rd.provider_product_code AND p.provider_id = rd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code AND p1.provider_id = rd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id  ";
       lsQuery+=" INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id   ";
       lsQuery+=" WHERE rd.reception_id ='"+psRecep+"' AND rd.provider_product_code not in ";
       lsQuery+="(select rmd.provider_product_code_remis FROM op_grl_remission_detail rmd  ";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.remission_id=rmd.remission_id  ";
       lsQuery+=" INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=rmd.provider_product_code_remis) ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rmd.provider_product_code_remis AND p.provider_id = rmd.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id  ";
       lsQuery+=" WHERE rd.reception_id ='"+psRecep+"')";
       lsQuery+=" \n UNION \n ";
     
       // Productos que aparecen en remision y NO en recepcion
       lsQuery+=" SELECT r.reception_id as reception_id, r.document_num as document_num, ";
       lsQuery+=" r.remission_id as remission_id, r.order_id as order_id, r.store_id as store_id, ";
       lsQuery+=" r.date_id as date_id, p.inv_id as inv_id, rmd.provider_id as provider_id,";
       lsQuery+=" p.stock_code_id as rem_stock_code_id, p.provider_product_code as rem_provider_product_code,";
       lsQuery+=" p.stock_code_id as recep_stock_code_id, p.provider_product_code as recep_provider_product_code,";
       lsQuery+=" rmd.required_quantity as received_quantity, p.provider_unit_measure as provider_unit,";
       lsQuery+=" '15' as difference_id, r.report_num as report_num, ";
       lsQuery+=" '3' as forwarding_id ";
       lsQuery+=" FROM op_grl_remission_detail rmd  ";
       lsQuery+=" INNER JOIN op_grl_reception r ON r.remission_id=rmd.remission_id  ";
       lsQuery+=" INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rmd.provider_product_code_remis AND p.provider_id = rmd.provider_id";
       lsQuery+=" INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id ";
       lsQuery+=" WHERE rmd.remission_id = '" + psRem + "' AND rmd.provider_product_code_remis";
       lsQuery+=" NOT IN  (SELECT provider_product_code FROM op_grl_reception_detail WHERE reception_id = '" + psRecep +"') ";
       lsQuery+=" ORDER BY 4 ASC,7 ASC ";
       return(lsQuery);
    }    

   String getDateTime(){
        String lsDate="";
        String lsQry="";
        Date ldToday=new Date();
        String DATE_FORMAT = "yy-MM-dd";
        int liMonth=(int)ldToday.getMonth();
        int liDay=(int)ldToday.getDate();
        java.text.SimpleDateFormat lsDF = new java.text.SimpleDateFormat(DATE_FORMAT);
        Calendar lsC1 = Calendar.getInstance();
        lsC1.set(1900+(int)ldToday.getYear(), (liMonth) , liDay);
        lsDate=lsDF.format(lsC1.getTime());

     lsQry = "SELECT '20"+lsDate+"' = date_limit FROM op_grl_set_date";
        if(moAbcUtils.queryToString(lsQry).equals("t")){
         lsQry = "SELECT to_char(CAST((now() - time_less) AS DATE), 'YY-MM-DD') FROM op_grl_set_date";
            lsDate=moAbcUtils.queryToString(lsQry);
        }
     System.out.println("QRY_RecepConfirmYum.jsp:"+lsDate);
        return(lsDate);
    }

    String getOrderRemiQuery(){
       String lsQuery=" SELECT distinct  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar),cast(rtrim(o.order_id) as Varchar)";
       lsQuery+=" FROM  op_grl_order_detail o ";
       lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id ";
       lsQuery+=" WHERE  o.order_id not in (SELECT DISTINCT order_id FROM op_grl_remission )";
       lsQuery+=" AND  rtrim(ltrim(o.order_id)||'_'||ltrim(o.provider_id)) NOT IN (SELECT DISTINCT rtrim(ltrim(rp.order_id)||'_'||ltrim(rp.provider_id)) FROM op_grl_reception rp) ";
       lsQuery+=" UNION " ;
       lsQuery+=" SELECT DISTINCT  rtrim(p.provider_id)||'_'||cast(rtrim(o.order_id) as Varchar)||'_'||cast(rtrim(r.remission_id) as Varchar),cast(rtrim(o.order_id) as Varchar)||'/'||cast(rtrim(r.remission_id) as Varchar)";
       lsQuery+=" FROM  op_grl_order_detail o ";
       lsQuery+=" INNER JOIN op_grl_remission r ON r.order_id=o.order_id  AND r.provider_id=o.provider_id ";
       lsQuery+=" INNER JOIN op_grl_cat_provider p ON o.provider_id=p.provider_id ";
       lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception WHERE o.store_id = store_id AND r.remission_id = remission_id) ";

       return(lsQuery);

    }


String getOrderRemissionQuery(){
    String lsQuery = "SELECT trim(p.provider_id)||'_'||cast(rtrim(r.order_id) as VARCHAR)||'_'||cast(rtrim(r.remission_id) as varchar),";
    lsQuery+=" cast(rtrim(r.order_id) as VARCHAR)||'/'||cast(rtrim(r.remission_id) as varchar)";
    lsQuery+=" FROM op_grl_cat_provider p";
    lsQuery+=" INNER JOIN op_grl_remission r ON r.provider_id = p.provider_id";
    lsQuery+=" WHERE NOT EXISTS (SELECT * FROM op_grl_reception re WHERE re.store_id = r.store_id AND re.remission_id = r.remission_id)";
    return(lsQuery);
}

   String getQueryAux(String  psRecep){
    String lsQuery = "";
        String lsRem = "";
        String lsOrd = "";
    String lsPrv = "";
    String lsResultAux ="";
        AbcUtils moAbcUtils = new AbcUtils();
        lsRem=moAbcUtils.queryToString("SELECT ltrim(rtrim(remission_id)) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
        lsOrd=moAbcUtils.queryToString("SELECT ltrim(rtrim(CAST(order_id AS CHAR(6)))) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
    lsPrv=moAbcUtils.queryToString("SELECT ltrim(rtrim(provider_id)) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
    lsQuery = "SELECT ";
    lsQuery += " trim(rd.provider_product_code) as recep_product";
    lsQuery += " FROM op_grl_order_detail od";
    lsQuery += " INNER JOIN op_grl_reception_detail rd ON rd.provider_product_code = od.provider_product_code";
    lsQuery += " INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code";
    lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
    lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
    lsQuery += " WHERE od.order_id = " + lsOrd;
    lsQuery += " AND rd.reception_id = " + psRecep;
    lsQuery += " AND rd.provider_id = '" + lsPrv + "'";
    lsQuery += " AND (rd.received_quantity -od.prv_required_quantity) <> 0";
    lsQuery += " AND d.difference_id = '0'";

    lsResultAux = moAbcUtils.queryToString(lsQuery,"@","");
    return(lsResultAux);
}

    String getQueryDiscCode(){
        int case_id = 6; //Es el de diferencia entre orden y recepcion, pero sin diferencias entre remision y recepcion
            String lsQuery = "";
        lsQuery += " SELECT difference_id from op_grl_cat_config_difference WHERE case_id=" + case_id;
        lsQuery += " ORDER BY sort_seq LIMIT 1";
        AbcUtils moAbcUtils = new AbcUtils();
            String lsSelectedDefault=moAbcUtils.queryToString(lsQuery,"","");
        return(lsSelectedDefault);
    }

    /**
        Crea una tabla para poder crear los reportes de diferencias 
    */
    void insertIntoDifference(String psRecep, AbcUtils moAbcUtils){
        String lsRem = "";
        String lsOrd = "";
        String lsPrv = "";
        String lsDiscrepDesc="";
        String lsQuery = "";
        
        lsRem=moAbcUtils.queryToString("SELECT ltrim(rtrim(remission_id)) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
        lsOrd=moAbcUtils.queryToString("SELECT ltrim(rtrim(CAST(order_id AS CHAR(6)))) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
        lsPrv=moAbcUtils.queryToString("SELECT ltrim(rtrim(provider_id)) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
        
        //Es el de diferencia entre orden y recepcion, cuando el elemento de la orden 
        //no esta en la recepci�           
        lsQuery += " SELECT d.dif_desc FROM op_grl_cat_difference d";
        lsQuery += " INNER JOIN op_grl_cat_config_difference cd ON cd.difference_id = d.difference_id";
        lsQuery += " WHERE case_id=7";
        lsQuery += " ORDER BY sort_seq LIMIT 1";
        
        lsDiscrepDesc = moAbcUtils.queryToString(lsQuery,"","");        

        if (!lsOrd.equals("-1") && !lsOrd.equals("") ){
        lsQuery = "INSERT INTO op_grl_difference ";
         /*******QUERY DE ELEMENTOS QUE MATCHEAN ENTRE ORDEN Y RECEPCION*******/
        lsQuery += "SELECT " + psRecep +",";
        lsQuery += " i.inv_desc as product_name,";
        lsQuery += " od.provider_product_code as order_product,";
        lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
        lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
        lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
        lsQuery += " rd.provider_product_code as recep_product,";
        lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
        lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p.conversion_factor IS NULL then 0 else p.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
        lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
        lsQuery += " d.dif_desc,";
        lsQuery += " to_char(rd.received_quantity - od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
        lsQuery += " to_char((rd.received_quantity -od.prv_required_quantity)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
        lsQuery += " FROM op_grl_order_detail od";
        lsQuery += " INNER JOIN op_grl_reception_detail rd ON rd.provider_product_code = od.provider_product_code and rd.provider_id = od.provider_id";
        lsQuery += " INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code = od.provider_product_code AND p.provider_id = od.provider_id";
        lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
        lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
        lsQuery += " WHERE od.order_id = " + lsOrd;
        lsQuery += " AND rd.reception_id = " + psRecep;
        lsQuery += " AND rd.provider_id = '" + lsPrv + "'";
        lsQuery += " AND (rd.received_quantity -od.prv_required_quantity) <> 0";
    /*******QUERY DE ELEMENTOS QUE MATCHEAN ENTRE ORDEN Y RECEPCION, PERO TIENEN UN CODIGO DE PROVEEDOR DIFERENTE******/
        lsQuery += " \nUNION\n";
        lsQuery += " SELECT " + psRecep +",";
        lsQuery += " i.inv_desc as product_name,";
        lsQuery += " p1.provider_product_code as provider_product_code_order,";
        lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
        lsQuery += " to_char(ROUND((Case When od.inv_required_quantity IS NULL then 0 else od.inv_required_quantity end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
        lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
        lsQuery += " p2.provider_product_code as provider_product_code_recep,";
        lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
        lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p2.conversion_factor IS NULL then 0 else p2.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
        lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
        lsQuery += " d.dif_desc,";
        lsQuery += " to_char(rd.received_quantity - od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
        lsQuery += " to_char((rd.received_quantity -od.prv_required_quantity)*(Case When p2.conversion_factor = Null then 0 else p2.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
        lsQuery += " FROM op_grl_cat_providers_product p1";
        lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.inv_id = p1.inv_id AND p1.provider_id = p2.provider_id";
        lsQuery += " INNER JOIN op_grl_order_detail od ON od.provider_product_code = p1.provider_product_code AND od.provider_id = p1.provider_id";
        lsQuery += " INNER JOIN op_grl_reception_detail rd ON rd.provider_product_code = p2.provider_product_code AND rd.provider_id = p2.provider_id";
        lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
        lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
        lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
        lsQuery += " WHERE  p1.provider_product_code <> p2.provider_product_code";
        lsQuery += " AND od.order_id = "+ lsOrd;
        lsQuery += " AND rd.reception_id = " + psRecep;
        lsQuery += " AND rd.provider_id = '"+ lsPrv + "'";

     /*******QUERY DE ELEMENTOS QUE ESTAN EN ORDEN, PERO NO EN RECEPCION*******/
        lsQuery += " \nUNION\n";

    lsQuery += " SELECT " + psRecep +",";
    lsQuery += " i.inv_desc as product_name,";
    lsQuery += " od.provider_product_code as order_product,";
    lsQuery += " ltrim(to_char(od.prv_required_quantity, '9999990.99'))||' '||m.unit_name as qty_required,";
    lsQuery += " to_char(ROUND((Case When od.prv_required_quantity IS NULL then 0 else od.prv_required_quantity end)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as order_equivalent,";
    lsQuery += " od.prv_required_quantity*od.unit_cost as ord_cost,";
    lsQuery += " '' as recep_product_product,";
    lsQuery += " '' as qty_received,";
    lsQuery += " '' as recep_equivalent,";
    lsQuery += " CAST ('0' as integer) as recep_cost,";
    lsQuery += " CAST('"+ lsDiscrepDesc + "' as varchar) as dif_desc,";
    lsQuery += " to_char(0 -od.prv_required_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
    lsQuery += " to_char((0 -od.prv_required_quantity)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
    lsQuery += " FROM op_grl_order_detail od";
    lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = od.provider_product_code AND p1.provider_id = od.provider_id";
    lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = od.provider_unit";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
    lsQuery += " WHERE od.order_id = " + lsOrd;
    lsQuery += " AND od.provider_id = '" +  lsPrv + "'";
    lsQuery += " AND p1.inv_id NOT IN";
    lsQuery += " (SELECT p2.inv_id";
    lsQuery += " FROM op_grl_reception_detail rd";
    lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = rd.provider_product_code AND p2.provider_id = rd.provider_id";
    lsQuery += " WHERE rd.reception_id=" + psRecep;
    lsQuery += " )";

    /*******QUERY DE ELEMENTOS QUE ESTAN EN RECEPCION, PERO NO EN ORDEN*******/
    lsQuery += " \nUNION\n";
    lsQuery += " SELECT " + psRecep +",";
    lsQuery += " i.inv_desc as product_name,";
    lsQuery += " '' as order_product,";
    lsQuery += " '' as qty_required,";
    lsQuery += " '' as order_equivalent,";
    lsQuery += " CAST('0' as integer) as ord_cost,";
    lsQuery += " rd.provider_product_code as recep_product,";
    lsQuery += " Ltrim(to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name) as qty_received,";
    lsQuery += " to_char(ROUND((Case When rd.received_quantity IS Null then 0 else rd.received_quantity end)*(Case When p1.conversion_factor IS NULL then 0 else p1.conversion_factor end)),'9999990.99')||' '||rtrim(m1.unit_name) as recep_equivalent,";
    lsQuery += " rd.received_quantity*rd.unit_cost as recep_cost,";
    lsQuery += " d.dif_desc,";
    lsQuery += " to_char(rd.received_quantity,'9999990.99')||' '||m.unit_name as dif_prv,";
    lsQuery += " to_char((rd.received_quantity)*(Case When p1.conversion_factor = Null then 0 else p1.conversion_factor end),'9999990.99')||' '||m1.unit_name as dif_inv";
    lsQuery += " FROM op_grl_reception_detail rd";
    lsQuery += " INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code = rd.provider_product_code AND p1.provider_id = rd.provider_id";
    lsQuery += " INNER JOIN op_grl_cat_inventory i ON i.inv_id = p1.inv_id";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p1.provider_unit_measure";
    lsQuery += " INNER JOIN op_grl_cat_unit_measure m1 ON m1.unit_id = i.inv_unit_measure";
    lsQuery += " INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id";
    lsQuery += " WHERE rd.reception_id = " + psRecep ;
    lsQuery += " AND rd.provider_id = '"+ lsPrv + "'";
    lsQuery += " AND p1.inv_id NOT IN (";
    lsQuery += " SELECT p2.inv_id";
    lsQuery += " FROM op_grl_order_detail od";
    lsQuery += " INNER JOIN op_grl_cat_providers_product p2 ON p2.provider_product_code = od.provider_product_code AND p2.provider_id = od.provider_id";
    lsQuery += " WHERE od.order_id=" + lsOrd;
    lsQuery += " )";

        moAbcUtils.executeSQLCommand(lsQuery, new String[]{});

        }
    }

String existRecep(String psRecep){
   String lsCont=moAbcUtils.queryToString("SELECT count(*) FROM op_grl_reception WHERE reception_id ="+psRecep,"","");
   return(lsCont);
}

String getToday(){
   String lsQuery = "";
   String lsToday = "";
   AbcUtils loAbcUtils = new AbcUtils();
   lsQuery += "SELECT to_char(timestamp 'now','YY-MM-DD HH24:MI:SS')";
   lsToday = loAbcUtils.queryToString(lsQuery,"","");
   return(lsToday);
}
%>
