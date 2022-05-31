// InventoryDetailYum.jsp

var increment = 0;
var gbValidEntry = true;

function customDataset(paDataset, fontSize){
  var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";
  var lsUM;
  for(var idx=0; idx<paDataset.length; idx++){
        var liRowId = idx + giNumRows;
    var lsInventoryId = 'inventoryId|' + liRowId;
//alert("paDataset[idx].length["+paDataset[idx].length+"]");
    if(paDataset[idx].length == giNumColumns){
        lsUM = paDataset[idx][16];
            lsInventoryUm     = 'inventoryUm|' + liRowId;
            //paDataset[idx][1] = '<div id="beginInvQty|'+liRowId+'">'+ paDataset[idx][1]+'</div>';
        paDataset[idx][1] = '<input type="text" name="beginInvQty|'+liRowId+'" id="beginInvQty|'+liRowId+
                            '" readonly="true" size="8" value="'+paDataset[idx][1]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
                            '" OnBlur="onBlurControl(this,true);" '+_class+'>';
        //paDataset[idx][2] = '<div id="receptionsQty|'+liRowId+'">'+ paDataset[idx][2]+'</div>';
        paDataset[idx][2] = '<input type="text" name="receptionsQty|'+liRowId+'" id="receptionsQty|'+liRowId+ 
                            '" readonly="true" size="8" value="'+paDataset[idx][2]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
                            'onFocus="onFocusControl(this) " OnBlur="onBlurControl(this,true);" '+_class+'>';
        //paDataset[idx][3] = '<div id="itransfersQty|'+liRowId+'">'+ paDataset[idx][3]+'</div>';
        paDataset[idx][3] = '<input type="text" name="itransfersQty|'+liRowId+'" id="itransfersQty|'+liRowId+ 
                            '" readonly="true" size="8" value="'+paDataset[idx][3]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
                            'onFocus="onFocusControl(this) " OnBlur="onBlurControl(this,true);" '+_class+'>';
        //paDataset[idx][4] = '<div id="otransfersQty|'+liRowId+'">'+ paDataset[idx][4]+'</div>';
        paDataset[idx][4] = '<input type="text" name="otransfersQty|'+liRowId+'" id="otransfersQty|'+liRowId+ 
                            '" readonly="true" size="8" value="'+paDataset[idx][4]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
                            'onFocus="onFocusControl(this) " OnBlur="onBlurControl(this,true);" '+_class+'>';
        // Captura en unidades de proveedor
        paDataset[idx][5] = '<input type="text" name="finalPrvQty|'+liRowId+'" id="finalPrvQty|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][5]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            'onFocus="onFocusControl(this) " OnBlur="onBlurControl(this,true);focusToRecptureValue(this)" '+_class+'>';
        paDataset[idx][6] = '<input type="text" name="finalPrvQtyRec|'+liRowId+'" id="finalPrvQtyRec|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][6]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            'onFocus="onFocusControl(this) " OnBlur="onBlurControl(this,true);validateValues(this,true);"  '+_class+'>';

        // Captura en unidades de inventario
        paDataset[idx][7] = '<input type="text" name="finalInvQty|'+liRowId+'" id="finalInvQty|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][7]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            ' onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);focusToRecptureValue(this)" '+_class+'>';
        paDataset[idx][8] = '<input type="text" name="finalInvQtyRec|'+liRowId+'" id="finalInvQtyRec|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][8]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            ' onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);validateValues(this,true);" '+_class+'>';

        // Captura en unidades de receta
        paDataset[idx][9] = '<input type="text" name="finalRecQty|'+liRowId+'" id="finalRecQty|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][9]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);focusToRecptureValue(this)" '+_class+'>';
        paDataset[idx][10] = '<input type="text" name="finalRecQtyRec|'+liRowId+'" id="finalRecQtyRec|'+liRowId+ 
                            '" size="8" value="'+paDataset[idx][10]+'" maxlength="15"  '+
                            'autocomplete="off" onKeyDown="handleKeyEventsA(event,this)" onkeypress="return valNumber(event)" '+
                            'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);validateValues(this,true);" '+_class+'>';

        paDataset[idx][11] = '<div id="finalInvTotal|'+liRowId+'" ></div>';
        //paDataset[idx][8] = '<input type="text" name="finalInvTotal|'+liRowId+'" id="finalInvTotal|'+liRowId+ 
        //                   '" size="8" value="'+paDataset[idx][8]+'" maxlength="15"  '+
        //                    'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  '+
        //                    'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';
        paDataset[idx][12] = '<div id="realUseQty|'+liRowId+'" ></div>';
                //paDataset[idx][10] = '<div id="idealUseQty|'+liRowId+'">'+paDataset[idx][10]+'</div>';
        //paDataset[idx][11] = '<div id="differenceQty|'+liRowId+'" ></div>';
        //paDataset[idx][12] = '<div id="moneyQty|'+liRowId+'" ></div>';
        paDataset[idx][13] = '<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+'" size="8" value="'+paDataset[idx][13]+'" maxlength="15"  ' + 
                             'autocomplete="off" onKeyDown="handleKeyEvents(event,this)"  ' + 
                             'onFocus="onFocusControl(this)" OnBlur="onBlurControl(this,true);" '+_class+'>';
        paDataset[idx][17] = '<div id="faltantQty|'+liRowId+'">'+paDataset[idx][17]+'</div>';

        lsItemId = paDataset[idx][18];
        
        gaInventoryUm[lsInventoryId]      = paDataset[idx][19];
        gaProviderConvFact[lsInventoryId] = paDataset[idx][20];
        gaProviderUm[lsInventoryId]       = paDataset[idx][21];
        gaRecipeConvFact[lsInventoryId]   = paDataset[idx][22];
        //gaInventoryDetailYum.js
        gaRecipeUm[lsInventoryId]         = paDataset[idx][23];
        gaUnitCost[lsInventoryId]         = paDataset[idx][24];
        gaMaxVariance[lsInventoryId]      = paDataset[idx][25];
        gaMinEfficiency[lsInventoryId]    = paDataset[idx][26];
        gaMaxEfficiency[lsInventoryId]    = paDataset[idx][27];
        gaMiscelaneo[lsInventoryId]       = paDataset[idx][28];
        gaWeekDay[lsInventoryId]          = paDataset[idx][29];

      }else{
        paDataset[idx][0] = 'colspan=05~'+paDataset[idx][0];
        paDataset[idx][5] = 'colspan=01~<input type="text" name="finalPrvQty|'+liRowId+'" '+
                            'id="finalPrvQty|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" ' + 
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';

        paDataset[idx][6] = 'colspan=01~<input type="text" name="finalPrvQtyRec|'+liRowId+'" '+
                            'id="finalPrvQtyRec|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" ' + 
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';

        paDataset[idx][7] = 'colspan=01~<input type="text" name="finalInvQty|'+liRowId+'" '+ 
                            'id="finalInvQty|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" '+
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';

        paDataset[idx][8] = 'colspan=01~<input type="text" name="finalInvQtyRec|'+liRowId+'" '+ 
                            'id="finalInvQtyRec|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" '+
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';


        paDataset[idx][9] = 'colspan=01~<input type="text" name="finalRecQty|'+liRowId+'" '+
                            'id="finalRecQty|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" '+
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';

        paDataset[idx][10] = 'colspan=01~<input type="text" name="finalRecQtyRec|'+liRowId+'" '+
                            'id="finalRecQtyRec|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5" '+
                            'onFocus="onFocusCustomControl2(this)" '+
                            'onBlur="onBlurCustomControl2(this)"' + _class+'>';


        paDataset[idx][11] = 'colspan=05~&nbsp;';
        paDataset[idx][12] = 'colspan=02~<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+ '" value="" '+
                            'autocomplete="off" readonly="true" size="5"'+
                            'onFocus="onFocusCustomControl2(this)" '+_class+'>' ;
        lsItemId = 'NA';

        lsFinalPrvQty}
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

