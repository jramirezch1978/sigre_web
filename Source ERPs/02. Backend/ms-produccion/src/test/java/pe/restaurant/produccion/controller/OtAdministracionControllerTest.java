package pe.restaurant.produccion.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.request.OtAdminUderRequest;
import pe.restaurant.produccion.dto.response.OtAdminUderResponse;
import pe.restaurant.produccion.dto.request.OtAdministracionRequest;
import pe.restaurant.produccion.dto.response.OtAdministracionResponse;
import pe.restaurant.produccion.entity.OtAdminUder;
import pe.restaurant.produccion.entity.OtAdministracion;
import pe.restaurant.produccion.mapper.OtAdminUderMapper;
import pe.restaurant.produccion.mapper.OtAdministracionMapper;
import pe.restaurant.produccion.service.OtAdministracionService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OtAdministracionControllerTest {

    @Mock private OtAdministracionService service;
    @Mock private OtAdministracionMapper adminMapper;
    @Mock private OtAdminUderMapper uderMapper;
    @InjectMocks private OtAdministracionController controller;

    private OtAdministracion entity;
    private OtAdministracionResponse response;
    private OtAdminUder uder;
    private OtAdminUderResponse uderResponse;

    @BeforeEach
    void setUp() {
        entity = new OtAdministracion();
        entity.setId(1L);
        entity.setCodigo("ADM-CAMPO");
        entity.setNombre("Administracion de campo");
        entity.setFlagTipoCosto("D");
        entity.setFlagEstado("1");

        response = OtAdministracionResponse.builder()
                .id(1L)
                .codigo("ADM-CAMPO")
                .nombre("Administracion de campo")
                .flagTipoCosto("D")
                .flagEstado("1")
                .build();

        uder = new OtAdminUder();
        uder.setId(50L);
        uder.setOtAdministracionId(1L);
        uder.setUsuarioId(10L);
        uder.setFlagEstado("1");

        uderResponse = OtAdminUderResponse.builder()
                .id(50L)
                .otAdministracionId(1L)
                .usuarioId(10L)
                .flagEstado("1")
                .build();
    }

    // ─────────────── Cabecera ───────────────

    @Test
    void findAll_sinFiltros_retornaPageData() {
        var page = new PageImpl<>(List.of(entity));
        when(service.findAll(isNull(), isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(adminMapper.toResponseList(any())).thenReturn(List.of(response));

        var result = controller.findAll(null, null, null, null, Pageable.unpaged());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).hasSize(1);
        assertThat(result.getData().getPage().getTotalElements()).isEqualTo(1);
    }

    @Test
    void findAll_propagaTodosLosFiltros() {
        var page = new PageImpl<OtAdministracion>(List.of());
        when(service.findAll(eq("ADM"), eq("camp"), eq("DIRECTO"), eq("1"), any(Pageable.class)))
                .thenReturn(page);
        when(adminMapper.toResponseList(any())).thenReturn(List.of());

        controller.findAll("ADM", "camp", "DIRECTO", "1", Pageable.unpaged());

        verify(service).findAll(eq("ADM"), eq("camp"), eq("DIRECTO"), eq("1"), any(Pageable.class));
    }

    @Test
    void findById_retornaResponseMapeado() {
        when(service.findById(1L)).thenReturn(entity);
        when(adminMapper.toResponse(entity)).thenReturn(response);
        var result = controller.findById(1L);
        assertThat(result.getData().getId()).isEqualTo(1L);
    }

    @Test
    void create_delegaServiceYRetornaCreatedConMensaje() {
        var req = new OtAdministracionRequest("ADM-CAMPO", "Administracion de campo", "DIRECTO");
        when(adminMapper.toEntity(any(OtAdministracionRequest.class))).thenReturn(entity);
        when(service.create(any(OtAdministracion.class))).thenReturn(entity);
        when(adminMapper.toResponse(entity)).thenReturn(response);

        var result = controller.create(req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("creada");
        verify(service).create(any(OtAdministracion.class));
    }

    @Test
    void update_invocaUpdateEntityYServiceUpdate() {
        var req = new OtAdministracionRequest("ADM-CAMPO", "Nuevo nombre", "INDIRECTO");
        when(service.findById(1L)).thenReturn(entity);
        when(service.update(eq(1L), any(OtAdministracion.class))).thenReturn(entity);
        when(adminMapper.toResponse(any(OtAdministracion.class))).thenReturn(response);

        var result = controller.update(1L, req);

        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("actualizada");
        verify(adminMapper).updateEntity(eq(req), eq(entity));
        verify(service).update(eq(1L), eq(entity));
    }

    @Test
    void activate_invocaServiceConMensaje() {
        when(service.activate(1L)).thenReturn(entity);
        when(adminMapper.toResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.getMessage()).contains("activada");
    }

    @Test
    void deactivate_invocaServiceConMensaje() {
        when(service.deactivate(1L)).thenReturn(entity);
        when(adminMapper.toResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.getMessage()).contains("desactivada");
    }

    @Test
    void delete_retornaTrueConMensaje() {
        doNothing().when(service).delete(1L);
        var result = controller.delete(1L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("eliminada");
        verify(service).delete(1L);
    }

    // ─────────────── Sub-recurso usuarios ───────────────

    @Test
    void findUsuarios_retornaListaMapeada() {
        when(service.findUsuarios(1L)).thenReturn(List.of(uder));
        when(uderMapper.toResponseList(any())).thenReturn(List.of(uderResponse));
        var result = controller.findUsuarios(1L);
        assertThat(result.getData()).hasSize(1);
        assertThat(result.getData().get(0).getUsuarioId()).isEqualTo(10L);
    }

    @Test
    void asignarUsuario_delegaServiceYRetornaCreated() {
        var req = new OtAdminUderRequest(10L);
        when(service.asignarUsuario(1L, 10L)).thenReturn(uder);
        when(uderMapper.toResponse(uder)).thenReturn(uderResponse);

        var result = controller.asignarUsuario(1L, req);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).contains("asignado");
        verify(service).asignarUsuario(1L, 10L);
    }

    @Test
    void desasignarUsuario_retornaTrueConMensaje() {
        doNothing().when(service).desasignarUsuario(1L, 10L);
        var result = controller.desasignarUsuario(1L, 10L);
        assertThat(result.getData()).isTrue();
        assertThat(result.getMessage()).contains("desasignado");
        verify(service).desasignarUsuario(1L, 10L);
    }
}
