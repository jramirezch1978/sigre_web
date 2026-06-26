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
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoNovedadRrhhResponse;
import pe.restaurant.rrhh.entity.TipoNovedadRrhh;
import pe.restaurant.rrhh.mapper.TipoNovedadRrhhMapper;
import pe.restaurant.rrhh.repository.TipoNovedadRrhhRepository;
import pe.restaurant.rrhh.validation.TipoNovedadRrhhValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoNovedadRrhhServiceImpl — Pruebas Unitarias")
class TipoNovedadRrhhServiceImplTest {

    @Mock
    private TipoNovedadRrhhRepository repository;

    @Mock
    private TipoNovedadRrhhValidator validator;

    @Mock
    private TipoNovedadRrhhMapper mapper;

    @InjectMocks
    private TipoNovedadRrhhServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    // ══════════════════════════════════════════════════════════════
    // listar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<TipoNovedadRrhh> entities = List.of(
            RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso"),
            RrhhTestFixtures.tipoNovedadRrhh(2L, "FAL", "Falta")
        );
        Page<TipoNovedadRrhh> expectedPage = new PageImpl<>(entities);

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(expectedPage);
        when(mapper.toResponse(any())).thenAnswer(invocation -> {
            TipoNovedadRrhh e = invocation.getArgument(0);
            return RrhhTestFixtures.tipoNovedadRrhhResponse(e.getId(), e.getCodigo(), e.getNombre());
        });

        Page<TipoNovedadRrhhResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ══════════════════════════════════════════════════════════════
    // obtenerPorId()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_idExistente_retornaDTO() {
        TipoNovedadRrhh entity = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(
            RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "PER", "Permiso"));

        TipoNovedadRrhhResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getCodigo()).isEqualTo("PER");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    // ══════════════════════════════════════════════════════════════
    // crear()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("crear() -> valida, crea y retorna DTO")
    void crear_validaYCrea() {
        TipoNovedadRrhhCreateRequest request = RrhhTestFixtures.tipoNovedadRrhhCreateRequest("PER", "Permiso");
        TipoNovedadRrhh entity = RrhhTestFixtures.tipoNovedadRrhh(null, "PER", "Permiso");
        TipoNovedadRrhh saved = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(
            RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "PER", "Permiso"));

        TipoNovedadRrhhResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarCodigoUnico("PER");
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    // actualizar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> actualiza y retorna DTO")
    void actualizar_actualizaYRetornaDTO() {
        TipoNovedadRrhhUpdateRequest request = RrhhTestFixtures.tipoNovedadRrhhUpdateRequest("Permiso Personal", "1");
        TipoNovedadRrhh existing = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");
        TipoNovedadRrhh updated = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso Personal");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(
            RrhhTestFixtures.tipoNovedadRrhhResponse(1L, "PER", "Permiso Personal"));

        TipoNovedadRrhhResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getNombre()).isEqualTo("Permiso Personal");
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        TipoNovedadRrhhUpdateRequest request = RrhhTestFixtures.tipoNovedadRrhhUpdateRequest("Permiso", "1");
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> valida y desactiva (baja lógica)")
    void eliminar_validaYDesactiva() {
        TipoNovedadRrhh existing = RrhhTestFixtures.tipoNovedadRrhh(1L, "PER", "Permiso");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.desactivar(1L);

        assertThat(existing.getFlagEstado()).isEqualTo("0");
        verify(validator).validarNoEnUsoEnNovedadesActivas(1L);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
        verify(validator, never()).validarNoEnUsoEnNovedadesActivas(any());
        verify(repository, never()).save(any(TipoNovedadRrhh.class));
    }
}
