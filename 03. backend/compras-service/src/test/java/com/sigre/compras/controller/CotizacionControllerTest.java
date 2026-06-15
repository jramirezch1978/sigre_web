package com.sigre.compras.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.*;
import com.sigre.compras.service.CotizacionService;
import com.sigre.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CotizacionController — Pruebas Unitarias")
class CotizacionControllerTest {

    @Mock private CotizacionService cotizacionService;
    @InjectMocks private CotizacionController controller;

    private CotizacionDetalleResponse detalle;
    private CotizacionResponse resumen;

    @BeforeEach
    void setUp() {
        detalle = CotizacionDetalleResponse.builder()
                .id(1L).proveedorId(10L).flagEstado("1").fecha(LocalDate.now())
                .total(new BigDecimal("500")).flagEstado("1")
                .lineas(Collections.emptyList()).build();

        resumen = CotizacionResponse.builder()
                .id(1L).proveedorId(10L).flagEstado("1")
                .total(new BigDecimal("500")).flagEstado("1").build();
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna page data")
    void listar_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(resumen));
        when(cotizacionService.listar(any(), any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<CotizacionResponse>> result = controller.listar(null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros delega al service")
    void listar_conFiltros_delegaAlService() {
        var page = new PageImpl<>(List.of(resumen));
        when(cotizacionService.listar(eq(10L), eq("REGISTRADA"), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<CotizacionResponse>> result = controller.listar(10L, "REGISTRADA", null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        verify(cotizacionService).listar(eq(10L), eq("REGISTRADA"), any(), any(), any());
    }

    @Test
    @DisplayName("listar() página vacia -> retorna ok")
    void listar_paginaVacia_retornaOk() {
        var page = new PageImpl<CotizacionResponse>(Collections.emptyList());
        when(cotizacionService.listar(any(), any(), any(), any(), any())).thenReturn(page);

        var result = controller.listar(null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(cotizacionService.obtener(1L)).thenReturn(detalle);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle")
    void crear_retornaDetalle() {
        when(cotizacionService.crear(any(CotizacionRequest.class))).thenReturn(detalle);

        var result = controller.crear(new CotizacionRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle")
    void actualizar_retornaDetalle() {
        when(cotizacionService.actualizar(eq(1L), any(CotizacionRequest.class))).thenReturn(detalle);

        var result = controller.actualizar(1L, new CotizacionRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    @DisplayName("seleccionar() retorna detalle")
    void seleccionar_retornaDetalle() {
        when(cotizacionService.seleccionar(1L)).thenReturn(detalle);

        var result = controller.seleccionar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("seleccionada");
    }

    @Test
    @DisplayName("descartar() retorna detalle")
    void descartar_retornaDetalle() {
        when(cotizacionService.descartar(1L)).thenReturn(detalle);

        var result = controller.descartar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("descartada");
    }

    @Test
    @DisplayName("anular() retorna detalle")
    void anular_retornaDetalle() {
        when(cotizacionService.anular(eq(1L), eq("Por error"))).thenReturn(detalle);

        CotizacionMotivoRequest req = new CotizacionMotivoRequest();
        req.setMotivo("Por error");
        var result = controller.anular(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulada");
    }
}