function onFocusCustomControl(poControl){
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    
    var lsFinalPrvQty  =  'finalPrvQty|' + lsRowId;
    var lsFinalInvQty  =  'finalInvQty|' + lsRowId;
    var lsFinalRecQty  =  'finalRecQty|' + lsRowId;

    var lsDecreaseQty  =  'decreaseQty|' + lsRowId;

    var lsFinalPrvQtyRec =  'finalPrvQtyRec|' + lsRowId;
    var lsFinalInvQtyRec =  'finalInvQtyRec|' + lsRowId;
    var lsFinalRecQtyRec =  'finalRecQtyRec|' + lsRowId;

    var lsFinalInvTotal = getFinalInventory(lsRowId);

    lfOrigProviderQty   = _getFinalPrvQty(lsRowId);
    lfOrigInventoryQty  = _getFinalInvQty(lsRowId);
    lfOrigRecipeQty     = _getFinalRecQty(lsRowId);

    lfOrigProviderQtyRec   = _getFinalPrvQtyRec(lsRowId);
    lfOrigInventoryQtyRec  = _getFinalInvQtyRec(lsRowId);
    lfOrigRecipeQtyRec     = _getFinalRecQtyRec(lsRowId);

    lfOrigDecreaseQty   = _getDecreaseQty(lsRowId);
    lfOrigProviderConvF = _getProviderConvFact(lsRowId);
    liBusinessDay    =  getBusniessDay(lsRowId);

    if(lfOrigProviderConvF == 0.00 && lsElement == lsFinalPrvQty){
            document.getElementById(lsFinalPrvQty).maxLength = 0;
            document.getElementById(lsFinalPrvQty).value = '';

        var currentScroll = document.getElementById('bsTbBs_DateGrid_0').scrollTop;
        var posX = findPosX(poControl);
        var posY = findPosY(poControl) - currentScroll;
        showfixtip('En este producto no se permite la captura en unidades de proveedor.', posX, posY);
    }else{
        if(lsElement == lsFinalPrvQty)
            document.getElementById(lsFinalPrvQty).value = _getFinalPrvQty(lsRowId);

        if(lsElement == lsFinalInvQty)
            document.getElementById(lsFinalInvQty).value = _getFinalInvQty(lsRowId);

        if(lsElement == lsFinalRecQty)
            document.getElementById(lsFinalRecQty).value = _getFinalRecQty(lsRowId);

    }
    /*if(lfOrigProviderConvF == 0.00 && lsElement == lsFinalPrvQtyRec){
            document.getElementById(lsFinalPrvQtyRec).maxLength = 0;
            document.getElementById(lsFinalPrvQtyRec).value = '';

        var currentScroll = document.getElementById('bsTbBs_DateGrid_0').scrollTop;
        var posX = findPosX(poControl);
        var posY = findPosY(poControl) - currentScroll;
        showfixtip('En este producto no se permite la captura en unidades de proveedor.', posX, posY);
    }else{
        if(lsElement == lsFinalPrvQtyRec)
            document.getElementById(lsFinalPrvQtyRec).value = _getFinalPrvQtyRec(lsRowId);

        if(lsElement == lsFinalInvQtyRec)
            document.getElementById(lsFinalInvQtyRec).value = _getFinalInvQtyRec(lsRowId);

        if(lsElement == lsFinalRecQtyRec)
            document.getElementById(lsFinalRecQtyRec).value = _getFinalRecQtyRec(lsRowId);

    }*/

    if(liBusinessDay == 1 && (lsElement == lsFinalPrvQty || lsElement == lsFinalInvQty || lsElement == lsFinalRecQty)){ // Cambiar condicion a 1 (Lunes)
        document.getElementById(lsFinalPrvQty).maxLength = 0;
        document.getElementById(lsFinalPrvQty).value = '';
        document.getElementById(lsFinalInvQty).maxLength = 0;
        document.getElementById(lsFinalInvQty).value = '';
        document.getElementById(lsFinalRecQty).maxLength = 0;
        document.getElementById(lsFinalRecQty).value = '';
        
        var currentScroll = document.getElementById('bsTbBs_DateGrid_0').scrollTop;
        var posX = findPosX(poControl);
        var posY = findPosY(poControl) - currentScroll;
        showfixtip('No puede realizar la captura el d\u00EDa lunes de la fecha de negocio', posX, posY);
    }
    else{
        if(lsElement == lsFinalPrvQty){
        document.getElementById(lsFinalPrvQty).value = _getFinalPrvQty(lsRowId);
    }

    if(lsElement == lsFinalInvQty)
        document.getElementById(lsFinalInvQty).value = _getFinalInvQty(lsRowId);

    if(lsElement == lsFinalRecQty)
        document.getElementById(lsFinalRecQty).value = _getFinalRecQty(lsRowId);

    if(lsElement == lsDecreaseQty)
            document.getElementById(lsDecreaseQty).value = _getDecreaseQty(lsRowId);
        
    if(lsElement == lsFinalInvTotal)
        document.getElementById(lsFinalInvTotal).value = lsFinalInvTotal;
    }
}
function customUnfocusElement(psElementId){
    loElement = document.getElementById(psElementId).parentNode;
    lsClassName = loElement.className;
    lsClassName=lsClassName.replace(/ entry_over/gi, "");
    loElement.className = lsClassName;
}

