-- Tabla de paso para transferencias

CREATE TABLE op_grl_step_transfer (
  transfer_id INTEGER NOT NULL DEFAULT nextval('transfer_seq'),
  local_store_id SMALLINT NOT NULL,
  neighbor_store_id SMALLINT,
  date_id TIMESTAMP,
  transfer_type SMALLINT,
  PRIMARY KEY(transfer_id) );

