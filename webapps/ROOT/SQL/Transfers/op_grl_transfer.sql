-- Tabla de transferencias

CREATE SEQUENCE transfer_seq;

CREATE TABLE op_grl_transfer (
  transfer_id INTEGER NOT NULL DEFAULT nextval('transfer_seq'),
  local_store_id SMALLINT NOT NULL,
  neighbor_store_id SMALLINT NOT NULL,
  date_id TIMESTAMP NULL,
  transfer_type SMALLINT NULL,
  PRIMARY KEY(transfer_id),

  FOREIGN KEY(local_store_id) REFERENCES ss_cat_store(store_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,

  FOREIGN KEY(neighbor_store_id)
    REFERENCES ss_cat_neighbor_store(store_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);

