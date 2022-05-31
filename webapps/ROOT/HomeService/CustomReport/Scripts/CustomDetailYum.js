
var gbValidEntry = true;

function customDataset(paDataset, fontSize)
{
  var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";

  for(var idx=0; idx<paDataset.length; idx++)
  {
    var liRowId = idx + giNumRows;
	var lsInventoryId = 'inventoryId|' + liRowId;

	if(paDataset[idx].length == giNumColumns)
	{
        lsInventoryUm     = 'inventoryUm|' + liRowId;

	    paDataset[idx][1] = '<div id="beginInvQty|'+liRowId+'">'+ paDataset[idx][1]+'</div>';
		paDataset[idx][2] = '<div id="receptionsQty|'+liRowId+'">'+ paDataset[idx][2]+'</div>';
		paDataset[idx][3] = '<div id="itransfersQty|'+liRowId+'">'+ paDataset[idx][3]+'</div>';
		paDataset[idx][4] = '<div id="otransfersQty|'+liRowId+'">'+ paDataset[idx][4]+'</div>';

		paDataset[idx][5] = '<input type="text" name="finalPrvQty|'+liRowId+'" id="finalPrvQty|'+liRowId+ 
		                    '" size="8" value="'+paDataset[idx][5]+'" maxlength="15"  '+
							'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
							'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';

		paDataset[idx][6] = '<input type="text" name="finalInvQty|'+liRowId+'" id="finalInvQty|'+liRowId+ 
		                    '" size="8" value="'+paDataset[idx][6]+'" maxlength="15"  '+
							'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
							' onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';

		paDataset[idx][7] = '<input type="text" name="finalRecQty|'+liRowId+'" id="finalRecQty|'+liRowId+ 
		                    '" size="8" value="'+paDataset[idx][7]+'" maxlength="15"  '+
							'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
							'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';
		paDataset[idx][8] = '<div id="finalInvTotal|'+liRowId+'" >'+paDataset[idx][8]+'</div>';
		paDataset[idx][9] = '<div id="realUseQty|'+liRowId+'" >'+paDataset[idx][9]+'</div>';
        paDataset[idx][10] = '<div id="idealUseQty|'+liRowId+'">'+paDataset[idx][10]+'</div>';
		paDataset[idx][11] = '<div id="differenceQty|'+liRowId+'" >'+paDataset[idx][11]+'</div>';
		paDataset[idx][12] = '<div id="moneyQty|'+liRowId+'" >'+paDataset[idx][12]+'</div>';
		paDataset[idx][13] = '<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+ '" size="7" value="'+paDataset[idx][13]+'" maxlength="15"  ' + 
							 'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  ' + 
							 'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';
		paDataset[idx][14] = '<div id="faltantQty|'+liRowId+'">'+paDataset[idx][14]+'</div>';

		lsItemId = paDataset[idx][15];
		
		gaInventoryUm[lsInventoryId]      = paDataset[idx][16];
		gaProviderConvFact[lsInventoryId] = paDataset[idx][17];
		gaProviderUm[lsInventoryId]       = paDataset[idx][18];
		gaRecipeConvFact[lsInventoryId]   = paDataset[idx][19];
		gaRecipeUm[lsInventoryId]         = paDataset[idx][20];
		gaUnitCost[lsInventoryId]         = paDataset[idx][21];
		gaMaxVariance[lsInventoryId]  	  = paDataset[idx][22];
		gaMinEfficiency[lsInventoryId] 	  = paDataset[idx][23];
		gaMaxEfficiency[lsInventoryId] 	  = paDataset[idx][24];
        gaMiscelaneo[lsInventoryId]       = paDataset[idx][25];

	  }
	  else
	  {

		paDataset[idx][0] = 'colspan=05~'+paDataset[idx][0];
		paDataset[idx][5] = 'colspan=01~<input type="text" name="finalPrvQty|'+liRowId+'" '+
                            'id="finalPrvQty|'+liRowId+ '" value="" '+
							'autocomplete="off" readonly="true" size="5" '+
							'onFocus="onFocusCustomControl2(this)" ' + 
							'onBlur="onBlurCustomControl2(this)"' + _class+'>';

		paDataset[idx][6] = 'colspan=01~<input type="text" name="finalInvQty|'+liRowId+'" '+ 
                            'id="finalInvQty|'+liRowId+ '" value="" '+
							'autocomplete="off" readonly="true" size="5" '+
							'onFocus="onFocusCustomControl2(this)" '+
							'onBlur="onBlurCustomControl2(this)"' + _class+'>';

		paDataset[idx][7] = 'colspan=01~<input type="text" name="finalRecQty|'+liRowId+'" '+
                            'id="finalRecQty|'+liRowId+ '" value="" '+
							'autocomplete="off" readonly="true" size="5" '+
							'onFocus="onFocusCustomControl2(this)" '+
							'onBlur="onBlurCustomControl2(this)"' + _class+'>';


		paDataset[idx][8] = 'colspan=05~&nbsp;';
		paDataset[idx][13] = 'colspan=02~<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+ '" value="" '+
							'autocomplete="off" readonly="true" size="5"'+
							'onFocus="onFocusCustomControl2(this)" '+_class+'>' ;
		lsItemId = 'NA';

		}
		addHidden(document.forms['frmGrid'], lsInventoryId, lsItemId);

	}
}

function autoSelect(poEntry)
{
	var size  = poEntry.length;
	var value = poEntry.value;

	poEntry.value = ' ' + value + '     ';
	poEntry.select();
}


