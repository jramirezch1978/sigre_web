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
import pe.restaurant.compras.dto.ContratoMarcoRequest;
import pe.restaurant.compras.dto.ContratoMarcoResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.service.ContratoMarcoService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ContratoMarcoController — Pruebas Unitarias")
class ContratoMarcoControllerTest {

    @Mock private ContratoMarcoService contratoMarcoService;
    @InjectMocks private ContratoMarcoController controller;

    private ContratoMarcoResponse response;

    @BeforeEach
    void setUp() {
        response = ContratoMarcoResponse.builder()
                .id(1L).numero("CM-001").flagEstado("1").proveedorId(10L)
                .fechaInicio(LocalDate.now()).build();
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna page data")
    void listar_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(response));
        when(contratoMarcoService.listar(any(), any(), any(), any())).thenReturn(page);

        ApiResponse<PageData<ContratoMarcoResponse>> result =
                controller.listar(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros delega al service")
    void listar_conFiltros_delegaAlService() {
        var page = new PageImpl<>(List.of(response));
        when(contratoMarcoService.listar(eq(10L), eq("VIGENTE"), any(), any())).thenReturn(page);

        var result = controller.listar(10L, "VIGENTE", null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        verify(contratoMarcoService).listar(eq(10L), eq("VIGENTE"), any(), any());
    }

    @Test
    @DisplayName("listar() página vacia -> retorna ok")
    void listar_paginaVacia_retornaOk() {
        var page = new PageImpl<ContratoMarcoResponse>(Collections.emptyList());
        when(contratoMarcoService.listar(any(), any(), any(), any())).thenReturn(page);

        var result = controller.listar(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    @Test
    @DisplayName("obtener() retorna response")
    void obtener_retornaResponse() {
        when(contratoMarcoService.obtener(1L)).thenReturn(response);

        var result = controller.obtener(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() retorna response con mensaje")
    void crear_retornaResponseConMensaje() {
        when(contratoMarcoService.crear(any(ContratoMarcoRequest.class))).thenReturn(response);

        var result = controller.crear(new ContratoMarcoRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    @DisplayName("actualizar() retorna response con mensaje")
    void actualizar_retornaResponseConMensaje() {
        when(contratoMarcoService.actualizar(eq(1L), any(ContratoMarcoRequest.class))).thenReturn(response);

        var result = controller.actualizar(1L, new ContratoMarcoRequest());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    @DisplayName("suspender() retorna response con mensaje")
    void suspender_retornaResponseConMensaje() {
        when(contratoMarcoService.suspender(eq(1L), any())).thenReturn(response);

        var result = controller.suspender(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("suspendido");
    }

    @Test
    @DisplayName("reabrir() retorna response con mensaje")
    void reabrir_retornaResponseConMensaje() {
        when(contratoMarcoService.reabrir(eq(1L), any())).thenReturn(response);

        var result = controller.reabrir(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("reabierto");
    }

    @Test
    @DisplayName("cerrar() retorna response con mensaje")
    void cerrar_retornaResponseConMensaje() {
        when(contratoMarcoService.cerrar(eq(1L), any())).thenReturn(response);

        var result = controller.cerrar(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("cerrado");
    }

    @Test
    @DisplayName("anular() retorna response con mensaje")
    void anular_retornaResponseConMensaje() {
        when(contratoMarcoService.anular(eq(1L), any())).thenReturn(response);

        var result = controller.anular(1L, null);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("anulado");
    }
}
