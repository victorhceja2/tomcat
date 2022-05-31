        
        var gaSelected  = simpleArray(laDataset.length, false);
        var gaFrecuency = simpleArray(laDataset.length, 0);
        var gaFrecuencyOri = simpleArray(laDataset.length, 0);

        function initDataGrid(psMax,psMaxcrit)
        {
            liCountSelected     = 0;
            loGrid.bHeaderFix   = true;
            loGrid.isReport     = true;
            loGrid.height       = 450;
            alert("M\u00E1ximo de cr\u00EDticos es: "+psMax+" y el disponible en este momento:"+psMaxcrit);
            if(laDataset.length > 0)
            {
                for(var idx=0; idx<laDataset.length; idx++)
                {
                    laDataset[idx][0] = '<input type=checkbox name=chk|'+idx+' id=chk|'+idx+' value='+ laDataset[idx][0] ;

                    //frecuency_id = 1 , diario obligatorio
                    //if(laDataset[idx][3] == 1 || laDataset[idx][3] == 5) 
                    if(laDataset[idx][3] == 1) 
                    {
                        laDataset[idx][0] += ' checked ';
                        gaSelected[idx] = true;
                        giNumItems ++;
                    }    
                    laDataset[idx][0] += ' onClick=selectUnselectItem('+idx+','+psMaxcrit+')>';

                    gaFrecuency[idx] = laDataset[idx][3];
                    gaFrecuencyOri[idx] = laDataset[idx][4];
                }

                headers  = new Array(
                // 0:  Codigo de inventario
                         {text:'&nbsp;',width:'10%'},
                // 1:  Codigo de inventario
                         {text:'C&oacute;digo de inventario',width:'20%'},
                // 2:  Proveedor                         
                         {text:'Descripci&oacute;n del producto', width:'70%', hclass:'right', bclass:'right'});
                // 3: frecuency id

                props    = new Array(null, null, null, {hide: true}, {hide: true});

                loGrid.setHeaders(headers);
                loGrid.setDataProps(props);
                loGrid.setData(laDataset);        
                loGrid.drawInto('goDataGrid');

                selectCurrentCritics();
            }
        }
        

    function selectUnselectItem(piRowId,piLeftItems)
    {
        var loCheckBox = document.getElementById('chk|'+piRowId);
        liCountSelected++;
        liMaxLeft = piLeftItems - liCountSelected;
        // Si quiere pasar los limites de los que puede agregar
        if(liMaxLeft < 0 && (!gaSelected[piRowId])){
            alert("Ya no puede seleccionar mas productos.");
            gaSelected[piRowId] = false;
            return false;
        }
//alert("seleccionados["+liCountSelected+"]");
//alert("frecuency["+gaFrecuency[piRowId]+"]  frecuencyOri["+gaFrecuencyOri[piRowId]+"]");
        if(gaFrecuency[piRowId] == 1 && gaFrecuencyOri[piRowId] == 0)
        {
            alert('Este producto no se puede quitar de cr\u00EDticos ya que es cr\u00EDtico obligatorio');
            loCheckBox.checked = true;
        }
        else
        {
            if(gaSelected[piRowId]) //Quita de seleccionados
            {
                gaSelected[piRowId] = false;
                unselectRow(piRowId);
                giNumItems--;

                gaOldItems[gaOldItems.length] = new String(loCheckBox.value);
                for(var i=0; i < gaNewItems.length; i++)
                {
                    if(gaNewItems[i] == loCheckBox.value)
                    {
                        gaNewItems[i] = -1;
                        break;
                    }
                }
            }
            else //Agrega a seleccionados
            {
                if(piLeftItems > 0)
                {
                    gaSelected[piRowId] = true;
                    selectRow(piRowId);
                    giNumItems++;
                    gaNewItems[gaNewItems.length] = new String(loCheckBox.value);
                    for(var i=0; i < gaOldItems.length; i++)
                    {
                        if(gaOldItems[i] == loCheckBox.value)
                        {
                            gaOldItems[i] = -1;
                            break;
                        }
                    }
                    document.frmCritics.hidHasChanges.value = true;
                }
                else
                {
                    alert("Ya no puede agregar m\u00E1s productos cr\u00EDticos a menos que quite alguno.");
                }
            }
        }
    }

    function selectCurrentCritics()
    {
        for(rowId=0; rowId<gaSelected.length; rowId++)
        {
            if(gaSelected[rowId])
                selectRow(rowId);
        }            
    }

    function selectRow(piRowId)
    {
        var lsElementId = 'chk|'+piRowId;
        var loElement   = document.getElementById(lsElementId).parentNode.parentNode;
        var lsClassName = loElement.className;

        loElement.className = lsClassName + ' alarm';
    }

    function unselectRow(piRowId)
    {
        var lsElementId = 'chk|'+piRowId;
        var loElement   = document.getElementById(lsElementId).parentNode.parentNode;
        var lsClassName = loElement.className;

        lsClassName=lsClassName.replace(/ alarm/gi, "");

        loElement.className = lsClassName;
    }

    function cancel()
    {
        window.close();
    }
    
    function saveChanges()
    {
        var laDataset  = new Array();
        var lsInvItems = new String();

        for(var li=0; li<laSelected.length; li++)
            if(laSelected[li]) 
            {
                 var lsInvId = gaDataset[li][0];

                 //El inv_id no ha sido ya considerado
                 if(lsInvItems.search(lsInvId) == -1)
                 {
                     laDataset.push( gaDataset[li] );
                     lsInvItems = lsInvItems.concat(lsInvId).concat(' ');
                 }
            }
           
         if(laDataset.length > 0)
             window.opener.addProducts(laDataset);
         close();
    }
