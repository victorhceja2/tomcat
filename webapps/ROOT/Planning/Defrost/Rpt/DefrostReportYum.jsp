
<jsp:include page = '/Include/ValidateSessionYum.jsp' />

<%--
##########################################################################################################
# Nombre Archivo  : DefrostReportYum.jsp
# Compania        : PRB
# Autor           : Sergio Cuellar
# Objetivo        : Reporte de Marinado y descongelado KFC
# Fecha Creacion  : 02/July/2013
# Inc/requires    :
# Modificaciones  : tiras isp 11 oct 13
#                   13 Feb 14 favoritas coronel, coronel supreme
##########################################################################################################
--%>

<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/DefrostLibYum.jsp" %>

<%!
AbcUtils moAbcUtils = new AbcUtils();

String msYear;
String msPeriod;
String msWeek;
String msWeekId;
String msDay;
String msReport;
String msMessage;
String mixCruji;
String mixSecreta;
String mixHCruji;
String mstransCong;
String mspzasTrans;
String msSelectedDate;
String msBCToday;
String msBCTomorrow;
String msBCAfterTomorrow;
String msFCToday;
String msFCTomorrow;
String msFCAfterTomorrow;
String msCSToday;
String msCSTomorrow;
String msCSAfterTomorrow;
String msWingsToday;
String msWingsTomorrow;
String msWingsNext3Days;
String msTendersToday;
String msTendersTomorrow;
String msTendersNext3Days;
String msTotalBC;
String msTotalFC;
String msTotalCS;
String msTotalWings;
String msTotalTenders;
String msTotalCrujiTomorrow;
String msTotalSecretaTomorrow;
String msTotalHCTomorrow;
String msPorcCruji17;
String msPorcSecre17;
String msPorcHC17;
String msTodayHH;
String ms24HH;
String ms48HH;
String msCrujiTarde;
String msSecretaTarde;
String msHotTarde;
String msHotSTarde;
String msAlitasTarde;
String msTendersTarde;
String msTarget;
String msPrintOption;


boolean reportOk;
%>

