package com.sigre.comercializacion.testdata;

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
 *         VentasTestDataExecutionListener.class
 *     },
 *     mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
 * )
 * </pre>
 * 
 * @author Equipo de Desarrollo
 * @since 2026-05-22
 */
public class VentasTestDataExecutionListener extends AbstractTestExecutionListener {

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

                    // 1. Maestros comunes necesarios para comercializacion-service
                    seeder.seedMoneda();
                    seeder.seedSucursal();
                    seeder.seedTiposDocumento();
                    seeder.seedEntidadContribuyente();
                    seeder.seedActualizarFlagsProveedorCliente();
                    seeder.seedDocTipo();
                    seeder.seedDocTipoNumSerie();

                    // 2. Datos transaccionales específicos de ventas
                    seeder.seedArticulo();
                    seeder.seedVendedor();
                    seeder.seedMesa();
                    seeder.seedComprador();
                    seeder.seedAprobadorConfigurado();
                    seeder.seedServicio();

                    seeded = true;
                } catch (Exception e) {
                    // Si algún seeder falla, no bloquear toda la suite
                    System.err.println("⚠️ Error en VentasTestDataExecutionListener: " + e.getMessage());
                } finally {
                    TenantContext.clear();
                }
            }
        }
    }
}
