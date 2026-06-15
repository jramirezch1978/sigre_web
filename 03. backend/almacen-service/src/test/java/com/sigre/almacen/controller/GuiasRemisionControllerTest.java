package com.sigre.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.GuiaLineaRequest;
import com.sigre.almacen.dto.GuiaRequest;
import com.sigre.almacen.dto.GuiaResponse;
import com.sigre.almacen.service.GuiaRemisionService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class GuiasRemisionControllerTest {

    @Mock
    private GuiaRemisionService service;

    @InjectMocks
    private GuiasRemisionController controller;

    private GuiaResponse response;

    @BeforeEach
    void setUp() {
        response = GuiaResponse.builder()
                .id(1L)
                .sucursalId(10L)
                .serie("T001")
                .numero("00000001")
                .fechaEmision(LocalDate.of(2026, 5, 2))
                .flagEstado("1")
                .build();
    }

    @Test
    void buscar_delegates() {
        var page = new PageImpl<>(List.of(response));
        when(service.buscar(isNull(), isNull(), isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class)))
                .thenReturn(page);

        var result = controller.buscar(null, null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getContent().get(0).getSerie()).isEqualTo("T001");
    }

    @Test
    void obtener_returnsOne() {
        when(service.obtener(1L)).thenReturn(response);

        assertThat(controller.obtener(1L).getData().getNumero()).isEqualTo("00000001");
    }

    @Test
    void crear_actualizar_anular_delegate() {
        GuiaRequest req = sampleRequest();
        when(service.crear(any())).thenReturn(response);
        when(service.actualizar(eq(1L), any())).thenReturn(response);
        when(service.anular(1L)).thenReturn(response);

        assertThat(controller.crear(req).getMessage()).isEqualTo("Guía creada");
        assertThat(controller.actualizar(1L, req).getMessage()).isEqualTo("Guía actualizada");
        assertThat(controller.anular(1L).getMessage()).isEqualTo("Guía anulada");

        verify(service).crear(req);
        verify(service).actualizar(1L, req);
        verify(service).anular(1L);
    }

    @Test
    void enTransito_entregar_deleganEnServicio() {
        when(service.ponerEnTransito(5L)).thenReturn(response);
        when(service.marcarEntregada(6L)).thenReturn(response);

        assertThat(controller.enTransito(5L).getMessage()).isEqualTo("Guía en tránsito");
        assertThat(controller.entregar(6L).getMessage()).isEqualTo("Guía entregada");

        verify(service).ponerEnTransito(5L);
        verify(service).marcarEntregada(6L);
    }

    @Test
    void anularPatch_delegaIgualQuePost() {
        when(service.anular(8L)).thenReturn(response);
        assertThat(controller.anularPatch(8L).getMessage()).isEqualTo("Guía anulada");
        verify(service).anular(8L);
    }

    private static GuiaRequest sampleRequest() {
        GuiaLineaRequest linea = new GuiaLineaRequest();
        linea.setArticuloId(100L);
        linea.setUnidadMedidaId(1L);
        linea.setCantidad(new BigDecimal("5"));
        GuiaRequest req = new GuiaRequest();
        req.setSucursalId(10L);
        req.setSerie("T001");
        req.setNumero("00000001");
        req.setFechaEmision(LocalDate.of(2026, 5, 2));
        req.setDestinatarioId(200L);
        req.setLineas(List.of(linea));
        return req;
    }
}
