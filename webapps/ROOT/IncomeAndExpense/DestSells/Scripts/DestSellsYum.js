
    function initDataGrid()
    {
        var _class  = " class='descriptionTabla' style='border: solid rgb(0,0,0) 0px; font-size:11px;  background-color: transparent;' ";

        loGrid1.bHeaderFix = false;
        loGrid1.width      = '900';
        loGrid1.padding    = 9;

        loGrid2.bHeaderFix = false;
        loGrid2.width      = '900';
        loGrid2.padding    = 9;

        loGrid3.bHeaderFix = false;
        loGrid3.width      = '900';
        loGrid3.padding    = 9;

        loGrid4.bHeaderFix = false;
        loGrid4.width      = '900';
        loGrid4.padding    = 9;

        loGrid5.bHeaderFix = false;
        loGrid5.width      = '900';
        loGrid5.padding    = 9;

        if(AllDestsDataset.length > 0)
        {

            mheaders = new Array(
                  {text:'Todos los destinos', align:'center',hclass:'right'});

            headers  = new Array(
            // 0:  
                     {text:'',width:'15%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Martes
                     {text:'Martes',width:'17%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'17%', align: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'17%', align: 'right'},
            // 4:  Viernes
                     {text:'Viernes', width:'17%', align: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado', width:'17%', align: 'right'},
            // 6:  Domingo
                     {text:'Domingo', width:'17%', align: 'right'},
            // 7:  Lunes
                     {text:'Lunes', width:'17%', align: 'right'});


            props    = new Array(null,null,null,null,null,null,null,null);
            
            loGrid1.setMainHeaders(mheaders);
            loGrid1.setHeaders(headers);
            loGrid1.setDataProps(props);
            loGrid1.setData(AllDestsDataset);        
            loGrid1.drawInto('AllDestsDataGrid');
        }

        if(DineinDataset.length > 0)
        {

            mheaders = new Array(
                  {text:'Dine In', align:'center',hclass:'right'});

            headers  = new Array(
            // 0:  
                     {text:'',width:'15%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Martes
                     {text:'Martes',width:'17%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'17%', align: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'17%', align: 'right'},
            // 4:  Viernes
                     {text:'Viernes', width:'17%', align: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado', width:'17%', align: 'right'},
            // 6:  Domingo
                     {text:'Domingo', width:'17%', align: 'right'},
            // 7:  Lunes
                     {text:'Lunes', width:'17%', align: 'right'});


            props    = new Array(null,null,null,null,null,null,null,null);
            
            loGrid2.setMainHeaders(mheaders);
            loGrid2.setHeaders(headers);
            loGrid2.setDataProps(props);
            loGrid2.setData(DineinDataset);        
            loGrid2.drawInto('DineinDataGrid');
        }

        if(DeliveryDataset.length > 0)
        {

            mheaders = new Array(
                  {text:'Delivery', align:'center',hclass:'right'});

            headers  = new Array(
            // 0:  
                     {text:'',width:'15%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Martes
                     {text:'Martes',width:'17%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'17%', align: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'17%', align: 'right'},
            // 4:  Viernes
                     {text:'Viernes', width:'17%', align: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado', width:'17%', align: 'right'},
            // 6:  Domingo
                     {text:'Domingo', width:'17%', align: 'right'},
            // 7:  Lunes
                     {text:'Lunes', width:'17%', align: 'right'});


            props    = new Array(null,null,null,null,null,null,null,null);
            
            loGrid3.setMainHeaders(mheaders);
            loGrid3.setHeaders(headers);
            loGrid3.setDataProps(props);
            loGrid3.setData(DeliveryDataset);        
            loGrid3.drawInto('DeliveryDataGrid');
        }

        if(CarryoutDataset.length > 0)
        {

            mheaders = new Array(
                  {text:'Carry out', align:'center',hclass:'right'});

            headers  = new Array(
            // 0:  
                     {text:'',width:'15%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Martes
                     {text:'Martes',width:'17%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'17%', align: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'17%', align: 'right'},
            // 4:  Viernes
                     {text:'Viernes', width:'17%', align: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado', width:'17%', align: 'right'},
            // 6:  Domingo
                     {text:'Domingo', width:'17%', align: 'right'},
            // 7:  Lunes
                     {text:'Lunes', width:'17%', align: 'right'});


            props    = new Array(null,null,null,null,null,null,null,null);
            
            loGrid4.setMainHeaders(mheaders);
            loGrid4.setHeaders(headers);
            loGrid4.setDataProps(props);
            loGrid4.setData(CarryoutDataset);        
            loGrid4.drawInto('CarryoutDataGrid');
        }

        if(WindowDataset.length > 0)
        {

            mheaders = new Array(
                  {text:'Window', align:'center',hclass:'right'});

            headers  = new Array(
            // 0:  
                     {text:'',width:'15%', hclass: 'left', bclass:'left', align:'right'},
            // 1:  Martes
                     {text:'Martes',width:'17%', hclass: 'right', bclass: 'right', align: 'right'},
            // 2:  Miercoles
                     {text:'Mi&eacute;rcoles', width:'17%', align: 'right'},
            // 3:  Jueves
                     {text:'Jueves', width:'17%', align: 'right'},
            // 4:  Viernes
                     {text:'Viernes', width:'17%', align: 'right'},
            // 5:  Sabado
                     {text:'S&aacute;bado', width:'17%', align: 'right'},
            // 6:  Domingo
                     {text:'Domingo', width:'17%', align: 'right'},
            // 7:  Lunes
                     {text:'Lunes', width:'17%', align: 'right'});


            props    = new Array(null,null,null,null,null,null,null,null);
            
            loGrid5.setMainHeaders(mheaders);
            loGrid5.setHeaders(headers);
            loGrid5.setDataProps(props);
            loGrid5.setData(WindowDataset);        
            loGrid5.drawInto('WindowDataGrid');
        }

    }


