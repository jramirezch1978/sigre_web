package com.sigre.finanzas.testdata;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.TestContext;
import org.springframework.test.context.support.AbstractTestExecutionListener;
import com.sigre.common.security.TenantContext;
import com.sigre.common.testutil.TestDataSeeder;

import javax.sql.DataSource;

/**
 * TestExecutionListener que ejecuta los seeders de datos UNA sola vez
 * antes de toda la suite de tests de integración, en lugar de en cada @BeforeEach.
 * 
 * <p>Problema que resuelve:</p>
 * <ul>
 *   <li>Antes: cada @BeforeEach llamaba a los seeders → 150+ inserts por suite</li>
 *   <li>Ahora: una sola llamada al inicio de la suite → misma data, 150x más rápido</li>
 * </ul>
 * 
 * <p>Los seeders usan ON CONFLICT / validación por ID, por lo que son idempotentes
 * y no generan errores si los datos ya existen en la BD remota.</p>
 * 
 * <p>Uso en tests de integración:</p>
 * <pre>
 * &#64;TestExecutionListeners(
 *     listeners = {
 *         TenantContextTestExecutionListener.class,
 *         FinanzasTestDataExecutionListener.class
 *     },
 *     mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
 * )
 * </pre>
 * 
 * @author Equipo de Desarrollo
 * @since 2026-05-20
 */
public class FinanzasTestDataExecutionListener extends AbstractTestExecutionListener {

    private static volatile boolean seeded = false;
    private static final Object lock = new Object();

    /**
     * Se ejecuta ANTES de que se ejecuten los métodos de test de una clase.
     * El seeding se hace solo la primera vez (singleton check).
     */
    @Override
    public void beforeTestClass(TestContext testContext) {
        synchronized (lock) {
            if (!seeded) {
                TenantContext.setEmpresaId(2L);
                TenantContext.setSucursalId(1L);
                TenantContext.setUsuarioId(1L);

                try {
                    DataSource dataSource = testContext.getApplicationContext()
                            .getBean(DataSource.class);

                    TestDataSeeder seeder = new TestDataSeeder(dataSource);

                    // 1. Maestros comunes necesarios para finanzas-service
                    seeder.seedMoneda();
                    seeder.seedSucursal();
                    seeder.seedTiposDocumento();
                    seeder.seedCentrosCosto();
                    seeder.seedEntidadContribuyente();
                    seeder.seedActualizarFlagsProveedorCliente();
                    seeder.seedConceptoFinanciero();
                    seeder.seedPlanContable();
                    seeder.seedDocTipo();
                    seeder.seedDocTipoNumSerie();

                    // Asegurar numeración para doc_tipo_id=1, serie=L001
                    JdbcTemplate jdbc = new JdbcTemplate(dataSource);
                    try {
                        jdbc.update("""
                            INSERT INTO core.doc_tipo_num_serie (sucursal_id, doc_tipo_id, serie, ultimo_numero, flag_estado)
                            VALUES (1, 1, 'L001', 0, '1')
                            ON CONFLICT (sucursal_id, doc_tipo_id, serie) DO UPDATE SET flag_estado = '1'
                            """);
                    } catch (Exception e) {
                        // No crítico si falla
                    }

                    // 2. Datos transaccionales específicos de finanzas
                    new TestDataSeederFinanzas(dataSource)
                            .ensureFinanzasTransactionalData();

                    seeded = true;
                } catch (Exception e) {
                    // Si algún seeder falla, no bloquear toda la suite
                    System.err.println("⚠️ Error en FinanzasTestDataExecutionListener: " + e.getMessage());
                } finally {
                    TenantContext.clear();
                }
            }
        }
    }

    @Override
    public int getOrder() {
        // Ejecutar DESPUÉS de TenantContext (que es MIN_VALUE) para que el
        // contexto de empresa ya esté establecido al momento de hacer los inserts
        return Integer.MIN_VALUE + 100;
    }
}
