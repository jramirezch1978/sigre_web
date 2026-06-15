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
import com.sigre.compras.service.ConformidadServicioService;
import com.sigre.common.dto.ApiResponse;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ConformidadServicioController — Pruebas Unitarias")
class ConformidadServicioControllerTest {

    @Mock private ConformidadServicioService conformidadServicioService;
    @InjectMocks private ConformidadServicioController controller;

    private ConformidadServicioDetalleResponse detalleResponse;
    private ConformidadServicioResponse resumenResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = ConformidadServicioDetalleResponse.builder()
                .id(1L)
                .ordenServicioId(10L)
                .aprobado(false)
                .flagEstado("1")
                .lineas(Collections.emptyList())
                .build();

        resumenResponse = ConformidadServicioResponse.builder()
                .id(1L)
                .ordenServicioId(10L)
                .aprobado(false)
                .flagEstado("1")
                .build();
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna page data")
    void listar_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(conformidadServicioService.listar(any(), any(), any(), any(), any(), any()))
                .thenReturn(page);

        ApiResponse<PageData<ConformidadServicioResponse>> result =
                controller.listar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros delega al service")
    void listar_conFiltros_delegaAlService() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(conformidadServicioService.listar(eq(10L), eq(true), eq("1"), any(), any(), any()))
                .thenReturn(page);

        var result = controller.listar(10L, true, "1", null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        verify(conformidadServicioService).listar(eq(10L), eq(true), eq("1"), any(), any(), any());
    }

    @Test
    @DisplayName("listar() página vacia -> retorna ok")
    void listar_paginaVacia_retornaOk() {
        var page = new PageImpl<ConformidadServicioResponse>(Collections.emptyList());
        when(conformidadServicioService.listar(any(), any(), any(), any(), any(), any()))
                .thenReturn(page);

        var result = controller.listar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(conformidadServicioService.obtener(1L)).thenReturn(detalleResponse);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle")
    void crear_retornaDetalle() {
        when(conformidadServicioService.crear(any(ConformidadServicioRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.crear(new ConformidadServicioRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle")
    void actualizar_retornaDetalle() {
        when(conformidadServicioService.actualizar(eq(1L), any(ConformidadServicioRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.actualizar(1L, new ConformidadServicioRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    @DisplayName("aprobar() retorna detalle")
    void aprobar_retornaDetalle() {
        when(conformidadServicioService.aprobar(1L)).thenReturn(detalleResponse);

        var result = controller.aprobar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobada");
    }

    @Test
    @DisplayName("anular() retorna detalle")
    void anular_retornaDetalle() {
        when(conformidadServicioService.anular(1L)).thenReturn(detalleResponse);

        var result = controller.anular(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulada");
    }
}
