package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.SolSalidaLineaRequest;
import pe.restaurant.almacen.dto.SolSalidaRequest;
import pe.restaurant.almacen.dto.SolSalidaResponse;
import pe.restaurant.almacen.service.SolicitudSalidaService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SolicitudesSalidaControllerTest {

    @Mock
    private SolicitudSalidaService service;

    @InjectMocks
    private SolicitudesSalidaController controller;

    @Test
    void buscar() {
        SolSalidaResponse row = SolSalidaResponse.builder().id(1L).numero("N1").build();
        Pageable pg = PageRequest.of(0, 10);
        when(service.buscar(20L, "BORRADOR", pg)).thenReturn(new PageImpl<>(List.of(row)));

        var response = controller.buscar(20L, "BORRADOR", pg);

        assertThat(response.isSuccess()).isTrue();
        assertThat(response.getData().getContent()).hasSize(1);
    }

    @Test
    void obtener() {
        SolSalidaResponse data = SolSalidaResponse.builder().id(5L).build();
        when(service.obtener(5L)).thenReturn(data);

        assertThat(controller.obtener(5L).getData().getId()).isEqualTo(5L);
    }

    @Test
    void crear() {
        SolSalidaRequest req = new SolSalidaRequest();
        req.setAlmacenId(1L);
        req.setFecha(LocalDate.now());
        SolSalidaLineaRequest linea = new SolSalidaLineaRequest();
        linea.setArticuloId(10L);
        linea.setCantidad(BigDecimal.ONE);
        req.setLineas(List.of(linea));

        SolSalidaResponse created = SolSalidaResponse.builder().id(9L).build();
        when(service.crear(any(SolSalidaRequest.class))).thenReturn(created);

        var response = controller.crear(req);

        assertThat(response.isSuccess()).isTrue();
        assertThat(response.getMessage()).contains("creada");
        assertThat(response.getData().getId()).isEqualTo(9L);
    }

    @Test
    void actualizar() {
        SolSalidaRequest req = new SolSalidaRequest();
        req.setAlmacenId(1L);
        req.setFecha(LocalDate.now());
        SolSalidaLineaRequest linea = new SolSalidaLineaRequest();
        linea.setArticuloId(10L);
        linea.setCantidad(BigDecimal.ONE);
        req.setLineas(List.of(linea));

        when(service.actualizar(eq(3L), any(SolSalidaRequest.class)))
                .thenReturn(SolSalidaResponse.builder().id(3L).build());

        var response = controller.actualizar(3L, req);

        assertThat(response.getMessage()).contains("actualizada");
    }

    @Test
    void eliminar() {
        controller.eliminar(8L);
        verify(service).eliminar(8L);
    }

    @Test
    void cambiarEstado() {
        when(service.cambiarEstado(4L, "1"))
                .thenReturn(SolSalidaResponse.builder().id(4L).flagEstado("1").build());

        var response = controller.cambiarEstado(4L, "1");

        assertThat(response.getData().getFlagEstado()).isEqualTo("1");
    }
}
