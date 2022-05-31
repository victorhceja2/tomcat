<%!
    String getStoreName(String psStoreId){
		String lsQuery;

		lsQuery  = "SELECT lpad(CAST(store_id AS CHAR(4)),4,' ') || ' - ' || upper(store_desc) FROM " +
				   "ss_cat_store WHERE store_id="+psStoreId;

		return moAbcUtils.queryToString(lsQuery);
    }

	String getStoreId(){
        return moAbcUtils.queryToString("SELECT store_id from ss_cat_store ","","");
    }
    
    String getStore(){
    	return getStoreId();
    }

    String getStoreName(){
        return moAbcUtils.queryToString("SELECT store_desc from ss_cat_store ","","");
    }


	String getCustomHeader(String psTitle, String psTarget){
   	    String lsHeader ="";
    	lsHeader +=  "<table border='0' width='100%' cellspacing='0' cellpadding='0'>";
	    lsHeader += "<tr>";
    	lsHeader += "<td width='15%' class='descriptionTabla' nowrap>";
	    lsHeader += "<b>Premium! Restaurant Brands</b>";
    	lsHeader += "</td>";
    	lsHeader += "<td width='5%' class='descriptionTabla'>";
    	lsHeader += "<img src='/Images/Menu/yum_icons.gif'>";
    	lsHeader += "</td>";
	    lsHeader += "<td width='80%' align='right'>";
        
       	if(psTarget.equals("Preview"))
		{
	        lsHeader += "<a href='javascript: parent.printer.focus(); parent.printer.print()'>" ;
			lsHeader += "<img src='/Images/Menu/print_button.gif' border='0' align='middle'></a> ";
			lsHeader += "<b class='descriptionTabla'>Imprimir</b>";
		}

        lsHeader += " &nbsp; ";
        
        lsHeader += "</td>";
    	lsHeader += "</tr>";
    	lsHeader += "<tr>";
	    lsHeader += "<td colspan=3 class='mainsubtitle' id='mainSubtitle'>";
    	lsHeader += psTitle;
	    lsHeader += "</td>";
    	lsHeader += "</tr>";
	    lsHeader += "</table>";

	    return(lsHeader);
    }

	String getCurrentYear()
	{
		String lsQry  = "SELECT current_year()";
		String lsYear = moAbcUtils.queryToString(lsQry, "", "");

		return lsYear;
	}
	String getCurrentPeriod()
	{
		String lsQry    = "SELECT current_period()";
		String lsPeriod = moAbcUtils.queryToString(lsQry, "", "");

		return lsPeriod;
	}

	String getCurrentWeek()
	{
		String lsQry  = "SELECT current_week()";
		String lsWeek = moAbcUtils.queryToString(lsQry, "", "");

		return lsWeek;
	}

	String getCurrentWeekNo()
	{
		String lsQuery  = "SELECT current_week_no()";
		String lsWeekNo = moAbcUtils.queryToString(lsQuery, "", "");

		return lsWeekNo;
	}

	String getWeekNo(String psYear, String psPeriod, String psWeek)
	{
		String lsQuery  = "SELECT get_week_no(CAST ("+psYear+" AS smallint), " +
						  "CAST("+psPeriod+" AS smallint), CAST("+psWeek+" AS smallint))";

		String lsWeekNo = moAbcUtils.queryToString(lsQuery,"","");

		return lsWeekNo;
	}

	String getTimestamp(String psYearNo, String psPeriodNo, String psWeekNo)
	{
		String lsQuery;

		lsQuery = "SELECT date_id FROM ss_cat_time WHERE year_no="+psYearNo+" AND "+
				  "period_no="+psPeriodNo+" AND week_no="+psWeekNo+" ORDER BY date_id DESC LIMIT 1";

		return moAbcUtils.queryToString(lsQuery);
	}

	/**
		Obtiene el ID de una semana, 1, 2, 3, 4 ..
	*/
	String getWeekId(String psYearNo, String psPeriodNo, String psWeekNo)
	{
		String lsQuery;
		lsQuery = "SELECT get_week('" + getTimestamp(psYearNo, psPeriodNo, psWeekNo) + "')";

		return moAbcUtils.queryToString(lsQuery);
	}

%>
