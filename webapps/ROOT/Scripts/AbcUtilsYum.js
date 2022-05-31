/*
##########################################################################################################
# Nombre Archivo  : abc_org_yum.js
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Rutinas genericas para la programación de mantenimientos
# Fecha Creacion  : 10/Enero/2002
# Inc/requires    : cls_abc.php
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
*/

    var Nav4 = ((navigator.appName == "Netscape"));
    var dialogWin = new Object();
    var gs_current_set = '';
    var gs_current_src = null;
    var goLastCtrl = null;
    //De prueba
    var goLastKeyEvent = null;
    var goCurrentCtrl = null;
    var gsOppBefore = null;
    var gsLastRowPos = '';
    var gs_row_height = 24;
    var gs_NN_row_height = gs_row_height + 1;

    var gsOppInsert = 'I';
    var gsOppDelete = 'D';
    var gsOppUpdate = 'U';
    var gsOppSearch = 'S';
    var gsOppBrowse = 'B';
    var gsOppPrint =  'P';
    var giSrcDialogWidth = 500;
    var giSrcDialogHeight = 360;
    var gsRowColor = '#E6E6FA';

    var giNumRows = 0;
    var giNumCols = 0;

    function f_get_window_width() {
        var li_window_width = (window.innerWidth)?window.innerWidth:document.body.clientWidth;
        return(li_window_width);
    }

    function f_get_window_height() {
            var li_window_height = (window.innerHeight)?window.innerHeight:document.body.clientHeight;	
            return(li_window_height);
    }

    function resetPage() {
            enableControls(gaKeys);
            enableControls(new Array('btnInsert'));
            disableControls(new Array('btnUpdate','btnDelete','btnSearch'));
            document.frmMaster.hidOperation.value = '';
    }

    function abcInsert() {
            if (!validateOpp(gsOppInsert)) return;

            if (validateInsert()) {
                    document.frmMaster.hidOperation.value = gsOppInsert;
                    document.frmMaster.submit();
            }
    }

    function abcDelete() {
            if (!validateOpp(gsOppDelete)) return;

            if (validateSearch()) {
                    if (!confirm('Esta seguro de borrar estos datos?')) return;
                    enableControls(gaKeys);
                    document.frmMaster.hidOperation.value = gsOppDelete;
                    document.frmMaster.submit();
            }
    }

    function abcUpdate() {
            if (!validateOpp(gsOppUpdate)) return;

            if (validateInsert()) {
                    enableControls(gaKeys);
                    document.frmMaster.hidOperation.value = gsOppUpdate;
                    document.frmMaster.submit();
            }
    }

    function abcSearch() {
            if (validateSearch()) {
                    enableControls(gaKeys);
                    document.frmMaster.hidOperation.value = gsOppSearch;
                    document.frmMaster.submit();
                    return(true);
            }
            return(false);
    }

    function browseDetail(psAction,psOppAction,psTabId) {
            if (!validateOpp(gsOppUpdate)) return;

            if(validateSearch()) {
                document.frmMaster.hidOperation.value = gsOppBrowse;
                enableControls(gaKeys);
                document.frmMaster.action = psAction;
                document.frmMaster.target = 'ifrDetail';
                document.frmMaster.submit();
                document.frmMaster.action = psOppAction;
                document.frmMaster.target = 'ifrProcess' ;
                disableControls(gaKeys);
                synchTab(psTabId);
            }
    }

    function executeDetail(psAction,psOppAction,psOppBrowse,psTarget) {
            if (!validateOpp(gsOppUpdate)) return;

            if(validateSearch()) {
                document.frmMaster.hidOperation.value = psOppBrowse;
                enableControls(gaKeys);
                document.frmMaster.action = psAction;
                document.frmMaster.target = psTarget;
                document.frmMaster.submit();
                document.frmMaster.action = psOppAction;
                document.frmMaster.target = 'ifrProcess';
                disableControls(gaKeys);
            }
    }

    function f_submit_form() {
        if (!f_validate_grid()) return;

        if (typeof validateGridCustom == 'function')
            if (!validateGridCustom()) return;

        f_enable_grid_controls();
        document.frmGrid.submit();						
    }

    function completeGrid(){
         if (typeof gridCustomSettings == 'function')
            gridCustomSettings();
    }

    function onFocusControl(poControl) {
        focusElement(poControl.id);

        if (typeof onFocusCustomControl == 'function')
            onFocusCustomControl(poControl);
    }

    function onBlurControl(poControl, lbStatus) {
        goLastCtrl = poControl;

        unfocusElement(poControl.id);

        if (typeof onBlurCustomControl == 'function' && lbStatus)
            onBlurCustomControl(poControl);
    }

    function setReturnedValues(lsAllData) {
        if (typeof setReturnedCustomValues == 'function')
            setReturnedCustomValues(lsAllData);
    }

    function f_validate_grid(){
        objTable = document.getElementById("tblMdx");
        for(i=0;i<objTable.rows.length-1; i++){

                ls_field = 'chkRowControl|' + i;
                objInput = document.getElementById(ls_field);
                if (objInput) if (objInput.value == '0' || objInput.value == 'on' || objInput.value=='') continue;

                for (j=0;j<ga_fields.length;j++){
                        ls_field = ga_fields[j]+'|'+i;
                        objInput = document.getElementById(ls_field);
                        if (objInput) if(!f_validate_field(objInput,ga_fields[j],ga_titles[j],ga_valid_mode[j],ga_search_mode[j],ga_range_mode[j])) return(false);
                }
        }
        return(true);
    }

    function f_enable_grid_controls() {
        objTable = document.getElementById("tblMdx");
        for(i=0;i<objTable.rows.length-1; i++){

                ls_field = 'chkRowControl|' + i;
                objInput = document.getElementById(ls_field);
                if (objInput) if (objInput.value == 'on' || objInput.value=='') continue;

                for (j=0;j<ga_fields.length;j++){
                        ls_field = ga_fields[j]+'|'+i;
                        objInput = document.getElementById(ls_field);
                        if (objInput) objInput.disabled = false;
                }
        }
        return;
    }

    function f_validate_field(objInput,ls_field,ls_tittle,ls_valid_option,ls_search_option,ls_range_option) {
        ls_type = ls_valid_option.substr(0,1);
        lb_required = (ls_valid_option.substr(1,2)=='R')?true:false;

        if (objInput.readOnly && ls_search_option=="") return(true);

        if (lb_required)	{
            if (objInput.type == 'select-one') {
                if (objInput.selectedIndex==0) {
                    alert('El campo <' + ls_tittle + '> es requerido');
                    objInput.focus();
                    return(false);
                }
            }
            if (objInput.value == '') {
                alert('El campo <' + ls_tittle + '> es requerido');
                objInput.focus();
                return(false);
            }
        }	

        switch(ls_type) {
            case '9':   if (objInput.value!='') {
                            if (isNaN(Number(objInput.value)) || objInput.value.indexOf(".")!=-1 || objInput.value.indexOf("-")!=-1) {
                                    alert ('El campo <' + ls_tittle + '> debe ser numérico positivo y sin decimales.');
                                    objInput.focus();
                                    return(false);
                            }
                        }
                        break;

            case '.':   if (objInput.value!='' || objInput.value.indexOf("-")!=-1) {
                            if (isNaN(Number(objInput.value))) {
                                alert ('El campo <' + ls_tittle + '> debe ser un numero positivo.');
                                objInput.focus();
                                return(false);	
                            }
                        }
                        break;

            case '-':   if (objInput.value!='') {
                            if (isNaN(Number(objInput.value))) {
                                alert ('El campo <' + ls_tittle + '> debe ser un numérico.');
                                objInput.focus();
                                return(false);	
                            }
                        }
                        break;

            case 'D':   if (objInput.value!='') {
                            var ls_date = objInput.value;
                            var la_date = ls_date.split('/')
                            var li_year = la_date[2];
                            var li_month = la_date[1];
                            var li_day = la_date[0];

                            ls_date = la_date[2]+''+la_date[1]+''+la_date[0];

                            var la_month_days = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
                            if (Number(li_year)%4==0) la_month_days[1]=29;

                            if (isNaN(Number(ls_date)) || ls_date.length<8) {
                                alert ('El campo <' + ls_tittle + '> no tiene un formato correcto.');
                                objInput.focus();
                                return(false);	
                            }

                            if (Number(ls_date)<0) {
                                alert ('El campo <' + ls_tittle + '> no tiene un formato correcto.');
                                objInput.focus();
                                return(false);	
                            }

                            if (Number(li_year)<1900 || Number(li_year)>2100) {
                                alert ('El año del campo <' + ls_tittle + '> no es valido.');
                                objInput.focus();
                                return(false);	
                            }

                            if (Number(li_month)<1 || Number(li_month)>12) {
                                alert ('El mes del campo <' + ls_tittle + '> no es valido.');
                                objInput.focus();
                                return(false);	
                            }

                            if (Number(li_day)<1 || Number(li_day)>la_month_days[Number(li_month)-1]) {
                                alert ('El día del campo <' + ls_tittle + '> no es valido.');
                                objInput.focus();
                                return(false);	
                            }
                        }
                        break;
        }

        if (ls_range_option != '' && objInput.value!='') {
            if (ls_range_option.indexOf(',')==-1) {
                la_intervals = ls_range_option.split(' ');

                la_intervals[0] = Number(la_intervals[0]);
                la_intervals[1] = Number(la_intervals[1]);

                if (objInput.value < la_intervals[0] || objInput.value > la_intervals[1]) {
                    alert ('El campo <' + ls_tittle + '> debe ser un valor entre ' + la_intervals[0] + ' y ' + la_intervals[1] + '.');
                    objInput.focus();
                    return(false);	
                }
            } else {
                //Para el caso de multiples valores separados por <,>
            }	
        }

        return(true);
    }

    function validateOpp(ls_current_op) {
        gsOppBefore = document.frmMaster.hidOperation.value;
        switch (ls_current_op) {
            case 'I': if (gsOppBefore==gsOppSearch) {alert('Imposible insertar un registro consultado'); return(false);}break;
            case 'D': if ((gsOppBefore!=gsOppSearch && gsOppBefore!=gsOppBrowse && gsOppBefore!=gsOppPrint) || gsOppBefore==null) {alert('Debe consultar un registro antes de esta operación');return(false);}break;
            case 'U': if ((gsOppBefore!=gsOppSearch && gsOppBefore!=gsOppBrowse && gsOppBefore!=gsOppPrint) || gsOppBefore==null) {alert('Debe consultar un registro antes de esta operación');return(false);}break;
        }
        return(true);
    }

    function enableControls(la_controls) {
        for (var i = 0; i < document.frmMaster.elements.length; i++){
            var control = document.frmMaster.elements[i];
            for (var j = 0; j < la_controls.length; j++)
                if (control.name.toLowerCase() == la_controls[j].toLowerCase()) control.disabled = false;
        }
    }

    function disableControls(la_controls) {
        for (var i = 0; i < document.frmMaster.elements.length; i++){
            var control = document.frmMaster.elements[i];
            for (var j = 0; j < la_controls.length; j++)
                if (control.name.toLowerCase() == la_controls[j].toLowerCase()) control.disabled = true;
        }
    }

    function setFocusMode(poCurrentCtr, pbED) {
        goCurrentCtrl = poCurrentCtr;
        if (pbED == 1) 
            enableControls(new Array('btnSearch'));
        else
            disableControls(new Array('btnSearch'));
    }

    function fillFields(la_controls,la_data) {
        for (var i = 0; i < document.frmMaster.elements.length; i++) {
            var control = document.frmMaster.elements[i];
            for (var j = 0; j < la_controls.length; j++) {
                if (control.name.toLowerCase() == la_controls[j].toLowerCase()) {
                    if (control.type=='select-one')
                        f_select_item(control,la_data[j]);
                    else
                        control.value = la_data[j];
                }
            }
        }
    }

    function clearFields(la_controls) {
        for (var i = 0; i < document.frmMaster.elements.length; i++){
            var control = document.frmMaster.elements[i];
            for (var j = 0; j < la_controls.length; j++) {
                if (control.name.toLowerCase() == la_controls[j].toLowerCase()) {
                    if (control.type=='select-one')
                        control.selectedIndex = 0;
                    else
                        control.value = '';
                }
            }
        }
    }

    function f_select_item(ctr_list,ls_option) {
        for(var i=0; i<=ctr_list.length-1; i++ ) {
            if (ctr_list.options[i].value==ls_option) {
                ctr_list.selectedIndex = i;
                ctr_list.options[i].selected=true;
                return;
            }
        }
    }

    function openDialog(url, width, height, returnFunc, args) {
        if (!dialogWin.win || (dialogWin.win && dialogWin.win.closed)) {
            dialogWin.returnFunc = returnFunc
            dialogWin.returnedValue = ""
            dialogWin.args = args
            dialogWin.url = url
            dialogWin.width = width
            dialogWin.height = height
            dialogWin.name = (new Date()).getSeconds().toString()
            if (Nav4) {
                dialogWin.left = window.screenX +((window.outerWidth - dialogWin.width) / 2)
                dialogWin.top = window.screenY + ((window.outerHeight - dialogWin.height) / 2)
                var attr = "screenX=" + dialogWin.left + ",screenY=" + dialogWin.top + ",resizable=no,width=" + dialogWin.width + ",height=" + dialogWin.height
            } else {
                dialogWin.left = (screen.width - dialogWin.width) / 2
                dialogWin.top = (screen.height - dialogWin.height) / 2
                var attr = "left=" + dialogWin.left + ",top=" + dialogWin.top + ",resizable=no,width=" + dialogWin.width + ",height=" + dialogWin.height
            }
            dialogWin.win=window.open(dialogWin.url, dialogWin.name, attr)
            dialogWin.win.focus()
        } 
        else {
            dialogWin.win.focus()
        }
    }

    function blockEvents() {
        if (Nav4) {
            window.captureEvents(Event.CLICK | Event.MOUSEDOWN | Event.MOUSEUP | Event.FOCUS)
            window.onclick = deadend
        } else {
            disableForms()
        }
        window.onfocus = checkModal
    }

    function unblockEvents() {
        if (Nav4) {
            window.releaseEvents(Event.CLICK | Event.MOUSEDOWN | Event.MOUSEUP | Event.FOCUS)
            window.onclick = null
            window.onfocus = null
            window.focus()
        } else {
            enableForms()
        }
    }

    function deadend() {
        if (dialogWin.win && !dialogWin.win.closed) {
            dialogWin.win.focus()
            return false
        }
    }

    function checkModal() {
        if (dialogWin.win && !dialogWin.win.closed) {
            dialogWin.win.focus()	
        }
    }

    function disableForms() {
        IELinkClicks = new Array()
        for (var h = 0; h < frames.length; h++) {
            for (var i = 0; i < frames[h].document.forms.length; i++) {
                for (var j = 0; j < frames[h].document.forms[i].elements.length; j++) {
                    frames[h].document.forms[i].elements[j].disabled = true
                }
            }
            IELinkClicks[h] = new Array()
            for (i = 0; i < frames[h].document.links.length; i++) {
                IELinkClicks[h][i] = frames[h].document.links[i].onclick
                frames[h].document.links[i].onclick = deadend
            }
        }
    }

    function enableForms() {
        for (var h = 0; h < frames.length; h++) {
            for (var i = 0; i < frames[h].document.forms.length; i++) {
                for (var j = 0; j < frames[h].document.forms[i].elements.length; j++) {
                    frames[h].document.forms[i].elements[j].disabled = false
                }
            }
            for (i = 0; i < frames[h].document.links.length; i++) {
                frames[h].document.links[i].onclick = IELinkClicks[h][i]
            }
        }
    }

    function returnData(psData) {
        top.opener.dialogWin.returnedValue = psData;
        closeModalWindow();
    }

    function closeModalWindow() {
        top.handleOK();
        top.window.close();
    }

    function f_getSelRow(objSel,lb_flag){
/*
        if (!lb_flag) {
            objSel.value = 'on';
            objSel.checked = false;
            return;
        }

        if(objSel.value != '0'){
            if(confirm('Desea Borrar este registro?')){
                objSel.value = '0' ;
                objSel.checked = true ;
            }else{
                objSel.value = 'on' ;
                objSel.checked = false ;
            }
        }else{
            objSel.value = 'on' ;
            objSel.checked = false ;
        }	
*/
    }

    function buscaItem(li_numItem){
        objTable = document.getElementById("tblMdx") ;
        for(i=0; i<document.frmGrid.elements.length-3; i++){
                document.frmGrid.elements[i].value = objTable.rows[li_numItem].cells[i+1].innerHTML ;
        }
    }

    function focusElement(psElementId){
        if(typeof customFocusElement == 'function')
            customFocusElement(psElementId);
        else    
        {
            loContainer = document.getElementById(psElementId).parentNode;
            loContainer.style.margin  = "0px";
            loContainer.style.padding = "0px";
            loContainer.style.border  = "solid #FF0000 2px";
       
	        document.getElementById(psElementId).focus();
        }
    }


    function unfocusElement(psElementId){
        if (typeof customUnfocusElement == 'function')
            customUnfocusElement(psElementId);
        else    
        { 
            loContainer = document.getElementById(psElementId).parentNode;
            loContainer.style.border = "solid 0px";
        }    
    }

    function getKeyCode(poEvent) {
        if (Nav4)
            return poEvent.which;
        else
            return poEvent.keyCode;
    }

    function getNumRows() {
        return(giNumRows);
    }

    function handleKeyEvents(poEvent, objUsed) {

    	goLastKeyEvent = poEvent;//EZ: 15Ago 05

        lsElement = objUsed.id;
        liRowId   = parseInt(lsElement.substring(lsElement.indexOf("|")+1));
        lsElement = lsElement.substr(0, lsElement.indexOf("|"));

        liKeyCode = getKeyCode(poEvent);
        liNumRows = getNumRows();
               
        if(liKeyCode == 13 || liKeyCode == 40){//<enter> o flecha hacia abajo
            if(liNumRows > 1){ //Si hay mas de dos filas
               if(liRowId < (liNumRows - 1)){
                    lsCurrentElement    = lsElement.concat("|",liRowId+1);
                    lsPreviousElement   = lsElement.concat("|",liRowId);

                    //El elemento seleccionado
                    goCurrentCtrl = document.getElementById(lsCurrentElement);
                    //El elemento anterior seleccionado
                    goLastCtrl = document.getElementById(lsPreviousElement);

                    focusElement(lsCurrentElement);
               }else{
                    lsLastElement = lsElement.concat("|",liRowId);
                    document.getElementById(lsLastElement).blur();
                    //El elemento seleccionado
                    goCurrentCtrl = goLastCtrl = document.getElementById(lsLastElement);
                    setTimeout("document.getElementById(lsLastElement).focus()", 10);
               }     
            }
        }
        if(liKeyCode == 38){ //Fecha hacia arriba
            if(liNumRows > 1){ //Si hay mas de dos filas
                if(liRowId > 0){
                    lsCurrentElement  = lsElement.concat("|", liRowId-1);
                    lsPreviousElement = lsElement.concat("|", liRowId);

                    goCurrentCtrl = document.getElementById(lsCurrentElement);
                    goLastCtrl = document.getElementById(lsPreviousElement);

                    focusElement(lsCurrentElement);
                }
            }
        }
        return(liKeyCode)
    }
    
    function handleOnChangeEvent(objUsed) {
        lsElementId = objUsed.id;
        unfocusElement(lsElementId);
    }

    function f_changeStatusOp(poEvent,objUsed,objControl){
        var liKeyCode;
        if(poEvent.type == 'keydown')
            liKeyCode = handleKeyEvents(poEvent, objUsed);

        if(poEvent.type == 'change') {
            handleOnChangeEvent(objUsed);
        }

        if (liKeyCode>40 || liKeyCode==32 || poEvent.type == 'change' || poEvent.type == 'checkbox') {
		objControl.checked = true;
            if (objControl.value!='2') objControl.value = '1';
            objName = new Object(objUsed);
        }

        if (typeof addFormFunctionality == 'function')                                                                                        addFormFunctionality(objUsed);
    }

    function setNumRows(piRows){
        giNumRows = piRows;
    }

    function onInsertAction(pbCustomFlag) {
        if (pbCustomFlag==true) {
            if (typeof onInsertCustomAction == 'function') {
                onInsertCustomAction();
            }
        } else {
            f_addRow();
            if (typeof onAfterInsertCustomAction == 'function') {
                onAfterInsertCustomAction();
            }
        }
    }

    function f_addRow(lb_focus_flag){
        var ls_first_field = '';
        lb_focus_flag = (typeof lb_focus_flag == 'undefined')?true:lb_focus_flag;

        if(navigator.appName != "Netscape") {
            objTable = document.getElementById("tblMdx");
            var intNoOfRows = objTable.rows.length;
            var loNewRow = objTable.insertRow();
            loNewRow.style.backgroundColor = gsRowColor;
            loNewRow.align = "center";
            loNewRow.id = "tblRow|" + giNumRows;
            //loNewRow.onclick = new Function("statusClick(this,'" + gsRowColor + "')");

            f_addRowIE(intNoOfRows, objTable, "checkbox" , "chkRowControl|" + giNumRows, "2", " checked ") ;
            for(i=0; i<=ga_fields.length-1 ; i++){
                ls_nomField = ga_fields[i] + "|" + giNumRows
                if (!ga_insert_mode[i] && ga_search_mode[i]==""){
                    ls_valor = 'N/E'
                }else{
                    ls_valor = "";
                    if (ls_first_field == '')
                        ls_first_field = ls_nomField;
                }
                f_addRowIE(intNoOfRows, objTable, ga_type_mode[i] , ls_nomField , ls_valor,"",ga_insert_mode[i],ga_search_mode[i],ga_size[i],ga_source_data[i],ga_blur_mode[i],ga_focus_mode[i],ga_src_dialog_width[i],ga_src_dialog_height[i],ga_color_mode[i]);
            }		
            giNumRows++;
        }
        else{
            var tbody = document.getElementById("tblMdx").getElementsByTagName("TBODY")[0];
            var row = document.createElement("TR")	
            row.className = "tdBgColor";
            row.style.backgroundColor = gsRowColor;
            row.align = "center";
            row.id = "tblRow|" + giNumRows;
            //row.setAttribute("onClick","onClick=statusClick(this,'" + gsRowColor + "')");

            f_insertTD('frmGrid', row, f_creaObjeto('checkbox','chkRowControl|'+giNumRows, '2'),gsRowColor);
            for(i=0; i<=ga_fields.length-1 ; i++){
                ls_nomField = ga_fields[i] + "|" + giNumRows
                if (!ga_insert_mode[i] && ga_search_mode[i]==""){
                    ls_valor = 'N/E';
                }else{
                    ls_valor = "";
                    if (ls_first_field == '')
                        ls_first_field = ls_nomField;
                }
                f_insertTD('frmGrid', row, f_creaObjeto(ga_type_mode[i],ls_nomField, ls_valor,ga_insert_mode[i],ga_search_mode[i],ga_size[i],ga_source_data[i],ga_blur_mode[i],ga_focus_mode[i],ga_src_dialog_width[i],ga_src_dialog_height[i],ga_color_mode[i]),ga_color_mode[i]); 
            }    	
            tbody.appendChild(row);
            for(i=0; i<=ga_fields.length-1 ; i++) if (ga_source_data[i]) f_fill_cbo_array(ga_fields[i] + "|" + giNumRows,ga_source_data[i]);
            giNumRows++;
            parent.adjustContainer();
        }
        objCur = document.getElementById(ls_first_field);
        if (objCur && lb_focus_flag) {objCur.focus(); }
    }

    function f_addRowIE(intNoOfRows, objTable, tipo, nombre, valor, extras,lb_insert_mode,ls_search_mode,ls_size,la_source,lb_blur_mode,lb_focus_mode,li_src_dialog_width,li_src_dialog_height,ls_color_mode){
        var ls_tagText = '';
        var ls_color_mode = (ls_color_mode=='' || typeof ls_color_mode == 'undefined')?gsRowColor:ls_color_mode;
        var ls_class_name = (valor=='N/E' || (!lb_insert_mode && ls_search_mode==""))?"ctrlDisabled":"descriptionTabla";

        objTable.rows(intNoOfRows).insertCell();

        if (!lb_insert_mode && tipo != "checkbox") extras += " READONLY";
        if (nombre.substring(0,nombre.length-2) == 'chkRowControl') {
            extras += " onClick = \"f_change_status(this);\" ";
        } else {
            li_size = Number(ls_size) + 1;
            li_maxlength = ls_size;
            extras += ' size = \"' + li_size + '\" maxlength = \"' + li_maxlength + '\"'
            extras += " onfocus = \"f_handle_search('" + ls_search_mode + "'," + lb_focus_mode + ",this," + li_src_dialog_width + "," + li_src_dialog_height + ");\" ";
        }

        extras += " onBlur = \"onBlurControl(this," + lb_blur_mode + ");\" ";
        if (lb_insert_mode) {
            alSuggested = nombre.split("|");
            liRowId = alSuggested[1];
            extras += " onKeyDown = \"f_changeStatusOp(event, this, document.getElementById(\'chkRowControl|" + liRowId + "\')); \" ";
        }

        if (la_source)
            ls_tagText = "<select id=\"" + nombre + "\" name=\"" + nombre + "\" class = \"descriptionTabla\" style = \"border: solid rgb(0,0,0) 0px; background-color: " + ls_color_mode + ";\"></select>" 
        else
            ls_tagText = "<input type=" + tipo + " id=\"" + nombre + "\" name=\"" + nombre + "\" value=\"" + valor + "\" " + extras + " class = \"" + ls_class_name + "\" style = \"border: solid rgb(0,0,0) 0px; background-color: " + ls_color_mode + ";\" >";	

        objTable.rows(intNoOfRows).cells(objTable.rows(intNoOfRows).cells.length-1).style.background = ls_color_mode;
        objTable.rows(intNoOfRows).cells(objTable.rows(intNoOfRows).cells.length-1).innerHTML = ls_tagText;
        if (la_source) f_fill_cbo_array(nombre,la_source)
    }

    function f_creaObjeto(ls_tipoInput, ls_nombre , ls_value,lb_insert_mode,ls_search_mode,ls_size,la_source,lb_blur_mode,lb_focus_mode,li_src_dialog_width,li_src_dialog_height,ls_color_mode) {
        var ls_color_mode = (ls_color_mode=='' || typeof ls_color_mode == 'undefined')?gsRowColor:ls_color_mode;
        var ls_class_name = (ls_value=='N/E' || (!lb_insert_mode && ls_search_mode==""))?"ctrlDisabled":"descriptionTabla";

        if (la_source) {
            var elementObj = document.createElement('select');
            elementObj.setAttribute('type', 'select-one');
            elementObj.setAttribute('name', ls_nombre);
            elementObj.setAttribute('id', ls_nombre );
            elementObj.setAttribute('class', ls_class_name);
            elementObj.setAttribute('size','1');
        }
        else {
            var elementObj = document.createElement('input');
            elementObj.setAttribute('type', ls_tipoInput);
            elementObj.setAttribute('name', ls_nombre);
            elementObj.setAttribute('id', ls_nombre );
            elementObj.setAttribute('value', ls_value);	
            elementObj.setAttribute('class', ls_class_name);
            elementObj.setAttribute('onfocus', 'f_handle_search(\'' + ls_search_mode + '\',' + lb_focus_mode + ',this,' + li_src_dialog_width + ',' + li_src_dialog_height + ')');

            if (!lb_insert_mode){
                elementObj.setAttribute('readOnly', 'true');
            } else {
                alSuggested = ls_nombre.split("|");
                liRowId = alSuggested[1];
                elementObj.setAttribute('onKeyDown', 'f_changeStatusOp(event, this, document.getElementById(\'chkRowControl|'+ liRowId +'\') )');
            }

            if(ls_tipoInput == 'checkbox'){
                elementObj.setAttribute('checked', '');	
                elementObj.setAttribute('onClick', 'f_change_status(this)');	
            }
            else {
                elementObj.setAttribute('size',Number(ls_size) + 1);
                elementObj.setAttribute('maxlength',ls_size);
            }

            elementObj.setAttribute('onBlur', 'onBlurControl(this,' + lb_blur_mode + ')');	
            elementObj.setAttribute('style','border: solid rgb(0,0,0) 0px; background-color: ' + ls_color_mode + ';')

            elementObj.setAttribute('autocomplete','off');
        }
        return(elementObj);
    }  

    function f_handle_search(ls_attrib,lb_focus_mode,objSel,li_width, li_height) {
        goCurrentCtrl = objSel;
        if (lb_focus_mode==true) onFocusControl(objSel);

        if (document.getElementById('chkRowControl|'+objSel.name.split('|')[1]).value != '2' && (ga_operations[2] == '' || ga_operations[2]==false)) {
            if (document.frmGrid.cmd_search) document.frmGrid.cmd_search.disabled = true;
            return;
        }

        if (ls_attrib != 'undefined' && ls_attrib != '') {
            gs_current_set = ls_attrib
            gs_current_src = objSel;					
            if (document.frmGrid.cmd_search) document.frmGrid.cmd_search.disabled = false;
            f_show_catalog(li_width,li_height);
        }
        else {
            gs_current_set = ''
            gs_current_src = null;
            if (document.frmGrid.cmd_search) document.frmGrid.cmd_search.disabled = true;
        }
    }

    function f_show_catalog(li_width,li_height) {
        if (typeof li_width == 'undefined') li_width = giSrcDialogWidth;
        if (typeof li_height == 'undefined') li_height = giSrcDialogHeight;

        switch(gs_current_set) {
            case 'D':   showCalendar('frmGrid',gs_current_src.name,'cmd_search');
                        //showCalendar('frmGrid',gs_current_src.name,gs_current_src.name);
                        f_changeStatusOp(event,this,document.getElementById('chkRowControl|'+gs_current_src.name.split('|')[1]))
                        break;

            default:    document.getElementById('chkRowControl|0').focus();
                        openDialog(gs_current_set.split('|')[0],li_width,li_height,setReturnedData);
                        break;
        }
    }

    function setReturnedData() {
        var ls_value = dialogWin.returnedValue;
        la_src_data = (gs_current_set)?gs_current_set.split('|'):new Array(1);

        if (la_src_data.length == 1) {
            setReturnedValues(ls_value)
        } else {
            la_all_data = ls_value.split('|')
            gs_current_src.value = la_all_data[0];
            for(li=0;li<la_src_data.length-1;li++) {
                document.getElementById(la_src_data[li+1] + '|' + gs_current_src.name.split('|')[1]).value = la_all_data[li]
            }
        }
        if (gs_current_src) f_changeStatusOp(event,this,document.getElementById('chkRowControl|'+gs_current_src.name.split('|')[1]))
    }

    function f_change_status(objSel) {
        if (objSel.value == '2') {
            objSel.value = '';
            objSel.checked = false;
            return;
        }

        if (objSel.value == '') {
            objSel.value = '2';
            objSel.checked = true;
        }
    }

    function f_insertTD(ls_nameForm, objRow, objIns, ls_color_mode){
        document.getElementById(ls_nameForm).appendChild(objIns);
        var td1 = document.createElement("TD")
        td1.style.background = ls_color_mode;
        objRow.appendChild(td1);
        td1.appendChild(objIns);
    }

    function synchTab(ls_tab_name) { 
        var elList,i; 
        elList = document.getElementsByTagName("A"); 
        for (i = 0; i < elList.length; i++) 
            if (elList[i].id == ls_tab_name) { 
                elList[i].className += " activeTab";
                elList[i].blur(); 
            } 
            else 
                elList[i].className = "tab";
    } 

    function f_removeName(el, name) { 
        var i, curList, newList; 
        if (el.className == null) return; 
        newList = new Array(); 
        curList = el.className.split(" "); 
        for (i = 0; i < curList.length; i++) 
            if (curList[i] != name) newList[i]=curList[i];
        el.className = newList.join(" ");
    } 

    function adjustContainer(li_header_width,li_header_height){
        var li_window_height = f_get_window_height();
        var li_window_width = f_get_window_width();

        var li_height = li_window_height - li_header_height;
        var li_width = li_window_width - li_header_width;

        if (li_height < 150) li_height = 150;
        if (li_width < 150) li_width = 150;

        document.getElementById('ifrDetail').style.height=li_height;
        document.getElementById('ifrDetail').style.width=li_width;
    }

    function onClickFunctionality(){
        if (typeof addFormFunctionality == 'function')
            addFormFunctionality();
        return;
    }

    function f_fill_cbo_array(ls_ctrl,la_source) {
        cbo_data = document.getElementById(ls_ctrl);
        for (var i=0;i<la_source.length;i++) {
            cbo_data.options[i]=new Option(la_source[i][1],la_source[i][0]);
        }
    }

    function f_hide_main_frame() {
        top.document.body.cols = "0,*";
    }

    function getDateValue(lsDate) {
        return((lsDate.substring(6,10) + lsDate.substring(3,5) + lsDate.substring(0,2))*1);
    }

    function getDateYear(lsDate) {
        return(lsDate.substring(6,10)*1);
    }

    function rowAbcFuntionallity(poRow) {
        if (typeof ga_fields == 'undefined') return;

        var lsRowPos = poRow.id.substring(poRow.id.indexOf('|'));
        var loControl = null;
        var lbFlag = false;

        goCurrentCtrl = (goCurrentCtrl!=null)?document.getElementById(goCurrentCtrl.id.substring(0,goCurrentCtrl.id.indexOf('|')) + lsRowPos):goCurrentCtrl;
        lbFlag = (goCurrentCtrl!=null)?ga_edit_mode[getFieldPos(goCurrentCtrl.id.substring(0,goCurrentCtrl.id.indexOf('|')))]:false;

        if (lbFlag) {
            if (goCurrentCtrl)
                if (goCurrentCtrl.type != 'select-one') goCurrentCtrl.focus();
        } else {
            for (li = 0; li < ga_fields.length; li++) {
                if (ga_edit_mode[li]) {
                    loControl = document.getElementById(ga_fields[li] + lsRowPos)
                    if (loControl && goCurrentCtrl) 
                        if (goCurrentCtrl.type != 'select-one') loControl.focus();
                    break;
                } 
            }
        }

        goCurrentCtrl = null;
    }

    function getFieldPos(psFieldId) {
        for (li=0; li < ga_fields.length; li++) {
            if (psFieldId == ga_fields[li])
            return(li);
        }
        return(-1);
    }
	function splitWindow(doSplit)
	{
		if(doSplit == true)
            if(top.msShowHide=='hidden')
            {
			    top.showOptionsBar();
                top.adjustMainContainer();
            }    
	}
