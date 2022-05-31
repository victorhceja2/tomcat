<%!

    CategoryDataset[] createPiecesDataset(int numWeeks, Date begindate)
    {
		String query;
		String dates;

		dates = getWeekDates(numWeeks, begindate);

		query = "SELECT to_char(date_id, 'DD/Mon/YY') AS weekdate, " +
				"ROUND(CAST(ppt_real AS numeric),2) AS ppt_real, " +
				"ROUND(CAST(ppt_sist AS numeric),2) AS ppt_sit, "+
				"ROUND(CAST(ppt_mng AS numeric),2) AS ppt_mng, date_id FROM op_gt_real_sist_mng " +
				//"WHERE ppt_real > 0 AND ppt_sist > 0 AND ppt_mng > 0 AND " +
				"WHERE ppt_sist > 0 AND ppt_mng > 0 AND " +
                "date_trunc('day',date_id) IN (" + dates + ") " +
				"ORDER BY date_id ASC ";

        return populateDataset(moAbcUtils.queryToMatrix(query));
    }

    CategoryDataset[] createTransactionsDataset(int numWeeks, Date begindate)
    {
        String query;
        String dates;

        dates   = getWeekDates(numWeeks, begindate);

        query   = "SELECT to_char(date_id, 'DD/Mon/YY') AS weekdate, " +
				  "trans_real, trans_sist, trans_mng, date_id FROM op_gt_real_sist_mng " +
                  //"WHERE trans_real > 0 AND trans_sist > 0 AND trans_mng > 0 AND " +
                  //Para graficar un dia de la semana actual o futura
                  "WHERE trans_sist > 0 AND trans_mng > 0 AND " +
                  "date_trunc('day',date_id) IN (" + dates + ") "+
                  "ORDER BY date_id ASC ";

        return populateDataset(moAbcUtils.queryToMatrix(query));

    }

    CategoryDataset[] populateDataset(String[][] data)
    {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        double realValue;

        for(int rowId = 0; rowId < data.length; rowId++)
        {
            String date    = data[rowId][0];
            String real    = data[rowId][1];
            String system  = data[rowId][2];
            String manager = data[rowId][3];

            realValue = Float.parseFloat(real);

            if (realValue == 0)
                dataset.addValue(null, "Real", date);
            else                
                dataset.addValue(realValue, "Real", date);

            dataset.addValue(Float.parseFloat(system), "Sistema", date);
            dataset.addValue(Float.parseFloat(manager), "Gerente", date);
        }

        return new CategoryDataset[]{dataset, null};
    }

	//Create raw dataset for real transactions by date
    CategoryDataset[] createTransactionsDataset(int numWeeks, 
							Date currentDate, Date previousDate, String reportType)
    {
        String lsQuery;
        String currentDates;
        String previousDates;

        currentDates  = getWeekDates(numWeeks, currentDate);
        previousDates = getWeekDates(numWeeks, previousDate);

        if(reportType.equals("day"))
        {
            lsQuery = "DROP TABLE op_gt_trans_current";
            moAbcUtils.executeSQLCommand(lsQuery, new String[]{} );

            lsQuery = "DROP TABLE op_gt_trans_previous";
            moAbcUtils.executeSQLCommand(lsQuery, new String[]{} );

            lsQuery = "CREATE TABLE op_gt_trans_current AS " +
                      "SELECT t.period_no, t.week_no, t.date_id, t1.trans_real FROM  " +
                      "op_gt_real_sist_mng t1 INNER JOIN ss_cat_time t " +
                      "ON(t1.date_id = t.date_id) AND date_trunc('day',t.date_id) "+
                      "IN ("+currentDates+")";

            moAbcUtils.executeSQLCommand(lsQuery, new String[]{} );

            lsQuery = "CREATE TABLE op_gt_trans_previous AS " +
                      "SELECT t.period_no, t.week_no, t.date_id, t1.trans_real FROM  " +
                      "op_gt_real_sist_mng t1 INNER JOIN ss_cat_time t " +
                      "ON(t1.date_id = t.date_id) AND date_trunc('day',t.date_id) "+
                      "IN ("+previousDates+")";

            moAbcUtils.executeSQLCommand(lsQuery, new String[]{} );
            
            lsQuery = "SELECT to_char(tc.date_id,'DD/Mon'), tc.trans_real, "+
                      "tp.trans_real, ROUND(CAST(tc.trans_real/tp.trans_real * 100 AS NUMERIC),2) AS idx,"+
                      "tc.week_no  FROM op_gt_trans_current tc,  op_gt_trans_previous tp WHERE " +
                      "tc.week_no = tp.week_no AND "+
                      "tp.trans_real >0 AND tc.trans_real > 0 ORDER BY week_no ";

        }
        else
        {
		    lsQuery = "SELECT to_char(t1.date_id, 'DD/Mon') AS weekdate, " +
				"t1.trans_real AS trans_current_year, t2.trans_real AS trans_previous_year, " +
				"ROUND(CAST ( t1.trans_real / t2.trans_real * 100 AS NUMERIC), 2) AS idx,  " +
				"t1.date_id FROM op_gt_real_sist_mng t1, op_gt_real_sist_mng t2 WHERE  " +
				"to_char(t1.date_id, 'DD/Mon') =  to_char(t2.date_id, 'DD/Mon') AND " +
				"t2.trans_real > 0 AND t1.trans_real > 0 AND date_trunc('day',t1.date_id) " +
				"IN (" + currentDates + ") AND " +
				"date_trunc('day',t2.date_id) IN (" +previousDates+ ") " +
				"ORDER BY date_id ASC ";
        }
                
        return populateDataset(moAbcUtils.queryToMatrix(lsQuery), currentDate, previousDate);

    }

	//Create categoryDataset for index transactions
    CategoryDataset[] populateDataset(String[][] data, Date currentDate, Date previousDate)
    {
		int currentYear, previousYear;
        DefaultCategoryDataset dataset    = new DefaultCategoryDataset();
        DefaultCategoryDataset idxdataset = new DefaultCategoryDataset();
		Calendar calendar = Calendar.getInstance();

		calendar.setTimeInMillis(currentDate.getTime());
		currentYear  = calendar.get(Calendar.YEAR);

		calendar.setTimeInMillis(previousDate.getTime());
		previousYear = calendar.get(Calendar.YEAR);

        for(int rowId = 0; rowId < data.length; rowId++)
        {
            String date     = data[rowId][0];
            String realCurr = data[rowId][1];
            String realPrev = data[rowId][2];
            String index    = data[rowId][3];
			
            dataset.addValue(Float.parseFloat(realCurr), "Transacciones "+currentYear,  date);
            dataset.addValue(Float.parseFloat(realPrev), "Transacciones "+previousYear, date);

            idxdataset.addValue(Float.parseFloat(index), "Indice", date);
        }

        return new CategoryDataset[]{dataset, idxdataset};
    }

	String generateChart(HttpSession session, PrintWriter writer, Date begindate, String columns)
	{
		return 	generateChart(session, writer, begindate, columns, null);
	}
    String generateChart(HttpSession session, PrintWriter writer, Date begindate, String columns, String axisLabel)
    {
        try
        {
			CategoryDataset dataset[] = createDataset(8, begindate);

			if(dataset[0] != null && dataset[0].getColumnCount() > 4)
			{
            	JFreeChart chart = createChart(dataset[0], dataset[1], columns, axisLabel);

				//  Write the chart image to the temporary directory
				ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
				String filename = ServletUtilities.saveChartAsPNG(chart, 740, 400, info, session);

				//  Write the image map to the PrintWriter
				ChartUtilities.writeImageMap(writer, filename, info);
				writer.flush();

	   	        return filename;
			}
			else
				return null;
        }
        catch(Exception e)
        {
            System.out.println("generateChart() exception ... " + e.toString());

			return null;
        }

    }


    static JFreeChart createChart(CategoryDataset dataset, CategoryDataset indexDataset, String columns)
	{
    	return createChart(dataset, indexDataset, columns, null);
	}

    static JFreeChart createChart(CategoryDataset dataset, 
								  CategoryDataset indexDataset, String columns, String axisLabel)
    {
        JFreeChart jfreechart;
		StandardLegend standardlegend;
        CategoryPlot categoryplot;
        NumberAxis numberaxis;
        CategoryAxis categoryaxis;
		ItemLabelPosition itemlabelposition;

        //DEBUG

		jfreechart = ChartFactory.createLineChart(null, axisLabel, columns,
                                        dataset, PlotOrientation.VERTICAL, 
								        true, false, false);
        jfreechart.setBackgroundPaint(Color.white);

        standardlegend = (StandardLegend)jfreechart.getLegend();
        standardlegend.setDisplaySeriesShapes(true);
        standardlegend.setDisplaySeriesLines(true);
        standardlegend.setAnchor(StandardLegend.SOUTH); //NORTH, SOUTH, EAST, WEST

        categoryplot = (CategoryPlot)jfreechart.getPlot();
        categoryplot.setBackgroundPaint(Color.white);
        categoryplot.setRangeGridlinePaint(Color.lightGray);
        categoryplot.setDomainGridlinesVisible(true);

        categoryaxis = categoryplot.getDomainAxis();

        numberaxis = (NumberAxis)categoryplot.getRangeAxis();
        numberaxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
        numberaxis.setAutoRangeIncludesZero(false);

        if(indexDataset != null)
        {
            numberaxis.setLowerMargin(0.4);
        
            NumberAxis indexAxis = new NumberAxis("Indice");
            indexAxis.setAutoRangeIncludesZero(false);
            indexAxis.setLowerMargin(0.1);
            categoryplot.setRangeAxis(1, indexAxis);
            categoryplot.setDataset(1, indexDataset);
            categoryplot.mapDatasetToRangeAxis(1, 1);
        }


        LineAndShapeRenderer linerenderer = (LineAndShapeRenderer)categoryplot.getRenderer();
		//show shapes
        linerenderer.setDrawShapes(true);
        //show quantities
        linerenderer.setLabelGenerator( new StandardCategoryLabelGenerator() );
        linerenderer.setItemLabelsVisible(true);

		//real
        linerenderer.setSeriesStroke(0, new BasicStroke(1.2F, 1, 1, 1, new float[]{1, 1}, 0.0F));
        //Sistema
        linerenderer.setSeriesStroke(1, new BasicStroke(0.5F, 1, 1, 1, new float[]{1, 1}, 0.0F));
		//gerente
        linerenderer.setSeriesStroke(2, new BasicStroke(0.5F, 1, 1, 1, new float[]{6, 6}, 0.0F));

		//real shape, rectangle
		linerenderer.setSeriesShape(0, new java.awt.geom.Rectangle2D.Double(-3.5,-3.5,7,7));
		//system shape, circle
		linerenderer.setSeriesShape(1, new java.awt.geom.Ellipse2D.Double(-4,-4,8,8));
		//manager shape
		linerenderer.setSeriesShape(2, new java.awt.Polygon(new int[]{0,4,-4},new int[]{-4,4,4},3));

		//real quantity
		itemlabelposition = new ItemLabelPosition(ItemLabelAnchor.OUTSIDE9, TextAnchor.CENTER_RIGHT);
		linerenderer.setSeriesPositiveItemLabelPosition(0, itemlabelposition);
		//system quantity
		itemlabelposition = new ItemLabelPosition(ItemLabelAnchor.OUTSIDE3, TextAnchor.CENTER_LEFT);
		linerenderer.setSeriesPositiveItemLabelPosition(1, itemlabelposition);
		//manager quantity
		itemlabelposition = new ItemLabelPosition(ItemLabelAnchor.OUTSIDE6, TextAnchor.TOP_CENTER);
		linerenderer.setSeriesPositiveItemLabelPosition(2, itemlabelposition);


        BarRenderer indexRenderer = new BarRenderer(); 
        indexRenderer.setLabelGenerator( new StandardCategoryLabelGenerator() );
        indexRenderer.setItemLabelsVisible(true);
		itemlabelposition = new ItemLabelPosition(ItemLabelAnchor.INSIDE6, TextAnchor.BOTTOM_CENTER);
		indexRenderer.setSeriesPositiveItemLabelPosition(0, itemlabelposition);
        
        indexRenderer.setSeriesPaint(0, new GradientPaint(0,0, new Color(250, 250, 250), 0,0, Color.white));

        indexRenderer.setMaxBarWidth(0.06);
        categoryplot.setRenderer(1, indexRenderer);

        return jfreechart;
    }



	private String getWeekDates(int numWeeks, Date beginDate)
	{
		Calendar calendar;
		DateFormat dateformat;
		String dates[];
		String currentDate;

        try
        {
    		dateformat  = new SimpleDateFormat("yyyy-MM-dd");
	    	dates       = new String[numWeeks];
		    calendar    = Calendar.getInstance();

            calendar.setTimeInMillis(beginDate.getTime());

	    	while(numWeeks > 0)
		    {
    			currentDate = dateformat.format(calendar.getTime());
			    calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - 7);
			    //calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - 7);
    			//currentDate = dateformat.format(calendar.getTime());

	    		dates[--numWeeks] = currentDate;
		    }
		
            return "'" + moAbcUtils.implodeArray("','",dates) + "'";
        }
        catch(Exception e)
        {
            System.out.println("getWeekDates() exception ... " + e.toString());

            return null;
        }
	}

    String calculatePreviousDate(String psYear, String psPeriod, String psWeek, String psDay)
    {
        String lsQuery;

		lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
                  "FROM ss_cat_time WHERE year_no="+psYear+"-1 AND period_no="+psPeriod+" AND "+
                  "week_no="+psWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
                  "WHERE year_no="+psYear+" AND period_no="+psPeriod+" AND "+
                  "week_no="+psWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";
                    
        return moAbcUtils.queryToString(lsQuery);
    }

    String calculateLimitDate(int numDays)
    {
        String lsQuery;

        lsQuery = "SELECT to_char(current_date + interval '"+numDays+" days', 'YYYY-MM-DD')";

        return moAbcUtils.queryToString(lsQuery);
    }

    void loadRSG()
    {
        System.out.println("Actualizando RSG en dbeyum");

        String lsCommand = "/usr/local/tomcat/webapps/ROOT/Scripts/carga_rsg.s";

        try
        {
            Runtime runtime = Runtime.getRuntime();
            Process process = runtime.exec(lsCommand);
            process.waitFor();
        }
        catch(Exception e)
        {
            System.out.println("loadRSG() exception ... " + e);
        }   

    }
%>
