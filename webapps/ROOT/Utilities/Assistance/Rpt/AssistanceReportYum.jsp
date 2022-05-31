<%--
##########################################################################################################
# Nombre Archivo  : AssistanceReportYum.jsp     
# Compania        : PRB
# Autor           : Sergio Cuellar
# Objetivo        : Reporte de Asistencia biometrico
# Fecha Creacion  : 08/Febrero/12
# Inc/requires    : ../Include/CommonLibyum.jsp
# Observaciones   : Se tiene que declarar un objecto moAbcUtils para que se pueda hacer 
#                   uso de los metodos
##########################################################################################################
--%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="generals.*" %>
<%@ page import="generals.AbcUtils" %>

<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/AssistanceLibYum.jsp" %>


<%! AbcUtils moAbcUtils = new AbcUtils();

    String msPreviousYear;
    String msYear;
    String msPeriod;
    String msWeek;
    String msWeekId;
    String msDay;
    String msReport;
    String msMessage;
    String msDataset;
    String msDatasetW;
    boolean reportOk;
%>

<%
    try
    {
        msYear            = request.getParameter("hidSelectedYear");
        msPeriod          = request.getParameter("hidSelectedPeriod");
        msWeek            = request.getParameter("hidSelectedWeek");
        msDay             = request.getParameter("hidSelectedDay");
        msReport          = request.getParameter("hidReportType");
        msMessage = "";
        msDataset = "new Array()";
        msDatasetW = "new Array()";
        reportOk  = false;

        
        if(msReport.equals("3"))//Se tiene que escoger una semana o un dia
        {
            reportOk  = true;
            msDataset = getDataset(msYear, msPeriod, msWeek, msDay);
            msDatasetW = getDatasetW(msYear, msPeriod, msWeek, msDay);

            logResults(msYear, msPeriod, msWeek, msDay);

            System.out.println("msWeek:"+msWeek);


            if(!msWeek.equals("0"))
            {
                msWeekId = getWeekId(msYear, msPeriod, msWeek);
            }

            String msDate = getDate(msYear, msPeriod, msWeek, msDay);
            System.out.println("msDate:"+msDate);
	        try{
		        int day = Integer.parseInt(msDay);
		        if (day < 10){
	  		        msDay = "0"+msDay;
		        } 
	        } catch ( NumberFormatException nfe){
                nfe.printStackTrace();
	        }

            Date today = Calendar.getInstance().getTime();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String TodayYYMMDD = formatter.format(today);

            String yymmdd  = msDate.substring(0, 4)+"-"+msDate.substring(5,7)+"-"+msDay;
            //System.out.println("yymmdd:"+yymmdd);
            //System.out.println("TodayYYMMDD:"+TodayYYMMDD);
            
            if ( yymmdd.equals(TodayYYMMDD)) {
                String command = "/usr/local/tomcat/webapps/ROOT/Scripts/getFP.sh "+yymmdd;
                System.out.println("Command:"+command);

                try {
                    Process p = Runtime.getRuntime().exec(command);
                    p.waitFor();
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException ie) {
                    ie.printStackTrace();
                }
            }
    } else {
        if(!msReport.equals("3"))
            msMessage = "Seleccione alg&uacute;n d&iacute;a del calendario PRB.";
        else
            msMessage = "Para obtener el reporte, seleccione un dia del calendario PRB";
	    }
	
        //reportOk  = true;//reportOk(msPreviousYear, msYear, msPeriod, msWeekId);
        //updateConm(msYear, msPeriod, msWeekId, msDay); 

    }
    catch(Exception e)
    {
        System.out.println("Exception  de AssistanceReportYum ... " + e);
    }

	//System.out.println(msDataset);
%>

<html>
    <head>
        <%@ include file="/Include/CalendarLibYum.jsp" %>
        <script language="javascript" src="/Scripts/HtmlUtilsYum.js"></script>
        <script src="../Scripts/AssistanceReportYum.js"></script>
        <script>
            var reportOk = <%= reportOk %>;
            
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
                    addHidden(document.mainform, 'hidTitle', 'Reporte de asistencia en biom&eacute;trico');
                    addHidden(document.mainform, 'hidSplit', 'true');
                    submitFrame('preview');
                }
            }
        
            var gaDataset = <%= msDataset %>;
            var gaDatasetW = <%= msDatasetW %>;

            customDataset(gaDataset);
            customDataset(gaDatasetW);

        </script>
    </head>
    <body onLoad=" doAction()" style="margin-left: 0px; margin-right: 0px">
        <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td width="100%">
                <iframe name="preview" width="100%" height="560" frameborder="0"></iframe>
            </td>
        </tr>
        <tr>
            <td width="100%">
                <iframe name="printer" width="100%" height="5" frameborder="0"></iframe>
            </td>
        </tr>
        </table>                      
        <form name="mainform" action="AssistanceReportFrm.jsp">
            <input type="hidden" name="year" value="<%= msYear %>">
            <input type="hidden" name="period" value="<%= msPeriod %>">
            <input type="hidden" name="week" value="<%= msWeekId %>">
            <input type="hidden" name="weekComplete" value="<%= msWeek %>">
            <input type="hidden" name="day" value="<%= msDay %>">
            <input type="hidden" name="hidTarget">
            <input type="hidden" name="hidMessage" value="<%= msMessage %>">
            <input type="hidden" name="hidPreviousYear" value="<%= msPreviousYear %>">
        </form>
    </body>
</html>

    
