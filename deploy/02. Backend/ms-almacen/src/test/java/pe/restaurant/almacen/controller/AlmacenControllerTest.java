package pe.restaurant.almacen.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.AlmacenRequest;
import pe.restaurant.almacen.dto.AlmacenResponse;
import pe.restaurant.almacen.dto.AlmacenUsuarioAsignarRequest;
import pe.restaurant.almacen.dto.AlmacenUsuarioResponse;
import pe.restaurant.almacen.dto.UbicacionAlmacenRequest;
import pe.restaurant.almacen.dto.UbicacionAlmacenResponse;
import pe.restaurant.almacen.entity.Almacen;
import pe.restaurant.almacen.entity.AlmacenUser;
import pe.restaurant.almacen.entity.UbicacionAlmacen;
import pe.restaurant.almacen.mapper.AlmacenMapper;
import pe.restaurant.almacen.mapper.UbicacionAlmacenMapper;
import pe.restaurant.almacen.service.AlmacenService;
import pe.restaurant.almacen.service.AlmacenTipoMovService;
import pe.restaurant.almacen.service.AlmacenUserService;
import pe.restaurant.almacen.service.UbicacionAlmacenService;
import pe.restaurant.almacen.support.AlmacenResponseEnricher;
import pe.restaurant.almacen.support.AlmacenUsuarioResponseAssembler;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AlmacenControllerTest {

    @Mock private AlmacenService almacenService;
    @Mock private AlmacenMapper almacenMapper;
    @Mock private AlmacenResponseEnricher almacenResponseEnricher;
    @Mock private AlmacenUserService almacenUserService;
    @Mock private AlmacenUsuarioResponseAssembler almacenUsuarioResponseAssembler;
    @Mock private AlmacenTipoMovService almacenTipoMovService;
    @Mock private UbicacionAlmacenService ubicacionAlmacenService;
    @Mock private UbicacionAlmacenMapper ubicacionAlmacenMapper;
    @InjectMocks private AlmacenController controller;

    private Almacen entity;
    private AlmacenResponse response;
    private UbicacionAlmacen ubicacionEntity;
    private UbicacionAlmacenResponse ubicacionResponse;

    @BeforeEach
    void setUp() {
        entity = new Almacen();
        entity.setId(1L);
        entity.setSucursalId(100L);
        entity.setCodigo("ALM01");
        entity.setNombre("Almacen Principal");
        entity.setFlagEstado("1");

        response = new AlmacenResponse();
        response.setId(1L);
        response.setCodigo("ALM01");

        ubicacionEntity = new UbicacionAlmacen();
        ubicacionEntity.setId(10L);
        ubicacionEntity.setAlmacenId(1L);

        ubicacionResponse = new UbicacionAlmacenResponse();
        ubicacionResponse.setId(10L);
    }

    @Test
    void findAll() {
        var page = new PageImpl<>(List.of(entity));
        when(almacenService.findAll(any(Pageable.class))).thenReturn(page);
        when(almacenMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(entity, response);
        var result = controller.findAll(Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
        verify(almacenResponseEnricher).enrich(entity, response);
    }

    @Test
    void findById() {
        when(almacenService.findById(1L)).thenReturn(entity);
        when(almacenMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(entity, response);
        assertThat(controller.findById(1L).getData().getId()).isEqualTo(1L);
    }

    @Test
    void create() {
        when(almacenMapper.toEntity(any(AlmacenRequest.class))).thenReturn(entity);
        when(almacenService.create(any())).thenReturn(entity);
        when(almacenMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(entity, response);
        var result = controller.create(new AlmacenRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void update() {
        when(almacenService.findById(1L)).thenReturn(entity);
        when(almacenService.update(eq(1L), any())).thenReturn(entity);
        when(almacenMapper.toResponse(any())).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(any(Almacen.class), any(AlmacenResponse.class));
        var result = controller.update(1L, new AlmacenRequest());
        assertThat(result.isSuccess()).isTrue();
    }

    @Test
    void activate() {
        when(almacenService.activate(1L)).thenReturn(entity);
        when(almacenMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(entity, response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activado");
    }

    @Test
    void deactivate() {
        when(almacenService.deactivate(1L)).thenReturn(entity);
        when(almacenMapper.toResponse(entity)).thenReturn(response);
        doNothing().when(almacenResponseEnricher).enrich(entity, response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivado");
    }

    @Test
    void delete() {
        doNothing().when(almacenService).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
    }

    @Test
    void findUbicaciones() {
        when(almacenService.findById(1L)).thenReturn(entity);
        when(ubicacionAlmacenService.findByAlmacenId(1L)).thenReturn(List.of(ubicacionEntity));
        when(ubicacionAlmacenMapper.toResponseList(any())).thenReturn(List.of(ubicacionResponse));
        var result = controller.findUbicaciones(1L);
        assertThat(result.getData()).hasSize(1);
    }

    @Test
    void createUbicacion() {
        var request = new UbicacionAlmacenRequest();
        when(almacenService.findById(1L)).thenReturn(entity);
        when(ubicacionAlmacenMapper.toEntity(any(UbicacionAlmacenRequest.class))).thenReturn(ubicacionEntity);
        when(ubicacionAlmacenService.create(any())).thenReturn(ubicacionEntity);
        when(ubicacionAlmacenMapper.toResponse(ubicacionEntity)).thenReturn(ubicacionResponse);
        var result = controller.createUbicacion(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(10L);
    }

    @Test
    void listarUsuarios() {
        var au = new AlmacenUser();
        au.setId(5L);
        au.setAlmacenId(1L);
        au.setUsuarioId(3L);
        when(almacenUserService.listarPorAlmacenId(eq(1L), isNull(), isNull())).thenReturn(List.of(au));
        when(almacenUsuarioResponseAssembler.toResponseList(any())).thenReturn(
                List.of(AlmacenUsuarioResponse.builder().id(5L).almacenId(1L).usuarioId(3L).flagEstado("1").build()));
        var result = controller.listarUsuarios(1L, null, null);
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getUsuarioId()).isEqualTo(3L);
    }

    @Test
    void asignarUsuario() {
        var row = new AlmacenUser();
        row.setId(7L);
        row.setUsuarioId(2L);
        when(almacenUserService.asignar(1L, 2L)).thenReturn(row);
        when(almacenUsuarioResponseAssembler.toResponse(row))
                .thenReturn(AlmacenUsuarioResponse.builder().id(7L).almacenId(1L).usuarioId(2L).flagEstado("1").build());
        var r = new AlmacenUsuarioAsignarRequest();
        r.setUsuarioId(2L);
        var result = controller.asignarUsuario(1L, r);
        assertThat(result.getData().getUsuarioId()).isEqualTo(2L);
    }

    @Test
    void desasignarUsuario() {
        var row = new AlmacenUser();
        row.setFlagEstado("0");
        when(almacenUserService.desasignar(1L, 2L)).thenReturn(row);
        when(almacenUsuarioResponseAssembler.toResponse(row))
                .thenReturn(AlmacenUsuarioResponse.builder().usuarioId(2L).flagEstado("0").build());
        var res = controller.desasignarUsuario(1L, 2L);
        assertThat(res.getData().getFlagEstado()).isEqualTo("0");
        verify(almacenUserService).desasignar(1L, 2L);
    }
}
