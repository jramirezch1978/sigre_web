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


-- ============================================================
-- RRHH — Motor de calculo de planilla (port SIGRE)
--
-- Contexto: rÃ©gimen general EMP (empleados sueldo fijo).
-- Puerto a partir del anÃ¡lisis de SIGRE usp_rh_cal_calcula_planilla.
-- Sin pesca, sin tripulantes, sin destajeros.
--
-- InvocaciÃ³n desde ms-rrhh:
--   CALL rrhh.sp_calcular_planilla(p_origen, p_fec_proceso, p_tipo_planilla_codigo);
--
-- Orden de despliegue:
--   1. Funciones auxiliares (fn_*)
--   2. Sub-procedimientos (sp_cal_*)
--   3. Orquestador principal (sp_calcular_planilla)
-- ============================================================

-- ============================================================
-- HELPERS INTERNOS
-- ============================================================

-- Resuelve el id de tipo_concepto_calculo por cÃ³digo ('INGRESO','DESCUENTO','APORTE')
-- Se llama desde todos los sub-SPs para escribir calculo_det.
CREATE OR REPLACE FUNCTION rrhh._fn_tipo_concepto_id(p_codigo VARCHAR)
RETURNS BIGINT
LANGUAGE sql STABLE AS $$
    SELECT id FROM rrhh.tipo_concepto_calculo WHERE codigo = p_codigo LIMIT 1;
$$;

-- Resuelve o crea un concepto_planilla por cÃ³digo.
-- p_codigo: cÃ³digo numÃ©rico string ('1001', '2201', etc.)
-- Devuelve id de rrhh.concepto_planilla.
CREATE OR REPLACE FUNCTION rrhh._fn_concepto_id(p_codigo VARCHAR)
RETURNS BIGINT
LANGUAGE plpgsql AS $$
DECLARE
    v_id BIGINT;
BEGIN
    SELECT id INTO v_id FROM rrhh.concepto_planilla WHERE codigo = p_codigo;
    IF v_id IS NULL THEN
        -- Concepto no encontrado; error claro para el administrador
        RAISE EXCEPTION 'concepto_planilla con codigo=% no existe. Verificar seed.', p_codigo;
    END IF;
    RETURN v_id;
END;
$$;

-- Devuelve valor_texto de config.configuracion o NULL
CREATE OR REPLACE FUNCTION rrhh._cfg_txt(p_source VARCHAR, p_param VARCHAR)
RETURNS TEXT
LANGUAGE sql STABLE AS $$
    SELECT valor_texto FROM config.configuracion
     WHERE modulo = p_source AND parametro = p_param AND activo = TRUE LIMIT 1;
$$;

-- Devuelve valor_entero de config.configuracion o default_val
CREATE OR REPLACE FUNCTION rrhh._cfg_int(p_source VARCHAR, p_param VARCHAR, p_default INTEGER DEFAULT NULL)
RETURNS INTEGER
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(valor_entero, p_default)
      FROM config.configuracion
     WHERE modulo = p_source AND parametro = p_param AND activo = TRUE LIMIT 1;
$$;

-- Devuelve valor_decimal de config.configuracion
CREATE OR REPLACE FUNCTION rrhh._cfg_dec(p_source VARCHAR, p_param VARCHAR, p_default NUMERIC DEFAULT NULL)
RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(valor_decimal, p_default)
      FROM config.configuracion
     WHERE modulo = p_source AND parametro = p_param AND activo = TRUE LIMIT 1;
$$;

-- CÃ³digo SIGRE (TEXT preferido; fallback valor_entero legacy) para concepto_planilla o grupo_calculo.
CREATE OR REPLACE FUNCTION rrhh._cfg_codigo(
    p_source VARCHAR, p_param VARCHAR, p_default TEXT DEFAULT NULL
) RETURNS TEXT
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(
        (SELECT COALESCE(
            NULLIF(TRIM(c.valor_texto), ''),
            NULLIF(TRIM(c.valor_entero::TEXT), '')
        )
           FROM config.configuracion c
          WHERE c.modulo = p_source AND c.parametro = p_param AND c.activo = TRUE
          LIMIT 1),
        NULLIF(TRIM(p_default), '')
    );
$$;

-- CÃ³digo de grupo_calculo (VARCHAR(3)): lee config como TEXT y normaliza dÃ­gitos cortos a 3 posiciones.
CREATE OR REPLACE FUNCTION rrhh._cfg_grupo_codigo(
    p_source VARCHAR, p_param VARCHAR, p_default TEXT DEFAULT NULL
) RETURNS VARCHAR(3)
LANGUAGE plpgsql STABLE AS $$
DECLARE
    v_raw TEXT;
BEGIN
    v_raw := rrhh._cfg_codigo(p_source, p_param, p_default);
    IF v_raw IS NULL THEN
        RETURN NULL;
    END IF;
    IF v_raw ~ '^\d+$' AND LENGTH(v_raw) < 3 THEN
        RETURN LPAD(v_raw, 3, '0');
    END IF;
    RETURN v_raw;
END;
$$;

-- Upsert en calculo_det (INSERT o UPDATE segÃºn UQ calculo_id + concepto_id + item).
-- p_tipo: 'INGRESO', 'DESCUENTO' o 'APORTE'
CREATE OR REPLACE FUNCTION rrhh._upsert_det(
    p_calculo_id        BIGINT,
    p_concepto_id       BIGINT,
    p_item              SMALLINT,
    p_imp_soles         NUMERIC,
    p_imp_dolar         NUMERIC,
    p_dias_trabajados   NUMERIC DEFAULT NULL,
    p_tipo              VARCHAR DEFAULT 'INGRESO'
) RETURNS VOID
LANGUAGE plpgsql AS $$
DECLARE
    v_tipo_id BIGINT;
BEGIN
    v_tipo_id := rrhh._fn_tipo_concepto_id(p_tipo);

    INSERT INTO rrhh.calculo_det
        (calculo_id, concepto_id, item, imp_soles, imp_dolar, dias_trabajados,
         tipo_concepto_calculo_id, flag_estado, fec_creacion)
    VALUES
        (p_calculo_id, p_concepto_id, p_item,
         ROUND(p_imp_soles, 2), ROUND(p_imp_dolar, 5),
         p_dias_trabajados, v_tipo_id, '1', NOW())
    ON CONFLICT (calculo_id, concepto_id, item)
    DO UPDATE SET
        imp_soles           = ROUND(EXCLUDED.imp_soles, 2),
        imp_dolar           = ROUND(EXCLUDED.imp_dolar, 5),
        dias_trabajados     = COALESCE(EXCLUDED.dias_trabajados, rrhh.calculo_det.dias_trabajados),
        fec_modificacion    = NOW();
END;
$$;

-- ============================================================
-- Helpers motor planilla EMP (SIGRE â†’ PostgreSQL)
-- ============================================================
CREATE OR REPLACE FUNCTION rrhh._cfg_grupo_id(
    p_source VARCHAR, p_param VARCHAR, p_default TEXT DEFAULT NULL
) RETURNS BIGINT
LANGUAGE sql STABLE AS $$
    SELECT gc.id
      FROM rrhh.grupo_calculo gc
     WHERE gc.codigo = rrhh._cfg_grupo_codigo(p_source, p_param, p_default)
     LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION rrhh._grupo_concepto_gen_id(p_grupo_id BIGINT)
RETURNS BIGINT
LANGUAGE sql STABLE AS $$
    SELECT concepto_gen_id FROM rrhh.grupo_calculo WHERE id = p_grupo_id LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION rrhh._sum_gan_fijo_grupo(p_trabajador_id BIGINT, p_grupo_id BIGINT)
RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(SUM(gdf.imp_gan_desc), 0)
      FROM rrhh.gan_desct_fijo gdf
     WHERE gdf.trabajador_id = p_trabajador_id
       AND gdf.flag_estado   = '1'
       AND gdf.concepto_id IN (
           SELECT gcd.concepto_planilla_id
             FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = p_grupo_id AND gcd.flag_estado = '1'
       );
$$;

CREATE OR REPLACE FUNCTION rrhh._sum_det_grupo(
    p_calculo_id BIGINT, p_grupo_id BIGINT, p_tipo VARCHAR DEFAULT NULL
) RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      FROM rrhh.calculo_det cd
      LEFT JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND cd.concepto_id IN (
           SELECT gcd.concepto_planilla_id
             FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = p_grupo_id AND gcd.flag_estado = '1'
       )
       AND (p_tipo IS NULL OR tcc.codigo = p_tipo);
$$;

CREATE OR REPLACE FUNCTION rrhh._sum_det_codigo(p_calculo_id BIGINT, p_concepto_cod VARCHAR)
RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      FROM rrhh.calculo_det cd
      JOIN rrhh.concepto_planilla cp ON cp.id = cd.concepto_id
     WHERE cd.calculo_id = p_calculo_id AND cp.codigo = p_concepto_cod;
$$;

CREATE OR REPLACE FUNCTION rrhh._sum_hist_grupo(
    p_trabajador_id    BIGINT,
    p_grupo_id         BIGINT,
    p_fec_proceso      DATE,
    p_meses            INTEGER,
    p_tipo_planilla_id BIGINT
) RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      FROM rrhh.calculo c
      JOIN rrhh.calculo_det cd ON cd.calculo_id = c.id
     WHERE c.trabajador_id     = p_trabajador_id
       AND c.tipo_planilla_id  = p_tipo_planilla_id
       AND c.fec_proceso       < p_fec_proceso
       AND c.fec_proceso       >= (p_fec_proceso - (p_meses || ' months')::INTERVAL)
       AND cd.concepto_id IN (
           SELECT gcd.concepto_planilla_id
             FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = p_grupo_id AND gcd.flag_estado = '1'
       )
       AND cd.imp_soles <> 0;
$$;

CREATE OR REPLACE FUNCTION rrhh._rem_basica(p_trabajador_id BIGINT)
RETURNS NUMERIC
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(SUM(gdf.imp_gan_desc), 0)
      FROM rrhh.gan_desct_fijo gdf
      JOIN rrhh.grupo_calculo_det gcd ON gcd.concepto_planilla_id = gdf.concepto_id
      JOIN rrhh.grupo_calculo gc ON gc.id = gcd.grupo_calculo_id
     WHERE gdf.trabajador_id = p_trabajador_id
       AND gdf.flag_estado     = '1'
       AND gc.codigo           = '010'
       AND gcd.flag_estado     = '1';
$$;

CREATE OR REPLACE FUNCTION rrhh._rmv_trabajador(p_trabajador_id BIGINT, p_fec_proceso DATE)
RETURNS NUMERIC
LANGUAGE plpgsql STABLE AS $$
DECLARE
    v_tipo_id BIGINT;
    v_rmv     NUMERIC := 0;
BEGIN
    SELECT tipo_trabajador_id INTO v_tipo_id
      FROM rrhh.trabajador WHERE id = p_trabajador_id;

    SELECT COALESCE(rmv.rmv, 0)
      INTO v_rmv
      FROM rrhh.remuneracion_minima_vital rmv
     WHERE rmv.tipo_trabajador_id = v_tipo_id
       AND rmv.fecha_desde        <= p_fec_proceso
     ORDER BY rmv.fecha_desde DESC
     LIMIT 1;

    RETURN COALESCE(v_rmv, 0);
END;
$$;

CREATE OR REPLACE FUNCTION rrhh._flag_ingreso_boleta(p_trabajador_id BIGINT)
RETURNS VARCHAR
LANGUAGE sql STABLE AS $$
    SELECT COALESCE(tt.flag_ingreso_boleta, 'S')
      FROM rrhh.trabajador t
      JOIN rrhh.tipo_trabajador tt ON tt.id = t.tipo_trabajador_id
     WHERE t.id = p_trabajador_id
     LIMIT 1;
$$;

-- ============================================================
-- fn_dias_trabajados
-- Port: SIGRE usf_rh_cal_dias_trabajados (EMP sueldo fijo)
-- Devuelve dÃ­as a pagar en el perÃ­odo [p_fec_inicio, p_fec_final].
-- ============================================================
CREATE OR REPLACE FUNCTION rrhh.fn_dias_trabajados(
    p_trabajador_id BIGINT,
    p_fec_inicio    DATE,
    p_fec_final     DATE,
    p_dias_mes      INTEGER DEFAULT 30
) RETURNS NUMERIC
LANGUAGE plpgsql STABLE AS $$
DECLARE
    v_fec_ingreso   DATE;
    v_fec_cese      DATE;
    v_desde         DATE;
    v_hasta         DATE;
    v_dias          NUMERIC;
    v_faltas        NUMERIC := 0;
    rec             RECORD;
