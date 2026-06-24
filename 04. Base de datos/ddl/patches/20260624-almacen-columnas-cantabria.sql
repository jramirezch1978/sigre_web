-- PATCH: columnas almacen.almacen alineadas con CANTABRIA.ALMACEN (tablas_cantabria.sql)
-- cencos → centros_costo_id, prov_almacen → proveedor_entidad_id, ubigeo_org → ubigeo

ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS centros_costo_id BIGINT;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS proveedor_entidad_id BIGINT;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS responsable_usuario_id BIGINT;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS direccion VARCHAR(80);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS area_total NUMERIC(7, 2);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS vol_total NUMERIC(7, 2);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS corr_guia BIGINT;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS cod_origen VARCHAR(2);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS flag_cntrl_lote VARCHAR(1) DEFAULT '1';
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS flag_replicacion VARCHAR(1) DEFAULT '1';
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS distrito VARCHAR(25);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS provincia VARCHAR(25);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS departamento VARCHAR(25);
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS distrito_id BIGINT;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS ano_apertura INTEGER;
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS cod_sunat VARCHAR(4) DEFAULT '0001';
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS flag_virtual VARCHAR(1) DEFAULT '0';
ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS ubigeo VARCHAR(6);

UPDATE almacen.almacen SET cod_sunat = '0001' WHERE cod_sunat IS NULL;
UPDATE almacen.almacen SET flag_cntrl_lote = '1' WHERE flag_cntrl_lote IS NULL;
UPDATE almacen.almacen SET flag_replicacion = '1' WHERE flag_replicacion IS NULL;
UPDATE almacen.almacen SET flag_virtual = '0' WHERE flag_virtual IS NULL;

ALTER TABLE almacen.almacen ALTER COLUMN cod_sunat SET DEFAULT '0001';
ALTER TABLE almacen.almacen ALTER COLUMN cod_sunat SET NOT NULL;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_almacen_proveedor_entidad') THEN
        ALTER TABLE almacen.almacen
            ADD CONSTRAINT fk_almacen_proveedor_entidad
            FOREIGN KEY (proveedor_entidad_id) REFERENCES core.entidad_contribuyente(id);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_almacen_distrito') THEN
        ALTER TABLE almacen.almacen
            ADD CONSTRAINT fk_almacen_distrito
            FOREIGN KEY (distrito_id) REFERENCES core.distrito(id);
    END IF;
END $$;

DO $$ BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk_almacen_centros_costo') THEN
        ALTER TABLE almacen.almacen
            ADD CONSTRAINT fk_almacen_centros_costo
            FOREIGN KEY (centros_costo_id) REFERENCES contabilidad.centros_costo(id);
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS ix_almacen_centros_costo ON almacen.almacen (centros_costo_id);
CREATE INDEX IF NOT EXISTS ix_almacen_proveedor ON almacen.almacen (proveedor_entidad_id);
CREATE INDEX IF NOT EXISTS ix_almacen_distrito ON almacen.almacen (distrito_id);
