package pe.restaurant.activos.client;

import org.junit.jupiter.api.Test;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.reflect.Method;

import static org.assertj.core.api.Assertions.assertThat;

class CoreMaestrosClientTest {

    @Test
    void hasFeignClientAnnotation() {
        FeignClient annotation = CoreMaestrosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation).isNotNull();
        assertThat(annotation.name()).isEqualTo("ms-core-maestros");
        assertThat(annotation.path()).isEqualTo("/api/core");
    }

    @Test
    void isInterface() {
        assertThat(CoreMaestrosClient.class.isInterface()).isTrue();
    }

    @Test
    void obtenerSucursalPorIdHasGetMapping() throws NoSuchMethodException {
        Method method = CoreMaestrosClient.class.getMethod("obtenerSucursalPorId", Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/sucursales/{id}");
    }

    @Test
    void obtenerEntidadPorIdHasGetMapping() throws NoSuchMethodException {
        Method method = CoreMaestrosClient.class.getMethod("obtenerEntidadPorId", Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/relaciones-comerciales/{id}");
    }

    @Test
    void feignClientUsesFeignConfig() {
        FeignClient annotation = CoreMaestrosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation.configuration())
                .containsExactly(pe.restaurant.activos.config.FeignConfig.class);
    }

    @Test
    void hasTwoDeclaredMethods() {
        long methods = java.util.Arrays.stream(CoreMaestrosClient.class.getDeclaredMethods())
                .filter(m -> !m.isSynthetic())
                .count();
        assertThat(methods).isEqualTo(2);
    }
}
