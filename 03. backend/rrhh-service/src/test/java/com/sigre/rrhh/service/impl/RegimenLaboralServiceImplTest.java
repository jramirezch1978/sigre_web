package com.sigre.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;
import com.sigre.rrhh.entity.RegimenLaboral;
import com.sigre.rrhh.mapper.RegimenLaboralMapper;
import com.sigre.rrhh.repository.RegimenLaboralRepository;
import com.sigre.rrhh.specification.RegimenLaboralSpecification;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("RegimenLaboralServiceImpl — Pruebas Unitarias")
class RegimenLaboralServiceImplTest {

    @Mock
    private RegimenLaboralRepository repository;

    @Mock
    private RegimenLaboralMapper mapper;

    @InjectMocks
    private RegimenLaboralServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            RegimenLaboral entity = inv.getArgument(0);
            RegimenLaboralResponse r = new RegimenLaboralResponse();
            r.setId(entity.getId());
            r.setCodigo(entity.getCodigo());
            r.setNombre(entity.getNombre());
            r.setFlagEstado(entity.getFlagEstado());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<RegimenLaboral> list = List.of(
                RrhhTestFixtures.regimenLaboral(1L, "RL"),
                RrhhTestFixtures.regimenLaboral(2L, "RC")
        );
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(list));

        Page<RegimenLaboralResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        List<RegimenLaboral> list = List.of(RrhhTestFixtures.regimenLaboral(1L, "RL"));
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(list));

        Page<RegimenLaboralResponse> result = service.listar("RL", "Regimen", "1", pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() {
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        RegimenLaboralResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("RL");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("RegimenLaboral no encontrado");
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("crear() con código único -> crea exitosamente")
    void crear_codigoUnico_creaExitosamente() {
        RegimenLaboralCreateRequest request = RrhhTestFixtures.regimenLaboralCreateRequest("RL", "Regimen Laboral");
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        when(repository.existsByCodigo("RL")).thenReturn(false);
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(entity);

        RegimenLaboralResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).existsByCodigo("RL");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("crear() con código duplicado -> lanza BusinessException")
    void crear_codigoDuplicado_lanzaBusinessException() {
        RegimenLaboralCreateRequest request = RrhhTestFixtures.regimenLaboralCreateRequest("RL", "Regimen Laboral");
        when(repository.existsByCodigo("RL")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un regimen_laboral con ese código");
        verify(repository).existsByCodigo("RL");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza exitosamente")
    void actualizar_idExistente_actualizaExitosamente() {
        Long id = 1L;
        RegimenLaboralUpdateRequest request = RrhhTestFixtures.regimenLaboralUpdateRequest("Regimen Actualizado");
        RegimenLaboral existing = RrhhTestFixtures.regimenLaboral(id, "RL");
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        RegimenLaboralResponse result = service.actualizar(id, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.regimenLaboralUpdateRequest("X")))
                .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("desactivar() con ID existente -> desactiva lógicamente")
    void desactivar_idExistente_desactivaLogicamente() {
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        var result = service.desactivar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza BusinessException")
    void desactivar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
                .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
    }

    // ══════════════════════════════════════════════════════════════
    // activar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("activar() con ID existente -> cambia flagEstado a 1")
    void activar_idExistente_cambiaEstado() {
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        var result = service.activar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
    }

    // ══════════════════════════════════════════════════════════════
    // listarActivos()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("listarActivos() -> retorna solo activos")
    void listarActivos_retornaActivos() {
        RegimenLaboral entity = RrhhTestFixtures.regimenLaboral(1L, "RL");
        RegimenLaboralResponse response = RrhhTestFixtures.regimenLaboralResponse(1L, "RL", "Regimen Laboral");
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        List<RegimenLaboralResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    @Test
    @DisplayName("listarActivos() cuando no hay activos -> retorna lista vacía")
    void listarActivos_sinActivos_retornaListaVacia() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        List<RegimenLaboralResponse> result = service.listarActivos();

        assertThat(result).isEmpty();
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }
}