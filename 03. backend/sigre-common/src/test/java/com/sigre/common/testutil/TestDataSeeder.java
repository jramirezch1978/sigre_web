package com.sigre.common.testutil;

import org.springframework.jdbc.core.JdbcTemplate;
import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

/**
 * Inserts TRANSACTIONAL test data into the tenant database for integration tests.
 * Master data (moneda, sucursal, doc_tipo, articulo_mov_tipo, almacen_tipo, almacen,
 * banco, banco_cnta, cntbl_libro, cencos, etc.) is already loaded by the DDL seed
 * scripts (01-carga-inicial-maestros.sql) and should NOT be duplicated here.
 *
 * Each seed method automatically calls its FK dependencies first (idempotent,
 * tracked by {@code seeded} set to avoid duplicate execution in the same instance).
 *
 * Usage from any microservice test:
 * <pre>
 *   &#64;Autowired DataSource dataSource;
 *   &#64;BeforeEach void seed() { new TestDataSeeder(dataSource).seedAll(); }
 * </pre>
 *
 * Or call individual methods (dependencies resolve automatically):
 * <pre>
 *   new TestDataSeeder(dataSource).seedValeMov();
 * </pre>
 */
public class TestDataSeeder {

    private final JdbcTemplate jdbc;
    private final Set<String> seeded = new HashSet<>();

    public TestDataSeeder(DataSource dataSource) {
        this.jdbc = new JdbcTemplate(dataSource);
    }

    public TestDataSeeder(JdbcTemplate jdbcTemplate) {
        this.jdbc = jdbcTemplate;
    }

    private void resetSequence(String sql) {
        jdbc.queryForObject(sql, Long.class);
    }

    public void seedAll() {
        seedMoneda();
        seedTiposDocumento();
        seedSucursal();
        seedCentrosCosto();
        seedArticulo();
        seedEntidadContribuyente();
        seedActualizarFlagsProveedorCliente();
        seedConceptoFinanciero();
        seedPlanContable();
        seedUbicacionAlmacen();
        seedLotePallet();
        seedAlmacenUser();
        seedAlmacenTipoMov();
        seedValeMov();
        seedGuia();
        seedOrdenTraslado();
        seedInventarioConteo();
        seedSolicitudSalida();
        seedArticuloBonificacion();
        seedArticuloAlmacen();
        seedArticuloAlmacenPosicion();
        seedArticuloSaldoMensual();
        seedCntasPagar();
        seedCntasCobrar();
        seedDocTipo();
        seedDocTipoNumSerie();
        seedComprador();
        seedAprobadorConfigurado();
        seedServicio();
    }

    // ==================== CORE (no seed in SQL) ====================