<%
try
{
    msYear    		= request.getParameter("hidSelectedYear");
    msPeriod  		= request.getParameter("hidSelectedPeriod");
    msWeek    		= request.getParameter("hidSelectedWeek");
    msDay     		= request.getParameter("hidSelectedDay");
    msReport  		= request.getParameter("hidReportType");

    msMessage = "";
    reportOk  = false;

    if(!msWeek.equals("0"))
    {
        msWeekId = getWeekId(msYear, msPeriod, msWeek);
    }

    if(msReport.equals("3"))//Se tiene que escoger un dia
    {
        reportOk  = true;
        try {

            String lsCommand = "/usr/bin/ph/databases/graphics/bin/carga_rsg.pl";
            
            try {
                Runtime runtime = Runtime.getRuntime();
                Process process = runtime.exec(lsCommand);
                process.waitFor();
            } catch(Exception e) {
                System.out.println(e);
            }


            msSelectedDate = getDate(msWeek, msYear, msPeriod, msDay);
            String date = msSelectedDate.substring(2, 10);

            String yesterdaydate    = getYesterdayDate(date);
            String tomorrowdate     = getTomorrowDate(date);
            String dayaftertomorrow = getNDate(date, 2);
	    String daat             = getNDate(date, 3);


	    // Cargar a la BD los horarios graficos de las fechas requeridas
	    String [] cmdtemp = {"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl " + date + ""};
            executeCommand(cmdtemp);
	    cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl " + yesterdaydate + ""};
            executeCommand(cmdtemp);
	    cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl " + tomorrowdate + ""};
            executeCommand(cmdtemp);
	    cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl " + dayaftertomorrow + ""};
            executeCommand(cmdtemp);
	    cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl " + daat + ""};
            executeCommand(cmdtemp);


            String msCurrentHour = getCurrentHour();

            msTodayHH = date+" "+msCurrentHour;
            ms24HH = tomorrowdate+" "+msCurrentHour;
            ms48HH = dayaftertomorrow+" "+msCurrentHour;

            String resODmix = getODmix(yesterdaydate);
            mstransCong = getTransCong(tomorrowdate);
            mspzasTrans = getPzaxTrans(tomorrowdate);

	    System.out.println("Selected date : " + date + "\nYesterday : " + yesterdaydate +
                                "\nTomorrow : " + tomorrowdate + "\nDay after Tomorrow : " + dayaftertomorrow +
                                "\nCurrent Hour : " + msCurrentHour + "\n");

            String [] recetasMix = resODmix.split(",");
            mixCruji   = recetasMix[0];
            mixHCruji  = recetasMix[1];
            mixSecreta = recetasMix[2];

	    System.out.println("Mixes del dia " + yesterdaydate + "\nCruji : " + mixCruji + "\n3aRec : " +
                                mixHCruji + "\nSecreta : " + mixSecreta );

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" bc"};
            msBCToday         = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" bc"};
            msBCTomorrow       = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+dayaftertomorrow+" bc"};
            msBCAfterTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 
            msTotalBC = String.valueOf( Float.parseFloat(msBCToday) + Float.parseFloat(msBCTomorrow) +
                        Float.parseFloat(msBCAfterTomorrow) );

	    System.out.println("BIG CRUNCH \n" + date + " : " + msBCToday +
                                "\n" + tomorrowdate + " : " + msBCTomorrow +
                                "\n" + dayaftertomorrow + " : " + msBCAfterTomorrow +
                                "\nTOTAL : " + msTotalBC + "\n");

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" k"};
            msFCToday         = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" k"};
            msFCTomorrow       = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+dayaftertomorrow+" k"};
            msFCAfterTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            msTotalFC = String.valueOf( Float.parseFloat(msFCToday) + Float.parseFloat(msFCTomorrow) +
                        Float.parseFloat(msFCAfterTomorrow) );

	    System.out.println("Kruncher \n" + date + " : " + msFCToday +
                                "\n" + tomorrowdate + " : " + msFCTomorrow +
                                "\n" + dayaftertomorrow + " : " + msFCAfterTomorrow +
                                "\nTOTAL : " + msTotalFC + "\n");

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" cs"};
            msCSToday         = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" cs"};
            msCSTomorrow       = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+dayaftertomorrow+" cs"};
            msCSAfterTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            msTotalCS = String.valueOf( Float.parseFloat(msCSToday) + Float.parseFloat(msCSTomorrow) +
                        Float.parseFloat(msCSAfterTomorrow) );

	    System.out.println("Coronel Supreme \n" + date + " : " + msCSToday +
                                "\n" + tomorrowdate + " : " + msCSTomorrow +
                                "\n" + dayaftertomorrow + " : " + msCSAfterTomorrow +
                                "\nTOTAL : " + msTotalCS + "\n");

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" t"};
            msTendersToday = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" t"};
            msTendersTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+dayaftertomorrow+" t"};
            String msTendersAfterTom = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+daat+" t"};
            String msTendersAfterAfterTom = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            msTendersNext3Days = String.valueOf( Float.parseFloat(msTendersTomorrow) + Float.parseFloat(msTendersAfterTom) +
                               Float.parseFloat(msTendersAfterAfterTom) );

            msTotalTenders = String.valueOf( Float.parseFloat(msTendersNext3Days) + 
                            Float.parseFloat(msTendersToday) );

	    System.out.println("Tiras \n" + date + " : " + msTendersToday +
                                "\n" + tomorrowdate + " : " + msTendersTomorrow +
                                "\n" + dayaftertomorrow + " : " + msTendersAfterTom +
                                "\n" + daat + " : " + msTendersAfterAfterTom +
                                "\nTOTAL 3 Days : " + msTendersNext3Days +
                                "\nTOTAL : " + msTotalTenders + "\n");

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" c"};
            msTotalCrujiTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" s"};
            msTotalSecretaTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" hc"};
            msTotalHCTomorrow = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" c p"};
            msPorcCruji17 = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" s p"};
            msPorcSecre17 = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" hc p"};
            msPorcHC17 = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" c 17"};
            msCrujiTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" s 17"};
            msSecretaTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" hc 17"};
            msHotTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+tomorrowdate+" hc 15"};
            msHotSTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" a 17"};
            msAlitasTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

            cmdtemp = new String[]{"/bin/sh", "-c", "/usr/bin/ph/perllib/bin/defrost.pl "+date+" t 17"};
            msTendersTarde = (executeCommand(cmdtemp).equals(""))?"0":executeCommand(cmdtemp); 

	    System.out.println("Cruji \n" + 
                                "\n" + tomorrowdate + " : " + msTotalCrujiTomorrow +
                                "\nP : " + date + " : " + msPorcCruji17 +
                                "\n17 : " + date + " : " + msCrujiTarde +
	    			"\nSecreta \n" +
                                "\n" + tomorrowdate + " : " + msTotalSecretaTomorrow +
                                "\nP : " + date + " : " + msPorcSecre17 +
                                "\n17 : " + date + " : " + msSecretaTarde +
	    			"\n3aRec \n" + 
                                "\n" + tomorrowdate + " : " + msTotalHCTomorrow +
                                "\nP : " + date + " : " + msPorcHC17 +
                                "\n17 : " + date + " : " + msHotTarde +
                                "\nhc 15" + tomorrowdate + " : " + msHotSTarde +
                                "\nAlitas" + date + " : " + msAlitasTarde +
                                "\ntiras" + date + " : " + msTendersTarde); 
        }
        catch(Exception e) {
            e.printStackTrace();
            msTarget = "Preview";
        }
    }
    else
    {
        if(msReport.equals("0"))
        msMessage = "Seleccione alg&uacute;n d&iacute;a del calendario Yum.";
        else
        msMessage = "Para obtener el reporte, seleccione un d&iacute; del calendario Yum";
    }
    if(msTarget == null) msTarget="Preview"; 
    if(msTarget.equals("Preview"))
        msPrintOption = "yes";
    else
        msPrintOption = "no";
}
catch(Exception e)
{
    System.out.println("Exception .. " + e);
}
%>

