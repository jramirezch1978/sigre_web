package com.sigre.finanzas.testdata;

import org.springframework.jdbc.core.JdbcTemplate;
import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * TestDataSeeder específico para finanzas-service.
 * Inserta datos de prueba transaccionales específicos del módulo finanzas.
 * Valida por ID individual para manejar casos parciales (algunos IDs existen, otros no).
 *
 * Uso en tests:
 * <pre>
 *   &#64;Autowired DataSource dataSource;
 *   &#64;BeforeEach void setup() {
 *       // Maestros comunes
 *       new TestDataSeeder(dataSource).seedAll();
 *       // Datos específicos de finanzas
 *       new TestDataSeederFinanzas(dataSource).ensureFinanzasTransactionalData();
 *   }
 * </pre>
 */
public class TestDataSeederFinanzas {

    private final JdbcTemplate jdbc;

    public TestDataSeederFinanzas(DataSource dataSource) {
        this.jdbc = new JdbcTemplate(dataSource);
    }

    public TestDataSeederFinanzas(JdbcTemplate jdbcTemplate) {
        this.jdbc = jdbcTemplate;
    }

    /**
     * Asegura que todos los datos transaccionales de finanzas existan.
     * Valida por ID individual y actualiza si existe, inserta si no.
     *
     * @return Mapa con tabla -> cantidad de registros afectados (insertados + actualizados)
     */
    public Map<String, Integer> ensureFinanzasTransactionalData() {
        Map<String, Integer> counts = new LinkedHashMap<>();

        counts.put("finanzas.banco", ensureBanco());
        counts.put("finanzas.banco_cnta", ensureBancoCnta());
        counts.put("finanzas.concepto_financiero", ensureConceptoFinanciero());
        counts.put("finanzas.cntas_pagar", ensureCntasPagar());
        counts.put("finanzas.cntas_pagar_det", ensureCntasPagarDet());
        counts.put("finanzas.cntas_pagar_det_imp", ensureCntasPagarDetImp());
        counts.put("finanzas.caja_bancos", ensureCajaBancos());
        counts.put("finanzas.programacion_pago", ensureProgramacionPago());

        return counts;
    }

