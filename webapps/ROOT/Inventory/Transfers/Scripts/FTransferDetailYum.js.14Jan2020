    function customFocusElement(psElementId)
    {
        loElement = document.getElementById(psElementId).parentNode;
        lsClassName = loElement.className;
        loElement.className = lsClassName + ' entry_over';
        document.getElementById(psElementId).focus();
    }

    function customUnfocusElement(psElementId)
    {
        loElement = document.getElementById(psElementId).parentNode;
        lsClassName = loElement.className;

         lsClassName=lsClassName.replace(/ entry_over/gi, "");

         loElement.className = lsClassName;
    }


    function _getMaxProviderQty(piRowId)
    {
        lfCurrentExistence  = _getCurrentExistence(piRowId);
        lfInventoryQty      = _getInventoryQty(piRowId);
        lfProviderConvFact  = _getProviderCF(piRowId);
        lfProviderQty       = _getProviderQty(piRowId) * _getProviderCF(piRowId);
                
        lfMaxQuantity       = Math.floor((lfCurrentExistence - lfInventoryQty - lfProviderQty) / lfProviderConvFact);

        return lfMaxQuantity;
    }

    function _getMaxInventoryQty(piRowId)
    {
        lfCurrentExistence  = _getCurrentExistence(piRowId);
        lfPrvQuantity       = _getProviderQty(piRowId) * _getProviderCF(piRowId);
        lfInventoryQty      = _getInventoryQty(piRowId);
        lfMaxQuantity       = lfCurrentExistence - lfPrvQuantity - lfInventoryQty;

        return lfMaxQuantity;
    }    

    function onFocusCustomControl(poControl)
    {
        var lsElement = poControl.name;
        var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
        
        var lsInventoryId   = 'inventoryQty|' + lsRowId;
        var lsProviderId    = 'providerQty|' + lsRowId;

        lfMaxInventoryQty   = _getMaxInventoryQty(lsRowId);
        lfOrigInventoryQty  = _getInventoryQty(lsRowId);

        lfMaxProviderQty    = _getMaxProviderQty(lsRowId);
        lfOrigProviderQty   = _getProviderQty(lsRowId);

        if(lsElement == lsInventoryId)
            document.getElementById(lsInventoryId).value = _getInventoryQty(lsRowId);
        if(lsElement == lsProviderId)
            document.getElementById(lsProviderId).value = _getProviderQty(lsRowId);

      autoSelect(poControl);
    }

    function updateFinalExistence(paDataset)
    {
        for(var idx=0; idx<paDataset.length; idx++)
            updateExistence(idx);
    }

    function _getProviderQty(piRowId)
    {
        lsProviderQty = 'providerQty|'+piRowId;
         lsProviderQty = document.getElementById(lsProviderQty).value;
         lsProviderQty = isEmpty(lsProviderQty)?'0':lsProviderQty;

        lfProviderQty = parseFloat(lsProviderQty);

        return lfProviderQty;
    }
   
      function _getInventoryQty(piRowId)
    {
        lsInventoryQty = 'inventoryQty|'+piRowId;
         lsInventoryQty = document.getElementById(lsInventoryQty).value;
         lsInventoryQty = isEmpty(lsInventoryQty)?'0':lsInventoryQty;

        lfInventoryQty = parseFloat(lsInventoryQty);

        return lfInventoryQty;
    }

    function _getInventoryUm(piRowId)
    {
        lsInventoryUm   = 'inventoryUm|'+piRowId;
        lsInventoryUm   = document.getElementById(lsInventoryUm).value;

        return lsInventoryUm;
    }

    function _getProviderUm(piRowId)
    {
        lsProviderUm    = 'providerUm|'+piRowId;
        lsProviderUm    = document.getElementById(lsProviderUm).value;

        return lsProviderUm;
    }

    function _getProviderCF(piRowId)
    {
        lsProviderFc = 'providerFc|'+piRowId
        lfProviderFc = parseFloat(document.getElementById(lsProviderFc).value);

        return lfProviderFc;
    }

function _getProviderProductCode(piRowId){
	lsProviderProductCode = 'provider_product_code|'+piRowId;
	lsProviderProductCode = document.getElementById(lsProviderProductCode).value;
	return lsProviderProductCode;
}

