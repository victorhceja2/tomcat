<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Edit/Proc/EmployeeLib.jsp" %>

<%! 
	AbcUtils moAbcUtils = new AbcUtils();
%>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Baja de Empleados";
    moHtmlAppHandler.setPresentation("VIEWPORT"); 
    moHtmlAppHandler.initializeHandler();

    moHtmlAppHandler.msReportTitle = "Baja de Empleados";
    moHtmlAppHandler.moReportTable.setTableHeaders("<p></p>|#EMPL|NOMBRE|FECHA<br>EFECTIVA|PUESTO|ULTIMO<br>CHECADO",0,false);
    moHtmlAppHandler.moReportTable.setFieldFormats("||||| ");
    //moHtmlAppHandler.moReportTable.setTableId("empTable");
    moHtmlAppHandler.validateHandler(); 

    if (!moHtmlAppHandler.getHandlerErrorMsg().equals("")) {
        out.println(moHtmlAppHandler.getHandlerErrorMsg());
        moHtmlAppHandler.initializeHandler();
        return;
    }

   ArrayList<String[]> empleados = new ArrayList<String[]>();

   empleados=readAllEmplFMS(); 
   addToEmplBD(empleados);
%>

<html>
    <head>
        <title><%=moHtmlAppHandler.msReportTitle %></title>
	<link rel='stylesheet' type='text/css' href='<%=moHtmlAppHandler.getReportStyleSheet() %>'>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
    	<link rel="stylesheet" type="text/css" href="/CSS/WaitMessageYum.css"/>
    	
    	<script src="/Scripts/AbcUtilsYum.js"></script>
	<script src="/Scripts/ReportUtilsYum.js"></script>
    	<script type="text/javascript">

	    var popupWindow=null; 

	    function checkUncheckAll(poElement) {

            	for (var z = 0; z < document.frmSelection.elements.length; z++) {
                    if (document.frmSelection[z].type == 'checkbox' && document.frmSelection.elements[z].name !='chkAll') {
                        if (poElement.checked==true && document.frmSelection.elements[z].checked==false)
                            document.frmSelection.elements[z].click();
                	else if(poElement.checked==false && document.frmSelection.elements[z].checked==true) 
                            document.frmSelection.elements[z].click();
                    }
		}
	    }

	    function uncheck(){

		for (var z = 0; z < document.frmSelection.elements.length; z++) {
                	document.frmSelection.elements[z].checked = false;
                }
	    }

	    function readTable(){

    		var empTable = document.getElementById('tblMdx');
    		var rowLength = empTable.rows.length;
		var empleados = "";

    		for (i = 1; i < rowLength; i++){
       			var empCells = empTable.rows.item(i).cells;

			if ( document.frmSelection[i+1].type == 'checkbox' && document.frmSelection.elements[i+1].checked==true ){
			   var cellVal = empCells.item(1).textContent;
			   empleados = empleados.concat(cellVal,"|");
			}
   		}
		document.getElementById("txtEmpls").value=empleados;
		console.log(empleados);
	    }
	
	    function openWindowPass(parentWindow){

		readTable(); 
		var empl = document.getElementById('txtEmpls').value;
		empl = empl.slice(0,-1);
		var left = (screen.width/2)-(380/2);
		var top = (screen.height/2)-(220/2);
		popupWindow = window.open('EmployeePasswd.jsp?empl='+ empl,'CheckPass','width=380,height=220,top='+top+',left='+left);
	
	    }

            function loadEntry(){
		    uncheck();  
            }

	   function parent_disable(){
		if(popupWindow && !popupWindow.closed)
			popupWindow.focus();
	   }

        </script>
	</head>
	<body bgcolor="white" <%=moHtmlAppHandler.moReportHeader.getBodyStyle() %> Onload="loadEntry();" onfocus="parent_disable();" onclick="parent_disable();" >
        	<jsp:include page = '/Include/GenerateHeaderYum.jsp'>
            	<jsp:param name="psStoreName" value="true"/>
        	</jsp:include>
	 <input type='hidden' id='txtEmpls' name='txtEmpls' value=''/>
         <form id="frmSelection" name="frmSelection" method="post" >
	    <br>
	    <table border='0' cellspacing='0' cellpadding='0' align='left' width='100%'>
              <tr valign='top'>
		   <td width='10%' class='descriptionTabla' align='top'>
                       <input type = 'checkbox'  name="chkAll" id="chkAll" value = '0' OnClick = 'checkUncheckAll(this);'><b>Seleccionar Todos</b>
            	  </td>
            	   <td width='40%'>
                       <input type = 'button' name="btnDelete" class = 'combos' value = 'Dar de baja' OnClick = 'openWindowPass(this)'>
            	   </td>
             </tr>
     	  </table>
	  <br><br>
	  <% moHtmlAppHandler.moReportTable.displayReportTable(out,getQueryReport()); %> 
	 </form>
	</body>
</html>

<%!

  String getQueryReport()
  {
    String lsQuery = "select '<input type=''checkbox'' >' as EXTRA,emp_num,(nombre || ' ' || ap_pat || ' ' || ap_mat) as nombre_com," +
		     "fecha_efe,puesto,ultimo_chk,extract(days from (now()-ultimo_chk::date)) from pp_empl_status where" +
		     " emp_activo=false and (extract(days from (now()-ultimo_chk::date)) > 31 or ultimo_chk IS NULL)" +
		     " order by nombre_com";
    return lsQuery;
  }

%>