function onBlurCustomControl(poControl, event){
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));

    /*
    'finalInvQty|'
    'finalRecQty|'
    */
   
    if(lfOrigProviderConvF == 0 && (lsRowName == 'finalPrvQty' || lsRowName == 'finalInvQty' || lsRowName == 'finalRecQty')){
        hidefixtip();
    }
    else{
        if(lsRowName == 'finalInvQty')
                if(_getFinalInvQty(lsRowId) < 0){
                        gbValidEntry = false;
                        alert('No puede poner valores negativos.');
                        unfocusElement(goCurrentCtrl.id);
                        focusElement(goLastCtrl.id);
                        return;
                }
                else{
                        gbValidEntry = true;
                        if(lfOrigInventoryQty != _getFinalInvQty(lsRowId))
                                hasChanges();
                }

                if(lsRowName == 'finalPrvQty')
                        if(_getFinalPrvQty(lsRowId) < 0){
                                gbValidEntry = false;
                                alert('No puede poner valores negativos.');
                                unfocusElement(goCurrentCtrl.id);
                                focusElement(goLastCtrl.id);
                                return;
                        }
                        else{
                                gbValidEntry = true;
                                if(lfOrigProviderQty != _getFinalPrvQty(lsRowId))
                                hasChanges();
                        }

                if(lsRowName == 'finalRecQty')
                        if(_getFinalRecQty(lsRowId) < 0){
                                gbValidEntry = false;
                                alert('No puede poner valores negativos.');
                                unfocusElement(goCurrentCtrl.id);
                                focusElement(goLastCtrl.id);
                                return;
                        }
                        else{
                                gbValidEntry = true;
                                if(lfOrigRecipeQty != _getFinalRecQty(lsRowId))
                                        hasChanges();
                        }

                if(lsRowName == 'decreaseQty')
                        if(_getDecreaseQty(lsRowId) < 0){
                                gbValidEntry = false;
                                alert('No puede poner valores negativos.');
                                unfocusElement(goCurrentCtrl.id);
                                focusElement(goLastCtrl.id);
                                return;
                        }
                else{
                        gbValidEntry = true;
                        if(lfOrigDecreaseQty != _getDecreaseQty(lsRowId))
                                hasChanges();

                }

                /*if(parseFloat(getExistence(lsRowId)) < parseFloat(getFinalInventory(lsRowId))){
                        gbValidEntry = false;
                        alert('No puede inventariar mas de lo que tiene en existencia');

                        //Restaura valor eoriginal
                        //document.getElementById(poControl.id).value = lfOrigInventoryQty;

                        unfocusElement(goCurrentCtrl.id);
                        focusElement(goLastCtrl.id);
                        return;
                }
                else
                        gbValidEntry = true;*/
        }
        if(gbValidEntry)
                updateRowValues(lsRowId);
}


