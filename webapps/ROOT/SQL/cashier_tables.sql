CREATE table mk_items_marketin as SELECT menu_item, menu_item_desc FROM sus_menu_items limit 1;
DELETE FROM mk_items_marketin;
INSERT INTO mk_items_marketin SELECT menu_item, menu_item_desc FROM sus_menu_items
WHERE menu_item IN ('015326','015327','015328','015329','015332','015333','015330','015331','015322','015323','015324','015325');
