-- ============================================================
-- SIGRE ERP - Tenant DB - Funciones y Procedimientos
-- Ejecutar DESPUÉS de toda la estructura de tablas (00 a 11)
-- y ANTES de la carga inicial de datos (seed/).
-- ============================================================
--
-- CONTENIDO:
--   finanzas.usp_fin_saldo_bancos() — Recálculo de saldos mensuales por cuenta bancaria
--
-- ============================================================

SET client_min_messages TO WARNING;
SET lock_timeout = '5s';
SET statement_timeout = '0';

-- ============================================================
-- finanzas.usp_fin_saldo_bancos()
--
-- Recalcula saldos mensuales acumulados por cuenta bancaria
-- a partir de asientos contables vinculados a movimientos
-- de caja/bancos.
--
-- Proceso:
--   1. Elimina registros no conciliados de saldo_banco_mes
--   2. Reinicia montos de registros conciliados
--   3. Agrega ingresos/egresos desde asientos contables
--   4. Rellena meses faltantes con saldo cero
--   5. Recalcula saldo acumulado cronológicamente
--
-- Origen: Oracle 11gR2 USP_FIN_SALDO_BANCOS
-- ============================================================
CREATE OR REPLACE FUNCTION finanzas.usp_fin_saldo_bancos()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    rec           RECORD;
    ln_saldo_mes  NUMERIC(18,4);
    ln_mes_next   INTEGER;
    ln_year_next  INTEGER;
    ln_year1      INTEGER;
    ln_year2      INTEGER;
    ln_count      INTEGER;
    ln_pen_id     BIGINT;
