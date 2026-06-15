package com.sigre.finanzas.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Servicio para inicializar datos de prueba en finanzas-service.
 *
 * <p>Inserta datos mínimos necesarios para el funcionamiento del módulo de finanzas,
 * incluyendo artículos, matriz contable, libro diario y series de documentos.</p>
 *
 * <p>IMPORTANTE: Este servicio muta la base de datos tenant (INSERT). El controlador
 * solo delega aquí cuando {@code app.testdata.enabled=true}; si no, responde 403.</p>
 */
@Service
@RequiredArgsConstructor
public class TestDataSeedService {

    private static final String CODIGO_LIBRO_DIARIO = "05";
    private static final Long GRUPO_MATRIZ_FINANZAS_ID = 1L;
    private static final String FLAG_DEBE = "D";
    private static final String FLAG_HABER = "H";
    
    // Códigos de matrices contables (deben coincidir con TipoOperacionContable.java en contabilidad-service)
    // Máximo 10 caracteres por limitación de la base de datos
    private static final String CODIGO_MATRIZ_CARTERA_PAGOS = "CART_PAGOS";
    private static final String CODIGO_MATRIZ_CARTERA_COBROS = "CART_COBR";
    private static final String CODIGO_MATRIZ_TRANSFERENCIA = "TRANSF";
    private static final String CODIGO_MATRIZ_APLICACION_DOCUMENTOS = "APLIC_DOC";
    private static final String CODIGO_MATRIZ_LIQUIDACION_GIRO = "LIQ_GIRO";
    private static final String CODIGO_MATRIZ_REGISTRO_CNTAS_PAGAR = "REG_CNT_PA";

    private final DataSource dataSource;

    /**
     * Ejecuta la carga completa de datos de prueba para finanzas-service.
     * Inserta datos en el siguiente orden para respetar dependencias FK:
     * 1. Dependencias mínimas (unidades, categorías, sucursal, doc_tipos)
     * 2. Artículos
     * 3. Plan contable
     * 4. Libro diario
     * 5. Matriz contable
     * 6. Series de documentos
     *
     * @return Mapa con el conteo de registros insertados por tabla
     */
    @Transactional
    public Map<String, Integer> seedFinanzasDemoData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("core.unidad_medida + articulo_categ", seedDependenciasMinimas(jdbc));
        out.put("core.entidad_contribuyente", seedEntidadContribuyente(jdbc));
        out.put("grupo_codigo_flujo_caja", seedGrupoCodigoFlujoCaja(jdbc));
        out.put("codigo_flujo_caja", seedCodigoFlujoCaja(jdbc));
        out.put("articulos", seedArticulos(jdbc));
        out.put("contabilidad.plan_contable_det", seedPlanContable(jdbc));
        out.put("contabilidad.cntbl_libro", seedLibroDiario(jdbc));
        out.put("contabilidad.matriz_contable + det", seedMatrizContable(jdbc));
        out.put("finanzas.concepto_financiero", seedConceptoFinanciero(jdbc));
        out.put("core.doc_tipo_num_serie", seedSeriesDocumento(jdbc));

