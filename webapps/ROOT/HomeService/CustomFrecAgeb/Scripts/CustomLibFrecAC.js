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
        	mheaders = new Array({text: 'Compras Clientes por AGEB',align: 'center',hclass: 'right',bclass: 'right',colspan: 2});
			headers  = new Array(
				// 1:  AGEB
				{text:'AGEB',width:'50%',align:'center',sort:'alpha'},
				// 2: Concntracion
				{text:'Clientes',width:'50%',align:'center',sort:'nemeric'});

			ponLink(gaDataset,"0");

			props = new Array(null,null,{hide:true},{hide:true},{hide:true},{hide:true});
			
        	loGrid.setMainHeaders(mheaders);
        	loGrid.setHeaders(headers);
        	loGrid.setDataProps(props);
        	loGrid.setData(gaDataset);
        	loGrid.drawInto('goDataGrid');
    	}
    }

//****************** FUNCION LINKS *************

function ponLink(data,cols){
	var datagrid = data;
	for(var rowId=0; rowId<data.length; rowId++){
		for(var columnId=0; columnId< data[rowId].length;columnId++){
			if(in_array(columnId, cols)){
				var newValue = new String(data[rowId][columnId]);
				//var pos = poda[columnId];
				if(newValue.length == 0 || newValue == '')
					newValue = '&nbsp;';
				else
					newValue = '<a href=javascript:openPopUp(\"CustomDetailFrecA.jsp?hidFrecu=' + data[rowId][2] + '&hidDate=' + data[rowId][3] + '&hidDateH=' + data[rowId][4] + '&hidAgeb=' + data[rowId][0] + '\");>' + datagrid[rowId][columnId] + '</a>';

				data[rowId][columnId] = newValue;
			}
		}
	}
	return data;
}


function openPopUp(url){
	window.open(url, 'Detalle de concentracion de Clientes por Calles','width=700px, height=500px, left=40, top=40px, menubar=no, scrollbars=yes, resizable=yes');
}