<html>
    <head>
        <%@ include file="/Include/CalendarLibYum.jsp" %>
        <script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
        <script language="javascript" src="/Scripts/AbcUtilsYum.js"></script>
        <link rel="stylesheet" href="/CSS/WaitMessageYum.css" type="text/css">
        <script>
            var reportOk =<%= reportOk %>;

            function submitFrame(frameName)
            {
                document.mainform.target = frameName;

                if(frameName=='preview')
                document.mainform.hidTarget.value = "Preview";

                if(frameName=='printer')
                document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
            }
            function submitFrames()
            {
                setTimeout("submitFrame('printer')", 1000);
                //Despues de 2 seg se carga el segundo frame
                setTimeout("submitFrame('preview')", 3000);
            }

            function doAction()
            {

                if(reportOk == true)
                {
                    submitFrames();
                }
                else
                {
                    document.mainform.action = '/MessageYum.jsp';
                    addHidden(document.mainform, 'hidTitle', 'Plan de Marinado/Descongelado');
                    addHidden(document.mainform, 'hidSplit', 'true');
                    submitFrame('preview');
                }
            }

        </script>
        <div id="divWaitGSO" style="width: 300px; height: 150px" class="wait-gso">
            <br>
            <br>Espere
            por favor...
            <br>
            <br>
        </div>
    </head>
    <body onLoad="doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td width="100%">
                    <iframe name="preview" width="100%" height="530" frameborder="0"></iframe>
                </td>
            </tr>
            <tr>
                <td width="100%">
                    <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
                </td>
            </tr>
        </table>
        <form name="mainform" action="DefrostReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeekId %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidMessage" value="<%= msMessage %>">
            <input type="hidden" name="mixCruji" value="<%= mixCruji %>">
            <input type="hidden" name="mixSecreta" value="<%= mixSecreta %>">
            <input type="hidden" name="mixHCruji" value="<%= mixHCruji %>">
            <input type="hidden" name="mstransCong" value="<%= mstransCong%>">
            <input type="hidden" name="mspzasTrans" value="<%= mspzasTrans%>">
            <input type="hidden" name="msBCToday" value="<%= msBCToday%>">
            <input type="hidden" name="msBCTomorrow" value="<%= msBCTomorrow%>">
            <input type="hidden" name="msBCAfterTomorrow" value="<%= msBCAfterTomorrow%>">
            <input type="hidden" name="msFCToday" value="<%= msFCToday%>">
            <input type="hidden" name="msFCTomorrow" value="<%= msFCTomorrow%>">
            <input type="hidden" name="msFCAfterTomorrow" value="<%= msFCAfterTomorrow%>">
            <input type="hidden" name="msCSToday" value="<%= msCSToday%>">
            <input type="hidden" name="msCSTomorrow" value="<%= msCSTomorrow%>">
            <input type="hidden" name="msCSAfterTomorrow" value="<%= msCSAfterTomorrow%>">
            <input type="hidden" name="msWingsToday" value="<%= msWingsToday%>">
            <input type="hidden" name="msWingsTomorrow" value="<%= msWingsTomorrow%>">
            <input type="hidden" name="msWingsNext3Days" value="<%= msWingsNext3Days%>">
            <input type="hidden" name="msTendersToday" value="<%= msTendersToday%>">
            <input type="hidden" name="msTendersTomorrow" value="<%= msTendersTomorrow%>">
            <input type="hidden" name="msTendersNext3Days" value="<%= msTendersNext3Days%>">
            <input type="hidden" name="msTotalBC" value="<%= msTotalBC%>">
            <input type="hidden" name="msTotalFC" value="<%= msTotalFC%>">
            <input type="hidden" name="msTotalCS" value="<%= msTotalCS%>">
            <input type="hidden" name="msTotalWings" value="<%= msTotalWings%>">
            <input type="hidden" name="msTotalTenders" value="<%= msTotalTenders%>">
            <input type="hidden" name="msTotalCrujiTomorrow" value="<%= msTotalCrujiTomorrow%>">
            <input type="hidden" name="msTotalSecretaTomorrow" value="<%= msTotalSecretaTomorrow%>">
            <input type="hidden" name="msTotalHCTomorrow" value="<%= msTotalHCTomorrow%>">
            <input type="hidden" name="msPorcCruji17" value="<%= msPorcCruji17%>">
            <input type="hidden" name="msPorcSecre17" value="<%= msPorcSecre17%>">
            <input type="hidden" name="msPorcHC17" value="<%= msPorcHC17%>">
            <input type="hidden" name="ms24HH" value="<%= ms24HH%>">
            <input type="hidden" name="ms48HH" value="<%= ms48HH%>">
            <input type="hidden" name="msTodayHH" value="<%= msTodayHH%>">
            <input type="hidden" name="msCrujiTarde" value="<%= msCrujiTarde%>">
            <input type="hidden" name="msSecretaTarde" value="<%= msSecretaTarde%>">
            <input type="hidden" name="msHotTarde" value="<%= msHotTarde%>">
            <input type="hidden" name="msHotSTarde" value="<%= msHotSTarde%>">
            <input type="hidden" name="msAlitasTarde" value="<%= msAlitasTarde%>">
            <input type="hidden" name="msTendersTarde" value="<%= msTendersTarde%>">
        </form>
    </body>
</html>

