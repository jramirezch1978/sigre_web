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
import com.sigre.rrhh.constants.PermisoLicenciaConstants;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.entity.PermisoLicenciaDet;
import com.sigre.rrhh.mapper.PermisoLicenciaMapper;
import java.time.LocalDate;
import com.sigre.rrhh.repository.PermisoLicenciaDetRepository;
import com.sigre.rrhh.repository.PermisoLicenciaRepository;
import com.sigre.rrhh.validation.PermisoLicenciaValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PermisoLicenciaServiceImpl — Pruebas Unitarias")
class PermisoLicenciaServiceImplTest {

    @Mock
    private PermisoLicenciaRepository repository;

    @Mock
    private PermisoLicenciaDetRepository detRepository;

    @Mock
    private PermisoLicenciaValidator validator;

    @Mock
    private PermisoLicenciaMapper mapper;

    @InjectMocks
    private PermisoLicenciaServiceImpl service;

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
        List<PermisoLicencia> entities = List.of(
            RrhhTestFixtures.permisoLicencia(1L),
            RrhhTestFixtures.permisoLicencia(2L)
        );
        Page<PermisoLicencia> expectedPage = new PageImpl<>(entities);

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(expectedPage);
        when(mapper.toResponse(any())).thenAnswer(invocation -> {
            PermisoLicencia e = invocation.getArgument(0);
            return RrhhTestFixtures.permisoLicenciaResponse(e.getId());
        });

        Page<PermisoLicenciaResponse> result = service.listar(null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(2);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro trabajador -> pasa el filtro al spec")
    void listar_conFiltroTrabajador_pasaFiltroAlSpec() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(Page.empty());

        service.listar(1L, null, null, null, pageable);

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ══════════════════════════════════════════════════════════════
    // obtenerPorId()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_idExistente_retornaDTO() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.obtenerPorId(1L);

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
        PermisoLicenciaCreateRequest request = RrhhTestFixtures.permisoLicenciaCreateRequest();
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(null);
        PermisoLicencia saved = RrhhTestFixtures.permisoLicencia(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(any(PermisoLicencia.class))).thenAnswer(invocation -> {
            PermisoLicencia p = invocation.getArgument(0);
            if (p.getId() == null) {
                p.setId(1L);
            }
            return p;
        });
        when(mapper.toResponse(any(PermisoLicencia.class))).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarTrabajador(request.getTrabajadorId());
        verify(validator).validarTipoSuspension(request.getTipoSuspensionLaboralId());
        verify(validator).validarFechas(request.getFechaInicio(), request.getFechaFin());
        verify(validator).validarSinSolapamiento(request.getTrabajadorId(), request.getFechaInicio(), request.getFechaFin(), null);
        verify(mapper).toEntity(request);
        verify(repository, times(1)).save(any(PermisoLicencia.class));
        verify(detRepository).save(any(PermisoLicenciaDet.class));
    }

