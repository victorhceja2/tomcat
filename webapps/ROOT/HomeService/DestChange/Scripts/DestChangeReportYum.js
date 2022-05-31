
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
            customDataset(gaDataset);

            /*mheaders = new Array(
                     {text: '&nbsp;', hclass: 'left'},
                     {text: '&nbsp;', hclass: 'right'},
                     {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3},
                     {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3},
                     {text: '&nbsp;', align: 'center', hclass: 'right', colspan: 3});*/

            headers  = new Array(
            // 0:  No de ticket
                     {text:'No ticket',width:'6%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Destino original
                     {text:'Dest original',width:'8%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Destino final
                     {text:'Dest final', width:'10%', align: 'right'},
            // 2:  Fecha de negocio
                     {text:'Fecha del cambio', width:'10%', align: 'right'},
            // 3:  No telefonico
                     {text:'No. telef&oacute;nico',width:'10%', align: 'right'},
            // 4:  Hora de cambio inicial
                     {text:'Hora inicial (aprox.)',width:'8%', hclass: 'right', bclass: 'right', align:'right'},
            // 5:  Hora de cambio final
                     {text:'Hora final (aprox.)',width:'8%', hclass: 'right', bclass: 'right', align:'right'},
            // 6:  Tiempo promesa
                     {text:'Tiempo promesa',width:'8%', align:'right'},
            // 7:  Hora toma pedido
                     {text:'Hora toma pedido',width:'8%', align:'right'},
            // 8:  Hora de cobro
                     {text:'Hora de cobro',width:'8%', hclass: 'right', bclass: 'right', align:'right'},
            // 9:  Total ( $ )           
                     {text:'Total ($)',width:'8%', align:'right'},
            //10:  Descuento ( $ )        
                     {text:'Descuento ($)',width:'8%', align:'right'},
            //11:  Cobrado ( $ )
                     {text:'Cobrado ($)',width:'8%', hclass: 'right', bclass: 'right', align:'right'});

            props    = new Array(null,null,null,null,null,null,null,null,null,null,null,null,null,{hide: true});

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
            //Penetracion
            //paDataset[liRowId][3] = paDataset[liRowId][3] + ' %';
            //Participacion
            //paDataset[liRowId][4] = paDataset[liRowId][4] + ' %';
        }
    }


