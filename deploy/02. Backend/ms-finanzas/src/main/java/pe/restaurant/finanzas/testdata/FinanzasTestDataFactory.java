package pe.restaurant.finanzas.testdata;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Factory B del microservicio ms-finanzas.
 * Componente Spring inyectable en tests de integracion.
 *
 * <p>Inserta datos de prueba transaccionales especificos del modulo finanzas.
 * Cada metodo privado valida existencia antes de insertar (idempotente).</p>
 *
 * <p>Uso en tests de integracion:</p>
 * <pre>
 *   &#64;Autowired private FinanzasTestDataFactory finanzasFactory;
 *   &#64;BeforeEach void setup() {
 *       // Maestros comunes (A)
 *       TestDataFactory.using(dataSource)
 *           .seedMoneda()
 *           .seedEntidadContribuyente();
 *       // Datos transaccionales de finanzas (B)
 *       finanzasFactory.ensureFinanzasTransactionalData();
 *       Long cxpId = finanzasFactory.resolveCntasPagarId();
 *   }
 * </pre>
 */
@Component
@RequiredArgsConstructor
public class FinanzasTestDataFactory {

    public static final Long BANCO_ID_TEST = 1L;
    public static final Long BANCO_ID_TEST_2 = 2L;
    public static final String NRO_CXP_TEST = "F001-00000001";
    public static final String NRO_CXP_TEST_2 = "F001-00000002";

    private final DataSource dataSource;

    /**
     * Asegura que todos los datos transaccionales de finanzas existan.
     * Cada metodo privado valida existencia antes de insertar (idempotente).
     *
     * @return Mapa con tabla -&gt; cantidad de registros afectados (insertados + actualizados)
     */
    @Transactional
    public Map<String, Integer> ensureFinanzasTransactionalData() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Map<String, Integer> out = new LinkedHashMap<>();

        out.put("finanzas.banco", ensureBanco(jdbc));
        out.put("finanzas.banco_cnta", ensureBancoCnta(jdbc));
        out.put("finanzas.concepto_financiero", ensureConceptoFinanciero(jdbc));
        out.put("finanzas.cntas_pagar", ensureCntasPagar(jdbc));
        out.put("finanzas.cntas_pagar_det", ensureCntasPagarDet(jdbc));
        out.put("finanzas.caja_bancos", ensureCajaBancos(jdbc));
        out.put("finanzas.programacion_pago", ensureProgramacionPago(jdbc));

