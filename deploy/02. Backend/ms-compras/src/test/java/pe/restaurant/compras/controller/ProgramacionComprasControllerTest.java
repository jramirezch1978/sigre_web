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
import pe.restaurant.compras.service.ProgramacionComprasService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProgramacionComprasController — Pruebas Unitarias")
class ProgramacionComprasControllerTest {

    @Mock private ProgramacionComprasService programacionComprasService;
    @InjectMocks private ProgramacionComprasController controller;

    private ProgramacionComprasDetalleResponse detalleResponse;
    private ProgramacionComprasResponse resumenResponse;

    @BeforeEach
    void setUp() {
        detalleResponse = ProgramacionComprasDetalleResponse.builder()
                .id(1L)
                .numero("PC-001")
                .anio(2026)
                .mes(4)
                .flagEstado("1")
                .lineas(Collections.emptyList())
                .build();

        resumenResponse = ProgramacionComprasResponse.builder()
                .id(1L)
                .numero("PC-001")
                .flagEstado("1")
                .build();
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna page data")
    void listar_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(programacionComprasService.listar(any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<ProgramacionComprasResponse>> result =
                controller.listar(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros delega al service")
    void listar_conFiltros_delegaAlService() {
        var page = new PageImpl<>(List.of(resumenResponse));
        when(programacionComprasService.listar(eq(2026), eq(4), eq("BORRADOR"), any()))
                .thenReturn(page);

        ApiResponse<PageData<ProgramacionComprasResponse>> result =
                controller.listar(2026, 4, "BORRADOR", Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        verify(programacionComprasService).listar(eq(2026), eq(4), eq("BORRADOR"), any());
    }

    @Test
    @DisplayName("listar() página vacia -> retorna ok")
    void listar_paginaVacia_retornaOk() {
        var page = new PageImpl<ProgramacionComprasResponse>(Collections.emptyList());
        when(programacionComprasService.listar(any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<ProgramacionComprasResponse>> result =
                controller.listar(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    @Test
    @DisplayName("obtener() retorna detalle")
    void obtener_retornaDetalle() {
        when(programacionComprasService.obtener(1L)).thenReturn(detalleResponse);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna detalle con mensaje")
    void crear_retornaDetalleConMensaje() {
        when(programacionComprasService.crear(any(ProgramacionComprasRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.crear(new ProgramacionComprasRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).containsIgnoringCase("creada");
    }

    @Test
    @DisplayName("actualizar() retorna detalle con mensaje")
    void actualizar_retornaDetalleConMensaje() {
        when(programacionComprasService.actualizar(eq(1L), any(ProgramacionComprasRequest.class)))
                .thenReturn(detalleResponse);

        var result = controller.actualizar(1L, new ProgramacionComprasRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).containsIgnoringCase("actualizada");
    }

    @Test
    @DisplayName("confirmar() retorna detalle con mensaje")
    void confirmar_retornaDetalleConMensaje() {
        when(programacionComprasService.confirmar(1L)).thenReturn(detalleResponse);

        var result = controller.confirmar(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).containsIgnoringCase("confirmada");
    }

    @Test
    @DisplayName("anular() retorna detalle con mensaje")
    void anular_retornaDetalleConMensaje() {
        when(programacionComprasService.anular(1L)).thenReturn(detalleResponse);

        var result = controller.anular(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).containsIgnoringCase("anulada");
    }
}