BEGIN
    ln_pen_id := core.fn_moneda_default_pen_id();

    -- --------------------------------------------------------
    -- 1. Eliminar registros no conciliados
    -- --------------------------------------------------------
    DELETE FROM finanzas.saldo_banco_mes
     WHERE saldo_conciliado = 0;

    -- --------------------------------------------------------
    -- 2. Reiniciar montos de registros conciliados
    -- --------------------------------------------------------
    UPDATE finanzas.saldo_banco_mes
       SET ingresos = 0,
           egresos  = 0,
           saldo    = 0;

    -- --------------------------------------------------------
    -- 3. Calcular ingresos/egresos por cuenta bancaria/año/mes
    --    Oracle: DECODE(flag_debhab,'D', amount, 0)
    --    PostgreSQL: debe/haber ya separan débito de crédito;
    --    se elige moneda nacional o extranjera según la cuenta.
    -- --------------------------------------------------------
    FOR rec IN
        SELECT bc.id                                          AS banco_cnta_id,
               EXTRACT(YEAR  FROM c.fecha)::INTEGER           AS ano,
               EXTRACT(MONTH FROM c.fecha)::INTEGER           AS mes,
               COALESCE(SUM(
                   CASE WHEN bc.moneda_id = ln_pen_id
                        THEN cad.debe
                        ELSE cad.debe_me
                   END
               ), 0)                                          AS total_ingresos,
               COALESCE(SUM(
                   CASE WHEN bc.moneda_id = ln_pen_id
                        THEN cad.haber
                        ELSE cad.haber_me
                   END
               ), 0)                                          AS total_egresos
          FROM contabilidad.cntbl_asiento      c
          JOIN finanzas.caja_bancos            cb  ON cb.cntbl_asiento_id = c.id
          JOIN contabilidad.cntbl_asiento_det  cad ON cad.cntbl_asiento_id = c.id
          JOIN finanzas.banco_cnta             bc  ON bc.id = cad.banco_cnta_id
         WHERE cb.flag_estado <> '0'
         GROUP BY bc.id,
                  EXTRACT(YEAR  FROM c.fecha),
                  EXTRACT(MONTH FROM c.fecha)
    LOOP
        UPDATE finanzas.saldo_banco_mes
           SET ingresos         = rec.total_ingresos,
               egresos          = rec.total_egresos,
               saldo            = rec.total_ingresos - rec.total_egresos
         WHERE banco_cnta_id = rec.banco_cnta_id
           AND ano           = rec.ano
           AND mes           = rec.mes;

        IF NOT FOUND THEN
            INSERT INTO finanzas.saldo_banco_mes
                   (banco_cnta_id, ano, mes, ingresos, egresos, saldo)
            VALUES (rec.banco_cnta_id, rec.ano, rec.mes,
                    rec.total_ingresos, rec.total_egresos,
                    rec.total_ingresos - rec.total_egresos);
        END IF;
    END LOOP;

    -- --------------------------------------------------------
    -- 4. Rellenar meses faltantes con saldo cero
    --    para cada cuenta dentro del rango global de años.
    -- --------------------------------------------------------
    FOR rec IN
        SELECT DISTINCT sbm.banco_cnta_id
          FROM finanzas.saldo_banco_mes sbm
    LOOP
        SELECT COALESCE(MIN(s.ano), 0),
               COALESCE(MAX(s.ano), 0)
          INTO ln_year1, ln_year2
          FROM finanzas.saldo_banco_mes s;

        FOR ln_year IN ln_year1 .. ln_year2 LOOP
            FOR ln_mes IN 1 .. 12 LOOP
                SELECT COUNT(*)
                  INTO ln_count
                  FROM finanzas.saldo_banco_mes sbm
                 WHERE sbm.banco_cnta_id = rec.banco_cnta_id
                   AND sbm.ano           = ln_year
                   AND sbm.mes           = ln_mes;

                IF ln_count = 0 THEN
                    INSERT INTO finanzas.saldo_banco_mes
                           (banco_cnta_id, ano, mes, ingresos, egresos, saldo, saldo_conciliado)
                    VALUES (rec.banco_cnta_id, ln_year, ln_mes, 0, 0, 0, 0);
                END IF;
            END LOOP;
        END LOOP;
    END LOOP;

    -- --------------------------------------------------------
    -- 5. Recalcular saldo acumulado cronológicamente
    --    Suma (ingresos - egresos) desde el inicio hasta
    --    el periodo actual para obtener el running total.
    -- --------------------------------------------------------
    FOR rec IN
        SELECT sbm.ano, sbm.mes, sbm.banco_cnta_id
          FROM finanzas.saldo_banco_mes sbm
         ORDER BY sbm.banco_cnta_id, sbm.ano, sbm.mes
    LOOP
        IF rec.mes = 12 THEN
            ln_mes_next  := 1;
            ln_year_next := rec.ano + 1;
        ELSE
            ln_mes_next  := rec.mes + 1;
            ln_year_next := rec.ano;
        END IF;

        SELECT COALESCE(SUM(s.ingresos - s.egresos), 0)
          INTO ln_saldo_mes
          FROM finanzas.saldo_banco_mes s
         WHERE s.banco_cnta_id = rec.banco_cnta_id
           AND (s.ano * 100 + s.mes) <= (rec.ano * 100 + rec.mes);

        UPDATE finanzas.saldo_banco_mes
           SET saldo            = ln_saldo_mes
         WHERE banco_cnta_id = rec.banco_cnta_id
           AND ano           = rec.ano
           AND mes           = rec.mes;

        IF NOT FOUND THEN
            INSERT INTO finanzas.saldo_banco_mes
                   (banco_cnta_id, ano, mes, ingresos, egresos, saldo)
            VALUES (rec.banco_cnta_id, ln_year_next, ln_mes_next,
                    0, 0, ln_saldo_mes);
        END IF;
    END LOOP;
END;
$$;

COMMENT ON FUNCTION finanzas.usp_fin_saldo_bancos() IS
    'Recalcula saldos mensuales acumulados por cuenta bancaria desde asientos contables. Origen: Oracle USP_FIN_SALDO_BANCOS.';

-- ============================================================
-- TRIGGERS DE almacen.vale_mov_det
-- Origen: Oracle 11gR2 — CANTABRIA.TIUB_ARTICULO_MOV,
--         CANTABRIA.TIB_ARTICULO_MOV, CANTABRIA.TUB_ARTICULO_MOV,
--         CANTABRIA.TDA_ARTICULO_MOV
-- PostgreSQL: TIUB_VALE_MOV_DET, TIB_VALE_MOV_DET,
--             TUB_VALE_MOV_DET, TDA_VALE_MOV_DET
--
-- Procesos implementados:
--   1. Validación datos entrada (precio/cantidad)
--   2. Validación artículo (existe, activo)
--   3. Validación lote
--   4. Validación referencia documental
--   5. Matriz contable
--   6. Precio promedio ponderado  → articulo_almacen.costo_promedio
--   7. Saldos articulo_almacen   → articulo_almacen.cantidad_disponible
--   9. Estado Orden de Compra    → compras.orden_compra.flag_estado
--  10. Estado Orden de Venta     → ventas.orden_venta.flag_estado
--  12. Saldos por lote           → articulo_almacen_lote.saldo
--  13. Saldos por posición       → articulo_almacen_posicion.cantidad_disponible
-- ============================================================

