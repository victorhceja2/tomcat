
<%!
String [][] getDataset(String msWeek, String msYear, String msPeriod, String msWeekId, String msDay, int dest)
{
    String lsQuery;
    String selectedDate = getDate(msWeek, msYear, msPeriod, msDay);


    lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate "+
              "FROM ss_cat_time WHERE year_no="+msYear+
              " AND period_no="+msPeriod+
              " AND week_no="+msWeek+" ORDER BY date_id ASC";

    String  [][] Fechas   = moAbcUtils.queryToMatrix(lsQuery);

    String [] FechasLY    = new String[7];
    String [] TotalDias   = new String[7];
    String [] TotalDiasLY = new String[7];
    String [] TransDias   = new String[7];
    String [] TransDiasLY = new String[7];

    String [][] resultset = new String[6][8];

    resultset[0][0] = "Ventas Actual";
    resultset[1][0] = "Ventas LY";
    resultset[2][0] = "Index Vtas.";
    resultset[3][0] = "Trans. Actual";
    resultset[4][0] = "Trans. LY";
    resultset[5][0] = "Index Trans.";

    double rf = 0.0;
    int precision = 100;

    for ( int i = 0; i < 7; i++ ) {
        if ( Fechas[i][0] != null ) {
            lsQuery = "SELECT date '"+Fechas[i][0]+"' - integer '364'";
            FechasLY[i] = moAbcUtils.queryToString(lsQuery);
        }
    }

    if( dest == 0 ) {

        lsQuery = "";

        for ( int i = 0; i < 7; i++ ) {
            if( ! Fechas[i][0].equals("") || Fechas[i][0] != null ) {
                lsQuery = "SELECT SUM(gross_sold) FROM gc_guest_checks "+
                          "WHERE date_id='"+Fechas[i][0]+"' "+
                          "AND status_code='C' "+
                          "AND emp_meal=0";
                TotalDias[i] = moAbcUtils.queryToString(lsQuery);
                if ( TotalDias[i] == null ) {
                    TotalDias[i] = "";
                }
                lsQuery = "SELECT COUNT(*) FROM gc_guest_checks "+
                          "WHERE date_id='"+Fechas[i][0]+"' "+
                          "AND status_code='C' ";
                          //"AND emp_meal=0";
                TransDias[i] = moAbcUtils.queryToString(lsQuery);
                if ( TransDias[i] == null ) {
                    TransDias[i] = "";
                }
            } else {
                TotalDias[i] = "";
                TransDias[i] = "";
            }
            //System.out.println(i+" TotalDias T= "+TotalDias[i]);

            lsQuery = "SELECT SUM(gross_sold) FROM gc_guest_checks "+
                      "WHERE date_id='"+FechasLY[i]+"' "+
                      "AND status_code='C' "+
                      "AND emp_meal=0";
            TotalDiasLY[i] = moAbcUtils.queryToString(lsQuery);
            if ( TotalDiasLY[i] == null ) {
                TotalDiasLY[i] = "";
            }

            lsQuery = "SELECT COUNT(*) FROM gc_guest_checks "+
                      "WHERE date_id='"+FechasLY[i]+"' "+
                      "AND status_code='C' ";
            TransDiasLY[i] = moAbcUtils.queryToString(lsQuery);
            if ( TransDiasLY[i] == null ) {
                TransDiasLY[i] = "";
            }

            //System.out.println(i+" TotalDiasLY T= "+TotalDiasLY[i]);
        
            resultset[0][i+1] = TotalDias[i];
            resultset[1][i+1] = TotalDiasLY[i];
            resultset[3][i+1] = TransDias[i];
            resultset[4][i+1] = TransDiasLY[i];

            if ( TotalDiasLY[i].equals("") || TotalDias[i].equals("") ) {
                resultset[2][i+1] = "";
            } else {
                rf = (Double.parseDouble(TotalDias[i])/Double.parseDouble(TotalDiasLY[i])*100);
                resultset[2][i+1] = Double.toString(Math.floor((rf*precision+.5)/precision));
            }

            if ( TransDiasLY[i].equals("") || TransDias[i].equals("") ) {
                resultset[5][i+1] = "";
            } else {
                rf = (Double.parseDouble(TransDias[i])/Double.parseDouble(TransDiasLY[i])*100);
                resultset[5][i+1] = Double.toString(Math.floor((rf*precision+.5)/precision));
            }

        }
    } else {
        lsQuery = "";
         
        for ( int i = 0; i < 7; i++ ) {
            if( ! Fechas[i][0].equals("") || Fechas[i][0] != null ) {
                lsQuery = "SELECT SUM(gross_sold) FROM gc_guest_checks "+
                          "WHERE date_id='"+Fechas[i][0]+"' "+
                          "AND status_code='C' "+
                          "AND destination='"+dest+"' "+
                          "AND emp_meal=0";
                TotalDias[i] = moAbcUtils.queryToString(lsQuery);
                if ( TotalDias[i] == null ) {
                    TotalDias[i] = "";
                }
                lsQuery = "SELECT COUNT(*) FROM gc_guest_checks "+
                          "WHERE date_id='"+Fechas[i][0]+"' "+
                          "AND status_code='C' "+
                          "AND destination='"+dest+"' ";
                TransDias[i] = moAbcUtils.queryToString(lsQuery);
                if ( TransDias[i] == null ) {
                    TransDias[i] = "";
                }
            } else {
                TotalDias[i] = "";
                TransDias[i] = "";
            }
            //System.out.println(i+" TotalDias "+dest+" = "+TotalDias[i]);
            
            lsQuery = "SELECT SUM(gross_sold) FROM gc_guest_checks "+
                      "WHERE date_id='"+FechasLY[i]+"' "+
                      "AND status_code='C' "+
                      "AND destination='"+dest+"' "+
                      "AND emp_meal=0";
            TotalDiasLY[i] = moAbcUtils.queryToString(lsQuery);

            if ( TotalDiasLY[i] == null ) {
                TotalDiasLY[i] = "";
            }

            lsQuery = "SELECT COUNT(*) FROM gc_guest_checks "+
                      "WHERE date_id='"+FechasLY[i]+"' "+
                      "AND status_code='C' "+
                      "AND destination='"+dest+"' ";
            TransDiasLY[i] = moAbcUtils.queryToString(lsQuery);

            if ( TransDiasLY[i] == null ) {
                TransDiasLY[i] = "";
            }

            //System.out.println(i+" TotalDiasLY "+dest+" = "+TotalDiasLY[i]);

            resultset[0][i+1] = TotalDias[i];
            resultset[1][i+1] = TotalDiasLY[i];
            resultset[3][i+1] = TransDias[i];
            resultset[4][i+1] = TransDiasLY[i];

            if ( TotalDiasLY[i].equals("") || TotalDias[i].equals("") ) {
                resultset[2][i+1] = "";
            } else {
                rf = (Double.parseDouble(TotalDias[i])/Double.parseDouble(TotalDiasLY[i])*100);
                resultset[2][i+1] = Double.toString(Math.floor((rf*precision+.5)/precision));
            }

            if ( TransDiasLY[i].equals("") || TransDias[i].equals("") ) {
                resultset[5][i+1] = "";
            } else {
                rf = (Double.parseDouble(TransDias[i])/Double.parseDouble(TransDiasLY[i])*100);
                resultset[5][i+1] = Double.toString(Math.floor((rf*precision+.5)/precision));
            }
        }
    }

    return resultset;
}

String getDate(String msWeek, String msYear, String msPeriod, String msDay)
{
    String lsQuery;

    lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
    "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
    "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
    "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
    "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";

    return moAbcUtils.queryToString(lsQuery);
}

String getDate(String msWeek, String msYear, String msPeriod, String msDay, int days)
{
    String lsQuery;

    String date;

    lsQuery = "SELECT to_char(date_id, 'YYYY-MM-DD') AS begindate " +
    "FROM ss_cat_time WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
    "week_no="+msWeek+" AND weekday_id IN (SELECT weekday_id FROM ss_cat_time "+
    "WHERE year_no="+msYear+" AND period_no="+msPeriod+" AND "+
    "week_no="+msWeek+" AND EXTRACT(day FROM date_id) = " + msDay + ")";

    date = moAbcUtils.queryToString(lsQuery);

    lsQuery = "SELECT date '"+date+"' - integer '"+days+"'";

    return moAbcUtils.queryToString(lsQuery);
}
%>
