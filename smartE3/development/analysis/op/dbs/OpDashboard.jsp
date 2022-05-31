<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%
   String msAdjust=(request.getParameter("adjust")==null)?"0":request.getParameter("adjust");
   String msStoreName=(request.getParameter("store_name")==null)?"":request.getParameter("store_name");
%>

<html>
    <head>
         <title>World Class Operations</title>
         <style>
             @media print {body {-webkit-print-color-adjust: exact;}}
         </style>
            <link rel="icon" href="/smartE3/images/e3/ui/dbs/dashboard.png" type="image/x-icon" />
            <link rel="stylesheet" type="text/css" href="/smartE3/resources/css/dbs_print.css" media="print" />
            <link rel="stylesheet" type="text/css" href="/smartE3/resources/css/dbs.css" media="screen" />
	    <script type="text/javascript" src="/smartE3/resources/js/jquery/jquery-1.6.2.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/generals/utils.js"></script>            
            <script type="text/javascript"  src="/smartE3/resources/js/flot/excanvas.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.min.js"></script>
            
            <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.fillbetween.min.js"></script>
            <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.symbol.min.js"></script>
            <script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.categories.min.js"></script>
            <!--script language="javascript" type="text/javascript" src="/smartE3/resources/js/flot/jquery.flot.barnumbers.enhanced.js"></script-->
            <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.1.0.1.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/justgage/raphael.2.1.2.min.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/justgage/justgage.js"></script>
            <script type="text/javascript" src="/smartE3/resources/js/generals/wco_dashboard.js"></script>
            <script>
                 var moAppHandler = new AppHandler();
            </script>
    </head>
   
    <body onload="setIntitialData()">
        <table style="width:100%;" id="tblMainDash">
            <tr class="gradient">
                <td colspan="6" align="center">
                    <table style="width: 100%">
                         <tr>
                            <td width="90" >
                            <img id="imgHeader" src="/smartE3/images/e3/ui/dbs/help.png" width="90px" />
                            </td>
                            <td width="70" align="rigth">
                                <img  src="/smartE3/images/e3/ui/dbs/dashboard.png" width="70px" />
                            </td>
                            <td rowspan="2" width="400px" style="font-family: myFirstFont">
                                Dashboard SMART
                            </td>
                            <td  id="tdDate" width="200" style="font-family: myFirstFont;font-size: 27px">
                                YYYY-MM-DD
                            </td>
                            <td width="40"  align="rigth">
                                <img  src="/smartE3/images/e3/ui/dbs/clock.png" width="40px" />
                            </td>
                            <td  id="tdHour" width="150" style="font-family: myFirstFont;font-size: 20px">
                                0:00-0:00
                            </td>
                            <td width="90"  align="rigth">
                                <img  src="/smartE3/images/e3/ui/dbs/print.png" onclick="window.print();" onmouseover="this.src='/smartE3/images/e3/ui/dbs/print_hover.png'" onmouseout="this.src='/smartE3/images/e3/ui/dbs/print.png'"width="60px" />
                            </td>
                            <td width="60"  align="rigth">
	                        <img  src="/smartE3/images/e3/ui/dbs/coins.png" width="60px" />
	                    </td>
                            <td  id="tdCoins" width="100" style="font-family: myFirstFont">
                                <font size="7px">0</font> 
                            </td>
                            <td id="tdRank" width="300px" style="font-family: myFirstFont;font-size: 14px">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table class="dash-header">
                        <tr>
                            <td>
                                <img  src="/smartE3/images/e3/ui/dbs/user.png" width="40px" />
                            </td>
                            <td style="font-family: myFirstFont;">
                                GENTE
                            </td>
                        </tr>
                    </table>
                    
                </td>
                  <td colspan="2">
                    <table class="dash-header">
                        <tr>
                            <td>
                                <img  src="/smartE3/images/e3/ui/dbs/sales.png" width="40px" />
                            </td>
                            <td style="font-family: myFirstFont;">
                                VENTAS/CLIENTES
                            </td>
                        </tr>
                    </table>
                    
                </td>
            
                  <td colspan="2">
                    <table class="dash-header">
                        <tr>
                            <td>
                                <img  src="/smartE3/images/e3/ui/dbs/utils.png" width="40px" />
                            </td>
                            <td style="font-family: myFirstFont;">
                                UTILIDADES
                            </td>
                        </tr>
                    </table>
                    
                </td>
                
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <table class="dash-table">
                        <tr class="bashboard-border">
                            <td colspan="3">
                                ASOCIADOS
                            </td>
                            <td colspan="3">
                                REPAS
                            </td>
                        </tr>
                        <tr class="bashboard-border-sublevel">
                            <td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td>
                            <td>
                                Dife
                            </td>
                            <td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td>
                            <td>
                                Dife
                            </td>
                        </tr>
                        <tr class="detail">
                            <td  id="tdPosIdeal">
                                0
                            </td>
                            <td  id="tdPosReal">
                                0
                            </td>
                            <td class="greenvalue" id="tdPosDif">
                                0
                            </td>
                              <td id="tdRepIdeal">
                                0
                            </td>
                            <td id="tdRepReal">
                                0
                            </td>
                            <td class="greenvalue" id="tdRepDif">
                                0
                            </td>
                            
                        </tr>
                          <tr class="bashboard-border">
                            <td colspan="3">
                                CAJEROS
                            </td>
                           <td colspan="3" class="bashboard-border-prod">
                                <span style="background-color:#FFFF00;color:black">TPHH</span>
                            </td>
                        </tr>
                        <tr class="bashboard-border-sublevel">
                            <td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td>
                            <td>
                                Dife
                            </td>
                            <td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td>
                            <td>
                                Dife
                            </td>
                            
                          
                         </tr>
                          <tr class="detail">
                            <td  id="tdCashIdeal">
                                0
                            </td>
                            <td  id="tdCashReal">
                                0
                            </td>
                            <td class="greenvalue" id="tdCashDif">
                                0
                            </td>
                             
                            <td id="tdProdIdeal">
                                0
                            </td>
                            <td id="tdProdReal">
                                0
                            </td>
                            <td class="greenvalue" id="tdProdDif">
                                0
                            </td>  
                          </tr>
                         <tr class="bashboard-border">
                            <td colspan="6">
                                AUSENTISMO
                            </td>
                        </tr>
                        
                        <tr class="detail">
                            <td class="greenvalue" colspan="6" id="abs">
                                0
                            </td>
                           
                        </tr>
                    </table>
                    <br>
                    <table>
                        <tr>
                            <td>
                                <table class="dash-table">
                                    <tr class="bashboard-border"><td colspan="2">TPHH</td></tr>
                                    <tr class="detail"><td>Ideal</td><td>Real</td></tr>
                                    <tr ><td id="tpph_id_last_week" class="bashboard-border-sublevel">0</td><td id="tpph_re_last_week" class="bashboard-border-sublevel">0</td></tr>
                                </table>
                            </td>
                            <td>
                                <table class="dash-table">
                                    <tr class="bashboard-border"><td colspan="2">EN CAPACITACION</td></tr>
                                    <tr class="detail"><td>Ideal</td><td>Real</td></tr>
                                    <tr><td id="tdEmpIdealTrain" class="bashboard-border-sublevel" >0</td><td id="tdEmpRealTrain" class="bashboard-border-sublevel" >0</td></tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    
                </td>
                <td colspan="2"  align="center">
                    <table class="dash-table">
                        <tr  class="bashboard-border">
                            <td colspan="3">
                                VENTAS
                            </td>
                            <td colspan="3">
                                TRX
                            </td>
                        </tr>
                        <tr class="bashboard-border-sublevel">
                            <td colspan="2">
                                Diferencia
                            </td>    
                            <!--td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td-->
                           
                             <td>
                                Ideal
                            </td>
                            <td>
                                Real
                            </td>
                           
                        </tr>
                         <tr class="detail">
                             <td colspan="2" class="detail" id="sales_res">
                                0
                            </td>
                            <!--td class="detail" id="sales_py">
                                0
                            </td>
                            <td class="detail" id="sales">
                                0
                            </td-->
                          
                             <td class="detail" id="trx_py">
                                0
                            </td>
                            <td class="detail" id="trx">
                                0
                            </td>
                          
                        </tr>
                        <tr class="detail">
                            <td >
                                Idx
                            </td>
                            <td class="rednovalue" id="sales_dif">
                                0
                            </td>
                            <td>
                                Idx
                            </td>
                              <td  class="greennovalue"  id="trx_dif">
                                0
                            </td>
                        </tr>
                        <tr>
                            <td colspan="1" class="bashboard-border-sublevel">
                               JUMBO 
                            </td>
                            <td class="detail" id="jumbo">
                                0
                            </td>    
                            <td rowspan="4" colspan="4">
                                <table style="width:100%">
                                    <tr>
                                        <td class="bashboard-border-sublevel">
                                            WPSA/MIX<br>
                                            VENTANA
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="detail" id="mix">
                                            0
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bashboard-border-sublevel" id="mix_name">
                                            0
                                        </td>
                                    </tr>

                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="1" class="bashboard-border-sublevel">
                               AGRANDA
                            </td>
                             <td class="detail" class="rednovalue" id="agranda">
                                0
                            </td>    
                        </tr>
                        <tr>
                            <td colspan="1" class="bashboard-border-sublevel">
                               DELICIA
                            </td>
                             <td class="detail" id="delicia">
                                0
                            </td>    
                        </tr>
                    </table>
                    <br>
                    <table class="dash-table">
                        <tr  class="bashboard-border">
                            <td colspan="6">
                                FREIDORAS
                            </td>
                        </tr>
                        <tr>
                            <td class="bashboard-border-sublevel">
                                CRUJI
                            </td>
                             <td class="detail" id="fry_cruji">
                                0
                            </td>   
                             </tr>
                        <tr>
                            <td class="bashboard-border-sublevel">
                                SECRETA
                            </td>
                             <td class="detail" id="fry_secre">
                                0
                            </td>   
                             </tr>
                        <tr>
                             <td class="bashboard-border-sublevel">
                                3A RECETA
                            </td>
                             <td class="detail" id="fry_third">
                                0
                            </td>   
                        </tr>
                    </table>
                    <br>
                </td>
                <td colspan="2"  align="center">
                    <table>
                        <tr>
                            <td>
                                <table class="dash-table">
                        <tr>
                            <td>
                                <table>
                                    <tr class="bashboard-border">
                                        <td colspan="2" >
                                            EFICIENCIAS
                                        </td>
                                        
                                    </tr>
                                    <tr >
                                        <td id="head_ef_label" class="bashboard-border-sublevel">
                                            Pollo
                                        </td>
                                        <td class="detail" id="head_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="bgcrunch_ef_label" class="bashboard-border-sublevel">
                                            Big Crunch
                                        </td>
                                        <td class="detail" id="bgcrunch_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="supr_ef_label" class="bashboard-border-sublevel">
                                            Suprema
                                        </td>
                                        <td class="detail" id="supr_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="fav_ef_label" class="bashboard-border-sublevel">
                                            Favoritas
                                        </td>
                                        <td class="detail" id="fav_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="biscuit_ef_label" class="bashboard-border-sublevel">
                                            Biscuit
                                        </td>
                                        <td class="detail" id="biscuit_ef">
                                            0%
                                        </td>
                                    </tr>
                                     <tr >
                                        <td id="tender_ef_label" class="bashboard-border-sublevel">
                                            Tiras
                                        </td>
                                        <td class="detail" id="tender_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="salad_ef_label" class="bashboard-border-sublevel">
                                            Ensalada
                                        </td>
                                        <td class="detail" id="salad_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="dress_ef_label" class="bashboard-border-sublevel">
                                            Aderezo
                                        </td>
                                        <td class="detail" id="dress_ef">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td id="mash_ef_label" class="bashboard-border-sublevel">
                                            Pure
                                        </td>
                                        <td class="detail" id="mash_ef">
                                            0%
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <table>
                        <tr>
                            <td>
                                <table class="dash-table">
                                    <tr class="bashboard-border">
                                        <td colspan="2">
                                            CANCELACIONES
                                        </td>
                                    </tr>
                                      <tr >
                                        <td class="bashboard-border-sublevel">
                                            Hechas
                                        </td>
                                        <td class="detail" id="cancel_done">
                                            0%
                                        </td>
                                        
                                    </tr>
                                    <tr >
                                        <td class="bashboard-border-sublevel">
                                            Comidas emp
                                        </td>
                                        <td class="detail" id="empl_meal">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td class="bashboard-border-sublevel">
                                            No hechas
                                        </td>
                                        <td class="detail" id="cancel_undone">
                                            0%
                                        </td>
                                    </tr>
                                     <tr >
                                        <td class="bashboard-border-sublevel">
                                            Reembolsos
                                        </td>
                                        <td class="detail" id="reimbursement">
                                            0%
                                        </td>
                                    </tr>
                                     <tr >
                                        <td class="bashboard-border-sublevel">
                                            Promo/Desc
                                        </td>
                                        <td class="detail" id="promo">
                                            0%
                                        </td>
                                    </tr>
                                    <tr >
                                        <td class="bashboard-border-sublevel">
                                            Paid Outs
                                        </td>
                                        <td class="detail" id="paidouts">
                                            0%
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>    
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2" rowspan="2"  align="center">
                    <table class="dash-table">
                        <tr>
                            <td>
                                <div style="background-color:white;width:340px;height:250px;">
                                <center>
                                    <div id="divGraph" style="background-color:white;width:300px;height:250px;margin-top: 5px;"></div>
                                </center>
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                    <script>
                    </script>
                </td>
                  <td colspan="2"  align="center">
                 
                    <table class="dash-table">
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>
                                            <div id="hd" style="width:200px;height:120px;font-size:30px"></div>
                                        </td>
                                        <td>
                                            <div id="auto" style="width:200px;height:120px"></div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="detail-mini">
                                              <center>
                                                  &Oacute;rdenes en producci&oacute;n<br>
                                                  <span id="prod_ord" name="prod_ord" class="employee"></span>
                                              </center>
                                        </td>
                                        <td colspan="2">
                                            <center>
                                                <div id="most" style="width:200px;height:120px"></div>
                                            </center>
                                        </td>
                                    </tr>    
                                </table>    
                                
                                
                            </td>
                        </tr>
                    </table>
                    
                    <script>
                  
                    </script>
                </td>
                  <td colspan="2"  align="center">
                    <table>
                        <tr>
                            <td>
                                <table class="dash-table">
                                    <tr class="bashboard-border">
                                        <td colspan="3">
                                            SEMIS
                                        </td>
                                    </tr>
                                    <tr class="bashboard-border-sublevel">
                                        <td >
                                            Ideal
                                        </td>
                                        <td>
                                            Real
                                        </td>

                                    </tr> 
                                     <tr >
                                        <td class="detail" id="semis_ideal">
                                            0
                                        </td>
                                        <td class="detail" id="semis_real">
                                            0
                                        </td>

                                    </tr> 
                                    <tr  class="detail">
                                         <td>
                                            Diferencia
                                        </td>
                                        <td id="semis_dif">
                                            0
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                <table class="dash-table">
                                    <tr>
                                       <td>
                                           <table>
                                               <tr class="bashboard-border">
                                                   <td colspan="4">
                                                       NEGATIVOS
                                                   </td>
                                               </tr>
                                               <tr class="bashboard-border-sublevel">
                                                   <td>
                                                       Merma
                                                   </td>

                                                   <td>
                                                       Faltante
                                                   </td>
                                               </tr> 
                                                 <tr class="detail">
                                                   <td class="detail" id="waste">
                                                       0
                                                   </td>
                                                   <td class="detail" id="missing">
                                                       0
                                                   </td>

                                               </tr>
                                                <tr class="detail">
                                                   <td class="detail" id="waste_per">
                                                       0
                                                   </td>
                                                   <td class="detail" id="missing_per">
                                                       0
                                                   </td>
                                               </tr>
                                           </table>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <table width="40%" class="dash-table">
                        <tr class="bashboard-border">
                            <td colspan="2">
                                COSTO DE VENTA
                            </td>
                        </tr>
                        <tr class="bashboard-border-sublevel">
                            <td>
                                DIARIO
                            </td>
                            <td>
                                SEMANAL
                            </td>
                        </tr>
                        <tr>
                            <td class="detail" id="tdSaleCostD">
                                0.00
                            </td>
                            <td class="detail" id="tdSaleCostW">
                                0.00
                            </td>
                        </tr>
                    </table>
                </td>

 
            </tr>
            <tr>
                <td id="sales" name="sales" style="visibility:hidden" ></td>
                <td id="sales_py" name="sales_py" style="visibility:hidden" ></td>
               
            </tr>
            <%if(!msStoreName.equals("")){%>
            <tr >
                <td colspan="6" class="divWarn"><center><p  class="store-name"><%=msStoreName%></p></center></td>
            </tr>
             <%}%>
        </table>
        <script>
        <%if(!msAdjust.equals("0")){%>
         document.body.style.zoom="<%=msAdjust%>%";
        <%}%>
        </script>
        <div id="divWarn" class="divWarn">&nbsp;</div>
        <!--
        <p  class="detail-mini">
            <b>Horas ideales:</b> Se obtiene de los datos de horarios gr&aacute;ficos.<br>
            <b>Horas reales:</b> Se obtienen del biom&eacute;trico.<br>
            <b>Ausentismo:</b> Se obtiene del reporte (4204 - Reporte de Porcentaje de asistencia) de la Intranet.<br>
            <b>Ventas y Trx:</b> Acumulado semanal, los datos hist&oacute;ricos se obtienen del reporte (4010 - Reporte de Ventas y Transacciones Vs. FCST & Vs. PY con Missings) de la Intranet consultando fechas de un a&ntilde;o anterior para ideal, la venta del d&iacute;a en curso se obtiene del reporte de operaciones diarias del d&iacute;a en curso  del reporteador.<br>
            <b>Mix:</b>Se obtienen del reporte de operaciones diarias del d&iacute;a en curso del reporteador.<br>
            <b>HD:</b>Se obtiene del reporte de auditor&iacute;a repartidor del d&iacute;a en curso del reporteador.<br>
            <b>AUTO:</b>Se obtiene del reporte en E-Reports en la ruta Estad&iacute;sticas -> Reportes -> Reporte de auto.<br>
            <b>MOST:</b>Se obtiene de la informaci&oacute;n del PKDS o de ALOHA seg&uacute;n el sistema que maneje el restaurante.<br>
            <b>Eficiencias:</b>Se obtienen del reporte de operaciones diarias del d&iacute;a anterior.<br>
            <b>Cancelaciones:</b>Se obtienen del reporte de operaciones diarias del d&iacute;a en curso.<br>
            <b>Semis ideal:</b>Corresponde al 3.2% de la venta acumulada del periodo en curso.<br> 
            <b>Semis real:</b>Se obtiene del reporte (1272 - Consulta de Semivariables y Paid Outs) de la Intranet con el acumulado del periodo en curso.<br> 
            <b>Mermas y faltantes:</b>Se obtienen del reporte de operaciones diarias del d&iacute;a anterior.<br>
        </p>
        -->
    </body>
    
    
</html>
