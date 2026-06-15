package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.core.dto.TipoCambioRequest;
import com.sigre.core.dto.TipoCambioResponse;
import com.sigre.core.entity.TipoCambio;
import com.sigre.core.mapper.TipoCambioMapper;
import com.sigre.core.service.TipoCambioService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TipoCambioControllerTest {

    @Mock private TipoCambioService service;
    @Mock private TipoCambioMapper mapper;
    @InjectMocks private TipoCambioController controller;

    private TipoCambio entity;
    private TipoCambioResponse response;

    @BeforeEach void setUp() {
        entity = new TipoCambio();
        entity.setId(1L);
        entity.setMonedaId(1L);
        entity.setFecha(LocalDate.now());
        entity.setCompra(BigDecimal.ONE);
        entity.setVenta(BigDecimal.ONE);

        response = new TipoCambioResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(any(), any(), any(), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(null, null, null, pageable).isSuccess()).isTrue();
    }

    @Test void findByFecha() {
        when(service.findByFecha(any(), eq(1L))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findByFecha(LocalDate.now(), 1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new TipoCambioRequest();
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.findById(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test void update() {
        var request = new TipoCambioRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(TipoCambio.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.update(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
    }

    @Test void delete_retornaOk() {
        var result = controller.delete(1L);
        assertThat(result.isSuccess()).isTrue();
        verify(service).delete(1L);
    }

    @Test void activate_retornaActivado() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("activado");
    }

    @Test void deactivate_retornaDesactivado() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("desactivado");
    }
}
