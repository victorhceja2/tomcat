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
        //lfProviderQty       = _getProviderQty(piRowId) * _getProviderCF(piRowId);
                
        //lfMaxQuantity       = Math.floor((lfCurrentExistence - lfInventoryQty - lfProviderQty) / lfProviderConvFact);
        lfMaxQuantity       = Math.floor((lfCurrentExistence + lfInventoryQty ) / lfProviderConvFact);

        return lfMaxQuantity;
    }

    function _getMaxInventoryQty(piRowId)
    {
        lfCurrentExistence  = _getCurrentExistence(piRowId);
        //lfPrvQuantity       = _getProviderQty(piRowId) * _getProviderCF(piRowId);
        lfInventoryQty      = _getInventoryQty(piRowId);
        //lfMaxQuantity       = lfCurrentExistence - lfPrvQuantity - lfInventoryQty; Original
        lfMaxQuantity       = lfCurrentExistence - lfInventoryQty;

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
        //lfOrigProviderQty   = _getProviderQty(lsRowId);

        if(lsElement == lsInventoryId)
            document.getElementById(lsInventoryId).value = _getInventoryQty(lsRowId);
        /*if(lsElement == lsProviderId)
            document.getElementById(lsProviderId).value = _getProviderQty(lsRowId);*/

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
        //lsInventoryQty = 'existence|'+piRowId;
         lsInventoryQty = document.getElementById(lsInventoryQty).value;
         lsInventoryQty = isEmpty(lsInventoryQty)?'0':lsInventoryQty;

        lfInventoryQty = parseFloat(lsInventoryQty);

        return lfInventoryQty;
    }

    function _getNeighborExistence(piRowId){
    	lsNeighborExistence = 'existence|'+piRowId;
	lsNeighborExistence = document.getElementById(lsNeighborExistence).value;
	lsNeighborExistence = isEmpty(lsNeighborExistence)?'0':lsNeighborExistence;

	lfNeighborExistence = parseFloat(lsNeighborExistence);


	return lfNeighborExistence;
    }

    function _getTransferQty(piElement){
    	lsTransferQty = document.getElementById(piElement.id).value;
	lfTransferQty = parseFloat(lsTransferQty);

	return lfTransferQty;
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
	lsProviderProductCode = 'inv_id|'+piRowId;
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
                 {text: 'Producto',colspan:'3', align:'center', hclass:'right'},
                 {text: 'Existencia original', align:'center', hclass:'right'},
                 {text: 'Cantidades a traspasar', align:'center', hclass: 'right'},
                 {text: 'Total traspaso', align:'center', hclass: 'right'},
                 {text: 'Existencia final', align:'center', hclass: 'right'});
                 //{text: 'Pronostico requerido', align: 'center'});

        headers  = new Array(
          //0: codigo de inventario
                 {text:'&nbsp;',width:'2%'},
          // 1: inv_id
                 {text:'C&oacute;digo inventario',width:'3%'},
          // 2: nombre proveedor
                 //{text:'Nombre proveedor ',width:'15%'},
          // 3: descripcion de inventario
                 {text:'Descripci&oacute;n de invitem', width:'17%', hclass:'right', bclass: 'right'},
          // 4: descripcion producto   
                 //{text:'Descripci&oacute;n de producto del proveedor', width:'25%', hclass:'right', bclass: 'right'},
          // 5: Existencia actual en unid de inventario
                 {text:'Unidades inventario',  width:'10%', hclass: 'right', bclass: 'right'},
          // 6: Cantidad a transferir en unid de prov
          //       {text:'Unidades proveedor', width:'5%'},
          // 7: Cantidad a transferir en unid de inv
                 {text:'Unidades inventario ', width:'5%', hclass: 'right', bclass: 'right'},
          // 8: Total a transferir en unid de inv
                 {text:'Unidades inventario ', width:'9%', hclass: 'right', bclass: 'right'},
          // 9: Existencia final en unid de inv
                 {text:'Unidades inventario', width:'9%', hclass: 'right', bclass: 'right'});
         // 10: Pronostico requerido una semana
         //        {text:'Una semana', width:'10%'});
         // 11: Unidades de inventario
         // 12: Unidades de proveedor
         // 13: Factor conversion proveedor
         // 14: Stock code id
         // 15: provider_id

        //props    = new Array(null, null, null, null, null, null, null, {entry: true}, //Original con nombre y descripcion de proveedor
        props    = new Array(null, null, null, null, {entry: true}, null, 
        		null, {hide: true}, {hide: true},
                          {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true});

         if(transferType == 'output')
        ftooltips = new Array(null,null,null,null,null,null, 
                {text: 'maxProviderQty', width: 150},
                {text: 'maxInventoryQty', width: 150}, null,
                null,null,null,null,null,null, null);

         if(transferType == 'input')
        ftooltips = new Array(null,null,null,null,null,null,null, null, null,null,null,null,null,null,null,null);

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setFTooltips(ftooltips);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

        updateFinalExistence(gaDataset);
    }
    

   function customDataset(paDataset) {
	var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;' ";

	for (var idx = 0; idx < paDataset.length; idx++) {
		var liRowId = idx + giNumRows;

		var chkRowControl = 'chkRowControl|' + liRowId;

		lsInventoryUm = 'inventoryUm|' + liRowId;
		lsProviderUm = 'providerUm|' + liRowId;
		lsProviderFc = 'providerFc|' + liRowId;
		lsProviderPD = 'provider_product_desc|' + liRowId;
		lsCurrentExistence = paDataset[idx][3];
		lsInvUm = paDataset[idx][8];
		lsProvQty = paDataset[idx][4];
		lsInvId = paDataset[idx][1];
		
		//console.log("lsInvUm: [" + lsInvUm + "]");

		//console.log("paDataset[" + idx + "]: [" + paDataset[idx] + "]");
		
		paDataset[idx][0] = '<input type=checkbox name=' + chkRowControl
				+ ' id=' + chkRowControl + ' value=' + paDataset[idx][0]
				+ ' checked>';
		paDataset[idx][1] = '<input type=text name="inv_id|' + liRowId
				+ '" id="inv_id|' + liRowId + '" value="' + lsInvId
				+ '" ' + _class + ' READONLY>';
		paDataset[idx][3] = '<div id="currentExistence|' + liRowId + '">'
				+ lsCurrentExistence + '</div>';
		paDataset[idx][9] = '<input type="text" name="providerQty|' + liRowId
				+ '" id="providerQty|' + liRowId + '" size="8" value="'
				+ lsProvQty + '" maxlength="15"  autocomplete="off"'
				+ _class + 'READONLY >';
		paDataset[idx][4] = '<input type="text" name="inventoryQty|'
				+ liRowId
				+ '" id="inventoryQty|'
				+ liRowId
				+ '" size="8" value="'
				+ paDataset[idx][5]
				+ '" '
				+ 'maxlength="15"  autocomplete="off" onKeyDown="handleKeyEvents(event, this)" '
				+ 'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this, true);" '
				+ _class + '>';
		paDataset[idx][5] = '<div id="totalTransfer|' + liRowId + '"></div>';
		paDataset[idx][6] = '<div id="finalExistence|' + liRowId + '"></div>'
				+ '<input type="hidden" name="' + lsInventoryUm + '" id="'
				+ lsInventoryUm + '" value="' + lsInvUm + '">'
				+ '<input type="hidden" name="' + lsProviderUm + '" id="'
				+ lsProviderUm + '" value="' + lsInvUm + '">'
				+ '<input type="hidden" name="' + lsProviderFc + '" id="'
				//+ lsProviderFc + '" value="' + paDataset[idx][13] + '">'
				+ lsProviderFc + '" value="0">'
				+ '<input type="hidden" name="' + lsProviderPD + '" id="'
				+ lsProviderPD + '" value="' + paDataset[idx][2] + '">'
				+ '<input type="hidden" name="provider_id|' + liRowId
				+ '" value="">'
				+ '<input type="hidden" name="existence|' + liRowId
				+ '" id="existence|' + liRowId + '" value="'
				+ parseFloat(lsCurrentExistence) + '">'
				+ '<input type="hidden" name="stock_code_id|' + liRowId
				+ '" value="' + lsInvId + '">'
				+ '<input type="hidden" name="providerQty|' + liRowId
				+ '" id="providerQty|' + liRowId + '" size="8" value="'
				+ lsProvQty + '" maxlength="15"  autocomplete="off"'
				+ _class + 'READONLY >';
		//console.log(paDataset[idx]);
	}
}

    function submitAdd(transferType)
    {
        dest = window.open("",'choose','width=900, height=650, menubar=no,scrollbars=yes,resizable=yes');
        document.frmGrid.target = 'choose';
         if(transferType == 'input')
           document.frmGrid.action = "IChooseProductsYum.jsp";
         if(transferType == 'output')
           document.frmGrid.action = "OChooseProductsYum.jsp";
        document.frmGrid.submit();
    }
    
    function submitAddP(ipRemStore)
    {	
      //alert('IP Remote Store: ' + ipRemStore);
      dest = window.open("",'choose','width=900, height=650, menubar=no,scrollbars=yes,resizable=yes');
      document.frmGrid.target = 'choose';
      document.frmGrid.action = "IChooseProductsYum.jsp?ipRemStore=" + ipRemStore;
    }

   function autoSelect(poEntry)
   {
      var size  = poEntry.length;
      var value = poEntry.value;

      poEntry.value = ' ' + value + '     ';
      poEntry.select();
   }
