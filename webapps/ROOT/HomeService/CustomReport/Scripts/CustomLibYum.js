    var loGrid = new Bs_DataGrid('loGrid');

    function initDataGrid(isReport){
		var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
		loGrid.isReport   = true;
   		if(!isReport){
			loGrid.bHeaderFix = true;
			loGrid.height = 300;
		}
		else
			loGrid.bHeaderFix = false;
		
		loGrid.padding = 4;
		if(gaDataset.length > 0){
        	mheaders = new Array({text: 'Ultima Compra Cliente',align: 'center',hclass: 'right',bclass: 'right',colspan: 8});
			headers  = new Array(
            	// 0:  Nombre
				{text:'Nombre',width:'30%', align:'left'},
				// 1:  Direccion
				{text:'Direccion',width:'30%',align:'left',sort:'alpha'},
				// 2: Seccion
				{text:'Ageb',width:'5%',align:'left',sort:'alpha'},
				// 3:  Telefono 
				{text:'Telefono',width:'8%',align:'left'},
				// 4: Fecha ultima Compra
				{text:'Fecha Ultima Compra',width:'10%',align:'right'},
				// 5:Monto ultima Compra
				{text:'Monto',width:'7%',align:'right'},
				// 6: Frecuency
				{text:'Frecuencia',width:'5%',align:'right',sort:'numeric'},
				// 7: Coupon
				{text:'Cupon',width:'5%',align:'left',sort:'alpha'});

			posi = new Array('2','3','6');
			ponLink(gaDataset,"0",posi);

			//props = new Array(null,null,null,null,null,null,{hide: true});
			props = new Array(null,null,null,null,null,null,null,null,{hide:true},{hide:true});

        	loGrid.setMainHeaders(mheaders);
        	loGrid.setHeaders(headers);
        	loGrid.setDataProps(props);
        	loGrid.setData(gaDataset);
        	loGrid.drawInto('goDataGrid');
    	}
    }

//****************** FUNCION LINKS *************

function ponLink(data,cols,poda){
	var datagrid = data;
	for(var rowId=0; rowId<data.length; rowId++){
		for(var columnId=0; columnId< data[rowId].length;columnId++){
			if(in_array(columnId, cols)){
				var newValue = new String(data[rowId][columnId]);
				var pos = poda[columnId];
				var name = data[rowId][0];
				name = name.replace(/\s/g,"_");
				if(newValue.length == 0 || newValue == '')
					newValue = '&nbsp;';
				else
					newValue = '<a href=javascript:openPopUp(\"OrderDetailYum.jsp?nomb=' + name + '&tel=' + data[rowId][3] + '&fec=' + data[rowId][4] + '&seq=' + data[rowId][8] + '&fre=' + data[rowId][6] + '\");>' + datagrid[rowId][columnId] + '</a>';

				data[rowId][columnId] = newValue;
			}
		}
	}
	return data;
}


