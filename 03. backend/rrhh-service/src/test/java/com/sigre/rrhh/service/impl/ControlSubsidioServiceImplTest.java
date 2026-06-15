package com.sigre.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;
import com.sigre.rrhh.entity.ControlSubsidio;
import com.sigre.rrhh.mapper.ControlSubsidioMapper;
import com.sigre.rrhh.repository.ControlSubsidioRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ControlSubsidioServiceImpl — Pruebas Unitarias")
class ControlSubsidioServiceImplTest {

    @Mock
    private ControlSubsidioRepository repository;

    @Mock
    private ControlSubsidioMapper mapper;

    @InjectMocks
    private ControlSubsidioServiceImpl service;

    @Captor
    private ArgumentCaptor<ControlSubsidio> captor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            ControlSubsidio entity = inv.getArgument(0);
            ControlSubsidioResponse r = new ControlSubsidioResponse();
            r.setId(entity.getId());
            r.setTrabajadorId(entity.getTrabajadorId());
            r.setTipoSubsidioId(entity.getTipoSubsidioId());
            r.setMontoSubsidio(entity.getMontoSubsidio());
            r.setFlagEstado(entity.getFlagEstado());
            return r;
        });
    }

    @Test
    @DisplayName("listar() -> retorna página")
    void listar_retornaPagina() {
        when(repository.findAll(any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.controlSubsidio(1L))));

        Page<ControlSubsidioResponse> result = service.listar(Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Pageable.class));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna subsidio")
    void obtenerPorId_idExistente_retornaSubsidio() {
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        ControlSubsidioResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("ControlSubsidio");
    }

    @Test
    @DisplayName("crear() con datos válidos -> guarda subsidio")
    void crear_datosValidos_guardaSubsidio() {
        ControlSubsidioCreateRequest request = RrhhTestFixtures.controlSubsidioCreateRequest();
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L);
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(any())).thenReturn(entity);

        ControlSubsidioResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(mapper).toEntity(request);
        verify(repository).save(captor.capture());
        ControlSubsidio saved = captor.getValue();
        assertThat(saved.getFlagEstado()).isEqualTo("1");
        assertThat(saved.getCreatedBy()).isEqualTo(1L);
        assertThat(saved.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza")
    void actualizar_idExistente_actualiza() {
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        ControlSubsidioUpdateRequest request = RrhhTestFixtures.controlSubsidioUpdateRequest();
        service.actualizar(1L, request);

        verify(mapper).updateEntity(entity, request);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.controlSubsidioUpdateRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("desactivar() -> cambia flagEstado a 0")
    void desactivar_cambiaFlagEstadoAInactivo() {
        ControlSubsidio entity = RrhhTestFixtures.controlSubsidio(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }
}
