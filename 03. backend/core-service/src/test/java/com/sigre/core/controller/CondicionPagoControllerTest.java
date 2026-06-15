package com.sigre.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.CondicionPagoRequest;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.entity.CondicionPago;
import com.sigre.core.mapper.CondicionPagoMapper;
import com.sigre.core.service.CondicionPagoService;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CondicionPagoControllerTest {

    @Mock private CondicionPagoService service;
    @Mock private CondicionPagoMapper mapper;
    @InjectMocks private CondicionPagoController controller;

    @Test
    void listDelegatesToService() {
        CondicionPago entity = new CondicionPago("CONTADO", "Contado", 0);
        Page<CondicionPago> page = new PageImpl<>(List.of(entity));
        when(service.list(any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(new CondicionPagoResponse(1L, "CONTADO", "Contado", 0, "1"));
        var response = controller.list(Pageable.unpaged());
        assertEquals(1, response.getData().getContent().size());
        verify(service).list(any(Pageable.class));
    }

    @Test
    void createDelegatesToService() {
        CondicionPagoRequest request = new CondicionPagoRequest("CONT", "Contado", 0, "1");
        when(service.create(request)).thenReturn(new CondicionPagoResponse());
        var response = controller.create(request);
        assertEquals(true, response.isSuccess());
        verify(service).create(request);
    }

    @Test
    void getByIdDelegatesToService() {
        var resp = new CondicionPagoResponse(1L, "CONTADO", "Contado", 0, "1");
        when(service.getById(1L)).thenReturn(resp);
        var result = controller.getById(1L);
        assertTrue(result.isSuccess());
        assertEquals("CONTADO", result.getData().getCodigo());
    }

    @Test
    void updateDelegatesToService() {
        CondicionPagoRequest request = new CondicionPagoRequest("CONT", "Contado Mod", 0, "1");
        when(service.update(1L, request)).thenReturn(new CondicionPagoResponse());
        var result = controller.update(1L, request);
        assertTrue(result.isSuccess());
        verify(service).update(1L, request);
    }

    @Test
    void deleteDelegatesToService() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertTrue(result.isSuccess());
        assertTrue(result.getData());
        verify(service).delete(1L);
    }

    @Test
    void activateDelegatesToService() {
        CondicionPago entity = new CondicionPago("CONTADO", "Contado", 0);
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new CondicionPagoResponse(1L, "CONTADO", "Contado", 0, "1"));
        var result = controller.activate(1L);
        assertTrue(result.isSuccess());
        verify(service).activate(1L);
    }

    @Test
    void deactivateDelegatesToService() {
        CondicionPago entity = new CondicionPago("CONTADO", "Contado", 0);
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new CondicionPagoResponse(1L, "CONTADO", "Contado", 0, "0"));
        var result = controller.deactivate(1L);
        assertTrue(result.isSuccess());
        verify(service).deactivate(1L);
    }
}
