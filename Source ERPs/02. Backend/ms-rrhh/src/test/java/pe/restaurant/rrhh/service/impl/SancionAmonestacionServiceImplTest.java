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
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionCreateRequest;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.SancionAmonestacionResponse;
import pe.restaurant.rrhh.entity.SancionAmonestacion;
import pe.restaurant.rrhh.mapper.SancionAmonestacionMapper;
import pe.restaurant.rrhh.repository.SancionAmonestacionRepository;
import pe.restaurant.rrhh.validation.SancionAmonestacionValidator;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SancionAmonestacionServiceImpl — Pruebas Unitarias")
class SancionAmonestacionServiceImplTest {

    @Mock
    private SancionAmonestacionRepository repository;

    @Mock
    private SancionAmonestacionValidator validator;

    @Mock
    private SancionAmonestacionMapper mapper;

    @InjectMocks
    private SancionAmonestacionServiceImpl service;

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
        List<SancionAmonestacion> entities = List.of(
            RrhhTestFixtures.sancionAmonestacion(1L),
            RrhhTestFixtures.sancionAmonestacion(2L)
        );
        Page<SancionAmonestacion> expectedPage = new PageImpl<>(entities);

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(expectedPage);
        when(mapper.toResponse(any())).thenAnswer(invocation -> {
            SancionAmonestacion e = invocation.getArgument(0);
            return RrhhTestFixtures.sancionAmonestacionResponse(e.getId());
        });

        Page<SancionAmonestacionResponse> result = service.listar(null, null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ══════════════════════════════════════════════════════════════
    // obtenerPorId()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_idExistente_retornaDTO() {
        SancionAmonestacion entity = RrhhTestFixtures.sancionAmonestacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.sancionAmonestacionResponse(1L));

        SancionAmonestacionResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
    }

    // ══════════════════════════════════════════════════════════════
    // crear()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("crear() -> valida, crea y retorna DTO")
    void crear_validaYCrea() {
        SancionAmonestacionCreateRequest request = RrhhTestFixtures.sancionAmonestacionCreateRequest();
        SancionAmonestacion entity = RrhhTestFixtures.sancionAmonestacion(null);
        SancionAmonestacion saved = RrhhTestFixtures.sancionAmonestacion(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(RrhhTestFixtures.sancionAmonestacionResponse(1L));

        SancionAmonestacionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarTrabajador(request.getTrabajadorId());
        verify(validator).validarTipoSancion(request.getTipoSancionId());
        verify(validator).validarFechaNoFutura(request.getFecha());
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    // actualizar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> actualiza y retorna DTO")
    void actualizar_actualizaYRetornaDTO() {
        SancionAmonestacionUpdateRequest request = RrhhTestFixtures.sancionAmonestacionUpdateRequest();
        SancionAmonestacion existing = RrhhTestFixtures.sancionAmonestacion(1L);
        SancionAmonestacion updated = RrhhTestFixtures.sancionAmonestacion(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.sancionAmonestacionResponse(1L));

        SancionAmonestacionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        SancionAmonestacionUpdateRequest request = RrhhTestFixtures.sancionAmonestacionUpdateRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con nuevo tipo sanción y fecha -> valida tipo y fecha")
    void actualizar_conNuevoTipoSancionYFecha_validaTipoYFecha() {
        SancionAmonestacion existing = RrhhTestFixtures.sancionAmonestacion(1L);
        SancionAmonestacionUpdateRequest request = new SancionAmonestacionUpdateRequest();
        request.setTipoSancionId(2L);
        request.setFecha(LocalDate.of(2026, 2, 1));
        request.setMotivo("Motivo actualizado");

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        when(mapper.toResponse(existing)).thenReturn(RrhhTestFixtures.sancionAmonestacionResponse(1L));

        SancionAmonestacionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(validator).validarTipoSancion(2L);
        verify(validator).validarFechaNoFutura(LocalDate.of(2026, 2, 1));
    }

    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> desactiva (baja lógica)")
    void eliminar_desactivaBajaLogica() {
        SancionAmonestacion entity = RrhhTestFixtures.sancionAmonestacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza BusinessException")
    void eliminar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any(SancionAmonestacion.class));
    }
}
