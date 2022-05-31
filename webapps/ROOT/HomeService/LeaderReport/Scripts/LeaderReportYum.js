/**
 * 
 */
function initDataGrid(){
	var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

    loGrid.isReport   = true;
            if(!isReport)
            {
            loGrid.bHeaderFix = true;
            loGrid.height = 300;
            }
    else
            loGrid.bHeaderFix = false;

    loGrid.padding    = 4;

    if(gaDataset.length > 0)
    {
        customDataset(gaDataset);

        /*mheaders = new Array(
                 {text: '&nbsp;', hclass: 'left'},
                 {text: '&nbsp;', hclass: 'right'},
                 {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3},
                 {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3},
                 {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3});*/

        headers  = new Array(
        // 0: id
        		{text:' ', width:'2%', hclass: 'left', bclass:'left', align:'right'},
        // 0:  Concepto
                 {text:'Concepto',width:'15%', hclass: 'left', bclass:'left', align:'right'},
        // 1:  Ponderación
                 {text:'Ponderaci&oacute;n',width:'8%', hclass: 'right', bclass: 'right', align: 'right'},
        // 2:  Fuera de Objetivo
                 {text:'Fuera de Objetivo', width:'10%', align: 'right'},
        // 3:  Dentro de Objetivo
                 {text:'Dentro de Objetivo', width:'10%', align: 'right'},
        // 4:  Acumulado Fuera Objetivo
                 {text:'Acumulado Fuera de Objetivo', width:'10%', align:'right'},
        // 5:  Acumulado Dentro Objetivo
                 {text:'Acumulado Dentro Objetivo', width:'10%', align:'right'},
        // 6:  Hora de Registro
        		 {text:'Hora de Registro', width:'8%', align: 'center'});

                 props    = new Array(null,null,null,null,null,null,null,null,{hide: true});

                 //loGrid.setMainHeaders(mheaders);
                 loGrid.setHeaders(headers);
                 loGrid.setDataProps(props);
                 loGrid.setData(gaDataset);
                 loGrid.drawInto('goDataGrid');
    }
}

function customDataset(paDataset)
{
    for(var liRowId=0; liRowId<paDataset.length; liRowId++)
    {
        lsPercent=paDataset[liRowId][2];
        if(lsPercent>5){
        	
        }
    }
}
