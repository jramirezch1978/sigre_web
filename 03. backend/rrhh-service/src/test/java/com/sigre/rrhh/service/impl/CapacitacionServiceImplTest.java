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
import com.sigre.rrhh.dto.request.CapacitacionCreateRequest;
import com.sigre.rrhh.dto.request.CapacitacionUpdateRequest;
import com.sigre.rrhh.dto.request.CapacitacionTrabajadorRequest;
import com.sigre.rrhh.dto.response.CapacitacionResponse;
import com.sigre.rrhh.dto.response.CapacitacionTrabajadorResponse;
import com.sigre.rrhh.entity.Capacitacion;
import com.sigre.rrhh.entity.CapacitacionTrabajador;
import com.sigre.rrhh.mapper.CapacitacionMapper;
import com.sigre.rrhh.mapper.CapacitacionTrabajadorMapper;
import com.sigre.rrhh.repository.CapacitacionRepository;
import com.sigre.rrhh.repository.CapacitacionTrabajadorRepository;
import com.sigre.rrhh.validation.CapacitacionValidator;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CapacitacionServiceImpl — Pruebas Unitarias")
class CapacitacionServiceImplTest {

    @Mock
    private CapacitacionRepository repository;

    @Mock
    private CapacitacionTrabajadorRepository ctRepository;

    @Mock
    private CapacitacionMapper mapper;

    @Mock
    private CapacitacionTrabajadorMapper ctMapper;

    @Mock
    private CapacitacionValidator validator;

    @InjectMocks
    private CapacitacionServiceImpl service;

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
        List<Capacitacion> entities = List.of(
            RrhhTestFixtures.capacitacion(1L),
            RrhhTestFixtures.capacitacion(2L)
        );
        Page<Capacitacion> expectedPage = new PageImpl<>(entities);

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(expectedPage);
        when(mapper.toResponse(any())).thenAnswer(invocation -> {
            Capacitacion e = invocation.getArgument(0);
            return RrhhTestFixtures.capacitacionResponse(e.getId());
        });

