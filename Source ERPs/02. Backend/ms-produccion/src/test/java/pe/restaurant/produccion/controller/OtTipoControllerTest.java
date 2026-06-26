package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.OtTipoRequest;
import pe.restaurant.produccion.dto.response.OtTipoResponse;
import pe.restaurant.produccion.entity.OtTipo;
import pe.restaurant.produccion.mapper.OtTipoMapper;
import pe.restaurant.produccion.service.OtTipoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OtTipoControllerTest {

    @Mock private OtTipoService service;
    @Mock private OtTipoMapper mapper;
    @InjectMocks private OtTipoController controller;

    private OtTipo entity;
    private OtTipoResponse response;

    @BeforeEach
    void setUp() {
        entity = new OtTipo();
        entity.setId(1L);
        entity.setCodigo("PRODUCCION");
        entity.setNombre("OT de produccion");
        entity.setFlagEstado("1");

        response = OtTipoResponse.builder()
                .id(1L)
                .codigo("PRODUCCION")
                .nombre("OT de produccion")
                .flagEstado("1")
                .build();
    }

    @Test
    void findAll_retornaPageDataConContenidoMapeado() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findAll(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getPage().getTotalElements()).isEqualTo(1);
    }

    @Test
    void findAll_propagaFiltrosAlService() {
        var page = new PageImpl<OtTipo>(List.of());
        when(service.findAll(eq("PROD"), eq("nombre"), eq("1"), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of());

        controller.findAll("PROD", "nombre", "1", Pageable.unpaged());

        verify(service).findAll(eq("PROD"), eq("nombre"), eq("1"), any(Pageable.class));
    }

    @Test
    void findById_retornaResponseMapeado() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.findById(1L);
        assertThat(result.getData().getId()).isEqualTo(1L);
        assertThat(result.getData().getCodigo()).isEqualTo("PRODUCCION");
    }

    @Test
    void create_delegaServiceYRetornaCreatedConMensaje() {
        var req = new OtTipoRequest("PRODUCCION", "OT de produccion");
        when(mapper.toEntity(any(OtTipoRequest.class))).thenReturn(entity);
        when(service.create(any(OtTipo.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.create(req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
        verify(service).create(any(OtTipo.class));
    }

    @Test
    void update_aplicaCambiosViaMapperYService() {
        var req = new OtTipoRequest("PROD", "Nuevo nombre");
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(OtTipo.class))).thenReturn(entity);
        when(mapper.toResponse(any(OtTipo.class))).thenReturn(response);

        var result = controller.update(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
        verify(mapper).updateEntity(eq(req), eq(entity));
        verify(service).update(eq(1L), eq(entity));
    }

    @Test
    void activate_invocaServiceConMensaje() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate_invocaServiceConMensaje() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);

        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
        verify(service).delete(1L);
    }
}