BEGIN
    -- Leer fechas del trabajador
    SELECT fecha_ingreso, fecha_cese
      INTO v_fec_ingreso, v_fec_cese
      FROM rrhh.trabajador
     WHERE id = p_trabajador_id;

    -- Acotar rango por fec_ingreso y fec_cese
    v_desde := GREATEST(p_fec_inicio,  COALESCE(v_fec_ingreso, p_fec_inicio));
    v_hasta := LEAST   (p_fec_final,   COALESCE(v_fec_cese,    p_fec_final));

    -- Si el trabajador no aplica al perÃ­odo â†’ 0
    IF v_desde > v_hasta THEN
        RETURN 0;
    END IF;

    -- DÃ­as en el rango
    v_dias := (v_hasta - v_desde) + 1;

    -- Ajuste febrero: si fec_hasta es el Ãºltimo dÃ­a del mes de feb â†’ 30 dÃ­as
    IF EXTRACT(MONTH FROM v_hasta) = 2
       AND v_hasta = (DATE_TRUNC('MONTH', v_hasta) + INTERVAL '1 month - 1 day')::DATE
    THEN
        v_dias := 30;
    END IF;

    -- No superar dÃ­as_mes
    v_dias := LEAST(v_dias, p_dias_mes);

    -- Sumar faltas del grupo DIAS_INASIS_DSCCONT + concepto vacaciones (SIGRE usf_rh_cal_dias_trabajados)
    SELECT COALESCE(SUM(i.dias_inasistencia), 0)
      INTO v_faltas
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND i.flag_estado   IN ('1','2','3','4')
       AND COALESCE(i.flag_vacaciones_adelantadas, '0') = '0'
       AND COALESCE(i.fecha_movimiento, i.fecha_desde) BETWEEN v_desde AND v_hasta
       AND (
           i.concepto_planilla_id IN (
               SELECT gcd.concepto_planilla_id
                 FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'DIAS_INASIS_DSCCONT', '008')
                  AND gcd.flag_estado = '1'
           )
           OR i.concepto_planilla_id = rrhh._grupo_concepto_gen_id(
               rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'GAN_FIJ_CALC_VACAC', '003')
           )
       );

    RETURN GREATEST(v_dias - v_faltas, 0);
END;
$$;

-- ============================================================
-- fn_calcular_impuesto_5ta
-- Port: SIGRE PKG_RRHH.sp_cal_quinta_categ_sueldo (simplificado EMP)
-- Devuelve la RETENCIÃ“N MENSUAL de quinta categorÃ­a.
-- ============================================================
CREATE OR REPLACE FUNCTION rrhh.fn_calcular_impuesto_5ta(
    p_trabajador_id   BIGINT,
    p_fec_proceso     DATE,
    p_rem_mensual     NUMERIC,   -- remuneraciÃ³n computable del mes
    p_tipo_planilla_id BIGINT
) RETURNS NUMERIC
LANGUAGE plpgsql STABLE AS $$
DECLARE
    v_anio              INTEGER;
    v_mes               INTEGER;
    v_meses_rest        INTEGER;
    v_uit               NUMERIC;
    v_ded_anual         NUMERIC;   -- 7 UIT
    v_rem_acum          NUMERIC := 0;
    v_rem_proyectada    NUMERIC;
    v_renta_neta        NUMERIC;
    v_impuesto_anual    NUMERIC := 0;
    v_imp_ant           NUMERIC := 0;  -- retenido meses anteriores
    v_retencion_mes     NUMERIC;
    rec                 RECORD;
BEGIN
    v_anio   := EXTRACT(YEAR  FROM p_fec_proceso)::INTEGER;
    v_mes    := EXTRACT(MONTH FROM p_fec_proceso)::INTEGER;
    v_meses_rest := 13 - v_mes;   -- meses restantes incluyendo el actual

    -- UIT vigente (Ãºltima antes de la fecha de proceso)
    SELECT COALESCE(valor_uit, 5150)
      INTO v_uit
      FROM core.uit
     WHERE anio <= v_anio
     ORDER BY anio DESC LIMIT 1;

    -- DeducciÃ³n anual: 7 UIT
    v_ded_anual := 7 * v_uit;

    -- Remuneraciones acumuladas del aÃ±o (meses anteriores al actual)
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_rem_acum
      FROM rrhh.calculo c
      JOIN rrhh.calculo_det cd ON cd.calculo_id = c.id
      JOIN rrhh.concepto_planilla cp ON cp.id = cd.concepto_id
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE c.trabajador_id     = p_trabajador_id
       AND c.tipo_planilla_id  = p_tipo_planilla_id
       AND c.anio              = v_anio
       AND c.mes               < v_mes
       AND tcc.codigo          = 'INGRESO'
       AND cp.flag_reporte_quinta = '1';

    -- Renta proyectada = acumulado + (rem_mensual Ã— meses restantes)
    v_rem_proyectada := v_rem_acum + (p_rem_mensual * v_meses_rest);

    -- Renta neta anual (despuÃ©s de deducciÃ³n 7 UIT)
    v_renta_neta := v_rem_proyectada - v_ded_anual;

    IF v_renta_neta <= 0 THEN
        RETURN 0;
    END IF;

    -- Escala progresiva desde rrhh.impuesto_renta_tramos (vigente a la fecha)
    v_impuesto_anual := 0;
    FOR rec IN
        SELECT tasa, tope_ini, tope_fin
          FROM rrhh.impuesto_renta_tramos
         WHERE fecha_vig_ini <= p_fec_proceso
           AND (fecha_vig_fin IS NULL OR fecha_vig_fin >= p_fec_proceso)
           AND flag_estado = '1'
         ORDER BY tope_ini ASC
    LOOP
        IF v_renta_neta > rec.tope_ini * v_uit THEN
            DECLARE
                v_base_tramo NUMERIC;
                v_tope_sup   NUMERIC;
            BEGIN
                v_tope_sup   := CASE WHEN rec.tope_fin = 0 THEN v_renta_neta
                                     ELSE rec.tope_fin * v_uit END;
                v_base_tramo := LEAST(v_renta_neta, v_tope_sup) - (rec.tope_ini * v_uit);
                v_impuesto_anual := v_impuesto_anual + (v_base_tramo * rec.tasa / 100);
            END;
        END IF;
    END LOOP;

    -- Retenciones previas del aÃ±o (rem_retencion = retenciÃ³n mensual calculada)
    SELECT COALESCE(SUM(qc.rem_retencion), 0)
      INTO v_imp_ant
      FROM rrhh.quinta_categoria qc
     WHERE qc.trabajador_id               = p_trabajador_id
       AND EXTRACT(YEAR  FROM qc.fec_proceso) = v_anio
       AND EXTRACT(MONTH FROM qc.fec_proceso) < v_mes;

    -- RetenciÃ³n del mes = (impuesto anual - ya retenido) / meses restantes
    v_retencion_mes := GREATEST((v_impuesto_anual - v_imp_ant) / v_meses_rest, 0);

    RETURN ROUND(v_retencion_mes, 2);
END;
$$;

