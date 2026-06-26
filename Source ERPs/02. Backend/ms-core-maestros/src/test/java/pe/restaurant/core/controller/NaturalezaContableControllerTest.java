package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.core.dto.NaturalezaContableRequest;
import pe.restaurant.core.dto.NaturalezaContableResponse;
import pe.restaurant.core.entity.NaturalezaContable;
import pe.restaurant.core.mapper.NaturalezaContableMapper;
import pe.restaurant.core.service.NaturalezaContableService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class NaturalezaContableControllerTest {

    @Mock private NaturalezaContableService service;
    @Mock private NaturalezaContableMapper mapper;
    @InjectMocks private NaturalezaContableController controller;

    private NaturalezaContable entity;
    private NaturalezaContableResponse response;

    @BeforeEach void setUp() {
        entity = new NaturalezaContable();
        entity.setId(1L);
        response = new NaturalezaContableResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var p = PageRequest.of(0, 20);
        when(service.findAll(p)).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(p).isSuccess()).isTrue();
    }
    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }
    @Test void create() {
        var req = new NaturalezaContableRequest();
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(req).isSuccess()).isTrue();
    }
    @Test void update() {
        var req = new NaturalezaContableRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, req).isSuccess()).isTrue();
    }
    @Test void deactivate() {
        controller.deactivate(1L);
        verify(service).deactivate(1L);
    }
}
