    // InventoryLibYum.js

    var loGrid = new Bs_DataGrid('loGrid');
    var loGrid2 = new Bs_DataGrid('loGrid2');
    var gaProviderConvFact = new Array();
    var gaRecipeConvFact   = new Array();
    var gaProviderUm       = new Array();
    var gaInventoryUm      = new Array();
    var gaRecipeUm         = new Array();
    var gaUnitCost         = new Array();
    var gaMaxVariance      = new Array();
    var gaMinEfficiency    = new Array();
    var gaMaxEfficiency    = new Array();
    var gaMiscelaneo       = new Array();
    var gaWeekDay	   = new Array();

    var lfOrigProviderQty   = 0;
    var lfOrigInventoryQty  = 0;
    var lfOrigRecipeQty     = 0;
    var lfOrigProviderQtyRec   = 0;
    var lfOrigInventoryQtyRec  = 0;
    var lfOrigRecipeQtyRec     = 0;
    var lfOrigDecreaseQty   = 0;
    var lfOrigProviderConvF = 0;
    var liBusinessDay	    = 0;
    var lfFinalInvQty	    = 0;

    var giNumColumns       = 30;
    var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana
    var gsValid;


    function initDataGrid(isReport)
    {
        var lsFontSize    = (isReport && isReport==true)?'9px':'11px';
        loGrid.isReport   = true;
        loGrid.bHeaderFix = (isReport && isReport==true)?false:true;
        loGrid.spacing    = 0;
        loGrid.padding    = 3;
        loGrid.height     = 280;
        loGrid.numColumns = 14;
        giNumRows         = 0;

        customDataset(gaDataset, lsFontSize);
        giNumRows = gaDataset.length;

        mheaders = new Array(
                 {text: 'Producto', align:'center', hclass:'right'},
                 {text: 'Movimientos en unid inv', colspan: '4', align:'center', hclass:'right'},
                 {text: 'Captura Inventario', colspan: '6', align:'center', hclass:'right'},
                 {text: 'Inv Final', align:'center', hclass:'right'},
                 {text: 'Cierre inventario', align:'center', hclass: 'right'},
		 {text: 'Merma', align: 'center', hclass: 'right'}
                 //{text: 'Faltante', align: 'center'}
        );

        headers  = new Array(
         // 0: descripcion producto
                 {text:'Descripci&oacute;n',width: '16%', hclass: 'right', bclass: 'right' },
         // 1: inventario inicial
                 {text:'Inv inicial' ,width: '6%', hclass: 'right', bclass: 'right'},
         // 2: recepciones
                 {text:'Recep ',width: '6%'},
         // 3: transferencias de entrada
                 {text:'Transf entrada', width: '6%'},
         // 4: transferencias de salida
                 {text:'Transf salida',  width: '6%', hclass: 'right', bclass: 'right'},
         // 5: inventario final unid prov
                 {text:'Unid prov', width: '5%'},
         // 6: inventario final unid prov
                 {text:'Unid prov rec', width: '5%'},
         // 7:  inventario final unid inv
                 {text:'Unid inv', width: '6%'},
         // 8:  inventario final unid inv
                 {text:'Unid inv rec', width: '6%'},
         // 9:  inventario final unid receta
                 {text:'Unid rec', width: '5%', hclass: 'right', bclass: 'right'},
         // 10: inventario final unid receta
                 {text:'Unid rec rec', width: '5%', hclass: 'right', bclass: 'right'},
         // 11:  inventario final Total
                 {text:'Unid inv', width: '9%', hclass: 'right', bclass: 'right'},
         // 12: uso real
                 {text:'Uso real', width: '6%', hclass: 'right', bclass: 'right'},
         // 13: uso ideal
                 //{text:'Uso ideal', width: '6%'},
         // 14: diferencia uso ideal - uso real
                 //{text:'Var Produc', width: '6%'},
         // 15: diferencia en dinero
                 //{text:'Var Dinero', width: '6%', hclass: 'right', bclass: 'right'},
         // 16: merma
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'}
         // 17: faltante
                 //{text:'Unid inv ', width: '5%'}
                 );
         // 18: id inventario
         // 19: unidad medida inventario
         // 20: factor conversion proveedor.
         // 21: unidad medida proveedor
         // 22: factor conversion receta
         // 23: unidad medida receta
         // 24: costo unitario
         // 25: maxima varianza permitida
         // 26: eficiencia minima
         // 27: eficiencia maxima
         // 28: miscelaneo ?

        props    = new Array(null, null, null, null, null, 
                            {entry: true}, {entry: true}, {entry: true},
                            {entry: true}, {entry: true}, {entry: true},
                            null, null, {entry: true}, {hide: true}, {hide: true}, {hide: true},
                            {hide: true}, {hide: true}, {hide: true}, {hide: true},
                            {hide: true}, {hide: true}, {hide: true}, {hide: true},
                            {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true});

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

        updateRows(gaDataset);
    }

    function initDataGrid2(isReport){
    	var lsFontSize    = (isReport && isReport==true)?'9px':'11px';
	loGrid2.isReport   = true;
	loGrid2.bHeaderFix = (isReport && isReport==true)?false:true;
	loGrid2.spacing    = 0;
	loGrid2.padding    = 3;
	loGrid2.height     = 280;
	loGrid2.numColumns = 11;
	giNumRows         = 0;

	customDatasetAcum(gaDataSet2, lsFontSize);
	giNumRows = gaDataset.length;

	mheaders2 = new Array(
		{text: 'Producto', align:'center', hclass:'right'},
                {text: 'Movimientos en unid inv', colspan: '4', align:'center', hclass:'right'},
                {text: 'Captura Inventario', colspan: '3', align:'center', hclass:'right'},
                {text: 'Inv Final', align:'center', hclass:'right'},
                {text: 'Cierre inventario', align:'center', hclass: 'right'},
		{text: 'Merma', align: 'center', hclass: 'right'}
	);
	
        headers2 = new Array(
                 {text:'Descripci&oacute;n',width: '16%', hclass: 'right', bclass: 'right' },
                 {text:'Inv inicial' ,width: '6%', hclass: 'right', bclass: 'right'},
                 {text:'Recep ',width: '6%'},
                 {text:'Transf entrada', width: '6%'},
                 {text:'Transf salida', width: '6%'},
                 {text:'Unid prov', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
                 {text:'Unid rec', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '9%', hclass: 'right', bclass: 'right'},
                 {text:'Uso real', width: '6%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'}
	);
	
        props = new Array(
		null, null, null, null, null, 
                {entry: true}, {entry: true}, {entry: true},
                null, null, {entry: true}, {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true}
	);

	loGrid2.setMainHeaders(mheaders2);
        loGrid2.setHeaders(headers2);
        loGrid2.setDataProps(props);
        loGrid2.setData(gaDataSet2);
        loGrid2.drawInto('goDataGrid2');
        updateRowsAcum(gaDataSet2);
    }
    
    function updateRows(paDataset){
        for(var idx=0; idx<paDataset.length; idx++)
            if(paDataset[idx].length == giNumColumns)
                updateRowValues(idx);
    }

    function updateRowsAcum(paDataSet){
    	for(var li=0; li<paDataSet.length; li++)
		if(paDataSet[li].length == giNumColumns)
			updateRowValuesAcum(li);
    }
        
    /* Devuelve el valor del inventario inicial*/
    function _getBeginInvQty(piRowId){
	
        lsBeginInvQty = 'beginInvQty|'+piRowId;
	gsValid = document.getElementById(lsBeginInvQty);

        //lfBeginInvQty = parseFloat(document.getElementById(lsBeginInvQty).innerHTML);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lfBeginInvQty = parseFloat(document.getElementById(lsBeginInvQty).value);

        return lfBeginInvQty;
    }
    /* Devuelve el valor de las recepciones */
    function _getReceptionsQty(piRowId){
    
        lsReceptionsQty = 'receptionsQty|'+piRowId
	gsValid = document.getElementById(lsReceptionsQty);
        //lfReceptionsQty = parseFloat(document.getElementById(lsReceptionsQty).innerHTML);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lfReceptionsQty = parseFloat(document.getElementById(lsReceptionsQty).value);

        return lfReceptionsQty;
    }
    
    /* Devuelve el valor de las transferencias de entrada */
    function _getITransfersQty(piRowId){

        lsITransfersQty = 'itransfersQty|'+piRowId
        //lfITransfersQty = parseFloat(document.getElementById(lsITransfersQty).innerHTML);
	gsValid = document.getElementById(lsITransfersQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lfITransfersQty = parseFloat(document.getElementById(lsITransfersQty).value);


        return lfITransfersQty;
    }
    
    /* Devuelve el valor de las transferencias de salida */
    function _getOTransfersQty(piRowId){
    
        lsOTransfersQty = 'otransfersQty|'+piRowId
        //lfOTransfersQty = parseFloat(document.getElementById(lsOTransfersQty).innerHTML);
	gsValid = document.getElementById(lsOTransfersQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lfOTransfersQty = parseFloat(document.getElementById(lsOTransfersQty).value);

        return lfOTransfersQty;
    }

    /* Devuelve el valor del inventario final en unid de proveedor*/
    function _getFinalPrvQty(piRowId){
    
        lsFinalPrvQty = 'finalPrvQty|'+piRowId;
	gsValid = document.getElementById(lsFinalPrvQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalPrvQty = document.getElementById(lsFinalPrvQty).value;
        lsFinalPrvQty = isEmpty(lsFinalPrvQty)?'0':lsFinalPrvQty;

        lfFinalPrvQty = parseFloat(trim(lsFinalPrvQty));

        return lfFinalPrvQty;
    }

    /* Devuelve el valor del inventario final  en unid de proveedor*/
    function _getFinalPrvQtyRec(piRowId){
    
        lsFinalPrvQtyRec = 'finalPrvQtyRec|'+piRowId;
	gsValid = document.getElementById(lsFinalPrvQtyRec);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalPrvQtyRec = document.getElementById(lsFinalPrvQtyRec).value;
        lsFinalPrvQtyRec = isEmpty(lsFinalPrvQtyRec)?'0':lsFinalPrvQtyRec;

        lfFinalPrvQtyRec = parseFloat(trim(lsFinalPrvQtyRec));

        return lfFinalPrvQtyRec;
    }


    /* Devuelve el valor del inventario final  en unid de inventario*/
    function _getFinalInvQty(piRowId){
    
        lsFinalInvQty = 'finalInvQty|'+piRowId;
	gsValid = document.getElementById(lsFinalInvQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalInvQty = document.getElementById(lsFinalInvQty).value;
        lsFinalInvQty = isEmpty(lsFinalInvQty)?'0':lsFinalInvQty;

        lfFinalInvQty = parseFloat(trim(lsFinalInvQty));

        return lfFinalInvQty;
    }

    /* Devuelve el valor del inventario final  en unid de inventario de recaptura*/
    function _getFinalInvQtyRec(piRowId){
    
        lsFinalInvQtyRec = 'finalInvQtyRec|'+piRowId;
	gsValid = document.getElementById(lsFinalInvQtyRec);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalInvQtyRec = document.getElementById(lsFinalInvQtyRec).value;
        lsFinalInvQtyRec = isEmpty(lsFinalInvQtyRec)?'0':lsFinalInvQtyRec;

        lfFinalInvQtyRec = parseFloat(trim(lsFinalInvQtyRec));

        return lfFinalInvQtyRec;
    }

      /* Devuelve el valor del inventario final  en unid de receta */
    function _getFinalRecQty(piRowId){
        lsFinalRecQty = 'finalRecQty|'+piRowId;
	gsValid = document.getElementById(lsFinalRecQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalRecQty = document.getElementById(lsFinalRecQty).value;
        lsFinalRecQty = isEmpty(lsFinalRecQty)?'0':lsFinalRecQty;

        lfFinalRecQty = parseFloat(trim(lsFinalRecQty));

        return lfFinalRecQty;
    }

      /* Devuelve el valor del inventario final en unidad de receta de recaptura*/
    function _getFinalRecQtyRec(piRowId){
        lsFinalRecQtyRec = 'finalRecQtyRec|'+piRowId;
	gsValid = document.getElementById(lsFinalRecQtyRec);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsFinalRecQtyRec = document.getElementById(lsFinalRecQtyRec).value;
        lsFinalRecQtyRec = isEmpty(lsFinalRecQtyRec)?'0':lsFinalRecQtyRec;

        lfFinalRecQtyRec = parseFloat(trim(lsFinalRecQtyRec));

        return lfFinalRecQtyRec;
    }

    function _lInvTotalgetFinalTotalQty(piRowId){
    
            lsFinalInvTotal = 'finalInvTotal|'+piRowId;
	    gsValid = document.getElementById(lsFinalInvTotal);
	    if(typeof gsValid !== 'undefined' && gsValid !== null)
	    	lsFinalInvTotal = document.getElementById(lsFinalInvTotal).value;
	    lsFinalInvTotal = isEmpty(lsFinalInvTotal)?'0':lsFinalInvTotal;

	    //alert('Hola--->'+lsFinalInvTotal);
	    
            lsFinalInvTotal = parseFloat(trim(lsFinalInvTotal));
            return lsFinalInvTotal;
    }

    /* Devuelve el valor del factor de conversion de proveedor */
    function _getProviderConvFact(piRowId)
    {
        var lsInventoryId = 'inventoryId|' + piRowId
        var lfConvFactor  = parseFloat(gaProviderConvFact[lsInventoryId]);

        return lfConvFactor;
    }

    /* Devuelve el valor del factor de conversion de receta */
    function _getRecipeConvFact(piRowId)
    {
        var lsInventoryId = 'inventoryId|' + piRowId
        var lfConvFactor  = parseFloat(gaRecipeConvFact[lsInventoryId]);

        return lfConvFactor;
    }

    /* Devuelve el valor del uso ideal */
    function _getIdealUseQty(piRowId)
    {
        var lsIdealUseQty = 'idealUseQty|'+piRowId
        var lfIdealUseQty = parseFloat(document.getElementById(lsIdealUseQty).innerHTML);

        return lfIdealUseQty;
    }
    /**
        Pone el valor del uso ideal
    */
    function setIdealUseQty(piRowId, pfValue)
    {
        var lsIdealUseQty = 'idealUseQty|'+piRowId
        document.getElementById(lsIdealUseQty).innerHTML = round_decimals(pfValue,2);
    }
    
    

    /* Devuelve el valor de la merma */
    function _getDecreaseQty(piRowId){
    
        var lsDecreaseQty = 'decreaseQty|'+piRowId;
	gsValid = document.getElementById(lsDecreaseQty);
	if(typeof gsValid !== 'undefined' && gsValid !== null)
           lsDecreaseQty = document.getElementById(lsDecreaseQty).value;
        lsDecreaseQty = isEmpty(lsDecreaseQty)?'0':lsDecreaseQty;

        var lfDecreaseQty = parseFloat(trim(lsDecreaseQty));

        return lfDecreaseQty;
        
    }

    /* Devuelve la unidad de medida de proveedor */
    function _getProviderUm(piRowId){
        lsInventoryId = 'inventoryId|' + piRowId
        lsProviderUm = gaProviderUm[lsInventoryId];
        //lsProviderUm = document.getElementById(lsInventoryId).value;
        return lsProviderUm;
    }

    /* Devuelve la unidad de medida de inventario */
    function _getInventoryUm(piRowId)
    {
        lsInventoryId = 'inventoryId|' + piRowId
        lsInventoryUm = gaInventoryUm[lsInventoryId];

        return lsInventoryUm;
        
    }

    /* Devuelve la unidad de medida de receta */
    function _getRecipeUm(piRowId)
    {
        lsInventoryId = 'inventoryId|' + piRowId
        lsRecipeUm    = gaRecipeUm[lsInventoryId];

        return lsRecipeUm;
        
    }

    /* Devuelve el costo unitario de un producto*/
    function _getUnitCost(piRowId)
    {
        lsInventoryId = 'inventoryId|' + piRowId
        lsUnitCost    = gaUnitCost[lsInventoryId];

        return lsUnitCost;
        
    }

    /* Devuelve la varianza maxima */
    function _getMaxVariance(piRowId)
    {
        var lsInventoryId = 'inventoryId|' + piRowId
        var lfMaxVariance = (gaMaxVariance[lsInventoryId]==0)?gfMaxVariance:gaMaxVariance[lsInventoryId];

        return lfMaxVariance;
    }

    /* Devuelve la eficiencia minima */
    function _getMinEfficiency(piRowId)
    {
        var lsInventoryId   = 'inventoryId|' + piRowId
        var lfMinEfficiency = (gaMinEfficiency[lsInventoryId]==0)?gfMinEfficiency:gaMinEfficiency[lsInventoryId];

        return lfMinEfficiency;
    }

    /* Devuelve la eficiencia maxima */
    function _getMaxEfficiency(piRowId)
    {
        var lsInventoryId   = 'inventoryId|' + piRowId;
        var lfMaxEfficiency = (gaMaxEfficiency[lsInventoryId]==0)?gfMaxEfficiency:gaMaxEfficiency[lsInventoryId];

        return lfMaxEfficiency;
    }

    /** Determina si un producto es miscelaneo */
    function isMiscelaneo(piRowId)
    {
        var lsInventoryId = 'inventoryId|' + piRowId;
        return gaMiscelaneo[lsInventoryId];
    }

    /**
        Calcula la existencia actual de un producto
    */
    function getExistence(piRowId)
    {
        var lfBeginInvQty     = _getBeginInvQty(piRowId);
        var lfReceptionsQty   = _getReceptionsQty(piRowId);
        var lfITransfersQty   = _getITransfersQty(piRowId);
        var lflfOTransfersQty = _getOTransfersQty(piRowId);

        var lfExistenceQty    = lfBeginInvQty + lfReceptionsQty + lfITransfersQty - lfOTransfersQty;
        return round_decimals(lfExistenceQty, 2);
    }

    /**
        Calcula el inventario final que esta siendo capturado.
    */
    function getFinalInventory(piRowId)
    {
        var lfFinalPrvQty   = _getFinalPrvQty(piRowId);
        var lfFinalRecQty   = _getFinalRecQty(piRowId);
        var lfFinalInvQty   = _getFinalInvQty(piRowId);

        var lfProviderConvF = _getProviderConvFact(piRowId);
        var lfRecipeConvF   = _getRecipeConvFact(piRowId);

        var lfFinalInv      = lfFinalInvQty + (lfFinalPrvQty * lfProviderConvF) + (lfFinalRecQty/lfRecipeConvF);

        return round_decimals(lfFinalInv, 2);
    }

    function getBusniessDay(piRowId){
    	var lsInventoryId = 'inventoryId|' + piRowId;
	return gaWeekDay[lsInventoryId];
    }

    /* Actualiza el valor del uso real y del faltante
        El uso real se calcula como:
        inv_ini + recep + trans_ent - trans_sal - inv_final

        El faltante se calcula como:
        uso real  - uso ideal - merma
        
    */
    function updateRowValues(piRowId){
        var lfBeginInvQty   = _getBeginInvQty(piRowId);
        var lfReceptionsQty = _getReceptionsQty(piRowId);
        var lfITransfersQty = _getITransfersQty(piRowId);
        var lfOTransfersQty = _getOTransfersQty(piRowId);

        var lfFinalPrvQty   = _getFinalPrvQty(piRowId);
        var lfFinalRecQty   = _getFinalRecQty(piRowId);
        var lfFinalInvQty   = _getFinalInvQty(piRowId);

        var lfFinalPrvQtyRec= _getFinalPrvQtyRec(piRowId);
        var lfFinalRecQtyRec= _getFinalRecQtyRec(piRowId);
        var lfFinalInvQtyRec= _getFinalInvQtyRec(piRowId);

        //var lfIdealUseQty   = _getIdealUseQty(piRowId);
        var lfDecreaseQty   = _getDecreaseQty(piRowId);

        var lsProviderUm    = _getProviderUm(piRowId);
        var lsInventoryUm   = _getInventoryUm(piRowId);
        var lsRecipeUm      = _getRecipeUm(piRowId);
    
        var lfProviderConvF = _getProviderConvFact(piRowId);
        var lfRecipeConvF   = _getRecipeConvFact(piRowId);

        var lfUnitCost      = _getUnitCost(piRowId);
        var lfMaxVariance   = _getMaxVariance(piRowId);
            lfMaxVariance   = lfMaxVariance * getNetSale();

        var lfMinEfficiency = _getMinEfficiency(piRowId);
        var lfMaxEfficiency = _getMaxEfficiency(piRowId);

        var lfFinalInv      = lfFinalInvQty+(lfFinalPrvQty * lfProviderConvF)+(lfFinalRecQty/lfRecipeConvF);
        var lfRealUseQty    = lfBeginInvQty+lfReceptionsQty+lfITransfersQty-lfOTransfersQty - lfFinalInv;

        /*if(isMiscelaneo(piRowId) == 't') 
        {
            lfIdealUseQty = lfRealUseQty;
            setIdealUseQty(piRowId, lfIdealUseQty);
        }*/

        //var lfVarianceProduct = round_decimals(lfIdealUseQty - lfRealUseQty ,2);
        //var lfVarianceMoney = round_decimals(lfVarianceProduct * lfUnitCost,2);

        //var lfFaltantQty    = lfVarianceProduct - lfDecreaseQty;
            //lfFaltantQty    = round_decimals(lfFaltantQty, 2);
        //var lsFaltantQty    = lfFaltantQty;

        //var lfEfficiency    = parseFloat(round_decimals((lfRealUseQty != 0)?(lfIdealUseQty/lfRealUseQty)*100:-1,2));

        //Se actualiza el uso real
        document.getElementById('realUseQty|'+piRowId).innerHTML = round_decimals(lfRealUseQty, 2);

        //Se actualiza la diferencia en cantidad
        //document.getElementById('differenceQty|'+piRowId).innerHTML = lfVarianceProduct;

        //Se actualiza la diferencia en dinero
        //document.getElementById('moneyQty|'+piRowId).innerHTML = lfVarianceMoney;

        //Se actualiza el faltante            
        //document.getElementById('faltantQty|'+piRowId).innerHTML = lsFaltantQty;

        //Se pone el valor del inventario final con las unidades de proveedor
        if(lfProviderConvF == 0){
            document.getElementById('finalPrvQty|'+piRowId).value = '';
            document.getElementById('finalPrvQtyRec|'+piRowId).value = '';
        }else{
            document.getElementById('finalPrvQty|'+piRowId).value = round_decimals(lfFinalPrvQty,2) + ' ' + lsProviderUm;
            document.getElementById('finalPrvQtyRec|'+piRowId).value = round_decimals(lfFinalPrvQtyRec,2) + ' ' + lsProviderUm;
            /*if(lfFinalPrvQty != lfFinalPrvQtyRec)
                turnOnDiffEndInv("finalPrvQtyRec|"+piRowId);*/
        }
        //Se pone el valor del inventario final con las unidades de inventario
        document.getElementById('finalInvQty|'+piRowId).value = round_decimals(lfFinalInvQty,2) + ' ' + lsInventoryUm;
        document.getElementById('finalInvQtyRec|'+piRowId).value = round_decimals(lfFinalInvQtyRec,2) + ' ' + lsInventoryUm;

        //Se pone el valor del inventario final con las unidades de receta
        document.getElementById('finalRecQty|'+piRowId).value = round_decimals(lfFinalRecQty,2) + ' ' + lsRecipeUm;
        document.getElementById('finalRecQtyRec|'+piRowId).value = round_decimals(lfFinalRecQtyRec,2) + ' ' + lsRecipeUm;

        //Se pone el valor total del inventario final
        document.getElementById('finalInvTotal|'+piRowId).innerHTML = round_decimals(lfFinalInv,2) + ' ' + lsInventoryUm;

        //Se pone el valor de la merma con las unidades
        document.getElementById('decreaseQty|'+piRowId).value = round_decimals(lfDecreaseQty,2) + ' ' + lsInventoryUm;

        //Se enciende la alarma si la varianza en producto tiene poco eficiencia
        /*if(lfEfficiency!=-1 && lfMinEfficiency!=-1 && lfMaxEfficiency!=-1)
            if(lfEfficiency < lfMinEfficiency || lfEfficiency > lfMaxEfficiency)
                turnOnProductAlarm(piRowId, lfEfficiency, lfMinEfficiency, lfMaxEfficiency, lfVarianceProduct);
            else
                turnOffAlarm("differenceQty|"+piRowId, lfVarianceProduct);*/

        //Se encience la alarma si la varianza en dinero es mayor del .15% de la venta neta
        /*if(lfMaxVariance > 0 && Math.abs(lfVarianceMoney) > lfMaxVariance )
            turnOnMoneyAlarm(piRowId, lfVarianceMoney);
        else
            turnOffAlarm("moneyQty|"+piRowId, lfVarianceMoney);*/

    }

    function updateRowValuesAcum(piRowId){
        var lfBeginInvQty   = _getBeginInvQty(piRowId);
        var lfReceptionsQty = _getReceptionsQty(piRowId);
        var lfITransfersQty = _getITransfersQty(piRowId);
        var lfOTransfersQty = _getOTransfersQty(piRowId);
        var lfFinalPrvQty   = _getFinalPrvQty(piRowId);
        var lfFinalRecQty   = _getFinalRecQty(piRowId);
        var lfFinalInvQty   = _getFinalInvQty(piRowId);
        var lfDecreaseQty   = _getDecreaseQty(piRowId);
        var lsProviderUm    = _getProviderUm(piRowId);
        var lsInventoryUm   = _getInventoryUm(piRowId);
        var lsRecipeUm      = _getRecipeUm(piRowId);
        var lfProviderConvF = _getProviderConvFact(piRowId);
        var lfRecipeConvF   = _getRecipeConvFact(piRowId);
        var lfUnitCost      = _getUnitCost(piRowId);
        var lfMaxVariance   = _getMaxVariance(piRowId);
            lfMaxVariance   = lfMaxVariance * getNetSale();
        var lfMinEfficiency = _getMinEfficiency(piRowId);
        var lfMaxEfficiency = _getMaxEfficiency(piRowId);
        var lfFinalInv      = lfFinalInvQty+(lfFinalPrvQty * lfProviderConvF)+(lfFinalRecQty/lfRecipeConvF);
        var lfRealUseQty    = lfBeginInvQty+lfReceptionsQty+lfITransfersQty-lfOTransfersQty - lfFinalInv;

        document.getElementById('realUseQtyAcum|'+piRowId).innerHTML = round_decimals(lfRealUseQty, 2);
        if(lfProviderConvF == 0)
            document.getElementById('finalPrvQtyAcum|'+piRowId).value = '';
        else
       	    document.getElementById('finalPrvQtyAcum|'+piRowId).value = round_decimals(lfFinalPrvQty,2) + ' ' + lsProviderUm;
        document.getElementById('finalInvQtyAcum|'+piRowId).value = round_decimals(lfFinalInvQty,2) + ' ' + lsInventoryUm;
        document.getElementById('finalRecQtyAcum|'+piRowId).value = round_decimals(lfFinalRecQty,2) + ' ' + lsRecipeUm;
        document.getElementById('finalInvTotalAcum|'+piRowId).innerHTML = round_decimals(lfFinalInv,2) + ' ' + lsInventoryUm;
        document.getElementById('decreaseQtyAcum|'+piRowId).value = round_decimals(lfDecreaseQty,2) + ' ' + lsInventoryUm;
    }

    function turnOnProductAlarm(piRowId, pfEfficiency, pfMinEfficiency, pfMaxEfficiency, pfDifferenceQty)
    {    
        var lsEfficiency = round_decimals(pfEfficiency,2);
        var lsMessage = "Atencion con este producto!. <br>Tiene una eficiencia de " + lsEfficiency +"%";

        if(pfEfficiency < pfMinEfficiency )
            lsMessage += ", menor del "+pfMinEfficiency+"%.";
        if(pfEfficiency > pfMaxEfficiency)
            lsMessage += ", mayor del "+pfMaxEfficiency+"%.";

        //turnOnAlarm("differenceQty|"+piRowId, pfDifferenceQty, lsMessage);
    }

   /* function turnOnDiffEndInv(piRowId)
    {
        var lsMessage = "Atencion el final no coincide";

        turnOnAlarm("finalPrvQtyRec|"+piRowId, "0", lsMessage);

    }*/

    function turnOnMoneyAlarm(piRowId, pfVarianceMoney)
    {
        var lsVarianceMoney = round_decimals(pfVarianceMoney,2);
        var lsMessage = "Atencion con este producto!. <br>Tiene una varianza en dinero de " + lsVarianceMoney +
                         ", que es mayor del "+(gfMaxVariance*100)+"% de la venta neta semanal.";

        turnOnAlarm("moneyQty|"+piRowId, lsVarianceMoney, lsMessage);

    }

    function getNetSale()
    {
        //return parseFloat(netSale);
        return parseFloat(0);
    }


    function turnOnAlarm(psElementId, psQuantity, psMessage)
    {
        if(typeof turnOnGraphicAlarm == 'function')
            turnOnGraphicAlarm(psElementId, psQuantity);
        else
        {
        var loElement = document.getElementById(psElementId).parentNode;
        lsClassName = loElement.className;
        loElement.className = lsClassName + ' alarm';

        document.getElementById(psElementId).innerHTML = '<a onMouseOver="ddrivetip(\''+ psMessage+'\',150)" '+
                                 'onMouseOut=hideddrivetip()>'+psQuantity +'</a>';
        }
    }

    function turnOffAlarm(psElementId, pfOriginalValue)
    {
        var loElement = document.getElementById(psElementId).parentNode;
        lsClassName = loElement.className;

        lsClassName=lsClassName.replace(/ alarm/gi, "");

        loElement.className = lsClassName;

        document.getElementById(psElementId).innerHTML = pfOriginalValue;
    }
