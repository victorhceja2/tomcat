// InventoryCritPreviewYum.js

    function customDataset(paDataset, fontSize, isReport)
    {
        var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";
        for(var idx=0; idx<paDataset.length; idx++){
            var liRowId = idx + giNumRows;
            lsInventoryId      = 'inventoryId|' + liRowId;

            if(paDataset[idx].length == giNumColumns)
            {
                lsInventoryUm     = 'inventoryUm|' + liRowId;
                lsFinalInvQty     = 'finalInvQty|' + liRowId;
                lfRealUse         = round_decimals(parseFloat(paDataset[idx][1]) + parseFloat(paDataset[idx][2]) + parseFloat(paDataset[idx][3]) - parseFloat(paDataset[idx][4]) - parseFloat(paDataset[idx][8]),2);
                lfVarProd         = round_decimals((parseFloat(paDataset[idx][10]) - lfRealUse),2); 
                lfFaltant         = round_decimals(((lfVarProd*(-1)) - parseFloat(paDataset[idx][12])),2);
//console.log("lfFaltant:"+lfFaltant+" lfVarProd:"+lfVarProd+" - "+parseFloat(paDataset[idx][12]));
                lfEficiency       = (lfRealUse != 0)? round_decimals((parseFloat(paDataset[idx][10])/lfRealUse*100),2):0.00;
//console.log("inv_id:"+lsInventoryId+" lfRealUse:"+lfRealUse+" = "+paDataset[idx][1]+" + "+paDataset[idx][2]+" + "+paDataset[idx][3]+" - "+paDataset[idx][4]+" - "+paDataset[idx][1]+" - "+paDataset[idx][8]);
                paDataset[idx][1] = '<input type="text" id="beginInvQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][1]+'" '+_class+'>';
                paDataset[idx][2] = '<input type="text" id="receptionsQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][2]+'" '+_class+'>';
                paDataset[idx][3] = '<input type="text" id="itransfersQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][3]+'" '+_class+'>';
                paDataset[idx][4] = '<input type="text" id="otransfersQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][4]+'" '+_class+'>';

                paDataset[idx][5] = '<input type="text" id="finalPrvQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][5]+'" '+_class+'>';
                paDataset[idx][6] = '<input type="text" id="finalInvQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][6]+'" '+_class+'>';
                paDataset[idx][7] = '<input type="text" id="finalRecQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][7]+'" '+_class+'>';

                paDataset[idx][8] = '<input type="text" id="finalTotQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][8]+'" '+_class+'>';
                paDataset[idx][9] = '<input type="text" id="realUseQty|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+lfRealUse+'" '+_class+'>';
                paDataset[idx][10] = '<input type="text" id="idealUseQty|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+paDataset[idx][10]+'" '+_class+'>';
                paDataset[idx][11] = '<input type="text" id="varProdQty|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfVarProd+'" '+_class+'>';
                paDataset[idx][12] = '<input type="text" id="decreaseQty|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+paDataset[idx][12]+'" '+_class+'>';
                paDataset[idx][13] = '<input type="text" id="faltantQty|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfFaltant+'" '+_class+'>';
                paDataset[idx][14] = '<input type="text" id="faltantQty|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfEficiency+'" '+_class+'>';
                
            
                gaInventoryUm[lsInventoryId]      = paDataset[idx][16];
                gaProviderConvFact[lsInventoryId] = paDataset[idx][17];
                gaProviderUm[lsInventoryId]       = paDataset[idx][18];
                gaRecipeConvFact[lsInventoryId]   = paDataset[idx][19];
                gaRecipeUm[lsInventoryId]         = paDataset[idx][20];
                gaUnitCost[lsInventoryId]         = paDataset[idx][21];
                gaMaxVariance[lsInventoryId]        = paDataset[idx][22];
                gaMinEfficiency[lsInventoryId]       = paDataset[idx][23];
                gaMaxEfficiency[lsInventoryId]       = paDataset[idx][24];
                gaMiscelaneo[lsInventoryId]       = paDataset[idx][25];
            }else{
                paDataset[idx][0] = 'colspan=05~'+paDataset[idx][0];
                paDataset[idx][5] = 'colspan=01~<input type="text" name="finalPrvQty|'+liRowId+'" id="finalPrvQty|'+liRowId+ '" value="" '+
                                    'autocomplete="off" readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" ' + _class+'>';

                paDataset[idx][6] = 'colspan=01~<input type="text" name="finalInvQty|'+liRowId+'" id="finalInvQty|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>';

                paDataset[idx][7] = 'colspan=01~<input type="text" name="finalRecQty|'+liRowId+'" id="finalRecQty|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>';

                paDataset[idx][8] = 'colspan=05~&nbsp;'
                paDataset[idx][12] = 'colspan=02~<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5"'+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>' ;
            }
        }
    }

    function customDatasetAcum(paDataset, fontSize){
        var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";
        for(var idx=0; idx<paDataset.length; idx++){
            var liRowId = idx + giNumRows;
            lsInventoryId     = 'inventoryId|' + liRowId;
            lfRealUse         = round_decimals(parseFloat(paDataset[idx][1]) + parseFloat(paDataset[idx][2]) + parseFloat(paDataset[idx][3]) - parseFloat(paDataset[idx][4]) - parseFloat(paDataset[idx][8]),2);
            lfVarProd         = round_decimals((parseFloat(paDataset[idx][10]) - lfRealUse),2); 
            //lfFaltant         = round_decimals((lfVarProd - parseFloat(paDataset[idx][12])),2);
            lfFaltant         = round_decimals(((lfVarProd*(-1)) - parseFloat(paDataset[idx][12])),2);
            lfEficiency       = (lfRealUse != 0)? round_decimals((parseFloat(paDataset[idx][10])/lfRealUse*100),2):0;
            if(paDataset[idx].length == giNumColumns){
                lsInventoryUm     = 'inventoryUm|' + liRowId;
                lsFinalInvQty     = 'finalInvQty|' + liRowId;
                paDataset[idx][1] = '<input type="text" id="beginInvQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][1]+'" '+_class+'>';
                paDataset[idx][2] = '<input type="text" id="receptionsQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][2]+'" '+_class+'>';
                paDataset[idx][3] = '<input type="text" id="itransfersQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][3]+'" '+_class+'>';
                paDataset[idx][4] = '<input type="text" id="otransfersQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][4]+'" '+_class+'>';
                paDataset[idx][5] = '<input type="text" id="finalPrvQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][5]+'" '+_class+'>';
                paDataset[idx][6] = '<input type="text" id="finalInvQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][6]+'" '+_class+'>';
                paDataset[idx][7] = '<input type="text" id="finalRecQtyAcum|'+liRowId+ '" size="8" '+
                                'readonly="true" value="'+paDataset[idx][7]+'" '+_class+'>';
                paDataset[idx][8] = '<input type="text" id="finalTotQtyAcum|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+paDataset[idx][8]+'" '+_class+'>';
                paDataset[idx][9] = '<input type="text" id="realUseQtyAcum|'+liRowId+ '" size="8" '+
                                    'readonly="true" value="'+lfRealUse+'" '+_class+'>';
                paDataset[idx][10] = '<input type="text" id="idealUseQtyAcum|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+paDataset[idx][10]+'" '+_class+'>';
                paDataset[idx][11] = '<input type="text" id="varProdQtyAcum|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfVarProd+'" '+_class+'>';
                paDataset[idx][12] = '<input type="text" id="decreaseQtyAcum|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+paDataset[idx][12]+'" '+_class+'>';
                paDataset[idx][13] = '<input type="text" id="faltantQtyAcum|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfFaltant+'" '+_class+'>';
                paDataset[idx][14] = '<input type="text" id="faltantQtyAcum|'+liRowId+ '" size="8" '+
                                     'readonly="true" value="'+lfEficiency+'" '+_class+'>';

                gaInventoryUm[lsInventoryId]      = paDataset[idx][16];
                gaProviderConvFact[lsInventoryId] = paDataset[idx][17];
                gaProviderUm[lsInventoryId]       = paDataset[idx][18];
                gaRecipeConvFact[lsInventoryId]   = paDataset[idx][19];
                gaRecipeUm[lsInventoryId]         = paDataset[idx][20];
                gaUnitCost[lsInventoryId]         = paDataset[idx][21];
                gaMaxVariance[lsInventoryId]      = paDataset[idx][22];
                gaMinEfficiency[lsInventoryId]    = paDataset[idx][23];
                gaMaxEfficiency[lsInventoryId]    = paDataset[idx][24];
                gaMiscelaneo[lsInventoryId]       = paDataset[idx][25];
            }
            else{
                paDataset[idx][0] = 'colspan=05~'+paDataset[idx][0];
                paDataset[idx][5] = 'colspan=01~<input type="text" name="finalPrvQty|'+liRowId+'" id="finalPrvQtyAcum|'+liRowId+ '" value="" '+
                                    'autocomplete="off" readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" ' + _class+'>';
                paDataset[idx][6] = 'colspan=01~<input type="text" name="finalInvQty|'+liRowId+'" id="finalInvQtyAcum|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>';

                paDataset[idx][7] = 'colspan=01~<input type="text" name="finalRecQty|'+liRowId+'" id="finalRecQtyAcum|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5" '+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>';

                paDataset[idx][8] = 'colspan=05~&nbsp;'
                paDataset[idx][10] = 'colspan=02~<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQtyAcum|'+liRowId+ '" value="" '+
                                    'readonly="true" size="5"'+
                                    'onFocus="onFocusCustomControl2(this)" '+_class+'>' ;
            }
        }
    }
