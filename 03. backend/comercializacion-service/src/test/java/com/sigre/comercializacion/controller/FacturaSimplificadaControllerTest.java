package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.FacturaSimplCabeceraRequest;
import com.sigre.comercializacion.dto.request.FacturaSimplLineRequest;
import com.sigre.comercializacion.dto.response.FacturaSimplificadaResponse;
import com.sigre.comercializacion.entity.FsFacturaSimpl;
import com.sigre.comercializacion.service.FacturaSimplificadaService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class FacturaSimplificadaControllerTest {

    @Mock
    private FacturaSimplificadaService facturaSimplificadaService;
    @InjectMocks
    private FacturaSimplificadaController controller;

    private FsFacturaSimpl entity;
    private FacturaSimplificadaResponse response;

    @BeforeEach
    void setUp() {
        entity = new FsFacturaSimpl();
        entity.setId(1L);
        entity.setSerie("B001");
        entity.setNumero("1");
        entity.setFlagEstado("1");

        response = FacturaSimplificadaResponse.builder()
                .id(1L)
                .serie("B001")
                .numero("1")
                .items(List.of())
                .pagos(List.of())
                .build();
    }

    @Test
    void findAll() {
        when(facturaSimplificadaService.findAll(any(), any(), any(), any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        var r = controller.findAll(Pageable.unpaged(), null, null, null, null, null, null, null, null);
        assertThat(r.isSuccess()).isTrue();
        assertThat(r.getData().getContent()).hasSize(1);
    }

    @Test
    void findById() {
        when(facturaSimplificadaService.getById(1L)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void createUpdateEmitirAnularPagos() {
        FacturaSimplCabeceraRequest req = cabeceraValida();
        when(facturaSimplificadaService.create(any())).thenReturn(response);
        when(facturaSimplificadaService.update(eq(1L), any())).thenReturn(response);
        when(facturaSimplificadaService.emitir(1L)).thenReturn(response);
        when(facturaSimplificadaService.anular(1L)).thenReturn(response);
        when(facturaSimplificadaService.listPagos(1L)).thenReturn(List.of());
        assertThat(controller.create(req).isSuccess()).isTrue();
        assertThat(controller.update(1L, req).isSuccess()).isTrue();
        assertThat(controller.emitir(1L).isSuccess()).isTrue();
        assertThat(controller.anular(1L).isSuccess()).isTrue();
        assertThat(controller.pagos(1L).getData()).isEmpty();
    }

    @Test
    void activateDeactivateDelete() {
        when(facturaSimplificadaService.activate(1L)).thenReturn(response);
        when(facturaSimplificadaService.deactivate(1L)).thenReturn(response);
        assertThat(controller.activate(1L).isSuccess()).isTrue();
        assertThat(controller.deactivate(1L).isSuccess()).isTrue();
        controller.delete(1L);
        verify(facturaSimplificadaService).delete(1L);
    }

    private static FacturaSimplCabeceraRequest cabeceraValida() {
        FacturaSimplLineRequest line = new FacturaSimplLineRequest();
        line.setArticuloId(1L);
        line.setCantidad(BigDecimal.ONE);
        line.setPrecioUnitario(BigDecimal.TEN);
        FacturaSimplCabeceraRequest req = new FacturaSimplCabeceraRequest();
        req.setClienteId(1L);
        req.setDocTipoId(1L);
        req.setSerie("B001");
        req.setNumero("00000001");
        req.setFechaEmision(LocalDate.of(2026, 5, 7));
        req.setAno(2026);
        req.setMes(5);
        req.setCntblLibroId(4L);
        req.setItems(List.of(line));
        return req;
    }
}
