
<jsp:include page = '/Include/ValidateSessionYum.jsp'/>

<%--
##########################################################################################################
# Nombre Archivo  : TransPiecesYum.jsp
# Compania        : Yum Brands Intl
# Autor           : Sergio Cuellar Valdes
# Objetivo        : Contenedor principal de la pantalla de captura de PiezasxTransaccion
# Fecha Creacion  : 29/Mayo/2008
# Inc/requires    : 
# Modificaciones  :
##########################################################################################################
--%>

<%@ page contentType="text/html"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="generals.*" %>
<%@ include file="/Include/CommonLibYum.jsp" %>
<%@ include file="../Proc/TransPiecesLibYum.jsp" %>  

<%! 
    AbcUtils moAbcUtils = new AbcUtils();
%>

<%

    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    moHtmlAppHandler.msReportTitle = "Captura de Piezas/Transac.";

    String msDateQRY       = null;
    String msDateYMD	   = null;
    String msDateDMY       = null;
    String msPpt_real      = null;
    String msPpt_sis	   = null;
    String msCbzs_real     = null;
    String msCbzs_sis      = null;
    String msId_fcst_gte   = null;
    String msPpt_gte_old   = null;
    String msLs_strFile    = null;
    float miTrans_Gte      = 0;
    float miCbzs_gte       = 0;
    String msMix_Auto_S    = null;
    String msMix_Auto_G    = null;
    String msMix_Home_S    = null;
    String msMix_Home_G    = null;
    String msMix_Dine_S    = null;
    String msMix_Carry_S   = null;
    int miStringFound      = 0;

    msDateYMD     = request.getParameter("fecha_cal");
    msDateDMY     = request.getParameter("txtDate");
    msDateQRY     = request.getParameter("fecha_qry");
    msPpt_sis     = request.getParameter("ppt_sis");
    msPpt_gte_old = request.getParameter("ppt_gte_old");
    msId_fcst_gte = request.getParameter("txtGerente");
    msMix_Auto_S  = request.getParameter("txtMixAutoS");
    msMix_Auto_G  = request.getParameter("txtMixAutoG");
    msMix_Home_S  = request.getParameter("txtMixHdS");
    msMix_Home_G  = request.getParameter("txtMixHdG");
    msMix_Dine_S  = request.getParameter("txtMixDnS");
    msMix_Carry_S = request.getParameter("txtMixCoS");
    miTrans_Gte   = Float.parseFloat(request.getParameter("trans_gte"));


    miCbzs_gte    = miTrans_Gte * Float.parseFloat(msId_fcst_gte) / 9;

    try {
        FileInputStream fstream  = new FileInputStream("/usr/bin/ph/tables/real_sistema_gerente.txt");
	DataInputStream instream = new DataInputStream(fstream);
	BufferedReader buffer    = new BufferedReader(new InputStreamReader(instream));

	String strLine;
	String [] rsg_line = null;
	StringBuffer msSb = new StringBuffer();

	msPpt_real = executeCommand("/usr/bin/ph/txthistory/ppt-real.pl --fecha " + msDateYMD + " --nocache --calc");
	msCbzs_real   = executeCommand("/usr/bin/ph/txthistory/cabezas-real.pl --fecha " + msDateYMD + " --nocache --calc");
	msCbzs_sis    = executeCommand("/usr/bin/ph/txthistory/cabezas-pron.pl --fecha " + msDateYMD + " --nocache --calc --natural");

	msLs_strFile  = msDateYMD + "|" + msPpt_real + "|" + msPpt_sis + "|" + msId_fcst_gte + "|" + msCbzs_real + "|" + msCbzs_sis + "|" + miCbzs_gte + "|\n";

	while ((strLine = buffer.readLine()) != null) {
	    rsg_line = strLine.split("\\|");
	    if(rsg_line[0].equals(msDateYMD)) {
	        msSb.append(msLs_strFile);
		miStringFound = 1;
	    } else {
	        msSb.append(strLine);
		msSb.append("\n");
            }
	}

	instream.close();

	if(miStringFound == 1) {
	    saveFile(msSb, "/usr/bin/ph/tables/real_sistema_gerente.txt");
            insertPzTrxDB(msDateQRY,msPpt_real,msPpt_sis,msId_fcst_gte,msCbzs_real,msCbzs_sis,String.valueOf(miCbzs_gte));
	}

        if(miStringFound == 0) {
            append2File(msLs_strFile, "/usr/bin/ph/tables/real_sistema_gerente.txt");
            insertPzTrxDB(msDateQRY,msPpt_real,msPpt_sis,msId_fcst_gte,msCbzs_real,msCbzs_sis,String.valueOf(miCbzs_gte));
        }
 
	// Agregar datos de Mix a op_mdw_trx_mix_frozen_data

	setMiXdest(msDateQRY,msMix_Home_G,msMix_Auto_G,msMix_Dine_S,msMix_Carry_S,msMix_Home_S,msMix_Auto_S);

	// Guardar log

	log(msDateYMD,msPpt_gte_old,msId_fcst_gte);		

    } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
    }

%>

<html>
    <head>
        <title>Captura de Piezas/Transac.</title>
        <link rel="stylesheet" type="text/css" href="/CSS/GeneralStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/TabStandardsYum.css"/>
	<link rel="stylesheet" type="text/css" href="/CSS/DataGridReportPreviewYum.css"/>

        <script src="/Scripts/AbcUtilsYum.js"></script>
        <script src="/Scripts/ReportUtilsYum.js"></script>
        <script src="/Scripts/Chars.js"></script>
        <script src="/Scripts/StringUtilsYum.js"></script>
        <script src="/Scripts/HtmlUtilsYum.js"></script>
        <script>

	</script>

    </head>
    <body bgcolor="white">
    <jsp:include page = '/Include/GenerateHeaderYum.jsp'>
		<jsp:param name="psStoreName" value="true"/>
    </jsp:include>

    <center>
    <table align="center" border="0" cellpadding="2" cellspacing="2">
       <tbody>
          <tr>
	      <td class="bsDg_td_colspan">Los datos fueron guardados satisfactoriamente</td>
	  </tr>
          <tr>
	      <td class="bsDg_td_colspan"><a href="../Entry/TransPiecesFrm.jsp?txtDate=<%=msDateDMY%>">Regresar</a></td>
	  </tr>
       </tbody>
    </table>
    </center>

    </form>

    <jsp:include page = '/Include/TerminatePageYum.jsp'/>
</html>
