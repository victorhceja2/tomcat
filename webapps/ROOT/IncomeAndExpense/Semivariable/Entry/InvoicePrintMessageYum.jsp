<html>
<head>
    <link rel='stylesheet' type='text/css' href='/CSS/GeneralStandardsYum.css'>
    <script language="javascript">

        function printDetail()
        {
            parent.printer.focus();
            parent.printer.print();

            parent.opener.parent.focus();
            Minimize();

            setTimeout("parent.window.close()",  2000);
        }
    function Minimize()
    {
        parent.resizeTo(250,20);
        parent.moveTo(screen.width, screen.height);
    }
    </script>
</head>
<body>
    <p class="mainsubtitle">
        Impresi&oacute;n de contra recibo ... 
        <br>
    </p>
    <br>
    <p align="center" class="subHeadB">
        Favor de entregar contra recibo al proveedor para anexarlo a la factura o remisi&oacute;n 
        (Requisito para el pago de facturas)
    </p>
    <form>
        <p align="center">
            <br>
            <input type="button" value="Aceptar" onClick="printDetail();">
        </p>
    </form>
</body>
</html>
