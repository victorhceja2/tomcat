
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
            customDataset(gaDataset);

            mheaders = new Array(
				{text: '&nbsp;', hclass: 'left'},
                {text: '&nbsp;', hclass: 'right'},
                {text: 'A&ntilde;o ' + piPreviousYear, align: 'center', hclass: 'right', colspan: 3},
                {text: 'A&ntilde;o ' + piCurrentYear, align: 'center', hclass: 'right', colspan: 3},
                {text: 'Transacciones', align: 'center', hclass: 'right', colspan: 3});

            headers  = new Array(
            // 0:  AGEB
                     {text:'AGEB',width:'6%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  House Hold
                     {text:'House Hold',width:'8%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Promedio 2005
                     {text:'Promedio transacciones', width:'10%', align: 'right'},
            // 3:  Penetracion
                     {text:'Penetraci&oacute;n',width:'10%', align: 'right'},
            // 4:  Participacion
                     {text:'Participaci&oacute;n',width:'10%', hclass: 'right', bclass: 'right', align:'right'},
            // 5:  Objetivo
                     {text:'Objetivo',width:'10%', align:'right'},
            // 6:  Promedio 2006
                     {text:'Promedio transacciones',width:'10%', align:'right'},
            // 7:  Indice anual
                     {text:'&Iacute;ndice anual',width:'10%', hclass: 'right', bclass: 'right', align:'right'},
			// 8:  Transacciones del 2005
                     {text: piPreviousYear,width:'8%', align:'right'},
			// 9:  Transacciones del 2006
                     {text: piCurrentYear,width:'8%', align:'right'},
			//10:  Indice   		 
                     {text:'Indice',width:'9%', hclass: 'right', bclass: 'right', align:'right'});


            props    = new Array(null,null,null,null,null,null,null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

    function customDataset(paDataset)
    {
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
            //Penetracion
            //paDataset[liRowId][3] = paDataset[liRowId][3] + ' %';
            //Participacion
            //paDataset[liRowId][4] = paDataset[liRowId][4] + ' %';
        }
    }