    /**
     * Asegura que existan bancos de prueba.
     * Valida por ID individual para manejar casos parciales.
     */
    private Integer ensureBanco() {
        int inserted = 0;
        int updated = 0;

        // Verificar e insertar/actualizar cada ID individualmente
        for (Long id : Arrays.asList(1L, 2L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.banco WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                // Insertar si no existe
                if (id == 1) {
                    jdbc.update("""
                        INSERT INTO finanzas.banco (id, cod_banco, nom_banco, flag_estado) VALUES
                        (1, '001', 'BANCO DE LA NACION', '1')
                        """);
                    inserted++;
                } else if (id == 2) {
                    jdbc.update("""
                        INSERT INTO finanzas.banco (id, cod_banco, nom_banco, flag_estado) VALUES
                        (2, '002', 'BANCO CREDITO', '1')
                        """);
                    inserted++;
                }
            } else {
                // Actualizar si existe
                if (id == 1) {
                    jdbc.update("""
                        UPDATE finanzas.banco SET
                            nom_banco = 'BANCO DE LA NACION',
                            flag_estado = '1'
                        WHERE id = 1
                        """);
                    updated++;
                } else if (id == 2) {
                    jdbc.update("""
                        UPDATE finanzas.banco SET
                            nom_banco = 'BANCO CREDITO',
                            flag_estado = '1'
                        WHERE id = 2
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan cuentas bancarias de prueba.
     */
    private Integer ensureBancoCnta() {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(1L, 2L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.banco_cnta WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 1) {
                    jdbc.update("""
                        INSERT INTO finanzas.banco_cnta (id, banco_id, cod_ctabco, descripcion, plan_contable_det_id, moneda_id, flag_estado) VALUES
                        (1, 1, '001-123456', 'CUENTA BANCARIA 1', 2, 1, '1')
                        """);
                    inserted++;
                } else if (id == 2) {
                    jdbc.update("""
                        INSERT INTO finanzas.banco_cnta (id, banco_id, cod_ctabco, descripcion, plan_contable_det_id, moneda_id, flag_estado) VALUES
                        (2, 2, '002-789012', 'CUENTA BANCARIA 2', 2, 1, '1')
                        """);
                    inserted++;
                }
            } else {
                if (id == 1) {
                    jdbc.update("""
                        UPDATE finanzas.banco_cnta SET
                            banco_id = 1,
                            cod_ctabco = '001-123456',
                            descripcion = 'CUENTA BANCARIA 1',
                            plan_contable_det_id = 2,
                            moneda_id = 1,
                            flag_estado = '1'
                        WHERE id = 1
                        """);
                    updated++;
                } else if (id == 2) {
                    jdbc.update("""
                        UPDATE finanzas.banco_cnta SET
                            banco_id = 2,
                            cod_ctabco = '002-789012',
                            descripcion = 'CUENTA BANCARIA 2',
                            plan_contable_det_id = 2,
                            moneda_id = 1,
                            flag_estado = '1'
                        WHERE id = 2
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan conceptos financieros de prueba.
     */
    private Integer ensureConceptoFinanciero() {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(1L, 2L, 3L, 4L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.concepto_financiero WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 1) {
                    jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (1, 'CF001', 'Cobro por ventas', '1')
                        """);
                    inserted++;
                } else if (id == 2) {
                    jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (2, 'CF002', 'Pago a proveedores', '1')
                        """);
                    inserted++;
                } else if (id == 3) {
                    jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (3, 'CF003', 'Transferencia entre cuentas', '1')
                        """);
                    inserted++;
                } else if (id == 4) {
                    jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (4, 'CF004', 'Aplicacion de documentos', '1')
                        """);
                    inserted++;
                }
            } else {
                if (id == 1) {
                    jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            codigo = 'CF001',
                            nombre = 'Cobro por ventas',
                            flag_estado = '1'
                        WHERE id = 1
                        """);
                    updated++;
                } else if (id == 2) {
                    jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            codigo = 'CF002',
                            nombre = 'Pago a proveedores',
                            flag_estado = '1'
                        WHERE id = 2
                        """);
                    updated++;
                } else if (id == 3) {
                    jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            codigo = 'CF003',
                            nombre = 'Transferencia entre cuentas',
                            flag_estado = '1'
                        WHERE id = 3
                        """);
                    updated++;
                } else if (id == 4) {
                    jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            codigo = 'CF004',
                            nombre = 'Aplicacion de documentos',
                            flag_estado = '1'
                        WHERE id = 4
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan cuentas por pagar de prueba.
     */
    private Integer ensureCntasPagar() {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(1001L, 1002L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.cntas_pagar WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 1001) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar
                        (id, sucursal_id, proveedor_id, doc_tipo_id, serie, numero,
                         fecha_emision, fecha_vencimiento, moneda_id, total, saldo,
                         flag_estado, created_by, fec_creacion)
                        VALUES
                        (1001, 1, 1, 1, 'F001', '00000001', CURRENT_DATE,
                         CURRENT_DATE + 30, 1, 1180.00, 1180.00, '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 1002) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar
                        (id, sucursal_id, proveedor_id, doc_tipo_id, serie, numero,
                         fecha_emision, fecha_vencimiento, moneda_id, total, saldo,
                         flag_estado, created_by, fec_creacion)
                        VALUES
                        (1002, 1, 1, 1, 'F001', '00000002', CURRENT_DATE,
                         CURRENT_DATE + 30, 1, 2360.00, 2360.00, '1', 1, NOW())
                        """);
                    inserted++;
                }
            } else {
                if (id == 1001) {
                    jdbc.update("""
                        UPDATE finanzas.cntas_pagar SET
                            saldo = total,
                            flag_estado = '1'
                        WHERE id = 1001
                        """);
                    updated++;
                } else if (id == 1002) {
                    jdbc.update("""
                        UPDATE finanzas.cntas_pagar SET
                            saldo = total,
                            flag_estado = '1'
                        WHERE id = 1002
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan movimientos de caja y bancos de prueba.
     */
    private Integer ensureCajaBancos() {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(2001L, 2002L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.caja_bancos WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 2001) {
                    jdbc.update("""
                        INSERT INTO finanzas.caja_bancos
                        (id, sucursal_id, nro_registro, flag_tipo_transaccion, banco_cnta_id,
                         fecha_emision, moneda_id, entidad_contribuyente_id, imp_total, imp_asignado,
                         concepto_financiero_id, ano, mes, cntbl_libro_id,
                         doc_tipo_id, nro_doc, observacion,
                         tasa_cambio, medio_pago_id, flag_estado, created_by, fec_creacion)
                        VALUES
                        (2001, 1, 'CB-00002001', 'C', 1, CURRENT_DATE, 1, 1,
                         1000.00, 1000.00, 1, 2026, 6, 1,
                         1, 'REC-001', 'Cobro de prueba',
                         1.000000, 1, '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 2002) {
                    jdbc.update("""
                        INSERT INTO finanzas.caja_bancos
                        (id, sucursal_id, nro_registro, flag_tipo_transaccion, banco_cnta_id,
                         fecha_emision, moneda_id, entidad_contribuyente_id, imp_total, imp_asignado,
                         concepto_financiero_id, ano, mes, cntbl_libro_id,
                         doc_tipo_id, nro_doc, observacion,
                         tasa_cambio, medio_pago_id, flag_estado, created_by, fec_creacion)
                        VALUES
                        (2002, 1, 'CB-00002002', 'P', 1, CURRENT_DATE, 1, 1,
                         800.00, 800.00, 2, 2026, 6, 1,
                         2, 'PAG-001', 'Pago de prueba',
                         1.000000, 2, '1', 1, NOW())
                        """);
                    inserted++;
                }
            } else {
                if (id == 2001) {
                    jdbc.update("""
                        UPDATE finanzas.caja_bancos SET
                            imp_asignado = imp_total,
                            flag_estado = '1'
                        WHERE id = 2001
                        """);
                    updated++;
                } else if (id == 2002) {
                    jdbc.update("""
                        UPDATE finanzas.caja_bancos SET
                            imp_asignado = imp_total,
                            flag_estado = '1'
                        WHERE id = 2002
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan programaciones de pago de prueba.
     */
    private Integer ensureProgramacionPago() {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(8001L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.programacion_pago WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 8001) {
                    jdbc.update("""
                        INSERT INTO finanzas.programacion_pago
                        (id, fecha_programada, flag_estado, created_by, fec_creacion)
                        VALUES
                        (8001, CURRENT_DATE + 7, '1', 1, NOW())
                        """);
                    inserted++;
                }
            } else {
                if (id == 8001) {
                    jdbc.update("""
                        UPDATE finanzas.programacion_pago SET
                            flag_estado = '1'
                        WHERE id = 8001
                        """);
                    updated++;
                }
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan detalles de cuentas por pagar de prueba.
     * Necesario para tests de LetraCanjeController y NotaController.
     */
    private Integer ensureCntasPagarDet() {
        int inserted = 0;
        int updated = 0;

        Long[] ids = {5001L, 5002L, 5003L, 5004L};

        for (Long id : ids) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.cntas_pagar_det WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                if (id == 5001) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5001, 1001, 1, 2, 'Compra de materia prima - Arroz',
                         100.0000, 10.00000000, 1000.0000, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5002) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5002, 1001, 2, 2, 'Compra de materia prima - Aceite',
                         50.0000, 20.00000000, 1000.0000, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5003) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5003, 1002, 1, 2, 'Compra de insumos de limpieza',
                         20.0000, 50.00000000, 1000.0000, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5004) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5004, 1002, 2, 2, 'Compra de útiles de oficina',
                         10.0000, 100.00000000, 1000.0000, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                }
            } else {
                jdbc.update("""
                    UPDATE finanzas.cntas_pagar_det SET
                        flag_estado = '1'
                    WHERE id = ?
                    """, id);
                updated++;
            }
        }

        return inserted + updated;
    }

    /**
     * Asegura que existan impuestos por detalle de cuentas por pagar de prueba.
     */
    private Integer ensureCntasPagarDetImp() {
        int inserted = 0;
        int updated = 0;

        record DetImpSeed(long id, long detId) {}
        DetImpSeed[] seeds = {
            new DetImpSeed(6001L, 5001L),
            new DetImpSeed(6002L, 5002L),
            new DetImpSeed(6003L, 5003L),
            new DetImpSeed(6004L, 5004L)
        };

        for (DetImpSeed seed : seeds) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.cntas_pagar_det_imp WHERE id = ?",
                Integer.class, seed.id());

            if (count == null || count == 0) {
                jdbc.update("""
                    INSERT INTO finanzas.cntas_pagar_det_imp
                    (id, cntas_pagar_det_id, tipos_impuesto_id, importe, created_by, fec_creacion)
                    VALUES (?, ?, 1, 0, 1, NOW())
                    """, seed.id(), seed.detId());
                inserted++;
            } else {
                jdbc.update("""
                    UPDATE finanzas.cntas_pagar_det_imp SET
                        tipos_impuesto_id = 1,
                        importe = 0
                    WHERE id = ?
                    """, seed.id());
                updated++;
            }
        }

        return inserted + updated;
    }
}
