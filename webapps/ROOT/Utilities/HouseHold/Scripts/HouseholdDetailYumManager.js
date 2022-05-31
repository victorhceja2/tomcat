    function initDataGrid()
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid.bHeaderFix   = true;
        loGrid.isReport     = true;
        loGrid.height       = 330;
        loGrid.width        = '500';
        loGrid.padding      = 4;


        if(gaDataset.length > 0)
        {
            giNumRows = gaDataset.length; //Para los eventos del teclado!!!

            for (var liRowId=0; liRowId<gaDataset.length; liRowId++)
            {
                gaDataset[liRowId][0] = '<input type="hidden" name="ageb|'+liRowId+'" '+
										'id="ageb|' +liRowId +'" ' +
                                        'value="' + gaDataset[liRowId][0] + '"> ' +
                                        gaDataset[liRowId][0];

                gaDataset[liRowId][1] = '<input type="text" name="household|'+liRowId+'" '+
                                       'id="household|' + liRowId + '" size="25" ' + 
                                        'value="' + gaDataset[liRowId][1] + '" autocomplete="off" '+
                                        'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';

                gaDataset[liRowId][2] = '<input type="text" name="target|'+liRowId+'" '+
                                        'id="target|' + liRowId + '" size="25" ' + 
                                        'value="' + gaDataset[liRowId][2] + '" autocomplete="off" '+
                                        'onKeyDown="handleKeyEvents(event, this)" '+
                                        'onFocus="onFocusControl(this)" ' +
                                        'onBlur="onBlurControl(this, true)" '+ _class +'>';
            }


            headers  = new Array(
            // 0:  AGEB
                     {text:'AGEB',width:'30%'},
            // 1:  House Hold
                     {text:'House Hold',width:'35%'},
            // 2:  Objetivo
                     {text:'Objetivo',width:'35%'});

            props    = new Array(null, {entry: true}, {entry: true});

            loGrid.setHeaders(headers);
            loGrid.setDataProps(props);
            loGrid.setData(gaDataset);        
            loGrid.drawInto('goDataGrid');
        }

    }

    function getHouseholdQty(psRowId)
    {
        var loElement = document.getElementById("household|"+psRowId);
        var quantity  = loElement.value;

        return parseInt(quantity);
    }

    function getTargetQty(psRowId)
    {
        var loElement = document.getElementById("target|"+psRowId);
        var quantity  = loElement.value;

        return parseFloat(quantity);
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

