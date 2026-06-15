package com.sigre.comercializacion.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.CartaRequest;
import com.sigre.comercializacion.dto.response.CartaResponse;
import com.sigre.comercializacion.entity.Carta;
import com.sigre.comercializacion.entity.CartaDet;
import com.sigre.comercializacion.mapper.CartaMapper;
import com.sigre.comercializacion.service.CartaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CartaControllerTest {

    @Mock
    private CartaService service;
    @Mock
    private CartaMapper mapper;
    @InjectMocks
    private CartaController controller;

    @Test
    void findAll() {
        when(service.findAllWithFilters(any(), any(), any(), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(new Carta())));
        when(mapper.toResponseList(any())).thenReturn(List.of(new CartaResponse()));
        assertThat(controller.findAll(Pageable.unpaged(), null, null, null).isSuccess()).isTrue();
    }

    @Test
    void findById() {
        Carta carta = new Carta();
        carta.setId(1L);
        when(service.findById(1L)).thenReturn(carta);
        CartaResponse resp = new CartaResponse();
        when(mapper.toResponse(carta)).thenReturn(resp);
        when(service.findItemsByCartaId(1L)).thenReturn(List.of(new CartaDet()));
        when(mapper.toDetResponseList(any())).thenReturn(List.of());
        assertThat(controller.findById(1L).isSuccess()).isTrue();
    }

    @Test
    void findBySucursal_and_lifecycle() {
        when(service.findBySucursalId(1L)).thenReturn(List.of(new Carta()));
        when(mapper.toResponseList(any())).thenReturn(List.of(new CartaResponse()));
        assertThat(controller.findBySucursalId(1L).isSuccess()).isTrue();

        CartaRequest req = new CartaRequest();
        Carta entity = new Carta();
        entity.setId(2L);
        when(mapper.toEntity(req)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new CartaResponse());
        assertThat(controller.create(req).isSuccess()).isTrue();

        when(service.update(eq(2L), any())).thenReturn(entity);
        assertThat(controller.update(2L, req).isSuccess()).isTrue();

        assertThat(controller.delete(2L).isSuccess()).isTrue();
        verify(service).delete(2L);
    }
}
