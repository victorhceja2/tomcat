    var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

    function changeEditStatus()
    {
    	var boxes= new Array();
	for (var i = 0; i < gaDataset.length; i++)
	{
	    boxes[i] = document.getElementById("usada|"+i);

	    if(boxes[i].checked == true)
	    {
	    	montoInput = document.getElementById("monto|"+i);
		fechaInput = document.getElementById("fecha|"+i);
	    	horaInput  = document.getElementById("hora|"+i);
	    	transInput = document.getElementById("trans|"+i);
	    	cancInput  = document.getElementById("canc|"+i);

		montoInput.disabled = false;
		fechaInput.disabled = false;
		horaInput.disabled  = false;
		transInput.disabled = false;
		cancInput.disabled  = false;
	    }
	    else
	    {
	    	montoInput = document.getElementById("monto|"+i);
		fechaInput = document.getElementById("fecha|"+i);
	    	horaInput  = document.getElementById("hora|"+i);
	    	transInput = document.getElementById("trans|"+i);
	    	cancInput  = document.getElementById("canc|"+i);

		montoInput.disabled = true;
		fechaInput.disabled = true;
		horaInput.disabled  = true;
		transInput.disabled = true;
		cancInput.disabled  = true;
	    }
	}
    }

    function initDataGrid()
    {
	var gaDataset2 = new Array(new Array());

	var totalSUS;
	var totalCC;
	var totalCanc;

        loGrid.bHeaderFix   = false;
        loGrid.isReport     = true;
        loGrid.height       = 30;
        loGrid.width        = '350';
        loGrid.padding      = 6;

        totGrid.bHeaderFix   = false;
        totGrid.isReport     = true;
        totGrid.height       = 30;
        totGrid.width        = '350';
        totGrid.padding      = 5;

        if(gaDataset.length > 0)
        {
            giNumRows = gaDataset.length; //Para los eventos del teclado!!!

            for (var liRowId=0; liRowId<gaDataset.length; liRowId++)
            {
                gaDataset[liRowId][0] = '<input type="hidden" name="idterminal|'+liRowId+'" '+
					'id="idterminal|' +liRowId +'" ' +
                                        'value="' + gaDataset[liRowId][0] + '"> ' +
                                        gaDataset[liRowId][0];

                gaDataset[liRowId][1] = '<input type="text" name="monto|'+liRowId+'" '+
                                        'id="monto|' + liRowId + '" size="15" ' + 
                                        'value="" autocomplete="off" '+
					'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';

                gaDataset[liRowId][2] = '<input type="text" name="fecha|'+liRowId+'" '+
                                        'id="fecha|' + liRowId + '" size="15" ' + 
                                        'onFocus=\"showCalendar(\'frmGrid\', \'fecha|'+liRowId+'\', \'fecha|'+liRowId+'\')\" readonly ' +_class+'>';

                gaDataset[liRowId][3] = '<input type="text" name="hora|'+liRowId+'" '+
                                        'id="hora|' + liRowId + '" size="15" ' + 
                                        'value="" autocomplete="off" '+
                                        'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';

                gaDataset[liRowId][4] = '<input type="text" name="trans|'+liRowId+'" '+
                                        'id="trans|' + liRowId + '" size="15" ' + 
                                        'value="" autocomplete="off" '+
                                        'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';

                gaDataset[liRowId][5] = '<input type="text" name="canc|'+liRowId+'" '+
                                        'id="canc|' + liRowId + '" size="15" ' + 
                                        'value="" autocomplete="off" '+
                                        'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';

		gaDataset[liRowId][6] = '<input type="checkbox" name="termfail|'+liRowId+'" >';
            }


            headers  = new Array(
            // 0:  Terminal
                     {text:'Venta M&oacute;vil',width:'25%'},
            // 1:  Monto 
                     {text:'Monto',width:'15%'},
            // 2:  Fecha
                     {text:'Fecha',width:'15%'},
            // 3:  Hora
                     {text:'Hora (HH:MM)',width:'10%'},
            // 4:  Trans
	             {text:'Num. Transacciones', width:'20%'},
            // 5:  Cancelaciones
	             {text:'Monto Cancelaciones', width:'15%'},
            // 6:  Cierre fallido
	             {text:'Cierre Fallido', width:'5%'});

            props    = new Array(null, {entry: true}, {entry: true}, {entry: true}, {entry: true}, {entry: true}, null);

            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
	    
            gaDataset2[0][0] = '<input type="text" name="totalCC" '+
	         		    'id="totalCC"' +
                                    'value=""' +
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

            gaDataset2[0][1] = '<input type="text" name="totalSUS" '+
	         		    'id="totalSUS"' +
                                    'value="" '+
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

            gaDataset2[0][2] = '<input type="text" name="totalCanc" '+
	         		    'id="totalCanc"' +
                                    'value="" '+
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

	    headers2 = new Array (
	    //0: Monto Aplicaciones Moviles 
	              {text:'Monto Total Aplicaciones M&oacute;viles', width:'40%'},
	    //1: Monto SUS
	              {text:'Monto Total SUS', width:'30%'},
	    //2: Monto Aplicaciones Moviles 
	              {text:'Monto Total Cancelaciones', width:'30%'}
            );

	    props2 = new Array(null, null,null);
	    
            totGrid.setHeaders(headers2);
            totGrid.setDataProps(props2);
            totGrid.setData(gaDataset2);        
            totGrid.drawInto('goTotalsGrid');

        }

    }
    
    function initResultGrid()
    {
	var gaDataset2 = new Array(new Array());

	var totalSUS;
	var totalCC = 0.0;
        var totalCanc = 0.0;

        loGrid.bHeaderFix   = false;
        loGrid.isReport     = true;
        loGrid.height       = 30;
        loGrid.width        = '400';
        loGrid.padding      = 6;

        totGrid.bHeaderFix   = false;
        totGrid.isReport     = true;
        totGrid.height       = 30;
        totGrid.width        = '400';
        totGrid.padding      = 5;

        if(gaDataset.length > 0)
        {
            giNumRows = gaDataset.length; //Para los eventos del teclado!!!

            for (var liRowId=0; liRowId<gaDataset.length; liRowId++)
            {
                gaDataset[liRowId][0] = '<input type="hidden" name="idterminal|'+liRowId+'" '+
					'id="idterminal|' +liRowId +'" ' +
                                        'value="' + gaDataset[liRowId][0] + '"> ' +
                                        gaDataset[liRowId][0];


		totalCC += parseFloat(gaDataset[liRowId][1]);
                gaDataset[liRowId][1] = '<input type="hidden" name="monto|'+liRowId+'" '+
                                        'id="monto|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][1] + '"> ' +
					gaDataset[liRowId][1];


                gaDataset[liRowId][2] = '<input type="hidden" name="fecha|'+liRowId+'" '+
                                        'id="fecha|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][2] + '"> ' +
					gaDataset[liRowId][2];

                gaDataset[liRowId][3] = '<input type="hidden" name="hora|'+liRowId+'" '+
                                        'id="hora|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][3] + '"> ' +
					gaDataset[liRowId][3];

                gaDataset[liRowId][4] = '<input type="hidden" name="trans|'+liRowId+'" '+
                                        'id="trans|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][4] + '"> ' +
					gaDataset[liRowId][4];

		totalCanc += parseFloat(gaDataset[liRowId][5]);
                gaDataset[liRowId][5] = '<input type="hidden" name="canc|'+liRowId+'" '+
                                        'id="canc|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][5] + '"> ' +
					gaDataset[liRowId][5];


                gaDataset[liRowId][6] = '<input type="hidden" name="fall|'+liRowId+'" '+
                                        'id="fall|' + liRowId + '" size="15" ' + 
					'value="' + gaDataset[liRowId][6] + '"> ' +
					gaDataset[liRowId][6];

		//gaDataset[liRowId][5] = '<input type="checkbox" disabled name="termfail|'+liRowId+'" value="'+gaDataset[liRowId][5]+'">';
            }

	    totalCC = totalCC.toFixed(2);
	    totalCanc = totalCanc.toFixed(2);


            headers  = new Array(
            // 0:  Terminal
                     {text:'Concepto M&oacute;vil',width:'20%'},
            // 1:  Monto 
                     {text:'Monto',width:'15%'},
            // 2:  Fecha
                     {text:'Fecha',width:'15%'},
            // 3:  Hora
                     {text:'Hora (HH:MM)',width:'15%'},
	    // 4:  Trans
	             {text:'Num. Trans.', width:'15%'},
	    // 5:  Cancelaciones
	             {text:'Monto Cancelaciones', width:'15%'},
	    // 6:  Cierre fallido
	             {text: 'Cierre Fallido', width:'5%'});

            props    = new Array(null, null, null, null, null, null,null);

            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('resultDataGrid');
	    
            gaDataset2[0][0] = '<input type="hidden" name="totalCC" '+
	         		    'id="totalCC"' +
				    'value="' + totalCC + '"'+
				    'disabled="disabled"' +
				    'onKeyDown="handleKeyEvents(event, this)" '+
				    'onFocus="onFocusControl(this)" ' +
				    'onBlur="onBlurControl(this, true)" '+ _class +'>'+totalCC;

            gaDataset2[0][1] = '<input type="text" name="totalSUS" '+
	         		    'id="totalSUS"' +
                                    'value="'+SUStot+'" '+
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

            gaDataset2[0][2] = '<input type="text" name="totalCanc" '+
	         		    'id="totalCanc"' +
                                    'value="'+totalCanc+'" '+
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

	    var diferencia = 0.0;
	    diferencia = parseFloat(SUStot) - parseFloat(totalCC) - parseFloat(totalCanc);
	    diferencia = diferencia.toFixed(2);


            gaDataset2[0][3] = '<input type="text" name="diferencia" '+
	         		    'id="diferencia"' +
                                    'value="'+diferencia+'" '+
                                    'disabled="disabled"' +
                                    'onKeyDown="handleKeyEvents(event, this)" '+
                                    'onFocus="onFocusControl(this)" ' +
                                    'onBlur="onBlurControl(this, true)" '+ _class +'>';

	    headers2 = new Array (
	    //0: Monto Aplicaciones Moviles 
	              {text:'Monto Total Aplicaciones M&oacute;viles', width:'25%'},
	    //1: Monto SUS
	              {text:'Monto Total SUS', width:'25%'},
	    //2: Monto Cancelacion
	              {text:'Monto Total Cancelaciones', width:'25%'},
            //3: Diferencia
	              {text:'Diferencia', width:'25%'});

	    props2 = new Array(null, null,null,null);
	    
            totGrid.setHeaders(headers2);
            totGrid.setDataProps(props2);
            totGrid.setData(gaDataset2);        
            totGrid.drawInto('resultTotalsGrid');

        }

    }

    function customFocusElement(psElementId)
    {
        loElement = document.getElementById(psElementId).parentNode;
        lsClassName = loElement.className;
    	loElement.className = lsClassName + ' entry_over';

        document.getElementById(psElementId).focus();

        autoSelect(document.getElementById(psElementId));
    }


    function customUnfocusElement(psElementId)
    {
        loElement = document.getElementById(psElementId).parentNode;
	    lsClassName = loElement.className;

    	lsClassName=lsClassName.replace(/ entry_over/gi, "");

	    loElement.className = lsClassName;

        document.getElementById(psElementId).blur();
    }

    function autoSelect(poEntry)
    {
    	var size  = poEntry.length;
	    var value = poEntry.value;

	    poEntry.select();
    }

    function cancel()
    {
       window.close();
    }

