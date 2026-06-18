package pe.restaurant.activos.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.dto.AfHistorialRequest;
import pe.restaurant.activos.dto.AfHistorialResponse;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.mapper.AfHistorialMapper;
import pe.restaurant.activos.service.AfHistorialService;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AfHistorialControllerTest {

    @Mock private AfHistorialService service;
    @Mock private AfHistorialMapper mapper;
    @InjectMocks private AfHistorialController controller;

    private AfHistorial entity;
    private AfHistorialResponse response;

    @BeforeEach
    void setUp() {
        entity = new AfHistorial();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setTipoEvento("CREACION");
        entity.setDescripcion("Creación de activo");
        entity.setFechaEvento(LocalDateTime.now());
        entity.setUsuarioId(1L);

        response = new AfHistorialResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setTipoEvento("CREACION");
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
        when(mapper.toEntity(any(AfHistorialRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.crear(new AfHistorialRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void eliminar() {
        doNothing().when(service).delete(1L);
        var result = controller.eliminar(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }

    @Test
    void listarPorActivo() {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorActivo(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void listarPorTipo() {
        when(service.findByTipoEvento("CREACION")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorTipo("CREACION");
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void listarPorUsuario() {
        when(service.findByUsuario(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorUsuario(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void listarPorRangoFechas() {
        LocalDateTime fechaInicio = LocalDateTime.now().minusDays(1);
        LocalDateTime fechaFin = LocalDateTime.now();
        when(service.findByFechaRange(fechaInicio, fechaFin)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.listarPorRangoFechas(fechaInicio, fechaFin);
        assertThat(result.getData()).hasSize(1);
    }
}