-- ============================================================
-- Procedimiento auxiliar: aplica (o revierte) los efectos de un
-- movimiento de almacén sobre tablas dependientes.
-- p_signo = +1 para INSERT/aplicar, -1 para DELETE/revertir.
-- ============================================================
CREATE OR REPLACE FUNCTION almacen._vmd_apply_effects(
    p_vale_mov_id       BIGINT,
    p_articulo_id       BIGINT,
    p_cant_procesada    NUMERIC,
    p_costo_unitario    NUMERIC,
    p_lote_pallet_id    BIGINT,
    p_ubicacion_alm_id  BIGINT,
    p_oc_det_id         BIGINT,
    p_ov_det_id         BIGINT,
    p_ot_det_id         BIGINT,
    p_flag_estado_det   VARCHAR,
    p_signo             INTEGER
) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_almacen_id        BIGINT;
    v_amt_id            BIGINT;
    v_tipo_ref          CHAR(1);
    v_oc_id             BIGINT;
    v_ov_id             BIGINT;
    v_tipo_mov          VARCHAR(10);

    v_fac_total         NUMERIC;
    v_fac_templa        NUMERIC;
    v_ajuste_valoriz    VARCHAR(1);
    v_sol_precio        VARCHAR(1);
    v_flag_contab       VARCHAR(1);
    v_tipo_mov_dev      VARCHAR(10);
    v_flag_clase_mov    VARCHAR(1);

    v_saldo_actual      NUMERIC;
    v_costo_prom        NUMERIC;
    v_saldo_nuevo       NUMERIC;
    v_costo_nuevo       NUMERIC;

    v_estado_doc        VARCHAR(1);
    v_cnt_abiertas      INTEGER;

    v_saldo_lote        NUMERIC;

    v_delta             NUMERIC;
