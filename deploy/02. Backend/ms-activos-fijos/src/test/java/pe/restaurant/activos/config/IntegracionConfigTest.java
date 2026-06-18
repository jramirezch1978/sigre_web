package pe.restaurant.activos.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import static org.assertj.core.api.Assertions.assertThat;

class IntegracionConfigTest {

    @Test
    void classHasConfigurationAnnotation() {
        assertThat(IntegracionConfig.class.isAnnotationPresent(Configuration.class)).isTrue();
    }

    @Test
    void classHasEnableConfigurationPropertiesAnnotation() {
        assertThat(IntegracionConfig.class.isAnnotationPresent(EnableConfigurationProperties.class)).isTrue();
    }

    @Test
    void enableConfigurationPropertiesTargetsIntegracionProperties() {
        EnableConfigurationProperties annotation =
                IntegracionConfig.class.getAnnotation(EnableConfigurationProperties.class);
        assertThat(annotation.value()).containsExactly(IntegracionProperties.class);
    }

    @Test
    void canInstantiate() {
        IntegracionConfig config = new IntegracionConfig();
        assertThat(config).isNotNull();
    }
}
