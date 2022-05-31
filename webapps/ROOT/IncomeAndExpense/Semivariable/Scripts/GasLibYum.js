 function isNumberKey(evt)
      {
         var charCode = (evt.which) ? evt.which : event.keyCode
			 if (charCode > 31 && (charCode < 48 || charCode > 57))
				return false;
	       return true;
      }

	  	/* Devuelve el valor de porcentaje inicial de gas*/
		function _getBeginPer()
		{
			lsBeginPer = 'beginPer';
			lsBeginPer = document.getElementById(lsBeginPer).value;
			lsBeginPer = isEmpty(lsBeginPer)?'0':lsBeginPer;

			lfBeginPer = parseFloat(trim(lsBeginPer));

			return lfBeginPer;
		}
		function _getBeginLit()
		{
			lsBeginLit = 'beginLit';
			lsBeginLit = document.getElementById(lsBeginLit).value;
			lsBeginLit = isEmpty(lsBeginLit)?'0':lsBeginLit;

			lfBeginLit = parseFloat(trim(lsBeginLit));

			return lfBeginLit;
		}
		function _getRequiredPer()
		{
			lsRequiredPer = 'requiredPer';
			lsRequiredPer = document.getElementById(lsRequiredPer).value;
			lsRequiredPer = isEmpty(lsRequiredPer)?'0':lsRequiredPer;

			lfRequiredPer = parseFloat(trim(lsRequiredPer));

			return lfRequiredPer;
		}
		function _getRequiredLit()
		{
			lsRequiredLit = 'requiredLit';
			lsRequiredLit = document.getElementById(lsRequiredLit).value;
			lsRequiredLit = isEmpty(lsRequiredLit)?'0':lsRequiredLit;

			lfRequiredLit = parseFloat(trim(lsRequiredLit));

			return lfRequiredLit;
		}
		function _getFinalPer()
		{
			lsFinalPer = 'finalPer';
			lsFinalPer = document.getElementById(lsFinalPer).value;
			lsFinalPer = isEmpty(lsFinalPer)?'0':lsFinalPer;

			lfFinalPer = parseFloat(trim(lsFinalPer));

			return lfFinalPer;
		}
		function _getDifferencePer()
		{
			lsDifferencePer = 'differencePer';
			lsDifferencePer = document.getElementById(lsDifferencePer).value;
			lsDifferencePer = isEmpty(lsDifferencePer)?'0':lsDifferencePer;

			lfDifferencePer = parseFloat(trim(lsDifferencePer));

			return lfDifferencePer;
		}
		function _getToLoadPer()
		{
			lsToLoadPer = 'toloadPer';
			lsToLoadPer = document.getElementById(lsToLoadPer).value;
			lsToLoadPer = isEmpty(lsToLoadPer)?'0':lsToLoadPer;

			lfToLoadPer = parseFloat(trim(lsToLoadPer));

			return lfToLoadPer;
		}
		function _getloadedLitersNote()
		{
			lsloadedLitersNote = 'loadedLitersbySupp';
			lsloadedLitersNote = document.getElementById(lsloadedLitersNote).value;
			lsloadedLitersNote = isEmpty(lsloadedLitersNote)?'0':lsloadedLitersNote;

			lfloadedLitersNote = parseFloat(trim(lsloadedLitersNote));

			return lfloadedLitersNote;
		}
