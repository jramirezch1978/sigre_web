package pe.restaurant.activos.client;

import org.junit.jupiter.api.Test;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;

import java.lang.reflect.Method;

import static org.assertj.core.api.Assertions.assertThat;

class ComprasActivosClientTest {

    @Test
    void hasFeignClientAnnotation() {
        FeignClient annotation = ComprasActivosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation).isNotNull();
        assertThat(annotation.name()).isEqualTo("ms-compras");
        assertThat(annotation.path()).isEqualTo("/api/compras");
    }

    @Test
    void isInterface() {
        assertThat(ComprasActivosClient.class.isInterface()).isTrue();
    }

    @Test
    void obtenerOrdenCompraHasGetMapping() throws NoSuchMethodException {
        Method method = ComprasActivosClient.class.getMethod("obtenerOrdenCompra", Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/ordenes-compra/{id}");
    }

    @Test
    void listarRecepcionesHasGetMapping() throws NoSuchMethodException {
        Method method = ComprasActivosClient.class.getMethod("listarRecepciones", Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/ordenes-compra/{id}/recepciones");
    }

    @Test
    void feignClientUsesFeignConfig() {
        FeignClient annotation = ComprasActivosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation.configuration())
                .containsExactly(pe.restaurant.activos.config.FeignConfig.class);
    }
}
