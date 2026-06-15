package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.dto.response.DescuentoPromocionResponse;
import com.sigre.comercializacion.entity.DescuentoPromocion;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.DescuentoPromocionService;

import java.math.BigDecimal;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DescuentoPromocionControllerTest {

    @Mock
    private DescuentoPromocionService service;
    @Mock
    private VentasResponseMapper mapper;
    @InjectMocks
    private DescuentoPromocionController controller;

    @Test
    void list() {
        when(service.findAll(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new DescuentoPromocion())));
        when(mapper.toDescuentoResponse(any())).thenReturn(DescuentoPromocionResponse.builder().id(1L).build());
        assertThat(controller.list(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void getById() {
        when(service.findById(1L)).thenReturn(new DescuentoPromocion());
        when(mapper.toDescuentoResponse(any())).thenReturn(DescuentoPromocionResponse.builder().id(1L).build());
        assertThat(controller.get(1L).isSuccess()).isTrue();
    }

    @Test
    void activar() {
        when(service.activar(2L)).thenReturn(new DescuentoPromocion());
        when(mapper.toDescuentoResponse(any())).thenReturn(DescuentoPromocionResponse.builder().id(2L).flagEstado("1").build());
        assertThat(controller.activar(2L).isSuccess()).isTrue();
    }

    @Test
    void deleteCallsService() {
        assertThat(controller.delete(5L).isSuccess()).isTrue();
        verify(service).delete(5L);
    }

    @Test
    void create() {
        var req = DescuentoPromocionRequest.builder()
                .nombre("2x1")
                .tipo("PCT")
                .valor(BigDecimal.TEN)
                .build();
        when(service.create(any())).thenReturn(new DescuentoPromocion());
        when(mapper.toDescuentoResponse(any())).thenReturn(DescuentoPromocionResponse.builder().id(9L).build());
        assertThat(controller.create(req).isSuccess()).isTrue();
    }
}
