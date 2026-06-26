package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.ArticuloBonificacionRequest;
import pe.restaurant.almacen.dto.ArticuloBonificacionResponse;
import pe.restaurant.almacen.entity.ArticuloBonificacion;
import pe.restaurant.almacen.mapper.ArticuloBonificacionMapper;
import pe.restaurant.almacen.service.ArticuloBonificacionService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloBonificacionControllerTest {

    @Mock
    private ArticuloBonificacionService service;
    @Mock
    private ArticuloBonificacionMapper mapper;
    @InjectMocks
    private ArticuloBonificacionController controller;

    private ArticuloBonificacion entity;
    private ArticuloBonificacionResponse response;
    private ArticuloBonificacionRequest request;

    @BeforeEach
    void setUp() {
        entity = new ArticuloBonificacion();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setCantidadMinima(new BigDecimal("100.0000"));
        entity.setCantidadBonificacion(new BigDecimal("5.0000"));
        entity.setFechaInicio(LocalDate.of(2026, 1, 1));
        entity.setFechaFin(LocalDate.of(2026, 12, 31));
        entity.setFlagEstado("1");

        response = new ArticuloBonificacionResponse();
        response.setId(1L);
        response.setArticuloId(10L);
        response.setCantidadMinima(new BigDecimal("100.0000"));
        response.setCantidadBonificacion(new BigDecimal("5.0000"));
        response.setFlagEstado("1");

        request = new ArticuloBonificacionRequest();
        request.setArticuloId(10L);
        request.setCantidadMinima(new BigDecimal("100.0000"));
        request.setCantidadBonificacion(new BigDecimal("5.0000"));
    }

    @Test
    void findAll_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(eq(10L), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(anyList())).thenReturn(List.of(response));
        var result = controller.findAll(10L, Pageable.unpaged());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_retornaRegistro() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.findById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    void update_retornaActualizado() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(ArticuloBonificacion.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.update(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    void delete_noLanzaExcepcion() {
        controller.delete(1L);
        verify(service).delete(1L);
    }

    @Test
    void activate_retornaActivado() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate_retornaDesactivado() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("desactivado");
    }
}
