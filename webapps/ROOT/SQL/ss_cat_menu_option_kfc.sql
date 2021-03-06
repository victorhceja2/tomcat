DELETE FROM ss_option_group;
DELETE FROM ss_option_company;
DELETE FROM ss_option_time;

DELETE FROM ss_cat_menu_option;

SELECT setval('ss_cat_menu_option_option_id_seq',1, false);

iNSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --1
VALUES (1, '20','Inventario',NULL,NULL,NULL,40,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --2  
VALUES (2, '40','Ingresos&nbsp;y&nbsp;gastos',NULL,NULL,NULL,20,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --3  
VALUES (3, '50','Estadisticas',NULL,NULL,NULL,60,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --4 
VALUES (4, '60','Home&nbsp;Service',NULL,NULL,NULL,30,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --5 
VALUES (5, '70','Mano&nbsp;de&nbsp;Obra',NULL,NULL,NULL,30,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --6 
VALUES (6, '80','Auditoria',NULL,NULL,NULL,30,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --7 
VALUES (7, '90','Empleados',NULL,NULL,NULL,40,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --8
VALUES (8, '2030','Control de Ordenes de Compra',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --9
VALUES (9, '2050','Control de Inventario',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --10
VALUES (10, '2060','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --11
VALUES (11, '4030','Semivariables',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --12 
VALUES (12, '4040','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --13 
VALUES (13, '4050','Ventas',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --14
VALUES (14, '5010','Transacciones por AGEB',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --15
VALUES (15, '5020','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --16
VALUES (16, '5030','Congelados',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --17
VALUES (17, '5050','Captura de volanteo',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --18
VALUES (18, '5070','Horarios',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --19
VALUES (19, '6030','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --20
VALUES (20, '7030','Mano de Obra Semanal',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --21
VALUES (21, '7040','Planeaci&oacute;n',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --22
VALUES (22, '8010','Reportes',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --23
VALUES (23, '9010','FMS',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --24
VALUES (24, '203015','Orden de Compra','/Inventory/PurchaseOrder/Entry/OrderYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --25
VALUES (25, '205010','Transferencias de entrada/salida','/Inventory/Transfers/Entry/TransferYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --26
VALUES (26, '205020','Inventario semanal','/Inventory/WeeklyInventory/Entry/InventoryYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --27
VALUES (27, '205030','Inventario de criticos','/Inventory/Criticos/Entry/InventoryYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --28-----
VALUES (28, '206010','Inventario semanal','/Inventory/WeeklyInventory/Rpt/InventoryReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --29-----
VALUES (29, '206020','Transferencias de entrada','/Inventory/Transfers/Rpt/TransferReportYum.jsp?type=input','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --30-----
VALUES (30, '206030','Transferencias de salida','/Inventory/Transfers/Rpt/TransferReportYum.jsp?type=output','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --31-----
VALUES (31, '206040','Confirmacion de Transferencias','/Inventory/Transfers/Rpt/CTransferReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --32-----
VALUES (32, '206050','Reporte de criticos','/Inventory/Criticos/Rpt/InventoryCritReportYum.jsp?type=output','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --33
VALUES (33, '403010','Captura de facturas','/IncomeAndExpense/Semivariable/Entry/InvoiceMasterYum.jsp','ifrMainContainer',NULL,510,0);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --34-----
VALUES (34, '403020','Reportes','/IncomeAndExpense/Semivariable/Rpt/InvoiceReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --35-----
VALUES (35, '404010','Comida de Empleados','/IncomeAndExpense/EmployeesMeal/Rpt/EmplMealReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --36
VALUES (36, '404020','Reporte de cajeros','/IncomeAndExpense/Cashiers/Entry/CashierYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --37
VALUES (37, '405010','Cierre Lote Tarj. Credito','/IncomeAndExpense/CreditCardBatch/Entry/CreditCardBatchYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --38
VALUES (38, '405020','Ventas Diarias por Destino','/IncomeAndExpense/DestSells/Rpt/DestSellsReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --39
VALUES (39, '405030','Cierre de Venta de Aplicaciones Moviles','/IncomeAndExpense/MovilSalesBatch/Entry/MovilSalesBatchYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --40
VALUES (40, '501010','Captura de HH y Objetivos','/Utilities/HouseHold/Entry/HouseholdYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --41----- 
VALUES (41, '501020','Reportes','/Utilities/HouseHold/Rpt/HouseholdReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --42 
VALUES (42, '501030','Resumen de transacciones','/Utilities/Resume/Rpt/HouseHoldResumeYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --43-----    
VALUES (43, '502010','Reporte de cupones','/Statistic/CouponReport/Rpt/CouponReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --44-----    
VALUES (44, '502020','Reporte de Auto','/SpeedOfService/Performance/Rpt/RepTimer.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --45-----
VALUES (45, '503020','Piezas por transaccion','/Graphics/PiecesAndTransactions/Rpt/PiecesReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --46-----
VALUES (46, '503030','No. transacciones','/Graphics/PiecesAndTransactions/Rpt/TransactionsReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --47-----
VALUES (47, '503040','Indice transacciones por fecha','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=date','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --48-----
VALUES (48, '503050','Indice transacciones por dia','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=day','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --49-----
VALUES (49, '503060','Indice transacciones por tendencia diaria','/Tendencies/Transactions/Rpt/TendenciesReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --50
VALUES (50, '503070','Captura de pzas/transac.','/Utilities/PiecesAndTransactions/Entry/TransPiecesYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --51
VALUES (51, '505010','Formato de captura','/Promotionalt/PromForm/Entry/TextPromForm.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --52-----
VALUES (52, '507010','Resumen OD Horarios','/Statistic/ReportHours/Rpt/HourTransReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --53-----
VALUES (53, '507020','Reporte de Asistencias en biom&eacute;trico','/Utilities/Assistance/Rpt/AssistanceReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --54-----
VALUES (54, '703010','Cambio de destino','/HomeService/DestChange/Rpt/DestChangeReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --55-----
VALUES (55, '603020','Llamadas de excepcion','/HomeService/ConmCall/Rpt/ConmCallReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --56-----
VALUES (56, '603030','Llamadas de salida','/HomeService/CallOut/Rpt/CallOutReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --57
VALUES (57, '603040','Clientes potenciales','/HomeService/CustomReport/Entry/CustomYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --58
VALUES (58, '603050','Clientes Frecuentes','/HomeService/CustomFrec/Entry/CustomFrec.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --59
VALUES (59, '603060','Clientes potenciales por AGEB','/HomeService/CustomReportAgeb/Entry/CustomYumA.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --60
VALUES (60, '603070','Clientes Frecuentes por AGEB','/HomeService/CustomFrecAgeb/Entry/CustomFrecA.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --61-----
VALUES (61, '703010','Horarios Graficos','/CostOfLabor/Rpt/CostofLaborReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --62-----
VALUES (62, '704020','Estimado Uso Real','/Planning/IdealUse/Rpt/IdealUseReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --63----
VALUES (63, '704030','Uso Ideal Diario','/Planning/IdealUse/Rpt/IdealUseReport14Yum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --64
VALUES (64, '801030','Reporte ticket SUS','/Auditoria/AudiReport/Entry/AudiReport.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --65 
VALUES (65, '801040','Reporte ticket Auditoria','/Auditoria/AudiPana/Entry/AudiPana.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --66 
VALUES (66, '901030','Actualizacion de datos','/Employees/Edit/Entry/EmployeeEdit.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --67 
VALUES (67, '5060','Anticipos',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --68
VALUES (68, '506010','Anticipos Recibidos/Aplicados','/IncomeAndExpense/AdvancePayment/Entry/AdvancePaymentYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --69----
VALUES (69, '704040','Plan de Marinado/Descongelado','/Planning/Defrost/Rpt/DefrostReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --70
VALUES (70, '506020', 'Consulta de Anticipos', '/IncomeAndExpense/AdvancePayment/Entry/AdvanceSearchYum.jsp', 'ifrMainContainer',NULL,500, 1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --71 
VALUES (71, '901010','Alta','/Employees/Add/EmployeeAdd.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_id, option_org, option_desc, action_desc, target, option_key, icon_id, visible) --72 
VALUES (72, '901020','Baja','/Employees/Delete/EmployeeDelete.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_option_group VALUES (100,1);
INSERT INTO ss_option_group VALUES (100,2);
INSERT INTO ss_option_group VALUES (100,3);
INSERT INTO ss_option_group VALUES (100,4);
INSERT INTO ss_option_group VALUES (100,5);
INSERT INTO ss_option_group VALUES (100,6);
INSERT INTO ss_option_group VALUES (100,7);
INSERT INTO ss_option_group VALUES (100,8);
INSERT INTO ss_option_group VALUES (100,9);
INSERT INTO ss_option_group VALUES (100,10);
INSERT INTO ss_option_group VALUES (100,11);
INSERT INTO ss_option_group VALUES (100,12);
INSERT INTO ss_option_group VALUES (100,13);
INSERT INTO ss_option_group VALUES (100,14);
INSERT INTO ss_option_group VALUES (100,15);
INSERT INTO ss_option_group VALUES (100,16);
INSERT INTO ss_option_group VALUES (100,17);
INSERT INTO ss_option_group VALUES (100,18);
INSERT INTO ss_option_group VALUES (100,19);
INSERT INTO ss_option_group VALUES (100,20);
INSERT INTO ss_option_group VALUES (100,21);
INSERT INTO ss_option_group VALUES (100,22);
INSERT INTO ss_option_group VALUES (100,23);
INSERT INTO ss_option_group VALUES (100,24);
INSERT INTO ss_option_group VALUES (100,25);
INSERT INTO ss_option_group VALUES (100,26);
INSERT INTO ss_option_group VALUES (100,27);
INSERT INTO ss_option_group VALUES (100,28);
INSERT INTO ss_option_group VALUES (100,29);
INSERT INTO ss_option_group VALUES (100,30);
INSERT INTO ss_option_group VALUES (100,31);
INSERT INTO ss_option_group VALUES (100,32);
INSERT INTO ss_option_group VALUES (100,33);
INSERT INTO ss_option_group VALUES (100,34);
INSERT INTO ss_option_group VALUES (100,35);
INSERT INTO ss_option_group VALUES (100,36);
INSERT INTO ss_option_group VALUES (100,37);
INSERT INTO ss_option_group VALUES (100,38);
INSERT INTO ss_option_group VALUES (100,39);
INSERT INTO ss_option_group VALUES (100,40);
INSERT INTO ss_option_group VALUES (100,41);
INSERT INTO ss_option_group VALUES (100,42);
INSERT INTO ss_option_group VALUES (100,43);
INSERT INTO ss_option_group VALUES (100,44);
INSERT INTO ss_option_group VALUES (100,45);
INSERT INTO ss_option_group VALUES (100,46);
INSERT INTO ss_option_group VALUES (100,47);
INSERT INTO ss_option_group VALUES (100,48);
INSERT INTO ss_option_group VALUES (100,49);
INSERT INTO ss_option_group VALUES (100,50);
INSERT INTO ss_option_group VALUES (100,51);
INSERT INTO ss_option_group VALUES (100,52);
INSERT INTO ss_option_group VALUES (100,53);
INSERT INTO ss_option_group VALUES (100,54);
INSERT INTO ss_option_group VALUES (100,55);
INSERT INTO ss_option_group VALUES (100,56);
INSERT INTO ss_option_group VALUES (100,57);
INSERT INTO ss_option_group VALUES (100,58);
INSERT INTO ss_option_group VALUES (100,59);
INSERT INTO ss_option_group VALUES (100,60);
INSERT INTO ss_option_group VALUES (100,61);
INSERT INTO ss_option_group VALUES (100,62);
INSERT INTO ss_option_group VALUES (100,63);
INSERT INTO ss_option_group VALUES (100,64);
INSERT INTO ss_option_group VALUES (100,65);
INSERT INTO ss_option_group VALUES (100,66);
INSERT INTO ss_option_group VALUES (100,67);
INSERT INTO ss_option_group VALUES (100,68);
INSERT INTO ss_option_group VALUES (100,69);
INSERT INTO ss_option_group VALUES (100,70);
INSERT INTO ss_option_group VALUES (100,71);
INSERT INTO ss_option_group VALUES (100,72);

INSERT INTO ss_option_company VALUES (28,'KFC');
INSERT INTO ss_option_company VALUES (29,'KFC');
INSERT INTO ss_option_company VALUES (30,'KFC');
INSERT INTO ss_option_company VALUES (31,'KFC');
INSERT INTO ss_option_company VALUES (32,'KFC'); 
INSERT INTO ss_option_company VALUES (34,'KFC');
INSERT INTO ss_option_company VALUES (35,'KFC');
INSERT INTO ss_option_company VALUES (41,'KFC');
INSERT INTO ss_option_company VALUES (43,'KFC');
INSERT INTO ss_option_company VALUES (44,'KFC');
INSERT INTO ss_option_company VALUES (45,'KFC');
INSERT INTO ss_option_company VALUES (46,'KFC');
INSERT INTO ss_option_company VALUES (47,'KFC');
INSERT INTO ss_option_company VALUES (48,'KFC');
INSERT INTO ss_option_company VALUES (49,'KFC');
INSERT INTO ss_option_company VALUES (52,'KFC');
INSERT INTO ss_option_company VALUES (53,'KFC');
INSERT INTO ss_option_company VALUES (54,'KFC');
INSERT INTO ss_option_company VALUES (55,'KFC');
INSERT INTO ss_option_company VALUES (56,'KFC');
INSERT INTO ss_option_company VALUES (61,'KFC');
INSERT INTO ss_option_company VALUES (62,'KFC');
INSERT INTO ss_option_company VALUES (63,'KFC');
INSERT INTO ss_option_company VALUES (69,'KFC');

INSERT INTO ss_option_time VALUES(28,50,50);
INSERT INTO ss_option_time VALUES(29,50,50);
INSERT INTO ss_option_time VALUES(30,50,50);
INSERT INTO ss_option_time VALUES(31,50,50);
INSERT INTO ss_option_time VALUES(32,50,50);
INSERT INTO ss_option_time VALUES(34,50,50);
INSERT INTO ss_option_time VALUES(35,50,50);
INSERT INTO ss_option_time VALUES(41,50,50);
INSERT INTO ss_option_time VALUES(43,50,50);
INSERT INTO ss_option_time VALUES(44,50,50);
INSERT INTO ss_option_time VALUES(45,50,50);
INSERT INTO ss_option_time VALUES(46,50,50);
INSERT INTO ss_option_time VALUES(47,50,50);
INSERT INTO ss_option_time VALUES(48,50,50);
INSERT INTO ss_option_time VALUES(49,50,50);
INSERT INTO ss_option_time VALUES(52,50,50); 
INSERT INTO ss_option_time VALUES(53,50,50);
INSERT INTO ss_option_time VALUES(54,50,50);
INSERT INTO ss_option_time VALUES(55,50,50);
INSERT INTO ss_option_time VALUES(56,50,50);
INSERT INTO ss_option_time VALUES(61,50,50);
INSERT INTO ss_option_time VALUES(62,50,50);
INSERT INTO ss_option_time VALUES(63,50,50);
INSERT INTO ss_option_time VALUES(69,50,50);

DROP VIEW ss_grl_vw_menu_struct;

CREATE VIEW ss_grl_vw_menu_struct AS


    SELECT user_id, cm.option_id, cm.option_org, cm.option_desc,
"substring"((cm.option_org)::text, 1, (length((cm.option_org)::text) - 2)) AS
father, CASE WHEN (cm.action_desc IS NULL) THEN (('show-menu=sm'::text ||
rtrim((cm.option_org)::text)))::character varying ELSE cm.action_desc END AS
"action", ci.icon_path, cm.target, text(oc.option_id) AS report_opts,
"isnull"(ss_grl_fn_get_exception(cm.option_id), ''::character varying) AS
report_exceptions, option_key,
"isnull"((ss_grl_fn_get_help_options(cm.option_id))::character varying,
''::character varying) AS help_options
FROM (((ss_cat_menu_option cm JOIN ss_option_group og ON ((cm.option_id =
og.option_id))) JOIN ss_user_group ug ON ((ug.group_id = og.group_id))) LEFT
JOIN ss_cat_icon ci ON ((cm.icon_id = ci.icon_id))   
LEFT JOIN ss_option_company oc ON (cm.option_id = oc.option_id AND oc.option_id=og.option_id)
) WHERE (visible = 1) 

UNION
SELECT user_id, cm.option_id, cm.option_org, cm.option_desc,
"substring"((cm.option_org)::text, 1, (length((cm.option_org)::text) - 2)) AS
father, CASE WHEN (cm.action_desc IS NULL) THEN (('show-menu=sm'::text ||
rtrim((cm.option_org)::text)))::character varying ELSE cm.action_desc END AS
"action", ci.icon_path, cm.target, '' AS report_opts,
"isnull"(ss_grl_fn_get_exception(cm.option_id), ''::character varying) AS
report_exceptions, option_key,
"isnull"((ss_grl_fn_get_help_options(cm.option_id))::character varying,
''::character varying) AS help_options FROM ((ss_cat_menu_option cm JOIN
ss_user_group ug ON ((cm.option_id = ug.option_id))) LEFT JOIN ss_cat_icon ci
ON ((cm.icon_id = ci.icon_id))) WHERE (visible = 1);

