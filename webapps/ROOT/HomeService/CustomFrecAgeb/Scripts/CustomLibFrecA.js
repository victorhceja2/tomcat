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
        	mheaders = new Array({text: 'Ultima Compra Cliente por AGEB',align: 'center',hclass: 'right',bclass: 'right',colspan: 3});
			headers  = new Array(
            	// 0:  calle
				{text:'Calle',width:'60%', align:'left', sort:'alpha'},
				// 1:  AGEB
				{text:'AGEB',width:'20%',align:'left',sort:'alpha'},
				// 2: Concntracion
				{text:'Clientes',width:'20%',align:'left',sort:'nemeric'});

			posi = new Array('2','3','6');
			ponLink(gaDataset,"0");

			//props = new Array(null,null,null,null,null,null,{hide: true});
			//props = new Array(null,null,null,null,null,null,null,{hide:true},null);
			//props = new Array(null,null,null,null,null,null,null,null);
			props = new Array(null,null,null,{hide:true},{hide:true},{hide:true},{hide:true});
			
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
				var street = data[rowId][0];
				street = street.replace(/\s/g,"_");
				if(newValue.length == 0 || newValue == '')
					newValue = '&nbsp;';
				else
					newValue = '<a href=javascript:openPopUp(\"../../CustomFrec/Entry/CustomDetailFrec.jsp?hidFrecu=' + data[rowId][3] + '&hidDate=' + data[rowId][4] + '&hidDateH=' + data[rowId][5] + '&hidAgeb=' + data[rowId][1] + '&hidStreet=' + street + '&hidBase=&hidPack=\");>' + datagrid[rowId][columnId] + '</a>';

				data[rowId][columnId] = newValue;
			}
		}
	}
	return data;
}


function openPopUp(url){
	window.open(url, 'Clientes Potenciales','width=850px, height=450px, left=10, top=10px, menubar=no, scrollbars=yes, resizable=yes');
}