BEGIN
    IF p_flag_estado_det = '0' THEN RETURN; END IF;
    IF p_cant_procesada <= 0 THEN RETURN; END IF;

    v_delta := p_cant_procesada * p_signo;

    SELECT vm.almacen_id, vm.articulo_mov_tipo_id, vm.tipo_referencia_origen,
           vm.orden_compra_id, vm.orden_venta_id
      INTO v_almacen_id, v_amt_id, v_tipo_ref,
           v_oc_id, v_ov_id
      FROM almacen.vale_mov vm
     WHERE vm.id = p_vale_mov_id;

    SELECT amt.factor_sldo_total, amt.factor_ctrl_templa,
           COALESCE(amt.flag_ajuste_valorizacion, '0'),
           COALESCE(amt.flag_solicita_precio, '0'),
           COALESCE(amt.flag_contabiliza, '0'),
           amt.tipo_mov_dev,
           amt.flag_clase_mov, amt.tipo_mov
      INTO v_fac_total, v_fac_templa,
           v_ajuste_valoriz, v_sol_precio,
           v_flag_contab, v_tipo_mov_dev,
           v_flag_clase_mov, v_tipo_mov
      FROM almacen.articulo_mov_tipo amt
     WHERE amt.id = v_amt_id;

    IF v_fac_total = 0 AND v_ajuste_valoriz = '0' THEN RETURN; END IF;

    -- ========================================================
    -- Precio promedio y saldo en articulo_almacen
    -- ========================================================
    SELECT COALESCE(aa.cantidad_disponible, 0), COALESCE(aa.costo_promedio, 0)
      INTO v_saldo_actual, v_costo_prom
      FROM almacen.articulo_almacen aa
     WHERE aa.almacen_id = v_almacen_id
       AND aa.articulo_id = p_articulo_id
       FOR UPDATE;

    IF NOT FOUND THEN
        v_saldo_actual := 0;
        v_costo_prom   := 0;
    END IF;

    v_costo_nuevo := v_costo_prom;

    IF v_ajuste_valoriz = '1' AND p_signo = 1 AND v_fac_total = 1 AND COALESCE(p_costo_unitario, 0) <> 0 THEN
        IF v_saldo_actual > 0 THEN
            v_costo_nuevo := (v_costo_prom * v_saldo_actual + p_costo_unitario) / v_saldo_actual;
        END IF;
    ELSIF v_ajuste_valoriz = '1' AND p_signo = -1 THEN
        IF v_saldo_actual > 0 THEN
            v_costo_nuevo := (v_costo_prom * v_saldo_actual - p_costo_unitario) / v_saldo_actual;
        END IF;
    ELSIF (v_flag_clase_mov = 'I' OR v_flag_clase_mov = 'P' OR v_sol_precio = '1') THEN
        IF p_signo = 1 THEN
            IF (v_saldo_actual + p_cant_procesada) <> 0 THEN
                v_costo_nuevo := (v_saldo_actual * v_costo_prom + p_cant_procesada * COALESCE(p_costo_unitario, 0))
                                 / (v_saldo_actual + p_cant_procesada);
            ELSE
                v_costo_nuevo := 0;
            END IF;
        ELSE
            IF (v_saldo_actual - p_cant_procesada) <> 0 THEN
                v_costo_nuevo := (v_saldo_actual * v_costo_prom - p_cant_procesada * COALESCE(p_costo_unitario, 0))
                                 / (v_saldo_actual - p_cant_procesada);
            ELSE
                v_costo_nuevo := 0;
            END IF;
        END IF;
    END IF;

    v_saldo_nuevo := v_saldo_actual + p_cant_procesada * v_fac_total * p_signo;

    IF v_saldo_nuevo < 0 AND p_signo = 1 THEN
        RAISE EXCEPTION 'Saldo negativo en articulo_almacen: saldo=%, delta=%, articulo_id=%, almacen_id=%',
            v_saldo_actual, p_cant_procesada * v_fac_total, p_articulo_id, v_almacen_id;
    END IF;

    UPDATE almacen.articulo_almacen
       SET cantidad_disponible = v_saldo_nuevo,
           costo_promedio      = GREATEST(COALESCE(v_costo_nuevo, 0), 0),
           ultima_actualizacion = NOW(),
           fec_modificacion    = NOW()
     WHERE almacen_id  = v_almacen_id
       AND articulo_id = p_articulo_id;

    IF NOT FOUND THEN
        IF v_fac_total * p_signo > 0 THEN
            INSERT INTO almacen.articulo_almacen
                   (almacen_id, articulo_id, cantidad_disponible, costo_promedio, ultima_actualizacion)
            VALUES (v_almacen_id, p_articulo_id, v_saldo_nuevo,
                    GREATEST(COALESCE(v_costo_nuevo, 0), 0), NOW());
        ELSE
            RAISE EXCEPTION 'articulo_almacen no existe para articulo_id=% almacen_id=% y el movimiento es una salida',
                p_articulo_id, v_almacen_id;
        END IF;
    END IF;

    -- ========================================================
    -- Orden de Traslado — actualizar cantidades despachada/recibida
    -- ========================================================
    IF p_ot_det_id IS NOT NULL AND v_fac_total <> 0 THEN
        IF v_fac_total * p_signo > 0 THEN
            UPDATE almacen.orden_traslado_det
               SET cantidad_recibida = COALESCE(cantidad_recibida, 0) + p_cant_procesada * p_signo
             WHERE id = p_ot_det_id;
        ELSE
            UPDATE almacen.orden_traslado_det
               SET cantidad_despachada = COALESCE(cantidad_despachada, 0) + p_cant_procesada * ABS(p_signo)
             WHERE id = p_ot_det_id;
        END IF;
    END IF;

    -- ========================================================
    -- Estado Orden de Compra
    -- ========================================================
    IF v_tipo_ref = 'I' AND v_oc_id IS NOT NULL THEN
        SELECT oc.flag_estado INTO v_estado_doc
          FROM compras.orden_compra oc
         WHERE oc.id = v_oc_id FOR UPDATE;

        IF v_estado_doc = '0' THEN
            RAISE EXCEPTION 'La Orden de Compra id=% está anulada', v_oc_id;
        END IF;

        SELECT COUNT(*) INTO v_cnt_abiertas
          FROM compras.orden_compra_det ocd
         WHERE ocd.orden_compra_id = v_oc_id
           AND ocd.flag_estado = '1'
           AND ocd.cant_procesada < ocd.cant_proyectada;

        UPDATE compras.orden_compra
           SET flag_estado = CASE WHEN v_cnt_abiertas = 0 THEN '2' ELSE '1' END,
               fec_modificacion = NOW()
         WHERE id = v_oc_id;
    END IF;

    -- ========================================================
    -- Estado Orden de Venta
    -- ========================================================
    IF v_tipo_ref = 'V' AND v_ov_id IS NOT NULL THEN
        SELECT ov.flag_estado INTO v_estado_doc
          FROM ventas.orden_venta ov
         WHERE ov.id = v_ov_id FOR UPDATE;

        IF v_estado_doc = '0' THEN
            RAISE EXCEPTION 'La Orden de Venta id=% está anulada', v_ov_id;
        END IF;

        SELECT COUNT(*) INTO v_cnt_abiertas
          FROM ventas.orden_venta_det ovd
         WHERE ovd.orden_venta_id = v_ov_id
           AND ovd.flag_estado = '1'
           AND ovd.cant_procesada < ovd.cant_proyectada;

        UPDATE ventas.orden_venta
           SET flag_estado = CASE WHEN v_cnt_abiertas = 0 THEN '2' ELSE '1' END,
               fec_modificacion = NOW()
         WHERE id = v_ov_id;
    END IF;

    -- ========================================================
    -- Saldos por lote — articulo_almacen_lote
    -- ========================================================
    IF p_lote_pallet_id IS NOT NULL AND v_fac_templa <> 0 THEN

        IF v_fac_templa * p_signo < 0 THEN
            SELECT COALESCE(aal.saldo, 0) INTO v_saldo_lote
              FROM almacen.articulo_almacen_lote aal
             WHERE aal.almacen_id    = v_almacen_id
               AND aal.articulo_id   = p_articulo_id
               AND aal.lote_pallet_id = p_lote_pallet_id
               FOR UPDATE;

            IF NOT FOUND THEN
                RAISE EXCEPTION 'No existe saldo por lote para articulo_id=%, almacen_id=%, lote_pallet_id=%',
                    p_articulo_id, v_almacen_id, p_lote_pallet_id;
            END IF;

            IF v_saldo_lote < p_cant_procesada AND p_signo = 1 THEN
                RAISE EXCEPTION 'Saldo por lote insuficiente: saldo=%, requerido=%, lote_pallet_id=%',
                    v_saldo_lote, p_cant_procesada, p_lote_pallet_id;
            END IF;
        END IF;

        UPDATE almacen.articulo_almacen_lote
           SET saldo              = saldo + p_cant_procesada * v_fac_templa * p_signo,
               cantidad_total     = CASE
                                      WHEN v_fac_templa * p_signo > 0
                                      THEN cantidad_total + p_cant_procesada * v_fac_templa * p_signo
                                      ELSE cantidad_total
                                    END,
               ultima_actualizacion = NOW(),
               fec_modificacion   = NOW()
         WHERE almacen_id    = v_almacen_id
           AND articulo_id   = p_articulo_id
           AND lote_pallet_id = p_lote_pallet_id;

        IF NOT FOUND THEN
            IF v_fac_templa * p_signo > 0 THEN
                INSERT INTO almacen.articulo_almacen_lote
                       (almacen_id, articulo_id, lote_pallet_id, cantidad_total, saldo)
                VALUES (v_almacen_id, p_articulo_id, p_lote_pallet_id,
                        p_cant_procesada, p_cant_procesada);
            ELSE
                RAISE EXCEPTION 'No existe saldo por lote para articulo_id=%, almacen_id=%, lote_pallet_id=%',
                    p_articulo_id, v_almacen_id, p_lote_pallet_id;
            END IF;
        END IF;
    END IF;

    -- ========================================================
    -- Saldos por posición — articulo_almacen_posicion
    -- ========================================================
    IF p_ubicacion_alm_id IS NOT NULL AND v_fac_total <> 0 THEN

        UPDATE almacen.articulo_almacen_posicion
           SET cantidad_disponible = cantidad_disponible + p_cant_procesada * v_fac_total * p_signo,
               ultima_actualizacion = NOW(),
               fec_modificacion    = NOW()
         WHERE ubicacion_almacen_id = p_ubicacion_alm_id
           AND articulo_id          = p_articulo_id;

        IF NOT FOUND THEN
            IF v_fac_total * p_signo > 0 THEN
                INSERT INTO almacen.articulo_almacen_posicion
                       (ubicacion_almacen_id, articulo_id, cantidad_disponible)
                VALUES (p_ubicacion_alm_id, p_articulo_id, p_cant_procesada * v_fac_total * p_signo);
            ELSE
                RAISE EXCEPTION 'No existe saldo por posición para articulo_id=%, ubicacion_almacen_id=%',
                    p_articulo_id, p_ubicacion_alm_id;
            END IF;
        END IF;
    END IF;

