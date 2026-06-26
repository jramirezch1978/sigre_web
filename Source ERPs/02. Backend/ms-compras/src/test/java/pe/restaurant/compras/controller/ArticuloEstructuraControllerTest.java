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
import pe.restaurant.compras.dto.ArticuloEstructuraRequest;
import pe.restaurant.compras.dto.ArticuloEstructuraResponse;
import pe.restaurant.compras.entity.ArticuloEstructura;
import pe.restaurant.compras.entity.ArticuloEstructuraId;
import pe.restaurant.compras.mapper.ArticuloEstructuraMapper;
import pe.restaurant.compras.service.ArticuloEstructuraService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ArticuloEstructuraController — Pruebas Unitarias")
class ArticuloEstructuraControllerTest {

    @Mock private ArticuloEstructuraService service;
    @Mock private ArticuloEstructuraMapper mapper;
    @InjectMocks private ArticuloEstructuraController controller;

    private ArticuloEstructura entity;
    private ArticuloEstructuraResponse response;

    @BeforeEach
    void setUp() {
        entity = new ArticuloEstructura();
        entity.setArticuloPadreId(1L);
        entity.setArticuloHijoId(2L);
        entity.setCantidad(BigDecimal.TEN);

        response = new ArticuloEstructuraResponse();
        response.setArticuloPadreId(1L);
        response.setArticuloHijoId(2L);
    }

    @Test
    @DisplayName("findAll() retorna página")
    void findAll_retornaPagina() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(anyLong(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(1L, Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findById() retorna response")
    void findById_retornaResponse() {
        var id = new ArticuloEstructuraId(1L, 2L);
        when(service.findById(id)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L, 2L).getData().getArticuloPadreId())
                .isEqualTo(1L);
    }

    @Test
    @DisplayName("create() retorna response")
    void create_retornaResponse() {
        when(mapper.toEntity(any(ArticuloEstructuraRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ArticuloEstructuraRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creado");
    }

    @Test
    @DisplayName("update() retorna response")
    void update_retornaResponse() {
        var id = new ArticuloEstructuraId(1L, 2L);
        when(service.findById(id)).thenReturn(entity);
        when(service.update(eq(id), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, 2L, new ArticuloEstructuraRequest());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test
    @DisplayName("delete() retorna true")
    void delete_retornaTrue() {
        var id = new ArticuloEstructuraId(1L, 2L);
        doNothing().when(service).delete(id);
        var result = controller.delete(1L, 2L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminado");
    }
}
