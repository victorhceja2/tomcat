
    function initDataGrid(piCurrentYear, piPreviousPeriod, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
	liPreviousYear = piCurrentYear - 1; 
	var liPastYear = liPreviousYear - 1;

        loGrid.isReport   = true;
	if(!isReport)
	{
            loGrid.bHeaderFix = true;
            loGrid.height = 300;
	}   
        else
            loGrid.bHeaderFix = false;

        loGrid.padding    = 4;

        if(gaDataset.length > 0)
        {

            mheaders = new Array(
                     {text: 'Coordenada', align: 'center', hclass: 'right', bclass: 'right'},
                     {text: 'A&ntilde;o ' + liPastYear + ' promedio TRX', align: 'center', hclass: 'right', bclass: 'right'},
                     {text: 'A&ntilde;o ' + liPreviousYear + ' promedio TRX', align: 'center', hclass: 'right', bclass: 'right'},
                     {text: 'A&ntilde;o ' + piCurrentYear + ' promedio TRX', align: 'center', hclass: 'right', bclass: 'right'},
                     {text: 'Diferencia de transacciones', align: 'center', hclass: 'right', bclass: 'right'},
                     {text: 'Diferencia de transacciones', align: 'center', hclass: 'right', bclass: 'right'});

            headers  = new Array(
            // 0:  Coordenada
                     {text:'Ageb', width:'10%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Promedio de transacciones del P1 - P actual  de hace dos anios
                     {text:'P1 - P' + piPreviousPeriod, width:'18%', align:'right', hclass: 'right', bclass: 'right'},
            // 2:  Promedio de transacciones del P1 - P actual  de hace un anio
                     {text:'P1 - P'+ piPreviousPeriod, width:'18%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Promedio de transacciones del P1 - P actual  de este anio
                     {text:'P1 - P'+ piPreviousPeriod, width:'18%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Diferencia de transacciones del actual menos el de hace dos anios
                     {text:'' + piCurrentYear +' - '+ liPastYear, width:'18%', align: 'right', hclass: 'right', bclass: 'right'},
            // 5:  Diferencia de transacciones del actual menos el de hace un anio   
                     {text:'' + piCurrentYear +' - '+ liPreviousYear, width:'18%', align: 'right', hclass: 'right', bclass: 'right'});

            props    = new Array(null,null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

    function customDataset(paDataset)
    {
        var liAvgLastTot = 0;
        var liAvgPastTot = 0;
        var liAvgCurrTot = 0;
        var liNoagebs = 0;
        
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {

	    liNoagebs++;
	    liAvgCurrTot += paDataset[liRowId][3]*1;
	    liAvgPastTot += paDataset[liRowId][2]*1;
	    liAvgLastTot += paDataset[liRowId][1]*1;

	    if(paDataset[liRowId][0].search("ZZZZ") != -1 )
	    {
                paDataset[liRowId][0] = "<b class=bsTotals>Totales:".concat(liNoagebs).concat("</b>"); 
                paDataset[liRowId][1] = "<b class=bsTotals>".concat(liAvgLastTot).concat("</b>"); 
                paDataset[liRowId][2] = "<b class=bsTotals>".concat(liAvgPastTot).concat("</b>"); 
                paDataset[liRowId][3] = "<b class=bsTotals>".concat(liAvgLastTot).concat("</b>"); 
                paDataset[liRowId][4] = "<b class=bsTotals>".concat(liAvgLastTot - liAvgCurrTot).concat("</b>"); 
                paDataset[liRowId][5] = "<b class=bsTotals>".concat(liAvgPastTot - liAvgCurrTot).concat("</b>"); 
	    }
        }
    }
