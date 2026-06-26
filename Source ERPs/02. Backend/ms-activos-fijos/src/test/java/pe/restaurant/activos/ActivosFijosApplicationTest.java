package pe.restaurant.activos;

import org.junit.jupiter.api.Test;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mockStatic;

class ActivosFijosApplicationTest {

    @Test
    void mainMethodInvokesSpringApplicationRun() {
        try (var mocked = mockStatic(SpringApplication.class)) {
            ActivosFijosApplication.main(new String[]{});
            mocked.verify(() -> SpringApplication.run(ActivosFijosApplication.class, new String[]{}));
        }
    }

    @Test
    void hasSpringBootApplicationAnnotation() {
        assertThat(ActivosFijosApplication.class.isAnnotationPresent(SpringBootApplication.class)).isTrue();
    }

    @Test
    void hasEnableFeignClientsAnnotation() {
        assertThat(ActivosFijosApplication.class.isAnnotationPresent(EnableFeignClients.class)).isTrue();
    }

    @Test
    void hasEnableJpaAuditingAnnotation() {
        assertThat(ActivosFijosApplication.class.isAnnotationPresent(EnableJpaAuditing.class)).isTrue();
    }

    @Test
    void springBootApplicationScanBasePackages() {
        SpringBootApplication annotation = ActivosFijosApplication.class.getAnnotation(SpringBootApplication.class);
        assertThat(annotation.scanBasePackages())
                .contains("pe.restaurant.activos", "pe.restaurant.common");
    }
}