        return out;
    }

    /**
     * Inserta dependencias mínimas requeridas por otras tablas.
     * Incluye unidades de medida, categorías de artículos, sucursal y tipos de documento.
     * Valida existencia por ID y código antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número total de registros insertados
     */
    private int seedDependenciasMinimas(JdbcTemplate jdbc) {
        int total = 0;

        // Unidad de medida: KG
        if (!existeUnidadMedida(jdbc, 1, "KG")) {
            total += jdbc.update("""
                INSERT INTO core.unidad_medida (id, codigo, nombre, flag_estado)
                VALUES (1, 'KG', 'Kilogramo', '1')
                """);
        }

        // Unidad de medida: UNI
        if (!existeUnidadMedida(jdbc, 2, "UNI")) {
            total += jdbc.update("""
                INSERT INTO core.unidad_medida (id, codigo, nombre, flag_estado)
                VALUES (2, 'UNI', 'Unidad', '1')
                """);
        }

        // Categoría: MP
        if (!existeArticuloCateg(jdbc, 1, "MP")) {
            total += jdbc.update("""
                INSERT INTO core.articulo_categ (id, cat_art, desc_cat_art, flag_estado)
                VALUES (1, 'MP', 'Materia Prima', '1')
                """);
        }

        // Categoría: INS
        if (!existeArticuloCateg(jdbc, 2, "INS")) {
            total += jdbc.update("""
                INSERT INTO core.articulo_categ (id, cat_art, desc_cat_art, flag_estado)
                VALUES (2, 'INS', 'Insumos', '1')
                """);
        }

        // Categoría: ENV
        if (!existeArticuloCateg(jdbc, 3, "ENV")) {
            total += jdbc.update("""
                INSERT INTO core.articulo_categ (id, cat_art, desc_cat_art, flag_estado)
                VALUES (3, 'ENV', 'Envases', '1')
                """);
        }

        return total;
    }

    /**
     * Inserta un proveedor demo para usar en Cuentas por Pagar.
     * Crea un proveedor con ID 1 con datos realistas.
     * Valida existencia por ID antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedEntidadContribuyente(JdbcTemplate jdbc) {
        if (!existeEntidadContribuyente(jdbc, 1L)) {
            return jdbc.update("""
                INSERT INTO core.entidad_contribuyente (
                    id, tipo_persona, tipo_documento, nro_documento, razon_social, 
                    telefono, email, es_proveedor, es_cliente, es_empleado,
                    flag_estado, created_by, fec_creacion
                )
                VALUES (
                    1, 'JURIDICA', 'RUC', '20123456789', 'DISTRIBUIDORA ALIMENTOS S.A.C.',
                    '01-5551234', 'contacto@distribuidora.com',
                    TRUE, FALSE, FALSE, '1', 1, NOW()
                )
                """);
        }
        return 0;
    }

    /**
     * Inserta conceptos financieros vinculados a cada matriz contable.
     * Crea un concepto por cada una de las 6 matrices de finanzas:
     * - SE101: Pago a Proveedores (CART_PAGOS)
     * - SE102: Cobro a Clientes (CART_COBROS)
     * - SE103: Transferencia Bancaria (TRANSF)
     * - SE104: Aplicación de Documentos (APLIC_DOC)
     * - SE105: Liquidación de Giro (LIQ_GIRO)
     * - SE106: Registro de Cuentas por Pagar (REG_CNT_PA)
     * 
     * Prefijo SE (Semilla) para identificar datos de prueba.
     * Valida existencia por código antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedConceptoFinanciero(JdbcTemplate jdbc) {
        int total = 0;
        
        // SE101: Pago a Proveedores
        total += crearConceptoFinanciero(jdbc, "SE101", "PAGO A PROVEEDORES", CODIGO_MATRIZ_CARTERA_PAGOS);
        
        // SE102: Cobro a Clientes
        total += crearConceptoFinanciero(jdbc, "SE102", "COBRO A CLIENTES", CODIGO_MATRIZ_CARTERA_COBROS);
        
        // SE103: Transferencia Bancaria
        total += crearConceptoFinanciero(jdbc, "SE103", "TRANSFERENCIA BANCARIA", CODIGO_MATRIZ_TRANSFERENCIA);
        
        // SE104: Aplicación de Documentos
        total += crearConceptoFinanciero(jdbc, "SE104", "APLICACION DE DOCUMENTOS", CODIGO_MATRIZ_APLICACION_DOCUMENTOS);
        
        // SE105: Liquidación de Giro
        total += crearConceptoFinanciero(jdbc, "SE105", "LIQUIDACION DE GIRO", CODIGO_MATRIZ_LIQUIDACION_GIRO);
        
        // SE106: Registro de Cuentas por Pagar
        total += crearConceptoFinanciero(jdbc, "SE106", "REGISTRO DE CUENTAS POR PAGAR", CODIGO_MATRIZ_REGISTRO_CNTAS_PAGAR);
        
        return total;
    }
    
    /**
     * Crea un concepto financiero vinculado a una matriz contable específica.
     * Valida que la matriz exista antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código del concepto financiero
     * @param nombre Nombre descriptivo del concepto
     * @param codigoMatriz Código de la matriz contable a vincular
     * @return Número de registros insertados (0 o 1)
     */
    private int crearConceptoFinanciero(JdbcTemplate jdbc, String codigo, String nombre, String codigoMatriz) {
        if (!existeConceptoFinanciero(jdbc, codigo)) {
            // Obtener ID de la matriz contable
            Long matrizId = null;
            try {
                matrizId = jdbc.queryForObject(
                    "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
                    Long.class, codigoMatriz);
            } catch (Exception e) {
                // Si no existe la matriz, no se puede insertar el concepto
                return 0;
            }
            
            if (matrizId != null) {
                return jdbc.update("""
                    INSERT INTO finanzas.concepto_financiero (
                        codigo, nombre, matriz_contable_id, flag_estado,
                        created_by, fec_creacion
                    )
                    VALUES (?, ?, ?, '1', 1, NOW())
                    """, codigo, nombre, matrizId);
            }
        }
        return 0;
    }

    /**
     * Inserta grupos de códigos de flujo de caja necesarios para el funcionamiento.
     * Crea el grupo principal para operaciones de tesorería.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedGrupoCodigoFlujoCaja(JdbcTemplate jdbc) {
        if (!existeGrupoCodigoFlujoCaja(jdbc, "GFC001")) {
            return jdbc.update("""
                INSERT INTO finanzas.grupo_codigo_flujo_caja (
                    id, codigo, nombre, orden, factor, actividad_flujo_caja_id, flag_estado,
                    created_by, fec_creacion
                )
                VALUES (
                    1, 'GFC001', 'OPERACIONES DE TESORERIA', 1, '1',
                    (SELECT id FROM finanzas.actividad_flujo_caja WHERE codigo = '01' LIMIT 1),
                    '1', 1, NOW()
                )
                ON CONFLICT (id) DO NOTHING
                """);
        }
        return 0;
    }

    /**
     * Inserta códigos de flujo de caja necesarios para clasificar movimientos.
     * Incluye el código principal (ID=1) para operaciones normales.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedCodigoFlujoCaja(JdbcTemplate jdbc) {
        int total = 0;
        
        // Código principal para operaciones normales (ID=1)
        if (!existeCodigoFlujoCaja(jdbc, "CFC001")) {
            total += jdbc.update("""
                INSERT INTO finanzas.codigo_flujo_caja (
                    id, codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, orden, flag_estado,
                    created_by, fec_creacion
                )
                VALUES (
                    1, 'CFC001', 1, 'OPERACIONES NORMALES', 'OPERATIVO', '1', 1, '1', 1, NOW()
                )
                ON CONFLICT (id) DO NOTHING
                """);
        }
        
        // Código para operaciones financieras
        if (!existeCodigoFlujoCaja(jdbc, "CFC002")) {
            total += jdbc.update("""
                INSERT INTO finanzas.codigo_flujo_caja (
                    id, codigo, grupo_codigo_flujo_caja_id, nombre, tipo, factor, orden, flag_estado,
                    created_by, fec_creacion
                )
                VALUES (
                    2, 'CFC002', 1, 'OPERACIONES FINANCIERAS', 'FINANCIERO', '1', 2, '1', 1, NOW()
                )
                ON CONFLICT (id) DO NOTHING
                """);
        }
        
        return total;
    }

    /**
     * Inserta artículos demo para usar en detalles de CxP y otras operaciones.
     * Incluye: Arroz, Aceite, Lomo, Caja Descartable, Pollo.
     * Valida existencia por ID o código antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedArticulos(JdbcTemplate jdbc) {
        int total = 0;

        // ART-001: Arroz Extra Granel (KG, MP)
        if (!existeArticulo(jdbc, 1, "ART-001")) {
            total += jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                VALUES (1, 'ART-001', 'Arroz Extra Granel', 'BIEN', 1, 1, 3.50, '1')
                """);
        }

        // ART-002: Aceite Vegetal 1L (UNI, INS)
        if (!existeArticulo(jdbc, 2, "ART-002")) {
            total += jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                VALUES (2, 'ART-002', 'Aceite Vegetal 1L', 'BIEN', 2, 2, 8.90, '1')
                """);
        }

        // ART-003: Lomo Fino kg (KG, MP)
        if (!existeArticulo(jdbc, 3, "ART-003")) {
            total += jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                VALUES (3, 'ART-003', 'Lomo Fino kg', 'BIEN', 1, 1, 42.00, '1')
                """);
        }

        // ART-004: Caja Descartable x100 (UNI, ENV)
        if (!existeArticulo(jdbc, 4, "ART-004")) {
            total += jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                VALUES (4, 'ART-004', 'Caja Descartable x100', 'BIEN', 2, 3, 25.00, '1')
                """);
        }

        // ART-005: Pollo Entero kg (KG, MP)
        if (!existeArticulo(jdbc, 5, "ART-005")) {
            total += jdbc.update("""
                INSERT INTO core.articulo (id, codigo, nombre, tipo, unidad_medida_id, articulo_categ_id, precio_venta, flag_estado)
                VALUES (5, 'ART-005', 'Pollo Entero kg', 'BIEN', 1, 1, 12.50, '1')
                """);
        }

        return total;
    }

    /**
     * Inserta cuentas contables básicas del plan contable.
     * Incluye cuentas necesarias para las 6 matrices contables de finanzas:
     * - 101: Caja (DEBE/HABER)
     * - 104: Cuentas Corrientes (DEBE/HABER)
     * - 121: Facturas por Cobrar (HABER)
     * - 421: Facturas por Pagar (HABER)
     * - 601: Compras (DEBE)
     * - 603: IGV (DEBE)
     * - 631: Gastos Diversos (DEBE)
     * Valida existencia por ID antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedPlanContable(JdbcTemplate jdbc) {
        int total = 0;

        // Cuenta 101: Caja (para cobros y pagos en efectivo)
        if (!existePlanContableDet(jdbc, 101L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (101, '10.1', 'CAJA', '1')
                """);
        }

        // Cuenta 104: Cuentas Corrientes (para transferencias y movimientos bancarios)
        if (!existePlanContableDet(jdbc, 104L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (104, '10.4', 'CUENTAS CORRIENTES', '1')
                """);
        }

        // Cuenta 121: Facturas por Cobrar (para cartera de cobros)
        if (!existePlanContableDet(jdbc, 121L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (121, '12.1', 'FACTURAS POR COBRAR', '1')
                """);
        }

        // Cuenta 421: Facturas por Pagar (para cartera de pagos)
        if (!existePlanContableDet(jdbc, 421L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (421, '42.1', 'FACTURAS POR PAGAR', '1')
                """);
        }

        // Cuenta 601: Compras (para registro de CxP)
        if (!existePlanContableDet(jdbc, 601L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (601, '60.1', 'COMPRAS', '1')
                """);
        }

        // Cuenta 603: IGV (para registro de CxP)
        if (!existePlanContableDet(jdbc, 603L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (603, '60.3', 'IGV', '1')
                """);
        }

        // Cuenta 631: Gastos Diversos (para liquidación de giro)
        if (!existePlanContableDet(jdbc, 631L)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.plan_contable_det (id, codigo, nombre, flag_estado)
                VALUES (631, '63.1', 'GASTOS DIVERSOS', '1')
                """);
        }

        return total;
    }

    /**
     * Inserta el libro diario contable.
     * Código: 05 - Libro Diario
     * Valida existencia por código antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedLibroDiario(JdbcTemplate jdbc) {
        if (!existeLibro(jdbc, CODIGO_LIBRO_DIARIO)) {
            return jdbc.update("""
                INSERT INTO contabilidad.cntbl_libro (codigo, nombre, created_by, fec_creacion)
                VALUES (?, 'Libro Diario', 1, NOW())
                """, CODIGO_LIBRO_DIARIO);
        }
        return 0;
    }

    /**
     * Inserta las 6 matrices contables necesarias para el módulo de finanzas.
     * Los códigos deben coincidir exactamente con TipoOperacionContable.java en contabilidad-service.
     * 
     * Matrices creadas:
     * 1. CART_PAGOS - Pagos a proveedores (Debe: CxP, Haber: Banco)
     * 2. CART_COBROS - Cobros de clientes (Debe: Banco, Haber: CxC)
     * 3. TRANSF - Transferencias bancarias (Debe: Banco Destino, Haber: Banco Origen)
     * 4. APLIC_DOC - Aplicación de documentos (Debe: CxP, Haber: CxC)
     * 5. LIQ_GIRO - Liquidación de órdenes de giro (Debe: Gastos, Haber: Banco)
     * 6. REG_CNT_PAG - Registro/Provisión de CxP (Debe: Compras+IGV, Haber: CxP)
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número total de registros insertados (cabeceras + detalles)
     */
    private int seedMatrizContable(JdbcTemplate jdbc) {
        int total = 0;

        // Asegurar que existe el grupo de matriz contable
        if (!existeGrupoMatrizCntbl(jdbc, GRUPO_MATRIZ_FINANZAS_ID)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.grupo_matriz_cntbl (id, codigo, nombre, flag_estado)
                VALUES (?, 'FIN', 'Finanzas', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID);
        }

        // 1. CARTERA_PAGOS - Pagos a proveedores
        total += crearMatrizCarteraPagos(jdbc);
        
        // 2. CARTERA_COBROS - Cobros de clientes
        total += crearMatrizCarteraCobros(jdbc);
        
        // 3. TRANSFERENCIA - Transferencias bancarias
        total += crearMatrizTransferencia(jdbc);
        
        // 4. APLICACION_DOCUMENTOS - Aplicación de documentos
        total += crearMatrizAplicacionDocumentos(jdbc);
        
        // 5. LIQUIDACION_GIRO - Liquidación de órdenes de giro
        total += crearMatrizLiquidacionGiro(jdbc);
        
        // 6. REGISTRO_CNTAS_PAGAR - Registro/Provisión de CxP
        total += crearMatrizRegistroCntasPagar(jdbc);

        return total;
    }
    
    /**
     * Crea matriz CART_PAGOS para pagos a proveedores.
     * Asiento: Debe: CxP (421), Haber: Banco (104)
     */
    private int crearMatrizCarteraPagos(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_CARTERA_PAGOS)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Pago a Proveedores', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_CARTERA_PAGOS);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_CARTERA_PAGOS);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 421, ?, 'TOTAL')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 104, ?, 'TOTAL')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }
    
    /**
     * Crea matriz CART_COBROS para cobros de clientes.
     * Asiento: Debe: Banco (104), Haber: CxC (121)
     */
    private int crearMatrizCarteraCobros(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_CARTERA_COBROS)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Cobro a Clientes', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_CARTERA_COBROS);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_CARTERA_COBROS);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 104, ?, 'TOTAL')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 121, ?, 'TOTAL')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }
    
    /**
     * Crea matriz TRANSF para transferencias bancarias.
     * Asiento: Debe: Banco Destino (104), Haber: Banco Origen (104)
     */
    private int crearMatrizTransferencia(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_TRANSFERENCIA)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Transferencia Bancaria', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_TRANSFERENCIA);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_TRANSFERENCIA);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 104, ?, 'TOTAL')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 104, ?, 'TOTAL')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }
    
    /**
     * Crea matriz APLIC_DOC para aplicación de documentos.
     * Asiento: Debe: CxP (421), Haber: CxC (121)
     */
    private int crearMatrizAplicacionDocumentos(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_APLICACION_DOCUMENTOS)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Aplicación de Documentos', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_APLICACION_DOCUMENTOS);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_APLICACION_DOCUMENTOS);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 421, ?, 'TOTAL')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 121, ?, 'TOTAL')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }
    
    /**
     * Crea matriz LIQ_GIRO para liquidación de órdenes de giro.
     * Asiento: Debe: Gastos (631), Haber: Banco (104)
     */
    private int crearMatrizLiquidacionGiro(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_LIQUIDACION_GIRO)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Liquidación de Orden de Giro', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_LIQUIDACION_GIRO);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_LIQUIDACION_GIRO);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 631, ?, 'IMPORTE_NETO')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 104, ?, 'IMPORTE_NETO')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }
    
    /**
     * Crea matriz REG_CNT_PAG para registro/provisión de CxP.
     * Asiento: Debe: Compras (601) + IGV (603), Haber: CxP (421)
     */
    private int crearMatrizRegistroCntasPagar(JdbcTemplate jdbc) {
        int total = 0;
        if (!existeMatrizContable(jdbc, CODIGO_MATRIZ_REGISTRO_CNTAS_PAGAR)) {
            total += jdbc.update("""
                INSERT INTO contabilidad.matriz_contable (grupo_matriz_cntbl_id, codigo, descripcion, flag_estado)
                VALUES (?, ?, 'Registro/Provisión de Cuentas por Pagar', '1')
                """, GRUPO_MATRIZ_FINANZAS_ID, CODIGO_MATRIZ_REGISTRO_CNTAS_PAGAR);
        }
        
        Long matrizId = jdbc.queryForObject(
            "SELECT id FROM contabilidad.matriz_contable WHERE codigo = ?",
            Long.class, CODIGO_MATRIZ_REGISTRO_CNTAS_PAGAR);
        
        if (matrizId != null) {
            if (!existeMatrizContableDet(jdbc, matrizId, 1)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 1, 601, ?, 'BASE_IMPONIBLE')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 2)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 2, 603, ?, 'IGV_CALCULADO')
                    """, matrizId, FLAG_DEBE);
            }
            if (!existeMatrizContableDet(jdbc, matrizId, 3)) {
                total += jdbc.update("""
                    INSERT INTO contabilidad.matriz_contable_det (
                        matriz_contable_id, secuencia, plan_contable_det_id, flag_deb_hab, referencia_campo
                    ) VALUES (?, 3, 421, ?, 'TOTAL')
                    """, matrizId, FLAG_HABER);
            }
        }
        return total;
    }

    /**
     * Inserta series de numeración para documentos tipo Letra.
     * Incluye:
     * - Serie L001 para doc_tipo_id 13 (LETRAS X PAGAR)
     * - Serie L001 para doc_tipo_id 185 (LETRAS X COBRAR)
     * Valida existencia antes de insertar.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número de registros insertados
     */
    private int seedSeriesDocumento(JdbcTemplate jdbc) {
        int total = 0;

        // Serie para LETRAS X PAGAR (ID: 13)
        if (!existeDocTipoNumSerie(jdbc, 1L, 13L, "L001")) {
            total += jdbc.update("""
                INSERT INTO core.doc_tipo_num_serie (
                    sucursal_id, doc_tipo_id, serie, ultimo_numero, flag_estado,
                    created_by, fec_creacion
                )
                VALUES (1, 13, 'L001', 0, '1', 1, NOW())
                """);
        }

        // Serie para LETRAS X COBRAR (ID: 185)
        if (!existeDocTipoNumSerie(jdbc, 1L, 185L, "L001")) {
            total += jdbc.update("""
                INSERT INTO core.doc_tipo_num_serie (
                    sucursal_id, doc_tipo_id, serie, ultimo_numero, flag_estado,
                    created_by, fec_creacion
                )
                VALUES (1, 185, 'L001', 0, '1', 1, NOW())
                """);
        }

        return total;
    }

    // ========== Métodos de validación de existencia ==========

    /**
     * Verifica si existe una unidad de medida por ID o código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID de la unidad de medida
     * @param codigo Código de la unidad de medida
     * @return true si existe, false en caso contrario
     */
    private boolean existeUnidadMedida(JdbcTemplate jdbc, int id, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.unidad_medida WHERE id = ? OR codigo = ?",
            Integer.class, id, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una categoría de artículo por ID o código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID de la categoría
     * @param catArt Código de la categoría
     * @return true si existe, false en caso contrario
     */
    private boolean existeArticuloCateg(JdbcTemplate jdbc, int id, String catArt) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.articulo_categ WHERE id = ? OR cat_art = ?",
            Integer.class, id, catArt);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una sucursal por ID.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID de la sucursal
     * @return true si existe, false en caso contrario
     */
    private boolean existeSucursal(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM auth.sucursal WHERE id = ?",
            Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un tipo de documento por ID.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID del tipo de documento
     * @return true si existe, false en caso contrario
     */
    private boolean existeDocTipo(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.doc_tipo WHERE id = ?",
            Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un artículo por ID o código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID del artículo
     * @param codigo Código del artículo
     * @return true si existe, false en caso contrario
     */
    private boolean existeArticulo(JdbcTemplate jdbc, Integer id, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.articulo WHERE id = ? OR codigo = ?",
            Integer.class, id, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un grupo de código de flujo de caja por código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código del grupo de flujo de caja
     * @return true si existe, false en caso contrario
     */
    private boolean existeGrupoCodigoFlujoCaja(JdbcTemplate jdbc, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.grupo_codigo_flujo_caja WHERE codigo = ?",
            Integer.class, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un código de flujo de caja por código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código del flujo de caja
     * @return true si existe, false en caso contrario
     */
    private boolean existeCodigoFlujoCaja(JdbcTemplate jdbc, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.codigo_flujo_caja WHERE codigo = ?",
            Integer.class, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una cuenta del plan contable por ID.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID de la cuenta
     * @return true si existe, false en caso contrario
     */
    private boolean existePlanContableDet(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.plan_contable_det WHERE id = ?",
            Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un libro contable por código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código del libro
     * @return true si existe, false en caso contrario
     */
    private boolean existeLibro(JdbcTemplate jdbc, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.cntbl_libro WHERE codigo = ?",
            Integer.class, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un grupo de matriz contable por ID.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param grupoId ID del grupo de matriz contable
     * @return true si existe, false en caso contrario
     */
    private boolean existeGrupoMatrizCntbl(JdbcTemplate jdbc, Long grupoId) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.grupo_matriz_cntbl WHERE id = ?",
            Integer.class, grupoId);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una matriz contable por código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código de la matriz contable
     * @return true si existe, false en caso contrario
     */
    private boolean existeMatrizContable(JdbcTemplate jdbc, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.matriz_contable WHERE codigo = ?",
            Integer.class, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un detalle de matriz contable por matriz y secuencia.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param matrizContableId ID de la matriz contable
     * @param secuencia Secuencia del detalle
     * @return true si existe, false en caso contrario
     */
    private boolean existeMatrizContableDet(JdbcTemplate jdbc, Long matrizContableId, int secuencia) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM contabilidad.matriz_contable_det WHERE matriz_contable_id = ? AND secuencia = ?",
            Integer.class, matrizContableId, secuencia);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una entidad contribuyente por ID.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param id ID de la entidad contribuyente
     * @return true si existe, false en caso contrario
     */
    private boolean existeEntidadContribuyente(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.entidad_contribuyente WHERE id = ?",
            Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un concepto financiero por código.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param codigo Código del concepto financiero
     * @return true si existe, false en caso contrario
     */
    private boolean existeConceptoFinanciero(JdbcTemplate jdbc, String codigo) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM finanzas.concepto_financiero WHERE codigo = ?",
            Integer.class, codigo);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una serie de documento por sucursal, tipo de documento y serie.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param sucursalId ID de la sucursal
     * @param docTipoId ID del tipo de documento
     * @param serie Serie del documento
     * @return true si existe, false en caso contrario
     */
    private boolean existeDocTipoNumSerie(JdbcTemplate jdbc, Long sucursalId, Long docTipoId, String serie) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.doc_tipo_num_serie WHERE sucursal_id = ? AND doc_tipo_id = ? AND serie = ?",
            Integer.class, sucursalId, docTipoId, serie);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una serie de documento por sucursal, tipo de documento y serie.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @param sucursalId ID de la sucursal
     * @param docTipoId ID del tipo de documento
     * @param serie Serie del documento
     * @return true si existe, false en caso contrario
     */
    private boolean existeSerieDocumento(JdbcTemplate jdbc, Long sucursalId, Long docTipoId, String serie) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.doc_tipo_num_serie WHERE sucursal_id = ? AND doc_tipo_id = ? AND serie = ?",
            Integer.class, sucursalId, docTipoId, serie);
        return count != null && count > 0;
    }

    /**
     * DEPRECADO: Inserta maestros básicos de RRHH necesarios para trabajadores.
     * Crea áreas, cargos y AFP básicas.
     * 
     * NOTA: Este método ya no se usa. Los datos de RRHH deben insertarse desde rrhh-service.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número total de registros insertados
     * @deprecated Usar el seed de rrhh-service en su lugar
     */
    @Deprecated
    private int seedMaestrosRRHH(JdbcTemplate jdbc) {
        int total = 0;

        // Área: Administración
        if (!existeArea(jdbc, 1L)) {
            total += jdbc.update("""
                INSERT INTO rrhh.area (id, nombre, created_by, fec_creacion)
                VALUES (1, 'Administración', 1, NOW())
                """);
        }

        // Área: Operaciones
        if (!existeArea(jdbc, 2L)) {
            total += jdbc.update("""
                INSERT INTO rrhh.area (id, nombre, created_by, fec_creacion)
                VALUES (2, 'Operaciones', 1, NOW())
                """);
        }

        // Cargo: Gerente Administrativo
        if (!existeCargo(jdbc, 1L)) {
            total += jdbc.update("""
                INSERT INTO rrhh.cargo (id, nombre, nivel, sueldo_minimo, sueldo_maximo, created_by, fec_creacion)
                VALUES (1, 'Gerente Administrativo', 'Senior', 8000.00, 12000.00, 1, NOW())
                """);
        }

        // Cargo: Técnico Mantenimiento
        if (!existeCargo(jdbc, 2L)) {
            total += jdbc.update("""
                INSERT INTO rrhh.cargo (id, nombre, nivel, sueldo_minimo, sueldo_maximo, created_by, fec_creacion)
                VALUES (2, 'Técnico Mantenimiento', 'Junior', 2500.00, 3500.00, 1, NOW())
                """);
        }

        // AFP: Prima AFP
        if (!existeAdminAfp(jdbc, 1L)) {
            total += jdbc.update("""
                INSERT INTO rrhh.admin_afp (id, nombre, comision_porcentaje, prima_seguro, aporte_obligatorio, created_by, fec_creacion)
                VALUES (1, 'Prima AFP', 1.25, 1.35, 10.00, 1, NOW())
                """);
        }

        return total;
    }

    /**
     * DEPRECADO: Inserta 2 trabajadores de prueba para usar en documentos directos.
     * Uno como Gerente Administrativo y otro como Técnico de Mantenimiento.
     * 
     * NOTA: Este método ya no se usa. Los datos de RRHH deben insertarse desde rrhh-service.
     *
     * @param jdbc JdbcTemplate para ejecutar SQL
     * @return Número total de registros insertados
     * @deprecated Usar el seed de rrhh-service en su lugar
     */
    @Deprecated
    private int seedTrabajadores(JdbcTemplate jdbc) {
        int total = 0;

        // Trabajador 1: Juan Perez - Gerente Administrativo
        if (!existeTrabajador(jdbc, "45678901")) {
            total += jdbc.update("""
                INSERT INTO rrhh.trabajador (
                    entidad_contribuyente_id, codigo_trabajador, nombres, apellido_paterno, apellido_materno,
                    tipo_documento, numero_documento, fecha_nacimiento, sexo, estado_civil,
                    direccion, telefono, email, cuenta_bancaria_sueldo, cuenta_cts,
                    admin_afp_id, cuspp, regimen_laboral, area_id, cargo_id, sucursal_id,
                    fecha_ingreso, flag_estado, created_by, fec_creacion
                )
                VALUES (
                    1, 'TRAB001', 'Juan Carlos', 'Perez', 'Lopez',
                    'DNI', '45678901', '1985-03-15', 'M', 'Casado',
                    'Av. Principal 123, Lima', '987654321', 'juan.perez@sigre.pe',
                    '191-1234567-0-01', '191-8765432-1-99',
                    1, '12345678901234567890', 'RGDL', 1, 1, 1,
                    '2020-01-15', '1', 1, NOW()
                )
                """);
        }

        // Trabajador 2: Carlos Ramirez - Técnico Mantenimiento
        if (!existeTrabajador(jdbc, "87654321")) {
            total += jdbc.update("""
                INSERT INTO rrhh.trabajador (
                    entidad_contribuyente_id, codigo_trabajador, nombres, apellido_paterno, apellido_materno,
                    tipo_documento, numero_documento, fecha_nacimiento, sexo, estado_civil,
                    direccion, telefono, email, cuenta_bancaria_sueldo, cuenta_cts,
                    admin_afp_id, cuspp, regimen_laboral, area_id, cargo_id, sucursal_id,
                    fecha_ingreso, flag_estado, created_by, fec_creacion
                )
                VALUES (
                    1, 'TRAB002', 'Carlos Alberto', 'Ramirez', 'Sanchez',
                    'DNI', '87654321', '1990-07-22', 'M', 'Soltero',
                    'Jr. Secundaria 456, Lima', '912345678', 'carlos.ramirez@sigre.pe',
                    '191-9876543-0-02', '191-2345678-1-88',
                    1, '09876543210987654321', 'RGDL', 2, 2, 1,
                    '2021-06-01', '1', 1, NOW()
                )
                """);
        }

        return total;
    }

    /**
     * Verifica si existe un área por ID.
     */
    private boolean existeArea(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.area WHERE id = ?", Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un cargo por ID.
     */
    private boolean existeCargo(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.cargo WHERE id = ?", Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe una AFP por ID.
     */
    private boolean existeAdminAfp(JdbcTemplate jdbc, Long id) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.admin_afp WHERE id = ?", Integer.class, id);
        return count != null && count > 0;
    }

    /**
     * Verifica si existe un trabajador por número de documento.
     */
    private boolean existeTrabajador(JdbcTemplate jdbc, String numeroDocumento) {
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM rrhh.trabajador WHERE numero_documento = ?", Integer.class, numeroDocumento);
        return count != null && count > 0;
    }
}
