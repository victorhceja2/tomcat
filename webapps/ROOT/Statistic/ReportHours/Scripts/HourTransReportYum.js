
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
                     {text: 'Resumen OD Horarios', align: 'center', hclass: 'right', bclass: 'right', colspan: 8});

            headers  = new Array(
            // 0:  orden
                     {text:' ',width:'15%', align:'left ', hclass: 'right', bclass: 'right'},
            // 1:  Martes
                     {text:'Martes',width:'12%', align:'left ', hclass: 'right', bclass: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'12%', align: 'left ', hclass: 'right', bclass: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'12%', align: 'left ', hclass: 'right', bclass: 'right'},
            // 4:  Viernes
                     {text:'Viernes',width:'12%', align: 'left ', hclass: 'right', bclass: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado',width:'12%', align:'left ', hclass: 'right', bclass: 'right'},
            // 6:  Domingo
                     {text:'Domingo',width:'12%', align: 'left ', hclass: 'right', bclass: 'right'},
            // 7:  Lunes
                     {text:'Lunes',width:'12%', align: 'left ', hclass: 'right', bclass: 'right'});

            props    = new Array({hide: true},null,null,null,null,null,null,null,null,null);

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

    function initDataGrid1(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid1.isReport   = true;
	if(!isReport)
	{
            loGrid1.bHeaderFix = true;
            loGrid1.height = 300;
	}   
        else
            loGrid1.bHeaderFix = false;

        loGrid1.padding    = 4;

        if(gaDataset1.length > 0)
        {
            mheaders1 = new Array(
                     {text: 'Transacciones seis semanas atras', align: 'center', hclass: 'right', bclass: 'right', colspan: 8});


            headers1  = new Array(
            // 0:  Titulo semanas hacia atras
                     {text:'A&ntilde;o',width:'16%', align:'left', hclass: 'right', bclass: 'right'},
            // 1:  W1 6a 58 semana hacia atras
                     {text:'W1',width:'12%', align:'left', hclass: 'right', bclass: 'right'},
            // 2:  W2 5a 57 semana hacia atras
                     {text:'W2', width:'12%', align: 'left', hclass: 'right', bclass: 'right'},
            // 3:  W3 4a 56 semana hacia atras
                     {text:'W3', width:'12%', align: 'left', hclass: 'right', bclass: 'right'},
            // 4:  W4 3a 55 semana hacia atras
                     {text:'W4',width:'12%', align: 'left', hclass: 'right', bclass: 'right'},
            // 5:  W5 2a 54 semana hacia atras
                     {text:'W5',width:'12%', align: 'left', hclass: 'right', bclass: 'right'},
            // 6:  W6 1a 53 semana hacia atras
                     {text:'W6',width:'12%', align: 'left', hclass: 'right', bclass: 'right'},
            // 7:  W0 1a 52 semana hacia atras
                     {text:'LY',width:'12%', align: 'left', hclass: 'right', bclass: 'right'});

            props1    = new Array({hide: true},null,null,null,null,null,null,null,null);

            loGrid1.setMainHeaders(mheaders1);
            loGrid1.setHeaders(headers1);
            loGrid1.setDataProps(props1);
            loGrid1.setData(gaDataset1);
            loGrid1.drawInto('goDataGrid1');
        }
    }

    function customDataset(paDataset)
    {
        /*if(paDataset.length > 1){
           paDataset.pop();  //Esto es para quitar un renglon de mas en el reporte 
        }*/
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
        }
    }

    function customDataset1(paDataset1)
    {
        /*for(var liRowIds=0; liRowIds<paDataset1.length; liRowIds++)
        {
        }*/
    }


