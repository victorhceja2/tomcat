
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
                     {text: 'Llamadas de clientes con transacci&oacute;n', align: 'center', hclass: 'right', bclass: 'right', colspan: 8});

            headers  = new Array(
            // 0:  No. Telefónico
                     {text:'Tel&eacute;fono',width:'13%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que entro el pedido en print1
                     {text:'Hora Pedido', width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Hora en que entro al caller 
                     {text:'Hora Llamada', width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Hora en que termino la llamada
                     {text:'Hora Termino',width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Duración de la llamada
                     {text:'Duraci&oacute;n',width:'12%', align:'right', hclass: 'right', bclass: 'right'},
            // 5:  Diferencia entre la llamada y la anterior
                     {text:'Diferencia',width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 6:  Fecha de negocio
                     {text:'Fecha Llamada',width:'13%', align: 'right', hclass: 'right', bclass: 'right'},
            // 7:  No de ticket
                     {text:'No ticket',width:'10%', hclass: 'right', bclass: 'right', align:'right'});

            props    = new Array(null,null,null,null,null,null,null,null,{hide: true});

            loGrid.setMainHeaders(mheaders);
            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }
    }

    function initDataGrid1(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid1.isReport   = true;
	if(!isReport)
	{
            loGrid1.bHeaderFix = true;
            loGrid1.height = 300;
	}   
        else
            loGrid1.bHeaderFix = false;

        loGrid1.padding    = 4;

        if(gaDataset1.length > 0)
        {
            mheaders1 = new Array(
                     {text: 'Llamadas de clientes sin transacci&oacute;n', align: 'center', hclass: 'right', bclass: 'right', colspan: 5});


            headers1  = new Array(
            // 0:  Nombre
                     {text:'Nombre',width:'25%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Telefono del cliente
                     {text:'Tel&eacute;fono', width:'13%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Numero de llamadas
                     {text:'Numero de llamadas', width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Duracion de las llamadas
                     {text:'Duraci&oacute;n de llamadas',width:'13%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Fecha de negocio
                     {text:'Fecha Llamada',width:'12%', align: 'right', hclass: 'right', bclass: 'right'});

            props1    = new Array(null,null,null,null,null,{hide: true});

            loGrid1.setMainHeaders(mheaders1);
            loGrid1.setHeaders(headers1);
            loGrid1.setDataProps(props1);
            loGrid1.setData(gaDataset1);
            loGrid1.drawInto('goDataGrid1');
        }
    }

    function initDataGrid2(piCurrentYear, piPreviousYear, isReport)
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid2.isReport   = true;
	if(!isReport)
	{
            loGrid2.bHeaderFix = true;
            loGrid2.height = 300;
	}   
        else
            loGrid2.bHeaderFix = false;

        loGrid2.padding    = 4;

        if(gaDataset2.length > 0)
        {

            mheaders2 = new Array(
                     {text: 'Llamadas de clientes con mas de 30 minutos de espera', align: 'center', hclass: 'right', bclass: 'right', colspan: 8});

            headers2  = new Array(
            // 0:  No. Telefónico
                     {text:'Tel&eacute;fono',width:'11%', align:'right', hclass: 'right', bclass: 'right'},
            // 1:  Hora en que entro el pedido en print1
                     {text:'Hora Pedido', width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 2:  Hora en que entro al caller 
                     {text:'Hora Llamada', width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 3:  Hora en que termino la llamada
                     {text:'Hora Termino',width:'12%', align: 'right', hclass: 'right', bclass: 'right'},
            // 4:  Duración de la llamada
                     {text:'Duraci&oacute;n',width:'12%', align:'right', hclass: 'right', bclass: 'right'},
            // 5:  Diferencia entre la llamada y la anterior
                     {text:'Tiempo de entrega',width:'14%', align: 'right', hclass: 'right', bclass: 'right'},
            // 6:  Fecha de negocio
                     {text:'Fecha Llamada',width:'13%', align: 'right', hclass: 'right', bclass: 'right'},
            // 7:  No de ticket
                     {text:'No ticket',width:'10%', hclass: 'right', bclass: 'right', align:'right'});

            props2    = new Array(null,null,null,null,null,null,null,null,{hide: true});

            loGrid2.setMainHeaders(mheaders2);
            loGrid2.setHeaders(headers2);
            loGrid2.setDataProps(props2);
            loGrid2.setData(gaDataset2);        
            loGrid2.drawInto('goDataGrid2');
        }
    }



/**************************************************************
* Recibe: dos datos de tipo time en este orden hr_mayor, hr_menor
* Devuelve: La diferencia entre estas horas 
* Prototipo de ejecución: timeDiff(hr_a,hr_b)
**************************************************************/
    function timeDiff(first_tm, second_tm)
    {
        var time=""; // substr es a partir de que posicion se va a hacer

        var first_hour = first_tm.substr(0,2) * 1;
        var first_min = first_tm.substr(3,2) * 1;
        var first_sec = first_tm.substr(6,2) * 1;
        var sec_first = first_hour*3600+first_min*60+first_sec;
                                                                // 11:22:33
        var second_hour = second_tm.substr(0,2) * 1;        // 01234567
        var second_min = second_tm.substr(3,2) * 1;
        var second_sec = second_tm.substr(6,2) * 1;
        var sec_second = second_hour*3600+second_min*60+second_sec;
       
        if(sec_first > sec_second) // Aseguro nunca tener negativos en la diferencia
	{
	   sec_big = sec_first;
	   sec_short = sec_second;
	}else{
	   sec_big = sec_second;
	   sec_short = sec_first;
	}

        var sec_dif = sec_big-sec_short;
        var hour = sec_dif/3600;
        var min = sec_dif/60;
        var sec = (sec_dif%60);

        while(min > 59)
        {
            min-=60;
        }

        var pos = String(hour).indexOf(".");
        if(pos == -1)
        {
            hours = String(hour);
        }else{
            hours = String(hour).substr(0,pos);
        }

        var mins = String(min).substr(0,2);
        var secs = String(sec).substr(0,2);
        
        long_hour = String(hours).length;
        long_secs = String(secs).length;
        long_mins = String(mins).length;

        if(long_hour == 1)
        {
            hours="0"+hours+":";
        }
        if(long_hour == 2)
        {
            hours+=":";
        }

        if(long_mins == 1)
        {
            mins="0"+mins;
        }

        if(long_secs == 1)
        {
            secs=":0"+secs;
        }
        if(long_secs == 2)
        {
            secs=":"+secs;
        }

        time=hours+""+mins+""+secs;

        return(time);
    }

/**************************************************************
* Recibe: datos de tipo time
* Devuelve: El total en segundos
* Prototipo de ejecución: timeSec(tm)
**************************************************************/
    function secDiff(f_tm,s_tm)
    {
        var f_hour = f_tm.substr(0,2) * 1;
        var f_min = f_tm.substr(3,2) * 1;
        var f_sec = f_tm.substr(6,2) * 1;
        var sec_f = f_hour*3600+f_min*60+f_sec;
                                                                // 11:22:33
        var s_hour = s_tm.substr(0,2) * 1;        // 01234567
        var s_min = s_tm.substr(3,2) * 1;
        var s_sec = s_tm.substr(6,2) * 1;
        var sec_s = s_hour*3600+s_min*60+s_sec;
       
        if(sec_f > sec_s) // Aseguro nunca tener negativos en la diferencia
	{
	   sec_big = sec_f;
	   sec_short = sec_s;
	}else{
	   sec_big = sec_s;
	   sec_short = sec_f;
	}

        var sec_dif = sec_big-sec_short;
	return sec_dif;
    }
 
    function customDataset(paDataset)
    {
        var lsFirstTime = '00:00:00';
        var lsNumbers = new String();
	var lsHours = new String();
	var lsTicket = new String();
        var limit=paDataset.length-1;
	var liNoClients = 0;
        var liCall;
        var liMin;
	var arrayMin = new Array();
        /*if(paDataset.length > 1){
           paDataset.pop();  //Esto es para quitar un renglon de mas en el reporte 
        }*/
        for(var liRowId=0; liRowId<paDataset.length; liRowId++)
        {
            var lsCurrentNumber = paDataset[liRowId][0];
	    var liHrTrans = secDiff(paDataset[liRowId][3],paDataset[liRowId][1]);
	    var lsCurrenttr = paDataset[liRowId][6] + paDataset[liRowId][7];

            if(lsTicket.search(lsCurrenttr) == -1)
            { // Para contar las transacciones
               liNoClients++;
	       lsTicket = lsTicket.concat(lsCurrenttr).concat(' ');
            }

            if(lsNumbers.search(lsCurrentNumber) == -1)
            { // Si no lo encuentra, hay un numero nuevo
                if(liCall != 0)
	        {
                    for(i=0;i<=liCall;i++)
	            {
                //        alert("liHrTrans="+liHrTrans+"Phone="+paDataset[liRowId][0]+" liRowId="+liRowId+" i="+i+" Ele[1]="+arrayMin[i][0]+" Ele[2]="+arrayMin[i][1]+" Ele[3]="+arrayMin[i][2]+" liMin="+liMin);
			if(arrayMin[i][2] == liMin)
			{ // Busca la diferencia minima entre llamadas de un grupo 
			    paDataset[arrayMin[i][3]][1] = "<b class=bsTotals>"+arrayMin[i][0]+"</b>";
			    paDataset[arrayMin[i][3]][7] = "<b class=bsTotals>"+arrayMin[i][1]+"</b>";
			    paDataset[arrayMin[i][3]][2] = "<b class=bsTotals>"+arrayMin[i][4]+"</b>";
			    paDataset[arrayMin[i][3]][3] = "<b class=bsTotals>"+arrayMin[i][5]+"</b>";
			    paDataset[arrayMin[i][3]][4] = "<b class=bsTotals>"+arrayMin[i][6]+"</b>";
			}
			if(i == 3 && arrayMin[i][1] != arrayMin[i-1][1])
			{ // Arregla parte del problema del producto cartesiano
			    paDataset[arrayMin[i][3]-1][1] = "<b class=bsTotals>"+arrayMin[i][0]+"</b>";
			    paDataset[arrayMin[i][3]-1][7] = "<b class=bsTotals>"+arrayMin[i][1]+"</b>";
			    paDataset[arrayMin[i][3]-1][2] = "<b class=bsTotals>"+arrayMin[i][4]+"</b>";
			    paDataset[arrayMin[i][3]-1][3] = "<b class=bsTotals>"+arrayMin[i][5]+"</b>";
			    paDataset[arrayMin[i][3]-1][4] = "<b class=bsTotals>"+arrayMin[i][6]+"</b>";
			}
	            }
	        }

                liDiff = liHrTrans; // Es la primera diferencia
		liCall = 0; // Reinicia el valor del arreglo asociativo
                lsNumbers = lsNumbers.concat(lsCurrentNumber).concat(' ');
                lsFirstTime = paDataset[liRowId][2];
                paDataset[liRowId][5] = "&nbsp;";

            }else{ // Regresa la differencia entre llamadas
		liCall++; // Aumenta el valor del arreglo asociativo
                paDataset[liRowId][0] = "&nbsp;";
                paDataset[liRowId][5] = timeDiff(paDataset[liRowId][2],lsFirstTime);
                lsFirstTime = paDataset[liRowId][2];
            }

            arrayMin[liCall] = new Array(paDataset[liRowId][1],paDataset[liRowId][7],liHrTrans,liRowId,paDataset[liRowId][2],paDataset[liRowId][3],paDataset[liRowId][4]);

            paDataset[liRowId][7] = "&nbsp;"; 
            paDataset[liRowId][1] = "&nbsp;"; 

	    /*if(paDataset[liRowId][5] == "00:00:00")
	    {  Si se repite la llamada por el producto cartesiano 
                paDataset[liRowId][2] = "&nbsp;";
                paDataset[liRowId][3] = "&nbsp;";
                paDataset[liRowId][4] = "&nbsp;";
                paDataset[liRowId][5] = "&nbsp;";
                paDataset[liRowId][6] = "&nbsp;";
	    }*/

	    if(liHrTrans < liDiff) 
	    { // Busca la diferencia minima en un conjunto de llamadas
	        liMin = liHrTrans; 
		liDiff = liMin;
	    }else{
                liMin = liDiff;
            }

	    if(paDataset[liRowId][1].search("bsTotals") == -1)
	    { // Si se repite hr_llamada y hr_termino lo borra del array
                /*paDataset[liRowId][2] = "&nbsp;";
                paDataset[liRowId][3] = "&nbsp;";
                paDataset[liRowId][4] = "&nbsp;";
                paDataset[liRowId][5] = "&nbsp;";
                paDataset[liRowId][6] = "&nbsp;";*/
	    }

            if(paDataset[liRowId][0].search("Totales") != -1 )
            { // Esto pone totales
                paDataset[liRowId][2] = "<b class=bsTotals>Llamadas ".concat(limit).concat("</b>");
                paDataset[liRowId][3] = "<b class=bsTotals>Transacciones ".concat(liNoClients).concat("</b>");
            }
        }
    }

    function customDataset1(paDataset1)
    {
        /*for(var liRowIds=0; liRowIds<paDataset1.length; liRowIds++)
        {
        }*/
    }
    function customDataset2(paDataset2)
    {
        /*for(var liRowIds=0; liRowIds<paDataset1.length; liRowIds++)
        {
        }*/
    }