function onBlurCustomControlMC(poControl, event){
    var lsElement = poControl.name;
    var lsRowId   = lsElement.substring(lsElement.indexOf('|')+1);
    var lsRowName = lsElement.substring(0, lsElement.indexOf('|'));
    /*
    
    'finalInvQty|'
    'finalRecQty|'
    
    */
    
    if(lfOrigProviderConvF == 0 && (lsRowName == 'finalPrvQty' || lsRowName == 'finalInvQty' || lsRowName == 'finalRecQty')){
        hidefixtip();
    }else{
        if(lsRowName == 'finalInvQty'){
            if(_getFinalInvQty(lsRowId) < 0){
                gbValidEntry = false;
                alert('No puede poner valores negativos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigInventoryQty != _getFinalInvQty(lsRowId))
                    hasChanges();
            }
        }
        if(lsRowName == 'finalPrvQty'){
            lsFinalPrvQty = _getFinalPrvQty(lsRowId)
            if(_getFinalPrvQty(lsRowId) < 0){
                gbValidEntry = false;
                alert('No puede poner valores negativos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigProviderQty != _getFinalPrvQty(lsRowId))
                    hasChanges();
            }
        }
        if(lsRowName == 'finalRecQty'){
            if(_getFinalRecQty(lsRowId) < 0){
                gbValidEntry = false;
                alert('No puede poner valores negativos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigRecipeQty != _getFinalRecQty(lsRowId))
                    hasChanges();
            }
        }

// Validamos que sean iguales proveedores
        if(lsRowName == 'finalPrvQty'){
            if(_getFinalPrvQtyRec(lsRowId) > 0 && _getFinalPrvQty(lsRowId) != _getFinalPrvQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigProviderQty == _getFinalPrvQtyRec(lsRowId))
                    hasChanges();
            }
        }
        if(lsRowName == 'finalPrvQtyRec'){
            lsOldRowId = lsRowId-1;
            lsFinalPrvQtyRec = lsRowName+'|'+lsOldRowId;
            if(_getFinalPrvQty(lsRowId) != _getFinalPrvQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                //document.getElementById(lsFinalPrvQtyRec).value=0;
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigProviderQty == _getFinalPrvQtyRec(lsRowId))
                    hasChanges();
            }
        }

// Validamos que sean iguales inventario 
        if(lsRowName == 'finalInvQty'){
            if(_getFinalInvQtyRec(lsRowId) > 0 && _getFinalInvQty(lsRowId) != _getFinalInvQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigInventoryQty == _getFinalInvQtyRec(lsRowId))
                    hasChanges();
            }
        }
        if(lsRowName == 'finalInvQtyRec'){
            lsOldRowId = lsRowId-1;
            lsFinalInvQtyRec = lsRowName+'|'+lsOldRowId;
            if(_getFinalInvQty(lsRowId) != _getFinalInvQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                //document.getElementById(lsFinalPrvQtyRec).value=0;
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigInventoryQty == _getFinalInvQtyRec(lsRowId))
                    hasChanges();
            }
        }

// Validamos que sean iguales receta 
        if(lsRowName == 'finalRecQty'){
            if(_getFinalRecQtyRec(lsRowId) > 0 &&_getFinalRecQty(lsRowId) != _getFinalRecQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigRecipeQty == _getFinalRecQtyRec(lsRowId))
                    hasChanges();
            }
        }
        if(lsRowName == 'finalRecInvRec'){
            lsOldRowId = lsRowId-1;
            lsFinalRecQtyRec = lsRowName+'|'+lsOldRowId;
            if(_getFinalRecQty(lsRowId) != _getFinalRecQtyRec(lsRowId)){
                gbValidEntry = false;
                alert('Los datos no coinciden por favor valide que sean correctos.');
                //document.getElementById(lsFinalPrvQtyRec).value=0;
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigRecipeQty == _getFinalRecQtyRec(lsRowId))
                    hasChanges();
            }
        }


        if(lsRowName == 'decreaseQty'){
            if(_getDecreaseQty(lsRowId) < 0){
                gbValidEntry = false;
                alert('No puede poner valores negativos.');
                unfocusElement(goCurrentCtrl.id);
                focusElement(goLastCtrl.id);
                return;
            }else{
                gbValidEntry = true;
                if(lfOrigDecreaseQty != _getDecreaseQty(lsRowId))
                    hasChanges();
            }
        }
        /*if(parseFloat(getExistence(lsRowId)) < parseFloat(getFinalInventory(lsRowId))){
            gbValidEntry = false;
            alert('No puede inventariar mas de lo que tiene en existencia');

            //Restaura valor eoriginal
                    //document.getElementById(poControl.id).value = lfOrigInventoryQty;

                unfocusElement(goCurrentCtrl.id);
                    focusElement(goLastCtrl.id);
            return;
        }
        else
            gbValidEntry = true;*/
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

