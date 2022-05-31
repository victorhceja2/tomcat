
    function initDataGrid(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

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
                     {text: 'Total de cupones aplicados', align: 'center', hclass: 'right', bclass: 'right', colspan: 5});

            headers  = new Array(
            // 0:  Fecha 
                     {text:'Fecha',width:'15%', align:'right', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 1:  Destino 
                     {text:'Destino', width:'26%', align: 'right', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 2:  Descripcion
                     {text:'Descripci&oacute;n', width:'25%', align: 'right', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 3:  Cantidad de cupones 
                     {text:'Cantidad',width:'14%', align: 'right', hclass: 'right', bclass: 'right',sort: 'numeric'},
            // 4:  Cantidad de cupones 
                     {text:'Total de cupones',width:'20%', align:'right', hclass: 'right', bclass: 'right'});

            props    = new Array(null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

              // paDataset[arrayMin[i][3]-1][4] = "<b class=bsTotals>"+arrayMin[i][6]+"</b>";
    function customDataset(paDataset)
    {
        var lsDates = "";
	var lsTickets = new String();

        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
            var lsCurrentNumber = paDataset[liRowId][0];

            if(lsTickets.search(lsCurrentNumber) == -1)// Si no lo encuentra, hay un ticket nuevo
                lsTickets = lsDates.concat(lsCurrentNumber).concat(' ');
            else 
                paDataset[liRowId][0] = "&nbsp;";

            if(paDataset[liRowId][0].search("Totales") != -1 )
            { // Esto pone totales
                //paDataset[liRowId][0] = "<b class=bsTotals>Totales</b>";
                paDataset[liRowId][3] = "<b class=bsTotals>Cupones: "+paDataset[liRowId][3]+"</b>";
                paDataset[liRowId][4] = "<b class=bsTotals>Venta: "+paDataset[liRowId][4]+"</b>";
            }
        }
    }
