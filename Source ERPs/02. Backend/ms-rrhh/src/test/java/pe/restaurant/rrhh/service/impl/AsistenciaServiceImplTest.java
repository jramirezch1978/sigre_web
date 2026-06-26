package pe.restaurant.rrhh.service.impl;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.response.AsistenciaResponse;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.AsistenciaImportarRequest;
import pe.restaurant.rrhh.dto.request.AsistenciaRegularizarRequest;
import pe.restaurant.rrhh.dto.response.AsistenciaResponse;
import pe.restaurant.rrhh.entity.Asistencia;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.mapper.AsistenciaMapper;
import pe.restaurant.rrhh.repository.AsistenciaRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AsistenciaServiceImpl — Pruebas Unitarias")
class AsistenciaServiceImplTest {

    @Mock private AsistenciaRepository asistenciaRepo;
    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private AsistenciaMapper mapper;

    @InjectMocks
    private AsistenciaServiceImpl service;

    @Captor
    private ArgumentCaptor<Asistencia> entityCaptor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    // ═══════════════════════════════════════════════════
    // listar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(asistenciaRepo.findWithFilters(any(), any(), any(), any(), any()))
            .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.asistencia(1L))));

        Page<Asistencia> result = service.listar(null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(asistenciaRepo).findWithFilters(null, null, null, null, pageable);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() {
        Pageable pageable = Pageable.ofSize(10);
        when(asistenciaRepo.findWithFilters(eq(1L), any(), any(), eq(2L), any()))
            .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 1, 31), 2L, pageable);

        verify(asistenciaRepo).findWithFilters(1L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 1, 31), 2L, pageable);
    }

    // ═══════════════════════════════════════════════════
    // obtenerPorId()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));

        Asistencia result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
            .isInstanceOf(BusinessException.class);
    }

    // ═══════════════════════════════════════════════════
    // crear()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("crear() -> valida, setea auditoría, guarda")
    void crear_validaYGuarda() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        entity.setFlagEstado(null);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);

        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(asistenciaRepo.existsTipoMovAsistenciaById(1L)).thenReturn(true);
        when(asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstado(1L, entity.getFecha(), "1")).thenReturn(false);
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.crear(entity);

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        assertThat(result.getFecCreacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("crear() con trabajador inactivo -> lanza RH-AS-001")
    void crear_trabajadorInactivo_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        Trabajador trabajador = RrhhTestFixtures.trabajadorInactivo(1L);

        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));

        assertThatThrownBy(() -> service.crear(entity))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("inactivo");
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("crear() con trabajador inexistente -> lanza RH-AS-001")
    void crear_trabajadorInexistente_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        when(trabajadorRepo.findById(any())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.crear(entity))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("crear() con registro duplicado -> lanza RH-AS-002")
    void crear_registroDuplicado_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);

        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(asistenciaRepo.existsTipoMovAsistenciaById(1L)).thenReturn(true);
        when(asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstado(1L, entity.getFecha(), "1")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(entity))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe");
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("crear() con horaSalida anterior a horaEntrada -> lanza RH-AS-003")
    void crear_horasInvalidas_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        entity.setHoraEntrada(LocalTime.of(17, 0));
        entity.setHoraSalida(LocalTime.of(8, 0));
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);

        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(asistenciaRepo.existsTipoMovAsistenciaById(1L)).thenReturn(true);
        when(asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstado(1L, entity.getFecha(), "1")).thenReturn(false);

        assertThatThrownBy(() -> service.crear(entity))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("posterior");
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("crear() -> calcula horas trabajadas y horas extra")
    void crear_calculaHoras() {
        Asistencia entity = RrhhTestFixtures.asistencia(null);
        entity.setHoraEntrada(LocalTime.of(8, 0));
        entity.setHoraSalida(LocalTime.of(18, 0));
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);

        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(asistenciaRepo.existsTipoMovAsistenciaById(1L)).thenReturn(true);
        when(asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstado(1L, entity.getFecha(), "1")).thenReturn(false);
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.crear(entity);

        assertThat(result.getHorasTrabajadas()).isEqualByComparingTo("10.00");
        assertThat(result.getHorasExtra()).isEqualByComparingTo("2.00");
    }

    // ═══════════════════════════════════════════════════
    // actualizar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> valida, actualiza y guarda")
    void actualizar_validaYGuarda() {
        Asistencia existing = RrhhTestFixtures.asistencia(1L);
        Asistencia datos = RrhhTestFixtures.asistencia(null);
        datos.setTrabajadorId(1L);
        datos.setFecha(LocalDate.of(2026, 2, 1));
        datos.setHoraEntrada(LocalTime.of(9, 0));
        datos.setHoraSalida(LocalTime.of(18, 0));
        datos.setTipoMovAsistenciaId(1L);
        Trabajador trabajador = RrhhTestFixtures.trabajador(1L);

        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(existing));
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(asistenciaRepo.existsTipoMovAsistenciaById(1L)).thenReturn(true);
        when(asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstadoAndIdNot(1L, LocalDate.of(2026, 2, 1), "1", 1L)).thenReturn(false);
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.actualizar(1L, datos);

        assertThat(result.getUpdatedBy()).isEqualTo(1L);
        assertThat(result.getFecModificacion()).isNotNull();
        assertThat(result.getFecha()).isEqualTo(LocalDate.of(2026, 2, 1));
        verify(asistenciaRepo).save(existing);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza error")
    void actualizar_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, new Asistencia()))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // anular()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("anular() -> cambia flagEstado a 0 y guarda")
    void anular_cambiaEstado() {
        Asistencia existing = RrhhTestFixtures.asistencia(1L);
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(existing));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        service.anular(1L);

        assertThat(existing.getFlagEstado()).isEqualTo("0");
        assertThat(existing.getUpdatedBy()).isEqualTo(1L);
        assertThat(existing.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(existing);
    }

    @Test
    @DisplayName("anular() con ID inexistente -> lanza error")
    void anular_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(999L))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // aprobar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("aprobar() con ID existente -> cambia estado a A")
    void aprobar_idExistente_cambiaEstado() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.aprobar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("A");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
        assertThat(result.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("aprobar() con ID inexistente -> lanza BusinessException")
    void aprobar_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.aprobar(999L))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("aprobar() con flagEstado no permitido -> lanza BusinessException")
    void aprobar_flagEstadoNoPermitido_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        entity.setFlagEstado("R"); // rechazado, no se puede aprobar
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.aprobar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden aprobar");
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // rechazar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("rechazar() con ID existente -> cambia estado a R")
    void rechazar_idExistente_cambiaEstado() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.rechazar(1L);

        assertThat(result.getFlagEstado()).isEqualTo("R");
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
        assertThat(result.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("rechazar() con ID inexistente -> lanza BusinessException")
    void rechazar_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.rechazar(999L))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("rechazar() con flagEstado no permitido -> lanza BusinessException")
    void rechazar_flagEstadoNoPermitido_lanzaError() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        entity.setFlagEstado("A"); // aprobado, no se puede rechazar
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.rechazar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Solo se pueden rechazar");
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // desactivar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("desactivar() con ID existente -> cambia flagEstado a 0")
    void desactivar_idExistente_cambiaEstado() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        service.desactivar(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        assertThat(entity.getUpdatedBy()).isEqualTo(1L);
        assertThat(entity.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza BusinessException")
    void desactivar_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // regularizar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("regularizar() con ID existente -> actualiza horaEntrada/horaSalida")
    void regularizar_idExistente_actualizaHoras() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        AsistenciaRegularizarRequest request = new AsistenciaRegularizarRequest(
                LocalTime.of(9, 0), LocalTime.of(18, 0), "Regularización manual");
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.regularizar(1L, request);

        assertThat(result.getHoraEntrada()).isEqualTo(LocalTime.of(9, 0));
        assertThat(result.getHoraSalida()).isEqualTo(LocalTime.of(18, 0));
        assertThat(result.getUpdatedBy()).isEqualTo(1L);
        assertThat(result.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("regularizar() con ID inexistente -> lanza BusinessException")
    void regularizar_idInexistente_lanzaError() {
        when(asistenciaRepo.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.regularizar(999L, new AsistenciaRegularizarRequest(null, null, "test")))
            .isInstanceOf(BusinessException.class);
        verify(asistenciaRepo, never()).save(any());
    }

    @Test
    @DisplayName("regularizar() con horaEntrada null -> mantiene horaEntrada existente")
    void regularizar_horaEntradaNull_mantieneExistente() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        entity.setHoraEntrada(LocalTime.of(8, 0));
        entity.setHoraSalida(LocalTime.of(17, 0));
        AsistenciaRegularizarRequest request = new AsistenciaRegularizarRequest(
                null, LocalTime.of(18, 0), "Solo salida");
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.regularizar(1L, request);

        assertThat(result.getHoraEntrada()).isEqualTo(LocalTime.of(8, 0)); // se mantiene
        assertThat(result.getHoraSalida()).isEqualTo(LocalTime.of(18, 0)); // se actualiza
        verify(asistenciaRepo).save(entity);
    }

    @Test
    @DisplayName("regularizar() con ambos null -> solo setea auditoría")
    void regularizar_ambosNull_soloAuditoria() {
        Asistencia entity = RrhhTestFixtures.asistencia(1L);
        AsistenciaRegularizarRequest request = new AsistenciaRegularizarRequest(null, null, "Sin cambios");
        when(asistenciaRepo.findById(1L)).thenReturn(Optional.of(entity));
        when(asistenciaRepo.save(any())).thenAnswer(i -> i.getArgument(0));

        Asistencia result = service.regularizar(1L, request);

        assertThat(result.getUpdatedBy()).isEqualTo(1L);
        assertThat(result.getFecModificacion()).isNotNull();
        verify(asistenciaRepo).save(entity);
    }

    // ═══════════════════════════════════════════════════
    // importar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("importar() -> crea múltiples registros")
    void importar_creaMultiplesRegistros() {
        AsistenciaImportarRequest request = new AsistenciaImportarRequest(List.of(
                new AsistenciaImportarRequest.AsistenciaImportRow(1L, LocalDate.of(2026, 1, 1), LocalTime.of(8, 0), LocalTime.of(17, 0), 1L),
                new AsistenciaImportarRequest.AsistenciaImportRow(2L, LocalDate.of(2026, 1, 1), LocalTime.of(8, 0), LocalTime.of(17, 0), 1L)
        ));
        Asistencia saved1 = RrhhTestFixtures.asistencia(1L);
        Asistencia saved2 = RrhhTestFixtures.asistencia(2L);
        AsistenciaResponse resp1 = RrhhTestFixtures.asistenciaResponse(1L);
        AsistenciaResponse resp2 = RrhhTestFixtures.asistenciaResponse(2L);

        when(asistenciaRepo.save(any())).thenReturn(saved1, saved2);
        when(mapper.toResponse(saved1)).thenReturn(resp1);
        when(mapper.toResponse(saved2)).thenReturn(resp2);

        List<AsistenciaResponse> results = service.importar(request);

        assertThat(results).hasSize(2);
        assertThat(results.get(0).getId()).isEqualTo(1L);
        assertThat(results.get(1).getId()).isEqualTo(2L);
        verify(asistenciaRepo, times(2)).save(any());
        verify(mapper, times(2)).toResponse(any());
    }

    // ═══════════════════════════════════════════════════
    // exportarExcel()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("exportarExcel() con fechas -> genera bytes")
    void exportarExcel_conFechas_generaBytes() {
        LocalDate desde = LocalDate.of(2026, 1, 1);
        LocalDate hasta = LocalDate.of(2026, 1, 31);
        when(asistenciaRepo.findByFechaBetween(desde, hasta)).thenReturn(List.of(RrhhTestFixtures.asistencia(1L)));

        byte[] result = service.exportarExcel(desde, hasta);

        assertThat(result).isNotNull();
        assertThat(result.length).isPositive();
        verify(asistenciaRepo).findByFechaBetween(desde, hasta);
    }

    @Test
    @DisplayName("exportarExcel() sin fechas -> exporta todos los registros")
    void exportarExcel_sinFechas_exportaTodos() {
        when(asistenciaRepo.findAll()).thenReturn(List.of(RrhhTestFixtures.asistencia(1L)));

        byte[] result = service.exportarExcel(null, null);

        assertThat(result).isNotNull();
        assertThat(result.length).isPositive();
        verify(asistenciaRepo).findAll();
    }

    @Test
    @DisplayName("exportarExcel() con error -> lanza BusinessException")
    void exportarExcel_conError_lanzaBusinessException() {
        // Simulamos que findAll() lanza una lista que falla al iterar dentro del try
        List<Asistencia> mockList = mock(List.class);
        when(mockList.iterator()).thenThrow(new RuntimeException("Error al generar Excel"));
        when(asistenciaRepo.findAll()).thenReturn(mockList);

        assertThatThrownBy(() -> service.exportarExcel(null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Error al exportar Excel");
    }

    // ═══════════════════════════════════════════════════════
    // importar()
    // ═══════════════════════════════════════════════════════

    @Test
    @DisplayName("importar() con registros vacíos -> retorna lista vacía")
    void importar_registrosVacios_retornaListaVacia() {
        AsistenciaImportarRequest request = new AsistenciaImportarRequest(List.of());

        List<AsistenciaResponse> results = service.importar(request);

        assertThat(results).isEmpty();
        verify(asistenciaRepo, never()).save(any());
    }

    // ═══════════════════════════════════════════════════════
    // procesarPeriodo()
    // ═══════════════════════════════════════════════════════

    @Test
    @DisplayName("procesarPeriodo() -> actualiza estado a C en rango de fechas")
    void procesarPeriodo_actualizaEstado() {
        LocalDate desde = LocalDate.of(2026, 1, 1);
        LocalDate hasta = LocalDate.of(2026, 1, 31);
        when(asistenciaRepo.actualizarEstadoPorRangoFechas(desde, hasta, "C", 1L)).thenReturn(5);

        service.procesarPeriodo(desde, hasta);

        verify(asistenciaRepo).actualizarEstadoPorRangoFechas(desde, hasta, "C", 1L);
    }

    @Test
    @DisplayName("procesarPeriodo() con fechas sin registros -> no actualiza nada")
    void procesarPeriodo_sinRegistros_noActualizaNada() {
        LocalDate desde = LocalDate.of(2026, 1, 1);
        LocalDate hasta = LocalDate.of(2026, 1, 31);
        when(asistenciaRepo.actualizarEstadoPorRangoFechas(desde, hasta, "C", 1L)).thenReturn(0);

        service.procesarPeriodo(desde, hasta);

        verify(asistenciaRepo).actualizarEstadoPorRangoFechas(desde, hasta, "C", 1L);
    }
}
