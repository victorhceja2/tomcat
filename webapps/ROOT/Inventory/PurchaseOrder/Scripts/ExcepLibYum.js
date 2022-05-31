function doClose(option)
{
	document.mainform.target = 'ifrMainContainer';
	document.mainform.action = "OrderYum.jsp";
	document.mainform.submit();
}

function doClosePreview(psAction){
	document.mainform.target = 'ifrDetail';
	document.mainform.action = psAction+'DetailYum.jsp';
	document.mainform.transfer.value = 1;
	document.mainform.submit();
}

function excepConfirm(){
	var lsResponsible = ignoreSpaces(document.mainform.txtResponsible.value);
	if (lsResponsible.length==0 || lsResponsible==""){
		alert('Para confirmar la excepcion, ingrese su nombre.');
		document.mainform.txtResponsible.focus();
		document.mainform.btnAceptar.disabled = false;
		return(false);
	}
	
	document.mainform.action = 'ExcepConfirmYum.jsp';
	confirm();
}

function confirm(){
	document.mainform.btnAceptar.disabled = true;
	document.mainform.target = '_self';
	document.mainform.submit();
}


function resetFrame(psAction){
	document.mainform.target = 'ifrDetail';
	document.mainform.action = psAction+'DetailYum.jsp';
	document.mainform.transfer.value = 3;
	document.mainform.submit();
}

function imprimir(){
	parent.frames["ifrPrinter"].focus();
	parent.frames["ifrPrinter"].print();
}

function submitFrame(frameName){
	document.mainform.target = frameName;

	if(frameName=='preview')
		document.mainform.hidTarget.value = "Preview";
	if(frameName=='printer')
		document.mainform.hidTarget.value = "Printer";

		document.mainform.submit();
}

function submitFrames(){
	submitFrame('printer');
	setTimeout("submitFrame('preview')", 2000);
}


function ignoreSpaces(string){
	var temp = "";
	string = '' + string;
	splitstring = string.split(" ");
	for(i = 0; i < splitstring.length; i++)
	temp += splitstring[i];
	return temp;
}