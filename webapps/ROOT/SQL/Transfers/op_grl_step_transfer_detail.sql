-- Tabla de paso para el detalle de transferencia

CREATE TABLE op_grl_step_transfer_detail (
  transfer_id INTEGER NOT NULL,
  inv_id CHAR(6) NOT NULL,
  stock_code_id CHAR(6) NOT NULL,
  provider_product_code character(10),
  provider_quantity DECIMAL(12,2) NOT NULL DEFAULT 0,
  inventory_quantity DECIMAL(12,2) NOT NULL DEFAULT 0,
  prv_conversion_factor DECIMAL(12,2) NOT NULL DEFAULT 0,
  provider_unit_measure CHAR(50) NULL,
  inventory_unit_measure CHAR(50) NULL,
  provider_id character(10),
  existence float,

  FOREIGN KEY(inv_id)
    REFERENCES op_grl_cat_inventory(inv_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE,

  FOREIGN KEY(transfer_id)
    REFERENCES op_grl_step_transfer(transfer_id)
      ON DELETE CASCADE
      ON UPDATE CASCADE
);


