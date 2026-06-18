package pe.restaurant.finanzas.controller;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.finanzas.service.CentroCostoCatalogoService;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CentroCostoCatalogoController — Pruebas Unitarias")
class CentroCostoCatalogoControllerTest {

    @Mock private CentroCostoCatalogoService service;
    @InjectMocks private CentroCostoCatalogoController controller;

    @Test
    @DisplayName("listar devuelve el catálogo dentro de ApiResponse.data")
    void listar() {
        List<Map<String, Object>> data = List.of(
                Map.of("id", 1L, "nombre", "Administración"),
                Map.of("id", 2L, "nombre", "Cocina"));
        when(service.listarActivos()).thenReturn(data);

        var result = controller.listar();

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isSameAs(data);
        assertThat(result.getData()).hasSize(2);
        verify(service).listarActivos();
    }
}