        Page<CapacitacionResponse> result = service.listar(null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro nombre -> pasa filtro al spec")
    void listar_conFiltroNombre_pasaFiltroAlSpec() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(Page.empty());

        service.listar("Capacitación Test", null, pageable);

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ══════════════════════════════════════════════════════════════
    // obtenerPorId()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_idExistente_retornaDTO() {
        Capacitacion entity = RrhhTestFixtures.capacitacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        CapacitacionResponse result = service.obtenerPorId(1L);

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
    @DisplayName("crear() -> valida fechas, crea y retorna DTO")
    void crear_validaYCrea() {
        CapacitacionCreateRequest request = RrhhTestFixtures.capacitacionCreateRequest();
        Capacitacion entity = RrhhTestFixtures.capacitacion(null);
        Capacitacion saved = RrhhTestFixtures.capacitacion(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        CapacitacionResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarFechas(request.getFechaInicio(), request.getFechaFin());
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    // actualizar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> actualiza y retorna DTO")
    void actualizar_actualizaYRetornaDTO() {
        CapacitacionUpdateRequest request = RrhhTestFixtures.capacitacionUpdateRequest();
        Capacitacion existing = RrhhTestFixtures.capacitacion(1L);
        Capacitacion updated = RrhhTestFixtures.capacitacion(1L);
        updated.setNombre("Capacitación Actualizada");
        updated.setHoras(30);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        CapacitacionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con nuevas fechas -> usa fechas del request para validar")
    void actualizar_conNuevasFechas_usaFechasDelRequest() {
        CapacitacionUpdateRequest request = new CapacitacionUpdateRequest();
        request.setFechaInicio(LocalDate.of(2026, 4, 1));
        request.setFechaFin(LocalDate.of(2026, 4, 5));
        request.setNombre("Test");
        Capacitacion existing = RrhhTestFixtures.capacitacion(1L);
        Capacitacion updated = RrhhTestFixtures.capacitacion(1L);
        updated.setFechaInicio(LocalDate.of(2026, 4, 1));
        updated.setFechaFin(LocalDate.of(2026, 4, 5));

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.capacitacionResponse(1L));

        CapacitacionResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(validator).validarFechas(LocalDate.of(2026, 4, 1), LocalDate.of(2026, 4, 5));
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        CapacitacionUpdateRequest request = RrhhTestFixtures.capacitacionUpdateRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> valida participantes y desactiva")
    void eliminar_validaParticipantesYDesactiva() {
        Capacitacion entity = RrhhTestFixtures.capacitacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(validator).validarSinParticipantes(1L);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza BusinessException")
    void eliminar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any(Capacitacion.class));
    }

    // ══════════════════════════════════════════════════════════════
    // listarParticipantes()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("listarParticipantes() -> retorna lista de participantes")
    void listarParticipantes_retornaLista() {
        List<CapacitacionTrabajador> entities = List.of(
            RrhhTestFixtures.capacitacionTrabajador(1L, 1L),
            RrhhTestFixtures.capacitacionTrabajador(2L, 1L)
        );
        when(ctRepository.findByCapacitacionId(1L)).thenReturn(entities);
        when(ctMapper.toResponseList(entities)).thenReturn(List.of(
            RrhhTestFixtures.capacitacionTrabajadorResponse(1L, 1L),
            RrhhTestFixtures.capacitacionTrabajadorResponse(2L, 1L)
        ));

        List<CapacitacionTrabajadorResponse> result = service.listarParticipantes(1L);

        assertThat(result).hasSize(2);
        verify(ctRepository).findByCapacitacionId(1L);
    }

    // ══════════════════════════════════════════════════════════════
    // agregarParticipante()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("agregarParticipante() -> valida, crea y retorna DTO")
    void agregarParticipante_validaYCrea() {
        Capacitacion capacitacion = RrhhTestFixtures.capacitacion(1L);
        CapacitacionTrabajadorRequest request = RrhhTestFixtures.capacitacionTrabajadorRequest();
        CapacitacionTrabajador entity = new CapacitacionTrabajador();
        entity.setCapacitacionId(1L);
        entity.setTrabajadorId(2L);
        CapacitacionTrabajador saved = RrhhTestFixtures.capacitacionTrabajador(3L, 1L);

        when(repository.findById(1L)).thenReturn(Optional.of(capacitacion));
        when(ctMapper.toEntity(request)).thenReturn(entity);
        when(ctRepository.save(entity)).thenReturn(saved);
        when(ctMapper.toResponse(saved)).thenReturn(RrhhTestFixtures.capacitacionTrabajadorResponse(3L, 1L));

        CapacitacionTrabajadorResponse result = service.agregarParticipante(1L, request);

        assertThat(result).isNotNull();
        verify(validator).validarTrabajador(request.getTrabajadorId());
        verify(validator).validarParticipanteNoDuplicado(1L, request.getTrabajadorId());
        verify(ctRepository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    // eliminarParticipante()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("eliminarParticipante() -> elimina participante existente")
    void eliminarParticipante_eliminaExistente() {
        CapacitacionTrabajador ct = RrhhTestFixtures.capacitacionTrabajador(1L, 1L);
        when(ctRepository.findByCapacitacionIdAndTrabajadorId(1L, 1L)).thenReturn(Optional.of(ct));

        service.eliminarParticipante(1L, 1L);

        verify(ctRepository).delete(ct);
    }

    @Test
    @DisplayName("eliminarParticipante() con participante inexistente -> lanza BusinessException")
    void eliminarParticipante_inexistente_lanzaBusinessException() {
        when(ctRepository.findByCapacitacionIdAndTrabajadorId(1L, 999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.eliminarParticipante(1L, 999L))
            .isInstanceOf(BusinessException.class);
        verify(ctRepository, never()).delete(any());
    }
}
