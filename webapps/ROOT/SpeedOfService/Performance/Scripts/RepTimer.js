/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function initDataGrid(piCurrentYear, piPreviousYear, isReport){
    var _class  = " class='descriptionTabla' style='border: solid rgb(100,230,75) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid.isReport   = true;
	if(!isReport)
	{
            loGrid.bHeaderFix = true;
            loGrid.height = 300;
	}   
        else
            loGrid.bHeaderFix = false;

        loGrid.padding = 4;

        
            mheaders = new Array(
            // 0: 
                    {text: 'Parte del día', align: 'center', hclass: 'right', bclass: 'right', colspan:2},
            // 1: Subsections
                    {text: 'Día actual', align: 'center', hclass: 'right', bclass: 'right', colspan: 4},
            // 1: Subsections
                    {text: 'Semana', align: 'center', hclass: 'right', bclass: 'right', colspan: 4},
            // 1: Subsections
                    {text: 'Periodo', align: 'center', hclass: 'right', bclass: 'right', colspan: 4}
                 );

            headers  = new Array(
            // 0:  Fecha 
                     {text:'Inicio',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
                     {text:'Fin',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 1:  Destino 
                     {text:'< 45 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'> 1:30 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
            // 2:  Semana 
                     {text:'< 45 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 1:30 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
            // 3: Mes 
                     {text:'< 45 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 1:30 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'}
                 );

            props    = new Array(null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            
        if( gaOrderDataset.length > 0 ){
            gaOrderDataset[gaOrderDataset.length -1 ][1] = '<p class="avg_text">Total</p>';
            loGrid.setData(gaOrderDataset);
            loGrid.drawInto('goDataGrid');
        }
        
        
        headersW  = new Array(
            // 0:  Fecha 
                     {text:'Inicio',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
                     {text:'Fin',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 1:  Destino 
                     {text:'< 60 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'> 2:00 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
            // 2:  Semana 
                     {text:'< 60 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 2:00 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
            // 3: Mes 
                     {text:'< 60 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 2:00 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'}
                 );
        if( gaWindowDataset.length > 0 ){
            gaWindowDataset[gaWindowDataset.length -1 ][1] = '<p class="avg_text">Total</p>';
            loGrid.setHeaders(headersW);
            loGrid.setData(gaWindowDataset); 
            loGrid.drawInto('goDataGridWin');
        }
        
        headersD  = new Array(
            // 0:  Fecha 
                     {text:'Inicio',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
                     {text:'Fin',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 1:  Destino 
                     {text:'< 2:30 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'> 4:00 ', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
            // 2:  Semana 
                     {text:'< 2:30 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 4:00 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
            // 3: Mes 
                     {text:'< 2:30 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'> 4:00 ', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'right', bclass: 'right'},
                     {text:'Tiempo Promedio', width:'8%', align: 'center', hclass: 'right', bclass: 'right'}
                 );
        if( gaDeliveryDataset.length > 0 ){
            gaDeliveryDataset[gaDeliveryDataset.length -1 ][1] = '<p class="avg_text">Total</p>';
            loGrid.setHeaders(headersD);
            loGrid.setData(gaDeliveryDataset);
            loGrid.drawInto('goDataGridDelivery');
        }
        
        mheadersDrive = new Array(
            // 0: 
                    {text: 'Parte del día', align: 'center', hclass: 'right', bclass: 'right', colspan:2},
            // 1: Subsections
                    {text: 'Parte', align: 'center', hclass: 'center', bclass: 'center', colspan: 4},
                    {text: 'Transacciones', align: 'center', hclass: 'center', bclass: 'center', colspan: 2}
                 );
                     
        headersDrive  = new Array(
            // 0:  Fecha 
                     {text:'Inicio',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
                     {text:'Fin',width:'7%', align:'center', hclass: 'right', bclass: 'right', sort: 'alpha'},
            // 1:  Destino 
                     {text:'Toma Orden', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Servicio', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Total', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Automóviles', width:'8%', align: 'center', hclass: 'center', bclass: 'center'},
                     {text:'Trx Reales', width:'8%', align: 'center', hclass: 'center', bclass: 'right'},
                     {text:'Eficiencia', width:'8%', align: 'center', hclass: 'center', bclass: 'center'}
                 );
                
        
        if( gaSumDataset.length > 0 ){
            var tmpD = 0;
            for ( var rowCt = 0; rowCt < gaSumDataset.length; rowCt++ ){
                tmpD =  100*Number( gaSumDataset[ rowCt ][7] )/ Number( gaSumDataset[ rowCt ][6] );
                if( isNaN(tmpD) ){
                    gaSumDataset[ rowCt ][8] = '<p class="eff_text"> 0 %</p>';
                }else{
                    gaSumDataset[ rowCt ][8] = '<p class="eff_text">'+ Math.round(tmpD*100)/100 + ' %</p>';
                }
            }
            gaSumDataset[gaSumDataset.length -1 ][1] = '<p class="avg_text">Total</p>';
            loGrid.setMainHeaders(mheadersDrive);
            loGrid.setHeaders(headersDrive);
            loGrid.setData(gaSumDataset);
            loGrid.drawInto('goDataGridDrive');
        }
}