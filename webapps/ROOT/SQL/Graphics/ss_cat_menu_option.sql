
DELETE FROM ss_option_group;
DELETE FROM ss_option_company;
DELETE FROM ss_option_time;

DELETE FROM ss_cat_menu_option;

SELECT setval('ss_cat_menu_option_option_id_seq',1, false);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('20','Inventario',NULL,NULL,NULL,20,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('2030','Control de Ordenes de Compra',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('2050','Control de Inventario',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('203015','Orden de Compra','/Inventory/PurchaseOrder/Entry/OrderYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('205010','Transferencias de entrada/salida','/Inventory/Transfers/Entry/TransferYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('205020','Inventario semanal','/Inventory/WeeklyInventory/Entry/InventoryYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('50','Ingresos y gastos',NULL,NULL,NULL,50,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('5030','Semivariables',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('503010','Captura de facturas','/IncomeAndExpense/Semivariable/Entry/InvoiceMasterYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('503020','Reportes','/IncomeAndExpense/Semivariable/Rpt/InvoiceReportYum.jsp','ifrMainContainer',NULL,500,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('60','Estadisticas',NULL,NULL,NULL,30,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('6030','Estadisticas diarias',NULL,NULL,NULL,NULL,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('603020','Piezas por transaccion','/Graphics/PiecesAndTransactions/Rpt/PiecesReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('603030','No. transacciones','/Graphics/PiecesAndTransactions/Rpt/TransactionsReportYum.jsp','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('603040','Indice transacciones por fecha','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=date','ifrMainContainer',NULL,510,1);

INSERT INTO ss_cat_menu_option (option_org, option_desc, action_desc, target, option_key, icon_id, visible) 
VALUES ('603050','Indice transacciones por dia','/Graphics/PiecesAndTransactions/Rpt/TransactionsIndexReportYum.jsp?type=day','ifrMainContainer',NULL,510,1);

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

INSERT INTO ss_option_company VALUES (10,'KFC');
INSERT INTO ss_option_company VALUES (13,'KFC');
INSERT INTO ss_option_company VALUES (14,'KFC');
INSERT INTO ss_option_company VALUES (15,'KFC');
INSERT INTO ss_option_company VALUES (16,'KFC');

INSERT INTO ss_option_time VALUES(10,50,50);
INSERT INTO ss_option_time VALUES(13,50,50);
INSERT INTO ss_option_time VALUES(14,50,50);
INSERT INTO ss_option_time VALUES(15,50,50);
INSERT INTO ss_option_time VALUES(16,50,50);

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