END;
$$;

-- ============================================================
-- TIUB_VALE_MOV_DET — BEFORE INSERT OR UPDATE
-- Validaciones básicas de datos de entrada
-- ============================================================
CREATE OR REPLACE FUNCTION almacen.fn_tiub_vale_mov_det()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.costo_unitario IS NOT NULL AND NEW.costo_unitario < 0 THEN
        NEW.costo_unitario := 0;
    END IF;

    IF NEW.cant_procesada < 0 THEN
        RAISE EXCEPTION 'La cantidad procesada no puede ser negativa: vale_mov_id=%, articulo_id=%',
            NEW.vale_mov_id, NEW.articulo_id;
    END IF;

    RETURN NEW;
END;
$$;

-- ============================================================
-- TIB_VALE_MOV_DET — BEFORE INSERT
-- Lógica principal al insertar un detalle de movimiento
-- ============================================================
CREATE OR REPLACE FUNCTION almacen.fn_tib_vale_mov_det()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_almacen_id     BIGINT;
    v_amt_id         BIGINT;
    v_tipo_ref       CHAR(1);
    v_flag_contab    VARCHAR(1);
    v_flag_clase_mov VARCHAR(1);
    v_fac_total      NUMERIC;
    v_fac_templa     NUMERIC;
    v_tipo_mov_dev   VARCHAR(10);
    v_fac_total_dev  NUMERIC;
    v_tipo_mov       VARCHAR(10);
    v_art_estado     VARCHAR(1);
    v_cnt            INTEGER;
