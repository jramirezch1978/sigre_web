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
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.TipoSancionCreateRequest;
import com.sigre.rrhh.dto.request.TipoSancionUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSancionResponse;
import com.sigre.rrhh.entity.TipoSancion;
import com.sigre.rrhh.mapper.TipoSancionMapper;
import com.sigre.rrhh.repository.TipoSancionRepository;
import com.sigre.rrhh.specification.TipoSancionSpecification;
import com.sigre.rrhh.validation.TipoSancionValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoSancionServiceImpl — Pruebas Unitarias")
class TipoSancionServiceImplTest {

    @Mock
    private TipoSancionRepository repository;

    @Mock
    private TipoSancionMapper mapper;

    @Mock
    private TipoSancionValidator validator;

    @InjectMocks
    private TipoSancionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            TipoSancion entity = inv.getArgument(0);
            TipoSancionResponse r = new TipoSancionResponse();
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
        List<TipoSancion> list = List.of(
                RrhhTestFixtures.tipoSancion(1L, "LEVE"),
                RrhhTestFixtures.tipoSancion(2L, "GRAVE")
        );
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(list));

        Page<TipoSancionResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        List<TipoSancion> list = List.of(RrhhTestFixtures.tipoSancion(1L, "LEVE"));
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(list));

        Page<TipoSancionResponse> result = service.listar("LEVE", "Leve", "1", pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() {
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        TipoSancionResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("LEVE");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("TipoSancion");
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("crear() con código único -> crea exitosamente")
    void crear_codigoUnico_creaExitosamente() {
        TipoSancionCreateRequest request = RrhhTestFixtures.tipoSancionCreateRequest("LEVE", "Leve");
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
        doNothing().when(validator).validarCodigoUnico("LEVE");
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(entity);

        TipoSancionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarCodigoUnico("LEVE");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("crear() con código duplicado -> lanza BusinessException")
    void crear_codigoDuplicado_lanzaBusinessException() {
        TipoSancionCreateRequest request = RrhhTestFixtures.tipoSancionCreateRequest("LEVE", "Leve");
        doThrow(new BusinessException("Ya existe un tipo de sanción con ese código.", null, "RH-TS-002"))
                .when(validator).validarCodigoUnico("LEVE");

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un tipo de sanción con ese código");
        verify(validator).validarCodigoUnico("LEVE");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza exitosamente")
    void actualizar_idExistente_actualizaExitosamente() {
        Long id = 1L;
        TipoSancionUpdateRequest request = RrhhTestFixtures.tipoSancionUpdateRequest("Grave");
        TipoSancion existing = RrhhTestFixtures.tipoSancion(id, "LEVE");
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        TipoSancionResponse result = service.actualizar(id, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.tipoSancionUpdateRequest("X")))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("desactivar() con ID existente sin sanciones -> desactiva lógicamente")
    void desactivar_idExistenteSinSanciones_desactivaLogicamente() {
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(validator).validarNoEnUsoEnSanciones(1L);
        when(repository.save(entity)).thenReturn(entity);

        var result = service.desactivar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(validator).validarNoEnUsoEnSanciones(1L);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("desactivar() con sanciones activas -> lanza BusinessException")
    void desactivar_conSancionesActivas_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.tipoSancion(1L, "LEVE")));
        doThrow(new BusinessException("No se puede eliminar un tipo de sanción con sanciones asociadas.", null, "RH-TS-005"))
                .when(validator).validarNoEnUsoEnSanciones(1L);

        assertThatThrownBy(() -> service.desactivar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede eliminar");
        verify(validator).validarNoEnUsoEnSanciones(1L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    // ══════════════════════════════════════════════════════════════
    // activar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("activar() con ID existente -> cambia flagEstado a 1")
    void activar_idExistente_cambiaEstado() {
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
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
        TipoSancion entity = RrhhTestFixtures.tipoSancion(1L, "LEVE");
        TipoSancionResponse response = RrhhTestFixtures.tipoSancionResponse(1L, "LEVE", "Sanción LEVE");
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        List<TipoSancionResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    @Test
    @DisplayName("listarActivos() cuando no hay activos -> retorna lista vacía")
    void listarActivos_sinActivos_retornaListaVacia() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        List<TipoSancionResponse> result = service.listarActivos();

        assertThat(result).isEmpty();
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }
}
