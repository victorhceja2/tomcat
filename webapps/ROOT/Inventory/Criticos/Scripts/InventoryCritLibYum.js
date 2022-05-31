    // InventoryCritLibYum.js

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
    var lfOrigDecreaseQty   = 0;
    var lfOrigProviderConvF = 0;
    var liBusinessDay	    = 0;
    var lfFinalInvQty	    = 0;

    var giNumColumns       = 27;
    var giWinControlClose=0; //Variable global de control para saber si se cierra la ventana
    var gsValid;


    function initDataGrid(isReport)
    {
        var lsFontSize    = '11px';
        loGrid.isReport   = true;
        loGrid.bHeaderFix = (isReport && isReport==true)?false:true;
        loGrid.spacing    = 0;
        loGrid.padding    = 3;
        loGrid.height     = 280;
        loGrid.numColumns = 15;
        giNumRows         = 0;

        customDataset(gaDataset,lsFontSize,isReport);
        giNumRows = gaDataset.length;

        mheaders = new Array(
                 {text: 'Producto', align:'center', hclass:'right'},
                 {text: 'Movimientos en unid inv', colspan: '4', align:'center', hclass:'right'},
                 {text: 'Captura Inventario', colspan: '3', align:'center', hclass:'right'},
                 {text: 'Inv Final', align:'center', hclass:'right'},
                 {text: 'Cierre inventario', colspan: '3', align:'center', hclass: 'right'},
                 {text: 'Merma', align: 'center', hclass: 'right'},
                 {text: 'Faltante', align: 'center'},
                 {text: 'Eficiencia', align: 'center'}
        );

        headers  = new Array(
         // 0: descripcion producto
                 {text:'Descripci&oacute;n',width: '15%', hclass: 'right', bclass: 'right' },
         // 1: inventario inicial
                 {text:'Inv inicial' ,width: '5%', hclass: 'right', bclass: 'right'},
         // 2: recepciones
                 {text:'Recep ',width: '5%'},
         // 3: transferencias de entrada
                 {text:'Transf entrada', width: '5%'},
         // 4: transferencias de salida
                 {text:'Transf salida',  width: '5%', hclass: 'right', bclass: 'right'},
         // 5: inventario final unid prov
                 {text:'Unid prov', width: '5%'},
         // 6:  inventario final unid inv
                 {text:'Unid inv', width: '5%'},
         // 7:  inventario final unid receta
                 {text:'Unid rec', width: '5%', hclass: 'right', bclass: 'right'},
         // 08:  inventario final Total
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
         // 09: uso real
                 {text:'Uso real', width: '5%', hclass: 'right', bclass: 'right'},
         // 10: uso ideal
                 {text:'Uso ideal', width: '5%'},
         // 11: diferencia uso ideal - uso real
                 {text:'Var Produc', width: '5%'},
         // 12: merma
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
         // 13: faltante
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
         // 14: eficiencia
                 {text:' % ', width: '5%'}
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

        props    = new Array(null, null, null, null, null, 
                            {entry: true}, {entry: true}, {entry: true},
                            null, null, null, null, {entry: true}, null, null,
                            {hide: true}, {hide: true}, {hide: true},
                            {hide: true}, {hide: true}, {hide: true}, {hide: true},
                            {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true}
                            );

        loGrid.setMainHeaders(mheaders);
        loGrid.setHeaders(headers);
        loGrid.setDataProps(props);
        loGrid.setData(gaDataset);
        loGrid.drawInto('goDataGrid');

        //updateRows(gaDataset);
    }

    function initDataGrid2(isReport){
    var lsFontSize     = '11px';
	loGrid2.isReport   = true;
	loGrid2.bHeaderFix = (isReport && isReport==true)?false:true;
	loGrid2.spacing    = 0;
	loGrid2.padding    = 3;
	loGrid2.height     = 280;
	loGrid2.numColumns = 15;
	giNumRows         = 0;

	customDatasetAcum(gaDataSet2, lsFontSize,isReport);
	giNumRows = gaDataset.length;

	mheaders2 = new Array(
		        {text: 'Producto', align:'center', hclass:'right'},
                {text: 'Movimientos en unid inv', colspan: '4', align:'center', hclass:'right'},
                {text: 'Captura Inventario', colspan: '3', align:'center', hclass:'right'},
                {text: 'Inv Final', align:'center', hclass:'right'},
                {text: 'Cierre inventario', colspan: '3', align:'center', hclass: 'right'},
                {text: 'Merma', align: 'center', hclass: 'right'},
                {text: 'Faltante', align: 'center'},
                {text: 'Eficiencia', align: 'center'}
	);
	
        headers2 = new Array(
                 {text:'Descripci&oacute;n',width: '15%', hclass: 'right', bclass: 'right' },
                 {text:'Inv inicial' ,width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Recep ',width: '5%'},
                 {text:'Transf entrada', width: '5%'},
                 {text:'Transf salida', width: '5%'},
                 {text:'Unid prov', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid rec', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
                 {text:'Uso real', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Uso ideal', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Var Produc', width: '5%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
                 {text:'Unid inv', width: '6%', hclass: 'right', bclass: 'right'},
                 {text:' % ', width: '5%'}
	);
	
        props = new Array(
		        null, null, null, null, null, 
                {entry: true}, {entry: true}, {entry: true},
                null, null, null, null, {entry: true}, null, null,
                {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true},
                {hide: true}, {hide: true}, {hide: true}, {hide: true}, {hide: true}
	);

	    loGrid2.setMainHeaders(mheaders2);
        loGrid2.setHeaders(headers2);
        loGrid2.setDataProps(props);
        loGrid2.setData(gaDataSet2);
        loGrid2.drawInto('goDataGrid2');
        //updateRowsAcum(gaDataSet2);
    }
    
    
