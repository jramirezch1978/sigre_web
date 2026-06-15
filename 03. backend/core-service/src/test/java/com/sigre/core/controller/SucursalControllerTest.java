package com.sigre.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.core.dto.SucursalRequest;
import com.sigre.core.dto.SucursalResponse;
import com.sigre.core.entity.Sucursal;
import com.sigre.core.mapper.SucursalMapper;
import com.sigre.core.service.SucursalService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SucursalControllerTest {

    @Mock private SucursalService service;
    @Mock private SucursalMapper mapper;
    @InjectMocks private SucursalController controller;

    private Sucursal sucursal;
    private SucursalResponse response;

    @BeforeEach
    void setUp() {
        sucursal = new Sucursal();
        sucursal.setId(1L);
        response = new SucursalResponse();
        response.setId(1L);
    }

    @Test void findAll() {
        var pageable = PageRequest.of(0, 20);
        when(service.findAll(pageable)).thenReturn(new PageImpl<>(List.of(sucursal)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        var result = controller.findAll(pageable);
        assertThat(result.isSuccess()).isTrue();
    }

    @Test void findById() {
        when(service.findById(1L)).thenReturn(sucursal);
        when(mapper.toResponse(sucursal)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test void create() {
        var request = new SucursalRequest();
        when(mapper.toEntity(request)).thenReturn(sucursal);
        when(service.create(sucursal)).thenReturn(sucursal);
        when(mapper.toResponse(sucursal)).thenReturn(response);
        assertThat(controller.create(request).isSuccess()).isTrue();
    }

    @Test void update() {
        var request = new SucursalRequest();
        when(service.findById(1L)).thenReturn(sucursal);
        when(service.update(eq(1L), any())).thenReturn(sucursal);
        when(mapper.toResponse(any())).thenReturn(response);
        assertThat(controller.update(1L, request).isSuccess()).isTrue();
    }
}
