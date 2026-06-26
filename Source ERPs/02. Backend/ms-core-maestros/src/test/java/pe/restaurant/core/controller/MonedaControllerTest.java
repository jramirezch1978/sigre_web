package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import pe.restaurant.core.dto.MonedaRequest;
import pe.restaurant.core.dto.MonedaResponse;
import pe.restaurant.core.entity.Moneda;
import pe.restaurant.core.mapper.MonedaMapper;
import pe.restaurant.core.service.MonedaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MonedaControllerTest {

    @Mock private MonedaService service;
    @Mock private MonedaMapper mapper;
    @InjectMocks private MonedaController controller;

    private Moneda moneda;
    private MonedaResponse response;

    @BeforeEach void setUp() {
        moneda = new Moneda("PEN", "PEN", "Sol", "S/", 2);
        response = new MonedaResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(pageable)).thenReturn(new PageImpl<>(List.of(moneda)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(pageable).isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(moneda);
        when(mapper.toResponse(moneda)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new MonedaRequest();
        when(mapper.toEntity(request)).thenReturn(moneda);
        when(service.create(moneda)).thenReturn(moneda);
        when(mapper.toResponse(moneda)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void update() {
        var request = new MonedaRequest();
        when(service.findById(1L)).thenReturn(moneda);
        when(service.update(eq(1L), any())).thenReturn(moneda);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }
}
