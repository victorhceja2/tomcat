
    var loGrid = new Bs_DataGrid('loGrid');
    var gaDescription      = new Array();
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
    var gaIdealUse		   = new Array();

    var lfOrigProviderQty   = 0;
    var lfOrigInventoryQty  = 0;
    var lfOrigRecipeQty     = 0;
    var lfOrigDecreaseQty   = 0;
    var lfOrigProviderConvF = 0;

    var giBlock            = 0;
    var giUBPeriod         = 0;
    var giUBWeek           = 0;
    var giNumColumns       = 26;
    var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana


    function initDataGrid(isReport, headerFix, psBlock)
    {
        var lsFontSize    = (isReport && isReport==true)?'9px':'11px';

        loGrid.isReport   = true;
        loGrid.bHeaderFix = (headerFix && headerFix==true)?true:false;;
        loGrid.spacing    = 0;
        loGrid.padding    = 2;
        loGrid.height     = 300;
        loGrid.numColumns = 15;
        giNumRows         = 0;

        customDataset(gaDataset, lsFontSize, psBlock);
        giNumRows = gaDataset.length;

        mheaders = new Array(
                 {text: 'Producto', align:'center', hclass:'right'},
                 {text: 'Movimientos en unid inv', colspan: '4', align:'center', hclass:'right'},
                 {text: 'Captura Inventario', colspan: '6', align:'center', hclass:'right'},
                 {text: 'Inv Final', align:'center', hclass:'right'},
                 {text: 'Cierre inventario', colspan:'1', align:'center', hclass: 'right'}
               //  {text: 'Merma', align: 'center', hclass: 'right'},
                // {text: 'Faltante', align: 'center'}
                 );

        headers  = new Array(
         // 0: descripcion producto
                 {text:'Descripci&oacute;n',width: '15%', hclass: 'right', bclass: 'right' },
         // 1: inventario inicial
                 {text:'Inv inicial',width: '8%'},
         // 2: recepciones
                 {text:'Recep ',width: '8%'},
         // 3: transferencias de entrada
                 {text:'Transf entrada', width: '8%'},
         // 4: transferencias de salida
                 {text:'Transf salida',  width: '8%', hclass: 'right', bclass: 'right'},
         // 5: inventario final unid prov
                 {text:'Unid prov', width: '8%'},
                 {text:'Unid prov Rec', width: '8%'},
         // 6:  inventario final unid inv
                 {text:'Unid inv', width: '8%'},
                 {text:'Unid inv Rec', width: '8%'},
         // 7:  inventario final unid receta
                 {text:'Unid rec', width: '8%', hclass: 'right', bclass: 'right'},
                 {text:'Unid rec Rec', width: '8%', hclass:'right', bclass: 'right'},
         // 08:  inventario final Total
                 {text:'Unid inv', width: '9%', hclass: 'right', bclass: 'right'},
         // 09: uso real
                 {text:'Uso real', width: '8%'}
         // 10: uso ideal
                 //{text:'Uso ideal', width: '6%'},
         // 11: diferencia uso ideal - uso real
                 //{text:'Var Produc', width: '6%'},
         // 12: diferencia en dinero
                 //{text:'Var Dinero', width: '6%', hclass: 'right', bclass: 'right'},
         // 13: merma
        //         {text:'Unid inv', width: '7%', hclass: 'right', bclass: 'right'},
         // 14: faltante
           //      {text:'Unid inv ', width: '5%'}
                 );
         // 15: id inventario
         // 16: unidad medida inventario
         // 17: factor conversion proveedor.
         // 18: unidad medida proveedor
         // 19: factor conversion receta
         // 20: unidad medida receta
         // 21: costo unitario
         // 22: maxima varianza permitida
         // 23: eficiencia minima
         // 24: eficiencia maxima
         // 25: miscelaneo ?

    	props    = new Array(null, null, null, null, null, //Descripcion(0),inicial (1) recepciones (2), I_trans(3), O_Trans(4)
                {entry: true}, {entry: true}, {entry: true},//unidades proveedor(5),Recap unidades proveedor(6),Unidades inventario(7)
                {entry: true}, {entry: true}, {entry: true},//Recaptura unidades inventario(8),Unidades receta(9),Recaptura Unidades receta(10)
                //null, null, null, null, null, {entry: true}, null, 
              //Final(11), Real(12),  Faltante (13), Uso Ideal(14), inv_id(15),   Unidad de medida(16), Factor de conversion(17)
                null,      null,      {hide:true},   {hide:true},   {hide: true}, {hide: true},         {hide: true}, 
                {hide: true}, {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true},
                //{hide: true}, {hide: true}, {hide: true}, {hide: true});
                {hide: true}, {hide: true}, {hide: true});

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

        //EZ: tunning
        //if(!isReport) updateRows(gaDataset);
    }

    function updateRows(paDataset)
    {
        for(var idx=0; idx<paDataset.length; idx++)
            if(paDataset[idx].length == giNumColumns)
                updateRowValues(idx);
    }
    function _getBlock()
    {
        var lsBlock = giBlock;
        return lsBlock;
    }
    /* Devuelve la descripcion del producto*/
    function _getDescription(piRowId)
    {
        var lsInventoryId = 'inventoryId|' + piRowId
        var lsDescription = gaDescription[lsInventoryId];

        return lsDescription;
    }
    
    /* Devuelve el valor del inventario inicial*/
    function _getBeginInvQty(piRowId)
    {
        lsBeginInvQty = 'beginInvQty|'+piRowId
        lfBeginInvQty = parseFloat(document.getElementById(lsBeginInvQty).innerHTML);

        return lfBeginInvQty;
    }
    /* Devuelve el valor de las recepciones */
    function _getReceptionsQty(piRowId)
    {
        lsReceptionsQty = 'receptionsQty|'+piRowId
        lfReceptionsQty = parseFloat(document.getElementById(lsReceptionsQty).innerHTML);

        return lfReceptionsQty;
    }
    
    /* Devuelve el valor de las transferencias de entrada */
    function _getITransfersQty(piRowId)
    {
        lsITransfersQty = 'itransfersQty|'+piRowId
        lfITransfersQty = parseFloat(document.getElementById(lsITransfersQty).innerHTML);

        return lfITransfersQty;
    }
    
    /* Devuelve el valor de las transferencias de salida */
    function _getOTransfersQty(piRowId)
    {
        lsOTransfersQty = 'otransfersQty|'+piRowId
        lfOTransfersQty = parseFloat(document.getElementById(lsOTransfersQty).innerHTML);

        return lfOTransfersQty;
    }

    /* Devuelve el valor del inventario final  en unid de proveedor*/
    function _getFinalPrvQty(piRowId)
    {
        lsFinalPrvQty = 'finalPrvQty|'+piRowId;
        lsFinalPrvQty = document.getElementById(lsFinalPrvQty).value;
        lsFinalPrvQty = isEmpty(lsFinalPrvQty)?'0':lsFinalPrvQty;

        lfFinalPrvQty = parseFloat(trim(lsFinalPrvQty));

        return lfFinalPrvQty;
    }

    /* Devuelve el valor del inventario final  en unid de inventario*/
    function _getFinalInvQty(piRowId)
    {
        lsFinalInvQty = 'finalInvQty|'+piRowId;
        lsFinalInvQty = document.getElementById(lsFinalInvQty).value;
        lsFinalInvQty = isEmpty(lsFinalInvQty)?'0':lsFinalInvQty;

        lfFinalInvQty = parseFloat(trim(lsFinalInvQty));

        return lfFinalInvQty;
    }

      /* Devuelve el valor del inventario final  en unid de receta */
    function _getFinalRecQty(piRowId)
    {
        lsFinalRecQty = 'finalRecQty|'+piRowId;
        lsFinalRecQty = document.getElementById(lsFinalRecQty).value;
        lsFinalRecQty = isEmpty(lsFinalRecQty)?'0':lsFinalRecQty;

        lfFinalRecQty = parseFloat(trim(lsFinalRecQty));

        return lfFinalRecQty;
    }
    
    /* Devuelve el valor del inventario final  en unid de proveedor*/
    function _getFinalPrvQtyRec(piRowId)
    {
        lsFinalPrvQty = 'finalPrvQtyRec|'+piRowId;
        lsFinalPrvQty = document.getElementById(lsFinalPrvQty).value;
        lsFinalPrvQty = isEmpty(lsFinalPrvQty)?'0':lsFinalPrvQty;

        lfFinalPrvQty = parseFloat(trim(lsFinalPrvQty));

        return lfFinalPrvQty;
    }

    /* Devuelve el valor del inventario final  en unid de inventario*/
    function _getFinalInvQtyRec(piRowId)
    {
        lsFinalInvQty = 'finalInvQtyRec|'+piRowId;
        lsFinalInvQty = document.getElementById(lsFinalInvQty).value;
        lsFinalInvQty = isEmpty(lsFinalInvQty)?'0':lsFinalInvQty;

        lfFinalInvQty = parseFloat(trim(lsFinalInvQty));

        return lfFinalInvQty;
    }

      /* Devuelve el valor del inventario final  en unid de receta */
    function _getFinalRecQtyRec(piRowId)
    {
        lsFinalRecQty = 'finalRecQtyRec|'+piRowId;
        lsFinalRecQty = document.getElementById(lsFinalRecQty).value;
        lsFinalRecQty = isEmpty(lsFinalRecQty)?'0':lsFinalRecQty;

        lfFinalRecQty = parseFloat(trim(lsFinalRecQty));

        return lfFinalRecQty;
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

    /* Devuelve el valor del uso ideal BLIND*/
    /*function _getIdealUseQty(piRowId)
    {
        var lsIdealUseQty = 'idealUseQty|'+piRowId
        var lfIdealUseQty = parseFloat(document.getElementById(lsIdealUseQty).innerHTML);

        return lfIdealUseQty;
    }*/
    /**
        Pone el valor del uso ideal
    */
    function setIdealUseQty(piRowId, pfValue)
    {
        var lsIdealUseQty = 'idealUseQty|'+piRowId
        document.getElementById(lsIdealUseQty).innerHTML = round_decimals(pfValue,2);
    }
    
    

    /* Devuelve el valor de la merma */
    function _getDecreaseQty(piRowId)
    {
        var lsDecreaseQty = 'decreaseQty|'+piRowId;
        var lsDecreaseQty = document.getElementById(lsDecreaseQty).value;
        var lsDecreaseQty = isEmpty(lsDecreaseQty)?'0':lsDecreaseQty;

        var lfDecreaseQty = parseFloat(trim(lsDecreaseQty));

        return lfDecreaseQty;
        
    }

    /* Devuelve la unidad de medida de proveedor */
    function _getProviderUm(piRowId)
    {
        lsInventoryId = 'inventoryId|' + piRowId
        lsProviderUm = gaProviderUm[lsInventoryId];

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
    
    function _getIdealUse(piRowId){
    	var lsInventoryId   = 'inventoryId|' + piRowId;
        var lfIdealUse = gaIdealUse[lsInventoryId];
        //alert("lsInventoryId: [" + lsInventoryId + "], lfIdealUse: [" + lfIdealUse + "]");

        return lfIdealUse;    	
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

    /* Actualiza el valor del uso real y del faltante
        El uso real se calcula como:
        inv_ini + recep + trans_ent - trans_sal - inv_final

        El faltante se calcula como:
        uso real  - uso ideal - merma
        
    */
    function updateRowValues(piRowId)
    {

        var lfFinalPrvQty    = _getFinalPrvQty(piRowId);
        var lfFinalRecQty    = _getFinalRecQty(piRowId);
        var lfFinalInvQty    = _getFinalInvQty(piRowId);
        var lfFinalPrvQtyRec = _getFinalPrvQtyRec(piRowId);
        var lfFinalRecQtyRec = _getFinalRecQtyRec(piRowId);
        var lfFinalInvQtyRec = _getFinalInvQtyRec(piRowId);

        var lfBeginInvQty   = _getBeginInvQty(piRowId);
        var lfReceptionsQty = _getReceptionsQty(piRowId);
        var lfITransfersQty = _getITransfersQty(piRowId);
        var lfOTransfersQty = _getOTransfersQty(piRowId);
        //var lfIdealUseQty   = _getIdealUseQty(piRowId); //BLIND
        var lfIdealUseQty   = _getIdealUse(piRowId); //BLIND
        //var lfDecreaseQty   = _getDecreaseQty(piRowId);

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

	// if(isMiscelaneo(piRowId) == 't')
	// {
	// lfIdealUseQty = lfRealUseQty;
	// setIdealUseQty(piRowId, lfIdealUseQty);
	// }
        // Se quitan alarmas de varianza MCHA    
        //var lfVarianceProduct = round_decimals(lfIdealUseQty - lfRealUseQty ,2);
        var lfVarianceProduct = 0;
        // Se quita alarma por diferencia de dinero
        //var lfVarianceMoney = round_decimals(lfVarianceProduct * lfUnitCost,2);
        var lfVarianceMoney = 0;

       //Se quita registro de merma 
	// var lfFaltantQty = lfVarianceProduct + lfDecreaseQty;
	// lfFaltantQty = round_decimals(lfFaltantQty, 2);
	// var lsFaltantQty = lfFaltantQty;

        var lfEfficiency    = parseFloat(round_decimals((lfRealUseQty != 0)?(lfIdealUseQty/lfRealUseQty)*100:-1,2));

        //Se actualiza el uso real
        document.getElementById('realUseQty|'+piRowId).innerHTML = round_decimals(lfRealUseQty, 2);

        //Se actualiza la diferencia en cantidad MCHA ya no existe eta columna
        //document.getElementById('differenceQty|'+piRowId).innerHTML = lfVarianceProduct;

        //Se actualiza la diferencia en dinero MCHA ya no existe eta columna
        //document.getElementById('moneyQty|'+piRowId).innerHTML = lfVarianceMoney;

        //Se actualiza el faltante            
        //document.getElementById('faltantQty|'+piRowId).innerHTML = lsFaltantQty;

        //Se pone el valor del inventario final con las unidades de proveedor
        if(lfProviderConvF == 0)
        document.getElementById('finalPrvQty|'+piRowId).value = '';
        else
        document.getElementById('finalPrvQty|'+piRowId).value = round_decimals(lfFinalPrvQty,2) + ' ' + lsProviderUm;
        
        document.getElementById('finalPrvQtyRec|'+piRowId).value = round_decimals(lfFinalPrvQtyRec,2) + ' ' + lsProviderUm;

        //Se pone el valor del inventario final con las unidades de inventario
        document.getElementById('finalInvQty|'+piRowId).value = round_decimals(lfFinalInvQty,2) + ' ' + lsInventoryUm;
        
        document.getElementById('finalInvQtyRec|'+piRowId).value = round_decimals(lfFinalInvQtyRec,2) + ' ' + lsInventoryUm;

        //Se pone el valor del inventario final con las unidades de receta
        document.getElementById('finalRecQty|'+piRowId).value = round_decimals(lfFinalRecQty,2) + ' ' + lsRecipeUm;
        
        document.getElementById('finalRecQtyRec|'+piRowId).value = round_decimals(lfFinalRecQtyRec,2) + ' ' + lsRecipeUm;

        //Se pone el valor total del inventario final
        document.getElementById('finalInvTotal|'+piRowId).innerHTML = round_decimals(lfFinalInv,2) + ' ' + lsInventoryUm;

        //Se pone el valor de la merma con las unidades
        //document.getElementById('decreaseQty|'+piRowId).value = round_decimals(lfDecreaseQty,2) + ' ' + lsInventoryUm;

        //document.getElementById('useIdeal|'+piRowId).value = lfIdealUseQty;

        //EZ: tunning
        //Se enciende la alarma si la varianza en producto tiene poco eficiencia MCHA Se cancela la alarma
        /*if(lfEfficiency!=-1 && lfMinEfficiency!=-1 && lfMaxEfficiency!=-1)
            if(lfEfficiency < lfMinEfficiency || lfEfficiency > lfMaxEfficiency)
                turnOnProductAlarm(piRowId, lfEfficiency, lfMinEfficiency, lfMaxEfficiency, lfVarianceProduct);
            else
                turnOffAlarm("differenceQty|"+piRowId, lfVarianceProduct);*/

        //Se encience la alarma si la varianza en dinero es mayor del .15% de la venta neta MCHA se cancela la alarma
        /*if(lfMaxVariance > 0 && Math.abs(lfVarianceMoney) > lfMaxVariance )
            turnOnMoneyAlarm(piRowId, lfVarianceMoney);
        else
            turnOffAlarm("moneyQty|"+piRowId, lfVarianceMoney);*/

    }

    function turnOnProductAlarm(piRowId, pfEfficiency, pfMinEfficiency, pfMaxEfficiency, pfDifferenceQty)
    {    
        var lsEfficiency = round_decimals(pfEfficiency,2);
        var lsMessage = "Atencion con este producto!. <br>Tiene una eficiencia de " + lsEfficiency +"%";

        if(pfEfficiency < pfMinEfficiency )
            lsMessage += ", menor del "+pfMinEfficiency+"%.";
        if(pfEfficiency > pfMaxEfficiency)
            lsMessage += ", mayor del "+pfMaxEfficiency+"%.";
       
        turnOnAlarm("differenceQty|"+piRowId, pfDifferenceQty, lsMessage);
    }

    function turnOnMoneyAlarm(piRowId, pfVarianceMoney)
    {
        var lsVarianceMoney = round_decimals(pfVarianceMoney,2);
        var lsMessage = "Atencion con este producto!. <br>Tiene una varianza en dinero de " + lsVarianceMoney +
                         ", que es mayor del "+(gfMaxVariance*100)+"% de la venta neta semanal.";

        turnOnAlarm("moneyQty|"+piRowId, lsVarianceMoney, lsMessage);

    }

    function getNetSale()
    {
        return parseFloat(netSale);
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
