        
        function doClose(option)
        {
            document.mainform.target = 'ifrMainContainer';
            document.mainform.action = 'javascript: validOption("'+option+'")';
            document.mainform.submit();
        }

        function doClosePreview(psAction)
        {
            document.mainform.target = 'ifrDetail';
            document.mainform.action = psAction+'DetailYum.jsp';
            document.mainform.transfer.value = 1;
            document.mainform.submit();
        }

        function otransferConfirm()
        {
            document.mainform.action = 'OTransferConfirmYum.jsp';
            confirm();
        }
        function itransferConfirm()
        {
            document.mainform.action = 'ITransferConfirmYum.jsp';
            confirm();
        }

        function confirm()
        {
            document.mainform.btnAceptar.disabled = true;
            document.mainform.target = '_self';
            document.mainform.submit();
        }

        //reset en transfer detail
        function resetFrame(psAction)
        {
            document.mainform.target = 'ifrDetail';
            document.mainform.action = psAction+'DetailYum.jsp';
            document.mainform.transfer.value = 3;
            document.mainform.submit();
        }

            function imprimir()
            {
                parent.frames["ifrPrinter"].focus();
                parent.frames["ifrPrinter"].print();
            }

            function submitFrame(frameName)
			{
                document.mainform.target = frameName;

				if(frameName=='preview')
                	document.mainform.hidTarget.value = "Preview";

				if(frameName=='printer')
                	document.mainform.hidTarget.value = "Printer";

                document.mainform.submit();
			}
			function submitFrames()
			{
				submitFrame('printer');
				setTimeout("submitFrame('preview')", 2000);
			}

