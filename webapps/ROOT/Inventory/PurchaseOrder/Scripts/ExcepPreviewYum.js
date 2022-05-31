
var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana
var loGrid = new Bs_DataGrid('loGrid');

function initDataGrid(){
	loGrid.isReport   = true;
	loGrid.bHeaderFix = false;
 	for(var idx=0; idx<laDataset.length; idx++){
 		laDataset[idx][0] = "";
 	}

 	if(laDataset.length > 0){
		headers  = new Array(
		// 0: Orden
		{text:'&nbsp;',width:'1%', hclass: 'left', bclass: 'left'},
		// 1: codigo proveedor
		{text:'C&oacute;digo producto',width:'4%'},
		// 2: nombre producto
		{text:'Producto ',width:'23%'},
		// 3: Cantidad Recibida
		{text:'Cantidad <br>Recibida', width:'12%', hclass:'right', bclass: 'right'},
		// 4: Discrepancia
		{text:'Discrepancia',  width:'18%', hclass: 'right', bclass: 'right'},
		// 5: Conversion Cantidad Recibida a Unidades de Inventario
		{text:'Unidad <br> Inv', width:'10%'},
		// 6: Precio Unitario 
		{text:'Precio <br> Unit ', width:'10%', hclass: 'right', bclass: 'right'},
		// 7: Subtotal 
		{text:'Subtotal ', width:'10%', hclass: 'right', bclass: 'right'});
		// 8 Provider name
		// 9 Conversion factor
		//10 Unidad de Inventario
		//11 Unidad de Proveedor

		props    = new Array(null, null, null, null, null, null, null, null,{hide: true},{hide: true},{hide: true},{hide: true});
	
		loGrid.setHeaders(headers);
		loGrid.setDataProps(props);
		loGrid.setData(laDataset);
		loGrid.drawInto('goDataGrid');
		
	}
}

function doClose(){
	if(giWinControlClose==0)
	cancel();
}

