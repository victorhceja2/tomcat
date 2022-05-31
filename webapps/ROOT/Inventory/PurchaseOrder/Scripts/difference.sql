-- Querie del código
SELECT i.inv_desc as Product,
CAST(od.provider_product_code as char) as order_product_code,
Ltrim(to_char(od.prv_required_quantity,9999990.99)||' '||m.unit_name) as order_required,
to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end)),9999990.99)||' '||rtrim(vwm.unit_name) as order_equivalent,
Ltrim(to_char(od.prv_required_quantity*od.unit_cost,9999990.99)) as ord_cost,
CAST(rd.provider_product_code as char) as recep_product_code,
Ltrim(to_char(rd.received_quantity,9999990.99)||' '||m.unit_name) as recep_required,
to_char(ROUND((Case When rd.received_quantity = Null then 0 else rd.received_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)),9999990.99)||' '||rtrim(vwm.unit_name) as recep_equivalent,
Ltrim(to_char(rd.received_quantity*rd.unit_cost,9999990.99)) as rec_cost,
dif_desc,
to_char(rd.received_quantity - od.prv_required_quantity,9999990.99)||' '||m.unit_name as dif_prv,
to_char((rd.received_quantity -od.prv_required_quantity)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end),9999990.99)||' '||vwm.unit_name as dif_inv
FROM op_grl_order_detail od
INNER JOIN op_grl_reception r ON r.order_id=od.order_id
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = CAST(od.provider_unit as char)
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10038
AND (rd.received_quantity -od.prv_required_quantity) <> 0
UNION
SELECT i.inv_desc as Product,
CAST('' as char) as order_product_code,
CAST('' as char) as order_required,
CAST('' as char) as order_equivalent,
CAST('' as char) as ord_cost,
CAST(rd.provider_product_code as char) as recep_product_code,
Ltrim(to_char(rd.received_quantity,9999990.99)||' '||m.unit_name) as recep_required,
to_char(ROUND((Case When rd.received_quantity = Null then 0 else rd.received_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)),9999990.99)||' '||rtrim(vwm.unit_name) as recep_equivalent,
Ltrim(to_char(rd.received_quantity*rd.unit_cost,9999990.99)) as rec_cost,
dif_desc,
to_char(rd.received_quantity,9999990.99)||' '||m.unit_name as dif_prv,
to_char((rd.received_quantity)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end),9999990.99)||' '||vwm.unit_name as dif_inv
FROM op_grl_reception r
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id )
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rd.provider_product_code
INNER JOIN op_grl_cat_inveod.prv_required_quantity*od.unit_costntory i ON i.inv_id=p.inv_id
INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = cast(p.provider_unit_measure as char)
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10038 AND rd.provider_product_code not in
(select od.provider_product_code FROM op_grl_order_detail od
INNER JOIN op_grl_reception r ON r.order_id=od.order_id
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10038 )
ORDER BY 4 ASC,7 ASC




SELECT CAST('' as char) as Product,
CAST('' as char) as order_product_code,
CAST('' as char) as order_required,
CAST('Total orden' as char) as order_equivalent,
SUM(od.prv_required_quantity*od.unit_cost) as ord_cost
FROM op_grl_order_detail od
INNER JOIN op_grl_reception r ON r.order_id=od.order_id
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = CAST(od.provider_unit as char)
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10038
AND (rd.received_quantity -od.prv_required_quantity) <> 0



-- Querie para generar el archivo
SELECT
r.reception_id as reception_id,
r.document_num as document_num,
r.remission_id as remission_id,
r.order_id as order_id,
r.store_id as store_id,
r.date_id as date_id,
p.inv_id as inv_id,
rd.provider_id as provider_id,
p.stock_code_id as stock_code_id_ord,
p.provider_product_code as provider_product_code_ord,
p1.stock_code_id as stock_code_id_rec,
p1.provider_product_code as provider_product_code_rec,
rd.received_quantity as received_quantity,
m.unit_name as unit_prov,
d.difference_id as difference_id,
r.report_num as report_num
FROM op_grl_order_detail od
INNER JOIN op_grl_reception r ON r.order_id=od.order_id
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = CAST(od.provider_unit as char)
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10048
AND (rd.received_quantity -od.prv_required_quantity) <> 0

UNION

