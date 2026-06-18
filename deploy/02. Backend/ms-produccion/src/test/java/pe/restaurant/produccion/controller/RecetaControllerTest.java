package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.FichaTecnicaRequest;
import pe.restaurant.produccion.dto.request.RecetaConsumibleRequest;
import pe.restaurant.produccion.dto.request.RecetaLaborRequest;
import pe.restaurant.produccion.dto.request.RecetaRequest;
import pe.restaurant.produccion.dto.response.RecetaConsumibleResponse;
import pe.restaurant.produccion.dto.response.RecetaLaborResponse;
import pe.restaurant.produccion.dto.response.RecetaResponse;
import pe.restaurant.produccion.entity.FichaTecnica;
import pe.restaurant.produccion.entity.Receta;
import pe.restaurant.produccion.entity.RecetaLabor;
import pe.restaurant.produccion.entity.RecetaLaborConsumible;
import pe.restaurant.produccion.mapper.FichaTecnicaMapper;
import pe.restaurant.produccion.mapper.RecetaConsumibleMapper;
import pe.restaurant.produccion.mapper.RecetaLaborMapper;
import pe.restaurant.produccion.mapper.RecetaMapper;
import pe.restaurant.produccion.service.RecetaService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RecetaControllerTest {

    @Mock private RecetaService recetaService;
    @Mock private RecetaMapper recetaMapper;
    @Mock private RecetaLaborMapper laborMapper;
    @Mock private RecetaConsumibleMapper consumibleMapper;
    @Mock private FichaTecnicaMapper fichaTecnicaMapper;
    @InjectMocks private RecetaController controller;

    private Receta entity;
    private RecetaResponse response;
    private RecetaRequest request;
    private RecetaLabor labor;
    private RecetaLaborResponse laborResponse;

    @BeforeEach
    void setUp() {
        entity = new Receta();
        entity.setId(1L);

        response = RecetaResponse.builder().id(1L).build();

        request = new RecetaRequest();

        labor = new RecetaLabor();
        labor.setId(1L);

        laborResponse = RecetaLaborResponse.builder().id(1L).build();
    }

    @Test
    void findAll_retornaPageDataConEnrich() {
        var page = new PageImpl<>(List.of(entity));
        when(recetaService.findAll(any(), any(), any(), any(), any(), any(Pageable.class))).thenReturn(page);
        when(recetaMapper.toResponseList(any())).thenReturn(List.of(response));
        doNothing().when(recetaService).enrichRecetaResponses(any());

        var result = controller.findAll(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        verify(recetaService).enrichRecetaResponses(any());
    }

    @Test
    void findById_retornaResponseConEnrich() {
        when(recetaService.findById(1L)).thenReturn(entity);
        when(recetaService.findLabores(1L)).thenReturn(List.of(labor));
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(null);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(laborMapper.toResponseList(any())).thenReturn(List.of(laborResponse));
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(recetaService).enrichRecetaResponses(any());
        doNothing().when(recetaService).enrichLaborResponses(any());
        doNothing().when(recetaService).enrichConsumibleResponses(any());

        var result = controller.findById(1L);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(1L);
        verify(recetaService).enrichRecetaResponses(any());
        verify(recetaService).enrichLaborResponses(any());
    }

    @Test
    void findById_conFichaTecnica_mapeaFicha() {
        var ft = new FichaTecnica();
        ft.setId(1L);
        when(recetaService.findById(1L)).thenReturn(entity);
        when(recetaService.findLabores(1L)).thenReturn(List.of());
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(ft);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        when(fichaTecnicaMapper.toResponse(ft)).thenReturn(new pe.restaurant.produccion.dto.response.FichaTecnicaResponse());
        doNothing().when(recetaService).enrichRecetaResponses(any());

        controller.findById(1L);

        verify(fichaTecnicaMapper).toResponse(ft);
    }

    @Test
    void create_retornaCreado() {
        when(recetaMapper.toEntity(any(RecetaRequest.class))).thenReturn(entity);
        when(recetaService.create(any(), any(), any(), any())).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(recetaService.findLabores(1L)).thenReturn(List.of());
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(null);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(recetaService).enrichRecetaResponses(any());
        doNothing().when(recetaService).enrichLaborResponses(any());
        doNothing().when(recetaService).enrichConsumibleResponses(any());

        var result = controller.create(request);

        assertThat(result.isSuccess()).isTrue();
        verify(recetaService).create(any(), any(), any(), any());
    }

    @Test
    void create_conLaboresYFicha_mapeaSubRecursos() {
        request.setLabores(List.of(new RecetaLaborRequest()));
        request.setFichaTecnica(new FichaTecnicaRequest());

        when(laborMapper.toEntity(any(RecetaLaborRequest.class))).thenReturn(labor);
        when(fichaTecnicaMapper.toEntity(any(FichaTecnicaRequest.class))).thenReturn(new FichaTecnica());
        when(recetaMapper.toEntity(any(RecetaRequest.class))).thenReturn(entity);
        when(recetaService.create(any(), any(), any(), any())).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(recetaService.findLabores(1L)).thenReturn(List.of());
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(null);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(recetaService).enrichRecetaResponses(any());
        doNothing().when(recetaService).enrichLaborResponses(any());

        controller.create(request);

        verify(laborMapper).toEntity(any(RecetaLaborRequest.class));
        verify(fichaTecnicaMapper).toEntity(any(FichaTecnicaRequest.class));
    }

    @Test
    void update_retornaActualizado() {
        when(recetaMapper.toEntity(any(RecetaRequest.class))).thenReturn(entity);
        when(recetaService.update(anyLong(), any(), any(), any(), any())).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(recetaService.findLabores(1L)).thenReturn(List.of());
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(null);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(recetaService).enrichRecetaResponses(any());
        doNothing().when(recetaService).enrichLaborResponses(any());
        doNothing().when(recetaService).enrichConsumibleResponses(any());

        var result = controller.update(1L, request);

        assertThat(result.isSuccess()).isTrue();
        verify(recetaService).update(anyLong(), any(), any(), any(), any());
    }

    @Test
    void update_conLaboresYConsumibles_mapeaSubRecursos() {
        request.setLabores(List.of(new RecetaLaborRequest()));
        request.setConsumibles(List.of(new RecetaConsumibleRequest()));

        when(laborMapper.toEntity(any(RecetaLaborRequest.class))).thenReturn(labor);
        when(consumibleMapper.toEntity(any(RecetaConsumibleRequest.class))).thenReturn(new RecetaLaborConsumible());
        when(recetaMapper.toEntity(any(RecetaRequest.class))).thenReturn(entity);
        when(recetaService.update(anyLong(), any(), any(), any(), any())).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        when(recetaService.findLabores(1L)).thenReturn(List.of());
        when(recetaService.findConsumibles(1L)).thenReturn(List.of());
        when(recetaService.findFichaTecnica(1L)).thenReturn(null);
        when(laborMapper.toResponseList(any())).thenReturn(List.of());
        when(consumibleMapper.toResponseList(any())).thenReturn(List.of());
        doNothing().when(recetaService).enrichRecetaResponses(any());
        doNothing().when(recetaService).enrichLaborResponses(any());
        doNothing().when(recetaService).enrichConsumibleResponses(any());

        controller.update(1L, request);

        verify(laborMapper).toEntity(any(RecetaLaborRequest.class));
        verify(consumibleMapper).toEntity(any(RecetaConsumibleRequest.class));
    }

    @Test
    void activate_retornaResponse() {
        when(recetaService.activate(1L)).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(recetaService).enrichRecetaResponses(any());

        var result = controller.activate(1L);

        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void deactivate_retornaResponse() {
        when(recetaService.deactivate(1L)).thenReturn(entity);
        when(recetaMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(recetaService).enrichRecetaResponses(any());

        var result = controller.deactivate(1L);

        assertThat(result.isSuccess()).isTrue();
    }
}
