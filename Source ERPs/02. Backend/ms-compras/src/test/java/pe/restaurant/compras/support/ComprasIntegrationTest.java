package pe.restaurant.compras.support;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * IT con BD tenant (rol B): {@code -Dcompras.it=true}. TransacciÃ³n con rollback al final del test.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@Tag("it")
@EnabledIfSystemProperty(named = "compras.it", matches = "true")
@ActiveProfiles("test")
@SpringBootTest
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
public @interface ComprasIntegrationTest {
}
