    var loGrid = new Bs_DataGrid('loGrid');

    function initDataGrid(isReport, psManager, psCashier){
	var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

	loGrid.isReport   = true;
   	if(!isReport)
	{
	    loGrid.bHeaderFix = true;
	    loGrid.height = 300;
	}
	else
	    loGrid.bHeaderFix = false;
	
	loGrid.padding = 4;

	if(gaDataset.length > 0)
	{

       	    mheaders = new Array(
	        {text: 'Empleado solicitante: '+psManager+' &nbsp;&nbsp;&nbsp;Cajero: '+psCashier, align: 'center',hclass: 'right',bclass: 'right',colspan: 4});

	    headers  = new Array(
            // 1:  Rubro
		{text:'Rubro',width:'30%', align:'left'},
            // 2:  Valor 
		{text:'Valor',width:'20%',align:'left',sort:'alpha'},
            // 3:  Rubro 
		{text:'Rubro',width:'30%',align:'left',sort:'alpha'},
            // 4:  Valor 
		{text:'Valor',width:'20%',align:'left',sort:'alpha'}
	    );

		props = new Array({hide:true},null,null,null,null,{hide:true},{hide:true});

       	loGrid.setMainHeaders(mheaders);
       	loGrid.setHeaders(headers);
       	loGrid.setDataProps(props);
       	loGrid.setData(gaDataset);
       	loGrid.drawInto('goDataGrid');
    	}
    }
