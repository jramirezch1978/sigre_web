package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.ParteInsumoRequest;
import pe.restaurant.produccion.dto.request.ParteProducidoRequest;
import pe.restaurant.produccion.dto.request.ParteProduccionRequest;
import pe.restaurant.produccion.dto.response.ParteInsumoResponse;
import pe.restaurant.produccion.dto.response.ParteProducidoResponse;
import pe.restaurant.produccion.dto.response.ParteProduccionResponse;
import pe.restaurant.produccion.entity.ParteProduccion;
import pe.restaurant.produccion.entity.ParteProduccionInsumo;
import pe.restaurant.produccion.entity.ParteProduccionProducido;
import pe.restaurant.produccion.mapper.ParteInsumoMapper;
import pe.restaurant.produccion.mapper.ParteProducidoMapper;
import pe.restaurant.produccion.mapper.ParteProduccionMapper;
import pe.restaurant.produccion.service.ParteProduccionService;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ParteProduccionControllerTest {

    @Mock private ParteProduccionService service;
    @Mock private ParteProduccionMapper mapper;
    @Mock private ParteInsumoMapper insumoMapper;
    @Mock private ParteProducidoMapper producidoMapper;
    @InjectMocks private ParteProduccionController controller;

    private ParteProduccion entity;
    private ParteProduccionResponse response;
    private ParteProduccionRequest request;
    private ParteProduccionInsumo insumo;
    private ParteInsumoResponse insumoResponse;

    @BeforeEach
    void setUp() {
        entity = new ParteProduccion();
        entity.setId(1L);
        entity.setFecha(LocalDate.now());

        response = ParteProduccionResponse.builder().id(1L).build();

        request = new ParteProduccionRequest();

        insumo = new ParteProduccionInsumo();
        insumo.setArticuloId(1L);

        insumoResponse = ParteInsumoResponse.builder().id(1L).build();
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
    void findById_retornaResponse() {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(insumoMapper.toResponseList(any())).thenReturn(List.of(insumoResponse));
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_conDatosValidos_retornaCreado() {
        when(mapper.toEntity(any(ParteProduccionRequest.class))).thenReturn(entity);
        when(service.create(any(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(insumoMapper.toResponseList(any())).thenReturn(List.of());
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).create(any(), any(), any());
    }

    @Test
    void create_conInsumosYProducidos_mapeaSubRecursos() {
        request.setInsumos(List.of(new ParteInsumoRequest()));
        request.setProducidos(List.of(new ParteProducidoRequest()));
        when(insumoMapper.toEntity(any(ParteInsumoRequest.class))).thenReturn(insumo);
        when(producidoMapper.toEntity(any(ParteProducidoRequest.class))).thenReturn(new ParteProduccionProducido());
        when(mapper.toEntity(any(ParteProduccionRequest.class))).thenReturn(entity);
        when(service.create(any(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(insumoMapper.toResponseList(any())).thenReturn(List.of(insumoResponse));
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        controller.create(request);

        verify(insumoMapper).toEntity(any(ParteInsumoRequest.class));
        verify(producidoMapper).toEntity(any(ParteProducidoRequest.class));
    }

    @Test
    void update_conDatosValidos_retornaActualizado() {
        when(mapper.toEntity(any(ParteProduccionRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(insumoMapper.toResponseList(any())).thenReturn(List.of());
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(service).update(anyLong(), any(), any(), any());
    }

    @Test
    void update_conInsumosYProducidos_mapeaSubRecursos() {
        request.setInsumos(List.of(new ParteInsumoRequest()));
        request.setProducidos(List.of(new ParteProducidoRequest()));
        when(insumoMapper.toEntity(any(ParteInsumoRequest.class))).thenReturn(insumo);
        when(producidoMapper.toEntity(any(ParteProducidoRequest.class))).thenReturn(new ParteProduccionProducido());
        when(mapper.toEntity(any(ParteProduccionRequest.class))).thenReturn(entity);
        when(service.update(anyLong(), any(), any(), any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);
        when(insumoMapper.toResponseList(any())).thenReturn(List.of(insumoResponse));
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        controller.update(1L, request);

        verify(insumoMapper).toEntity(any(ParteInsumoRequest.class));
        verify(producidoMapper).toEntity(any(ParteProducidoRequest.class));
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
    void findInsumos_retornaLista() {
        when(service.findInsumos(1L)).thenReturn(List.of(insumo));
        when(insumoMapper.toResponseList(any())).thenReturn(List.of(insumoResponse));

        var result = controller.findInsumos(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void findProducidos_retornaLista() {
        when(service.findProducidos(1L)).thenReturn(List.of());
        when(producidoMapper.toResponseList(any())).thenReturn(List.of());

        var result = controller.findProducidos(1L);

        assertThat(result.isSuccess()).isTrue();
    }
}
