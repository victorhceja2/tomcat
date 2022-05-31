
	function turnOnGraphicAlarm(psElementId, psQuantity)
	{
		var loElement = document.getElementById(psElementId);
		loElement.innerHTML = '<input type="button" value="'+psQuantity+'" style="border: 1px; width: 100%; background-color: #e3e3e3; color: #000000; font-size: 8px; font-family: Arial, Helvetica, Verdana" size="10">';
		
		//document.getElementById(psElementId).innerHTML = '<img src="/ShowQuantity?quantity='+psQuantity+'">';
	}
