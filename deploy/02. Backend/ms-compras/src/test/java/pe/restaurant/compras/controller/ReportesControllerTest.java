package pe.restaurant.compras.controller;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.compras.service.ReporteComprasService;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ReportesController — Pruebas Unitarias")
class ReportesControllerTest {

    @Mock private ReporteComprasService service;
    @InjectMocks private ReportesController controller;

    private static final List<Map<String, Object>> SAMPLE =
            List.of(Map.of("campo", "valor"));

    @Test
    @DisplayName("gestion-compras delega filtros al service y envuelve en ApiResponse")
    void gestionCompras() {
        LocalDate desde = LocalDate.of(2026, 1, 1);
        LocalDate hasta = LocalDate.of(2026, 1, 31);
        when(service.gestionCompras(5L, desde, hasta)).thenReturn(SAMPLE);

        var result = controller.gestionCompras(5L, desde, hasta);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isSameAs(SAMPLE);
        verify(service).gestionCompras(5L, desde, hasta);
    }

    @Test
    @DisplayName("compras-transito delega sucursalId")
    void comprasTransito() {
        when(service.comprasTransito(2L)).thenReturn(SAMPLE);
        assertThat(controller.comprasTransito(2L).getData()).isSameAs(SAMPLE);
        verify(service).comprasTransito(2L);
    }

    @Test
    @DisplayName("compras-por-ingresar delega sucursalId")
    void comprasPorIngresar() {
        when(service.comprasPorIngresar(null)).thenReturn(SAMPLE);
        assertThat(controller.comprasPorIngresar(null).getData()).isSameAs(SAMPLE);
        verify(service).comprasPorIngresar(null);
    }

    @Test
    @DisplayName("compras-sugeridas delega sucursalId")
    void comprasSugeridas() {
        when(service.comprasSugeridas(2L)).thenReturn(SAMPLE);
        assertThat(controller.comprasSugeridas(2L).getData()).isSameAs(SAMPLE);
        verify(service).comprasSugeridas(2L);
    }

    @Test
    @DisplayName("compras-categoria delega sucursalId")
    void comprasCategoria() {
        when(service.comprasCategoria(2L)).thenReturn(SAMPLE);
        assertThat(controller.comprasCategoria(2L).getData()).isSameAs(SAMPLE);
        verify(service).comprasCategoria(2L);
    }

    @Test
    @DisplayName("analisis-proveedores delega sucursalId")
    void analisisProveedores() {
        when(service.analisisProveedores(2L)).thenReturn(SAMPLE);
        assertThat(controller.analisisProveedores(2L).getData()).isSameAs(SAMPLE);
        verify(service).analisisProveedores(2L);
    }

    @Test
    @DisplayName("compras (procesadas) delega sucursalId")
    void comprasProcesadas() {
        when(service.comprasProcesadas(2L)).thenReturn(SAMPLE);
        assertThat(controller.comprasProcesadas(2L).getData()).isSameAs(SAMPLE);
        verify(service).comprasProcesadas(2L);
    }
}
