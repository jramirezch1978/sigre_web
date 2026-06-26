package pe.restaurant.activos.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.dto.AfNumeracionConfigResponse;
import pe.restaurant.activos.dto.SiguienteCodigoResponse;
import pe.restaurant.activos.service.AfNumeracionService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AfNumeracionControllerTest {

    @Mock private AfNumeracionService service;
    @InjectMocks private AfNumeracionController controller;

    @Test
    void obtenerConfig() {
        var config = new AfNumeracionConfigResponse();
        config.setTipo("MAESTRO");
        when(service.obtenerConfig("MAESTRO")).thenReturn(config);
        assertThat(controller.obtenerConfig("MAESTRO").getData().getTipo()).isEqualTo("MAESTRO");
    }

    @Test
    void siguienteCodigo() {
        when(service.generarSiguienteCodigo("MAESTRO"))
                .thenReturn(new SiguienteCodigoResponse("MAESTRO", "AF-00001", 1L));
        assertThat(controller.siguienteCodigo("MAESTRO").getData().getCodigo()).isEqualTo("AF-00001");
    }
}
