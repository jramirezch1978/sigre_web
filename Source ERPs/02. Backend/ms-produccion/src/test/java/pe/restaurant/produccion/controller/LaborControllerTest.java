package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.LaborArticuloRequest;
import pe.restaurant.produccion.dto.request.LaborEjecutorRequest;
import pe.restaurant.produccion.dto.response.LaborEjecutorResponse;
import pe.restaurant.produccion.dto.response.LaborInsumoResponse;
import pe.restaurant.produccion.dto.response.LaborProduccionResponse;
import pe.restaurant.produccion.dto.request.LaborRequest;
import pe.restaurant.produccion.dto.response.LaborResponse;
import pe.restaurant.produccion.entity.Labor;
import pe.restaurant.produccion.entity.LaborEjecutor;
import pe.restaurant.produccion.entity.LaborInsumo;
import pe.restaurant.produccion.entity.LaborProduccion;
import pe.restaurant.produccion.mapper.LaborEjecutorMapper;
import pe.restaurant.produccion.mapper.LaborInsumoMapper;
import pe.restaurant.produccion.mapper.LaborMapper;
import pe.restaurant.produccion.mapper.LaborProduccionMapper;
import pe.restaurant.produccion.service.LaborService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class LaborControllerTest {

    @Mock private LaborService service;
    @Mock private LaborMapper laborMapper;
    @Mock private LaborInsumoMapper insumoMapper;
    @Mock private LaborProduccionMapper produccionMapper;
    @Mock private LaborEjecutorMapper ejecutorMapper;
    @InjectMocks private LaborController controller;

    private Labor entity;
    private LaborResponse response;
    private LaborInsumo insumo;
    private LaborInsumoResponse insumoResponse;
    private LaborProduccion producido;
    private LaborProduccionResponse producidoResponse;

    @BeforeEach
    void setUp() {
        entity = new Labor();
        entity.setId(1L);
        entity.setCodigo("LAB-COSECHA");
        entity.setNombre("Labor de cosecha");
        entity.setFlagEstado("1");

        response = LaborResponse.builder()
                .id(1L)
                .codigo("LAB-COSECHA")
                .nombre("Labor de cosecha")
                .flagEstado("1")
                .build();

        insumo = new LaborInsumo();
        insumo.setId(50L);
        insumo.setLaborId(1L);
        insumo.setArticuloId(100L);

        insumoResponse = LaborInsumoResponse.builder()
                .id(50L).laborId(1L).articuloId(100L).build();

        producido = new LaborProduccion();
        producido.setId(60L);
        producido.setLaborId(1L);
        producido.setArticuloId(200L);

        producidoResponse = LaborProduccionResponse.builder()
                .id(60L).laborId(1L).articuloId(200L).build();
    }

    // ─────────────── Cabecera ───────────────

    @Test
    void findAll_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(laborMapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findAll(null, null, null, Pageable.unpaged());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getPage().getTotalElements()).isEqualTo(1);
    }

    @Test
    void findAll_propagaFiltros() {
        var page = new PageImpl<Labor>(List.of());
        when(service.findAll(eq("LAB"), eq("cosecha"), eq("1"), any(Pageable.class))).thenReturn(page);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());

        controller.findAll("LAB", "cosecha", "1", Pageable.unpaged());
        verify(service).findAll(eq("LAB"), eq("cosecha"), eq("1"), any(Pageable.class));
    }

    @Test
    void findById_retornaResponseMapeado() {
        when(service.findById(1L)).thenReturn(entity);
        when(laborMapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_delegaServiceYRetornaCreatedConMensaje() {
        var req = new LaborRequest("LAB-COSECHA", "Labor de cosecha");
        when(laborMapper.toEntity(any(LaborRequest.class))).thenReturn(entity);
        when(service.create(any(Labor.class))).thenReturn(entity);
        when(laborMapper.toResponse(entity)).thenReturn(response);

        var result = controller.create(req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
        verify(service).create(any(Labor.class));
    }

    @Test
    void update_invocaUpdateEntityYServiceUpdate() {
        var req = new LaborRequest("LAB-COSECHA", "Nuevo nombre");
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(Labor.class))).thenReturn(entity);
        when(laborMapper.toResponse(any(Labor.class))).thenReturn(response);

        var result = controller.update(1L, req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
        verify(laborMapper).updateEntity(eq(req), eq(entity));
        verify(service).update(eq(1L), eq(entity));
    }

    @Test
    void activate_invocaServiceConMensaje() {
        when(service.activate(1L)).thenReturn(entity);
        when(laborMapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.activate(1L).getMessage()).contains("activada");
    }

    @Test
    void deactivate_invocaServiceConMensaje() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(laborMapper.toResponse(entity)).thenReturn(response);
        assertThat(controller.deactivate(1L).getMessage()).contains("desactivada");
    }

    @Test
    void delete_retornaTrueConMensaje() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminada");
        verify(service).delete(1L);
    }

    // ─────────────── Sub-recurso insumos ───────────────

    @Test
    void findInsumos_retornaListaMapeada() {
        when(service.findInsumos(1L)).thenReturn(List.of(insumo));
        when(insumoMapper.toResponseList(any())).thenReturn(List.of(insumoResponse));
        var result = controller.findInsumos(1L);
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getArticuloId()).isEqualTo(100L);
    }

    @Test
    void asignarInsumo_delegaServiceYRetornaCreated() {
        var req = new LaborArticuloRequest(100L);
        when(service.asignarInsumo(1L, 100L)).thenReturn(insumo);
        when(insumoMapper.toResponse(insumo)).thenReturn(insumoResponse);

        var result = controller.asignarInsumo(1L, req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("Insumo asignado");
        verify(service).asignarInsumo(1L, 100L);
    }

    @Test
    void desasignarInsumo_retornaTrueConMensaje() {
        doNothing().when(service).desasignarInsumo(1L, 100L);
        var result = controller.desasignarInsumo(1L, 100L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("Insumo desasignado");
        verify(service).desasignarInsumo(1L, 100L);
    }

    // ─────────────── Sub-recurso producidos ───────────────

    @Test
    void findProducidos_retornaListaMapeada() {
        when(service.findProducidos(1L)).thenReturn(List.of(producido));
        when(produccionMapper.toResponseList(any())).thenReturn(List.of(producidoResponse));
        var result = controller.findProducidos(1L);
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getArticuloId()).isEqualTo(200L);
    }

    @Test
    void asignarProducido_delegaServiceYRetornaCreated() {
        var req = new LaborArticuloRequest(200L);
        when(service.asignarProducido(1L, 200L)).thenReturn(producido);
        when(produccionMapper.toResponse(producido)).thenReturn(producidoResponse);

        var result = controller.asignarProducido(1L, req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("Producido asignado");
        verify(service).asignarProducido(1L, 200L);
    }

    @Test
    void desasignarProducido_retornaTrueConMensaje() {
        doNothing().when(service).desasignarProducido(1L, 200L);
        var result = controller.desasignarProducido(1L, 200L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("Producido desasignado");
        verify(service).desasignarProducido(1L, 200L);
    }

    // ─────────────── Sub-recurso ejecutores ───────────────

    @Test
    void findEjecutores_retornaListaMapeadaConEnrich() {
        var ejecutorEntity = new LaborEjecutor();
        ejecutorEntity.setId(1L);
        var ejecutorResponse = LaborEjecutorResponse.builder().id(1L).build();
        when(service.findEjecutores(1L)).thenReturn(List.of(ejecutorEntity));
        when(ejecutorMapper.toResponseList(any())).thenReturn(List.of(ejecutorResponse));
        doNothing().when(service).enrichEjecutores(any());

        var result = controller.findEjecutores(1L);

        assertThat(result.getData()).hasSize(1);
        verify(service).enrichEjecutores(any());
    }

    @Test
    void asignarEjecutor_delegaServiceYRetornaCreated() {
        var req = new LaborEjecutorRequest();
        req.setEjecutorId(10L);
        var savedEntity = new LaborEjecutor();
        savedEntity.setId(1L);
        var ejecutorResponse = LaborEjecutorResponse.builder().id(1L).build();

        when(ejecutorMapper.toEntity(any(LaborEjecutorRequest.class))).thenReturn(savedEntity);
        when(service.asignarEjecutor(eq(1L), eq(10L), any(LaborEjecutor.class))).thenReturn(savedEntity);
        when(ejecutorMapper.toResponse(any())).thenReturn(ejecutorResponse);
        doNothing().when(service).enrichEjecutores(any());

        var result = controller.asignarEjecutor(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("asignado");
        verify(service).asignarEjecutor(eq(1L), eq(10L), any(LaborEjecutor.class));
    }

    @Test
    void actualizarEjecutor_delegaServiceYRetornaResponse() {
        var req = new LaborEjecutorRequest();
        req.setEjecutorId(10L);
        var entity = new LaborEjecutor();
        entity.setId(1L);
        var response = LaborEjecutorResponse.builder().id(1L).build();

        when(ejecutorMapper.toEntity(any(LaborEjecutorRequest.class))).thenReturn(entity);
        when(service.actualizarEjecutor(eq(1L), eq(10L), any(LaborEjecutor.class))).thenReturn(entity);
        when(ejecutorMapper.toResponse(any())).thenReturn(response);
        doNothing().when(service).enrichEjecutores(any());

        var result = controller.actualizarEjecutor(1L, 10L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizado");
        verify(service).actualizarEjecutor(eq(1L), eq(10L), any(LaborEjecutor.class));
    }

    @Test
    void desasignarEjecutor_retornaTrueConMensaje() {
        doNothing().when(service).desasignarEjecutor(1L, 10L);

        var result = controller.desasignarEjecutor(1L, 10L);

        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("desasignado");
        verify(service).desasignarEjecutor(1L, 10L);
    }
}
