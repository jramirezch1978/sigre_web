package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.core.dto.NumeradorRequest;
import com.sigre.core.dto.NumeradorResponse;
import com.sigre.core.dto.SiguienteNumeradorRequest;
import com.sigre.core.entity.Numerador;
import com.sigre.core.mapper.NumeradorMapper;
import com.sigre.core.service.NumeradorService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class NumeradorControllerTest {

    @Mock private NumeradorService service;
    @Mock private NumeradorMapper mapper;
    @InjectMocks private NumeradorController controller;

    private Numerador entity;
    private NumeradorResponse response;

    @BeforeEach void setUp() {
        entity = new Numerador("FACTURA", "Factura", "F001", 100L, 8);
        response = new NumeradorResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(pageable)).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(pageable).isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new NumeradorRequest();
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void update() {
        var request = new NumeradorRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }

    @Test void siguiente() {
        var request = new SiguienteNumeradorRequest();
        request.setCodigoNumerador("FACTURA");
        when(service.siguiente("FACTURA")).thenReturn(101L);
        var result = controller.siguiente(request);
        assertThat(result.getData().getSiguiente()).isEqualTo(101L);
    }
}
