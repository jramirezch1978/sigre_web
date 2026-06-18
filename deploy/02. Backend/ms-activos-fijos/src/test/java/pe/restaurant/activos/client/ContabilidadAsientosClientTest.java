package pe.restaurant.activos.client;

import org.junit.jupiter.api.Test;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import java.lang.reflect.Method;

import static org.assertj.core.api.Assertions.assertThat;

class ContabilidadAsientosClientTest {

    @Test
    void hasFeignClientAnnotation() {
        FeignClient annotation = ContabilidadAsientosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation).isNotNull();
        assertThat(annotation.name()).isEqualTo("ms-contabilidad");
        assertThat(annotation.path()).isEqualTo("/api/contabilidad/asientos");
    }

    @Test
    void isInterface() {
        assertThat(ContabilidadAsientosClient.class.isInterface()).isTrue();
    }

    @Test
    void obtenerAsientoPorIdHasGetMapping() throws NoSuchMethodException {
        Method method = ContabilidadAsientosClient.class.getMethod("obtenerAsientoPorId", Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/{id}");
    }

    @Test
    void buscarPorOrigenHasGetMapping() throws NoSuchMethodException {
        Method method = ContabilidadAsientosClient.class.getMethod("buscarPorOrigen", String.class, Long.class);
        GetMapping mapping = method.getAnnotation(GetMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/buscar");
    }

    @Test
    void crearHasPostMapping() throws NoSuchMethodException {
        Method method = ContabilidadAsientosClient.class.getMethod("crear",
                pe.restaurant.activos.client.dto.contabilidad.AsientoRequest.class);
        PostMapping mapping = method.getAnnotation(PostMapping.class);
        assertThat(mapping).isNotNull();
    }

    @Test
    void generarDepreciacionHasPostMapping() throws NoSuchMethodException {
        Method method = ContabilidadAsientosClient.class.getMethod("generarDepreciacion",
                pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest.class);
        PostMapping mapping = method.getAnnotation(PostMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/generar/af-depreciacion");
    }

    @Test
    void generarRevaluacionHasPostMapping() throws NoSuchMethodException {
        Method method = ContabilidadAsientosClient.class.getMethod("generarRevaluacion",
                pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest.class);
        PostMapping mapping = method.getAnnotation(PostMapping.class);
        assertThat(mapping).isNotNull();
        assertThat(mapping.value()).containsExactly("/generar/af-revaluacion");
    }

    @Test
    void feignClientUsesFeignConfig() {
        FeignClient annotation = ContabilidadAsientosClient.class.getAnnotation(FeignClient.class);
        assertThat(annotation.configuration())
                .containsExactly(pe.restaurant.activos.config.FeignConfig.class);
    }

    @Test
    void generarIndexacionYDevengoTienenRutasAf() throws NoSuchMethodException {
        PostMapping idx = ContabilidadAsientosClient.class.getMethod("generarIndexacion",
                pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest.class)
                .getAnnotation(PostMapping.class);
        PostMapping dev = ContabilidadAsientosClient.class.getMethod("generarDevengoSeguros",
                pe.restaurant.activos.client.dto.contabilidad.GenerarAsientoRequest.class)
                .getAnnotation(PostMapping.class);
        assertThat(idx.value()).containsExactly("/generar/af-indexacion");
        assertThat(dev.value()).containsExactly("/generar/af-devengo-seguros");
    }

    @Test
    void crearUsaPostEnRaizDeAsientos() throws NoSuchMethodException {
        PostMapping mapping = ContabilidadAsientosClient.class.getMethod("crear",
                pe.restaurant.activos.client.dto.contabilidad.AsientoRequest.class)
                .getAnnotation(PostMapping.class);
        assertThat(mapping.value()).isEmpty();
    }

    @Test
    void tieneSieteMetodosFeign() {
        long feignMethods = java.util.Arrays.stream(ContabilidadAsientosClient.class.getDeclaredMethods())
                .filter(m -> !m.isSynthetic())
                .count();
        assertThat(feignMethods).isEqualTo(7);
    }
}
