package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfTrasladoRequest;
import pe.restaurant.activos.dto.AfTrasladoResponse;
import pe.restaurant.activos.entity.AfTraslado;
import pe.restaurant.activos.mapper.AfTrasladoMapper;
import pe.restaurant.activos.service.AfTrasladoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfTrasladoControllerTest {

    @Mock private AfTrasladoService service;
    @Mock private AfTrasladoMapper mapper;
    @InjectMocks private AfTrasladoController controller;

    private AfTraslado entity;
    private AfTrasladoResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfTraslado();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setUbicacionOrigenId(1L);
        entity.setUbicacionDestinoId(2L);
        entity.setMotivo("Traslado de oficina");

        response = new AfTrasladoResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
    }

    @Test
    void listar() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listar(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void obtenerPorId() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.obtenerPorId(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void crear() {
        when(mapper.toEntity(any(AfTrasladoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfTrasladoRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void actualizar() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.actualizar(1L, new AfTrasladoRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    void eliminar() {
        doNothing().when(service).delete(1L);
        var result = controller.eliminar(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }

    @Test
    void ejecutar() {
        when(service.ejecutar(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.ejecutar(1L);
        assertThat(result.getMessage()).contains("ejecutado");
    }

}
