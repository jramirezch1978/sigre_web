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
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.SolicitarGoceRequest;
import com.sigre.rrhh.dto.request.VacacionCreateRequest;
import com.sigre.rrhh.dto.request.VacacionObservarRequest;
import com.sigre.rrhh.dto.request.VacacionUpdateRequest;
import com.sigre.rrhh.dto.response.SaldoVacacionDto;
import com.sigre.rrhh.dto.response.VacacionResponse;
import com.sigre.rrhh.entity.Vacacion;
import com.sigre.rrhh.mapper.VacacionMapper;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.repository.VacacionRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("VacacionServiceImpl — Pruebas Unitarias")
class VacacionServiceImplTest {

    @Mock
    private VacacionRepository repository;

    @Mock
    private TrabajadorRepository trabajadorRepository;

    @Mock
    private VacacionMapper mapper;

    @InjectMocks
    private VacacionServiceImpl service;

    @Captor
    private ArgumentCaptor<Vacacion> captor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            Vacacion v = inv.getArgument(0);
            VacacionResponse r = new VacacionResponse();
            r.setId(v.getId());
            r.setTrabajadorId(v.getTrabajadorId());
            r.setPeriodoAnio(v.getPeriodoAnio());
            r.setDiasDerecho(v.getDiasDerecho());
            r.setDiasGozados(v.getDiasGozados());
            r.setDiasPendientes(v.getDiasPendientes());
            r.setFlagEstado(v.getFlagEstado());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        when(repository.findAll(any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.vacacion(1L))));

        Page<VacacionResponse> result = service.listar(null, null, null, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro trabajador -> usa findByTrabajadorId")
    void listar_conFiltroTrabajador_usaFindByTrabajadorId() {
        when(repository.findByTrabajadorId(eq(1L), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, null, null, Pageable.ofSize(10));

        verify(repository).findByTrabajadorId(1L, Pageable.ofSize(10));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna vacación")
    void obtenerPorId_idExistente_retornaVacacion() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        VacacionResponse result = service.obtenerPorId(1L);

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
                .hasMessageContaining("Vacacion");
    }

    @Test
    @DisplayName("crear() con datos válidos -> guarda vacación")
    void crear_datosValidos_guardaVacacion() {
        VacacionCreateRequest request = RrhhTestFixtures.vacacionCreateRequest();
        when(repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(any(), any(), any())).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.crear(request);

        assertThat(result).isNotNull();
        verify(repository).save(captor.capture());
        Vacacion saved = captor.getValue();
        assertThat(saved.getTrabajadorId()).isEqualTo(1L);
        assertThat(saved.getPeriodoAnio()).isEqualTo(2026);
        assertThat(saved.getDiasDerecho()).isEqualTo(30);
        assertThat(saved.getDiasPendientes()).isEqualTo(30);
        assertThat(saved.getCreatedBy()).isEqualTo(1L);
        assertThat(saved.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("crear() con período duplicado -> lanza BusinessException")
    void crear_periodoDuplicado_lanzaBusinessException() {
        VacacionCreateRequest request = RrhhTestFixtures.vacacionCreateRequest();
        when(repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(any(), any(), any())).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza")
    void actualizar_idExistente_actualiza() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        VacacionUpdateRequest request = RrhhTestFixtures.vacacionUpdateRequest();
        service.actualizar(1L, request);

        assertThat(entity.getDiasDerecho()).isEqualTo(15);
        assertThat(entity.getDiasPendientes()).isEqualTo(15);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("solicitarGoce() con datos válidos -> cambia estado a 2 (Pendiente)")
    void solicitarGoce_datosValidos_cambiaEstadoAPendiente() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        SolicitarGoceRequest request = RrhhTestFixtures.solicitarGoceRequest();
        service.solicitarGoce(1L, request);

        assertThat(entity.getFlagEstado()).isEqualTo("2");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("solicitarGoce() con días excedidos -> lanza BusinessException")
    void solicitarGoce_diasExcedidos_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "1");
        entity.setDiasPendientes(5);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        SolicitarGoceRequest request = new SolicitarGoceRequest();
        request.setFechaInicio(java.time.LocalDate.of(2026, 3, 1));
        request.setFechaFin(java.time.LocalDate.of(2026, 3, 31));

        assertThatThrownBy(() -> service.solicitarGoce(1L, request))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("aprobar() con flagEstado legacy P -> normaliza y aprueba (3)")
    void aprobar_conLegacyP_cambiaAAprobado() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "P");
        entity.setFechaInicio(java.time.LocalDate.of(2026, 8, 1));
        entity.setFechaFin(java.time.LocalDate.of(2026, 8, 7));
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.aprobar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("3");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("aprobar() con estado pendiente -> cambia a 3 (Aprobado)")
    void aprobar_estadoPendiente_cambiaAAprobado() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.aprobar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("3");
        assertThat(entity.getDiasGozados()).isEqualTo(30);
        assertThat(entity.getDiasPendientes()).isEqualTo(0);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("aprobar() con estado no pendiente -> lanza BusinessException")
    void aprobar_estadoNoPendiente_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "3");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("rechazar() con estado pendiente -> cambia a 4 (Rechazado)")
    void rechazar_estadoPendiente_cambiaARechazado() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.rechazar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("4");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("reprogramar() desde aprobado -> reabre solicitud como pendiente")
    void reprogramar_desdeAprobado_reabreSolicitud() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "3");
        entity.setDiasGozados(30);
        entity.setDiasPendientes(0);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        SolicitarGoceRequest request = new SolicitarGoceRequest();
        request.setFechaInicio(java.time.LocalDate.of(2026, 4, 1));
        request.setFechaFin(java.time.LocalDate.of(2026, 4, 10));
        service.reprogramar(1L, request);

        assertThat(entity.getFlagEstado()).isEqualTo("2");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("desactivar() -> cambia estado a 0")
    void desactivar_cambiaEstadoAInactivo() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("observar() con estado pendiente -> vuelve a 2 (Pendiente)")
    void observar_estadoPendiente_cambiaAObservado() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        VacacionObservarRequest request = new VacacionObservarRequest("Revisar documentos");
        service.observar(1L, request);

        assertThat(entity.getFlagEstado()).isEqualTo("2");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("observar() con flagEstado no permitido -> lanza BusinessException")
    void observar_flagEstadoNoPermitido_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "5"); // cerrado
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.observar(1L, new VacacionObservarRequest("test")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden observar");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("anular() con estado pendiente -> cambia a 0")
    void anular_estadoActivo_cambiaAInactivo() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "2");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.anular(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("anular() con estado ya anulado -> lanza BusinessException")
    void anular_estadoAnulado_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("anular() con estado cerrado -> lanza BusinessException")
    void anular_estadoCerrado_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "5");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No se puede anular");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("cerrar() con estado aprobado -> cambia a 5 (Cerrado)")
    void cerrar_estadoAprobado_cambiaACerrado() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "3");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.cerrar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("5");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("cerrar() con estado no aprobable -> lanza BusinessException")
    void cerrar_estadoNoAprobable_lanzaBusinessException() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    // ══════════════════════════════════════════════════════════════
    //  CONSULTAS Y PROCESOS BATCH
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("procesar() con trabajadores activos -> crea vacaciones")
    void procesar_conTrabajadoresActivos_creaVacaciones() {
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L, 2L));
        when(repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(anyLong(), anyInt(), anyList())).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.procesar(2026);

        verify(repository, times(2)).save(any());
        verify(repository).existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(1L, 2026, List.of("0", "5"));
        verify(repository).existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(2L, 2026, List.of("0", "5"));
    }

    @Test
    @DisplayName("procesar() sin trabajadores nuevos -> lanza BusinessException")
    void procesar_sinTrabajadoresNuevos_lanzaBusinessException() {
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L));
        when(repository.existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(anyLong(), anyInt(), anyList())).thenReturn(true);

        assertThatThrownBy(() -> service.procesar(2026))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("bandejaAprobacion() con filtro -> retorna página")
    void bandejaAprobacion_conFiltro_retornaPagina() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L, "2");
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<VacacionResponse> result = service.bandejaAprobacion(2026, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("bandejaAprobacion() sin filtro -> usa periodoAnio null")
    void bandejaAprobacion_sinFiltro_usaPeriodoNull() {
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class)))
                .thenReturn(Page.empty());

        Page<VacacionResponse> result = service.bandejaAprobacion(null, Pageable.ofSize(10));

        assertThat(result).isNotNull();
        assertThat(result.getContent()).isEmpty();
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("consultarSaldos() con datos -> retorna lista de saldos")
    void consultarSaldos_conDatos_retornaLista() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class)))
                .thenReturn(List.of(entity));

        List<SaldoVacacionDto> result = service.consultarSaldos(2026);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).trabajadorId()).isEqualTo(1L);
        assertThat(result.get(0).periodoAnio()).isEqualTo(2026);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class));
    }

    @Test
    @DisplayName("consultarSaldos() sin datos -> retorna lista vacía")
    void consultarSaldos_sinDatos_retornaListaVacia() {
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class)))
                .thenReturn(List.of());

        List<SaldoVacacionDto> result = service.consultarSaldos(2026);

        assertThat(result).isEmpty();
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class));
    }

    @Test
    @DisplayName("consultarSaldos() con periodoAnio null -> retorna todos los saldos")
    void consultarSaldos_periodoAnioNull_retornaSaldos() {
        Vacacion entity = RrhhTestFixtures.vacacion(1L);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class)))
                .thenReturn(List.of(entity));

        List<SaldoVacacionDto> result = service.consultarSaldos(null);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).trabajadorId()).isEqualTo(1L);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class));
    }
}
