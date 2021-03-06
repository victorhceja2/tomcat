/**
 * author: javm date: 2017-04-19
 */
var increment = 0;

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
			var lsRecap = lsElement.substring(11, lsElement.length) == "Rec" ? true
					: false;
			if (lsRecap) {
				validateValues(objUsed, false);
				if (increment == 0) {
					if ((liNumRows - 1) == liRowId) {
						var lsNextElem = lsElement.substring(5, 8) == "Prv" ? "Inv"
								: (lsElement.substring(5, 8) == "Inv" ? "Rec"
										: "Prv");
						lsCurrentElement = 'final' + lsNextElem + 'Qty|1';
					} else {
						lsCurrentElement = '';
						lsCurrentElement = lsElement.substring(0,(lsElement.length - 3)).concat("|", liRowId + 1);
					}
					increment = 1;
				} else {
					lsCurrentElement = lsElement.substring(0, lsElement.length)
							.concat("|", liRowId);
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

function valNumber(poEvent) {

	poEvent = (poEvent) ? poEvent : window.event;

	var charCode = (poEvent.which) ? poEvent.which : poEvent.keyCode;

	if (charCode == 46 || charCode == 37 || charCode == 39 || liKeyCode == 13
			|| liKeyCode == 40) {
		return true;
	}

	if (charCode > 31 && (charCode < 48 || charCode > 57)) {
		return false;
	}
	return true;
}

function updateMissing(objUsed) {
	lsElement = objUsed.id;
	lsRowId = lsElement.substring(lsElement.indexOf("|") + 1);
	lsUseIdeal = "useIdeal|" + lsRowId;
	lsFantan = "faltantQty|" + lsRowId;
	lsBegin = "beginInvQty|" + lsRowId;
	lsRecep = "receptionsQty|" + lsRowId;
	lsITrans = "itransfersQty|" + lsRowId;
	lsOTrans = "otransfersQty|" + lsRowId;
	lsFinal = "finalInvTotal|" + lsRowId;

	lfValUso = parseFloat(document.getElementById(lsUseIdeal).value);
	lfValIni = parseFloat(document.getElementById(lsBegin).innerHTML);
	lfValRec = parseFloat(document.getElementById(lsRecep).innerHTML);
	lfITrans = parseFloat(document.getElementById(lsITrans).innerHTML);
	lfOTrans = parseFloat(document.getElementById(lsOTrans).innerHTML);
	lfValFin = parseFloat(document.getElementById(lsFinal).innerHTML);

	lfExist = lfValIni + lfValRec + lfITrans - lfOTrans;
	lfTotFal = lfExist - lfValFin - lfValUso;

	document.getElementById(lsFantan).innerHTML = Math.round(lfTotFal * 100) / 100;
}

function validateValues(objUsed, focus) {
	var lsBeforeElement;
	var lsElement = objUsed.id;
	liRowElement = parseInt(lsElement.substring(lsElement.indexOf("|") + 1));

	// lfOrigProviderConvF = _getProviderConvFact(lsRowId);
	//
	// if(lfOrigProviderConvF == 0 && lsElement == lsFinalPrvQty){
	//		
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