-- ============================================================
-- sp_cal_borra_movimiento
-- Limpia calculo + calculo_det del trabajador para el perÃ­odo,
-- permitiendo reprocesar sin duplicar lÃ­neas.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_borra_movimiento(
    p_trabajador_id   BIGINT,
    p_fec_proceso     DATE,
    p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_calculo_id BIGINT;
BEGIN
    SELECT id INTO v_calculo_id
      FROM rrhh.calculo
     WHERE trabajador_id    = p_trabajador_id
       AND fec_proceso      = p_fec_proceso
       AND tipo_planilla_id = p_tipo_planilla_id
     LIMIT 1;

    IF v_calculo_id IS NOT NULL THEN
        DELETE FROM rrhh.calculo_det WHERE calculo_id = v_calculo_id;
        DELETE FROM rrhh.calculo     WHERE id         = v_calculo_id;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_ganancias_fijas
-- Port: SIGRE usp_rh_cal_ganancias_fijas (rama sueldo EMP)
-- Lee gan_desct_fijo del trabajador en el grupo de ganancias fijas,
-- prorratea por dÃ­as trabajados y escribe en calculo_det.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_ganancias_fijas(
    p_calculo_id        BIGINT,
    p_trabajador_id     BIGINT,
    p_fec_inicio        DATE,
    p_fec_final         DATE,
    p_dias_trabajados   NUMERIC,
    p_dias_mes          INTEGER,
    p_tipo_cambio       NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_gan_fija_cod  VARCHAR;
    v_grp_gan_fija_id   BIGINT;
    v_item              SMALLINT := 1;
    rec                 RECORD;
    v_imp_prorrateado   NUMERIC;
BEGIN
    -- Grupo ganancias fijas desde RRHHPARAM (GRC_GNN_FIJA = 10 â†’ cÃ³digo '010')
    v_grp_gan_fija_cod := rrhh._cfg_grupo_codigo('RRHHPARAM', 'GRC_GNN_FIJA', '010');
    SELECT id INTO v_grp_gan_fija_id FROM rrhh.grupo_calculo WHERE codigo = v_grp_gan_fija_cod;

    IF v_grp_gan_fija_id IS NULL THEN RETURN; END IF;

    FOR rec IN
        SELECT gdf.concepto_id,
               gdf.imp_gan_desc,
               cp.codigo AS concepto_codigo,
               cp.flag_reporte_quinta
          FROM rrhh.gan_desct_fijo gdf
          JOIN rrhh.concepto_planilla cp ON cp.id = gdf.concepto_id
         WHERE gdf.trabajador_id = p_trabajador_id
           AND gdf.flag_estado   = '1'
           AND gdf.concepto_id IN (
               SELECT gcd.concepto_planilla_id
                 FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_gan_fija_id
                  AND gcd.flag_estado = '1'
           )
         ORDER BY cp.codigo
    LOOP
        -- Prorrateo: imp_fijo / dias_mes Ã— dias_trabajados
        v_imp_prorrateado := ROUND(
            COALESCE(rec.imp_gan_desc, 0) / p_dias_mes * p_dias_trabajados,
            2);

        -- Solo registrar si importe > 0
        IF v_imp_prorrateado <> 0 THEN
            PERFORM rrhh._upsert_det(
                p_calculo_id,
                rec.concepto_id,
                v_item,
                v_imp_prorrateado,
                ROUND(v_imp_prorrateado / p_tipo_cambio, 5),
                p_dias_trabajados,
                'INGRESO');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_asig_familiar
-- Port: SIGRE usp_rh_cal_asig_familiar (EMP sueldo â€” sin prorrateo)
-- Lee el concepto asignaciÃ³n familiar de gan_desct_fijo; no prorratea.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_asig_familiar(
    p_calculo_id      BIGINT,
    p_trabajador_id   BIGINT,
    p_tipo_cambio     NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_af_id     BIGINT;
    rec             RECORD;
BEGIN
    SELECT rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'GAN_FIJ_CALC_VACAC', '003') INTO v_grp_af_id;

    IF v_grp_af_id IS NULL THEN RETURN; END IF;

    FOR rec IN
        SELECT gdf.concepto_id, COALESCE(gdf.imp_gan_desc, 0) AS monto
          FROM rrhh.gan_desct_fijo gdf
         WHERE gdf.trabajador_id = p_trabajador_id
           AND gdf.flag_estado   = '1'
           AND gdf.concepto_id IN (
               SELECT gcd.concepto_planilla_id
                 FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_af_id
                  AND gcd.flag_estado = '1'
           )
    LOOP
        IF rec.monto <> 0 THEN
            PERFORM rrhh._upsert_det(
                p_calculo_id, rec.concepto_id, 1,
                rec.monto,
                ROUND(rec.monto / p_tipo_cambio, 5),
                NULL, 'INGRESO');
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_prom_remun_vacac
-- Port: SIGRE usp_rh_cal_prom_remun_vacac
-- Escribe en gan_desct_variable (promedio remuneraciÃ³n vacacional).
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_prom_remun_vacac(
    p_trabajador_id     BIGINT,
    p_fec_proceso       DATE,
    p_tipo_planilla_id  BIGINT,
    p_created_by        BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_prom_id       BIGINT;
    v_grp_vac_id        BIGINT;
    v_concepto_prom_id  BIGINT;
    v_concepto_vac_id   BIGINT;
    v_dias_vaca         NUMERIC := 0;
    v_promedio          NUMERIC := 0;
    v_acu               NUMERIC;
    v_imp_mes           NUMERIC;
    v_num_mes           INTEGER;
    v_ran_ini           DATE;
    v_ran_fin           DATE;
    rec                 RECORD;
    x                   INTEGER;
BEGIN
    v_grp_prom_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'PROM_REMUN_VACAC', '806');
    v_grp_vac_id  := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'GAN_FIJ_CALC_VACAC', '003');

    IF v_grp_prom_id IS NULL OR v_grp_vac_id IS NULL THEN RETURN; END IF;

    v_concepto_prom_id := rrhh._grupo_concepto_gen_id(v_grp_prom_id);
    v_concepto_vac_id  := rrhh._grupo_concepto_gen_id(v_grp_vac_id);

    IF v_concepto_prom_id IS NULL OR v_concepto_vac_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(SUM(i.dias_inasistencia), 0)
      INTO v_dias_vaca
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND i.concepto_planilla_id = v_concepto_vac_id;

    IF v_dias_vaca <= 0 THEN RETURN; END IF;

    FOR rec IN
        SELECT gcd.concepto_planilla_id
          FROM rrhh.grupo_calculo_det gcd
         WHERE gcd.grupo_calculo_id = v_grp_prom_id AND gcd.flag_estado = '1'
    LOOP
        v_ran_ini := (p_fec_proceso - INTERVAL '1 month')::DATE;
        v_num_mes := 0;
        v_acu     := 0;

        FOR x IN 1..6 LOOP
            v_ran_fin := v_ran_ini;
            v_ran_ini := (v_ran_fin - INTERVAL '1 month' + INTERVAL '1 day')::DATE;

            SELECT COALESCE(SUM(cd.imp_soles), 0)
              INTO v_imp_mes
              FROM rrhh.calculo c
              JOIN rrhh.calculo_det cd ON cd.calculo_id = c.id
             WHERE c.trabajador_id    = p_trabajador_id
               AND c.tipo_planilla_id = p_tipo_planilla_id
               AND cd.concepto_id     = rec.concepto_planilla_id
               AND c.fec_proceso BETWEEN v_ran_ini AND v_ran_fin;

            IF v_imp_mes > 0 THEN
                v_num_mes := v_num_mes + 1;
                v_acu     := v_acu + v_imp_mes;
            END IF;
            v_ran_ini := (v_ran_ini - INTERVAL '1 day')::DATE;
        END LOOP;

        IF v_num_mes > 2 THEN
            v_promedio := v_promedio + (v_acu / 6.0);
        END IF;
    END LOOP;

    v_promedio := ROUND(v_promedio / 30.0 * v_dias_vaca, 2);

    IF v_promedio > 0 THEN
        INSERT INTO rrhh.gan_desct_variable
            (trabajador_id, fec_movim, concepto_id, imp_var, tipo_planilla_id, created_by, fec_creacion)
        VALUES
            (p_trabajador_id, p_fec_proceso, v_concepto_prom_id, v_promedio, p_tipo_planilla_id, p_created_by, NOW());
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_add_diferi_quincena
-- Port: SIGRE usp_rh_cal_add_diferi_quincena
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_add_diferi_quincena(
    p_trabajador_id     BIGINT,
    p_fec_proceso       DATE,
    p_created_by        BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    rec RECORD;
BEGIN
    DELETE FROM rrhh.gan_desct_variable gdv
     WHERE gdv.trabajador_id = p_trabajador_id
       AND gdv.concepto_id IN (
           SELECT aq.concepto_planilla_id
             FROM rrhh.adelanto_quincena aq
            WHERE aq.trabajador_id = p_trabajador_id
              AND COALESCE(aq.imp_adelanto, 0) <> 0
              AND aq.fec_proceso = p_fec_proceso
       );

    FOR rec IN
        SELECT aq.concepto_planilla_id, aq.fec_proceso, aq.imp_adelanto
          FROM rrhh.adelanto_quincena aq
         WHERE aq.trabajador_id = p_trabajador_id
           AND COALESCE(aq.imp_adelanto, 0) <> 0
           AND TO_CHAR(aq.fec_proceso, 'YYYYMM') = TO_CHAR(p_fec_proceso, 'YYYYMM')
    LOOP
        IF EXISTS (
            SELECT 1 FROM rrhh.gan_desct_variable gdv
             WHERE gdv.trabajador_id = p_trabajador_id
               AND gdv.fec_movim     = rec.fec_proceso
               AND gdv.concepto_id   = rec.concepto_planilla_id
        ) THEN
            UPDATE rrhh.gan_desct_variable
               SET imp_var = rec.imp_adelanto, fec_modificacion = NOW()
             WHERE trabajador_id = p_trabajador_id
               AND fec_movim     = rec.fec_proceso
               AND concepto_id   = rec.concepto_planilla_id;
        ELSE
            INSERT INTO rrhh.gan_desct_variable
                (trabajador_id, fec_movim, concepto_id, imp_var, created_by, fec_creacion)
            VALUES
                (p_trabajador_id, rec.fec_proceso, rec.concepto_planilla_id,
                 rec.imp_adelanto, p_created_by, NOW());
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_ganancias_variables
-- Port: SIGRE usp_rh_cal_ganancias_variables
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_ganancias_variables(
    p_calculo_id        BIGINT,
    p_trabajador_id     BIGINT,
    p_fec_inicio        DATE,
    p_fec_final         DATE,
    p_tipo_cambio       NUMERIC,
    p_tipo_planilla_id  BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_rem_basica    NUMERIC;
    v_item          SMALLINT := 100;
    rec             RECORD;
    v_monto         NUMERIC;
BEGIN
    v_rem_basica := rrhh._rem_basica(p_trabajador_id);

    FOR rec IN
        SELECT gdv.concepto_id,
               COALESCE(gdv.imp_var, 0)   AS imp_var,
               COALESCE(gdv.nro_horas, 0) AS nro_horas,
               COALESCE(gdv.nro_dias, 0)  AS nro_dias,
               COALESCE(cp.factor_pago, 1)  AS factor_pago
          FROM rrhh.gan_desct_variable gdv
          JOIN rrhh.concepto_planilla cp ON cp.id = gdv.concepto_id
         WHERE gdv.trabajador_id    = p_trabajador_id
           AND gdv.fec_movim       BETWEEN p_fec_inicio AND p_fec_final
           AND (gdv.tipo_planilla_id IS NULL OR gdv.tipo_planilla_id = p_tipo_planilla_id)
           AND cp.codigo           LIKE '1%'
         ORDER BY cp.codigo
    LOOP
        IF rec.imp_var > 0 THEN
            v_monto := rec.imp_var;
        ELSIF rec.nro_horas > 0 THEN
            v_monto := ROUND(v_rem_basica / 240.0 * rec.nro_horas * rec.factor_pago, 2);
        ELSIF rec.nro_dias > 0 THEN
            v_monto := ROUND(v_rem_basica / 30.0 * rec.nro_dias * rec.factor_pago, 2);
        ELSE
            CONTINUE;
        END IF;

        IF v_monto <> 0 THEN
            PERFORM rrhh._upsert_det(
                p_calculo_id, rec.concepto_id, v_item,
                v_monto, ROUND(v_monto / p_tipo_cambio, 5),
                rec.nro_dias, 'INGRESO');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_descuento_variable
-- Port: SIGRE usp_rh_cal_descuento_variable
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_descuento_variable(
    p_calculo_id        BIGINT,
    p_trabajador_id     BIGINT,
    p_fec_inicio        DATE,
    p_fec_final         DATE,
    p_tipo_cambio       NUMERIC,
    p_tipo_planilla_id  BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_item  SMALLINT := 100;
    rec     RECORD;
    v_total NUMERIC;
BEGIN
    FOR rec IN
        SELECT gdv.concepto_id, cp.codigo
          FROM rrhh.gan_desct_variable gdv
          JOIN rrhh.concepto_planilla cp ON cp.id = gdv.concepto_id
         WHERE gdv.trabajador_id = p_trabajador_id
           AND gdv.fec_movim    BETWEEN p_fec_inicio AND p_fec_final
           AND (gdv.tipo_planilla_id IS NULL OR gdv.tipo_planilla_id = p_tipo_planilla_id)
           AND cp.codigo LIKE '2%'
           AND cp.codigo <> '2204'
         GROUP BY gdv.concepto_id, cp.codigo
         ORDER BY cp.codigo
    LOOP
        SELECT COALESCE(SUM(gdv.imp_var), 0)
          INTO v_total
          FROM rrhh.gan_desct_variable gdv
         WHERE gdv.trabajador_id = p_trabajador_id
           AND gdv.concepto_id   = rec.concepto_id
           AND gdv.fec_movim    BETWEEN p_fec_inicio AND p_fec_final
           AND (gdv.tipo_planilla_id IS NULL OR gdv.tipo_planilla_id = p_tipo_planilla_id);

        IF v_total <> 0 THEN
            PERFORM rrhh._upsert_det(
                p_calculo_id, rec.concepto_id, v_item,
                ABS(v_total), ROUND(ABS(v_total) / p_tipo_cambio, 5),
                NULL, 'DESCUENTO');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- sp_cal_variables â€” DEPRECATED: usar sp_cal_ganancias_variables + sp_cal_descuento_variable
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_variables(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
BEGIN
    CALL rrhh.sp_cal_ganancias_variables(
        p_calculo_id, p_trabajador_id, p_fec_inicio, p_fec_final, p_tipo_cambio, p_tipo_planilla_id);
    CALL rrhh.sp_cal_descuento_variable(
        p_calculo_id, p_trabajador_id, p_fec_inicio, p_fec_final, p_tipo_cambio, p_tipo_planilla_id);
END;
$$;

-- ============================================================
-- sp_cal_inasistencias
-- Descuento por dÃ­as no laborados (falta injustificada).
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_inasistencias(
    p_calculo_id        BIGINT,
    p_trabajador_id     BIGINT,
    p_fec_inicio        DATE,
    p_fec_final         DATE,
    p_dias_mes          INTEGER,
    p_tipo_cambio       NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_faltas    NUMERIC;
    v_sueldo_dia      NUMERIC;
    v_concepto_id     BIGINT;
    v_descuento       NUMERIC;
    -- Concepto descuento inasistencia = primer concepto del grupo DIAS_INASIS_DSCCONT
    v_grp_inas_id     BIGINT;
BEGIN
    SELECT COALESCE(SUM(i.dias_inasistencia), 0)
      INTO v_total_faltas
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND i.flag_estado   IN ('3')   -- solo injustificadas generan descuento
       AND i.fecha_desde  <= p_fec_final
       AND COALESCE(i.fecha_hasta, i.fecha_desde) >= p_fec_inicio;

    IF v_total_faltas = 0 THEN RETURN; END IF;

    -- Sueldo diario = total ingresos fijos / dias_mes (aproximaciÃ³n)
    SELECT COALESCE(SUM(cd.imp_soles), 0) / p_dias_mes
      INTO v_sueldo_dia
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND tcc.codigo    = 'INGRESO';

    v_descuento := ROUND(v_sueldo_dia * v_total_faltas, 2);
    IF v_descuento = 0 THEN RETURN; END IF;

    -- Concepto descuento inasistencia: grupo DIAS_INASIS_DSCCONT (value_int=8 â†’ '008')
    SELECT rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'DIAS_INASIS_DSCCONT', '008') INTO v_grp_inas_id;

    IF v_grp_inas_id IS NOT NULL THEN
        SELECT gcd.concepto_planilla_id INTO v_concepto_id
          FROM rrhh.grupo_calculo_det gcd
         WHERE gcd.grupo_calculo_id = v_grp_inas_id AND gcd.flag_estado = '1'
         LIMIT 1;
    END IF;

    IF v_concepto_id IS NULL THEN
        -- Fallback: buscar cualquier concepto 2xxx de descuento inasistencia
        SELECT id INTO v_concepto_id
          FROM rrhh.concepto_planilla
         WHERE codigo LIKE '2%' AND LOWER(nombre) LIKE '%inasist%' LIMIT 1;
    END IF;

    IF v_concepto_id IS NOT NULL THEN
        PERFORM rrhh._upsert_det(
            p_calculo_id, v_concepto_id, 1,
            v_descuento,
            ROUND(v_descuento / p_tipo_cambio, 5),
            v_total_faltas, 'DESCUENTO');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_horas_extras
-- Calcula HE 25% (diurnas), 35% (nocturnas) y 100% (feriados)
-- desde gan_desct_variable con nro_horas > 0.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_horas_extras(
    p_calculo_id        BIGINT,
    p_trabajador_id     BIGINT,
    p_fec_inicio        DATE,
    p_fec_final         DATE,
    p_tipo_cambio       NUMERIC,
    p_tipo_planilla_id  BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_rem_basica    NUMERIC := 0;
    v_valor_hora    NUMERIC;
    v_item          SMALLINT := 200;
    rec             RECORD;
    v_monto         NUMERIC;
BEGIN
    -- RemuneraciÃ³n bÃ¡sica acumulada hasta ahora (ganancias fijas)
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_rem_basica
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id AND tcc.codigo = 'INGRESO';

    IF v_rem_basica = 0 THEN RETURN; END IF;

    v_valor_hora := v_rem_basica / 30 / 8;   -- valor hora ordinaria

    FOR rec IN
        SELECT gdv.concepto_id,
               cp.codigo,
               cp.factor_pago,
               COALESCE(gdv.nro_horas, 0) AS nro_horas
          FROM rrhh.gan_desct_variable gdv
          JOIN rrhh.concepto_planilla cp ON cp.id = gdv.concepto_id
         WHERE gdv.trabajador_id    = p_trabajador_id
           AND gdv.fec_movim       BETWEEN p_fec_inicio AND p_fec_final
           AND (gdv.tipo_planilla_id IS NULL OR gdv.tipo_planilla_id = p_tipo_planilla_id)
           AND gdv.nro_horas       > 0
           AND cp.codigo           LIKE '1%'
         ORDER BY cp.codigo
    LOOP
        -- factor_pago: 1.25 (HE diurna), 1.35 (nocturna), 2.00 (feriado/descanso)
        v_monto := ROUND(v_valor_hora * rec.nro_horas * COALESCE(rec.factor_pago, 1.25), 2);
        IF v_monto <> 0 THEN
            PERFORM rrhh._upsert_det(
                p_calculo_id, rec.concepto_id, v_item,
                v_monto,
                ROUND(v_monto / p_tipo_cambio, 5),
                NULL, 'INGRESO');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_ganancia_total
-- Totalizador ingresos (suma todos los conceptos INGRESO â†’ concepto 1499).
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_ganancia_total(
    p_calculo_id        BIGINT,
    p_tipo_cambio       NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_soles   NUMERIC;
    v_total_dolar   NUMERIC;
    v_cnc_total_ing VARCHAR;
    v_concepto_id   BIGINT;
BEGIN
    v_cnc_total_ing := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499)::TEXT;
    v_concepto_id   := rrhh._fn_concepto_id(v_cnc_total_ing);

    SELECT COALESCE(SUM(cd.imp_soles), 0),
           COALESCE(SUM(cd.imp_dolar), 0)
      INTO v_total_soles, v_total_dolar
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id AND tcc.codigo = 'INGRESO';

    PERFORM rrhh._upsert_det(
        p_calculo_id, v_concepto_id, 1,
        v_total_soles, v_total_dolar,
        NULL, 'INGRESO');
END;
$$;

-- ============================================================
-- sp_cal_onp
-- Port: SIGRE usp_rh_cal_snp â€” Descuento ONP/SNP 13%
-- Solo si flag_cat_trab='1' y admin_afp_id IS NULL.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_onp(
    p_calculo_id      BIGINT,
    p_trabajador_id   BIGINT,
    p_tipo_cambio     NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_snp_id    BIGINT;
    v_base          NUMERIC := 0;
    v_tasa          NUMERIC;
    v_descuento     NUMERIC;
    v_concepto_id   BIGINT;
BEGIN
    -- Grupo SNP (RRHHPARAM_CCONCEP.SNP = '019')
    SELECT rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'SNP', '019') INTO v_grp_snp_id;

    IF v_grp_snp_id IS NULL THEN RETURN; END IF;

    -- Base afecta = suma ingresos del grupo SNP
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_base
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND tcc.codigo    = 'INGRESO'
       AND cd.concepto_id IN (
           SELECT gcd.concepto_planilla_id
             FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = v_grp_snp_id AND gcd.flag_estado = '1'
       );

    IF v_base = 0 THEN RETURN; END IF;

    -- Tasa: leer factor_pago del primer concepto del grupo (tÃ­pico 0.13)
    SELECT cp.factor_pago INTO v_tasa
      FROM rrhh.grupo_calculo_det gcd
      JOIN rrhh.concepto_planilla cp ON cp.id = gcd.concepto_planilla_id
     WHERE gcd.grupo_calculo_id = v_grp_snp_id AND gcd.flag_estado = '1'
     ORDER BY cp.codigo LIMIT 1;

    v_tasa := COALESCE(v_tasa, 0.13);
    v_descuento := ROUND(v_base * v_tasa, 2);

    -- Concepto destino: primero del grupo SNP con cÃ³digo 2xxx
    SELECT cp.id INTO v_concepto_id
      FROM rrhh.grupo_calculo_det gcd
      JOIN rrhh.concepto_planilla cp ON cp.id = gcd.concepto_planilla_id
     WHERE gcd.grupo_calculo_id = v_grp_snp_id AND gcd.flag_estado = '1'
       AND cp.codigo LIKE '2%'
     ORDER BY cp.codigo LIMIT 1;

    IF v_concepto_id IS NOT NULL AND v_descuento > 0 THEN
        PERFORM rrhh._upsert_det(
            p_calculo_id, v_concepto_id, 1,
            v_descuento,
            ROUND(v_descuento / p_tipo_cambio, 5),
            NULL, 'DESCUENTO');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_afp
-- Port: SIGRE usp_rh_cal_afp â€” 3 componentes AFP
-- Solo si flag_cat_trab='1' y admin_afp_id IS NOT NULL.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_afp(
    p_calculo_id      BIGINT,
    p_trabajador_id   BIGINT,
    p_admin_afp_id    BIGINT,
    p_tipo_cambio     NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_afp_id     BIGINT;
    v_grp_cbssp_cod  VARCHAR;
    v_grp_cbssp_id   BIGINT;
    v_base           NUMERIC := 0;
    v_afp            RECORD;
    v_cnc_jub        TEXT;
    v_cnc_inv        TEXT;
    v_cnc_com        TEXT;
    v_concepto_jub   BIGINT;
    v_concepto_inv   BIGINT;
    v_concepto_com   BIGINT;
    v_monto          NUMERIC;
BEGIN
    -- Grupo AFP (RRHHPARAM_CCONCEP.CONCEP_CALCULO_AFP = 23 â†’ '023')
    SELECT rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_CALCULO_AFP', '023') INTO v_grp_afp_id;

    IF v_grp_afp_id IS NULL THEN RETURN; END IF;

    -- Base AFP = suma ingresos del grupo AFP
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_base
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND tcc.codigo    = 'INGRESO'
       AND cd.concepto_id IN (
           SELECT gcd.concepto_planilla_id
             FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = v_grp_afp_id AND gcd.flag_estado = '1'
       );

    IF v_base = 0 THEN RETURN; END IF;

    -- Tasas AFP
    SELECT comision_porcentaje, prima_seguro, aporte_obligatorio
      INTO v_afp
      FROM rrhh.admin_afp
     WHERE id = p_admin_afp_id;

    IF v_afp IS NULL THEN RETURN; END IF;

    -- Conceptos destino (RRHHPARAM_CCONCEP)
    v_cnc_jub := rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'AFP_JUBILACION', '020');
    v_cnc_inv := rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'AFP_INVALIDEZ',  '021');
    v_cnc_com := rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'AFP_COMISION',   '022');

    -- JubilaciÃ³n (aporte_obligatorio)
    IF COALESCE(v_afp.aporte_obligatorio, 0) > 0 THEN
        v_monto := ROUND(v_base * v_afp.aporte_obligatorio / 100, 2);
        BEGIN
            v_concepto_jub := rrhh._fn_concepto_id(v_cnc_jub::TEXT);
            PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_jub, 1,
                v_monto, ROUND(v_monto/p_tipo_cambio,5), NULL, 'DESCUENTO');
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

    -- Invalidez (prima_seguro)
    IF COALESCE(v_afp.prima_seguro, 0) > 0 THEN
        v_monto := ROUND(v_base * v_afp.prima_seguro / 100, 2);
        BEGIN
            v_concepto_inv := rrhh._fn_concepto_id(v_cnc_inv::TEXT);
            PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_inv, 1,
                v_monto, ROUND(v_monto/p_tipo_cambio,5), NULL, 'DESCUENTO');
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

    -- ComisiÃ³n
    IF COALESCE(v_afp.comision_porcentaje, 0) > 0 THEN
        v_monto := ROUND(v_base * v_afp.comision_porcentaje / 100, 2);
        BEGIN
            v_concepto_com := rrhh._fn_concepto_id(v_cnc_com::TEXT);
            PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_com, 1,
                v_monto, ROUND(v_monto/p_tipo_cambio,5), NULL, 'DESCUENTO');
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_quinta_categoria
-- Port: SIGRE usp_rh_cal_quinta_categoria
-- Calcula y registra retenciÃ³n mensual de quinta categorÃ­a.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_quinta_categoria(
    p_calculo_id       BIGINT,
    p_trabajador_id    BIGINT,
    p_fec_proceso      DATE,
    p_tipo_cambio      NUMERIC,
    p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_rem_computable    NUMERIC := 0;
    v_retencion         NUMERIC;
    v_concepto_id       BIGINT;
    v_cnc_qta           TEXT;
    v_anio              INTEGER;
    v_mes               INTEGER;
BEGIN
    v_anio := EXTRACT(YEAR  FROM p_fec_proceso)::INTEGER;
    v_mes  := EXTRACT(MONTH FROM p_fec_proceso)::INTEGER;

    -- RemuneraciÃ³n computable = total ingresos afectos a quinta (flag_reporte_quinta='1')
    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_rem_computable
      FROM rrhh.calculo_det cd
      JOIN rrhh.concepto_planilla cp ON cp.id = cd.concepto_id
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id          = p_calculo_id
       AND tcc.codigo             = 'INGRESO'
       AND cp.flag_reporte_quinta = '1';

    IF v_rem_computable = 0 THEN RETURN; END IF;

    v_retencion := rrhh.fn_calcular_impuesto_5ta(
        p_trabajador_id, p_fec_proceso, v_rem_computable, p_tipo_planilla_id);

    IF v_retencion = 0 THEN RETURN; END IF;

    -- Concepto quinta categorÃ­a (RRHHPARAM_CCONCEP.QUINTA_CAT_PROYECTA = 24)
    v_cnc_qta := rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'QUINTA_CAT_PROYECTA', '024');
    BEGIN
        v_concepto_id := rrhh._fn_concepto_id(v_cnc_qta::TEXT);
    EXCEPTION WHEN OTHERS THEN RETURN; END;

    PERFORM rrhh._upsert_det(
        p_calculo_id, v_concepto_id, 1,
        v_retencion,
        ROUND(v_retencion / p_tipo_cambio, 5),
        NULL, 'DESCUENTO');

    -- Guardar en quinta_categoria para acumulado anual (UQ: trabajador_id + fec_proceso + flag_automatico + tipo_planilla_id)
    INSERT INTO rrhh.quinta_categoria
        (trabajador_id, fec_proceso, rem_proyectable, rem_retencion,
         flag_automatico, tipo_planilla_id, fec_creacion)
    VALUES
        (p_trabajador_id, p_fec_proceso, v_rem_computable, v_retencion,
         '1', p_tipo_planilla_id, NOW())
    ON CONFLICT (trabajador_id, fec_proceso, flag_automatico, tipo_planilla_id)
    DO UPDATE SET
        rem_proyectable  = EXCLUDED.rem_proyectable,
        rem_retencion    = EXCLUDED.rem_retencion,
        fec_modificacion = NOW();
END;
$$;

-- ============================================================
-- sp_cal_descuento_total
-- Totalizador descuentos (suma todos DESCUENTO â†’ concepto 2398).
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_descuento_total(
    p_calculo_id   BIGINT,
    p_tipo_cambio  NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total         NUMERIC;
    v_concepto_id   BIGINT;
    v_cnc_dsct      VARCHAR;
BEGIN
    v_cnc_dsct    := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_DSCT', 2398)::TEXT;
    v_concepto_id := rrhh._fn_concepto_id(v_cnc_dsct);

    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_total
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id AND tcc.codigo = 'DESCUENTO';

    PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
        v_total, ROUND(v_total/p_tipo_cambio,5), NULL, 'DESCUENTO');
END;
$$;

-- ============================================================
-- sp_cal_total_pagado
-- Neto = ingresos - descuentos â†’ concepto 2399.
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_total_pagado(
    p_calculo_id   BIGINT,
    p_tipo_cambio  NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_ingresos      NUMERIC := 0;
    v_descuentos    NUMERIC := 0;
    v_neto          NUMERIC;
    v_concepto_id   BIGINT;
    v_cnc_pgd       VARCHAR;
    v_cnc_ing_int   INTEGER;
    v_cnc_dsc_int   INTEGER;
BEGIN
    v_cnc_pgd  := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_PGD',  2399)::TEXT;
    v_cnc_ing_int := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499);
    v_cnc_dsc_int := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_DSCT', 2398);

    v_concepto_id := rrhh._fn_concepto_id(v_cnc_pgd);

    -- Total ingresos (excluyendo el propio totalizador 1499)
    SELECT COALESCE(SUM(cd.imp_soles), 0) INTO v_ingresos
      FROM rrhh.calculo_det cd
      JOIN rrhh.concepto_planilla cp ON cp.id = cd.concepto_id
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND tcc.codigo    = 'INGRESO'
       AND cp.codigo     <> v_cnc_ing_int::TEXT;

    -- Total descuentos (excluyendo totalizador 2398)
    SELECT COALESCE(SUM(cd.imp_soles), 0) INTO v_descuentos
      FROM rrhh.calculo_det cd
      JOIN rrhh.concepto_planilla cp ON cp.id = cd.concepto_id
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND tcc.codigo    = 'DESCUENTO'
       AND cp.codigo     <> v_cnc_dsc_int::TEXT;

    v_neto := v_ingresos - v_descuentos;

    PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
        v_neto, ROUND(v_neto/p_tipo_cambio,5), NULL, 'DESCUENTO');