    public void seedMoneda() {
        if (!seeded.add("moneda")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.moneda WHERE id IN (1,2)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO core.moneda (id, codigo, sigla_moneda, nombre, simbolo, decimales, flag_estado) VALUES
                (1, 'PEN', 'S/.', 'Soles', 'S/', 2, '1'),
                (2, 'USD', 'US$', 'Dolares Americanos', 'US$', 2, '1')
                """);
            resetSequence("SELECT setval('core.moneda_id_seq', 2)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de moneda ya existen, omitiendo inserción");
        }
    }

    public void seedTiposDocumento() {
        if (!seeded.add("tipos_documento")) return;
        
        // Verificar si la tabla existe usando to_regclass (retorna null si no existe)
        String tableExists = jdbc.queryForObject(
            "SELECT to_regclass('core.tipos_documento_identidad')", 
            String.class);
        
        if (tableExists == null) {
            // La tabla no existe, omitir este seeder
            System.out.println("ℹ️ Tabla core.tipos_documento_identidad no existe, omitiendo inserción");
            return;
        }
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.tipos_documento_identidad WHERE id IN (1,6)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO core.tipos_documento_identidad (id, codigo, descripcion, abreviatura, flag_estado) VALUES
                (1, '6', 'RUC', 'RUC', '1'),
                (6, '1', 'DNI', 'DNI', '1')
                """);
            resetSequence("SELECT setval('core.tipos_documento_identidad_id_seq', 6)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de tipos_documento ya existen, omitiendo inserción");
        }
    }

    /**
     * Seeds core.doc_tipo with document type codes required by compras (OC, OS, SC, SS)
     * and finanzas/ventas (FAC, BOL, RET, GRR, LCO, FAP).
     * Creates the table if it doesn't exist in the tenant database.
     */
    public void seedDocTipo() {
        if (!seeded.add("doc_tipo")) return;

        String tableExists = jdbc.queryForObject(
            "SELECT to_regclass('core.doc_tipo')::text", String.class);

        if (tableExists == null) {
            jdbc.execute("""
                CREATE TABLE core.doc_tipo (
                    id BIGSERIAL PRIMARY KEY,
                    codigo VARCHAR(20) NOT NULL UNIQUE,
                    nombre VARCHAR(120) NOT NULL,
                    sunat_codigo VARCHAR(20),
                    flag_estado VARCHAR(1) NOT NULL DEFAULT '1',
                    created_by BIGINT,
                    fec_creacion TIMESTAMPTZ DEFAULT NOW(),
                    updated_by BIGINT,
                    fec_modificacion TIMESTAMPTZ
                )
                """);
        }

        jdbc.update("""
            INSERT INTO core.doc_tipo (codigo, nombre, sunat_codigo, flag_estado, created_by, fec_creacion) VALUES
            ('OC',  'ORDEN DE COMPRA',              NULL, '1', 1, NOW()),
            ('OS',  'ORDEN DE SERVICIO',            NULL, '1', 1, NOW()),
            ('SC',  'SOLICITUD DE COMPRA',          NULL, '1', 1, NOW()),
            ('SS',  'SOLICITUD DE SERVICIO',        NULL, '1', 1, NOW()),
            ('FAP', 'FACTURA X PAGAR',              '01', '1', 1, NOW()),
            ('FAC', 'FACTURA',                      '01', '1', 1, NOW()),
            ('BOL', 'BOLETA DE VENTA',              '03', '1', 1, NOW()),
            ('RET', 'RETENCION',                    '20', '1', 1, NOW()),
            ('GRR', 'GUIA DE REMISION REMITENTE',   '09', '1', 1, NOW()),
            ('LCO', 'LETRA DE CANJE',               NULL, '1', 1, NOW())
            ON CONFLICT (codigo) DO NOTHING
            """);
    }

    public void seedSucursal() {
        if (!seeded.add("sucursal")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM auth.sucursal WHERE id IN (1)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO auth.sucursal (id, codigo, nombre, direccion, ciudad, moneda_defult_id, pais_id, departamento_id, provincia_id, distrito_id, ubigeo, flag_estado) VALUES
                (1, 'LM', 'SEDE LIMA', 'Av. Principal 123', 'LIMA', 1, 1, 1, 1, 1, '150101', '1')
                """);
            resetSequence("SELECT setval('auth.sucursal_id_seq', 1)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de sucursal ya existen, omitiendo inserción");
        }
    }

    public void seedCentrosCosto() {
        if (!seeded.add("centros_costo")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.centros_costo WHERE id IN (1)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO contabilidad.centros_costo (id, cencos, desc_cencos, flag_estado) VALUES
                (1, 'CC001', 'CENTRO COSTO GENERAL', '1')
                """);
            resetSequence("SELECT setval('contabilidad.centros_costo_id_seq', 1)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de centros_costo ya existen, omitiendo inserción");
        }
    }

    public void seedArticulo() {
        if (!seeded.add("articulo")) return;
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.articulo WHERE flag_estado = '1'", Integer.class);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
            SELECT v.id, v.codigo, v.nombre, v.tipo,
                   COALESCE((SELECT um.id FROM core.unidad_medida um WHERE um.codigo = v.um_cod), 1),
                   COALESCE((SELECT ac.id FROM core.articulo_categ ac WHERE ac.cat_art = v.cat_cod), 1),
                   v.precio, '1'
            FROM (VALUES
                (1, 'ART-001', 'Arroz Extra Granel',    'BIEN', 'KG',  'MP',  3.50),
                (2, 'ART-002', 'Aceite Vegetal 1L',     'BIEN', 'UNI', 'INS', 8.90),
                (3, 'ART-003', 'Lomo Fino kg',          'BIEN', 'KG',  'MP',  42.00),
                (4, 'ART-004', 'Caja Descartable x100', 'BIEN', 'UNI', 'ENV', 25.00),
                (5, 'ART-005', 'Pollo Entero kg',       'BIEN', 'KG',  'MP',  12.50)
            ) AS v(id, codigo, nombre, tipo, um_cod, cat_cod, precio)
            ON CONFLICT (codigo) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = '1'
            """);
    }

    public void seedEntidadContribuyente() {
        if (!seeded.add("entidad_contribuyente")) return;
        
        // Validar por ID individual para manejar casos parciales
        for (Long id : new Long[]{1L, 2L, 3L}) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM core.entidad_contribuyente WHERE id = ?", 
                Integer.class, id);
            
            if (count == null || count == 0) {
                // No existe, insertar con todos los campos obligatorios
                if (id == 1) {
                    jdbc.update("""
                        INSERT INTO core.entidad_contribuyente 
                        (id, tipo_persona, tipo_documento, nro_documento, razon_social, 
                         es_proveedor, es_cliente, es_empleado, flag_estado, created_by, fec_creacion) 
                        VALUES (1, 'JURIDICA', 'RUC', '20123456789', 'PROVEEDOR DEMO S.A.C.', 
                                TRUE, FALSE, FALSE, '1', 1, NOW())
                        """);
                } else if (id == 2) {
                    jdbc.update("""
                        INSERT INTO core.entidad_contribuyente 
                        (id, tipo_persona, tipo_documento, nro_documento, razon_social, 
                         es_proveedor, es_cliente, es_empleado, flag_estado, created_by, fec_creacion) 
                        VALUES (2, 'JURIDICA', 'RUC', '20987654321', 'CLIENTE DEMO E.I.R.L.', 
                                FALSE, TRUE, FALSE, '1', 1, NOW())
                        """);
                } else if (id == 3) {
                    jdbc.update("""
                        INSERT INTO core.entidad_contribuyente 
                        (id, tipo_persona, tipo_documento, nro_documento, razon_social, 
                         es_proveedor, es_cliente, es_empleado, flag_estado, created_by, fec_creacion) 
                        VALUES (3, 'JURIDICA', 'RUC', '20111222333', 'TRANSPORTES ABC S.A.', 
                                FALSE, FALSE, FALSE, '1', 1, NOW())
                        """);
                }
            } else {
                // Ya existe, actualizar solo campos necesarios
                if (id == 1) {
                    jdbc.update("""
                        UPDATE core.entidad_contribuyente SET
                            tipo_persona = 'JURIDICA',
                            tipo_documento = 'RUC',
                            razon_social = 'PROVEEDOR DEMO S.A.C.',
                            es_proveedor = TRUE,
                            flag_estado = '1'
                        WHERE id = 1
                        """);
                } else if (id == 2) {
                    jdbc.update("""
                        UPDATE core.entidad_contribuyente SET
                            tipo_persona = 'JURIDICA',
                            tipo_documento = 'RUC',
                            razon_social = 'CLIENTE DEMO E.I.R.L.',
                            es_cliente = TRUE,
                            flag_estado = '1'
                        WHERE id = 2
                        """);
                } else if (id == 3) {
                    jdbc.update("""
                        UPDATE core.entidad_contribuyente SET
                            tipo_persona = 'JURIDICA',
                            tipo_documento = 'RUC',
                            razon_social = 'TRANSPORTES ABC S.A.',
                            flag_estado = '1'
                        WHERE id = 3
                        """);
                }
            }
        }
        
        resetSequence("SELECT setval('core.entidad_contribuyente_id_seq', GREATEST((SELECT MAX(id) FROM core.entidad_contribuyente), 3))");
    }

    public void seedActualizarFlagsProveedorCliente() {
        if (!seeded.add("flags_proveedor_cliente")) return;
        
        // Los flags ya se asignan en seedEntidadContribuyente()
        // Este método se mantiene por compatibilidad pero ya no hace nada
        // porque seedEntidadContribuyente() ahora incluye tipo_persona, tipo_documento y flags
    }

    public void seedConceptoFinanciero() {
        if (!seeded.add("concepto_financiero")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.concepto_financiero WHERE id IN (1,2,3,4)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                (1, 'CF001', 'Cobro por ventas', '1'),
                (2, 'CF002', 'Pago a proveedores', '1'),
                (3, 'CF003', 'Transferencia entre cuentas', '1'),
                (4, 'CF004', 'Aplicacion de documentos', '1')
                """);
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de concepto_financiero ya existen, omitiendo inserción");
        }
    }

    public void seedBanco() {
        if (!seeded.add("banco")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.banco WHERE id IN (1,2)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO finanzas.banco (id, cod_banco, nombre, flag_estado) VALUES
                (1, '001', 'BANCO DE LA NACION', '1'),
                (2, '002', 'BANCO CREDITO', '1')
                """);
            resetSequence("SELECT setval('finanzas.banco_id_seq', 2)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de banco ya existen, omitiendo inserción");
        }
    }

    public void seedBancoCnta() {
        if (!seeded.add("banco_cnta")) return;
        
        // Verificar si los IDs ya existen antes de insertar
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.banco_cnta WHERE id IN (1,2)", 
            Integer.class);
        
        if (count == null || count == 0) {
            // No existen los IDs, podemos insertar safely
            jdbc.update("""
                INSERT INTO finanzas.banco_cnta (id, banco_id, cod_ctabco, descripcion, plan_contable_det_id, moneda_id, correlativo_cheque, flag_estado) VALUES
                (1, 1, '001-123456', 'CUENTA BANCARIA 1', 2, 1, 0, '1'),
                (2, 2, '002-789012', 'CUENTA BANCARIA 2', 2, 1, 0, '1')
                """);
            resetSequence("SELECT setval('finanzas.banco_cnta_id_seq', 2)");
        } else {
            // Los datos ya existen, no hacer nada
            System.out.println("ℹ️ Datos de banco_cnta ya existen, omitiendo inserción");
        }
    }

    public void seedPlanContable() {
        if (!seeded.add("plan_contable")) return;
        
        // Validar por ID individual para plan_contable
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.plan_contable WHERE id = 1", 
            Integer.class);
        
        if (count == null || count == 0) {
            jdbc.update("""
                INSERT INTO contabilidad.plan_contable (id, codigo, nombre, anio, effective_from, flag_estado)
                VALUES (1, 'PCGE-2026', 'Plan Contable General Empresarial 2026', 2026, DATE '2026-01-01', '1')
                """);
        } else {
            jdbc.update("""
                UPDATE contabilidad.plan_contable SET 
                    nombre = 'Plan Contable General Empresarial 2026',
                    effective_from = DATE '2026-01-01'
                WHERE id = 1
                """);
        }
        
        // Validar por ID individual para plan_contable_det
        for (int i = 1; i <= 12; i++) {
            Integer countDet = jdbc.queryForObject(
                "SELECT COUNT(*) FROM contabilidad.plan_contable_det WHERE id = ?", 
                Integer.class, i);
            
            if (countDet == null || countDet == 0) {
                // Insertar según el ID
                switch (i) {
                    case 1:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (1, 1, '10', 'Efectivo y Equivalentes de Efectivo', 1, 'DEUDORA', 'BALANCE', '1')");
                        break;
                    case 2:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (2, 1, '1011', 'Caja', 2, 'DEUDORA', 'BALANCE', '1')");
                        break;
                    case 3:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (3, 1, '12', 'Cuentas por Cobrar Comerciales', 1, 'DEUDORA', 'BALANCE', '1')");
                        break;
                    case 4:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (4, 1, '1212', 'Emitidas en cartera', 2, 'DEUDORA', 'BALANCE', '1')");
                        break;
                    case 5:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (5, 1, '40', 'Tributos por Pagar', 1, 'ACREEDORA', 'BALANCE', '1')");
                        break;
                    case 6:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (6, 1, '4011', 'IGV Cuenta Propia', 2, 'ACREEDORA', 'BALANCE', '1')");
                        break;
                    case 7:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (7, 1, '42', 'Cuentas por Pagar Comerciales', 1, 'ACREEDORA', 'BALANCE', '1')");
                        break;
                    case 8:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (8, 1, '4212', 'Emitidas', 2, 'ACREEDORA', 'BALANCE', '1')");
                        break;
                    case 9:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (9, 1, '60', 'Compras', 1, 'DEUDORA', 'RESULTADO', '1')");
                        break;
                    case 10:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (10, 1, '6011', 'Mercaderias', 2, 'DEUDORA', 'RESULTADO', '1')");
                        break;
                    case 11:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (11, 1, '70', 'Ventas', 1, 'ACREEDORA', 'RESULTADO', '1')");
                        break;
                    case 12:
                        jdbc.update("INSERT INTO contabilidad.plan_contable_det (id, plan_contable_id, cnta_ctbl, desc_cnta, niv_cnta, naturaleza, tipo, flag_estado) VALUES (12, 1, '7011', 'Mercaderias Terceros', 2, 'ACREEDORA', 'RESULTADO', '1')");
                        break;
                }
            }
        }
        
        resetSequence("SELECT setval('contabilidad.plan_contable_id_seq', GREATEST((SELECT MAX(id) FROM contabilidad.plan_contable), 1))");
        resetSequence("SELECT setval('contabilidad.plan_contable_det_id_seq', GREATEST((SELECT MAX(id) FROM contabilidad.plan_contable_det), 12))");
    }

    // ==================== ALMACEN TRANSACTIONAL ====================

    /**
     * Assigns usuario_id=1 to all active almacenes.
     * No FK dependencies on other transactional tables.
     */
    public void seedAlmacenUser() {
        if (!seeded.add("almacen_user")) return;
        jdbc.update("DELETE FROM almacen.almacen_user");
        jdbc.update("""
            INSERT INTO almacen.almacen_user (almacen_id, usuario_id, flag_estado)
            SELECT a.id, 1, '1' FROM almacen.almacen a WHERE a.flag_estado = '1'
            """);
    }

    /**
     * Associates all active mov types to all active almacenes.
     * No FK dependencies on other transactional tables.
     */
    public void seedAlmacenTipoMov() {
        if (!seeded.add("almacen_tipo_mov")) return;
        jdbc.update("DELETE FROM almacen.almacen_tipo_mov");
        jdbc.update("""
            INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado)
            SELECT a.id, t.id, '1'
            FROM almacen.almacen a
            CROSS JOIN almacen.articulo_mov_tipo t
            WHERE a.flag_estado = '1' AND t.flag_estado = '1'
            ON CONFLICT (almacen_id, articulo_mov_tipo_id) DO NOTHING
            """);
    }

    /**
     * Creates a minimal set of ubicaciones for active almacenes.
     * Used by vale_mov_det (optional) and inventario_conteo.
     */
    public void seedUbicacionAlmacen() {
        if (!seeded.add("ubicacion_almacen")) return;
        jdbc.update("DELETE FROM almacen.ubicacion_almacen");
        jdbc.update("""
            INSERT INTO almacen.ubicacion_almacen (id, almacen_id, codigo, nombre, pasillo, estante, nivel)
            SELECT v.id, a.id, v.codigo, v.nombre, v.pasillo, v.estante, v.nivel
            FROM (VALUES
                (1, 'PICK-01', 'Picking 01', 'A', '01', '01'),
                (2, 'PICK-02', 'Picking 02', 'A', '01', '02')
            ) AS v(id, codigo, nombre, pasillo, estante, nivel)
            JOIN almacen.almacen a ON a.flag_estado = '1'
            ORDER BY a.id
            LIMIT 1
            """);
        resetSequence("SELECT setval('almacen.ubicacion_almacen_id_seq', GREATEST((SELECT MAX(id) FROM almacen.ubicacion_almacen), 2))");
    }

    /**
     * Creates sample lote_pallet rows.
     */
    public void seedLotePallet() {
        if (!seeded.add("lote_pallet")) return;
        seedArticulo();
        jdbc.update("DELETE FROM almacen.lote_pallet");
        jdbc.update("""
            INSERT INTO almacen.lote_pallet (id, almacen_id, articulo_id, nro_lote, fecha_produccion, fecha_vencimiento, observacion, flag_estado)
            SELECT v.id, a.id, art.id, v.nro_lote, v.f_prod::date, v.f_venc::date, v.obs, '1'
            FROM (VALUES
                (1, 'ART-001', 'L-2026-001', CURRENT_DATE - 5, CURRENT_DATE + 90, 'Lote demo'),
                (2, 'ART-005', 'L-2026-002', CURRENT_DATE - 2, CURRENT_DATE + 30, 'Lote demo 2')
            ) AS v(id, art_cod, nro_lote, f_prod, f_venc, obs)
            JOIN almacen.almacen a ON a.flag_estado = '1'
            JOIN core.articulo art ON art.codigo = v.art_cod
            ORDER BY a.id
            LIMIT 2
            """);
        resetSequence("SELECT setval('almacen.lote_pallet_id_seq', GREATEST((SELECT MAX(id) FROM almacen.lote_pallet), 2))");
    }

    /**
     * Creates sample vale_mov + vale_mov_det.
     * Automatically calls its transactional dependencies first.
     */
    public void seedValeMov() {
        if (!seeded.add("vale_mov")) return;

        seedArticulo();
        seedEntidadContribuyente();
        seedAlmacenUser();
        seedAlmacenTipoMov();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.vale_mov_det");
        jdbc.update("DELETE FROM almacen.vale_mov");

        jdbc.update("""
            INSERT INTO almacen.vale_mov (id, sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale, proveedor_id, flag_estado)
            SELECT 1, s.id, a.id, t.id, ?::date, 'LM2026000001', e.id, '1'
            FROM auth.sucursal s, almacen.almacen a, almacen.articulo_mov_tipo t, core.entidad_contribuyente e
            WHERE s.codigo = 'LM' AND a.codigo LIKE '%MP%' AND t.tipo_mov = 'I01' AND e.id = 1
            LIMIT 1
            """, today);

        jdbc.update("""
            INSERT INTO almacen.vale_mov (id, sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale, flag_estado)
            SELECT 2, s.id, a.id, t.id, ?::date, 'LM2026000002', '1'
            FROM auth.sucursal s, almacen.almacen a, almacen.articulo_mov_tipo t
            WHERE s.codigo = 'LM' AND a.codigo LIKE '%MP%' AND t.tipo_mov = 'S01'
            LIMIT 1
            """, today);

        jdbc.update("""
            INSERT INTO almacen.vale_mov (id, sucursal_id, almacen_id, articulo_mov_tipo_id, fecha_mov, nro_vale, proveedor_id, flag_estado)
            SELECT 3, s.id, a.id, t.id, ?::date, 'LM2026000003', e.id, '1'
            FROM auth.sucursal s, almacen.almacen a, almacen.articulo_mov_tipo t, core.entidad_contribuyente e
            WHERE s.codigo = 'LM' AND a.codigo LIKE '%PT%' AND t.tipo_mov = 'I01' AND e.id = 1
            LIMIT 1
            """, today);

        jdbc.update("""
            INSERT INTO almacen.vale_mov_det (id, vale_mov_id, articulo_id, cant_procesada, costo_unitario, moneda_id, flag_estado)
            SELECT v.id, v.vale_mov_id, art.id, v.cant, v.costo, m.id, '1'
            FROM (VALUES
                (1, 1, 'ART-001', 100.0000, 3.5000),
                (2, 1, 'ART-003',  50.0000, 42.0000),
                (3, 2, 'ART-001',  20.0000, 3.5000),
                (4, 3, 'ART-005', 200.0000, 12.5000)
            ) AS v(id, vale_mov_id, art_cod, cant, costo)
            JOIN core.articulo art ON art.codigo = v.art_cod
            JOIN core.moneda m ON m.codigo = 'PEN'
            """);

        resetSequence("SELECT setval('almacen.vale_mov_id_seq', GREATEST((SELECT MAX(id) FROM almacen.vale_mov), 3))");
        resetSequence("SELECT setval('almacen.vale_mov_det_id_seq', GREATEST((SELECT MAX(id) FROM almacen.vale_mov_det), 4))");
    }

    /**
     * Creates a guia + guia_det linked (optionally) to a vale_mov.
     */
    public void seedGuia() {
        if (!seeded.add("guia")) return;

        seedEntidadContribuyente();
        seedValeMov();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.guia_det");
        jdbc.update("DELETE FROM almacen.guia");

        jdbc.update("""
            INSERT INTO almacen.guia (id, sucursal_id, serie, numero, fecha_emision, fecha_traslado,
                                      motivo_traslado_id, destinatario_id, transportista_id, vale_mov_id, estado, flag_estado)
            SELECT 1, s.id, 'T001', '00000001', ?::date, ?::date,
                   mt.id, dest.id, trans.id, vm.id, 'EMITIDA', '1'
            FROM auth.sucursal s
            JOIN almacen.motivo_traslado mt ON mt.codigo IS NOT NULL
            JOIN core.entidad_contribuyente dest ON dest.id = 2
            JOIN core.entidad_contribuyente trans ON trans.id = 3
            JOIN almacen.vale_mov vm ON vm.id = 1
            WHERE s.codigo = 'LM'
            ORDER BY mt.id
            LIMIT 1
            """, today, today);

        jdbc.update("""
            INSERT INTO almacen.guia_det (id, guia_id, vale_mov_id, articulo_id, unidad_medida_id, cantidad, flag_estado)
            SELECT 1, 1, 1, art.id, art.unidad_medida_id, 10.0000, '1'
            FROM core.articulo art
            WHERE art.codigo = 'ART-001'
            """);

        resetSequence("SELECT setval('almacen.guia_id_seq', GREATEST((SELECT MAX(id) FROM almacen.guia), 1))");
        resetSequence("SELECT setval('almacen.guia_det_id_seq', GREATEST((SELECT MAX(id) FROM almacen.guia_det), 1))");
    }

    /**
     * Creates an orden_traslado with one detail. Used by integration flows and vale_mov FK.
     */
    public void seedOrdenTraslado() {
        if (!seeded.add("orden_traslado")) return;

        seedArticulo();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.orden_traslado_det");
        jdbc.update("DELETE FROM almacen.orden_traslado");

        jdbc.update("""
            INSERT INTO almacen.orden_traslado (id, almacen_origen_id, almacen_destino_id, nro_orden_traslado, fecha, estado, observacion)
            SELECT 1, a1.id, a2.id, 'OT202600001', ?::date, 'BORRADOR', 'OT demo'
            FROM almacen.almacen a1
            JOIN almacen.almacen a2 ON a2.id <> a1.id
            WHERE a1.flag_estado='1' AND a2.flag_estado='1'
            ORDER BY a1.id, a2.id
            LIMIT 1
            """, today);

        jdbc.update("""
            INSERT INTO almacen.orden_traslado_det (id, orden_traslado_id, articulo_id, cantidad, cantidad_despachada, cantidad_recibida)
            SELECT 1, 1, art.id, 5.0000, 0, 0
            FROM core.articulo art
            WHERE art.codigo = 'ART-001'
            """);

        resetSequence("SELECT setval('almacen.orden_traslado_id_seq', GREATEST((SELECT MAX(id) FROM almacen.orden_traslado), 1))");
        resetSequence("SELECT setval('almacen.orden_traslado_det_id_seq', GREATEST((SELECT MAX(id) FROM almacen.orden_traslado_det), 1))");
    }

    /**
     * Creates sample inventario_conteo row referencing almacen/articulo/ubicacion and (optional) vale_mov.
     */
    public void seedInventarioConteo() {
        if (!seeded.add("inventario_conteo")) return;

        seedUbicacionAlmacen();
        seedArticulo();
        seedValeMov();
        seedLotePallet();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.inventario_conteo");
        jdbc.update("""
            INSERT INTO almacen.inventario_conteo (
                id, almacen_id, articulo_id, fecha_conteo, nro_conteo,
                saldo_sistema, cantidad_conteo_1, auditor_conteo_1, nro_ficha_conteo_1,
                costo_unitario, diferencia, vale_mov_ajuste_id, lote_pallet_id, ubicacion_id, estado
            )
            SELECT 1, a.id, art.id, ?::date, 1,
                   100.0000, 98.0000, 'AUDITOR 1', 'FICHA-001',
                   3.5000, -2.0000, vm.id, lp.id, ub.id, 'EN_PROCESO'
            FROM almacen.almacen a
            JOIN core.articulo art ON art.codigo = 'ART-001'
            JOIN almacen.vale_mov vm ON vm.id = 1
            LEFT JOIN almacen.lote_pallet lp ON lp.id = 1
            JOIN almacen.ubicacion_almacen ub ON ub.id = 1
            WHERE a.flag_estado='1'
            ORDER BY a.id
            LIMIT 1
            """, today);
        resetSequence("SELECT setval('almacen.inventario_conteo_id_seq', GREATEST((SELECT MAX(id) FROM almacen.inventario_conteo), 1))");
    }

    /**
     * Creates sol_salida + sol_salida_det.
     */
    public void seedSolicitudSalida() {
        if (!seeded.add("sol_salida")) return;

        seedArticulo();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.sol_salida_det");
        jdbc.update("DELETE FROM almacen.sol_salida");

        jdbc.update("""
            INSERT INTO almacen.sol_salida (id, almacen_id, nro_sol_salida, fecha, estado, observacion)
            SELECT 1, a.id, 'SS202600001', ?::date, 'BORRADOR', 'Solicitud demo'
            FROM almacen.almacen a
            WHERE a.flag_estado='1'
            ORDER BY a.id
            LIMIT 1
            """, today);

        jdbc.update("""
            INSERT INTO almacen.sol_salida_det (id, sol_salida_id, articulo_id, cantidad, cantidad_despachada)
            SELECT 1, 1, art.id, 3.0000, 0
            FROM core.articulo art
            WHERE art.codigo='ART-001'
            """);

        resetSequence("SELECT setval('almacen.sol_salida_id_seq', GREATEST((SELECT MAX(id) FROM almacen.sol_salida), 1))");
        resetSequence("SELECT setval('almacen.sol_salida_det_id_seq', GREATEST((SELECT MAX(id) FROM almacen.sol_salida_det), 1))");
    }

    /**
     * Creates one articulo_bonificacion record for ART-001.
     */
    public void seedArticuloBonificacion() {
        if (!seeded.add("articulo_bonificacion")) return;
        seedArticulo();
        jdbc.update("DELETE FROM almacen.articulo_bonificacion");
        jdbc.update("""
            INSERT INTO almacen.articulo_bonificacion (id, articulo_id, cantidad_minima, cantidad_bonificacion, fecha_inicio, fecha_fin, flag_estado)
            SELECT 1, art.id, 10.0000, 1.0000, CURRENT_DATE - 1, CURRENT_DATE + 30, '1'
            FROM core.articulo art
            WHERE art.codigo='ART-001'
            """);
        resetSequence("SELECT setval('almacen.articulo_bonificacion_id_seq', GREATEST((SELECT MAX(id) FROM almacen.articulo_bonificacion), 1))");
    }

    /**
     * Creates articulo_almacen balances (aggregate per almacen+articulo).
     */
    public void seedArticuloAlmacen() {
        if (!seeded.add("articulo_almacen")) return;
        seedArticulo();
        jdbc.update("DELETE FROM almacen.articulo_almacen");
        jdbc.update("""
            INSERT INTO almacen.articulo_almacen (id, almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
            SELECT 1, a.id, art.id, 100.0000, 0, 3.5000
            FROM almacen.almacen a
            JOIN core.articulo art ON art.codigo='ART-001'
            WHERE a.flag_estado='1'
            ORDER BY a.id
            LIMIT 1
            """);
        resetSequence("SELECT setval('almacen.articulo_almacen_id_seq', GREATEST((SELECT MAX(id) FROM almacen.articulo_almacen), 1))");
    }

    /**
     * Creates articulo_almacen_posicion balances (per ubicacion+articulo).
     */
    public void seedArticuloAlmacenPosicion() {
        if (!seeded.add("articulo_almacen_posicion")) return;
        seedUbicacionAlmacen();
        seedArticulo();
        jdbc.update("DELETE FROM almacen.articulo_almacen_posicion");
        jdbc.update("""
            INSERT INTO almacen.articulo_almacen_posicion (id, ubicacion_almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
            SELECT 1, ub.id, art.id, 60.0000, 0, 3.5000
            FROM almacen.ubicacion_almacen ub
            JOIN core.articulo art ON art.codigo='ART-001'
            WHERE ub.id = 1
            """);
        jdbc.update("""
            INSERT INTO almacen.articulo_almacen_posicion (id, ubicacion_almacen_id, articulo_id, cantidad_disponible, cantidad_reservada, costo_promedio)
            SELECT 2, ub.id, art.id, 40.0000, 0, 3.5000
            FROM almacen.ubicacion_almacen ub
            JOIN core.articulo art ON art.codigo='ART-001'
            WHERE ub.id = 2
            """);
        resetSequence("SELECT setval('almacen.articulo_almacen_posicion_id_seq', GREATEST((SELECT MAX(id) FROM almacen.articulo_almacen_posicion), 2))");
    }

    /**
     * Creates minimal articulo_saldo_mensual rows linked to vale_mov_det.
     */
    public void seedArticuloSaldoMensual() {
        if (!seeded.add("articulo_saldo_mensual")) return;
        seedValeMov();

        String today = LocalDate.now().toString();
        jdbc.update("DELETE FROM almacen.articulo_saldo_mensual");
        jdbc.update("""
            INSERT INTO almacen.articulo_saldo_mensual (
                id, almacen_id, articulo_id, vale_mov_det_id, fecha, tipo,
                cantidad, costo_unitario, costo_total, saldo_cantidad, saldo_costo_unitario, saldo_costo_total
            )
            SELECT 1, vm.almacen_id, vmd.articulo_id, vmd.id, ?::date, 'INGRESO',
                   vmd.cant_procesada, COALESCE(vmd.costo_unitario, 0), COALESCE(vmd.cant_procesada,0) * COALESCE(vmd.costo_unitario,0),
                   vmd.cant_procesada, COALESCE(vmd.costo_unitario,0), COALESCE(vmd.cant_procesada,0) * COALESCE(vmd.costo_unitario,0)
            FROM almacen.vale_mov_det vmd
            JOIN almacen.vale_mov vm ON vm.id = vmd.vale_mov_id
            WHERE vmd.id = 1
            """, today);
        resetSequence("SELECT setval('almacen.articulo_saldo_mensual_id_seq', GREATEST((SELECT MAX(id) FROM almacen.articulo_saldo_mensual), 1))");
    }

    // ==================== FINANZAS / VENTAS TRANSACTIONAL ====================

    /**
     * Creates sample cntas_pagar. Calls seedEntidadContribuyente first.
     */
    public void seedCntasPagar() {
        if (!seeded.add("cntas_pagar")) return;

        seedEntidadContribuyente();

        String today = LocalDate.now().toString();
        String venc = LocalDate.now().plusDays(30).toString();
        jdbc.update("""
            INSERT INTO finanzas.cntas_pagar (id, sucursal_id, proveedor_id, doc_tipo_id, serie, numero,
                fecha_emision, fecha_vencimiento, moneda_id, total, saldo, estado, flag_estado)
            SELECT v.id, s.id, e.id, dt.id, v.serie, v.numero, ?::date, ?::date, m.id, v.total, v.total, 'PENDIENTE', '1'
            FROM (VALUES
                (1, 'FAC', 'F001', '00000001', 11800.00),
                (2, 'FAC', 'F001', '00000002',  5900.00)
            ) AS v(id, doc_cod, serie, numero, total)
            JOIN auth.sucursal s ON s.codigo = 'LM'
            JOIN core.entidad_contribuyente e ON e.id = 1
            JOIN core.doc_tipo dt ON dt.codigo = v.doc_cod
            JOIN core.moneda m ON m.codigo = 'PEN'
            ON CONFLICT (proveedor_id, doc_tipo_id, serie, numero) DO UPDATE SET total = EXCLUDED.total, saldo = EXCLUDED.saldo
            """, today, venc, today, venc);
        resetSequence("SELECT setval('finanzas.cntas_pagar_id_seq', GREATEST((SELECT MAX(id) FROM finanzas.cntas_pagar), 2))");
    }

    /**
     * Creates sample cntas_cobrar. Calls seedEntidadContribuyente first.
     */
    public void seedCntasCobrar() {
        if (!seeded.add("cntas_cobrar")) return;

        seedEntidadContribuyente();

        String today = LocalDate.now().toString();
        String venc = LocalDate.now().plusDays(30).toString();
        jdbc.update("""
            INSERT INTO ventas.cntas_cobrar (id, sucursal_id, cliente_id, doc_tipo_id, serie, numero,
                fecha_emision, fecha_vencimiento, moneda_id, total, saldo, ano, mes, cntbl_libro_id, flag_estado)
            SELECT v.id, s.id, e.id, dt.id, v.serie, v.numero, ?::date, ?::date, m.id, v.total, v.total,
                EXTRACT(YEAR FROM ?::date)::INTEGER, EXTRACT(MONTH FROM ?::date)::INTEGER, cl.id, '1'
            FROM (VALUES
                (1, 'FAC', 'F001', '00000001', 23600.00),
                (2, 'BOL', 'B001', '00000001',  1180.00)
            ) AS v(id, doc_cod, serie, numero, total)
            JOIN auth.sucursal s ON s.codigo = 'LM'
            JOIN core.entidad_contribuyente e ON e.id = 2
            JOIN core.doc_tipo dt ON dt.codigo = v.doc_cod
            JOIN core.moneda m ON m.codigo = 'PEN'
            JOIN contabilidad.cntbl_libro cl ON cl.codigo = '4'
            ON CONFLICT (cliente_id, doc_tipo_id, serie, numero) DO UPDATE SET total = EXCLUDED.total, saldo = EXCLUDED.saldo
            """, today, venc, today);
        resetSequence("SELECT setval('ventas.cntas_cobrar_id_seq', GREATEST((SELECT MAX(id) FROM ventas.cntas_cobrar), 2))");
    }

    /**
     * Configures SUNAT series for numbering. No transactional FK dependencies.
     */
    public void seedDocTipoNumSerie() {
        if (!seeded.add("doc_tipo_num_serie")) return;
        jdbc.update("""
            INSERT INTO core.doc_tipo_num_serie (sucursal_id, doc_tipo_id, serie, ultimo_numero, flag_estado)
            SELECT s.id, dt.id, v.serie, 0, '1'
            FROM (VALUES
                ('FAC', 'F001'), ('BOL', 'B001'), ('RET', 'R001'),
                ('GRR', 'T001'), ('LCO', 'L001')
            ) AS v(doc_cod, serie)
            JOIN auth.sucursal s ON s.codigo = 'LM'
            JOIN core.doc_tipo dt ON dt.codigo = v.doc_cod
            ON CONFLICT (sucursal_id, doc_tipo_id, serie) DO UPDATE SET flag_estado = '1'
            """);
    }

    // ==================== COMPRAS TRANSACTIONAL ====================

    /**
     * Creates sample compradores (buyers). No FK dependencies on other transactional tables.
     */
    public void seedComprador() {
        if (!seeded.add("comprador")) return;
        jdbc.update("DELETE FROM compras.comprador_categoria");
        jdbc.update("DELETE FROM compras.comprador WHERE id <= 2");
        jdbc.update("""
            INSERT INTO compras.comprador (id, usuario_id, nombre, flag_estado) VALUES
            (1, 1, 'Comprador Demo 1', '1'),
            (2, 2, 'Comprador Demo 2', '1')
            ON CONFLICT (id) DO UPDATE SET nombre = EXCLUDED.nombre, flag_estado = '1'
            """);
        resetSequence("SELECT setval('compras.comprador_id_seq', GREATEST((SELECT MAX(id) FROM compras.comprador), 2))");
    }

    /**
     * Creates sample aprobadores configurados for OC and OS.
     * Resolves doc_tipo_id dynamically from core.doc_tipo.codigo.
     */
    public void seedAprobadorConfigurado() {
        if (!seeded.add("aprobador_configurado")) return;
        seedDocTipo();
        jdbc.update("DELETE FROM compras.aprobador_configurado WHERE id <= 2");
        jdbc.update("""
            INSERT INTO compras.aprobador_configurado (id, doc_tipo_id, nivel, aprobador_id, monto_minimo, monto_maximo, flag_estado)
            SELECT v.id, dt.id, v.nivel, v.aprobador_id, v.monto_min, v.monto_max, '1'
            FROM (VALUES
                (1, 'OC', 1, 1, 0::numeric, 50000.00::numeric),
                (2, 'OS', 1, 1, 0::numeric, 50000.00::numeric)
            ) AS v(id, doc_cod, nivel, aprobador_id, monto_min, monto_max)
            JOIN core.doc_tipo dt ON dt.codigo = v.doc_cod
            ON CONFLICT (id) DO UPDATE SET doc_tipo_id = EXCLUDED.doc_tipo_id, monto_maximo = EXCLUDED.monto_maximo, flag_estado = '1'
            """);
        resetSequence("SELECT setval('compras.aprobador_configurado_id_seq', GREATEST((SELECT MAX(id) FROM compras.aprobador_configurado), 2))");
    }

    /**
     * Creates sample servicios (service catalog).
     */
    public void seedServicio() {
        if (!seeded.add("servicio")) return;
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.servicio WHERE flag_estado = '1'", Integer.class);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO compras.servicio (id, servicio, descripcion, cod_sub_cat, tarifa_estd, und, cnta_prsp, flag_estado) VALUES
            (1, 'SRV001', 'Servicio de mantenimiento preventivo', 'MNT   ', 1500.0000, 'GLB', '63110001', '1'),
            (2, 'SRV002', 'Servicio de fumigacion', 'FUM   ', 2500.0000, 'GLB', '63110002', '1'),
            (3, 'SRV003', 'Servicio de limpieza', 'LMP   ', 800.0000, 'GLB', '63110003', '1')
            ON CONFLICT (servicio) DO UPDATE SET descripcion = EXCLUDED.descripcion, flag_estado = '1'
            """);
        resetSequence("SELECT setval('compras.servicio_id_seq', GREATEST((SELECT MAX(id) FROM compras.servicio), 3))");
    }

    /**
     * Creates sample vendedores para ventas.
     */
    public void seedVendedor() {
        if (!seeded.add("vendedor")) return;
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM ventas.vendedor WHERE flag_estado = '1'", Integer.class);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO ventas.vendedor (id, codigo, nombres, apellidos, comision, flag_estado, created_by, fec_creacion) VALUES
            (1, 'V-001', 'Juan', 'Perez', 5.00, '1', 1, CURRENT_TIMESTAMP),
            (2, 'V-002', 'Maria', 'Gomez', 3.50, '1', 1, CURRENT_TIMESTAMP),
            (3, 'V-003', 'Carlos', 'Lopez', 4.00, '1', 1, CURRENT_TIMESTAMP)
            ON CONFLICT (codigo) DO UPDATE SET flag_estado = '1'
            """);
        resetSequence("SELECT setval('ventas.vendedor_id_seq', GREATEST((SELECT MAX(id) FROM ventas.vendedor), 3))");
    }

    /**
     * Creates sample mesas para ventas.
     */
    public void seedMesa() {
        if (!seeded.add("mesa")) return;
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM almacen.mesa WHERE flag_estado = '1'", Integer.class);
        if (count != null && count > 0) return;

        jdbc.update("""
            INSERT INTO almacen.mesa (id, numero, capacidad, zona_id, flag_estado, created_by, fec_creacion) VALUES
            (1, 'M-001', 4, 1, '1', 1, CURRENT_TIMESTAMP),
            (2, 'M-002', 6, 1, '1', 1, CURRENT_TIMESTAMP),
            (3, 'M-003', 2, 1, '1', 1, CURRENT_TIMESTAMP)
            ON CONFLICT (numero) DO UPDATE SET flag_estado = '1'
            """);
        resetSequence("SELECT setval('almacen.mesa_id_seq', GREATEST((SELECT MAX(id) FROM almacen.mesa), 3))");
    }

}
