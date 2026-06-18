package pe.restaurant.ventas.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.PropinaRequest;
import pe.restaurant.ventas.dto.response.PropinaResponse;
import pe.restaurant.ventas.entity.Propina;
import pe.restaurant.ventas.mapper.VentasIssue5DtoMapper;
import pe.restaurant.ventas.service.PropinaService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class PropinaControllerTest {

    @Mock
    private PropinaService service;
    @Mock
    private VentasIssue5DtoMapper mapper;
    @InjectMocks
    private PropinaController controller;

    @Test
    void list() {
        Propina entity = new Propina();
        entity.setId(1L);
        when(service.findAll(any(), any(), any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toPropinaResponse(entity)).thenReturn(PropinaResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null, null, null).isSuccess()).isTrue();
    }

    @Test
    void get() {
        Propina entity = new Propina();
        entity.setId(2L);
        when(service.findById(2L)).thenReturn(entity);
        when(mapper.toPropinaResponse(entity)).thenReturn(PropinaResponse.builder().id(2L).build());
        assertThat(controller.get(2L).getData().getId()).isEqualTo(2L);
    }

    @Test
    void create_update_activar_desactivar() {
        PropinaRequest req = new PropinaRequest();
        Propina entity = new Propina();
        entity.setId(3L);
        PropinaResponse resp = PropinaResponse.builder().id(3L).build();

        when(service.create(req)).thenReturn(entity);
        when(mapper.toPropinaResponse(entity)).thenReturn(resp);
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.update(eq(3L), eq(req))).thenReturn(entity);
        assertThat(controller.update(3L, req).isSuccess()).isTrue();

        when(service.activar(3L)).thenReturn(entity);
        assertThat(controller.activar(3L).isSuccess()).isTrue();

        when(service.desactivar(3L)).thenReturn(entity);
        assertThat(controller.desactivar(3L).isSuccess()).isTrue();

    }

    @Test
    void create() {
        PropinaRequest request = new PropinaRequest();
        request.setFsFacturaSimplId(1L);
        request.setTrabajadorId(1L);
        request.setMonto(new BigDecimal("10.00"));
        request.setFecha(LocalDate.now());
        
        when(service.create(any())).thenReturn(new Propina());
        when(mapper.toPropinaResponse(any())).thenReturn(PropinaResponse.builder().id(1L).build());
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test
    void update() {
        PropinaRequest request = new PropinaRequest();
        request.setFsFacturaSimplId(1L);
        request.setTrabajadorId(1L);
        request.setMonto(new BigDecimal("15.00"));
        request.setFecha(LocalDate.now());
        
        when(service.update(anyLong(), any())).thenReturn(new Propina());
        when(mapper.toPropinaResponse(any())).thenReturn(PropinaResponse.builder().id(1L).build());
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }

    @Test
    void activar() {
        when(service.activar(anyLong())).thenReturn(new Propina());
        when(mapper.toPropinaResponse(any())).thenReturn(PropinaResponse.builder().id(1L).build());
        assertThat(controller.activar(1L).isSuccess()).isTrue();
    }

    @Test
    void desactivar() {
        when(service.desactivar(anyLong())).thenReturn(new Propina());
        when(mapper.toPropinaResponse(any())).thenReturn(PropinaResponse.builder().id(1L).build());
        assertThat(controller.desactivar(1L).isSuccess()).isTrue();
    }
}
