<%@ include file="/Include/CommonLibYum.jsp"%>

<%!String searchTransfers(String msYear, String msPeriod, String msWeek,
			String msDay) {
		java.util.Calendar c = java.util.Calendar.getInstance();
		String year = c.get(java.util.Calendar.YEAR) + "";
		String month = (c.get(java.util.Calendar.MONTH) + 1) < 10 ? "0"
				+ (c.get(java.util.Calendar.MONTH) + 1) : (c
				.get(java.util.Calendar.MONTH) + 1) + "";
		String day = c.get(java.util.Calendar.DAY_OF_MONTH) < 10 ? "0"
				+ c.get(java.util.Calendar.DAY_OF_MONTH) : c
				.get(java.util.Calendar.DAY_OF_MONTH) + "";
		String date = year + "-" + month + "-" + day;
		String dateBussiness = getBussinesDate(msYear, msPeriod, msWeek, msDay);
		String lsQuery = "SELECT dr.indicator_id, description, consideration || '%' AS CONSIDERATION,"
				//FUERA DE OBJETIVO
				+ "CASE WHEN dr.indicator_id=4 THEN CASE "
				+ "WHEN below_target=0 THEN '0.0' "
				+ "WHEN to_char(about_target/below_target, '9.99') > '1.41' THEN to_char(about_target/below_target, '9.99') "
				+ "WHEN to_char(about_target/below_target, '9.99') < '1.19' THEN to_char(about_target/below_target, '9.99') "
				+ "ELSE '0.0' "
				+ "END "
				+ "WHEN dr.indicator_id=5 THEN CASE "
				+ "WHEN about_target=0 THEN '0.00%' "
				+ "WHEN ((below_target/about_target)*100)<100 THEN to_char(100-(below_target/about_target)*100, '999.99%') "
				+ "ELSE '0.00%' "
				+ "END "
				+ "WHEN below_target=0 THEN '0.0%' "
				+ "ELSE to_char((below_target*100)/(below_target+about_target), '999.99%') "
				+ "END AS FUERA_OBJETIVO, "
				//DENTRO DE OBJETIVO
				+ "CASE "
				+ "WHEN dr.indicator_id=4 THEN CASE "
				+ "WHEN below_target=0 THEN '0.0' "
				+ "WHEN about_target=0 THEN '0.0' "
				+ "WHEN to_char(about_target/below_target, '9.99') BETWEEN '1.19' AND '1.41' THEN to_char(about_target/below_target, '9.99') "
				+ "ELSE '0.0' "
				+ "END "
				+ "WHEN dr.indicator_id=5 THEN CASE "
				+ "WHEN about_target=0 THEN '100.00%' "
				+ "WHEN below_target=0 THEN '0.00%' "
				+ "ELSE to_char((below_target/about_target)*100, '999.99%') "
				+ "END "
				+ "WHEN about_target=0 THEN '0.0%' "
				+ "ELSE to_char((about_target*100)/(below_target+about_target), '999.99%') "
				+ "END AS DENTRO_OBJETIVO, "
				//ACUMULADO FUERA DE OBJETIVO
				+ "CASE "
				+ "WHEN dr.indicator_id=4 THEN CASE "
				+ "WHEN accum_below_target=0 THEN '0' "
				+ "WHEN to_char(accum_about_target/accum_below_target, '9.99') > '1.4' THEN to_char(accum_about_target/accum_below_target, '9.99') "
				+ "WHEN to_char(accum_about_target/accum_below_target, '9.99') < '1.2' THEN to_char(accum_about_target/accum_below_target, '9.99') "
				+ "ELSE '0.0' "
				+ "END "
				+ "WHEN dr.indicator_id=5 THEN CASE "
				+ "WHEN accum_about_target=0 THEN '0.00%' "
				+ "WHEN ((accum_below_target/accum_about_target)*100)<100 THEN to_char(100-(accum_below_target/accum_about_target)*100, '999.99%') "
				+ "ELSE to_char((accum_below_target/accum_about_target)*100, '999.99%') "
				+ "END "
				+ "WHEN accum_below_target=0 THEN '0.0%' "
				+ "ELSE to_char((accum_below_target*100)/(accum_below_target+accum_about_target), '999.99%') "
				+ "END AS ACCUM_FUERA_OBJETIVO, "
				//ACUMULADO DENTRO DE OBJETIVO
				+ "CASE "
				+ "WHEN dr.indicator_id=4 THEN CASE "
				+ "WHEN accum_below_target=0 THEN '0' "
				+ "WHEN to_char(accum_about_target/accum_below_target, '9.99') BETWEEN '1.20' AND '1.40' THEN to_char(accum_about_target/accum_below_target, '9.99') "
				+ "ELSE '0.0' "
				+ "END "
				+ "WHEN dr.indicator_id=5 THEN CASE "
				+ "WHEN accum_below_target=0 THEN '0.00%' "
				+ "WHEN accum_about_target=0 THEN '0.00%' "
				+ "WHEN ((accum_below_target/accum_about_target)*100)<100 THEN to_char((accum_below_target/accum_about_target)*100, '999.99%') "
				+ "ELSE to_char(100-((accum_below_target/accum_about_target)*100), '999.99%') "
				+ "END "
				+ "ELSE CASE "
				+ "WHEN (accum_below_target+accum_about_target)=0 THEN '0.0%' "
				+ "ELSE to_char((accum_about_target*100)/(accum_below_target+accum_about_target), '999.99%') "
				+ "END "
				+ "END AS ACCUM_DENTRO_OBJETIVO, "
				//Segmento de tiempo
				+ "segment_time, t.id_segment "
				+ "FROM op_grl_delivery_rpt dr INNER JOIN op_grl_cat_delivery_rpt cdr ON (cdr.indicator_id=dr.indicator_id) "
				+ "INNER JOIN (select id_segment, CAST(min_time AS CHAR(5))||' - '||CAST(close_time AS CHAR(5)) AS segmentos from op_grl_cat_segment_time ) t "
				+ "ON (dr.segment_time = t.segmentos)"
				+ "WHERE bussines_date='" + dateBussiness + "' ";

		/*
		lsQuery += "(SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="
		+ msYear + " ";

		if (!msPeriod.equals("0"))
		lsQuery += " AND period_no=" + msPeriod + " ";

		if (!msWeek.equals("0"))
		lsQuery += " AND week_no=" + msWeek + " ";

		if (!msDay.equals("0"))
		lsQuery += " AND EXTRACT(day from date_id) = " + msDay;

		lsQuery += ") ";
		 */
		System.out
				.println("date: " + date + ", datebussines: " + dateBussiness);
		if (date.equals(dateBussiness)) {
			lsQuery += "AND to_char(date_id, 'HH24:mi')>(SELECT to_char(now()::TIMESTAMP - interval '1 hours', 'HH24:mi')) ";
		}
		lsQuery += "ORDER BY 9,1 asc";

		System.out.println("Query:\n" + lsQuery);
		String lsResult = moAbcUtils.getJSResultSet(lsQuery);
		//System.out.println("Resultado:\n" + lsResult);
		return lsResult;
	}

	String getBussinesDate(String msYear, String msPeriod, String msWeek,
			String msDay) {
		String lsQuery = "SELECT CAST(date_id AS CHAR(10)) FROM ss_cat_time WHERE year_no="
				+ msYear + " ";

		if (!msPeriod.equals("0"))
			lsQuery += " AND period_no=" + msPeriod + " ";

		if (!msWeek.equals("0"))
			lsQuery += " AND week_no=" + msWeek + " ";

		if (!msDay.equals("0"))
			lsQuery += " AND EXTRACT(day from date_id) = " + msDay;
		String lsResult = moAbcUtils.queryToString(lsQuery);
		return lsResult;
	}%>