BEGIN
    NEW.precio_unit_ant := COALESCE(NEW.costo_unitario, 0);
    IF NEW.peso_neto_tm IS NULL THEN NEW.peso_neto_tm := 0; END IF;

    IF NEW.flag_estado = '0' THEN RETURN NEW; END IF;

    SELECT vm.almacen_id, vm.articulo_mov_tipo_id, vm.tipo_referencia_origen
      INTO v_almacen_id, v_amt_id, v_tipo_ref
      FROM almacen.vale_mov vm
     WHERE vm.id = NEW.vale_mov_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe vale_mov con id=%', NEW.vale_mov_id;
    END IF;

    SELECT amt.factor_sldo_total, amt.factor_ctrl_templa,
           COALESCE(amt.flag_contabiliza, '0'), amt.flag_clase_mov,
           amt.tipo_mov_dev, amt.tipo_mov
      INTO v_fac_total, v_fac_templa,
           v_flag_contab, v_flag_clase_mov,
           v_tipo_mov_dev, v_tipo_mov
      FROM almacen.articulo_mov_tipo amt
     WHERE amt.id = v_amt_id;

    IF v_tipo_mov_dev IS NOT NULL THEN
        IF v_tipo_mov_dev = v_tipo_mov THEN
            RAISE EXCEPTION 'tipo_mov (%) no puede ser devolución de sí mismo', v_tipo_mov;
        END IF;

        SELECT COALESCE(amt2.factor_sldo_total, 0)
          INTO v_fac_total_dev
          FROM almacen.articulo_mov_tipo amt2
         WHERE amt2.tipo_mov = v_tipo_mov_dev;

        IF v_fac_total_dev = 0 THEN
            RAISE EXCEPTION 'tipo_mov_dev (%) no tiene factor_sldo_total definido', v_tipo_mov_dev;
        END IF;

        IF v_fac_total_dev = v_fac_total THEN
            RAISE EXCEPTION 'tipo_mov (%) y tipo_mov_dev (%) tienen el mismo factor_sldo_total', v_tipo_mov, v_tipo_mov_dev;
        END IF;
    END IF;

    SELECT a.flag_estado INTO v_art_estado
      FROM core.articulo a WHERE a.id = NEW.articulo_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Artículo id=% no existe', NEW.articulo_id;
    END IF;

    IF v_art_estado = '0' THEN
        RAISE EXCEPTION 'Artículo id=% está inactivo', NEW.articulo_id;
    END IF;

    IF v_flag_contab = '1' AND NEW.matriz_contable_id IS NULL THEN
        RAISE EXCEPTION 'Tipo de movimiento % se contabiliza pero no tiene matriz contable, articulo_id=%',
            v_tipo_mov, NEW.articulo_id;
    END IF;

    IF NEW.lote_pallet_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_cnt
          FROM almacen.lote_pallet lp
         WHERE lp.id = NEW.lote_pallet_id;

        IF v_cnt = 0 THEN
            RAISE EXCEPTION 'Lote/pallet id=% no existe', NEW.lote_pallet_id;
        END IF;

        IF v_fac_templa = 0 THEN
            RAISE EXCEPTION 'Tipo de movimiento % no tiene activo el factor de lote pero se indicó lote_pallet_id=%',
                v_tipo_mov, NEW.lote_pallet_id;
        END IF;
    END IF;

    PERFORM almacen._vmd_apply_effects(
        NEW.vale_mov_id, NEW.articulo_id, NEW.cant_procesada, COALESCE(NEW.costo_unitario, 0),
        NEW.lote_pallet_id, NEW.ubicacion_almacen_id,
        NEW.oc_det_id, NEW.orden_venta_det_id, NEW.orden_traslado_det_id,
        NEW.flag_estado, 1
    );

    RETURN NEW;
