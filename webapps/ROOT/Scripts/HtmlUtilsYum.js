
    var msAgent=navigator.userAgent.toLowerCase();
    var mbIsIE = ((msAgent.indexOf("msie") != -1) && (msAgent.indexOf("opera") == -1));

	//Funcion para agregar campos ocultos a un formulario
	function addHidden(poForm, psName, psValue)
	{
		var el = document.createElement("input");
		    el.type  = "hidden";
		    el.name  = psName;
		    el.id    = psName;
		    el.value = psValue;
		    poForm.appendChild(el);
	}

    function findPosY(obj)
	{
		var curtop = 0;
		if (obj.offsetParent)
		{
			while (obj.offsetParent)
			{
				curtop += obj.offsetTop
				obj = obj.offsetParent;
			}
		}
		else if (obj.y)
				curtop += obj.y;

		return curtop;
	}		
	
	function findPosX(obj)
	{
		var curleft = 0;

		if (obj.offsetParent)
		{
			while (obj.offsetParent)
			{
					curleft += obj.offsetLeft
					obj = obj.offsetParent;
			}
		}
		else if
			(obj.x) curleft += obj.x; 
		
		return curleft;
	}
        
	function centerDivWait(divId)
	{
		var liWidth  = parseInt(document.getElementById(divId).style.width);
		var liHeight = parseInt(document.getElementById(divId).style.height);
		if(isNaN(liHeight)){ liHeight = 200; }

		var liLeft = Math.round((window.innerWidth/2)-(liWidth/2));
		var liTop  = Math.round((window.innerHeight/2)-(liHeight/2));

        document.getElementById(divId).style.left = liLeft + 'px';
        document.getElementById(divId).style.top  = liTop + 'px';
    }
	function showWaitMessage(psControl)
    {
		var lsControl = (psControl != null && psControl != 'undefined')?psControl:'divWaitGSO';
		centerDivWait(lsControl);
		showHideControl(lsControl, 'visible');
	}
	function hideWaitMessage(psControl)
	{
		var lsControl = (psControl != null && psControl != 'undefined')?psControl:'divWaitGSO';
		showHideControl(lsControl, 'hidden');
	}

    function getWindowWidth() {
        var liWindowWidth = (window.innerWidth)?window.innerWidth:document.body.clientWidth;
        return(liWindowWidth);
    }

    function getWindowHeight() {
        var liWindowHeight = (window.innerHeight)?window.innerHeight:document.body.clientHeight;
        return(liWindowHeight);
    }

    function showHideControl(psControl,psStatus) {
        var loControl = document.getElementById(psControl);
        if (loControl) loControl.style.visibility = psStatus;
    }
	function openWindow(psUrl, psName, piWidth, piHeight, psAttr)
	{
		var liLeft = Math.abs(screen.width  - piWidth) / 2;
		var liTop  = Math.abs(screen.height - piHeight) / 2 - 10;
		var lsName = (psName != null && psName != 'undefined')?psName:'auxWindow';
		var lsAttr = (psAttr != null && psAttr != 'undefined')?psAttr:'menubar=no, scrollbars=yes, resizable=yes';

		window.open(psUrl, lsName, 
                    'height='+piHeight+', width='+piWidth+',left='+liLeft+', top='+liTop+','+lsAttr);
	}
