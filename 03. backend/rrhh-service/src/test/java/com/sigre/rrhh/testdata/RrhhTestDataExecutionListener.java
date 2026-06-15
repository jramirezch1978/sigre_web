package com.sigre.rrhh.testdata;

import org.springframework.test.context.TestContext;
import org.springframework.test.context.support.AbstractTestExecutionListener;
import com.sigre.common.security.TenantContext;
import com.sigre.common.testutil.TestDataFactory;

import javax.sql.DataSource;

/**
 * TestExecutionListener que ejecuta los seeders de datos UNA sola vez
 * antes de toda la suite de tests de integración de RRHH.
 * 
 * <p>Usa {@link TestDataSeederRrhh} para datos base (maestros compartidos).
 * {@link RrhhTestDataFactory} queda disponible para tests particulares que
 * necesiten datos más específicos vía su propio {@code @BeforeEach}.</p>
 * 
 * <p>Uso en tests de integración:</p>
 * <pre>
 * &#64;TestExecutionListeners(
 *     listeners = {
 *         TenantContextTestExecutionListener.class,
 *         RrhhTestDataExecutionListener.class
 *     },
 *     mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
 * )
 * </pre>
 */
public class RrhhTestDataExecutionListener extends AbstractTestExecutionListener {

    private static volatile boolean seeded = false;
    private static final Object lock = new Object();

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

                    TestDataFactory.using(dataSource)
                            .seedMoneda()
                            .seedSucursal()
                            .seedTiposDocumento()
                            .seedCentrosCosto()
                            .seedEntidadContribuyente()
                            .seedPlanContable()
                            .seedDocTipo()
                            .seedDocTipoNumSerie();

                    new TestDataSeederRrhh(dataSource)
                            .ensureRrhhTransactionalData();

                    seeded = true;
                } catch (Exception e) {
                    System.err.println("⚠️ Error en RrhhTestDataExecutionListener: " + e.getMessage());
                } finally {
                    TenantContext.clear();
                }
            }
        }
    }

    @Override
    public int getOrder() {
        return Integer.MIN_VALUE + 100;
    }
}
