package pe.restaurant.activos.support;

import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * IT HTTP (MockMvc) sobre el mismo contrato que {@link ActivosIntegrationTest}.
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Inherited
@ActivosIntegrationTest
@AutoConfigureMockMvc
public @interface ActivosIntegrationMockMvcTest {
}
