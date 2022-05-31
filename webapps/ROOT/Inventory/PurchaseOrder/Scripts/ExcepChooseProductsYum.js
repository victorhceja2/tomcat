function initDataGrid(){
	var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;' ";
	loGrid.buttonsDefaultPath = '/Images/Datagrid/';
	loGrid.bHeaderFix   = true;
	loGrid.height       = 450;
	loGrid.width        = '650';
	if(laDataset.length > 0)
	{
		for(var idx=0; idx<laDataset.length; idx++){
			laDataset[idx][0] = '<input type=checkbox name=chk value='+ laDataset[idx][0] +' onClick=selectItem('+idx+')>';
			laDataset[idx][3] = '<div id="provider|'+idx+'">'+laDataset[idx][8]+'</div>';
			laDataset[idx][5] = '<div id="umeasure|'+idx+'">'+laDataset[idx][11]+'</div>';
		}

	headers  = new Array(
			// 0:  Codigo de inventario
			{text:'&nbsp;',width:'5%'},
			// 1:  Codigo proveedor
			{text:'CVE<br>PROD<br>PROV',width:'10%', sort:true},
			// 2:  Nombre proveedor
			{text:'PRODUCTO ',width:'30%', sort:true},
			//{text:'PRODUCTO ',width:'15%', sort:true},
			// 3:  Descripcion producto	
			{text:'PROVEEDOR', width:'20%', sort:true, hclass:'right', bclass:'right'},
			//{text:'PROVEEDOR', width:'20%', sort:true, hclass:'right', bclass:'right'},
			// 4:  Descripcion de la familia
			{text:'CATEGORIA',  width:'15%'},
			// 5:  Unidad de Medida del Proveedor
			{text:'UNIDAD<BR>MEDIDA',  width:'10%'},
			// 6:  Precio
			{text:'PRECIO',  width:'10%'});
			
	
			props    = new Array(null, null, null, null, null , null, null, {hide: true}, {hide: true}, {hide: true}, {hide: true},{hide: true});
	loGrid.setHeaders(headers);
	loGrid.setDataProps(props);
	loGrid.setData(laDataset);        
	loGrid.drawInto('goDataGrid');
	}
}
		
function addProducts(){
	var laDataset  = new Array();
	var lsInvItems = new String();

	for(var li=0; li<laSelected.length; li++)
		if(laSelected[li]) {
			var lsInvId = gaDataset[li][0];

			//El inv_id no ha sido ya considerado
			if(lsInvItems.search(lsInvId) == -1){
				laDataset.push( gaDataset[li] );
				lsInvItems = lsInvItems.concat(lsInvId).concat(' ');
			}
		}
	
	if(laDataset.length > 0)
		window.opener.addProducts(laDataset);
	close();
}

function selectItem(piRowId){
	laSelected[piRowId] = laSelected[piRowId] ? 0 : 1;
}

function cancel(){
	window.close();
}