package pe.restaurant.rrhh.controller;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.GanDescFijoEstadoRequest;
import pe.restaurant.rrhh.dto.request.GanDescFijoRequest;
import pe.restaurant.rrhh.dto.response.GanDescFijoResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.entity.GanDescFijo;
import pe.restaurant.rrhh.mapper.GanDescFijoMapper;
import pe.restaurant.rrhh.service.GanDescFijoService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GanDescFijoController — Pruebas Unitarias")
class GanDescFijoControllerTest {

    @Mock
    private GanDescFijoService service;

    @Mock
    private GanDescFijoMapper mapper;

    @InjectMocks
    private GanDescFijoController controller;

    @Test
    @DisplayName("cambiarEstado() con flagEstado=1 -> mensaje activado")
    void cambiarEstado_flagEstado1_retornaMensajeActivado() {
        GanDescFijoEstadoRequest request = new GanDescFijoEstadoRequest();
        request.setFlagEstado("1");
        GanDescFijo entity = new GanDescFijo();
        GanDescFijoResponse response = new GanDescFijoResponse();

        when(service.cambiarEstado(1L, request)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ResponseEntity<ApiResponse<GanDescFijoResponse>> result = controller.cambiarEstado(1L, request);

        assertThat(result.getBody()).isNotNull();
        assertThat(result.getBody().getMessage()).contains("activado");
    }

    @Test
    @DisplayName("cambiarEstado() con flagEstado=0 -> mensaje inactivado")
    void cambiarEstado_flagEstado0_retornaMensajeInactivado() {
        GanDescFijoEstadoRequest request = new GanDescFijoEstadoRequest();
        request.setFlagEstado("0");
        GanDescFijo entity = new GanDescFijo();
        GanDescFijoResponse response = new GanDescFijoResponse();

        when(service.cambiarEstado(1L, request)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ResponseEntity<ApiResponse<GanDescFijoResponse>> result = controller.cambiarEstado(1L, request);

        assertThat(result.getBody()).isNotNull();
        assertThat(result.getBody().getMessage()).contains("inactivado");
    }

    @Test
    @DisplayName("listar() retorna página de responses")
    void listar_retornaPaginaDeResponses() {
        PageRequest pageable = PageRequest.of(0, 10);
        GanDescFijo entity = new GanDescFijo();
        Page<GanDescFijo> page = new PageImpl<>(List.of(entity));
        GanDescFijoResponse response = GanDescFijoResponse.builder().id(1L).build();

        when(service.listar(null, null, null, pageable)).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(response);

        ResponseEntity<ApiResponse<PageData<GanDescFijoResponse>>> result = controller.listar(pageable, null, null, null);

        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(result.getBody()).isNotNull();
        assertThat(result.getBody().getData().getContent()).hasSize(1);
        assertThat(result.getBody().getData().getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtener() retorna response")
    void obtener_retornaResponse() {
        GanDescFijo entity = new GanDescFijo();
        GanDescFijoResponse response = GanDescFijoResponse.builder().id(1L).impGanDesc(new BigDecimal("500")).build();

        when(service.obtenerPorId(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ResponseEntity<ApiResponse<GanDescFijoResponse>> result = controller.obtener(1L);

        assertThat(result.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(result.getBody()).isNotNull();
        assertThat(result.getBody().getData().getImpGanDesc()).isEqualByComparingTo(new BigDecimal("500"));
    }
}