SELECT
r.reception_id as reception_id,
r.document_num as document_num,
r.remission_id as remission_id,
r.order_id as order_id,
r.store_id as store_id,
r.date_id as date_id,
p.inv_id as inv_id,
rd.provider_id as provider_id,
CAST('' as char) as stock_code_id_ord,
CAST('' as char) as provider_product_code_ord,
p.stock_code_id as stock_code_id_rec,
p.provider_product_code as provider_product_code_rec,
rd.received_quantity as received_quantity,
m.unit_name as unit_prov,
d.difference_id as difference_id,
r.report_num as report_num
FROM op_grl_reception r
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id )
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=rd.provider_product_code
INNER JOIN op_grl_cat_providers_product p1 ON p1.provider_product_code=rd.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id
INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = cast(p.provider_unit_measure as char)
INNER JOIN op_grl_cat_unit_measurprovider_product_codee vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10048 AND rd.provider_product_code not in
(select od.provider_product_code FROM op_grl_order_detail od
INNER JOIN op_grl_reception r ON r.order_id=od.order_id
INNER JOIN op_grl_reception_detail rd ON(r.reception_id=rd.reception_id AND rd.provider_product_code=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id INNER JOIN op_grl_cat_difference d ON d.difference_id = rd.difference_id
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.reception_id =10048 )
ORDER BY 4 ASC,7 ASC





-- Query para reporte de remisiones
SELECT i.inv_desc as product,
CAST(rd.provider_product_code_order as char) as order_product_code,
Ltrim(to_char(od.prv_required_quantity,9999990.99)||' '||m.unit_name) as order_required,
to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end)),9999990.99)||' '||rtrim(vwm.unit_name) as order_equivalent,
Ltrim(to_char(od.prv_required_quantity*od.unit_cost,9999990.99)) as ord_cost,
CAST(rd.provider_product_code_remis as char) as remis_product_code,
Ltrim(to_char(rd.required_quantity,9999990.99)||' '||m1.unit_name) as remis_qty,
to_char(ROUND((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)),9999990.99)||' '||rtrim(vwm.unit_name) as remis_equivalent,
Ltrim(to_char(rd.required_quantity*rd.unit_cost,9999990.99)) as remis_cost,
Ltrim(to_char(rd.required_quantity*rd.unit_cost - od.prv_required_quantity*od.unit_cost,9999990.99))  as dif_cost,
to_char((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)-(Case When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end),9999990.99)||' '||rtrim(vwm.unit_name) as dif_inv
FROM op_grl_order_detail od
INNER JOIN op_grl_remission r ON r.order_id=od.order_id
INNER JOIN op_grl_remission_detail rd ON(r.remission_id=rd.remission_id AND rd.provider_product_code_order=od.provider_product_code)
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id
INNER JOIN op_grl_cat_unit_measure m ON cast(m.unit_id as char) = CAST(od.provider_unit as char)
INNER JOIN op_grl_cat_unit_measure m1 ON cast(m1.unit_id as char) = CAST(rd.unit_measure_remis as char)
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE rd.remission_id ='R006'

UNION

--Para obtener los elementos de la orden que no estan en la remisión
SELECT DISTINCT i.inv_desc as product,
CAST(od.provider_product_code as char) as order_product_code,
Ltrim(to_char(od.prv_required_quantity,9999990.99)||' '||m.unit_name) as order_required,
to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else od.inv_required_quantity end)),9999990.99)||' '||rtrim(vwm.unit_name) as order_equivalent,
Ltrim(to_char(od.prv_required_quantity*od.unit_cost,9999990.99)) as ord_cost,
CAST('' as char) as remis_product_code,
CAST('' as char) as remis_qty,
CAST('' as char) as remis_equivalent,
CAST('' as char) as remis_cost,
Ltrim(to_char(-od.prv_required_quantity*od.unit_cost,9999990.99)) as dif_cost,
to_char(ROUND((Case When od.inv_required_quantity = Null then 0 else -od.inv_required_quantity end)),9999990.99)||' '||rtrim(vwm.unit_name) as dif_inv
FROM op_grl_order_detail od
FULL OUTER JOIN op_grl_remission r ON r.order_id = od.order_id
INNER JOIN op_grl_remission_detail rd ON rd.remission_id = r.remission_id
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code =od.provider_product_code
INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id
INNER JOIN op_grl_cat_unit_measure m ON m.unit_id=p.provider_unit_measure
INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
WHERE r.remission_id='R006' AND od.provider_product_code not in (
SELECT od.provider_product_code FROM op_grl_order_detail od
	INNER JOIN op_grl_remission r ON r.order_id=od.order_id
	INNER JOIN op_grl_remission_detail rd ON(r.remission_id=rd.remission_id AND rd.provider_product_code_order = od.provider_product_code)
	INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
	INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id
	INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
	WHERE rd.remission_id ='R006'
)

