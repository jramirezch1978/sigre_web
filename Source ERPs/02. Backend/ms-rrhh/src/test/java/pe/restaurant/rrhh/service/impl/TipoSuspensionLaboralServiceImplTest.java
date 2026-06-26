package pe.restaurant.rrhh.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSuspensionLaboralResponse;
import pe.restaurant.rrhh.entity.TipoSuspensionLaboral;
import pe.restaurant.rrhh.mapper.TipoSuspensionLaboralMapper;
import pe.restaurant.rrhh.repository.TipoSuspensionLaboralRepository;
import pe.restaurant.rrhh.specification.TipoSuspensionLaboralSpecification;
import pe.restaurant.rrhh.validation.TipoSuspensionLaboralValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoSuspensionLaboralServiceImpl — Pruebas Unitarias")
class TipoSuspensionLaboralServiceImplTest {

    @Mock
    private TipoSuspensionLaboralRepository repository;

    @Mock
    private TipoSuspensionLaboralMapper mapper;

    @Mock
    private TipoSuspensionLaboralValidator validator;

    @InjectMocks
    private TipoSuspensionLaboralServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            TipoSuspensionLaboral entity = inv.getArgument(0);
            TipoSuspensionLaboralResponse r = new TipoSuspensionLaboralResponse();
            r.setId(entity.getId());
            r.setCodigo(entity.getCodigo());
            r.setNombre(entity.getNombre());
            r.setFlagEstado(entity.getFlagEstado());
            r.setFlagTipoSusp(entity.getFlagTipoSusp());
            r.setFlagCitt(entity.getFlagCitt());
            r.setTipoSubsidioId(entity.getTipoSubsidioId());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<TipoSuspensionLaboral> list = List.of(
                RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC"),
                RrhhTestFixtures.tipoSuspensionLaboral(2L, "ENF")
        );
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(list));

        Page<TipoSuspensionLaboralResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        List<TipoSuspensionLaboral> list = List.of(RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC"));
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(list));

        Page<TipoSuspensionLaboralResponse> result = service.listar("VAC", "Vacaciones", "1", pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() {
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        TipoSuspensionLaboralResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("VAC");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("TipoSuspensionLaboral");
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("crear() con código único -> crea exitosamente")
    void crear_codigoUnico_creaExitosamente() {
        TipoSuspensionLaboralCreateRequest request = RrhhTestFixtures.tipoSuspensionLaboralCreateRequest("VAC", "Vacaciones");
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        doNothing().when(validator).validarCodigoUnico("VAC");
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(entity);

        TipoSuspensionLaboralResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarCodigoUnico("VAC");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("crear() con código duplicado -> lanza excepción del validator")
    void crear_codigoDuplicado_lanzaExcepcion() {
        TipoSuspensionLaboralCreateRequest request = RrhhTestFixtures.tipoSuspensionLaboralCreateRequest("VAC", "Vacaciones");
        doThrow(new BusinessException("Ya existe un código", null, "RH-TSL-001"))
                .when(validator).validarCodigoUnico("VAC");

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe un código");
        verify(validator).validarCodigoUnico("VAC");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza exitosamente")
    void actualizar_idExistente_actualizaExitosamente() {
        Long id = 1L;
        TipoSuspensionLaboralUpdateRequest request = RrhhTestFixtures.tipoSuspensionLaboralUpdateRequest("Vacaciones Actualizado");
        TipoSuspensionLaboral existing = RrhhTestFixtures.tipoSuspensionLaboral(id, "VAC");
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);

        TipoSuspensionLaboralResponse result = service.actualizar(id, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.tipoSuspensionLaboralUpdateRequest("X")))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("desactivar() con ID existente sin permisos -> desactiva lógicamente")
    void desactivar_idExistenteSinPermisos_desactivaLogicamente() {
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(validator).validarNoEnUsoEnPermisos(1L);
        when(repository.save(entity)).thenReturn(entity);

        var result = service.desactivar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(validator).validarNoEnUsoEnPermisos(1L);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("desactivar() con ID existente en uso en permisos -> lanza BusinessException")
    void desactivar_idExistenteEnUso_lanzaBusinessException() {
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doThrow(new BusinessException("No se puede desactivar, está en uso en permisos", null, "RH-TSL-002"))
                .when(validator).validarNoEnUsoEnPermisos(1L);

        assertThatThrownBy(() -> service.desactivar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("en uso en permisos");
        verify(validator).validarNoEnUsoEnPermisos(1L);
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
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        var result = service.activar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
    }

    @Test
    @DisplayName("activar() con ID inexistente -> lanza ResourceNotFoundException")
    void activar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activar(999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    // ══════════════════════════════════════════════════════════════
    // listarActivos()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("listarActivos() -> retorna solo activos")
    void listarActivos_retornaActivos() {
        TipoSuspensionLaboral entity = RrhhTestFixtures.tipoSuspensionLaboral(1L, "VAC");
        TipoSuspensionLaboralResponse response = RrhhTestFixtures.tipoSuspensionLaboralResponse(1L, "VAC", "Vacaciones");
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        List<TipoSuspensionLaboralResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    @Test
    @DisplayName("listarActivos() cuando no hay activos -> retorna lista vacía")
    void listarActivos_sinActivos_retornaListaVacia() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        List<TipoSuspensionLaboralResponse> result = service.listarActivos();

        assertThat(result).isEmpty();
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }
}
