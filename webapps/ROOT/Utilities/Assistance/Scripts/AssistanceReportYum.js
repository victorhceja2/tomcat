
    function initDataGrid(piCurrentYear, piCurrentPeriod, piCurrentWeek, dateReport, isReport){
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid.isReport   = true;
        if(!isReport)
        {
            loGrid.bHeaderFix = true;
            loGrid.height = 150;
        }   
        else
            loGrid.bHeaderFix = false;

        loGrid.padding    = 4;

        if(gaDataset.length > 0){
            mheaders = new Array(
                     {text: 'Reporte de Asistencias del dia '+dateReport +' ', align: 'center', hclass: 'right', bclass: 'right', colspan: 7});
            headers  = new Array(
            // 0:  Fecha
                     //{text:'Fecha',width:'8%', align:'right', hclass: 'center', bclass: 'right'},
            // 1:  No. Ticket
                     {text:'No. empleado',width:'10%', align:'center', hclass: 'center', bclass: 'right'},
            // 2:  Hora en que se sirvio
                     {text:'Nombre', width:'25%', align: 'left', hclass: 'center', bclass: 'right'},
            // 3:  Nombre del empleado
                     {text:'Hora Entrada 1', width:'11%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  autorizado por
                     {text:'Hora Salida 1',width:'11%', align: 'right', hclass: 'right', bclass: 'right'},
            // 5:  Total IVA
                     {text:'Hora Entrada 2',width:'11%', align: 'right', hclass: 'right', bclass: 'right'},
            // 6:  Total Neto
                     {text:'Hora Salida 2',width:'11%', align: 'right', hclass: 'right', bclass: 'right'},
            // 7:  Total bruto 
                     {text:'Total horas',width:'11%', hclass: 'right', bclass: 'right', align:'right'});

            props    = new Array(null,null,null,null,null,null,null,null,{hide: true});
            var tmpVal = "";
            var tmpNE = "";
            for ( var rowCt = 0; rowCt < gaDataset.length; rowCt++ ){
                tmpNE =  gaDataset[ rowCt ][0];
                tmpVal =  gaDataset[ rowCt ][1];
                gaDataset[ rowCt ][1] = '<a href=javascript:openPopUp(\"AssistanceDetail.jsp?noempl=' + tmpNE 
                    +'&year='+ piCurrentYear +'&period='+ piCurrentPeriod +'&week='+ piCurrentWeek +'\");>' + tmpVal 
                    + '</a>';
            }
            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }

        if(gaDatasetW.length > 0){
            mheadersW = new Array(
                     {text: 'Asociados con actividad en la misma semana', align: 'center', hclass: 'right', bclass: 'right', colspan: 2});
            headersW  = new Array(
            // 0:  Fecha
                     //{text:'Fecha',width:'8%', align:'right', hclass: 'center', bclass: 'right'},
            // 1:  No. Ticket
                     {text:'No. empleado',width:'10%', align:'center', hclass: 'center', bclass: 'right'},
            // 2:  Hora en que se sirvio
                     {text:'Nombre', width:'30%', align: 'left', hclass: 'center', bclass: 'right'});
            
            var tmpVal = "";
            var tmpNE = "";
            //propsW    = new Array(null,{hide: true});
            for ( var rowCt = 0; rowCt < gaDatasetW.length; rowCt++ ){
                tmpNE =  gaDatasetW[ rowCt ][0];
                tmpVal =  gaDatasetW[ rowCt ][1];
                gaDatasetW[ rowCt ][1] = '<a href=javascript:openPopUp(\"AssistanceDetail.jsp?noempl=' + tmpNE 
                    +'&year='+ piCurrentYear +'&period='+ piCurrentPeriod +'&week='+ piCurrentWeek +'\");>' + tmpVal 
                    + '</a>';
                /*gaDatasetW[ rowCt ][1] = '<a href=\"AssistanceDetail.jsp?noempl=' + tmpNE 
                    +'&year='+ piCurrentYear +'&period='+ piCurrentPeriod +'&week='+ piCurrentWeek +'\" target=\"_blank\">' + tmpVal 
                    + '</a>';*/
            }
            loGrid.setMainHeaders(mheadersW);
            loGrid.setHeaders(headersW);
            loGrid.setData(gaDatasetW);        
            loGrid.drawInto('goDataGridW');
        }
    }
    
    function initDetailedDataGrid(isReport){
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
        loGridD.isReport   = true;
        if(!isReport){
            loGridD.bHeaderFix = true;
            loGridD.height = 300;
        }else
            loGridD.bHeaderFix = false;
        
        loGridD.padding = 4;
        if(gaDataset.length > 0){
            mheaders = new Array({text: 'Detalle de Asistencias', align: 'center', hclass: 'right', bclass: 'right', colspan:6});
            headers = new Array(
            // 0: Fecha
                {text:'Fecha',width:'15%', align:'center', hclass: 'center', bclass: 'center'},
            // 1:  Entrada 1
                {text:'Hora Entrada 1', width:'15%', align: 'center', hclass: 'center', bclass: 'center'},
            // 2:  Salida 1
                {text:'Hora Salida 1',width:'15%', align: 'center', hclass: 'center', bclass: 'center'},
            // 3:  Entrada 1
                {text:'Hora Entrada 2', width:'15%', align: 'center', hclass: 'center', bclass: 'center'},
            // 4:  Salida 1
                {text:'Hora Salida 2',width:'15%', align: 'center', hclass: 'center', bclass: 'center'},
            // 5:  Total bruto 
                {text:'Total horas',width:'15%', hclass: 'center', bclass: 'center', align:'center'} 
             );
             props = new Array(null,null,null,null,null,null);
             loGridD.setMainHeaders(mheaders);
             loGridD.setHeaders(headers);
             loGridD.setDataProps(props);
             loGridD.setData(gaDataset);
             loGridD.drawInto('goDetailedDataGrid');
        }
    }

function openPopUp(url){
    //window.open(url, "Detalle de Asistencias","width='300', height='300', left='500px', top='300px', menubar='no', scrollbars='yes', resizable='yes'");
   //window.open(url, "Detalle Orden","width='30px', height='300px', left='500px', top='30s0px', menubar='no', scrollbars='yes', resizable='yes'");
   window.open(url, 'Detalle de Asistencias', 'width=600, height=400, location=1, scrollbars=yes, menubar=no');
}

    function customDataset(paDataset)
    {
    }