        return out;
    }

    // ==== resolve*Id() — localizar por codigo de negocio ====

    public Long resolveCntasPagarId() {
        return new JdbcTemplate(dataSource).queryForObject(
            "SELECT id FROM finanzas.cntas_pagar WHERE serie = 'F001' AND numero = '00000001'",
            Long.class);
    }

    public Long resolveCntasPagarId2() {
        return new JdbcTemplate(dataSource).queryForObject(
            "SELECT id FROM finanzas.cntas_pagar WHERE serie = 'F001' AND numero = '00000002'",
            Long.class);
    }

    public Long resolveBancoId() {
        return BANCO_ID_TEST;
    }

    public Long resolveBancoId2() {
        return BANCO_ID_TEST_2;
    }

    public Long resolveConceptoFinancieroId(String codigo) {
        return new JdbcTemplate(dataSource).queryForObject(
            "SELECT id FROM finanzas.concepto_financiero WHERE codigo = ?",
            Long.class, codigo);
    }

    public Long resolveCajaBancosId(String nroRegistro) {
        return new JdbcTemplate(dataSource).queryForObject(
            "SELECT id FROM finanzas.caja_bancos WHERE nro_registro = ?",
            Long.class, nroRegistro);
    }

    public Long resolveProgramacionPagoId() {
        return 8001L;
    }

    // ==== metodos privados idempotentes ====

    private Integer ensureBanco(JdbcTemplate jdbc) {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(1L, 2L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.banco WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
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

    private Integer ensureBancoCnta(JdbcTemplate jdbc) {
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

    private Integer ensureConceptoFinanciero(JdbcTemplate jdbc) {
        int inserted = 0;
        int updated = 0;

        for (Long id : Arrays.asList(1L, 2L, 3L, 4L)) {
            Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM finanzas.concepto_financiero WHERE id = ?",
                Integer.class, id);

            if (count == null || count == 0) {
                switch (id.intValue()) {
                    case 1 -> jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (1, 'CF001', 'Cobro por ventas', '1')
                        """);
                    case 2 -> jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (2, 'CF002', 'Pago a proveedores', '1')
                        """);
                    case 3 -> jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (3, 'CF003', 'Transferencia entre cuentas', '1')
                        """);
                    case 4 -> jdbc.update("""
                        INSERT INTO finanzas.concepto_financiero (id, codigo, nombre, flag_estado) VALUES
                        (4, 'CF004', 'Aplicacion de documentos', '1')
                        """);
                }
                inserted++;
            } else {
                switch (id.intValue()) {
                    case 1 -> jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            nombre = 'Cobro por ventas',
                            flag_estado = '1'
                        WHERE id = 1
                        """);
                    case 2 -> jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            nombre = 'Pago a proveedores',
                            flag_estado = '1'
                        WHERE id = 2
                        """);
                    case 3 -> jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            nombre = 'Transferencia entre cuentas',
                            flag_estado = '1'
                        WHERE id = 3
                        """);
                    case 4 -> jdbc.update("""
                        UPDATE finanzas.concepto_financiero SET
                            nombre = 'Aplicacion de documentos',
                            flag_estado = '1'
                        WHERE id = 4
                        """);
                }
                updated++;
            }
        }

        return inserted + updated;
    }

    private Integer ensureCntasPagar(JdbcTemplate jdbc) {
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
                         fecha_emision, fecha_vencimiento, moneda_id, tasa_cambio, total, saldo,
                         ano, mes, cntbl_libro_id, flag_estado, created_by, fec_creacion)
                        VALUES
                        (1001, 1, 1, 1, 'F001', '00000001', CURRENT_DATE,
                         CURRENT_DATE + 30, 1, 1, 1180.00, 1180.00,
                         EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER, EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER, 1, '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 1002) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar
                        (id, sucursal_id, proveedor_id, doc_tipo_id, serie, numero,
                         fecha_emision, fecha_vencimiento, moneda_id, tasa_cambio, total, saldo,
                         ano, mes, cntbl_libro_id, flag_estado, created_by, fec_creacion)
                        VALUES
                        (1002, 1, 1, 1, 'F001', '00000002', CURRENT_DATE,
                         CURRENT_DATE + 30, 1, 1, 2360.00, 2360.00,
                         EXTRACT(YEAR FROM CURRENT_DATE)::INTEGER, EXTRACT(MONTH FROM CURRENT_DATE)::INTEGER, 1, '1', 1, NOW())
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

    private Integer ensureCntasPagarDet(JdbcTemplate jdbc) {
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
                         cantidad, precio_unitario, monto, centros_costo_id, tipos_impuesto_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5001, 1001, 1, 2, 'Compra de materia prima - Arroz',
                         100.0000, 10.00000000, 1000.0000, 1, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5002) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id, tipos_impuesto_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5002, 1001, 2, 2, 'Compra de materia prima - Aceite',
                         50.0000, 20.00000000, 1000.0000, 1, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5003) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id, tipos_impuesto_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5003, 1002, 1, 2, 'Compra de insumos de limpieza',
                         20.0000, 50.00000000, 1000.0000, 1, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
                        """);
                    inserted++;
                } else if (id == 5004) {
                    jdbc.update("""
                        INSERT INTO finanzas.cntas_pagar_det
                        (id, cntas_pagar_id, item, concepto_financiero_id, descripcion,
                         cantidad, precio_unitario, monto, centros_costo_id, tipos_impuesto_id,
                         fecha_mov, tipo_mov, flag_estado, created_by, fec_creacion)
                        VALUES
                        (5004, 1002, 2, 2, 'Compra de utiles de oficina',
                         10.0000, 100.00000000, 1000.0000, 1, 1, CURRENT_DATE, 'COMPRA', '1', 1, NOW())
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

    private Integer ensureCajaBancos(JdbcTemplate jdbc) {
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

    private Integer ensureProgramacionPago(JdbcTemplate jdbc) {
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
}
