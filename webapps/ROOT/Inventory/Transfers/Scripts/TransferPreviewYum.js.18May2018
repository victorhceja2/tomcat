        
    var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana
    var loGrid = new Bs_DataGrid('loGrid');

    function initDataGrid(transferType)
    {
            loGrid.isReport   = true;
            loGrid.bHeaderFix = false;

            for(var idx=0; idx<laDataset.length; idx++)
            {
                //set existence_value
                var lfCurrentExistence    = parseFloat(laDataset[idx][6]);
                //var provider_quantity    = parseFloat(laDataset[idx][6]);
                var lfInventoryQuantity    = parseFloat(laDataset[idx][5]);
                //var provider_conv_fact    = parseFloat(laDataset[idx][13]);
                var lsInventoryUnit     = laDataset[idx][7];

                //var existence_value = lfCurrentExistence + ' ' + lsInventoryUnit;

                //set transfer_value
                //var lfTransferQuantity = (provider_quantity*provider_conv_fact) + lfInventoryQuantity;
                var lfTransferQuantity = lfInventoryQuantity;

                //set final_existence
                //var final_existence = lfCurrentExistence + lfTransferQuantity;
                var final_existence = lfCurrentExistence;

                if(transferType == 'output')
                    final_existence -= lfTransferQuantity;
                if(transferType == 'input')
                    final_existence += lfTransferQuantity;

                var final_existence_value = round_decimals(final_existence,2) + ' ' + lsInventoryUnit;
                            
                laDataset[idx][5] = round_decimals(lfTransferQuantity,2) + ' ' + lsInventoryUnit;                            
                laDataset[idx][7] = final_existence_value;
                laDataset[idx][4] = lfCurrentExistence + ' ' + lsInventoryUnit;
                laDataset[idx][0] = "";
            }

            if(laDataset.length > 0){
            mheaders = new Array(
                     {text: '&nbsp;', hclass:'left'},
                     {text: 'Producto',colspan:'3', align:'center', hclass:'right'},
                     {text: 'Existencia original', align:'center', hclass:'right'},
                     {text: lsTransferMsg, align:'center', hclass: 'right'},
                     {text: 'Total traspaso', align:'center', hclass: 'right'},
                     {text: 'Existencia final', align:'center', hclass: 'right'});

            headers  = new Array(
             // 0: codigo de inventario
                     {text:'&nbsp;',width:'1%', hclass: 'left', bclass: 'left'},
             // 1: codigo proveedor
                     {text:'C&oacute;digo inventario',width:'3%'},
             // 2: nombre proveedor
                //     {text:'Nombre proveedor ',width:'15%'},
             // 3: descripcion de inventario
                     {text:'Descripci&oacute;n de invitem', width:'17%', hclass:'right', bclass: 'right'},
             // 4: descripcion producto    
                  //   {text:'Descripci&oacute;n de producto del proveedor', width:'25%', hclass:'right', bclass: 'right'},
             // 5: Existencia actual en unid de inventario
                     {text:'Unidades <br> inventario',  width:'10%', hclass: 'right', bclass: 'right'},
             // 6: Cantidad a transferir en unid de prov
                     {text:'Unidades inventario', width:'5%'},
             // 7: Cantidad a transferir en unid de inv
                     {text:'Unidades inventario ', width:'5%', hclass: 'right', bclass: 'right'},
             // 8: Total a transferir en unid de inv
                     {text:'Unidades inventario ', width:'9%', hclass: 'right', bclass: 'right'},
             // 9: Existencia final en unid de inv
                     {text:'Unidades inventario', width:'9%', hclass: 'right', bclass: 'right'});
             // 10: Pronostico requerido una semana
             // 11: Unidades de inventario
             // 12: Unidades de proveedor
             // 13: Factor conversion proveedor
             // 14: Stock code id
             // 15: Stock code id

            //props    = new Array(null, null, null, null, null, null, null, null, null, null, //Original con nombre de proveedor y descripcion
            props    = new Array(null, null, null, null, null, null, null, null,
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

