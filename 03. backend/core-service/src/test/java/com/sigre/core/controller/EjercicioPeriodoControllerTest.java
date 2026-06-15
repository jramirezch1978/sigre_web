package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.core.dto.EjercicioPeriodoRequest;
import com.sigre.core.dto.EjercicioPeriodoResponse;
import com.sigre.core.entity.EjercicioPeriodo;
import com.sigre.core.mapper.EjercicioPeriodoMapper;
import com.sigre.core.service.EjercicioPeriodoService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class EjercicioPeriodoControllerTest {

    @Mock private EjercicioPeriodoService service;
    @Mock private EjercicioPeriodoMapper mapper;
    @InjectMocks private EjercicioPeriodoController controller;

    private EjercicioPeriodo entity;
    private EjercicioPeriodoResponse response;

    @BeforeEach void setUp() {
        entity = new EjercicioPeriodo();
        entity.setId(1L);
        response = new EjercicioPeriodoResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(null, pageable)).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(null, pageable).isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new EjercicioPeriodoRequest();
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void update() {
        var request = new EjercicioPeriodoRequest();
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }

    @Test void deactivate() {
        controller.deactivate(1L);
        verify(service).deactivate(1L);
    }
}
