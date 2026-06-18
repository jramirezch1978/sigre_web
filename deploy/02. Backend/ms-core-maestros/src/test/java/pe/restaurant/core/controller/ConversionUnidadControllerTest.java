package pe.restaurant.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.entity.ConversionUnidad;
import pe.restaurant.core.mapper.ConversionUnidadMapper;
import pe.restaurant.core.service.ConversionUnidadService;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ConversionUnidadControllerTest {

    @Mock private ConversionUnidadService service;
    @Mock private ConversionUnidadMapper mapper;
    @InjectMocks private ConversionUnidadController controller;

    @Test
    void listDelegates() {
        ConversionUnidad entity = new ConversionUnidad();
        entity.setId(1L);
        Page<ConversionUnidad> page = new PageImpl<>(List.of(entity));
        when(service.list(isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(new ConversionUnidadResponse());
        var result = controller.list(null, null, null, Pageable.unpaged());
        assertEquals(1, result.getData().getContent().size());
        verify(service).list(isNull(), isNull(), isNull(), any(Pageable.class));
    }

    @Test
    void createDelegates() {
        ConversionUnidadRequest request = new ConversionUnidadRequest(null, 1L, 2L, BigDecimal.ONE);
        when(service.create(request)).thenReturn(new ConversionUnidadResponse());
        assertTrue(controller.create(request).isSuccess());
        verify(service).create(request);
    }

    @Test
    void getByIdDelegates() {
        var resp = new ConversionUnidadResponse();
        resp.setId(1L);
        when(service.getById(1L)).thenReturn(resp);
        var result = controller.getById(1L);
        assertTrue(result.isSuccess());
        assertEquals(1L, result.getData().getId());
    }

    @Test
    void updateDelegates() {
        ConversionUnidadRequest request = new ConversionUnidadRequest(null, 1L, 2L, BigDecimal.TEN);
        when(service.update(1L, request)).thenReturn(new ConversionUnidadResponse());
        var result = controller.update(1L, request);
        assertTrue(result.isSuccess());
        verify(service).update(1L, request);
    }

    @Test
    void deleteDelegates() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertTrue(result.isSuccess());
        assertTrue(result.getData());
        verify(service).delete(1L);
    }

    @Test
    void activateDelegates() {
        ConversionUnidad entity = new ConversionUnidad();
        entity.setId(1L);
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ConversionUnidadResponse());
        var result = controller.activate(1L);
        assertTrue(result.isSuccess());
        verify(service).activate(1L);
    }

    @Test
    void deactivateDelegates() {
        ConversionUnidad entity = new ConversionUnidad();
        entity.setId(1L);
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ConversionUnidadResponse());
        var result = controller.deactivate(1L);
        assertTrue(result.isSuccess());
        verify(service).deactivate(1L);
    }
}