function openPopUp(url){
	window.open(url, "Detalle Orden","width='10px', height='10px', left='35px', top='20px', menubar='no', scrollbars='yes', resizable='yes'");
}

	//****************** DETALLE COMPRA *********

	function initDataGridSub(isReport){
    	var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
		loGrid.isReport   = true;
		if(!isReport){
			loGrid.bHeaderFix = true;
			loGrid.height = 300;
		}
		else
			loGrid.bHeaderFix = false;
			
		loGrid.padding = 4;
		if(gaDataset.length > 0){
			//mheaders = new Array({text: 'Detalle de Compra', align: 'center', hclass: 'right', bclass: 'right', colspan:6});
			mheaders = new Array({text: 'Detalle de Compra', align: 'center', hclass: 'right', bclass: 'right', colspan:5});
			
			headers = new Array(
				// 0: Cantidad
					{text:'Cantidad',width:'10%',align:'left', hclass: 'right', bclass:'right'},
				// 1: Tipo
					{text:'Type',width:'10%', align:'left', hclass: 'right', bclass: 'right'},
				// 2: Base
					{text:'Base',width:'15%',align:'right',hclass:'right',bclass:'right'},
				// 3: tamano 
				//	{text:'Size', width:'10%', align: 'left', hclass: 'right', bclass: 'right'},
				// 4: Producto
					{text:'Product',width:'55%', align:'right',hclass:'right',bclass:'right'},
				// 5: Precio
					{text:'Price',width:'10%',align:'right',hclass:'right',bclass:'right'});
					
			//props = new Array(null,null,null,null,null,null);
			props = new Array(null,null,null,null,null);
			loGrid.setMainHeaders(mheaders);
			loGrid.setHeaders(headers);
			loGrid.setDataProps(props);
			loGrid.setData(gaDataset);
			loGrid.drawInto('goDataGrid');
		}
	}

	function initDataGridU(isReport){
		var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
		loGridU.isReport = true;
		if(!isReport){
			loGridU.bHeaderFix = true;
			loGridU.height = 300;
		}
		else
			loGridU.bHeaderFix = false;

		loGridU.pandding = 4;
		if(gaDatasetU.length > 0){
			mheaders = new Array({text: 'Fecha Ultimas Compras', align: 'center', hclass: 'right', bclass: 'right', colspan:3});
		
			headers = new Array(
				// 0: Cupon
				        {text:'Cupon',width:'3%',align:'center',hclass:'right',bclass:'right'},
		   		// 1: Fecha
						{text:'Fecha',width:'15%',align:'left', hclass: 'right', bclass: 'right'},
				// 2: Monto
						{text:'Monto',width:'15%',align:'right',hclass:'right',bclass:'right'});

			ponLinkDetalle(gaDatasetU,"1");

			props = new Array(null,null,null,{hide:true},{hide:true},{hide:true},{hide:true},{hide:true});
			loGridU.setMainHeaders(mheaders);
			loGridU.setHeaders(headers);
			loGridU.setDataProps(props);
			loGridU.setData(gaDatasetU);
			loGridU.drawInto('goDataGridU');
		}
	}

function ponLinkDetalle(data,cols){
    var datagrid = data;
    for(var rowId=0; rowId<data.length; rowId++){
        for(var columnId=0; columnId<data[rowId].length;columnId++){
            if(in_array(columnId,cols)){
               var newValue = new String(data[rowId][columnId]);
               var name = data[rowId][7];
               name = name.replace(/\s/g,"_");
               if(newValue.length == 0 || newValue == '')
                    newValue = '&nbsp;';
               else
                   newValue = '<a href=javascript:openPopUp(\"OrderDetailYum.jsp?nomb=' + name + '&tel=' + data[rowId][5] + '&fec=' + data[rowId][3] + '&seq=' + data[rowId][4] + '&fre=' + data[rowId][6] + '\");>' + datagrid[rowId][columnId] + '</a>';
				data[rowId][columnId] = newValue;
            }
		}
	}
	return data;
}
							



	function initDataGridC(isReport){
		var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
		loGridC.isReport = true;
		if(!isReport){
			loGridC.bHeaderFix = true;
			loGridC.height = 300;
		}
		else
			loGridC.bHeaderFix = false;

		loGridC.pandding = 4;
		if(gaDatasetC.length > 0){
			mheaders = new Array({text: 'Cupones Aplicados a la Compra', align:'center', hclass: 'right', bclass: 'right', colspan:3});

			 headers = new Array(
			                 // 0: Descripcion
							 {text:'Descripcion',width:'70%',align:'left',hclass: 'right', bclass: 'right'},
							 // 1: Monto Cupon
							 {text:'Cupon',width:'30%',align:'right',hclass:'right',bclass:'right'});
							 // 2: Total Item
							 //{text:'',width:'25%',align:'right',hclass:'right',bclass:'right'});
													
			props = new Array(null,null);
			loGridC.setMainHeaders(mheaders);
			loGridC.setHeaders(headers);
			loGridC.setDataProps(props);
			loGridC.setData(gaDatasetC);
			loGridC.drawInto('goDataGridC');
		}
	}