END;
$$;

-- ============================================================
-- sp_cal_essalud
-- Port: SIGRE usp_rh_cal_apo_essalud â€” Aporte patronal EsSalud 9%
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_essalud(
    p_calculo_id   BIGINT,
    p_trabajador_id BIGINT,
    p_tipo_cambio  NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_ess_id    BIGINT;
    v_base          NUMERIC := 0;
    v_rmv           NUMERIC := 0;
    v_base_ess      NUMERIC;
    v_tasa          NUMERIC := 0.09;
    v_aporte        NUMERIC;
    v_concepto_id   BIGINT;
    v_tipo_trab_id  BIGINT;
    v_fec_proceso   DATE;
BEGIN
    -- Obtener tipo_trabajador_id y fec_proceso desde calculo
    SELECT c.tipo_planilla_id, c.fec_proceso, t.tipo_trabajador_id
      INTO v_base, v_fec_proceso, v_tipo_trab_id
      FROM rrhh.calculo c
      JOIN rrhh.trabajador t ON t.id = c.trabajador_id
     WHERE c.id = p_calculo_id;

    -- Grupo EsSalud (RRHHPARAM_CCONCEP.CONCEP_ESSALUD = 77 â†’ '077')
    SELECT rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_ESSALUD', '077') INTO v_grp_ess_id;

    IF v_grp_ess_id IS NOT NULL THEN
        -- Base = suma ingresos del grupo EsSalud
        SELECT COALESCE(SUM(cd.imp_soles), 0)
          INTO v_base
          FROM rrhh.calculo_det cd
          JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
         WHERE cd.calculo_id = p_calculo_id
           AND tcc.codigo    = 'INGRESO'
           AND cd.concepto_id IN (
               SELECT gcd.concepto_planilla_id
                 FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_ess_id AND gcd.flag_estado = '1'
           );
    END IF;

    IF v_base = 0 THEN
        -- Fallback: total ingresos fijos
        SELECT COALESCE(SUM(cd.imp_soles), 0)
          INTO v_base
          FROM rrhh.calculo_det cd
          JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
         WHERE cd.calculo_id = p_calculo_id AND tcc.codigo = 'INGRESO';
    END IF;

    -- RMV vigente (tope mÃ­nimo base EsSalud)
    SELECT COALESCE(r.rmv, 0) INTO v_rmv
      FROM rrhh.remuneracion_minima_vital r
     WHERE r.tipo_trabajador_id = v_tipo_trab_id
       AND r.fecha_desde       <= v_fec_proceso
       AND r.flag_estado        = '1'
     ORDER BY r.fecha_desde DESC LIMIT 1;

    v_base_ess := GREATEST(v_base, v_rmv);
    v_aporte   := ROUND(v_base_ess * v_tasa, 2);

    IF v_aporte = 0 THEN RETURN; END IF;

    -- Concepto EsSalud patronal (cÃ³digo 3xxx del grupo)
    SELECT cp.id INTO v_concepto_id
      FROM rrhh.grupo_calculo_det gcd
      JOIN rrhh.concepto_planilla cp ON cp.id = gcd.concepto_planilla_id
     WHERE gcd.grupo_calculo_id = COALESCE(v_grp_ess_id, 0)
       AND gcd.flag_estado = '1'
       AND cp.codigo LIKE '3%'
     ORDER BY cp.codigo LIMIT 1;

    IF v_concepto_id IS NULL THEN
        -- Fallback directo al concepto 3099 EsSalud
        BEGIN
            v_concepto_id := rrhh._fn_concepto_id('3099');
        EXCEPTION WHEN OTHERS THEN RETURN; END;
    END IF;

    PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
        v_aporte, ROUND(v_aporte/p_tipo_cambio,5), NULL, 'APORTE');
