package com.sigre.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.almacen.dto.UbicacionAlmacenRequest;
import com.sigre.almacen.dto.UbicacionAlmacenResponse;
import com.sigre.almacen.entity.UbicacionAlmacen;
import com.sigre.almacen.mapper.UbicacionAlmacenMapper;
import com.sigre.almacen.service.UbicacionAlmacenService;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UbicacionAlmacenControllerTest {

    @Mock private UbicacionAlmacenService service;
    @Mock private UbicacionAlmacenMapper mapper;
    @InjectMocks private UbicacionAlmacenController controller;

    private UbicacionAlmacen entity;
    private UbicacionAlmacenResponse response;

    @BeforeEach
    void setUp() {
        entity = new UbicacionAlmacen();
        entity.setId(1L);
        entity.setAlmacenId(10L);
        entity.setCodigo("UB01");
        entity.setNombre("Ubicacion 1");

        response = new UbicacionAlmacenResponse();
        response.setId(1L);
        response.setCodigo("UB01");
    }

    @Test
    void update() {
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, new UbicacionAlmacenRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void delete() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }
}
