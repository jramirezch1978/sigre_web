package com.sigre.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.request.ProcesarCosteoRequest;
import com.sigre.produccion.dto.response.CosteoProduccionResponse;
import com.sigre.produccion.dto.response.ProcesarCosteoResponse;
import com.sigre.produccion.entity.CosteoProduccion;
import com.sigre.produccion.mapper.CosteoProduccionMapper;
import com.sigre.produccion.service.CosteoProduccionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CosteoProduccionControllerTest {

    @Mock private CosteoProduccionService service;
    @Mock private CosteoProduccionMapper mapper;
    @InjectMocks private CosteoProduccionController controller;

    private CosteoProduccion entity;
    private CosteoProduccionResponse response;

    @BeforeEach
    void setUp() {
        entity = new CosteoProduccion();
        entity.setId(1L);

        response = CosteoProduccionResponse.builder().id(1L).build();
    }

    @Test
    void findAll_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findAll(null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void procesar_retornaProcesarCosteoResponse() {
        var request = new ProcesarCosteoRequest(2025, 5, null, null);
        var procesarResponse = ProcesarCosteoResponse.builder().totalOtsProcesadas(3).build();
        when(service.procesar(2025, 5, null, null)).thenReturn(procesarResponse);

        var result = controller.procesar(request);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getTotalOtsProcesadas()).isEqualTo(3);
    }

    @Test
    void findByPeriodo_retornaLista() {
        when(service.findByPeriodo(2025, 5)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findByPeriodo(2025, 5);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }
}