function valNumber(poEvent) {
        poEvent = (poEvent) ? poEvent : window.event;
        var charCode = (poEvent.which) ? poEvent.which : poEvent.keyCode;

        if (charCode == 46 || charCode == 37 || charCode == 39 || liKeyCode == 13 || liKeyCode == 40) {
                return true;
        }

        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
        }
        return true;
}

function handleKeyEventsA(poEvent, objUsed) {

	goLastKeyEvent = poEvent;

	var lsElement = objUsed.id;
	liRowId = parseInt(lsElement.substring(lsElement.indexOf("|") + 1));
	lsElement = lsElement.substr(0, lsElement.indexOf("|"));

	liKeyCode = getKeyCode(poEvent);
	liNumRows = getNumRows();
	// alert("Tecla presionada: [" + poEvent.which + "], [" + liKeyCode + "]");

	if (liKeyCode == 13 || liKeyCode == 40) {// <enter> o flecha hacia abajo
		if (liNumRows > 1) { // Si hay mas de dos filas
			// if (liRowId < (liNumRows - 1)) {
			var lsRecap = lsElement.substring(11, lsElement.length) == "Rec" ? true : false;
			if (lsRecap) {
				validateValues(objUsed, false);
				if (increment == 0) {
					if ((liNumRows - 1) == liRowId) {
						var lsNextElem = lsElement.substring(5, 8) == "Prv" ? "Inv" : (lsElement.substring(5, 8) == "Inv" ? "Rec" : "Prv");
						lsCurrentElement = 'final' + lsNextElem + 'Qty|1';
					} else {
						lsCurrentElement = '';
						lsCurrentElement = lsElement.substring(0,(lsElement.length - 3)).concat("|", liRowId + 1);
					}
					increment = 1;
				} else {
					lsCurrentElement = lsElement.substring(0, lsElement.length).concat("|", liRowId);
					increment = 1;
				}
			} else {

				lsCurrentElement = lsElement.concat("Rec|", liRowId);
			}

			lsPreviousElement = lsElement.concat("|", liRowId);

			// El elemento seleccionado
			goCurrentCtrl = document.getElementById(lsCurrentElement);
			// El elemento anterior seleccionado
			goLastCtrl = document.getElementById(lsPreviousElement);

			// alert("[" + lsCurrentElement + "]");
			//
			// loElement =
			// document.getElementById(lsCurrentElement).parentNode;
			// lsClassName = loElement.className;
			// loElement.className = lsClassName + ' entry_over';
			// document.getElementById(lsCurrentElement).focus();

			// customFocusElement(lsCurrentElement);
			focusElement(lsCurrentElement);
			// } else {
			// alert("Es el último elemento");
			// lsLastElement = lsElement.concat("|", liRowId);
			// document.getElementById(lsLastElement).blur();
			// // El elemento seleccionado
			// goCurrentCtrl = goLastCtrl = document
			// .getElementById(lsLastElement);
			// setTimeout("document.getElementById(lsLastElement).focus()", 10);
			// }
		}
	}
	if (liKeyCode == 38) { // Fecha hacia arriba
		if (liNumRows > 1) { // Si hay mas de dos filas
			if (liRowId > 0) {
				lsCurrentElement = lsElement.concat("|", liRowId - 1);
				lsPreviousElement = lsElement.concat("|", liRowId);

				goCurrentCtrl = document.getElementById(lsCurrentElement);
				goLastCtrl = document.getElementById(lsPreviousElement);

				focusElement(lsCurrentElement);
			}
		}
	}

	return (liKeyCode);
}