END;
$$;

-- ============================================================
-- sp_cal_apo_total
-- Totalizador aportes (suma todos APORTE â†’ concepto 3099).
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_apo_total(
    p_calculo_id   BIGINT,
    p_tipo_cambio  NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total         NUMERIC;
    v_concepto_id   BIGINT;
    v_cnc_aport     VARCHAR;
BEGIN
    v_cnc_aport   := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_APORT', 3099)::TEXT;
    BEGIN
        v_concepto_id := rrhh._fn_concepto_id(v_cnc_aport);
    EXCEPTION WHEN OTHERS THEN RETURN; END;

    SELECT COALESCE(SUM(cd.imp_soles), 0)
      INTO v_total
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id AND tcc.codigo = 'APORTE';

    PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
        v_total, ROUND(v_total/p_tipo_cambio,5), NULL, 'APORTE');

    -- Actualizar cabecera calculo con totales
    UPDATE rrhh.calculo SET
        total_ingresos_soles   = (SELECT COALESCE(SUM(cd2.imp_soles),0) FROM rrhh.calculo_det cd2
                                   JOIN rrhh.tipo_concepto_calculo tcc2 ON tcc2.id=cd2.tipo_concepto_calculo_id
                                  WHERE cd2.calculo_id=p_calculo_id AND tcc2.codigo='INGRESO'),
        total_descuentos_soles = (SELECT COALESCE(SUM(cd2.imp_soles),0) FROM rrhh.calculo_det cd2
                                   JOIN rrhh.tipo_concepto_calculo tcc2 ON tcc2.id=cd2.tipo_concepto_calculo_id
                                  WHERE cd2.calculo_id=p_calculo_id AND tcc2.codigo='DESCUENTO'),
        total_aportes_soles    = v_total,
        total_neto_soles       = (SELECT COALESCE(SUM(cd2.imp_soles),0) FROM rrhh.calculo_det cd2
                                   JOIN rrhh.tipo_concepto_calculo tcc2 ON tcc2.id=cd2.tipo_concepto_calculo_id
                                  WHERE cd2.calculo_id=p_calculo_id AND tcc2.codigo='INGRESO')
                                 -
                                 (SELECT COALESCE(SUM(cd2.imp_soles),0) FROM rrhh.calculo_det cd2
                                   JOIN rrhh.tipo_concepto_calculo tcc2 ON tcc2.id=cd2.tipo_concepto_calculo_id
                                  WHERE cd2.calculo_id=p_calculo_id AND tcc2.codigo='DESCUENTO'),
        fec_modificacion       = NOW()
    WHERE id = p_calculo_id;
END;
$$;

-- ============================================================
-- sp_cal_feriado â€” Port SIGRE usp_rh_cal_feriado (no-op EMP sueldo fijo)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_feriado(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_dias_trab NUMERIC,
    p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF rrhh._flag_ingreso_boleta(p_trabajador_id) <> 'J' THEN RETURN; END IF;
    -- LÃ³gica jornal: pendiente tablas asistencia/calendario_feriado
END;
$$;

-- ============================================================
-- sp_cal_dso â€” Port SIGRE USP_RH_CAL_DSO (no-op EMP sueldo fijo)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_dso(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_dias_trab NUMERIC,
    p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF rrhh._flag_ingreso_boleta(p_trabajador_id) <> 'J' THEN RETURN; END IF;
END;
$$;

-- ============================================================
-- sp_cal_vacaciones â€” Port SIGRE usp_rh_cal_vacaciones
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_vacaciones(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_dias_mes INTEGER,
    p_fec_proceso DATE, p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_vac_id        BIGINT;
    v_concepto_vac_id   BIGINT;
    v_concepto_var_id   BIGINT;
    v_dias_vac          NUMERIC := 0;
    v_imp_fijo          NUMERIC := 0;
    v_imp_var           NUMERIC := 0;
    v_grp_var_id        BIGINT;
    v_rmv               NUMERIC;
BEGIN
    v_grp_vac_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'GAN_FIJ_CALC_VACAC', '003');
    IF v_grp_vac_id IS NULL THEN RETURN; END IF;

    v_concepto_vac_id := rrhh._grupo_concepto_gen_id(v_grp_vac_id);
    v_rmv := rrhh._rmv_trabajador(p_trabajador_id, p_fec_proceso);

    SELECT COALESCE(SUM(i.dias_inasistencia), 0), MAX(i.concepto_planilla_id)
      INTO v_dias_vac, v_concepto_vac_id
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND COALESCE(i.fecha_movimiento, i.fecha_desde) BETWEEN p_fec_inicio AND p_fec_final
       AND (i.concepto_planilla_id IN (
               SELECT gcd.concepto_planilla_id FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_vac_id AND gcd.flag_estado = '1'
           ) OR i.concepto_planilla_id = v_concepto_vac_id);

    IF v_dias_vac <= 0 THEN RETURN; END IF;

    v_imp_fijo := ROUND(rrhh._sum_gan_fijo_grupo(p_trabajador_id, v_grp_vac_id) / 30.0 * v_dias_vac, 2);
    IF v_imp_fijo > v_rmv AND v_rmv > 0 THEN v_imp_fijo := v_rmv; END IF;

    IF v_imp_fijo > 0 AND v_concepto_vac_id IS NOT NULL THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_vac_id, 10,
            v_imp_fijo, ROUND(v_imp_fijo / p_tipo_cambio, 5), v_dias_vac, 'INGRESO');
    END IF;

    SELECT id INTO v_grp_var_id FROM rrhh.grupo_calculo WHERE codigo = '806' LIMIT 1;
    IF v_grp_var_id IS NOT NULL THEN
        v_imp_var := ROUND(rrhh._sum_hist_grupo(p_trabajador_id, v_grp_var_id, p_fec_proceso, 6, p_tipo_planilla_id) / 6.0 / 30.0 * v_dias_vac, 2);
        IF v_imp_var > 0 THEN
            v_concepto_var_id := rrhh._fn_concepto_id('1108');
            PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_var_id, 11,
                v_imp_var, ROUND(v_imp_var / p_tipo_cambio, 5), v_dias_vac, 'INGRESO');
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_enfermedad â€” Port SIGRE usp_rh_cal_enfermedad
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_enfermedad(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_fec_proceso DATE,
    p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_pat_id    BIGINT;
    v_grp_sub_id    BIGINT;
    v_con_pat_id    BIGINT;
    v_con_sub_id    BIGINT;
    v_dias          NUMERIC;
    v_base          NUMERIC;
    v_monto         NUMERIC;
BEGIN
    v_grp_pat_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'ENFERM_PATRON_PIRM20', '012');
    v_grp_sub_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'SUBSIDIO_ENFERMEDAD', '014');
    v_con_pat_id := rrhh._grupo_concepto_gen_id(v_grp_pat_id);
    v_con_sub_id := rrhh._grupo_concepto_gen_id(v_grp_sub_id);

    IF v_grp_pat_id IS NOT NULL AND v_con_pat_id IS NOT NULL THEN
        SELECT COALESCE(SUM(i.dias_inasistencia), 0) INTO v_dias
          FROM rrhh.inasistencia i
         WHERE i.trabajador_id = p_trabajador_id
           AND i.concepto_planilla_id = v_con_pat_id
           AND COALESCE(i.fecha_movimiento, i.fecha_desde) = p_fec_proceso;

        IF v_dias > 0 THEN
            v_base  := rrhh._sum_gan_fijo_grupo(p_trabajador_id, v_grp_pat_id);
            v_monto := ROUND(v_base / 30.0 * v_dias, 2);
            IF v_monto > 0 THEN
                PERFORM rrhh._upsert_det(p_calculo_id, v_con_pat_id, 20,
                    v_monto, ROUND(v_monto / p_tipo_cambio, 5), v_dias, 'INGRESO');
            END IF;
        END IF;
    END IF;

    IF v_grp_sub_id IS NOT NULL AND v_con_sub_id IS NOT NULL THEN
        SELECT COALESCE(SUM(i.dias_inasistencia), 0) INTO v_dias
          FROM rrhh.inasistencia i
         WHERE i.trabajador_id = p_trabajador_id
           AND i.concepto_planilla_id = v_con_sub_id
           AND COALESCE(i.fecha_movimiento, i.fecha_desde) BETWEEN p_fec_inicio AND p_fec_final;

        IF v_dias > 0 THEN
            v_base  := rrhh._sum_gan_fijo_grupo(p_trabajador_id, v_grp_sub_id);
            v_monto := ROUND(v_base / 30.0 * v_dias, 2);
            IF v_monto > 0 THEN
                PERFORM rrhh._upsert_det(p_calculo_id, v_con_sub_id, 21,
                    v_monto, ROUND(v_monto / p_tipo_cambio, 5), v_dias, 'INGRESO');
            END IF;
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_maternidad â€” Port SIGRE usp_rh_cal_maternidad
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_maternidad(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_proceso DATE, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id      BIGINT;
    v_concepto_id BIGINT;
    v_dias        NUMERIC;
    v_monto       NUMERIC;
BEGIN
    v_grp_id      := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'MATERNIDAD', '013');
    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_grp_id IS NULL OR v_concepto_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(SUM(i.dias_inasistencia), 0) INTO v_dias
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND i.concepto_planilla_id = v_concepto_id
       AND COALESCE(i.fecha_movimiento, i.fecha_desde) = p_fec_proceso;

    IF v_dias <= 0 THEN RETURN; END IF;

    v_monto := ROUND(rrhh._sum_gan_fijo_grupo(p_trabajador_id, v_grp_id) / 30.0 * v_dias, 2);
    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), v_dias, 'INGRESO');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_reintegros â€” Port SIGRE usp_rh_cal_reintegros
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_reintegros(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_gan_id  BIGINT;
    v_grp_rei_id  BIGINT;
    v_grp_dia_id  BIGINT;
    v_base        NUMERIC;
    v_dias        NUMERIC;
    v_monto       NUMERIC;
    v_con_dia_id  BIGINT;
    rec           RECORD;
BEGIN
    v_grp_gan_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'GAN_FIJ_REINTEGRO', '016');
    v_grp_rei_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_CALC_REINTEGRO', '017');
    v_grp_dia_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'REINTEGRO_2530_POR_DIA', NULL);
    IF v_grp_gan_id IS NULL OR v_grp_rei_id IS NULL THEN RETURN; END IF;

    v_base := rrhh._sum_gan_fijo_grupo(p_trabajador_id, v_grp_gan_id);

    FOR rec IN
        SELECT gcd.concepto_planilla_id AS concepto_id
          FROM rrhh.grupo_calculo_det gcd
         WHERE gcd.grupo_calculo_id = v_grp_rei_id AND gcd.flag_estado = '1'
    LOOP
        SELECT COALESCE(SUM(i.dias_inasistencia), 0) INTO v_dias
          FROM rrhh.inasistencia i
         WHERE i.trabajador_id = p_trabajador_id
           AND i.concepto_planilla_id = rec.concepto_id
           AND COALESCE(i.fecha_movimiento, i.fecha_desde) BETWEEN p_fec_inicio AND p_fec_final;

        IF v_dias > 0 THEN
            v_monto := ROUND(v_base / 30.0 * v_dias, 2);
            IF v_monto > 0 THEN
                PERFORM rrhh._upsert_det(p_calculo_id, rec.concepto_id, 30,
                    v_monto, ROUND(v_monto / p_tipo_cambio, 5), v_dias, 'INGRESO');
            END IF;
        END IF;
    END LOOP;

    IF v_grp_dia_id IS NOT NULL THEN
        v_con_dia_id := rrhh._grupo_concepto_gen_id(v_grp_dia_id);
        IF v_con_dia_id IS NOT NULL THEN
            SELECT COALESCE(SUM(cd.imp_soles), 0) INTO v_monto
              FROM rrhh.calculo_det cd
             WHERE cd.calculo_id = p_calculo_id AND cd.concepto_id IN (
                 SELECT gcd.concepto_planilla_id FROM rrhh.grupo_calculo_det gcd
                  WHERE gcd.grupo_calculo_id = v_grp_rei_id AND gcd.flag_estado = '1'
             );
            IF v_monto > 0 THEN
                PERFORM rrhh._upsert_det(p_calculo_id, v_con_dia_id, 31,
                    v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'INGRESO');
            END IF;
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_descuentos_fijos â€” Port SIGRE usp_rh_cal_descuentos_fijos
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_descuentos_fijos(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id        BIGINT;
    v_total_ing     NUMERIC;
    v_monto         NUMERIC;
    rec             RECORD;
    v_item          SMALLINT := 50;
BEGIN
    v_grp_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'DESCT_FIJO', '030');
    IF v_grp_id IS NULL THEN RETURN; END IF;

    v_total_ing := rrhh._sum_det_codigo(p_calculo_id,
        rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499)::TEXT);

    FOR rec IN
        SELECT gdf.concepto_id, gdf.imp_gan_desc, gdf.porcentaje
          FROM rrhh.gan_desct_fijo gdf
         WHERE gdf.trabajador_id = p_trabajador_id AND gdf.flag_estado = '1'
           AND gdf.concepto_id IN (
               SELECT gcd.concepto_planilla_id FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_id AND gcd.flag_estado = '1'
           )
    LOOP
        IF COALESCE(rec.porcentaje, 0) <> 0 THEN
            v_monto := ROUND(v_total_ing * rec.porcentaje / 100.0, 2);
        ELSE
            v_monto := COALESCE(rec.imp_gan_desc, 0);
        END IF;
        IF v_monto <> 0 THEN
            PERFORM rrhh._upsert_det(p_calculo_id, rec.concepto_id, v_item,
                v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'DESCUENTO');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_desct_comedor â€” Port SIGRE usp_rh_cal_desct_comedor (no-op EMP oficina)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_desct_comedor(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM rrhh.trabajador t
         WHERE t.id = p_trabajador_id AND COALESCE(t.flag_dscto_comedor, '0') = '1'
    ) THEN RETURN; END IF;
    -- Destajo/comedor: requiere tablas tg_pd_destajo (no aplica EMP oficina)
