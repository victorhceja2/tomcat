
    function initDataGrid(piCurrentYear, piPreviousYear, isReport)
    {
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

            mheaders = new Array(
                     {text: 'Comidas de empleado', align: 'center', hclass: 'right', bclass: 'right', colspan: 7});

            headers  = new Array(
            // 0:  No. Ticket
                     {text:'No. ticket',width:'10%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que se sirvio
                     {text:'Fecha Hora', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Nombre del empleado
                     {text:'Empleado', width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  autorizado por
                     {text:'Autorizo',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Total IVA
                     {text:'Impuesto',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 5:  Total Neto
                     {text:'Total Neto',width:'15%', align: 'right', hclass: 'right', bclass: 'right'},
            // 6:  Total bruto 
                     {text:'Total Bruto',width:'15%', hclass: 'right', bclass: 'right', align:'right'});

            props    = new Array(null,null,null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

              // paDataset[arrayMin[i][3]-1][4] = "<b class=bsTotals>"+arrayMin[i][6]+"</b>";
    function customDataset(paDataset)
    {
        var lsNumbers = "";
        var lsTickets = new String();
	var laDate_id = "";

        /*if(paDataset.length > 1){
           paDataset.pop();  //Esto es para quitar un renglon de mas en el reporte 
        }*/
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
            var lsCurrentNumber = paDataset[liRowId][0];

            /*if(lsTickets.search(lsCurrentNumber) == -1)
            { // Si no lo encuentra, hay un ticket nuevo
                //lsTickets = lsTickets.concat(lsCurrentNumber).concat(' ');
                lsTickets = lsNumbers.concat(lsCurrentNumber).concat(' ');
            }else{ 
                paDataset[liRowId][0] = "&nbsp;";
                paDataset[liRowId][9] = "&nbsp;";
        }*/

            laDate_id = paDataset[liRowId][1].split(/_/);
            paDataset[liRowId][0] = '<a href=javascript:openPopUp(\"OrderDetailYum.jsp?fec='+laDate_id[0]+'&seq='+paDataset[liRowId][0]+'\");>'+paDataset[liRowId][0]+'</a>';
            if(paDataset[liRowId][0].search("9999") != -1 )
            { // Esto pone totales

//newValue = '<a href=javascript:openPopUp(\"OrderDetailYum.jsp?tel=' + data[rowId][3] + '&fec=' + data[rowId][4] + '&seq=' + data[rowId][7] + '&fre=' + data[rowId][6] + '\");>' + datagrid[rowId][columnId] + '</a>';


                paDataset[liRowId][0] = "&nbsp;";
                paDataset[liRowId][1] = "&nbsp;";
                paDataset[liRowId][5] = "<b class=bsTotals>Comidas: "+paDataset[liRowId][5]+"</b>";
                paDataset[liRowId][4] = "&nbsp;";
                paDataset[liRowId][6] = "<b class=bsTotals>Venta: "+paDataset[liRowId][6]+"</b>";
            }
        }
    }

    function initDataGridSub(isReport){
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";
        loGrid.isReport   = true;
         if(!isReport){
             loGrid.bHeaderFix = true;
             loGrid.height = 300;
         }
         else
             loGrid.bHeaderFix = false;

         loGrid.padding = 4;
         if(gaDataset.length > 0){
             mheaders = new Array({text: 'Detalle de Compra', align: 'center', hclass: 'right', bclass: 'right', colspan:6});

             headers = new Array(
                 // 0: Cantidad
                     {text:'Cantidad',width:'10%',align:'left', hclass: 'right', bclass:'right'},
                 // 1: Tipo
                     {text:'Type',width:'10%', align:'left', hclass: 'right', bclass: 'right'},
                 // 2: Base
                     {text:'Base',width:'15%',align:'right',hclass:'right',bclass:'right'},
                 // 3: tamano 
                     {text:'Size', width:'10%', align: 'left', hclass: 'right', bclass: 'right'},
                 // 4: Producto
                     {text:'Product',width:'55%', align:'right',hclass:'right',bclass:'right'},
                 // 5: Precio
                     {text:'Price',width:'10%',align:'right',hclass:'right',bclass:'right'});

             props = new Array(null,null,null,null,null,null);
             loGrid.setMainHeaders(mheaders);
             loGrid.setHeaders(headers);
             loGrid.setDataProps(props);
             loGrid.setData(gaDataset);
             loGrid.drawInto('goDataGrid');
         }
    }

function ponLink(data,cols,poda){
    var datagrid = data;
    for(var rowId=0; rowId<data.length; rowId++){
        for(var columnId=0; columnId< data[rowId].length;columnId++){
            if(in_array(columnId, cols)){
                var newValue = new String(data[rowId][columnId]);
                var pos = poda[columnId];
                var name = data[rowId][0];
                name = name.replace(/\s/g,"_");
                if(newValue.length == 0 || newValue == '')
                    newValue = '&nbsp;';
                else
                    newValue = '<a href=javascript:openPopUp(\"OrderDetailYum.jsp?nomb=' + name + '&tel=' + data[rowId][3] + '&fec=' + data[rowId][4] + '&seq=' + data[rowId][8] + '&fre=' + data[rowId][6] + '\");>' + datagrid[rowId][columnId] + '</a>';

                    data[rowId][columnId] = newValue;
            }
        }
    }
    return data;
}


function openPopUp(url){
    window.open(url, "Detalle Orden","width='10px', height='10px', left='35px', top='20px', menubar='no', scrollbars='yes', resizable='yes'");
}

