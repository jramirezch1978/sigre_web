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
import pe.restaurant.compras.dto.ServicioCatalogoRequest;
import pe.restaurant.compras.dto.ServicioCatalogoResponse;
import pe.restaurant.compras.entity.ServicioCatalogo;
import pe.restaurant.compras.mapper.ServicioCatalogoMapper;
import pe.restaurant.compras.service.ServicioCatalogoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ServicioCatalogoController — Pruebas Unitarias")
class ServicioCatalogoControllerTest {

    @Mock private ServicioCatalogoService service;
    @Mock private ServicioCatalogoMapper mapper;
    @InjectMocks private ServicioCatalogoController controller;

    private ServicioCatalogo entity;
    private ServicioCatalogoResponse response;

    @BeforeEach
    void setUp() {
        entity = new ServicioCatalogo();
        entity.setId(1L);
        entity.setServicio("SRV01");
        entity.setDescripcion("Servicio 1");
        entity.setFlagEstado("1");

        response = new ServicioCatalogoResponse();
        response.setId(1L);
        response.setServicio("SRV01");
    }

    @Test
    @DisplayName("findAll() validación general")
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findById() validación general")
    void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("create() validación general")
    void create() {
        when(mapper.toEntity(any(ServicioCatalogoRequest.class))).thenReturn(entity);
        when(service.create(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(new ServicioCatalogoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("update() validación general")
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new ServicioCatalogoRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    @DisplayName("activate() validación general")
    void activate() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    @DisplayName("deactivate() validación general")
    void deactivate() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    @DisplayName("delete() validación general")
    void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }
}