END;
$$;

-- ============================================================
-- sp_cal_tardanzas â€” Port SIGRE usp_rh_cal_tardanzas
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_tardanzas(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_tar_id    BIGINT;
    v_grp_dsc_id    BIGINT;
    v_con_tar_id    BIGINT;
    v_con_dsc_id    BIGINT;
    v_minutos       NUMERIC := 0;
    v_ganancias     NUMERIC;
    v_valor_min     NUMERIC;
    v_monto         NUMERIC;
    v_grc_gan       VARCHAR;
BEGIN
    v_grp_tar_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_TARDANZA', '031');
    v_grp_dsc_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'DSCTO_TARDANZA', '032');
    IF v_grp_tar_id IS NULL OR v_grp_dsc_id IS NULL THEN RETURN; END IF;

    v_con_tar_id := rrhh._grupo_concepto_gen_id(v_grp_tar_id);
    v_con_dsc_id := rrhh._grupo_concepto_gen_id(v_grp_dsc_id);
    IF v_con_tar_id IS NULL OR v_con_dsc_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(SUM(i.dias_inasistencia * 100), 0) INTO v_minutos
      FROM rrhh.inasistencia i
     WHERE i.trabajador_id = p_trabajador_id
       AND i.concepto_planilla_id = v_con_tar_id
       AND COALESCE(i.fecha_movimiento, i.fecha_desde) BETWEEN p_fec_inicio AND p_fec_final;

    IF v_minutos <= 0 THEN RETURN; END IF;

    v_grc_gan := rrhh._cfg_grupo_codigo('RRHHPARAM', 'GRC_GNN_FIJA', '010');
    SELECT COALESCE(SUM(gdf.imp_gan_desc), 0) INTO v_ganancias
      FROM rrhh.gan_desct_fijo gdf
      JOIN rrhh.concepto_planilla cp ON cp.id = gdf.concepto_id
     WHERE gdf.trabajador_id = p_trabajador_id AND gdf.flag_estado = '1'
       AND LEFT(cp.codigo, 2) = v_grc_gan;

    v_valor_min := (v_ganancias / 240.0) / 60.0;
    v_monto     := ROUND(v_valor_min * v_minutos, 2);

    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_con_dsc_id, 40,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'DESCUENTO');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_porcentaje_judicial â€” Port SIGRE usp_rh_cal_porcentaje_judicial
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_porcentaje_judicial(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_proceso DATE, p_tipo_cambio NUMERIC,
    p_porc_judicial NUMERIC, p_porc_jud_util NUMERIC,
    p_tipo_planilla_id BIGINT, p_created_by BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id        BIGINT;
    v_base          NUMERIC := 0;
    v_descuento     NUMERIC := 0;
    v_concepto_id   BIGINT;
    rec             RECORD;
BEGIN
    v_grp_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CALC_JUDIC', '028');
    IF v_grp_id IS NULL THEN RETURN; END IF;

    DELETE FROM rrhh.calculo_judicial
     WHERE trabajador_id = p_trabajador_id AND fec_proceso = p_fec_proceso;

    SELECT COALESCE(SUM(
        CASE WHEN tcc.codigo = 'INGRESO' THEN cd.imp_soles ELSE -cd.imp_soles END
    ), 0) INTO v_base
      FROM rrhh.calculo_det cd
      JOIN rrhh.tipo_concepto_calculo tcc ON tcc.id = cd.tipo_concepto_calculo_id
     WHERE cd.calculo_id = p_calculo_id
       AND cd.concepto_id IN (
           SELECT gcd.concepto_planilla_id FROM rrhh.grupo_calculo_det gcd
            WHERE gcd.grupo_calculo_id = v_grp_id AND gcd.flag_estado = '1'
       );

    IF EXISTS (
        SELECT 1 FROM rrhh.retencion_judicial rj
         WHERE rj.trabajador_id = p_trabajador_id AND rj.flag_estado = '1'
    ) THEN
        FOR rec IN
            SELECT rj.* FROM rrhh.retencion_judicial rj
             WHERE rj.trabajador_id = p_trabajador_id AND rj.flag_estado = '1'
        LOOP
            IF COALESCE(rec.porcentaje, 0) > 0 THEN
                v_descuento := ROUND(v_base * rec.porcentaje / 100.0, 2);
            ELSE
                v_descuento := COALESCE(rec.importe, 0);
            END IF;
            IF v_descuento > 0 THEN
                INSERT INTO rrhh.calculo_judicial
                    (trabajador_id, concepto_planilla_id, secuencia, fec_proceso,
                     imp_soles, imp_dolar, imp_bruto, tipo_trabajador_id, tipo_planilla_id, created_by)
                SELECT p_trabajador_id, rec.concepto_planilla_id, rec.secuencia, p_fec_proceso,
                       v_descuento, ROUND(v_descuento / p_tipo_cambio, 4), v_base,
                       t.tipo_trabajador_id, p_tipo_planilla_id, p_created_by
                  FROM rrhh.trabajador t WHERE t.id = p_trabajador_id;

                PERFORM rrhh._upsert_det(p_calculo_id, rec.concepto_planilla_id, rec.secuencia::SMALLINT,
                    v_descuento, ROUND(v_descuento / p_tipo_cambio, 5), NULL, 'DESCUENTO');
            END IF;
        END LOOP;
    ELSE
        v_descuento := ROUND(v_base * COALESCE(p_porc_judicial, 0) / 100.0, 2);
        IF v_descuento > 0 THEN
            v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
            IF v_concepto_id IS NOT NULL THEN
                PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 45,
                    v_descuento, ROUND(v_descuento / p_tipo_cambio, 5), NULL, 'DESCUENTO');
            END IF;
        END IF;
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_essalud_vida â€” Port SIGRE usp_rh_cal_essalud_vida
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_essalud_vida(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_proceso DATE, p_fec_inicio DATE, p_fec_final DATE,
    p_tipo_cambio NUMERIC, p_tipo_planilla_id BIGINT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id        BIGINT;
    v_concepto_id   BIGINT;
    v_monto_fijo    NUMERIC;
    v_ya_cobrado    BOOLEAN;
BEGIN
    v_grp_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'DSCTO_ESSALUD_VIDA', NULL);
    IF v_grp_id IS NULL THEN RETURN; END IF;

    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_concepto_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(gdf.imp_gan_desc, 0) INTO v_monto_fijo
      FROM rrhh.gan_desct_fijo gdf
     WHERE gdf.trabajador_id = p_trabajador_id
       AND gdf.concepto_id   = v_concepto_id
       AND gdf.flag_estado   = '1'
     LIMIT 1;

    IF v_monto_fijo = 0 THEN RETURN; END IF;

    SELECT EXISTS (
        SELECT 1 FROM rrhh.calculo c
        JOIN rrhh.calculo_det cd ON cd.calculo_id = c.id
       WHERE c.trabajador_id = p_trabajador_id
         AND cd.concepto_id  = v_concepto_id
         AND c.fec_proceso  <= p_fec_proceso
         AND cd.imp_soles   <> 0
    ) INTO v_ya_cobrado;

    IF NOT v_ya_cobrado THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 46,
            v_monto_fijo, ROUND(v_monto_fijo / p_tipo_cambio, 5), NULL, 'DESCUENTO');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_cuenta_corriente â€” Port SIGRE usp_rh_cal_cuenta_corriente
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_cuenta_corriente(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_fec_proceso DATE, p_tipo_cambio NUMERIC,
    p_created_by BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_ing     NUMERIC;
    v_grp_id        BIGINT;
    v_cuota         NUMERIC;
    rec             RECORD;
    v_item          SMALLINT := 60;
BEGIN
    v_total_ing := rrhh._sum_det_codigo(p_calculo_id,
        rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499)::TEXT);
    IF v_total_ing <= 0 THEN RETURN; END IF;

    v_grp_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CNTA_CNTE', '029');
    IF v_grp_id IS NULL THEN RETURN; END IF;

    DELETE FROM rrhh.cnta_crrte_det d
     USING rrhh.cnta_crrte c
     WHERE d.cnta_crrte_id = c.id
       AND c.trabajador_id = p_trabajador_id
       AND d.fecha_movimiento = p_fec_proceso
       AND d.flag_digitado = '0';

    FOR rec IN
        SELECT cc.* FROM rrhh.cnta_crrte cc
         WHERE cc.trabajador_id = p_trabajador_id
           AND cc.flag_estado = '1'
           AND cc.saldo_prestamo > 0
           AND cc.concepto_planilla_id IN (
               SELECT gcd.concepto_planilla_id FROM rrhh.grupo_calculo_det gcd
                WHERE gcd.grupo_calculo_id = v_grp_id AND gcd.flag_estado = '1'
           )
    LOOP
        v_cuota := LEAST(rec.monto_cuota, rec.saldo_prestamo);
        IF v_cuota <= 0 THEN CONTINUE; END IF;

        PERFORM rrhh._upsert_det(p_calculo_id, rec.concepto_planilla_id, v_item,
            v_cuota, ROUND(v_cuota / p_tipo_cambio, 5), NULL, 'DESCUENTO');

        INSERT INTO rrhh.cnta_crrte_det
            (cnta_crrte_id, nro_dscto, fecha_movimiento, tipo_movimiento_cnta_crrte_id,
             imp_dscto, flag_digitado, flag_estado, created_by, fec_creacion)
        VALUES
            (rec.id, 1, p_fec_proceso, 1, v_cuota, '0', '1', p_created_by, NOW());

        UPDATE rrhh.cnta_crrte
           SET saldo_prestamo = saldo_prestamo - v_cuota, fec_modificacion = NOW()
         WHERE id = rec.id;

        v_item := v_item + 1;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_snp â€” alias SIGRE usp_rh_cal_snp (= sp_cal_onp)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_snp(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    CALL rrhh.sp_cal_onp(p_calculo_id, p_trabajador_id, p_tipo_cambio);
END;
$$;

-- ============================================================
-- sp_cal_apo_sctr_ipss â€” Port SIGRE usp_rh_cal_apo_sctr_ipss
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_apo_sctr_ipss(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id      BIGINT;
    v_concepto_id BIGINT;
    v_base        NUMERIC;
    v_tasa        NUMERIC;
    v_monto       NUMERIC;
BEGIN
    v_grp_id      := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_SCTR_IPSS', '046');
    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_grp_id IS NULL OR v_concepto_id IS NULL THEN RETURN; END IF;

    IF NOT EXISTS (
        SELECT 1 FROM rrhh.gan_desct_fijo gdf
         WHERE gdf.trabajador_id = p_trabajador_id
           AND gdf.concepto_id   = v_concepto_id AND gdf.flag_estado = '1'
    ) THEN RETURN; END IF;

    SELECT COALESCE(cp.factor_pago, 0) INTO v_tasa
      FROM rrhh.concepto_planilla cp WHERE cp.id = v_concepto_id;

    IF v_tasa <= 0 THEN RETURN; END IF;

    v_base  := rrhh._sum_det_grupo(p_calculo_id, v_grp_id, 'INGRESO');
    v_monto := ROUND(v_base * v_tasa, 2);

    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'APORTE');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_apo_sctr_onp â€” Port SIGRE usp_rh_cal_apo_sctr_onp
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_apo_sctr_onp(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id      BIGINT;
    v_concepto_id BIGINT;
    v_porc        NUMERIC;
    v_base        NUMERIC;
    v_monto       NUMERIC;
BEGIN
    v_grp_id      := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_SCTR_ONP', '047');
    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_grp_id IS NULL OR v_concepto_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(s.porc_sctr_onp, 0) INTO v_porc
      FROM rrhh.trabajador t
      JOIN rrhh.seccion s ON s.id = t.seccion_id
     WHERE t.id = p_trabajador_id;

    IF v_porc <= 0 THEN RETURN; END IF;

    v_base  := rrhh._sum_det_grupo(p_calculo_id, v_grp_id, 'INGRESO');
    v_monto := ROUND(v_base * v_porc / 100.0, 2);

    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'APORTE');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_apo_senati â€” Port SIGRE usp_rh_cal_apo_senati
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_apo_senati(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_seccion_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id      BIGINT;
    v_concepto_id BIGINT;
    v_tasa        NUMERIC;
    v_base        NUMERIC;
    v_monto       NUMERIC;
    v_flag_sec    VARCHAR;
BEGIN
    v_grp_id      := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_AFECTO_SENATI', '049');
    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_grp_id IS NULL OR v_concepto_id IS NULL THEN RETURN; END IF;

    SELECT COALESCE(gc.flag_seccion, '0') INTO v_flag_sec
      FROM rrhh.grupo_calculo gc WHERE gc.id = v_grp_id;

    IF v_flag_sec = '1' AND p_seccion_id IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM rrhh.grupo_conceptos_seccion gcs
             WHERE gcs.grupo_calculo_id = v_grp_id
               AND gcs.seccion_id = p_seccion_id AND gcs.flag_estado = '1'
        ) THEN RETURN; END IF;
    END IF;

    SELECT COALESCE(cp.factor_pago, 0) INTO v_tasa
      FROM rrhh.concepto_planilla cp WHERE cp.id = v_concepto_id;

    v_base  := rrhh._sum_det_grupo(p_calculo_id, v_grp_id, 'INGRESO');
    v_monto := ROUND(v_base * v_tasa, 2);

    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'APORTE');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_otras_aport â€” Port SIGRE usp_rh_cal_otras_aport
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_otras_aport(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_ing NUMERIC;
    v_grp_id    BIGINT;
    v_base      NUMERIC;
    v_monto     NUMERIC;
    rec         RECORD;
    v_item      SMALLINT := 10;
BEGIN
    v_total_ing := rrhh._sum_det_codigo(p_calculo_id,
        rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499)::TEXT);

    FOR rec IN
        SELECT gdf.concepto_id, cp.factor_pago, cp.codigo
          FROM rrhh.gan_desct_fijo gdf
          JOIN rrhh.concepto_planilla cp ON cp.id = gdf.concepto_id
         WHERE gdf.trabajador_id = p_trabajador_id AND gdf.flag_estado = '1'
           AND cp.codigo LIKE '3%'
           AND NOT EXISTS (
               SELECT 1 FROM rrhh.calculo_det cd
                WHERE cd.calculo_id = p_calculo_id AND cd.concepto_id = gdf.concepto_id
           )
    LOOP
        SELECT gc.id INTO v_grp_id
          FROM rrhh.grupo_calculo_det gcd
          JOIN rrhh.grupo_calculo gc ON gc.id = gcd.grupo_calculo_id
         WHERE gcd.concepto_planilla_id = rec.concepto_id AND gcd.flag_estado = '1'
         LIMIT 1;

        IF v_grp_id IS NOT NULL THEN
            v_base := rrhh._sum_det_grupo(p_calculo_id, v_grp_id, 'INGRESO');
        ELSE
            v_base := v_total_ing;
        END IF;

        v_monto := ROUND(v_base * rec.factor_pago, 2);

        IF v_monto > 0 THEN
            PERFORM rrhh._upsert_det(p_calculo_id, rec.concepto_id, v_item,
                v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'APORTE');
            v_item := v_item + 1;
        END IF;
    END LOOP;
