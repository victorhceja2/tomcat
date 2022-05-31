/*
##########################################################################################################
# Nombre Archivo  : ReportUtilsYum.js
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : Funciones para el manejo del layout en los reportes
# Fecha Creacion  : 19/Febrero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
*/

    var giNumRows = 0;
    var giBottomMargin = 0;
    var giRowHeight = 24;
    var msAgent=navigator.userAgent.toLowerCase();
    var mbIsMajor = parseInt(navigator.appVersion);
    var mbIsMenor = parseFloat(navigator.appVersion);
    var mbIsNN = (window.innerHeight)?true:false;
    var mbIsIE = ((msAgent.indexOf("msie") != -1) && (msAgent.indexOf("opera") == -1));
    var mbIsIE4 = (!document.getElementById && document.all)?true:false;
    var mbIsIE5 = (mbIsIE && (mbIsMajor == 4) && (msAgent.indexOf("msie 5.0")!=-1) );
    var mbIsIE5_5  = (mbIsIE && (mbIsMajor == 4) && (msAgent.indexOf("msie 5.5") !=-1));

    function printReport() {
	if (confirm('Desea Imprimir este Documento ?'))
            print(document) 
    } 

    function statusClick(poRow, psColorDefault) {
    //TODO: sincronizar cambios
    /*
        lsColorBG = poRow.style.backgroundColor;
        if(lsColorBG != 'tomato'){
            poRow.style.backgroundColor='tomato';
        }else{
            poRow.style.backgroundColor=psColorDefault;
        }
	*/        

        doRowAbcFuntionallity(poRow);
    }

    function doRowAbcFuntionallity(poRow) {
        if (typeof rowAbcFuntionallity == 'function') rowAbcFuntionallity(poRow);
    }

    function getWindowWidth() {
        var liWindowWidth = (window.innerWidth)?window.innerWidth:document.body.clientWidth;
        return(liWindowWidth);
    }

    function getWindowHeight() {
        var liWindowHeight = (window.innerHeight)?window.innerHeight:document.body.clientHeight;
        return(liWindowHeight);
    }

    function adjustTableSize() {
        if (!document.getElementById) return;

        var liWindowHeight = getWindowHeight();
        var liWindowWidth  = getWindowWidth();
        var liRowHeight    = 25;
        var liHeaderYPos   = 0;
		var liExtraHeight  = (giNumRows == 1)?15:22;

        if (document.getElementById('divReport')) {
            if (liWindowHeight - (document.getElementById('divReport').offsetTop + 20) < 10) return;
            document.getElementById('divReport').style.height=liWindowHeight - (document.getElementById('divReport').offsetTop + 20) - giBottomMargin;
            document.getElementById('divReport').style.width=liWindowWidth - 20;
        }

        if (document.getElementById('tbyReport')) {
            liHeaderYPos = getControlYpos('tbyReport') + 30;
            if ((giNumRows*liRowHeight) > liWindowHeight - liHeaderYPos)
			{
                document.getElementById("tbyReport").style.height=liWindowHeight - liHeaderYPos - giBottomMargin;
			}
            else {
                document.getElementById("tbyReport").style.height=(giNumRows*liRowHeight) + liExtraHeight - giBottomMargin;
            }
            document.getElementById('tblMdx').style.width = liWindowWidth - 20;
	
        }
    }

/*
    function adjustLayoutSettings() {
        if (!document.getElementById) return;

        var liWindowHeight = getWindowHeight();
        var liWindowWidth = getWindowWidth();

        if (document.getElementById('divTableData')) {
            document.getElementById('divTableHeaderScroller').style.width=liWindowWidth - document.getElementById('divTableHeaderScroller').offsetLeft - 30;
            document.getElementById('divTableCaptionScroller').style.height=liWindowHeight - (document.getElementById('divTableHeaderScroller').offsetTop + 60) - giBottomMargin;
            document.getElementById('divTableData').style.width = liWindowWidth - document.getElementById('divTableHeaderScroller').offsetLeft - 10;
            document.getElementById('divTableData').style.height = liWindowHeight - (document.getElementById('divTableHeaderScroller').offsetTop + 40) - giBottomMargin;
        }
    }
*/
    
    function getControlXpos(psControl) {
        var loControl = document.getElementById(psControl);
        var liOffset = loControl.offsetLeft;

        while ((loControl = loControl.offsetParent) != null) liOffset += loControl.offsetLeft;
        return(liOffset);
    }

    function getControlYpos(psControl) {
        var loControl = document.getElementById(psControl);
        var liOffset = loControl.offsetTop;

        while ((loControl = loControl.offsetParent) != null) liOffset += loControl.offsetTop;
        return(liOffset);
    }

    function showHideControl(psControl,psStatus) {
        var loControl = document.getElementById(psControl);
        if (loControl) loControl.style.visibility = psStatus;
    }

    function handleTableScroll() {
/*
        document.getElementById('divTableCaption').style.top = -document.getElementById('divTableData').scrollTop;
        document.getElementById('divTableHeader').style.left = -document.getElementById('divTableData').scrollLeft-2;
*/
    }


    function tableHasSelect() {
        objTable = document.getElementById("tblMdx");
        for (j=0;j<ga_fields.length;j++) {
            lsField = ga_fields[j]+'|'+'0';
            objInput = document.getElementById(lsField);
            if (objInput) if (objInput.type=='select-one') return(true); 
        }
        return(false);
    }

    function goTableTop() {
        if (tableHasSelect()) document.getElementById("divReport").scrollTop = 0;
    }

    function executePageDW(psPresentation) {
		giWinControlClose=1; //Variable global para no cerrar la ventana y que siga el flujo normal de la información
    	var lsURL='';

	if (typeof executeReportCustom == 'function') {
		executeReportCustom();
		return;
	}

        lsURL = document.location.href.substr(0,document.location.href.indexOf('?'));
        lsURL = lsURL.substr(lsURL.lastIndexOf('/')+1);
        lsURL = lsURL + document.location.href.substr(document.location.href.indexOf('?'));

        if (lsURL.indexOf('?')>0)
            lsURL = lsURL + '&hidOperation=' + psPresentation;
        else
            lsURL = lsURL + '?hidOperation=' + psPresentation;

        document.location.href = lsURL;
    }

    function openHelpWindowAux(psPage,psPresentation) {
        var lsURL = psPage;
        if (lsURL=='') {alert('No existe ayuda para este contexto'); return;}

        if (lsURL.indexOf('?')>0)
            lsURL = lsURL + '&hidOperation=' + psPresentation;
        else
            lsURL = lsURL + '?hidOperation=' + psPresentation;

        window.open(lsURL,'helpWindow','width=640px, height=480px, menubar=no,scrollbars=yes,resizable=yes');
        top.showHideHelpWS("hidden");
    }

    function adjustHelpContainer() {
        var liWindowWidth =  getWindowWidth();
        var liMBLeftMargin = (mbIsIE)?1:6;
        document.getElementById('divHelpBar').style.width = liWindowWidth - liMBLeftMargin;
        if (document.getElementById('ifrCustomHelp')) document.getElementById('ifrCustomHelp').style.width = liWindowWidth - liMBLeftMargin-10;
    }
