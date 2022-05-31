

    var loGrid = new Bs_DataGrid('loGrid');

	var giNumColumns = 13;

	function initDataGrid(isReport)
	{
		var lsFontSize    = (isReport && isReport==true)?'9px':'11px';

        loGrid.isReport   = true;
        loGrid.bHeaderFix = (isReport && isReport==true)?false:true;
        loGrid.spacing    = 0;
        loGrid.padding    = 6;
		//loGrid.numColumns = 15;
        giNumRows         = 0;

	    customDataset(gaDataset);

        giNumRows = gaDataset.length;

        mheaders = new Array(
                 {text: 'Producto', align:'center', hclass:'right'},
                 {text: 'Cantidades en Congelador', colspan: '3', align:'center', hclass:'right'},
                 {text: 'Cantidades en Cuarto Frio', colspan: '3', align:'center', hclass:'right'},
                 {text: 'Cantidades en Bodega', colspan: '3', align: 'center', hclass: 'right'},
                 {text: 'Cantidades en Mostrador', colspan: '3', align: 'center'}
				 );

        headers  = new Array(
		 // 0: descripcion producto
                 {text:'Descripci&oacute;n',width: '16%', hclass: 'right', bclass: 'right' },
		 // 1: unidades proveedor
                 {text:'Prov',width: '7%', bclass: 'sright'},
		 // 2: unidades inventario
                 {text:'Inv ',width: '7%', bclass: 'sright'},
		 // 3: unidades receta
                 {text:'Rec', width: '7%', hclass: 'right', bclass: 'right'},
		 // 4: unidades proveedor
                 {text:'Prov',width: '7%', bclass: 'sright'},
		 // 5: unidades inventario
                 {text:'Inv ',width: '7%', bclass: 'sright'},
		 // 6: unidades receta
                 {text:'Rec', width: '7%', hclass: 'right', bclass: 'right'},
		 // 7: unidades proveedor
                 {text:'Prov',width: '7%', bclass: 'sright'},
		 // 8: unidades inventario
                 {text:'Inv ',width: '7%', bclass: 'sright'},
		 // 9: unidades receta
                 {text:'Rec', width: '7%', hclass: 'right', bclass: 'right'},
		 // 10: unidades proveedor
                 {text:'Prov',width: '7%', bclass: 'sright'},
		 // 11: unidades inventario
                 {text:'Inv ',width: '7%', bclass: 'sright'},
		 // 12: unidades receta
                 {text:'Rec', width: '7%'}
				 );

        props    = new Array(null, null, null, null, null, 
							 null, null, null, null, null, null, null, null);

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

    }

	function customDataset(paDataset)
	{
		for(var idx=0; idx<paDataset.length; idx++)
		{
		    var liRowId = idx + giNumRows;

			if(paDataset[idx].length == giNumColumns)
				continue;
			else
				paDataset[idx][0] = 'colspan=13~'+paDataset[idx][0];
		}
	}

