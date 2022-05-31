
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
                     {text: 'Llamadas de salida del restaurante a n&uacute;meros que no son clientes', align: 'center', hclass: 'right', bclass: 'right', colspan: 6});

            headers  = new Array(
            // 0:  No. Telefónico
                     {text:'Tel&eacute;fono',width:'20%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que entro el pedido en print1
                     {text:'Linea Telef&oacute;nica', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Hora en que entro al caller 
                     {text:'Hora Llamada', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Hora en que termino la llamada
                     {text:'Hora Termino',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Duración de la llamada
                     {text:'Tiempo de dialogo',width:'15%', align:'right', hclass: 'right', bclass: 'right'},
            // 5:  Fecha de negocio
                     {text:'Fecha Llamada',width:'15%', align: 'right', hclass: 'right', bclass: 'right'});

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
        lsMngLine = new String()    
        lsMngArray = new String()    
        lsNumber = new String()
	    liNoLlamadas = 0
        /*if(paDataset.length > 1){
            paDataset.pop(); // Esto es para quitar un renglon de mas en el reporte 
        }*/
        
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
	        var lsCurrentNumber = paDataset[liRowId][0]; 
	        var lsMngLine = paDataset[liRowId][1];
	        lsMngArray = lsMngLine.split("-")

	        if(lsNumber.search(lsCurrentNumber) == -1)
	        {
                    lsNumber = lsNumber.concat(lsCurrentNumber).concat(' '); 
	        }
	        else
	        {
                    paDataset[liRowId][0] = "&nbsp;";
	        }
	        if(lsMngArray[0] == lsMngArray[1])
	        {
                    paDataset[liRowId][1] = "Linea Gerente ".concat(lsMngArray[0]);
		            liNoLlamadas++;
	        }
	        else
	        {
                    paDataset[liRowId][1] = "Linea No. ".concat(lsMngArray[1]); 
	        }
	        //alert(paDataset[liRowId][0].search("Totales"));
	        if(paDataset[liRowId][0].search("Totales") != -1 )
	        {
                    paDataset[liRowId][1] = "<b class=bsTotals>Llamadas del gerente ".concat(liNoLlamadas).concat("</b>"); 
	        }
        }
    }


    function initDataGridC(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGridC.isReport   = true;
	if(!isReport)
	{
            loGridC.bHeaderFix = true;
            loGridC.height = 300;
	}   
        else
            loGridC.bHeaderFix = false;

        loGridC.padding    = 4;

        if(gaDatasetC.length > 0)
        {

            mheaders = new Array(
                     {text: 'Llamadas de salida del restaurante a clientes', align: 'center', hclass: 'right', bclass: 'right', colspan: 6});

            headers  = new Array(
            // 0:  No. Telefónico
                     {text:'Tel&eacute;fono',width:'20%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que entro el pedido en print1
                     {text:'Linea Telef&oacute;nica', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Hora en que entro al caller 
                     {text:'Hora Llamada', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Hora en que termino la llamada
                     {text:'Hora Termino',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Duración de la llamada
                     {text:'Tiempo de dialogo',width:'15%', align:'right', hclass: 'right', bclass: 'right'},
            // 5:  Fecha de negocio
                     {text:'Fecha Llamada',width:'15%', align: 'right', hclass: 'right', bclass: 'right'});

            props    = new Array(null,null,null,null,null,null,{hide: true});

            loGridC.setMainHeaders(mheaders);
            loGridC.setHeaders(headers);
            loGridC.setDataProps(props);
            loGridC.setData(gaDatasetC);        
            loGridC.drawInto('goDataGridC');
        }
    }

    function customDatasetC(paDatasetC)
    {
        lsMngLine = new String()    
        lsMngArray = new String()    
        lsNumber = new String()
	    liNoLlamadas = 0
        /*if(paDataset.length > 1){
            paDataset.pop(); // Esto es para quitar un renglon de mas en el reporte 
        }*/
        
        for(var liRowId=0; liRowId<paDatasetC.length; liRowId++)
        {
	        var lsCurrentNumber = paDatasetC[liRowId][0]; 
	        var lsMngLine = paDatasetC[liRowId][1];
	        lsMngArray = lsMngLine.split("-")

	        if(lsNumber.search(lsCurrentNumber) == -1)
	        {
                    lsNumber = lsNumber.concat(lsCurrentNumber).concat(' '); 
	        }
	        else
	        {
                    paDatasetC[liRowId][0] = "&nbsp;";
	        }
	        if(lsMngArray[0] == lsMngArray[1])
	        {
                    paDatasetC[liRowId][1] = "Linea Gerente ".concat(lsMngArray[0]);
		            liNoLlamadas++;
	        }
	        else
	        {
                    paDatasetC[liRowId][1] = "Linea No. ".concat(lsMngArray[1]); 
	        }
	        //alert(paDataset[liRowId][0].search("Totales"));
	        if(paDatasetC[liRowId][0].search("Totales") != -1 )
	        {
                    paDatasetC[liRowId][1] = "<b class=bsTotals>Llamadas del gerente ".concat(liNoLlamadas).concat("</b>"); 
	        }
        }
    }
