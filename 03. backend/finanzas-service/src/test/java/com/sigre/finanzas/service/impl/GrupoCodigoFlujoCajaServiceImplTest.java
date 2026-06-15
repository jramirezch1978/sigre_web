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
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.entity.GrupoCodigoFlujoCaja;
import com.sigre.finanzas.mapper.GrupoCodigoFlujoCajaMapper;
import com.sigre.finanzas.repository.GrupoCodigoFlujoCajaRepository;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - GrupoCodigoFlujoCajaServiceImpl")
class GrupoCodigoFlujoCajaServiceImplTest {

    @Mock private GrupoCodigoFlujoCajaRepository repository;
    @Mock private GrupoCodigoFlujoCajaMapper mapper;

    @InjectMocks
    private GrupoCodigoFlujoCajaServiceImpl service;

    private GrupoCodigoFlujoCaja entity;
    private GrupoCodigoFlujoCajaResponse response;

    @BeforeEach
    void setUp() {
        entity = new GrupoCodigoFlujoCaja();
        entity.setId(1L);
        entity.setFlagEstado("1");

        response = new GrupoCodigoFlujoCajaResponse();
        response.setId(1L);
        response.setFlagEstado("1");
    }


    // ==== findAll — otros ====

    @Test
    @DisplayName("findAll - Debe retornar página")
    void findAll_DebeRetornarPagina() {
        Page<GrupoCodigoFlujoCaja> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        PageData<GrupoCodigoFlujoCajaResponse> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getContent().size()).isEqualTo(1);
    }


    // ==== findById — otros ====

    @Test
    @DisplayName("findById - Debe retornar entidad")
    void findById_DebeRetornarEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(response);

        GrupoCodigoFlujoCajaResponse result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById - Debe lanzar excepción si no existe")
    void findById_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== activate — escenarios felices ====

    @Test
    @DisplayName("activate - Debe activar")
    void activate_DebeActivar() {
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);

        GrupoCodigoFlujoCajaResponse result = service.activate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== deactivate — escenarios felices ====

    @Test
    @DisplayName("deactivate - Debe desactivar")
    void deactivate_DebeDesactivar() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toResponse(any())).thenReturn(response);

        GrupoCodigoFlujoCajaResponse result = service.deactivate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }
}
