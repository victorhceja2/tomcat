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

function onFocusCustomControl(poControl)
{
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    var lsInventoryId   = 'inventoryQty|' + lsRowId;
    var lsProviderId    = 'providerQty|' + lsRowId;
    autoSelect(poControl);
}

function _getQtyReceived(piRowId){
    lsQtyReceived = 'qtyReceived|'+piRowId;
    lsQtyReceived = document.getElementById(lsQtyReceived).value;
    lsQtyReceived = isEmpty(lsQtyReceived)?'0':lsQtyReceived;
    lfQtyReceived = parseFloat(lsQtyReceived);
    
    return lfQtyReceived;
}

function _getInventoryUm(piRowId){
    lsInventoryUm   = 'inventoryUm|'+piRowId;
    lsInventoryUm   = document.getElementById(lsInventoryUm).value;
    return lsInventoryUm;
}

function _getProviderUm(piRowId){
    lsProviderUm    = 'providerUm|'+piRowId;
    lsProviderUm    = document.getElementById(lsProviderUm).value;
    return lsProviderUm;
}

function _getProviderCF(piRowId){
    lsProviderFc = 'providerFc|'+piRowId
    lfProviderFc = parseFloat(document.getElementById(lsProviderFc).value);
    return lfProviderFc;
}

function _getUnitPrice(piRowId){
    lsUnitPrice = 'unitPrice|'+piRowId
    lsUnitPrice = parseFloat(document.getElementById(lsUnitPrice).value);
    return lsUnitPrice;
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

function _getDiscrepancyCode(piRowId){
    lsDifferenceId = 'discCode|'+piRowId;
    lsDifferenceId = document.getElementById(lsDifferenceId).value;
    return lsDifferenceId;
}

function addProducts(dataset)
{
    customDataset(dataset);
    loGrid.addRows(dataset);
    giNumRows = giNumRows + dataset.length;
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

    headers  = new Array(
        //0: Codigo de inventario
        {text:'&nbsp;',width:'4%'},
        // 1: Codigo proveedor
        {text:'C&oacute;digo <br> producto',width:'6%'},
        // 2: Nombre del producto
        {text:'Producto ',width:'30%'},
        // 3: Captura de cantidad recibida (En unidad de proveedor) 
        {text:'CAPTURA <br> CANTIDAD <br> RECIBIDA', width:'15%', hclass:'right', bclass: 'right'},
        // 4: C??digo de discrepancia
        {text:'C&oacute;digo <br>Discrepancia', width:'15%', hclass: 'right', bclass: 'right'},
        // 5: Unidad de medida de inventario
        {text:'Unidad<br>inv', width:'10%'},
        // 6: Precio unitario del producto
        {text:'Precio <br>Unidad ', width:'10%', hclass: 'right', bclass: 'right'},
        // 7: Subtotal
        {text:'Subtotal ', width:'10%', hclass: 'right', bclass: 'right'});
        // 8: Factor de Conversion Proveedor -> Inventario 
        // 9: Unidad de medida de inventario
        // 10: Unidad de medida de proveedor

    props    = new Array(null, null, null, {entry: true}, {entry: true}, null, null, null,{hide: true},{hide: true},{hide: true},{hide: true});

    loGrid.setHeaders(headers);
    loGrid.setDataProps(props);
    loGrid.setData(gaDataset);
    loGrid.drawInto('goDataGrid');
}

function customDataset(paDataset){
    var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: 11px; background-color: transparent;' ";
    for(var idx=0; idx<paDataset.length; idx++)
    {
        var liRowId = idx + giNumRows;
        var chkRowControl  = 'chkRowControl|'+liRowId;

        //options = "<option value=0>Ninguno</option>";
        options = "";
        for(j=0; j<discCodes.length; j++){
            if(discCodes[j][0]==2){
                sel=" selected ";
            }else{
                sel ="";
            }
            options += "<option value="+discCodes[j][0]+ sel + ">" + discCodes[j][1] +"</option>";
        }

        lsInventoryUm      = 'inventoryUm|' + liRowId;
        lsProviderUm       = 'providerUm|' + liRowId;
        lsProviderFc       = 'providerFc|' + liRowId;

        paDataset[idx][0] = '<input type=checkbox name='+chkRowControl+' id='+chkRowControl+' value='+ paDataset[idx][0] +' checked>';
        paDataset[idx][1] = '<input type=text name="provider_product_code|'+liRowId+'" id="provider_product_code|'+liRowId+
                            '" value="'+ paDataset[idx][1] +'" '+_class+' READONLY>';
        paDataset[idx][2] = '<input type=text name="provider_product_desc|'+liRowId+'" id="provider_product_desc|'+liRowId+
                            '" value="'+ paDataset[idx][2] +'" '+_class+' READONLY>';
        paDataset[idx][3] = '<input type="text" name="qtyReceived|'+liRowId+'" id="qtyReceived|'+liRowId+'" size="15" value="'+paDataset[idx][3]+'" '+
                            'maxlength="15"  autocomplete="off" onKeyDown="handleKeyEvents(event, this)" '+
                            'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this, true);" '+_class+'>';
        paDataset[idx][4] = '<select name="discCode|'+liRowId+'" id="discCode|'+liRowId+'" class="descriptionTabla">' + options +'</select>';
        paDataset[idx][5] = '<input type="text" name="invUnit|'+liRowId+'" id="invUnit|'+liRowId+'" size="8" value="'+paDataset[idx][5]+'" '+
                            'maxlength="15"  autocomplete="off"'+_class+'READONLY>';
        paDataset[idx][6] = '<input type="text" name="unitPrice|'+liRowId+
                            '" id="unitPrice|'+liRowId+'" size="8" value="'+paDataset[idx][6]+'" '+'maxlength="15" autocomplete="off"'+_class+'READONLY>';
        paDataset[idx][7] = '<input type="text" name="subtotal|'+liRowId+
                            '" id="subtotal|'+liRowId+'" size="8" value="'+paDataset[idx][7]+'" '+'maxlength="15" autocomplete="off"'+_class+'READONLY>' +
                            '<input type="hidden" name="'+lsProviderFc+'" id="'+lsProviderFc+'" value="'+paDataset[idx][9]+'">' +
                            '<input type="hidden" name="'+lsProviderUm+'" id="'+lsProviderUm+'" value="' + paDataset[idx][11]+ '">' +
                            '<input type="hidden" name="'+lsInventoryUm+'" id="'+lsInventoryUm+'" value="'+paDataset[idx][10]+'">';
    }
}

function submitAdd(transferType)
{
    if(parent.document.frmMaster.cmbOrdRem.selectedIndex == 0){
        alert('Debe seleccionar un Numero de Pedido para capturar una excepcion.');
        parent.document.frmMaster.cmbOrdRem.focus();
        return false;
    }
    dest = window.open("",'choose','width=700, height=650, menubar=no,scrollbars=yes,resizable=yes');
    document.frmGrid.target = 'choose';
    document.frmGrid.action = "ExcepChooseProductsYum.jsp";
    document.frmGrid.submit();
}

function getNumDoc(){
    var numdoc = parent.document.frmMaster.cmbOrdRem.value;
    return(numdoc);
}

function autoSelect(poEntry)
{
    var size  = poEntry.length;
    var value = poEntry.value;

    poEntry.value = ' ' + value + '     ';
    poEntry.select();
}