    // ══════════════════════════════════════════════════════════════
    // actualizar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> actualiza y retorna DTO")
    void actualizar_actualizaYRetornaDTO() {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequest();
        PermisoLicencia existing = RrhhTestFixtures.permisoLicencia(1L);
        PermisoLicenciaDet det = RrhhTestFixtures.permisoLicenciaDet(10L, 1L);
        PermisoLicencia updated = RrhhTestFixtures.permisoLicencia(1L);
        updated.setDiasTotales(5);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(detRepository.findFirstByPermisoLicenciaIdOrderByItemAsc(1L)).thenReturn(Optional.of(det));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con tipo suspensión nuevo -> valida el tipo")
    void actualizar_conTipoSuspensionNuevo_validaTipo() {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequestConNuevoTipo();
        PermisoLicencia existing = RrhhTestFixtures.permisoLicencia(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(detRepository.findFirstByPermisoLicenciaIdOrderByItemAsc(1L)).thenReturn(Optional.empty());

        service.actualizar(1L, request);

        verify(validator).validarTipoSuspension(2L);
    }

    @Test
    @DisplayName("actualizar() sin fechas -> omite validación de solapamiento")
    void actualizar_sinFechas_omiteSolapamiento() {
        PermisoLicenciaUpdateRequest request = new PermisoLicenciaUpdateRequest();
        request.setFlagEstado("1");
        PermisoLicencia existing = RrhhTestFixtures.permisoLicencia(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(detRepository.findFirstByPermisoLicenciaIdOrderByItemAsc(1L)).thenReturn(Optional.empty());
        when(repository.save(existing)).thenReturn(existing);
        when(mapper.toResponse(existing)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(validator, never()).validarSinSolapamiento(any(), any(), any(), any());
    }

    @Test
    @DisplayName("actualizar() con nuevas fechas -> valida solapamiento")
    void actualizar_conNuevasFechas_validaSolapamiento() {
        PermisoLicenciaUpdateRequest request = new PermisoLicenciaUpdateRequest();
        request.setFechaInicio(LocalDate.of(2026, 3, 1));
        request.setFechaFin(LocalDate.of(2026, 3, 5));
        request.setFlagEstado("1");
        PermisoLicencia existing = RrhhTestFixtures.permisoLicencia(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(detRepository.findFirstByPermisoLicenciaIdOrderByItemAsc(1L))
                .thenReturn(Optional.of(RrhhTestFixtures.permisoLicenciaDet(10L, 1L)));
        when(repository.save(existing)).thenReturn(existing);
        when(mapper.toResponse(existing)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(validator).validarSinSolapamiento(1L, LocalDate.of(2026, 3, 1), LocalDate.of(2026, 3, 5), 1L);
        verify(detRepository).save(any(PermisoLicenciaDet.class));
    }

    // ══════════════════════════════════════════════════════════════
    // aprobar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("aprobar() con flagEstado legacy P -> normaliza y aprueba (2)")
    void aprobar_conLegacyP_cambiaFlagEstadoA2() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "P");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        service.aprobar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("2");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("aprobar() -> cambia flagEstado a 2")
    void aprobar_cambiaFlagEstadoA2() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
        PermisoLicencia approved = RrhhTestFixtures.permisoLicencia(1L, "2");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(approved);
        when(mapper.toResponse(approved)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.aprobar(1L);

        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("rechazar() con permiso ya aprobado -> lanza BusinessException")
    void rechazar_yaAprobado_lanzaBusinessException() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.rechazar(1L))
            .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // cerrar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("cerrar() con permiso aprobado -> cambia flagEstado a 5")
    void cerrar_conPermisoAprobado_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        PermisoLicencia closed = RrhhTestFixtures.permisoLicencia(1L, "5");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(closed);
        when(mapper.toResponse(closed)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.cerrar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("5");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("cerrar() con permiso no aprobado -> lanza BusinessException")
    void cerrar_conPermisoNoAprobado_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.cerrar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Solo se puede cerrar un permiso aprobado");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // procesar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("procesar() con permiso aprobado -> cambia flagEstado a 6")
    void procesar_conPermisoAprobado_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        PermisoLicencia processed = RrhhTestFixtures.permisoLicencia(1L, "6");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(processed);
        when(mapper.toResponse(processed)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.procesar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("6");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("procesar() con permiso no aprobado -> lanza BusinessException")
    void procesar_conPermisoNoAprobado_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.procesar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Solo se puede procesar un permiso aprobado");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // enviarPlanilla()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("enviarPlanilla() con permiso procesado -> cambia flagEstado a 7")
    void enviarPlanilla_conPermisoProcesado_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "6");
        PermisoLicencia sent = RrhhTestFixtures.permisoLicencia(1L, "7");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(sent);
        when(mapper.toResponse(sent)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.enviarPlanilla(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("7");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("enviarPlanilla() con permiso no procesado -> lanza BusinessException")
    void enviarPlanilla_conPermisoNoProcesado_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.enviarPlanilla(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El permiso debe estar procesado");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // reflejarBoleta()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("reflejarBoleta() con permiso en planilla -> cambia flagEstado a 8")
    void reflejarBoleta_conPermisoEnPlanilla_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "7");
        PermisoLicencia reflected = RrhhTestFixtures.permisoLicencia(1L, "8");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(reflected);
        when(mapper.toResponse(reflected)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.reflejarBoleta(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("8");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("reflejarBoleta() con permiso no en planilla -> lanza BusinessException")
    void reflejarBoleta_conPermisoNoEnPlanilla_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "6");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.reflejarBoleta(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El permiso debe estar en planilla");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // observar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("observar() con permiso pendiente -> cambia flagEstado a 3")
    void observar_conPermisoPendiente_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "1");
        PermisoLicencia observed = RrhhTestFixtures.permisoLicencia(1L, "3");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(observed);
        when(mapper.toResponse(observed)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.observar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("3");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("observar() con permiso no pendiente -> lanza BusinessException")
    void observar_conPermisoNoPendiente_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.observar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El permiso no está en estado pendiente");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // anular()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("anular() con permiso pendiente -> cambia flagEstado a 4")
    void anular_conPermisoPendiente_cambiaEstado() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "1");
        PermisoLicencia anulled = RrhhTestFixtures.permisoLicencia(1L, "4");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(anulled);
        when(mapper.toResponse(anulled)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.anular(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("4");
        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("anular() con permiso no pendiente -> lanza BusinessException")
    void anular_conPermisoNoPendiente_lanzaError() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("El permiso no está en estado pendiente");
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════
    // rechazar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("rechazar() -> cambia flagEstado a 0")
    void rechazar_cambiaFlagEstadoA0() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
        PermisoLicencia rejected = RrhhTestFixtures.permisoLicencia(1L, "0");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(rejected);
        when(mapper.toResponse(rejected)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        PermisoLicenciaResponse result = service.rechazar(1L);

        assertThat(result).isNotNull();
        verify(repository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("eliminar() -> desactiva (baja lógica)")
    void eliminar_desactivaBajaLogica() {
        PermisoLicencia entity = RrhhTestFixtures.permisoLicencia(1L);
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
        verify(repository, never()).save(any(PermisoLicencia.class));
    }

    // ══════════════════════════════════════════════════════════════
    // procesarBatch()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("procesarBatch() -> procesa todos los pendientes")
    void procesarBatch_procesaPendientes() {
        PermisoLicencia p1 = RrhhTestFixtures.permisoLicencia(1L, "A");
        PermisoLicencia p2 = RrhhTestFixtures.permisoLicencia(2L, "1");
        when(repository.findByFlagEstadoIn(any())).thenReturn(List.of(p1, p2));

        service.procesarBatch();

        assertThat(p1.getFlagEstado()).isEqualTo(PermisoLicenciaConstants.ESTADO_PROCESADO);
        assertThat(p2.getFlagEstado()).isEqualTo(PermisoLicenciaConstants.ESTADO_PROCESADO);
        assertThat(p1.getUpdatedBy()).isEqualTo(1L);
        assertThat(p2.getUpdatedBy()).isEqualTo(1L);
        assertThat(p1.getFecModificacion()).isNotNull();
        assertThat(p2.getFecModificacion()).isNotNull();
        verify(repository).findByFlagEstadoIn(any());
        verify(repository).saveAll(List.of(p1, p2));
    }

    @Test
    @DisplayName("procesarBatch() sin pendientes -> no guarda nada")
    void procesarBatch_sinPendientes_noGuardaNada() {
        when(repository.findByFlagEstadoIn(any())).thenReturn(List.of());

        service.procesarBatch();

        verify(repository).findByFlagEstadoIn(any());
        verify(repository).saveAll(List.of());
    }
}