END;
$$;

-- ============================================================
-- TUB_VALE_MOV_DET — BEFORE UPDATE
-- Reversa el OLD y aplica el NEW (dos fases)
-- ============================================================
CREATE OR REPLACE FUNCTION almacen.fn_tub_vale_mov_det()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_almacen_id     BIGINT;
    v_amt_id         BIGINT;
    v_tipo_ref       CHAR(1);
    v_flag_contab    VARCHAR(1);
    v_tipo_mov       VARCHAR(10);
    v_tipo_mov_dev   VARCHAR(10);
    v_fac_templa     NUMERIC;
    v_art_estado     VARCHAR(1);
    v_cnt            INTEGER;
    v_fac_total_dev  NUMERIC;
    v_fac_total      NUMERIC;
    v_flag_clase_mov VARCHAR(1);
BEGIN
    NEW.fec_modificacion := NOW();

    IF OLD.flag_estado = '0' AND NEW.flag_estado = '0' THEN RETURN NEW; END IF;

    IF OLD.flag_estado <> '0' THEN
        PERFORM almacen._vmd_apply_effects(
            OLD.vale_mov_id, OLD.articulo_id, OLD.cant_procesada, COALESCE(OLD.costo_unitario, 0),
            OLD.lote_pallet_id, OLD.ubicacion_almacen_id,
            OLD.oc_det_id, OLD.orden_venta_det_id, OLD.orden_traslado_det_id,
            OLD.flag_estado, -1
        );
    END IF;

    IF NEW.flag_estado = '0' THEN
        NEW.precio_unit_ant := COALESCE(NEW.costo_unitario, 0);
        RETURN NEW;
    END IF;

    NEW.precio_unit_ant := COALESCE(NEW.costo_unitario, 0);
    IF NEW.peso_neto_tm IS NULL THEN NEW.peso_neto_tm := 0; END IF;

    SELECT vm.almacen_id, vm.articulo_mov_tipo_id, vm.tipo_referencia_origen
      INTO v_almacen_id, v_amt_id, v_tipo_ref
      FROM almacen.vale_mov vm WHERE vm.id = NEW.vale_mov_id;

    SELECT amt.factor_sldo_total, amt.factor_ctrl_templa,
           COALESCE(amt.flag_contabiliza, '0'), amt.flag_clase_mov,
           amt.tipo_mov_dev, amt.tipo_mov
      INTO v_fac_total, v_fac_templa,
           v_flag_contab, v_flag_clase_mov,
           v_tipo_mov_dev, v_tipo_mov
      FROM almacen.articulo_mov_tipo amt WHERE amt.id = v_amt_id;

    IF v_tipo_mov_dev IS NOT NULL THEN
        IF v_tipo_mov_dev = v_tipo_mov THEN
            RAISE EXCEPTION 'tipo_mov (%) no puede ser devolución de sí mismo', v_tipo_mov;
        END IF;
        SELECT COALESCE(amt2.factor_sldo_total, 0) INTO v_fac_total_dev
          FROM almacen.articulo_mov_tipo amt2 WHERE amt2.tipo_mov = v_tipo_mov_dev;
        IF v_fac_total_dev = 0 THEN
            RAISE EXCEPTION 'tipo_mov_dev (%) sin factor_sldo_total', v_tipo_mov_dev;
        END IF;
        IF v_fac_total_dev = v_fac_total THEN
            RAISE EXCEPTION 'tipo_mov y tipo_mov_dev tienen mismo factor_sldo_total';
        END IF;
    END IF;

    SELECT a.flag_estado INTO v_art_estado FROM core.articulo a WHERE a.id = NEW.articulo_id;
    IF NOT FOUND THEN RAISE EXCEPTION 'Artículo id=% no existe', NEW.articulo_id; END IF;
    IF v_art_estado = '0' THEN RAISE EXCEPTION 'Artículo id=% inactivo', NEW.articulo_id; END IF;

    IF v_flag_contab = '1' AND NEW.matriz_contable_id IS NULL THEN
        RAISE EXCEPTION 'Falta matriz contable para tipo_mov %, articulo_id=%', v_tipo_mov, NEW.articulo_id;
    END IF;

    IF NEW.lote_pallet_id IS NOT NULL THEN
        SELECT COUNT(*) INTO v_cnt FROM almacen.lote_pallet lp WHERE lp.id = NEW.lote_pallet_id;
        IF v_cnt = 0 THEN RAISE EXCEPTION 'Lote id=% no existe', NEW.lote_pallet_id; END IF;
        IF v_fac_templa = 0 THEN
            RAISE EXCEPTION 'tipo_mov % sin factor lote pero se indicó lote_pallet_id=%', v_tipo_mov, NEW.lote_pallet_id;
        END IF;
    END IF;

    PERFORM almacen._vmd_apply_effects(
        NEW.vale_mov_id, NEW.articulo_id, NEW.cant_procesada, COALESCE(NEW.costo_unitario, 0),
        NEW.lote_pallet_id, NEW.ubicacion_almacen_id,
        NEW.oc_det_id, NEW.orden_venta_det_id, NEW.orden_traslado_det_id,
        NEW.flag_estado, 1
    );

    RETURN NEW;
