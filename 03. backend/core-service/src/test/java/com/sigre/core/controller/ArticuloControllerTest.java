package com.sigre.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.*;
import com.sigre.core.entity.Articulo;
import com.sigre.core.mapper.ArticuloMapper;
import com.sigre.core.service.ArticuloService;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ArticuloControllerTest {

    @Mock private ArticuloService service;
    @Mock private ArticuloMapper mapper;
    @InjectMocks private ArticuloController controller;

    @Test
    void listDelegates() {
        Articulo entity = new Articulo();
        entity.setId(1L);
        Page<Articulo> page = new PageImpl<>(List.of(entity));
        when(service.list(isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(new ArticuloResponse());
        var result = controller.list(null, null, null, Pageable.unpaged());
        assertEquals(1, result.getData().getContent().size());
        verify(service).list(isNull(), isNull(), isNull(), any(Pageable.class));
    }

    @Test
    void createDelegates() {
        ArticuloRequest request = new ArticuloRequest("A01", "Arroz", "BIEN", null, 1L, null, null, null, null, null, null, "1");
        when(service.create(request)).thenReturn(new ArticuloResponse());
        assertTrue(controller.create(request).isSuccess());
        verify(service).create(request);
    }

    @Test
    void getByIdDelegates() {
        ArticuloDetalleResponse detalle = new ArticuloDetalleResponse();
        detalle.setId(1L);
        when(service.getById(1L)).thenReturn(detalle);
        var result = controller.getById(1L);
        assertTrue(result.isSuccess());
        assertEquals(1L, result.getData().getId());
    }

    @Test
    void updateDelegates() {
        ArticuloRequest request = new ArticuloRequest("A01", "Arroz", "BIEN", null, 1L, null, null, null, null, null, null, "1");
        when(service.update(eq(1L), any())).thenReturn(new ArticuloResponse());
        var result = controller.update(1L, request);
        assertTrue(result.isSuccess());
        verify(service).update(eq(1L), any());
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
        Articulo entity = new Articulo();
        entity.setId(1L);
        entity.setFlagEstado("1");
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ArticuloResponse());
        var result = controller.activate(1L);
        assertTrue(result.isSuccess());
        verify(service).activate(1L);
    }

    @Test
    void deactivateDelegates() {
        Articulo entity = new Articulo();
        entity.setId(1L);
        entity.setFlagEstado("0");
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(new ArticuloResponse());
        var result = controller.deactivate(1L);
        assertTrue(result.isSuccess());
        verify(service).deactivate(1L);
    }

    @Test
    void listProveedoresDelegates() {
        var resp = new ArticuloProveedorResponse(1L, 1L, 10L, "Proveedor S.A.");
        when(service.listProveedores(1L)).thenReturn(List.of(resp));
        var result = controller.listProveedores(1L);
        assertTrue(result.isSuccess());
        assertEquals(1, result.getData().size());
    }

    @Test
    void createProveedorDelegates() {
        var request = new ArticuloProveedorRequest(10L, 1L);
        var resp = new ArticuloProveedorResponse(1L, 1L, 10L, "Proveedor S.A.");
        when(service.createProveedor(1L, request)).thenReturn(resp);
        var result = controller.createProveedor(1L, request);
        assertTrue(result.isSuccess());
        assertEquals(10L, result.getData().getProveedorId());
    }

    @Test
    void listAlmacenesConfigDelegates() {
        var resp = new ArticuloAlmacenConfigResponse(1L, 1L, 5L, java.math.BigDecimal.ONE, java.math.BigDecimal.TEN);
        when(service.listAlmacenesConfig(1L)).thenReturn(List.of(resp));
        var result = controller.listAlmacenesConfig(1L);
        assertTrue(result.isSuccess());
        assertEquals(1, result.getData().size());
    }

    @Test
    void upsertAlmacenConfigDelegates() {
        var request = new ArticuloAlmacenConfigRequest(5L, java.math.BigDecimal.ONE, java.math.BigDecimal.TEN);
        var resp = new ArticuloAlmacenConfigResponse(1L, 1L, 5L, java.math.BigDecimal.ONE, java.math.BigDecimal.TEN);
        when(service.upsertAlmacenConfig(1L, request)).thenReturn(resp);
        var result = controller.upsertAlmacenConfig(1L, request);
        assertTrue(result.isSuccess());
        assertEquals(5L, result.getData().getAlmacenId());
    }
}
