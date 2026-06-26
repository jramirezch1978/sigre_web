package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.ArticuloEquivalenciaRequest;
import pe.restaurant.core.dto.ArticuloEquivalenciaResponse;
import pe.restaurant.core.entity.ArticuloEquivalencia;
import pe.restaurant.core.mapper.ArticuloEquivalenciaMapper;
import pe.restaurant.core.service.ArticuloEquivalenciaService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloEquivalenciaControllerTest {

    @Mock private ArticuloEquivalenciaService service;
    @Mock private ArticuloEquivalenciaMapper mapper;
    @InjectMocks private ArticuloEquivalenciaController controller;

    private ArticuloEquivalencia entity;
    private ArticuloEquivalenciaResponse response;
    private ArticuloEquivalenciaRequest request;

    @BeforeEach
    void setUp() {
        entity = new ArticuloEquivalencia();
        entity.setId(1L);
        entity.setArticuloId(10L);
        entity.setArticuloEquivalenteId(20L);
        entity.setFactor(new BigDecimal("1.5"));
        entity.setFlagEstado("1");

        response = new ArticuloEquivalenciaResponse();
        response.setId(1L);
        response.setArticuloId(10L);
        response.setArticuloEquivalenteId(20L);
        response.setFactor(new BigDecimal("1.5"));
        response.setFlagEstado("1");

        request = new ArticuloEquivalenciaRequest();
        request.setArticuloId(10L);
        request.setArticuloEquivalenteId(20L);
        request.setFactor(new BigDecimal("1.5"));
    }

    @Test
    void findAll_retornaPagina() {
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
        assertThat(result.getMessage()).contains("creada");
    }

    @Test
    void update_retornaActualizado() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(ArticuloEquivalencia.class))).thenReturn(entity);
        when(mapper.toResponse(any(ArticuloEquivalencia.class))).thenReturn(response);
        var result = controller.update(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
    }

    @Test
    void delete_retornaTrue() {
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
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
