        function initDataGrid()
		{
            loGrid.buttonsDefaultPath = '/Images/Datagrid/';
            loGrid.bHeaderFix   = true;
            loGrid.height       = 450;
            loGrid.width        = '650';

			if(laDataset.length > 0)
			{
				for(var idx=0; idx<laDataset.length; idx++)
                laDataset[idx][0] = '<input type=checkbox name=chk value='+ laDataset[idx][0] +' onClick=selectItem('+idx+')>';

                mheaders = new Array(
                         {text: 'Producto',colspan:'4', align:'center', hclass:'right'},
                         {text: 'Existencia actual'});

                headers  = new Array(
				// 0:  Codigo de inventario
                         {text:'&nbsp;',width:'5%'},
			    // 1:  Codigo proveedor
                         {text:'C&oacute;digo proveedor',width:'10%', sort:true},
			    // 2:  Nombre proveedor
                         {text:'Nombre proveedor ',width:'25%', sort:true},
			    // 3:  Descripcion producto	
                         {text:'Descripci&oacute;n', width:'40%', sort:true, hclass:'right', bclass:'right'},
			    // 4:  Existencia actual en unid de inventario
                         {text:'Unidades inventario',  width:'20%'});
			    // 5:  Cantidad a transferir en unid de prov
			    // 6:  Cantidad a transferir en unid de inv
                // 7:  Total a transferir en unid de inv
                // 8:  Existencia final en unid de inv
                // 9:  Pronostico requerido una semana
                // 10: Unidades de inventario
                // 11: Unidades de proveedor
                // 12: Factor conversion proveedor
                // 13: Stock code id
                // 14: provider_id

                props    = new Array(null, null, null, null, null, 
						{hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true}, 
						{hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true});

                loGrid.setMainHeaders(mheaders);
                loGrid.setHeaders(headers);
                loGrid.setDataProps(props);
				loGrid.setData(laDataset);        
                loGrid.drawInto('goDataGrid');
			}

        }
		
		function addProducts()
        {
            var laDataset  = new Array();
			var lsInvItems = new String();

            for(var li=0; li<laSelected.length; li++)
                if(laSelected[li]) 
				{
					var lsInvId = gaDataset[li][0];

					//El inv_id no ha sido ya considerado
					if(lsInvItems.search(lsInvId) == -1)
					{
				        laDataset.push( gaDataset[li] );
					    lsInvItems = lsInvItems.concat(lsInvId).concat(' ');
					}	
				}
           
            if(laDataset.length > 0)
                window.opener.addProducts(laDataset);

            close();
        }

        function selectItem(piRowId)
        {
        	laSelected[piRowId] = laSelected[piRowId] ? 0 : 1;
        }

        function cancel()
        {
            window.close();
        }

