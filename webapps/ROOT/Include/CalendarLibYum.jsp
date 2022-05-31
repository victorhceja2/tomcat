<script language="javascript">
    var giSelectedYear   = <%= msYear %>;
    var giSelectedPeriod = <%= msPeriod %>;
    var giSelectedWeek   = <%= msWeek.equals("0")?"0":getWeekId(msYear, msPeriod, msWeek) %>;
    var giSelectedDay    = <%= msDay %>;
    var giReportType     = <%= msReport %>;

    function getReportHeader(piReportType)
    {
        var lsReportHeader = 'A&ntilde;o ' + giSelectedYear;

        switch(giReportType)
        {
            case 1: //Periodic report
                lsReportHeader = 'A&ntilde;o: ' + giSelectedYear + ', Periodo: ' + giSelectedPeriod;
            break;

            case 2: //Weekly report
                lsReportHeader = 'A&ntilde;o: ' + giSelectedYear + ', Periodo: ' + giSelectedPeriod + ', Semana: ' + giSelectedWeek;
            break;

            case 3: //Daily report
                lsReportHeader = 'A&ntilde;o: ' + giSelectedYear + ', Periodo: ' + giSelectedPeriod + ', Semana: ' + giSelectedWeek + ', D&iacute;a: ' + giSelectedDay + ' de ' + parent.getSelectedMonth();
            break;
       
        }
        lsReportHeader = '<font class="datagrid-leyend">' + lsReportHeader + '</font>';

        return lsReportHeader;
    }
    
    function getReportErrorMsg(piReportType)
    {
        var lsErrorMsg;

        switch(piReportType)
        {
            case 0:
                lsErrorMsg = 'Seleccione alguna fecha del calendario YUM.';
            break;

            case 1: //Periodic report
                lsErrorMsg = 'No se encontraron datos para el periodo ' + giSelectedPeriod + ' de ' + giSelectedYear;
            break;

            case 2: //Weekly report
                lsErrorMsg = 'No se encontraron datos para la semana ' + giSelectedWeek +' del periodo ' + giSelectedPeriod;
            break;

            case 3: //Daily report
                lsErrorMsg = 'No se encontraron datos para el ' + giSelectedDay + ' de ' + parent.getSelectedMonth() + ' de ' + giSelectedYear;
            break;
        }   

        return lsErrorMsg;
    }    

</script>

<%!
	String getDayName(int dayId)
	{
    	String aaccute = "\u00E1";
	    String eaccute = "\u00E9";

		String _day[] = {"Dummy","Domingo", "Lunes","Martes","Mi"+eaccute+"rcoles",
						 "Jueves","Viernes","S"+aaccute+"bado"};

		if(dayId > 0 && dayId <= 7)
			return _day[dayId];
		else
			return null;
	}

    String calculateCurrentDate()
    {
        String lsQuery;

        lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS currentdate FROM " +
                  "ss_cat_time WHERE date_id = current_date";

        return moAbcUtils.queryToString(lsQuery);
    }

	String calculateBeginDate()
	{

        String lsQuery;
		
		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
                  "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay; 
                    
        return moAbcUtils.queryToString(lsQuery);
	}
	String calculateDate(String psYearNo, String psPeriodNo, String psWeekNo, String psDayNumber)
	{
        String lsQuery;
		
		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+psYearNo+" AND period_no="+psPeriodNo+" AND "+
                  "week_no="+psWeekNo+" AND EXTRACT(day FROM date_id) = " + psDayNumber; 
                    
        return moAbcUtils.queryToString(lsQuery);
	}
	String calculateDate(String psYearNo, String psPeriodNo, String psWeekNo)
	{
		String lsQuery;

		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS caldate " +
                  "FROM ss_cat_time WHERE year_no="+psYearNo+" AND period_no="+psPeriodNo+" AND "+
                  "week_no="+psWeekNo+" AND weekday_id=7";

		return moAbcUtils.queryToString(lsQuery);
	}

%>