END;
$$;

-- ============================================================
-- sp_cal_cred_eps â€” Port SIGRE usp_rh_cal_cred_eps
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_cred_eps(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_ess_id    BIGINT;
    v_con_eps_id    BIGINT;
    v_tasa          NUMERIC;
    v_base          NUMERIC;
    v_monto         NUMERIC;
BEGIN
    v_con_eps_id := rrhh._fn_concepto_id(
        rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'CNC_CRED_EPS', '3010'));
    v_grp_ess_id := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_ESSALUD', '077');
    IF v_grp_ess_id IS NULL THEN RETURN; END IF;

    IF NOT EXISTS (
        SELECT 1 FROM rrhh.gan_desct_fijo gdf
         WHERE gdf.trabajador_id = p_trabajador_id
           AND gdf.concepto_id = v_con_eps_id AND gdf.flag_estado = '1'
    ) THEN RETURN; END IF;

    SELECT COALESCE(cp.factor_pago, 0) INTO v_tasa
      FROM rrhh.concepto_planilla cp WHERE cp.id = v_con_eps_id;

    v_base  := rrhh._sum_det_grupo(p_calculo_id, v_grp_ess_id, 'INGRESO');
    v_monto := ROUND(v_base * v_tasa, 2);

    IF v_monto > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_con_eps_id, 1,
            v_monto, ROUND(v_monto / p_tipo_cambio, 5), NULL, 'APORTE');
    END IF;
END;
$$;

-- ============================================================
-- sp_cal_apo_essalud â€” Port SIGRE usp_rh_cal_apo_essalud (reemplaza sp_cal_essalud)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_apo_essalud(
    p_calculo_id BIGINT, p_trabajador_id BIGINT,
    p_tipo_cambio NUMERIC, p_flag_cierre VARCHAR DEFAULT '0'
)
LANGUAGE plpgsql AS $$
DECLARE
    v_grp_id        BIGINT;
    v_concepto_id   BIGINT;
    v_con_eps_id    BIGINT;
    v_base          NUMERIC := 0;
    v_rmv           NUMERIC;
    v_tasa          NUMERIC := 0.09;
    v_aporte        NUMERIC;
    v_fec_proceso   DATE;
    v_hist_pagado   NUMERIC := 0;
BEGIN
    SELECT c.fec_proceso INTO v_fec_proceso FROM rrhh.calculo c WHERE c.id = p_calculo_id;

    v_grp_id      := rrhh._cfg_grupo_id('RRHHPARAM_CCONCEP', 'CONCEP_ESSALUD', '077');
    v_concepto_id := rrhh._grupo_concepto_gen_id(v_grp_id);
    IF v_concepto_id IS NULL THEN RETURN; END IF;

    v_rmv := rrhh._rmv_trabajador(p_trabajador_id, v_fec_proceso);
    v_base := rrhh._sum_det_grupo(p_calculo_id, v_grp_id, 'INGRESO');

    IF p_flag_cierre = '1' THEN
        v_base := GREATEST(v_base, v_rmv);
        SELECT COALESCE(SUM(cd.imp_soles), 0) INTO v_hist_pagado
          FROM rrhh.calculo c
          JOIN rrhh.calculo_det cd ON cd.calculo_id = c.id
         WHERE c.trabajador_id = p_trabajador_id
           AND cd.concepto_id IN (
               v_concepto_id,
               rrhh._fn_concepto_id(rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'CNC_ESSALUD_675', '3009'))
           )
           AND c.fec_proceso < v_fec_proceso;
        v_base := GREATEST(v_base - v_hist_pagado, 0);
    END IF;

    v_aporte := ROUND(GREATEST(v_base, v_rmv) * v_tasa, 2);

    BEGIN
        v_con_eps_id := rrhh._fn_concepto_id(
            rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'CNC_CRED_EPS', '3010'));
        IF EXISTS (
            SELECT 1 FROM rrhh.calculo_det cd
             WHERE cd.calculo_id = p_calculo_id AND cd.concepto_id = v_con_eps_id AND cd.imp_soles <> 0
        ) THEN
            v_concepto_id := rrhh._fn_concepto_id(
                rrhh._cfg_codigo('RRHHPARAM_CCONCEP', 'CNC_ESSALUD_675', '3009'));
        END IF;
    EXCEPTION WHEN OTHERS THEN NULL;
    END;

    IF v_aporte > 0 THEN
        PERFORM rrhh._upsert_det(p_calculo_id, v_concepto_id, 1,
            v_aporte, ROUND(v_aporte / p_tipo_cambio, 5), NULL, 'APORTE');
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE rrhh.sp_cal_essalud(
    p_calculo_id BIGINT, p_trabajador_id BIGINT, p_tipo_cambio NUMERIC
)
LANGUAGE plpgsql AS $$
BEGIN
    CALL rrhh.sp_cal_apo_essalud(p_calculo_id, p_trabajador_id, p_tipo_cambio, '0');
END;
$$;

-- ============================================================
-- sp_cal_limpia_ceros / sp_cal_limpia_fantasmas â€” Fases 1-3 SIGRE
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_cal_limpia_ceros(
    p_calculo_id BIGINT, p_fec_proceso DATE, p_con_tipo_planilla BOOLEAN DEFAULT TRUE
)
LANGUAGE plpgsql AS $$
DECLARE
    v_cnc_pgd VARCHAR;
BEGIN
    v_cnc_pgd := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_PGD', 2399)::TEXT;

    DELETE FROM rrhh.calculo_det cd
     WHERE cd.calculo_id = p_calculo_id
       AND COALESCE(cd.imp_soles, 0) = 0
       AND COALESCE(cd.imp_dolar, 0) = 0
       AND cd.concepto_id <> rrhh._fn_concepto_id(v_cnc_pgd);

    DELETE FROM rrhh.calculo_det cd
     WHERE cd.calculo_id = p_calculo_id
       AND cd.concepto_id NOT IN (
           SELECT cd2.concepto_id FROM rrhh.calculo_det cd2
            JOIN rrhh.concepto_planilla cp ON cp.id = cd2.concepto_id
           WHERE cd2.calculo_id = p_calculo_id
             AND cp.codigo = rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_ING', 1499)::TEXT
       );
END;
$$;