UNION

-- Para obtener los elementos de la remisión que no están en la orden
SELECT
DISTINCT(Case rd.difference when  't' then '<img src=\"/Images/Menu/red_button.gif\">' end),
i.inv_desc as product,
CAST('' as char) as order_product_code,
CAST('' as char) as order_required,
CAST('' as char) as order_equivalent,
CAST('' as char) as order_cost,
CAST(rd.provider_product_code_remis as char) as remis_product_code,
Ltrim(to_char(rd.required_quantity,9999990.99)||' '||m.unit_name) as remis_qty,
to_char(ROUND((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)),9999990.99)||' '||rtrim(vwm.unit_name) as remis_equivalent,
Ltrim(to_char(rd.required_quantity*rd.unit_cost,9999990.99)) as remis_cost,
Ltrim(to_char(rd.required_quantity*rd.unit_cost,9999990.99)) as dif_cost,
to_char(ROUND((Case When rd.required_quantity = Null then 0 else rd.required_quantity end)*(Case When p.conversion_factor = Null then 0 else p.conversion_factor end)),9999990.99)||' '||rtrim(vwm.unit_name) as dif_inv
FROM op_grl_remission_detail rd
INNER JOIN op_grl_remission r ON r.remission_id = rd.remission_id
FULL OUTER JOIN op_grl_order_detail od  ON od.order_id = r.order_id
INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code =rd.provider_product_code_remis
INNER JOIN op_grl_cat_inventory i ON i.inv_id = p.inv_id
INNER JOIN op_grl_cat_unit_measure m ON m.unit_id = p.provider_unit_measure
INNER JOIN op_grl_cat_unit_measure vwm ON vwm.unit_id = i.inv_unit_measure
WHERE r.remission_id='R006' AND rd.provider_product_code_remis NOT IN(
SELECT od.provider_product_code FROM op_grl_order_detail od
	INNER JOIN op_grl_remission r ON r.order_id=od.order_id
	INNER JOIN op_grl_remission_detail rd ON(r.remission_id=rd.remission_id AND rd.provider_product_code_order = od.provider_product_code)
	INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
	INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id
	INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
	WHERE rd.remission_id ='R006'
)

UNION

SELECT CAST('' as char),
CAST('' as char),
CAST('' as char),
CAST('Total orden' as char),
Ltrim(to_char(SUM(od.prv_required_quantity*od.unit_cost),9999990.99)) as total_cost,
CAST('' as char),
CAST('' as char),
CAST('Total remisi&oacute;n' as char)
--SUM(rd.required_quantity*rd.unit_cost)
FROM op_grl_order_detail od
WHERE od.order_id ='10028'


SELECT
Ltrim(to_char(SUM(od.prv_required_quantity*od.unit_cost),9999990.99)) as total_cost,
SUM(rd.required_quantity*rd.unit_cost)
FROM op_grl_order_detail od, op_grl_remission_detail rd
WHERE od.provider_product_code in
(SELECT provider_product_code
FROM op_grl_order_detail
WHERE od.order_id ='10028')
AND rd.provider_product_code_remis in
(SELECT provider_product_code_remis
FROM op_grl_remission_detail
WHERE rd.remission_id='R006');




-- Para obtener totales

ORDER BY 2 ASC, 6 ASC


-- Subquery
SELECT od.provider_product_code FROM op_grl_order_detail od
	INNER JOIN op_grl_remission r ON r.order_id=od.order_id
	INNER JOIN op_grl_remission_detail rd ON(r.remission_id=rd.remission_id AND rd.provider_product_code_remis = od.provider_product_code)
	INNER JOIN op_grl_cat_providers_product p ON p.provider_product_code=od.provider_product_code
	INNER JOIN op_grl_cat_inventory i ON i.inv_id=p.inv_id
	INNER JOIN op_grl_cat_unit_measure vwm ON cast(vwm.unit_id as char) = cast(i.inv_unit_measure as char)
	WHERE rd.remission_id ='R006'


			lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
		lsQuery += " ";
