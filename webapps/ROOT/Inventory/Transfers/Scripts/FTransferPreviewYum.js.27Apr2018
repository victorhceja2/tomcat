        
    var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana
    var loGrid = new Bs_DataGrid('loGrid');

	function initDataGrid(transferType)
	{
            loGrid.isReport   = true;
            loGrid.bHeaderFix = false;

			for(var idx=0; idx<laDataset.length; idx++)
			{
			    //set existence_value
				var lfCurrentExistence	= parseFloat(laDataset[idx][4]);
				var provider_quantity	= parseFloat(laDataset[idx][5]);
				var lfInventoryQuantity	= parseFloat(laDataset[idx][6]);
				var provider_conv_fact	= parseFloat(laDataset[idx][12]);
                var lsInventoryUnit     = laDataset[idx][10];

                var existence_value = lfCurrentExistence + ' ' + lsInventoryUnit;

				//set transfer_value
				var lfTransferQuantity = lfInventoryQuantity;

				//set final_existence
				var final_existence = lfCurrentExistence;

				if(transferType == 'output')
					final_existence -= lfTransferQuantity;
				if(transferType == 'input')
					final_existence += lfTransferQuantity;

				var final_existence_value = round_decimals(final_existence,2) + ' ' + lsInventoryUnit;
							
				laDataset[idx][7] = round_decimals(lfTransferQuantity,2) + ' ' + lsInventoryUnit;							
			    laDataset[idx][8] = final_existence_value;
				laDataset[idx][0] = "";
			}

			if(laDataset.length > 0){
			mheaders = new Array(
                     {text: '&nbsp;', hclass:'left'},
                     {text: 'Producto',colspan:'3', align:'center', hclass:'right'},
                     {text: 'Existencia original', align:'center', hclass:'right'},
                     {text: lsTransferMsg, colspan:'2', align:'center', hclass: 'right'},
                     {text: 'Total traspaso', align:'center', hclass: 'right'},
                     {text: 'Existencia final', align:'center', hclass: 'right'});

            headers  = new Array(
			 // 0: codigo de inventario
                     {text:'&nbsp;',width:'1%', hclass: 'left', bclass: 'left'},
			 // 1: codigo proveedor
                     {text:'C&oacute;digo prov',width:'4%'},
			 // 2: nombre proveedor
                     {text:'Nombre proveedor ',width:'23%'},
			 // 3: descripcion producto	
                     {text:'Descripci&oacute;n', width:'20%', hclass:'right', bclass: 'right'},
			 // 4: Existencia actual en unid de inventario
                     {text:'Unidades <br> inventario',  width:'12%', hclass: 'right', bclass: 'right'},
			 // 5: Cantidad a transferir en unid de prov
                     {text:'Unidades proveedor', width:'10%'},
			 // 6: Cantidad a transferir en unid de inv
                     {text:'Unidades inventario ', width:'10%', hclass: 'right', bclass: 'right'},
			 // 7: Total a transferir en unid de inv
                     {text:'Unidades inventario ', width:'10%', hclass: 'right', bclass: 'right'},
			 // 8: Existencia final en unid de inv
                     {text:'Unidades inventario', width:'10%', hclass: 'right', bclass: 'right'});
             // 9: Pronostico requerido una semana
             // 10: Unidades de inventario
             // 11: Unidades de proveedor
             // 12: Factor conversion proveedor
             // 13: Stock code id
             // 14: Stock code id

            props    = new Array(null, null, null, null, null, null, null, null, null, 
								 {hide: true},{hide: true},{hide: true},
                                 {hide: true},{hide: true},{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(laDataset);
            loGrid.drawInto('goDataGrid');

            }
        }
        
        function doClose()
        {
		    if(giWinControlClose==0)
			    cancel();
        }

