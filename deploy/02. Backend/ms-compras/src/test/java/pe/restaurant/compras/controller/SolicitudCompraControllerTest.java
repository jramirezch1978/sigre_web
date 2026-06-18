package pe.restaurant.compras.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.service.SolicitudCompraService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SolicitudCompraController — Pruebas Unitarias")
class SolicitudCompraControllerTest {

    @Mock private SolicitudCompraService solicitudCompraService;
    @InjectMocks private SolicitudCompraController controller;

    private SolicitudCompraDetalleResponse detalleResponse;
    private SolicitudCompraResponse resumenResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = SolicitudCompraDetalleResponse.builder()
                .id(1L)
                .numero("SC-001")
                .flagEstado("1")
                .fecha(LocalDate.now())
                .lineas(Collections.emptyList())
                .build();

        resumenResponse = SolicitudCompraResponse.builder()
                .id(1L)
                .numero("SC-001")
                .flagEstado("1")
                .build();
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna page data")
    void listar_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(solicitudCompraService.listar(any(), any(), any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<SolicitudCompraResponse>> result = controller.listar(
                null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros delega al service")
    void listar_conFiltros_delegaAlService() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(solicitudCompraService.listar(eq(1L), eq("BORRADOR"), eq("ALTA"), any(), any(), any()))
                .thenReturn(page);

        ApiResponse<PageData<SolicitudCompraResponse>> result = controller.listar(
                1L, "BORRADOR", "ALTA", null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        verify(solicitudCompraService).listar(eq(1L), eq("BORRADOR"), eq("ALTA"), any(), any(), any());
    }

    @Test
    @DisplayName("listar() página vacia -> retorna ok")
    void listar_paginaVacia_retornaOk() {
        var page = new PageImpl<SolicitudCompraResponse>(Collections.emptyList());
        when(solicitudCompraService.listar(any(), any(), any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<SolicitudCompraResponse>> result = controller.listar(
                null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(solicitudCompraService.obtener(1L)).thenReturn(detalleResponse);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle con mensaje")
    void crear_retornaDetalleConMensaje() {
        when(solicitudCompraService.crear(any(SolicitudCompraRequest.class))).thenReturn(detalleResponse);

        var result = controller.crear(new SolicitudCompraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle con mensaje")
    void actualizar_retornaDetalleConMensaje() {
        when(solicitudCompraService.actualizar(eq(1L), any(SolicitudCompraRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.actualizar(1L, new SolicitudCompraRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    @DisplayName("enviar() retorna detalle con mensaje")
    void enviar_retornaDetalleConMensaje() {
        when(solicitudCompraService.enviar(1L)).thenReturn(detalleResponse);

        var result = controller.enviar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("enviada");
    }

    @Test
    @DisplayName("aprobar() con observacion -> retorna detalle")
    void aprobar_conObservacion_retornaDetalle() {
        when(solicitudCompraService.aprobar(eq(1L), eq("Conforme"))).thenReturn(detalleResponse);

        OrdenCompraObservacionRequest body = new OrdenCompraObservacionRequest();
        body.setObservacion("Conforme");
        var result = controller.aprobar(1L, body);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("aprobada");
    }

    @Test
    @DisplayName("aprobar() sin body -> retorna detalle")
    void aprobar_sinBody_retornaDetalle() {
        when(solicitudCompraService.aprobar(eq(1L), isNull())).thenReturn(detalleResponse);

        var result = controller.aprobar(1L, null);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("rechazar() retorna detalle con mensaje")
    void rechazar_retornaDetalleConMensaje() {
        when(solicitudCompraService.rechazar(eq(1L), eq("No cumple"))).thenReturn(detalleResponse);

        OrdenCompraMotivoRequest req = new OrdenCompraMotivoRequest();
        req.setMotivo("No cumple");
        var result = controller.rechazar(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("rechazada");
    }

    @Test
    @DisplayName("anular() retorna detalle con mensaje")
    void anular_retornaDetalleConMensaje() {
        when(solicitudCompraService.anular(eq(1L), eq("Por error"))).thenReturn(detalleResponse);

        OrdenCompraMotivoRequest req = new OrdenCompraMotivoRequest();
        req.setMotivo("Por error");
        var result = controller.anular(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulada");
    }
}