function _getProviderProductDesc(piRowId){
	lsProviderProductDesc = 'provider_product_desc|'+piRowId;
	lsProviderProductDesc = document.getElementById(lsProviderProductDesc).value;
	return lsProviderProductDesc;
}

    /* Devuelve el valor de la existencia actual */
    function _getCurrentExistence(piRowId)
    {
        var lsCurrentExistence = 'currentExistence|'+piRowId
        var lfCurrentExistence = parseFloat(document.getElementById(lsCurrentExistence).innerHTML);

        return lfCurrentExistence;
    }

    function addProducts(dataset)
    {
       customDataset(dataset);
        loGrid.addRows(dataset);
        giNumRows = giNumRows + dataset.length;
        updateFinalExistence(loGrid.getData());
    }

    function initDataGrid(transferType){        
        loGrid.isReport   = true;
        loGrid.bHeaderFix = false;
        loGrid.spacing    = 0;
        loGrid.padding    = 3;
        giNumRows         = 0;


        if(liTransferExists)
        {
         customDataset(gaDataset);
            giNumRows = gaDataset.length;
        }    

        mheaders = new Array(
                 {text: 'Producto',colspan:'4', align:'center', hclass:'right'},
                 {text: 'Existencia original', align:'center', hclass:'right'},
                 {text: 'Cantidades a traspasar', colspan:'2', align:'center', hclass: 'right'},
                 {text: 'Total traspaso', align:'center', hclass: 'right'},
                 {text: 'Existencia final', align:'center', hclass: 'right'},
                 {text: 'Pronostico requerido', align: 'center'});

        headers  = new Array(
          //0: codigo de inventario
                 {text:'&nbsp;',width:'2%'},
          // 1: codigo proveedor
                 {text:'C&oacute;digo prov',width:'4%'},
          // 2: nombre proveedor
                 {text:'Nombre proveedor ',width:'26%'},
          // 3: descripcion producto   
                 {text:'Descripci&oacute;n', width:'20%', hclass:'right', bclass: 'right'},
          // 4: Existencia actual en unid de inventario
                 {text:'Unidades inventario',  width:'10%', hclass: 'right', bclass: 'right'},
          // 5: Cantidad a transferir en unid de prov
                 {text:'Unidades proveedor', width:'5%'},
          // 6: Cantidad a transferir en unid de inv
                 {text:'Unidades inventario ', width:'5%', hclass: 'right', bclass: 'right'},
          // 7: Total a transferir en unid de inv
                 {text:'Unidades inventario ', width:'9%', hclass: 'right', bclass: 'right'},
          // 8: Existencia final en unid de inv
                 {text:'Unidades inventario', width:'9%', hclass: 'right', bclass: 'right'},
         // 9: Pronostico requerido una semana
                 {text:'Una semana', width:'10%'});
         // 10: Unidades de inventario
         // 11: Unidades de proveedor
         // 12: Factor conversion proveedor
         // 13: Stock code id
         // 14: provider_id

        props    = new Array(null, null, null, null, null, null, {entry: true}, 
                         null, null, null,
                          {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true});

         if(transferType == 'output')
        ftooltips = new Array(null,null,null,null,null, 
                {text: 'maxProviderQty', width: 150},
                {text: 'maxInventoryQty', width: 150}, null,
                null,null,null,null,null,null, null);

         if(transferType == 'input')
        ftooltips = new Array(null,null,null,null,null, 
                null, null, null,
                null,null,null,null,null,null,null);

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setFTooltips(ftooltips);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

        updateFinalExistence(gaDataset);
    }
   function customDataset(paDataset)
   {
        var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;' ";
   
      for(var idx=0; idx<paDataset.length; idx++)
      {
            var liRowId = idx + giNumRows;
            
            var chkRowControl  = 'chkRowControl|'+liRowId;
                        
            lsInventoryUm      = 'inventoryUm|' + liRowId;
            lsProviderUm       = 'providerUm|' + liRowId;
            lsProviderFc       = 'providerFc|' + liRowId;
	    lsProviderPD       = 'provider_product_desc|' + liRowId;
            lsCurrentExistence = paDataset[idx][4];

            paDataset[idx][0] = '<input type=checkbox name='+chkRowControl+
                                ' id='+chkRowControl+' value='+ paDataset[idx][0] +' checked>';
	    paDataset[idx][1] = '<input type=text name="provider_product_code|'+liRowId+
                                '" id="provider_product_code|'+liRowId+'" value="'+ paDataset[idx][1] +'" '+_class+' READONLY>';
            paDataset[idx][4] = '<div id="currentExistence|'+liRowId+'">'+paDataset[idx][4]+'</div>';
            paDataset[idx][5] = '<input type="text" name="providerQty|'+liRowId+
            '" id="providerQty|'+liRowId+'" size="8" value="'+paDataset[idx][5]+
            '" maxlength="15"  autocomplete="off"'+_class+'READONLY >';
            paDataset[idx][6] = '<input type="text" name="inventoryQty|'+liRowId+
            '" id="inventoryQty|'+liRowId+'" size="8" value="'+paDataset[idx][6]+'" '+
            'maxlength="15"  autocomplete="off" onKeyDown="handleKeyEvents(event, this)" '+
            'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this, true);" '+_class+'>';
            paDataset[idx][7] = '<div id="totalTransfer|'+liRowId+'"></div>';
            paDataset[idx][8] = '<div id="finalExistence|'+liRowId+'"></div>' + 
                 '<input type="hidden" name="'+lsInventoryUm+'" id="'+lsInventoryUm+
                 '" value="'+paDataset[idx][10]+'">' +
                 '<input type="hidden" name="'+lsProviderUm+'" id="'+lsProviderUm+
                 '" value="' + paDataset[idx][11]+ '">' +
                 '<input type="hidden" name="'+lsProviderFc+'" id="'+lsProviderFc+
                 '" value="'+paDataset[idx][12]+'">' +
		'<input type="hidden" name="'+lsProviderPD+'" id="'+lsProviderPD+
                 '" value="' + paDataset[idx][3]+ '">' +
		'<input type="hidden" name="provider_id|'+liRowId+
                      '" value="'+paDataset[idx][14]+'">' +
		'<input type="hidden" name="existence|'+liRowId+
                      '" value="'+parseFloat(lsCurrentExistence)+'">'+
                 '<input type="hidden" name="stock_code_id|'+liRowId+
                      '" value="'+paDataset[idx][13]+'">' ;//+
		//'<input type="hidden" name="provider_product_code|'+liRowId+
                  //    '" value="'+paDataset[idx][1]+'">';
         }
      }

    function submitAdd(transferType)
    {
        dest = window.open("",'choose','width=700, height=650, menubar=no,scrollbars=yes,resizable=yes');
        document.frmGrid.target = 'choose';
         if(transferType == 'input')
           document.frmGrid.action = "FIChooseProductsYum.jsp";
         if(transferType == 'output')
           document.frmGrid.action = "FOChooseProductsYum.jsp";
        document.frmGrid.submit();
    }

   function autoSelect(poEntry)
   {
      var size  = poEntry.length;
      var value = poEntry.value;

      poEntry.value = ' ' + value + '     ';
      poEntry.select();
   }