function customFocusElement(psElementId)
{
    loElement = document.getElementById(psElementId).parentNode;
	lsClassName = loElement.className;
	loElement.className = lsClassName + ' entry_over';

    document.getElementById(psElementId).focus();

	if(gbValidEntry == true)
	{
		autoSelect(document.getElementById(psElementId));
	}		
}

function onFocusCustomControl(poControl)
{
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    
    var lsFinalPrvQty  = 'finalPrvQty|' + lsRowId;
    var lsFinalInvQty  = 'finalInvQty|' + lsRowId;
    var lsFinalRecQty  = 'finalRecQty|' + lsRowId;
    var lsDecreaseQty  = 'decreaseQty|' + lsRowId;

    lfOrigProviderQty   = _getFinalPrvQty(lsRowId);
    lfOrigInventoryQty  = _getFinalInvQty(lsRowId);
    lfOrigRecipeQty     = _getFinalRecQty(lsRowId);
    lfOrigDecreaseQty   = _getDecreaseQty(lsRowId);
    lfOrigProviderConvF = _getProviderConvFact(lsRowId);

	if(lfOrigProviderConvF == 0 && lsElement == lsFinalPrvQty)
	{
        document.getElementById(lsFinalPrvQty).maxLength = 0;
        document.getElementById(lsFinalPrvQty).value = '';

		var currentScroll = document.getElementById('bsTbBs_DateGrid_0').scrollTop;
		var posX = findPosX(poControl);
		var posY = findPosY(poControl) - currentScroll;
		showfixtip('En este producto no se permite la captura en unidades de proveedor.', posX, posY);
	}	
	else
	{
    	if(lsElement == lsFinalPrvQty)
        	document.getElementById(lsFinalPrvQty).value = _getFinalPrvQty(lsRowId);

	    if(lsElement == lsFinalInvQty)
    	    document.getElementById(lsFinalInvQty).value = _getFinalInvQty(lsRowId);

	    if(lsElement == lsFinalRecQty)
    	    document.getElementById(lsFinalRecQty).value = _getFinalRecQty(lsRowId);

		if(lsElement == lsDecreaseQty)
        	document.getElementById(lsDecreaseQty).value = _getDecreaseQty(lsRowId);
	}
}
function customUnfocusElement(psElementId)
{
    loElement = document.getElementById(psElementId).parentNode;
	lsClassName = loElement.className;

	lsClassName=lsClassName.replace(/ entry_over/gi, "");

	loElement.className = lsClassName;
}


function onBlurCustomControl(poControl, event)
{
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));
    
	if(lfOrigProviderConvF == 0 && lsRowName == 'finalPrvQty')
	{
		hidefixtip();
	}
	else
	{
    	if(lsRowName == 'finalInvQty')
        	if(_getFinalInvQty(lsRowId) < 0)
        	{
				gbValidEntry = false;
            	alert('No puede poner valores negativos.');
            	unfocusElement(goCurrentCtrl.id);
            	focusElement(goLastCtrl.id);
				return;
        	}
			else
			{	
				gbValidEntry = true;
				if(lfOrigInventoryQty != _getFinalInvQty(lsRowId))
					hasChanges();
			}

		if(lsRowName == 'finalPrvQty')
        	if(_getFinalPrvQty(lsRowId) < 0)
        	{
				gbValidEntry = false;
            	alert('No puede poner valores negativos.');
            	unfocusElement(goCurrentCtrl.id);
            	focusElement(goLastCtrl.id);
				return;
        	}
			else
			{
				gbValidEntry = true;
				if(lfOrigProviderQty != _getFinalPrvQty(lsRowId))
					hasChanges();
			}

		if(lsRowName == 'finalRecQty')
        	if(_getFinalRecQty(lsRowId) < 0)
        	{
				gbValidEntry = false;
            	alert('No puede poner valores negativos.');
            	unfocusElement(goCurrentCtrl.id);
            	focusElement(goLastCtrl.id);
				return;
        	}
			else
			{
				gbValidEntry = true;
				if(lfOrigRecipeQty != _getFinalRecQty(lsRowId))
					hasChanges();
			}

		if(lsRowName == 'decreaseQty')
    	    if(_getDecreaseQty(lsRowId) < 0)
        	{
				gbValidEntry = false;
            	alert('No puede poner valores negativos.');
	            unfocusElement(goCurrentCtrl.id);
    	        focusElement(goLastCtrl.id);
				return;
			}
			else
			{
				gbValidEntry = true;
				if(lfOrigDecreaseQty != _getDecreaseQty(lsRowId))
					hasChanges();

			}

		if(parseFloat(getExistence(lsRowId)) < parseFloat(getFinalInventory(lsRowId)))
		{
			gbValidEntry = false;
			alert('No puede inventariar mas de lo que tiene en existencia.');

			//Restaura valor eoriginal
            //document.getElementById(poControl.id).value = lfOrigInventoryQty;

	        unfocusElement(goCurrentCtrl.id);
    	    focusElement(goLastCtrl.id);
			return;
			
		}
		else
			gbValidEntry = true;
	}


	if(gbValidEntry)
    	updateRowValues(lsRowId);
}

function onFocusCustomControl2(objUsed)
{
	var lsElement = objUsed.id;
	var liRowId   = parseInt(lsElement.substring(lsElement.indexOf("|")+1));

	if(liRowId == 0)
		objUsed.blur();
	else
	{
		var liKeyCode = getKeyCode(goLastKeyEvent);
		handleKeyEvents(goLastKeyEvent, objUsed);
	}	
}

function onBlurCustomControl2(objused)
{
	customUnfocusElement(objused.id);
}
function hasChanges()
{
	document.frmGrid.hidHasChanges.value = 'true';
}