END;
$$;

-- ============================================================
-- TDA_VALE_MOV_DET — AFTER DELETE
-- Reversa todos los efectos del registro eliminado
-- ============================================================
CREATE OR REPLACE FUNCTION almacen.fn_tda_vale_mov_det()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.flag_estado = '0' THEN RETURN OLD; END IF;

    PERFORM almacen._vmd_apply_effects(
        OLD.vale_mov_id, OLD.articulo_id, OLD.cant_procesada, COALESCE(OLD.costo_unitario, 0),
        OLD.lote_pallet_id, OLD.ubicacion_almacen_id,
        OLD.oc_det_id, OLD.orden_venta_det_id, OLD.orden_traslado_det_id,
        OLD.flag_estado, -1
    );

    RETURN OLD;
END;
$$;

-- ============================================================
-- TRIGGERS en almacen.vale_mov_det
-- Convención de nombres: T{evento}{timing}_{tabla}
--   T = Trigger, I = Insert, U = Update, D = Delete
--   B = Before, A = After
-- Orden ejecución PostgreSQL: alfabético dentro del mismo timing.
-- ============================================================

DROP TRIGGER IF EXISTS trg_vale_mov_det_01_biu ON almacen.vale_mov_det;
DROP TRIGGER IF EXISTS trg_vale_mov_det_02_bi ON almacen.vale_mov_det;
DROP TRIGGER IF EXISTS trg_vale_mov_det_02_bu ON almacen.vale_mov_det;
DROP TRIGGER IF EXISTS trg_vale_mov_det_03_ad ON almacen.vale_mov_det;

DROP TRIGGER IF EXISTS TIUB_VALE_MOV_DET ON almacen.vale_mov_det;
CREATE TRIGGER TIUB_VALE_MOV_DET
    BEFORE INSERT OR UPDATE ON almacen.vale_mov_det
    FOR EACH ROW
    EXECUTE FUNCTION almacen.fn_tiub_vale_mov_det();

DROP TRIGGER IF EXISTS TIB_VALE_MOV_DET ON almacen.vale_mov_det;
CREATE TRIGGER TIB_VALE_MOV_DET
    BEFORE INSERT ON almacen.vale_mov_det
    FOR EACH ROW
    EXECUTE FUNCTION almacen.fn_tib_vale_mov_det();

DROP TRIGGER IF EXISTS TUB_VALE_MOV_DET ON almacen.vale_mov_det;
CREATE TRIGGER TUB_VALE_MOV_DET
    BEFORE UPDATE ON almacen.vale_mov_det
    FOR EACH ROW
    EXECUTE FUNCTION almacen.fn_tub_vale_mov_det();

DROP TRIGGER IF EXISTS TAD_VALE_MOV_DET ON almacen.vale_mov_det;
DROP TRIGGER IF EXISTS TDA_VALE_MOV_DET ON almacen.vale_mov_det;
CREATE TRIGGER TDA_VALE_MOV_DET
    AFTER DELETE ON almacen.vale_mov_det
    FOR EACH ROW
    EXECUTE FUNCTION almacen.fn_tda_vale_mov_det();

-- core.fn_tasa_cambio_calendario(fecha, id_moneda_origen, id_moneda_destino): definida en 01-core.sql