CREATE OR REPLACE PROCEDURE rrhh.sp_cal_limpia_fantasmas(
    p_fec_proceso DATE, p_tipo_planilla_id BIGINT, p_trabajador_id BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_cnc_pgd VARCHAR;
BEGIN
    v_cnc_pgd := rrhh._cfg_int('RRHHPARAM', 'CNC_TOTAL_PGD', 2399)::TEXT;

    DELETE FROM rrhh.calculo_det cd
     USING rrhh.calculo c
     WHERE cd.calculo_id = c.id
       AND c.fec_proceso = p_fec_proceso
       AND c.tipo_planilla_id = p_tipo_planilla_id
       AND (p_trabajador_id IS NULL OR c.trabajador_id = p_trabajador_id)
       AND c.trabajador_id NOT IN (
           SELECT c2.trabajador_id FROM rrhh.calculo c2
            JOIN rrhh.calculo_det cd2 ON cd2.calculo_id = c2.id
            JOIN rrhh.concepto_planilla cp ON cp.id = cd2.concepto_id
           WHERE c2.fec_proceso = p_fec_proceso
             AND cp.codigo = v_cnc_pgd
       );
END;
$$;

-- ============================================================
-- sp_calcular_planilla  â€” ORQUESTADOR PRINCIPAL
--
-- ParÃ¡metros:
--   p_origen               â€” sucursal ('PI', 'LM', etc.)
--   p_fec_proceso          â€” fecha del proceso (1er dÃ­a del mes)
--   p_tipo_planilla_codigo â€” cÃ³digo de rrhh.tipo_planilla ('N', 'Q', etc.)
--
-- Flujo por trabajador EMP activo:
--   1. Validar periodo en fechas_proceso
--   2. Obtener/crear cabecera calculo
--   3. Limpiar detalle previo (reproceso)
--   4. DÃ­as trabajados
--   5. Ganancias fijas (sueldo prorrateado, conceptos fijos)
--   6. AsignaciÃ³n familiar
--   7. Variables del perÃ­odo (propinas, HE-imp, otros)
--   8. HE calculadas por horas
--   9. Inasistencias injustificadas
--  10. Total ingresos
--  11. AFP o ONP
--  12. Quinta categorÃ­a
--  13. Total descuentos
-- Orquestador principal â€” secuencia SIGRE usp_rh_cal_calcula_planilla (31 sub-SPs EMP)
-- ============================================================
CREATE OR REPLACE PROCEDURE rrhh.sp_calcular_planilla(
    p_origen                 VARCHAR,
    p_fec_proceso            DATE,
    p_tipo_planilla_codigo   VARCHAR,
    p_flag_control           VARCHAR DEFAULT '1',
    p_flag_renta_quinta      VARCHAR DEFAULT '1',
    p_flag_dso_af            VARCHAR DEFAULT '1',
    p_flag_cierre_mes        VARCHAR DEFAULT '0',
    p_created_by             BIGINT DEFAULT NULL
)
LANGUAGE plpgsql AS $$
DECLARE
    v_tipo_planilla_id  BIGINT;
    v_tipo_emp_codigo   VARCHAR;
    v_tipo_emp_id       BIGINT;
    v_tipo_trip_codigo  VARCHAR;
    v_dias_mes          INTEGER;
    v_periodo_rec       RECORD;
    v_trab              RECORD;
    v_calculo_id        BIGINT;
    v_dias_trab         NUMERIC;
    v_tipo_cambio       NUMERIC;
    v_sucursal_id       BIGINT;
    v_contados          INTEGER := 0;
    v_errores           INTEGER := 0;
    v_anio              INTEGER;
    v_mes               INTEGER;
BEGIN
    v_anio := EXTRACT(YEAR  FROM p_fec_proceso)::INTEGER;
    v_mes  := EXTRACT(MONTH FROM p_fec_proceso)::INTEGER;

    SELECT id INTO v_tipo_planilla_id
      FROM rrhh.tipo_planilla
     WHERE codigo = TRIM(p_tipo_planilla_codigo)
       AND flag_estado = '1'
     LIMIT 1;

    IF v_tipo_planilla_id IS NULL THEN
        RAISE EXCEPTION 'Tipo de planilla no existe: %', p_tipo_planilla_codigo;
    END IF;

    v_tipo_emp_codigo  := COALESCE(rrhh._cfg_txt('RRHHPARAM', 'TIPO_TRAB_EMPLEADO'), 'EMP');
    v_tipo_trip_codigo := COALESCE(rrhh._cfg_txt('RRHHPARAM', 'TIPO_TRAB_TRIPULANTE'), 'TRI');
    v_dias_mes         := COALESCE(rrhh._cfg_int('RRHHPARAM', 'DIAS_MES_EMPLEADO'), 30);

    SELECT id INTO v_tipo_emp_id
      FROM rrhh.tipo_trabajador WHERE codigo = v_tipo_emp_codigo LIMIT 1;

    IF v_tipo_emp_id IS NULL THEN
        RAISE EXCEPTION 'No se encontrÃ³ tipo_trabajador con codigo=%', v_tipo_emp_codigo;
    END IF;

    SELECT * INTO v_periodo_rec
      FROM rrhh.fechas_proceso
     WHERE origen             = p_origen
       AND fec_proceso        = p_fec_proceso
       AND tipo_trabajador_id = v_tipo_emp_id
       AND tipo_planilla_id   = v_tipo_planilla_id
     LIMIT 1;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No existe fechas_proceso origen=%, fec=%, tipo=%',
            p_origen, p_fec_proceso, v_tipo_emp_codigo;
    END IF;

    SELECT COALESCE(core.fn_tasa_cambio_calendario(p_fec_proceso, NULL, NULL), 1.0)
      INTO v_tipo_cambio;

    IF v_tipo_cambio = 0 THEN
        RAISE EXCEPTION 'Tipo de cambio cero para %', p_fec_proceso;
    END IF;

    SELECT id INTO v_sucursal_id
      FROM auth.sucursal WHERE codigo = p_origen AND flag_estado = '1' LIMIT 1;

    FOR v_trab IN
        SELECT t.id, t.codigo_trabajador, t.admin_afp_id, t.flag_cat_trab,
               t.fecha_ingreso, t.fecha_cese, t.fecha_nacimiento,
               t.porc_judicial, t.porc_jud_util, t.seccion_id,
               tt.codigo AS tipo_trab_codigo
          FROM rrhh.trabajador t
          JOIN rrhh.tipo_trabajador tt ON tt.id = t.tipo_trabajador_id
         WHERE t.tipo_trabajador_id = v_tipo_emp_id
           AND t.flag_estado = '1'
           AND (v_sucursal_id IS NULL OR t.sucursal_id = v_sucursal_id)
           AND (t.fecha_cese IS NULL OR t.fecha_cese >= v_periodo_rec.fec_inicio)
           AND (t.fecha_ingreso IS NULL OR t.fecha_ingreso <= v_periodo_rec.fec_final)
         ORDER BY t.codigo_trabajador
    LOOP
    BEGIN
        -- #1 prom_remun_vacac (gan_desct_variable, antes de cabecera)
        CALL rrhh.sp_cal_prom_remun_vacac(
            v_trab.id, p_fec_proceso, v_tipo_planilla_id, p_created_by);

        -- #2 add_diferi_quincena
        CALL rrhh.sp_cal_add_diferi_quincena(
            v_trab.id, p_fec_proceso, p_created_by);

        CALL rrhh.sp_cal_borra_movimiento(v_trab.id, p_fec_proceso, v_tipo_planilla_id);

        INSERT INTO rrhh.calculo (
            trabajador_id, fec_proceso, fec_inicio, fec_final,
            tipo_planilla_id, sucursal_id, tipo_cambio, admin_afp_id,
            periodo, flag_replicacion, flag_estado, fec_creacion)
        VALUES (
            v_trab.id, p_fec_proceso,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_planilla_id, v_sucursal_id, v_tipo_cambio,
            COALESCE(v_trab.admin_afp_id,
                (SELECT id FROM rrhh.admin_afp WHERE nombre = 'ONP' AND flag_estado = '1' LIMIT 1)),
            TO_CHAR(p_fec_proceso, 'YYYY-MM'),
            '1', '1', NOW())
        RETURNING id INTO v_calculo_id;

        -- fn_dias_trabajados
        v_dias_trab := rrhh.fn_dias_trabajados(
            v_trab.id, v_periodo_rec.fec_inicio, v_periodo_rec.fec_final, v_dias_mes);
        UPDATE rrhh.calculo SET dias_trabajados = v_dias_trab WHERE id = v_calculo_id;

        IF p_flag_control = '1' THEN
            -- #3 ganancias_fijas
            CALL rrhh.sp_cal_ganancias_fijas(
                v_calculo_id, v_trab.id,
                v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
                v_dias_trab, v_dias_mes, v_tipo_cambio);
            -- #4 asig_familiar
            CALL rrhh.sp_cal_asig_familiar(v_calculo_id, v_trab.id, v_tipo_cambio);
            -- #5 feriado (no-op EMP)
            CALL rrhh.sp_cal_feriado(
                v_calculo_id, v_trab.id,
                v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
                v_tipo_cambio, v_dias_trab, v_tipo_planilla_id);
            -- #6 dso (no-op EMP)
            CALL rrhh.sp_cal_dso(
                v_calculo_id, v_trab.id,
                v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
                v_tipo_cambio, v_dias_trab, v_tipo_planilla_id);
        END IF;

        -- #7 vacaciones
        CALL rrhh.sp_cal_vacaciones(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, v_dias_mes, p_fec_proceso, v_tipo_planilla_id);
        -- #8 enfermedad
        CALL rrhh.sp_cal_enfermedad(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, p_fec_proceso, v_tipo_planilla_id);
        -- #9 maternidad
        CALL rrhh.sp_cal_maternidad(v_calculo_id, v_trab.id, p_fec_proceso, v_tipo_cambio);
        -- #10 reintegros
        CALL rrhh.sp_cal_reintegros(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, v_tipo_planilla_id);
        -- #11 ganancias_variables
        CALL rrhh.sp_cal_ganancias_variables(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, v_tipo_planilla_id);

        -- #12 ganancia_total
        CALL rrhh.sp_cal_ganancia_total(v_calculo_id, v_tipo_cambio);

        -- #13 snp / #14 afp
        IF COALESCE(v_trab.flag_cat_trab, '1') = '1' THEN
            IF v_trab.admin_afp_id IS NOT NULL THEN
                CALL rrhh.sp_cal_afp(v_calculo_id, v_trab.id, v_trab.admin_afp_id, v_tipo_cambio);
            ELSE
                CALL rrhh.sp_cal_snp(v_calculo_id, v_trab.id, v_tipo_cambio);
            END IF;
        END IF;

        -- #15 quinta_categoria
        IF p_flag_renta_quinta = '1' THEN
            CALL rrhh.sp_cal_quinta_categoria(
                v_calculo_id, v_trab.id, p_fec_proceso, v_tipo_cambio, v_tipo_planilla_id);
        END IF;

        -- #16 descuentos_fijos
        CALL rrhh.sp_cal_descuentos_fijos(v_calculo_id, v_trab.id, v_tipo_cambio);
        -- #17 desct_comedor
        CALL rrhh.sp_cal_desct_comedor(v_calculo_id, v_trab.id, v_tipo_cambio);
        -- #18 descuento_variable
        CALL rrhh.sp_cal_descuento_variable(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, v_tipo_planilla_id);
        -- #19 tardanzas
        CALL rrhh.sp_cal_tardanzas(
            v_calculo_id, v_trab.id,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final, v_tipo_cambio);
        -- #20 porcentaje_judicial
        CALL rrhh.sp_cal_porcentaje_judicial(
            v_calculo_id, v_trab.id, p_fec_proceso, v_tipo_cambio,
            v_trab.porc_judicial, v_trab.porc_jud_util, v_tipo_planilla_id, p_created_by);
        -- #21 essalud_vida
        CALL rrhh.sp_cal_essalud_vida(
            v_calculo_id, v_trab.id, p_fec_proceso,
            v_periodo_rec.fec_inicio, v_periodo_rec.fec_final,
            v_tipo_cambio, v_tipo_planilla_id);
        -- #22 cuenta_corriente
        CALL rrhh.sp_cal_cuenta_corriente(
            v_calculo_id, v_trab.id, p_fec_proceso, v_tipo_cambio, p_created_by);

        -- #23 descuento_total
        CALL rrhh.sp_cal_descuento_total(v_calculo_id, v_tipo_cambio);
        -- #24 total_pagado
        CALL rrhh.sp_cal_total_pagado(v_calculo_id, v_tipo_cambio);

        -- #25 apo_sctr_ipss
        CALL rrhh.sp_cal_apo_sctr_ipss(v_calculo_id, v_trab.id, v_tipo_cambio);
        -- #26 apo_sctr_onp
        CALL rrhh.sp_cal_apo_sctr_onp(v_calculo_id, v_trab.id, v_tipo_cambio);
        -- #27 apo_senati (EMP â‰  TRI)
        IF v_trab.tipo_trab_codigo <> v_tipo_trip_codigo THEN
            CALL rrhh.sp_cal_apo_senati(
                v_calculo_id, v_trab.id, v_trab.seccion_id, v_tipo_cambio);
        END IF;
        -- #28 otras_aport
        CALL rrhh.sp_cal_otras_aport(v_calculo_id, v_trab.id, v_tipo_cambio);

        -- Limpieza fase 1 (SIGRE Â§7)
        CALL rrhh.sp_cal_limpia_ceros(v_calculo_id, p_fec_proceso);

        -- #29 cred_eps
        CALL rrhh.sp_cal_cred_eps(v_calculo_id, v_trab.id, v_tipo_cambio);
        -- #30 apo_essalud
        CALL rrhh.sp_cal_apo_essalud(
            v_calculo_id, v_trab.id, v_tipo_cambio, p_flag_cierre_mes);
        -- #31 apo_total
        CALL rrhh.sp_cal_apo_total(v_calculo_id, v_tipo_cambio);

        -- Limpieza fases 2-3
        CALL rrhh.sp_cal_limpia_ceros(v_calculo_id, p_fec_proceso, FALSE);
        CALL rrhh.sp_cal_limpia_fantasmas(p_fec_proceso, v_tipo_planilla_id, v_trab.id);

        v_contados := v_contados + 1;

    EXCEPTION
        WHEN OTHERS THEN
            v_errores := v_errores + 1;
            RAISE WARNING 'Error trabajador %: % â€” %',
                v_trab.codigo_trabajador, SQLERRM, SQLSTATE;
    END;
    END LOOP;

    RAISE NOTICE 'sp_calcular_planilla: % OK, % errores', v_contados, v_errores;

    IF v_contados = 0 AND v_errores = 0 THEN
        RAISE WARNING 'Sin trabajadores EMP para origen=%, fec=%', p_origen, p_fec_proceso;
    END IF;
END;
$$;

-- ============================================================
-- fn_validar_calculo_referencia â€” compara motor vs seed 14 (CALCULO.json)
-- Retorna filas con diferencia de importe mayor a p_tolerancia.
-- ============================================================
CREATE OR REPLACE FUNCTION rrhh.fn_validar_calculo_referencia(
    p_origen            VARCHAR,
    p_fec_proceso       DATE,
    p_tipo_planilla_id  BIGINT,
    p_tolerancia        NUMERIC DEFAULT 0.02
)
RETURNS TABLE (
    codigo_trabajador   VARCHAR,
    concepto_codigo     VARCHAR,
    imp_referencia      NUMERIC,
    imp_calculado       NUMERIC,
    diferencia          NUMERIC
)
LANGUAGE sql STABLE AS $$
    SELECT t.codigo_trabajador,
           cp.codigo AS concepto_codigo,
           ref.imp_soles AS imp_referencia,
           calc.imp_soles AS imp_calculado,
           ABS(COALESCE(ref.imp_soles, 0) - COALESCE(calc.imp_soles, 0)) AS diferencia
      FROM rrhh.calculo_referencia ref_c
      JOIN rrhh.trabajador t ON t.id = ref_c.trabajador_id
      JOIN auth.sucursal s ON s.id = ref_c.sucursal_id AND s.codigo = p_origen
      JOIN rrhh.calculo_det_referencia ref ON ref.calculo_id = ref_c.id
      JOIN rrhh.concepto_planilla cp ON cp.id = ref.concepto_id
      JOIN rrhh.calculo calc_c
        ON calc_c.trabajador_id = ref_c.trabajador_id
       AND calc_c.fec_proceso = p_fec_proceso
       AND calc_c.tipo_planilla_id = p_tipo_planilla_id
       AND calc_c.sucursal_id = ref_c.sucursal_id
      JOIN rrhh.calculo_det calc
        ON calc.calculo_id = calc_c.id
       AND calc.concepto_id = ref.concepto_id
       AND calc.item = ref.item
     WHERE ref_c.fec_proceso = p_fec_proceso
       AND ref_c.tipo_planilla_id = p_tipo_planilla_id
       AND ABS(COALESCE(ref.imp_soles, 0) - COALESCE(calc.imp_soles, 0)) > p_tolerancia;
$$;
