<%--
##########################################################################################################
# Nombre Archivo  : GenerateMenuYum.jsp
# Compañia        : Yum Brands Intl
# Autor           : JPG
# Objetivo        : JSP para generar el menu de opciones Yum
# Fecha Creacion  : 29/Enero/2004
# Inc/requires    : 
# Modificaciones  :
# Fecha           Programador     Observaciones
# --------------  -----------     ---------------
##########################################################################################################
--%>

<%@page import = "generals.*" %>

<style type='text/css'>
    #divMenuBar{position:absolute; visibility:show; left:0px; top:0px; width:100px; z-index:0}
</style>

<%
    HtmlAppHandler moHtmlAppHandler = (HtmlAppHandler)session.getAttribute(request.getRemoteAddr());
    EyumDBConnectionPool moConnectionPool = EyumDBConnectionPool.getInstance();
    DBConnection moDataLayer = moConnectionPool.getConnection();

    if (!moHtmlAppHandler.moClientData.clientIsNN4()) {
%>
    <div id='divMenuBar' bgcolor = 'navy' style = 'width:3000px; height:20px;'>
        <table bgcolor = 'navy' width = '100%' height = '100%' border = '0'>
            <tr bgcolor = 'navy'>
                <td>
                </td>
                <td class = 'littleOptions' align = 'right'>
                    <img src = '/Images/Menu/yum_icons.gif' border = '0' stretch>
                </td>	
            </tr>
        </table>
    </div>
<%}%>

<Script language = "JavaScript">
    menunum=0;menus=new Array();_d=document;function addmenu(){menunum++;menus[menunum]=menu;}function dumpmenus(){mt="<scr"+"ipt language=javascript>";for(a=1;a<menus.length;a++){mt+=" menu"+a+"=menus["+a+"];"}mt+="<\/scr"+"ipt>";_d.write(mt)}
    effect = "Fade(duration=0.2);Alpha(style=0,opacity=88);Shadow(color='#777777', Direction=135, Strength=5)"
    timegap=500			// The time delay for menus to remain visible
    followspeed=5		// Follow Scrolling speed
    followrate=40		// Follow Scrolling Rate
    suboffset_top=4;            // Sub menu offset Top position 
    suboffset_left=6;           // Sub menu offset Left position
    closeOnClick = true

    style1=['navy','dddddd','ffffff','aaaaaa','000000',10,'normal','bold','Verdana, Arial',4,'/Images/Menu/arrow.gif',,'66ffff','000099',,,'/Images/Menu/arrowdn.gif','ffffff','000099','navy',]
    maHelpOptions = new Array();

<% if (moHtmlAppHandler.moClientData.clientIsNN4()) { %>
    style2=['navy','navy','ffffff','navy','000000',10,'normal','bold','Verdana, Arial',4,'/Images/Menu/arrow.gif',,'66ffff','000099',,,'/Images/Menu/arrowdn.gif','ffffff','000099','navy',]
    addmenu(menu=['dummie',0,0,window.innerWidth,1,,style2,1,'right',,,1,,,,,,,,,,,'<img src=/Images/Menu/yum_icons.gif border=0>','',,'',1])
<%}%>

    <%
            String msQuery = "";
            String msLastFather = "";
            String msSpaces = "&nbsp;&nbsp;&nbsp;&nbsp;";
            String msScriptMenu = "";
            String msMenuKeys = "var gsMenuKeys = '";
            java.sql.ResultSet moResult;

            msQuery = "SELECT * FROM ss_grl_vw_menu_struct WHERE user_id = '" + moHtmlAppHandler.moUserData.getUserId() + "' ORDER BY father,option_org";
            moResult = moDataLayer.getQueryResult(msQuery);

            try {
                while (moResult.next()) {
                    String lsOptionId = moResult.getString("option_id");
                    String lsOption = moResult.getString("option_org");
                    String lsOptionName = moResult.getString("option_desc");
                    String lsOptionFather = moResult.getString("father");
                    String lsAction = moResult.getString("action");
                    String lsIcon = moResult.getString("icon_path");
                    String lsTarget = moResult.getString("target");
                    String lsReportOpts = moResult.getString("report_opts");
                    String lsReportExceptions = moResult.getString("report_exceptions");
                    String lsOptionKey = moResult.getString("option_key");
                    String lsHelpOptions = moResult.getString("help_options");
                    String lsReportTarget = lsTarget;

                    lsIcon = (lsIcon != null)?lsIcon = "<img src = " + lsIcon + " border=0>&nbsp;":"";
                    lsTarget = (lsTarget != null)?lsTarget = " target=" + lsTarget:"";
                    lsOptionFather = (lsOptionFather.equals(""))?"1":lsOptionFather;

                    if (!lsOptionFather.equals(msLastFather)) {
                        if (!msLastFather.equals("")) out.println("])");
                        
                        if (lsOptionFather.equals("1")) {
                            out.println("addmenu(menu=['menu" + lsOptionFather + "',4,5,,1,'',style1,1,'left',,,1,,,,,,'ifrMainContainer',,,,");
                        }
                        else {
                            out.println("addmenu(menu=['sm" + lsOptionFather + "',,,160,1,'',style1,,'left',effect,,,,,,,,'ifrMainContainer',,,,");
                        }
                        
                        msLastFather = lsOptionFather;
                    }
                    if (lsAction.substring(0,1).equals("/")) {
                        String lsOptionGroup = lsOption.substring(0,2);
                        String lsOptionKeyDigit = (lsOptionKey!=null)?lsOptionKey.substring(1):"";
                        if (lsOptionKey!=null) {
                            msMenuKeys += lsOptionKey + "|";
                            msScriptMenu += "var " + lsOptionKey + " = 'showPage(" + lsOptionId + ",\"" + lsAction + "\",\"" + lsReportTarget + "\",\"" + lsReportOpts + "\",\"" + lsOptionKeyDigit + "\",\"" + lsOptionGroup + "\",\"" + lsReportExceptions + "\")'; \n";
	                    if (!lsHelpOptions.equals("")) msScriptMenu += "maHelpOptions[" + lsOptionId + "] = '" + lsHelpOptions + "'; \n";
                        }
                        
                        lsAction = "javascript:showPage(" + lsOptionId + ",\"" + lsAction + "\",\"" + lsReportTarget + "\",\"" + lsReportOpts + "\",\"" + lsOptionKeyDigit + "\",\"" + lsOptionGroup + "\",\"" + lsReportExceptions + "\") ";
                        lsTarget = "";
                    }
                    out.println(",'" + lsIcon + lsOptionName + msSpaces + "','" + lsAction + lsTarget + "',,,1");
                }
                if (!msLastFather.equals("")) out.println("])");
            } catch (Exception e) {
                e.printStackTrace();
                out.println(e.getMessage());
            }
            out.println(msScriptMenu);
            out.println(msMenuKeys + "'; \n");
            moConnectionPool.freeConnection(moDataLayer);
     %>    

    dumpmenus();
</script>

<script language='JavaScript' src='/Scripts/MainMenuYum.js' type='text/javascript'></script>
