
--ALTER TABLE gc_delivery DROP CONSTRAINT fk_delivery;

ALTER TABLE gc_delivery ADD CONSTRAINT fk_delivery FOREIGN KEY (store_id,client)
REFERENCES sus_clients (store_id,client) ON UPDATE CASCADE ON DELETE NO ACTION;
