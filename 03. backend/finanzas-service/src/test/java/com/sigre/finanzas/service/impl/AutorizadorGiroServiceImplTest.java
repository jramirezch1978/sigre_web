package com.sigre.finanzas.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.client.AuthSecurityClient;
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;
import com.sigre.finanzas.entity.AutorizadorGiro;
import com.sigre.finanzas.mapper.AutorizadorGiroMapper;
import com.sigre.finanzas.repository.AutorizadorGiroRepository;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - AutorizadorGiroServiceImpl")
class AutorizadorGiroServiceImplTest {

    @Mock private AutorizadorGiroRepository repository;
    @Mock private AutorizadorGiroMapper mapper;
    @Mock private AuthSecurityClient authSecurityClient;

    @InjectMocks
    private AutorizadorGiroServiceImpl service;

    private AutorizadorGiro autorizador;
    private AutorizadorGiroResponse response;
    private AutorizadorGiroRequest request;
    private AutorizadorGiroRequest requestWithDifferentCentro;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);

        autorizador = new AutorizadorGiro();
        autorizador.setId(1L);
        autorizador.setCentrosCostoId(10L);
        autorizador.setUsuarioId(1L);
        autorizador.setActivo(true);

        response = new AutorizadorGiroResponse();
        response.setId(1L);

        request = new AutorizadorGiroRequest();
        request.setCentrosCostoId(10L);
        request.setActivo(true);

        requestWithDifferentCentro = new AutorizadorGiroRequest();
        requestWithDifferentCentro.setCentrosCostoId(20L);
        requestWithDifferentCentro.setActivo(true);
    }


    // ==== findAll ====

    @Test
    @DisplayName("findAll - Debe retornar página")
    void findAll_DebeRetornarPagina() {
        Page<AutorizadorGiro> page = new PageImpl<>(List.of(autorizador));
        when(repository.findAll(any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<AutorizadorGiroResponse> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== findById ====

    @Test
    @DisplayName("findById - Debe retornar autorizador")
    void findById_DebeRetornarAutorizador() {
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(mapper.toResponse(autorizador)).thenReturn(response);

        AutorizadorGiroResponse result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById - Debe lanzar excepción si no existe")
    void findById_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== create ====

    @Test
    @DisplayName("create - Con datos válidos debe crear autorizador")
    void create_ConDatosValidos_DebeCrearAutorizador() {
        when(repository.existsByCentrosCostoIdAndUsuarioId(10L, 1L)).thenReturn(false);
        when(mapper.toEntity(request)).thenReturn(autorizador);
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(autorizador)).thenReturn(response);

        AutorizadorGiroResponse result = service.create(request);

        assertThat(result).isNotNull();
        verify(repository).save(autorizador);
    }

    @Test
    @DisplayName("create - Cuando existe duplicado debe lanzar BusinessException")
    void create_CuandoExisteDuplicado_DebeLanzarExcepcion() {
        when(repository.existsByCentrosCostoIdAndUsuarioId(10L, 1L)).thenReturn(true);

        assertThatThrownBy(() -> service.create(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un autorizador");
    }


    // ==== update ====

    @Test
    @DisplayName("update - Con datos válidos debe actualizar autorizador")
    void update_ConDatosValidos_DebeActualizarAutorizador() {
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.existsByCentrosCostoIdAndUsuarioIdAndIdNot(20L, 1L, 1L)).thenReturn(false);
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(any())).thenReturn(response);

        AutorizadorGiroResponse result = service.update(1L, requestWithDifferentCentro);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update - Cuando no existe debe lanzar ResourceNotFoundException")
    void update_CuandoNoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(999L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("update - Cuando existe duplicado debe lanzar BusinessException")
    void update_CuandoExisteDuplicado_DebeLanzarExcepcion() {
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.existsByCentrosCostoIdAndUsuarioIdAndIdNot(20L, 1L, 1L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(1L, requestWithDifferentCentro))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un autorizador");
    }

    @Test
    @DisplayName("update - Sin cambios en centrosCostoId ni usuarioId debe pasar sin validar duplicado")
    void update_CuandoMismoCentroYUsuario_DebePasar() {
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(any())).thenReturn(response);

        AutorizadorGiroResponse result = service.update(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update - Cuando cambia usuarioId (distinto al token) y no hay duplicado debe actualizar")
    void update_CuandoCambiaUsuarioId_DebePasar() {
        TenantContext.setUsuarioId(99L);
        autorizador.setUsuarioId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.existsByCentrosCostoIdAndUsuarioIdAndIdNot(10L, 99L, 1L)).thenReturn(false);
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(any())).thenReturn(response);

        AutorizadorGiroResponse result = service.update(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== deleteById ====

    @Test
    @DisplayName("deleteById - Debe eliminar autorizador cuando existe")
    void deleteById_CuandoExiste_DebeEliminar() {
        when(repository.existsById(1L)).thenReturn(true);

        service.deleteById(1L);

        verify(repository).deleteById(1L);
    }

    @Test
    @DisplayName("deleteById - Cuando no existe debe lanzar ResourceNotFoundException")
    void deleteById_CuandoNoExiste_DebeLanzarExcepcion() {
        when(repository.existsById(999L)).thenReturn(false);

        assertThatThrownBy(() -> service.deleteById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== activate ====

    @Test
    @DisplayName("activate - Debe activar autorizador inactivo")
    void activate_DebeActivarAutorizador() {
        autorizador.setActivo(false);
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(any())).thenReturn(response);

        AutorizadorGiroResponse result = service.activate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== deactivate ====

    @Test
    @DisplayName("deactivate - Debe desactivar autorizador activo")
    void deactivate_DebeDesactivarAutorizador() {
        when(repository.findById(1L)).thenReturn(Optional.of(autorizador));
        when(repository.save(any())).thenReturn(autorizador);
        when(mapper.toResponse(any())).thenReturn(response);

        AutorizadorGiroResponse result = service.deactivate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== findByCentroCosto ====

    @Test
    @DisplayName("findByCentroCosto - Debe retornar lista de autorizadores")
    void findByCentroCosto_DebeRetornarLista() {
        when(repository.findByCentrosCostoIdAndActivo(10L, true))
                .thenReturn(List.of(autorizador));
        when(mapper.toResponse(autorizador)).thenReturn(response);

        List<AutorizadorGiroResponse> result = service.findByCentroCosto(10L);

        assertThat(result).hasSize(1);
    }


    // ==== findActivosByCentroCosto ====

    @Test
    @DisplayName("findActivosByCentroCosto - Debe retornar lista de autorizadores activos")
    void findActivosByCentroCosto_DebeRetornarLista() {
        when(repository.findAutorizadoresActivosPorCentroCosto(10L))
                .thenReturn(List.of(autorizador));
        when(mapper.toResponse(autorizador)).thenReturn(response);

        List<AutorizadorGiroResponse> result = service.findActivosByCentroCosto(10L);

        assertThat(result).hasSize(1);
    }
}
