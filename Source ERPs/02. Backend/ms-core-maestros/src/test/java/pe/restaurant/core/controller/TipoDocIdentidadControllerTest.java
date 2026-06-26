package pe.restaurant.core.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.TipoDocIdentidadRequest;
import pe.restaurant.core.dto.TipoDocIdentidadResponse;
import pe.restaurant.core.entity.TipoDocIdentidad;
import pe.restaurant.core.mapper.TipoDocIdentidadMapper;
import pe.restaurant.core.service.TipoDocIdentidadService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class TipoDocIdentidadControllerTest {

    @Mock private TipoDocIdentidadService service;
    @Mock private TipoDocIdentidadMapper mapper;
    @InjectMocks private TipoDocIdentidadController controller;

    private TipoDocIdentidad entity;
    private TipoDocIdentidadResponse response;

    @BeforeEach void setUp() {
        entity = new TipoDocIdentidad();
        entity.setId(1L);
        entity.setCodigo("DNI");
        entity.setNombre("Documento Nacional de Identidad");
        entity.setFlagEstado("1");
        response = new TipoDocIdentidadResponse();
        response.setId(1L);
        response.setCodigo("DNI");
        response.setNombre("Documento Nacional de Identidad");
        response.setFlagEstado("1");
    }

    private TipoDocIdentidadRequest buildRequest(String codigo, String nombre, String flagEstado) {
        TipoDocIdentidadRequest request = new TipoDocIdentidadRequest();
        request.setCodigo(codigo);
        request.setNombre(nombre);
        request.setFlagEstado(flagEstado);
        return request;
    }

    @Test void findAllNoFilter() {
        when(service.findAll(null)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll(null).getData()).hasSize(1);
        verify(service).findAll(null);
    }

    @Test void findAllFilterByActivo() {
        when(service.findAll("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));
        assertThat(controller.findAll("1").getData()).hasSize(1);
        verify(service).findAll("1");
    }

    @Test void findByIdDelegates() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.findById(1L);
        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(service).findById(1L);
    }

    @Test void findByIdNotFound() {
        when(service.findById(99L)).thenThrow(new ResourceNotFoundException("TipoDocIdentidad", 99L));
        assertThatThrownBy(() -> controller.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test void createDelegates() {
        var request = buildRequest("RUC", "RUC", "1");
        when(mapper.toEntity(request)).thenReturn(entity);
        when(service.create(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.create(request);
        assertThat(result.isSuccess()).isTrue();
        verify(service).create(entity);
    }

    @Test void updateDelegates() {
        var request = buildRequest("DNI", "DNI actualizado", "1");
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);
        var result = controller.update(1L, request);
        assertThat(result.isSuccess()).isTrue();
        verify(mapper).updateEntity(request, entity);
    }

    @Test void deleteDelegates() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
        verify(service).delete(1L);
    }

    @Test void activateDelegates() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.isSuccess()).isTrue();
        verify(service).activate(1L);
    }

    @Test void deactivateDelegates() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.isSuccess()).isTrue();
        verify(service).deactivate(1L);
    }
}
