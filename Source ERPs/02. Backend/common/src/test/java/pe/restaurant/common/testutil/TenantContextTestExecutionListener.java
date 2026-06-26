package pe.restaurant.common.testutil;

import org.springframework.test.context.TestContext;
import org.springframework.test.context.support.AbstractTestExecutionListener;
import pe.restaurant.common.security.TenantContext;

/**
 * TestExecutionListener que establece el contexto de empresa ANTES de que Spring Boot
 * inicialice el ApplicationContext y cree el EntityManagerFactory.
 * 
 * Esto resuelve el problema de "Sin contexto de empresa" en tests de integración
 * que usan @SpringBootTest con arquitectura multitenant.
 * 
 * @author Equipo de Desarrollo
 */
public class TenantContextTestExecutionListener extends AbstractTestExecutionListener {
    
    private static final Long EMPRESA_ID_TEST = 2L;
    private static final Long SUCURSAL_ID_TEST = 1L;
    private static final Long USUARIO_ID_TEST = 1L;
    
    /**
     * Se ejecuta ANTES de preparar el TestContext.
     * Este es el momento más temprano posible para establecer el contexto.
     */
    @Override
    public void prepareTestInstance(TestContext testContext) {
        establecerContextoEmpresa();
    }
    
    /**
     * Se ejecuta ANTES de cada método de test.
     * Garantiza que el contexto esté presente incluso si se limpió.
     */
    @Override
    public void beforeTestMethod(TestContext testContext) {
        establecerContextoEmpresa();
    }
    
    /**
     * Se ejecuta DESPUÉS de cada método de test.
     * Limpia el contexto para evitar contaminación entre tests.
     */
    @Override
    public void afterTestMethod(TestContext testContext) {
        TenantContext.clear();
    }
    
    /**
     * Establece el contexto de empresa para tests.
     * Usa valores fijos que deben existir en la base de datos de test.
     */
    private void establecerContextoEmpresa() {
        TenantContext.setEmpresaId(EMPRESA_ID_TEST);
        TenantContext.setSucursalId(SUCURSAL_ID_TEST);
        TenantContext.setUsuarioId(USUARIO_ID_TEST);
    }
    
    /**
     * Orden de ejecución: lo más alto posible para ejecutarse primero.
     */
    @Override
    public int getOrder() {
        return Integer.MIN_VALUE; // Ejecutar antes que cualquier otro listener
    }
}
