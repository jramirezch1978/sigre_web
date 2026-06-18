package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.InventarioConteoRequest;
import pe.restaurant.almacen.dto.InventarioConteoResponse;
import pe.restaurant.almacen.service.InventarioConteoService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class InventarioConteoControllerTest {

    @Mock
    private InventarioConteoService service;

    @InjectMocks
    private InventarioConteoController controller;

    private InventarioConteoResponse response;

    @BeforeEach
    void setUp() {
        response = InventarioConteoResponse.builder()
                .id(1L)
                .almacenId(10L)
                .articuloId(100L)
                .fechaConteo(LocalDate.of(2026, 5, 2))
                .flagEstado("1")
                .build();
    }

    @Test
    void buscar_delegatesAndWrapsPage() {
        var page = new PageImpl<>(List.of(response));
        when(service.buscar(isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);

        var result = controller.buscar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    void buscar_pasaFechasAlServicio() {
        LocalDate desde = LocalDate.of(2026, 2, 1);
        LocalDate hasta = LocalDate.of(2026, 2, 28);
        var page = new PageImpl<>(List.of(response));
        when(service.buscar(isNull(), isNull(), isNull(), eq(desde), eq(hasta), any(Pageable.class)))
                .thenReturn(page);

        var result = controller.buscar(null, null, null, desde, hasta, Pageable.unpaged());

        assertThat(result.getData().getContent()).hasSize(1);
        verify(service).buscar(null, null, null, desde, hasta, Pageable.unpaged());
    }

    @Test
    void obtener_returnsOne() {
        when(service.obtener(1L)).thenReturn(response);

        var result = controller.obtener(1L);

        assertThat(result.getData().getFlagEstado()).isEqualTo("1");
        verify(service).obtener(1L);
    }

    @Test
    void crear_returnsCreatedPayload() {
        InventarioConteoRequest req = new InventarioConteoRequest();
        req.setAlmacenId(10L);
        req.setArticuloId(100L);
        req.setFechaConteo(LocalDate.of(2026, 5, 2));
        when(service.crear(any())).thenReturn(response);

        var result = controller.crear(req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Toma de inventario registrada");
        verify(service).crear(req);
    }

    @Test
    void actualizar_delegates() {
        InventarioConteoRequest req = new InventarioConteoRequest();
        req.setAlmacenId(10L);
        req.setArticuloId(100L);
        req.setFechaConteo(LocalDate.of(2026, 5, 2));
        when(service.actualizar(eq(1L), any())).thenReturn(response);

        var result = controller.actualizar(1L, req);

        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(service).actualizar(1L, req);
    }

    @Test
    void comparar_cerrar_anular_delegate() {
        when(service.comparar(1L)).thenReturn(response);
        when(service.cerrar(1L)).thenReturn(response);
        when(service.anular(1L)).thenReturn(response);

        assertThat(controller.compararPost(1L).getMessage()).isEqualTo("Comparación registrada");
        assertThat(controller.compararPatch(1L).getMessage()).isEqualTo("Comparación registrada");
        assertThat(controller.cerrarPost(1L).getMessage()).isEqualTo("Toma de inventario cerrada");
        assertThat(controller.anularPost(1L).getMessage()).isEqualTo("Toma de inventario anulada");

        verify(service, times(2)).comparar(1L);
        verify(service).cerrar(1L);
        verify(service).anular(1L);
    }
}