function validateValues(objUsed, focus) {
        var lsBeforeElement;
        var lsElement = objUsed.id;
        liRowElement = parseInt(lsElement.substring(lsElement.indexOf("|") + 1));
        // lfOrigProviderConvF = _getProviderConvFact(lsRowId);
        // if(lfOrigProviderConvF == 0 && lsElement == lsFinalPrvQty){
        // }

        lsElement = lsElement.substr(0, (lsElement.indexOf("|") - 3));

        lsBeforeElement = lsElement.concat("|", liRowElement);

        if ( !focus ){
                lsBeforeElement = lsElement.concat("|", (liRowElement + 1));
                if ( document.getElementById(lsBeforeElement) != null ){
                        document.getElementById(lsBeforeElement).focus();
                } else {
                        if ( lsElement == "finalPrvQty" ){
                                document.getElementById("finalInvQty|1").focus();
                        } else if ( lsElement == "finalInvQty" ){
                                document.getElementById("finalRecQty|1").focus();
                        } else {
                                document.getElementById("finalPrvQty|1").focus();
                        }
                }
                return;
        }

        lsValue = document.getElementById(lsBeforeElement).value;
        if (lsValue == "") {
                lsActualElement = lsElement.concat("Rec|", liRowElement);
                // alert("En este producto no se permite la captura en unidades de
                // proveedor [" + lsActualElement + "]");
                document.getElementById(lsActualElement).maxLength = 0;
                document.getElementById(lsActualElement).value = '';
                lsBeforeElement = lsElement.concat("|", (liRowElement + 1));
                focusElement(lsBeforeElement);
                return;
        }
        lfValue = parseFloat(lsValue.substr(0, lsValue.indexOf(" ")));
        lfValueRec = parseFloat(objUsed.value);
        if (lfValue != lfValueRec) {
                increment = 1;
                if (focus) {
                        alert("Los valores ingresados no coinciden, por favor valida que sean correctos");
                        goCurrentCtrl = document.getElementById(lsBeforeElement);
                        focusElement(lsBeforeElement);
                }
        } else {
                increment = 0;
        }
}

function focusToRecptureValue(objUsed) {
        lsElement = objUsed.id;
        liRowId = parseInt(lsElement.substring(lsElement.indexOf("|") + 1));
        lsElement = lsElement.substr(0, lsElement.indexOf("|"));
        lsNextElement = lsElement.concat("Rec|", liRowId);
        goCurrentCtrl = document.getElementById(lsNextElement);
        focusElement(lsNextElement);
}

