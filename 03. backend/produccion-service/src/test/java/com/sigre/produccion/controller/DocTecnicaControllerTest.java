package com.sigre.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.request.CaractDetRequest;
import com.sigre.produccion.dto.request.DocTecnicaRequest;
import com.sigre.produccion.dto.response.CaractDetResponse;
import com.sigre.produccion.dto.response.DocTecnicaResponse;
import com.sigre.produccion.entity.ArticuloDocTecnica;
import com.sigre.produccion.entity.ArticuloDocTecnicaCaractDet;
import com.sigre.produccion.mapper.ArticuloDocTecnicaMapper;
import com.sigre.produccion.mapper.CaractDetMapper;
import com.sigre.produccion.service.ArticuloDocTecnicaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class DocTecnicaControllerTest {

    @Mock private ArticuloDocTecnicaService service;
    @Mock private ArticuloDocTecnicaMapper mapper;
    @Mock private CaractDetMapper caractDetMapper;
    @InjectMocks private DocTecnicaController controller;

    private ArticuloDocTecnica entity;
    private DocTecnicaResponse response;
    private DocTecnicaRequest request;

    @BeforeEach
    void setUp() {
        entity = new ArticuloDocTecnica();
        entity.setId(1L);

        response = DocTecnicaResponse.builder().id(1L).build();

        request = new DocTecnicaRequest();
    }

    @Test
    void findAll_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findAll(null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
    }

    @Test
    void findById_retornaResponseConCaracteristicas() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(service).enrichCaractDetResponses(any());
    }

    @Test
    void create_retornaCreado() {
        when(mapper.toEntity(any(DocTecnicaRequest.class))).thenReturn(entity);
        when(service.create(any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any(), any());
    }

    @Test
    void create_conCaracteristicas_mapeaSubRecursos() {
        request.setCaracteristicas(List.of(new CaractDetRequest()));
        when(caractDetMapper.toEntity(any(CaractDetRequest.class))).thenReturn(new ArticuloDocTecnicaCaractDet());
        when(mapper.toEntity(any(DocTecnicaRequest.class))).thenReturn(entity);
        when(service.create(any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        controller.create(request);

        verify(caractDetMapper).toEntity(any(CaractDetRequest.class));
    }

    @Test
    void update_retornaActualizado() {
        when(mapper.toEntity(any(DocTecnicaRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any(), any());
    }

    @Test
    void update_conCaracteristicas_mapeaSubRecursos() {
        request.setCaracteristicas(List.of(new CaractDetRequest()));
        when(caractDetMapper.toEntity(any(CaractDetRequest.class))).thenReturn(new ArticuloDocTecnicaCaractDet());
        when(mapper.toEntity(any(DocTecnicaRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        controller.update(1L, request);

        verify(caractDetMapper).toEntity(any(CaractDetRequest.class));
    }

    @Test
    void activate_retornaResponse() {
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.activate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void deactivate_retornaResponse() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        var result = controller.deactivate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void delete_retornaTrue() {
        doNothing().when(service).delete(1L);

        var result = controller.delete(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    @Test
    void findCaracteristicas_retornaLista() {
        when(service.findCaracteristicas(1L)).thenReturn(List.of());
        when(caractDetMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(service).enrichCaractDetResponses(any());

        var result = controller.findCaracteristicas(1L);

        assertThat(result.isSuccess()).isTrue();
    }
}
