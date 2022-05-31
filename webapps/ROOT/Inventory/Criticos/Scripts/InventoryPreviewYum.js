// InventoryPreviewYum.js

	function customDataset(paDataset, fontSize)
	{
    	var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";
		for(var idx=0; idx<paDataset.length; idx++){
        		var liRowId = idx + giNumRows;
			lsInventoryId	  = 'inventoryId|' + liRowId;

			if(paDataset[idx].length == giNumColumns)
			{
        		lsInventoryUm     = 'inventoryUm|' + liRowId;
			lsFinalInvQty     = 'finalInvQty|' + liRowId;

			//paDataset[idx][1] = '<div id="beginInvQty|'+liRowId+'">'+ paDataset[idx][1]+'</div>';
			paDataset[idx][1] = '<input type="text" id="beginInvQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][1]+'" '+_class+'>';
			//paDataset[idx][2] = '<div id="receptionsQty|'+liRowId+'">'+ paDataset[idx][2]+'</div>';
			paDataset[idx][2] = '<input type="text" id="receptionsQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][2]+'" '+_class+'>';
			//paDataset[idx][3] = '<div id="itransfersQty|'+liRowId+'">'+ paDataset[idx][3]+'</div>';
			paDataset[idx][3] = '<input type="text" id="itransfersQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][3]+'" '+_class+'>';
			//paDataset[idx][4] = '<div id="otransfersQty|'+liRowId+'">'+ paDataset[idx][4]+'</div>';
			paDataset[idx][4] = '<input type="text" id="otransfersQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][4]+'" '+_class+'>';

			paDataset[idx][5] = '<input type="text" id="finalPrvQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][5]+'" '+_class+'>';
			paDataset[idx][6] = '<input type="text" id="finalPrvQtyRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][6]+'" '+_class+'>';

			paDataset[idx][7] = '<input type="text" id="finalInvQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][7]+'" '+_class+'>';
			paDataset[idx][8] = '<input type="text" id="finalInvQtyRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][8]+'" '+_class+'>';

			paDataset[idx][9] = '<input type="text" id="finalRecQty|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][9]+'" '+_class+'>';
			paDataset[idx][10] = '<input type="text" id="finalRecQtyRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][10]+'" '+_class+'>';

			paDataset[idx][11] = '<div id="finalInvTotal|'+liRowId+'" ></div>';
			paDataset[idx][12] = '<div id="realUseQty|'+liRowId+'" ></div>';
            		//paDataset[idx][10] = '<div id="idealUseQty|'+liRowId+'">'+paDataset[idx][10]+'</div>';
			//paDataset[idx][11] = '<div id="differenceQty|'+liRowId+'" ></div>';
			//paDataset[idx][12] = '<div id="moneyQty|'+liRowId+'" ></div>';
			paDataset[idx][13] = '<input type="text" id="decreaseQty|'+liRowId+ '" size="8" '+
                                 'readonly="true" value="'+paDataset[idx][13]+'" '+_class+'>';
			//paDataset[idx][14] = '<div id="faltantQty|'+liRowId+'">'+paDataset[idx][14]+'</div>';
		
			gaInventoryUm[lsInventoryId]      = paDataset[idx][19];
			gaProviderConvFact[lsInventoryId] = paDataset[idx][20];
			gaProviderUm[lsInventoryId]       = paDataset[idx][21];
			gaRecipeConvFact[lsInventoryId]   = paDataset[idx][22];
			gaRecipeUm[lsInventoryId]         = paDataset[idx][23];
			gaUnitCost[lsInventoryId]         = paDataset[idx][24];
			gaMaxVariance[lsInventoryId]  	  = paDataset[idx][25];
			gaMinEfficiency[lsInventoryId] 	  = paDataset[idx][26];
			gaMaxEfficiency[lsInventoryId] 	  = paDataset[idx][27];
            		gaMiscelaneo[lsInventoryId]       = paDataset[idx][28];
			}
			else{
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
				paDataset[idx][10] = 'colspan=02~<input type="text" name="decreaseQty|'+liRowId+'" id="decreaseQty|'+liRowId+ '" value="" '+
									'readonly="true" size="5"'+
									'onFocus="onFocusCustomControl2(this)" '+_class+'>' ;
			}
		}
	}

	function customDatasetAcum(paDataset, fontSize){
    		var _class = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size: "+fontSize+"; background-color: transparent;' ";
		for(var idx=0; idx<paDataset.length; idx++){
        		var liRowId = idx + giNumRows;
			lsInventoryId	  = 'inventoryId|' + liRowId;

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
				paDataset[idx][6] = '<input type="text" id="finalPrvQtyAcumRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][6]+'" '+_class+'>';
				paDataset[idx][7] = '<input type="text" id="finalInvQtyAcum|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][7]+'" '+_class+'>';
				paDataset[idx][8] = '<input type="text" id="finalInvQtyAcumRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][8]+'" '+_class+'>';
				paDataset[idx][9] = '<input type="text" id="finalRecQtyAcum|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][9]+'" '+_class+'>';
				paDataset[idx][10] = '<input type="text" id="finalRecQtyAcumRec|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][10]+'" '+_class+'>';

				paDataset[idx][11] = '<div id="finalInvTotalAcum|'+liRowId+'" ></div>';
				paDataset[idx][12] = '<div id="realUseQtyAcum|'+liRowId+'" ></div>';
				paDataset[idx][13] = '<input type="text" id="decreaseQtyAcum|'+liRowId+ '" size="8" '+
								'readonly="true" value="'+paDataset[idx][13]+'" '+_class+'>';
		
				gaInventoryUm[lsInventoryId]      = paDataset[idx][19];
				gaProviderConvFact[lsInventoryId] = paDataset[idx][20];
				gaProviderUm[lsInventoryId]       = paDataset[idx][21];
				gaRecipeConvFact[lsInventoryId]   = paDataset[idx][22];
				gaRecipeUm[lsInventoryId]         = paDataset[idx][23];
				gaUnitCost[lsInventoryId]         = paDataset[idx][24];
				gaMaxVariance[lsInventoryId]  	  = paDataset[idx][25];
				gaMinEfficiency[lsInventoryId] 	  = paDataset[idx][26];
				gaMaxEfficiency[lsInventoryId] 	  = paDataset[idx][27];
            			gaMiscelaneo[lsInventoryId]       = paDataset[idx][28];
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
