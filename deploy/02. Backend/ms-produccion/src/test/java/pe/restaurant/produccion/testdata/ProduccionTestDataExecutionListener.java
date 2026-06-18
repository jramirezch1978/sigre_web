package pe.restaurant.produccion.testdata;

import org.springframework.test.context.TestContext;
import org.springframework.test.context.support.AbstractTestExecutionListener;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.testutil.TestDataFactory;

import javax.sql.DataSource;

public class ProduccionTestDataExecutionListener extends AbstractTestExecutionListener {

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
                            .seedArticulo()
                            .seedSucursal();

                    testContext.getApplicationContext()
                            .getBean(ProduccionTestDataFactory.class)
                            .ensurePlanificacionData();

                    seeded = true;
                } catch (Exception e) {
                    System.err.println("⚠️ Error en ProduccionTestDataExecutionListener: " + e.getMessage());
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
