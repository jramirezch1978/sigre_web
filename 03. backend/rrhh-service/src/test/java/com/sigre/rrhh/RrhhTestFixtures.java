package com.sigre.rrhh;

import com.sigre.rrhh.entity.Contrato;
import com.sigre.rrhh.entity.HorarioTrabajador;
import com.sigre.rrhh.entity.Trabajador;
import com.sigre.rrhh.dto.request.AreaRequest;
import com.sigre.rrhh.dto.response.AreaResponse;
import com.sigre.rrhh.entity.Area;
import com.sigre.rrhh.dto.request.CargoRequest;
import com.sigre.rrhh.dto.response.CargoResponse;
import com.sigre.rrhh.entity.Cargo;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.entity.TipoNovedadRrhh;
import com.sigre.rrhh.entity.GanDescFijo;
import com.sigre.rrhh.dto.request.GanDescFijoRequest;
import com.sigre.rrhh.dto.request.GanDescFijoEstadoRequest;
import com.sigre.rrhh.dto.response.GanDescFijoResponse;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.entity.TipoSuspensionLaboral;
import com.sigre.rrhh.entity.SancionAmonestacion;
import com.sigre.rrhh.entity.TipoSancion;
import com.sigre.rrhh.entity.Capacitacion;
import com.sigre.rrhh.entity.CapacitacionTrabajador;
import com.sigre.rrhh.entity.PeriodoGratificacion;
import com.sigre.rrhh.entity.Gratificacion;
import com.sigre.rrhh.entity.PeriodoCts;
import com.sigre.rrhh.entity.Cts;
import com.sigre.rrhh.entity.NovedadRrhh;
import com.sigre.rrhh.entity.NovedadRrhhDet;
import com.sigre.rrhh.entity.CntaCrrte;
import com.sigre.rrhh.entity.CntaCrrteDet;
import com.sigre.rrhh.entity.Prestamo;
import com.sigre.rrhh.entity.Vacacion;
import com.sigre.rrhh.entity.GanDescVariable;
import com.sigre.rrhh.entity.ControlSubsidio;
import com.sigre.rrhh.entity.EvaluacionDesempeno;
import com.sigre.rrhh.dto.request.PermisoLicenciaCreateRequest;
import com.sigre.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import com.sigre.rrhh.dto.response.PermisoLicenciaResponse;
import com.sigre.rrhh.dto.request.SancionAmonestacionCreateRequest;
import com.sigre.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import com.sigre.rrhh.dto.response.SancionAmonestacionResponse;
import com.sigre.rrhh.dto.request.CapacitacionCreateRequest;
import com.sigre.rrhh.dto.request.CapacitacionUpdateRequest;
import com.sigre.rrhh.dto.request.CapacitacionTrabajadorRequest;
import com.sigre.rrhh.dto.response.CapacitacionResponse;
import com.sigre.rrhh.dto.response.CapacitacionTrabajadorResponse;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSuspensionLaboralResponse;
import com.sigre.rrhh.dto.request.TipoSancionCreateRequest;
import com.sigre.rrhh.dto.request.TipoSancionUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSancionResponse;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import com.sigre.rrhh.dto.response.NovedadRrhhDetResponse;
import com.sigre.rrhh.dto.response.CntaCrrteResponse;
import com.sigre.rrhh.dto.response.CntaCrrteDetResponse;
import com.sigre.rrhh.dto.request.CntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import com.sigre.rrhh.dto.response.GratificacionResponse;
import com.sigre.rrhh.dto.response.CtsResponse;
import com.sigre.rrhh.dto.request.PrestamoCreateRequest;
import com.sigre.rrhh.dto.request.PrestamoUpdateRequest;
import com.sigre.rrhh.dto.response.PrestamoResponse;
import com.sigre.rrhh.dto.response.VacacionResponse;
import com.sigre.rrhh.dto.response.GanDescVariableResponse;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;
import com.sigre.rrhh.dto.response.EvaluacionDesempenoResponse;
import com.sigre.rrhh.dto.request.VacacionCreateRequest;
import com.sigre.rrhh.dto.request.VacacionUpdateRequest;
import com.sigre.rrhh.dto.request.SolicitarGoceRequest;
import com.sigre.rrhh.dto.request.GanDescVariableRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import com.sigre.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import com.sigre.rrhh.dto.response.EstadoCivilResponse;
import com.sigre.rrhh.dto.request.EstadoCivilCreateRequest;
import com.sigre.rrhh.dto.request.EstadoCivilUpdateRequest;
import com.sigre.rrhh.entity.EstadoCivil;
import com.sigre.rrhh.entity.Sexo;
import com.sigre.rrhh.dto.request.SexoCreateRequest;
import com.sigre.rrhh.dto.request.SexoUpdateRequest;
import com.sigre.rrhh.dto.response.SexoResponse;
import com.sigre.rrhh.entity.TipoMovAsistencia;
import com.sigre.rrhh.dto.request.TipoMovAsistenciaCreateRequest;
import com.sigre.rrhh.dto.request.TipoMovAsistenciaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoMovAsistenciaResponse;
import com.sigre.rrhh.entity.TipoSubsidio;
import com.sigre.rrhh.dto.request.TipoSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.TipoSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSubsidioResponse;
import com.sigre.rrhh.dto.request.PeriodoGratificacionCreateRequest;
import com.sigre.rrhh.dto.request.PeriodoGratificacionUpdateRequest;
import com.sigre.rrhh.dto.response.PeriodoGratificacionResponse;
import com.sigre.rrhh.entity.RegimenLaboral;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;
import com.sigre.rrhh.entity.TipoConceptoCalculo;
import com.sigre.rrhh.dto.request.TipoConceptoCalculoCreateRequest;
import com.sigre.rrhh.dto.request.TipoConceptoCalculoUpdateRequest;
import com.sigre.rrhh.dto.response.TipoConceptoCalculoResponse;
import com.sigre.rrhh.entity.TipoContrato;
import com.sigre.rrhh.dto.request.TipoContratoCreateRequest;
import com.sigre.rrhh.dto.request.TipoContratoUpdateRequest;
import com.sigre.rrhh.dto.response.TipoContratoResponse;
import com.sigre.rrhh.entity.TipoMovimientoCntaCrrte;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;
import com.sigre.rrhh.entity.TipoPlanilla;
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;
import com.sigre.rrhh.dto.request.PeriodoCtsCreateRequest;
import com.sigre.rrhh.dto.request.PeriodoCtsUpdateRequest;
import com.sigre.rrhh.dto.response.PeriodoCtsResponse;

import com.sigre.rrhh.dto.request.AsistenciaRequest;
import com.sigre.rrhh.dto.response.AsistenciaResponse;
import com.sigre.rrhh.dto.response.RefResponse;
import com.sigre.rrhh.entity.Asistencia;
import com.sigre.rrhh.dto.request.CalculoProcesarRequest;
import com.sigre.rrhh.dto.response.CalculoResponse;
import com.sigre.rrhh.dto.response.CalculoDetalleResponse;
import com.sigre.rrhh.dto.response.CalculoDetResponse;
import com.sigre.rrhh.entity.Calculo;
import com.sigre.rrhh.entity.CalculoDet;
import com.sigre.rrhh.entity.Liquidacion;
import com.sigre.rrhh.entity.QuintaCategoria;
import com.sigre.rrhh.entity.ProgramVacacion;
import com.sigre.rrhh.dto.response.LiquidacionResponse;
import com.sigre.rrhh.dto.response.QuintaCategoriaResponse;
import com.sigre.rrhh.dto.response.ProgramVacacionResponse;
import com.sigre.rrhh.dto.request.ProgramVacacionCreateRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionUpdateRequest;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

/**
 * Fixtures estáticas en RAM (tipo C) para tests unitarios de rrhh-service.
 * No accede a BD; construye entidades con datos mínimos coherentes.
 */
public final class RrhhTestFixtures {

    private RrhhTestFixtures() {
        throw new UnsupportedOperationException("Clase de fixtures — no instanciable");
    }

    private static final Long DEFAULT_USUARIO_ID = 1L;

    // ── Trabajador ──────────────────────────────────────────────

    /** Crea un trabajador activo con datos mínimos y el ID indicado. */
    public static Trabajador trabajador(Long id) {
        return trabajador(id, "1");
    }

    /** Crea un trabajador con el ID y flag_estado indicados. */
    public static Trabajador trabajador(Long id, String flagEstado) {
        Trabajador t = Trabajador.builder()
                .codigoTrabajador("TRB-" + String.format("%03d", id))
                .nombres("Nombre " + id)
                .apellidoPaterno("Paterno")
                .apellidoMaterno("Materno")
                .tipoDocIdentidadId(null)
                .numeroDocumento("4567891" + id)
                .fechaNacimiento(LocalDate.of(1990, 5, 20))
                .sexoId(null)
                .estadoCivilId(null)
                .direccion("Av. Test 123")
                .telefono("987654321")
                .email("test" + id + "@empresa.com")
                .regimenLaboralId(null)
                .areaId(1L)
                .cargoId(1L)
                .sucursalId(1L)
                .fechaIngreso(LocalDate.of(2024, 3, 15))
                .build();
        t.setId(id);
        t.setFlagEstado(flagEstado);
        t.setCreatedBy(DEFAULT_USUARIO_ID);
        t.setFecCreacion(Instant.now());
        return t;
    }

    /** Crea un trabajador inactivo (cesado). */
    public static Trabajador trabajadorInactivo(Long id) {
        Trabajador t = trabajador(id, "0");
        t.setFechaCese(LocalDate.of(2026, 1, 31));
        t.setMotivoCese("Renuncia voluntaria");
        return t;
    }

    // ── Contrato ────────────────────────────────────────────────

    /** Crea un contrato activo de tipo INDEFINIDO para el trabajador indicado. */
    public static Contrato contrato(Long id, Long trabajadorId) {
        return contrato(id, trabajadorId, "1");
    }

    /** Crea un contrato con el estado indicado. */
    public static Contrato contrato(Long id, Long trabajadorId, String flagEstado) {
        Contrato c = Contrato.builder()
                .trabajadorId(trabajadorId)
                .tipoContratoId(1L)
                .fechaInicio(LocalDate.of(2024, 3, 15))
                .remuneracion(new BigDecimal("4200.0000"))
                .asignacionFamiliar(true)
                .build();
        c.setId(id);
        c.setFlagEstado(flagEstado);
        c.setCreatedBy(DEFAULT_USUARIO_ID);
        c.setFecCreacion(Instant.now());
        return c;
    }

    /** Crea un contrato de plazo fijo con fecha fin. */
    public static Contrato contratoPlazoFijo(Long id, Long trabajadorId) {
        Contrato c = contrato(id, trabajadorId);
        c.setTipoContratoId(2L);
        c.setFechaFin(LocalDate.of(2025, 3, 14));
        return c;
    }

    // ── Horario ─────────────────────────────────────────────────

    /** Crea un horario activo para el trabajador con el turno indicado. */
    public static HorarioTrabajador horario(Long id, Long trabajadorId) {
        return horario(id, trabajadorId, "1");
    }

    /** Crea un horario con el estado indicado. */
    public static HorarioTrabajador horario(Long id, Long trabajadorId, String flagEstado) {
        HorarioTrabajador h = HorarioTrabajador.builder()
                .trabajadorId(trabajadorId)
                .turnoId(1L)
                .fechaDesde(LocalDate.of(2024, 3, 15))
                .build();
        h.setId(id);
        h.setFlagEstado(flagEstado);
        h.setCreatedBy(DEFAULT_USUARIO_ID);
        h.setFecCreacion(Instant.now());
        return h;
    }

    /** Crea un horario con rango de fechas definido. */
    public static HorarioTrabajador horarioConRango(Long id, Long trabajadorId,
                                                     LocalDate desde, LocalDate hasta) {
        HorarioTrabajador h = horario(id, trabajadorId);
        h.setFechaDesde(desde);
        h.setFechaHasta(hasta);
        return h;
    }

    // ── Area ────────────────────────────────────────────────────

    /**
     * Crea una entidad Area para tests unitarios.
     *
     * @param id      ID del área
     * @param nombre  Nombre del área
     * @param padreId ID del área padre (null para áreas raíz)
     * @return Entidad Area configurada
     */
    public static Area area(Long id, String nombre, Long padreId) {
        Area area = new Area();
        area.setId(id);
        area.setNombre(nombre);
        area.setPadreId(padreId);
        area.setResponsableId(null);
        area.setCreatedBy(DEFAULT_USUARIO_ID);
        area.setFecCreacion(Instant.now());
        area.setUpdatedBy(null);
        area.setFecModificacion(null);
        return area;
    }

    /**
     * Crea un AreaRequest para tests unitarios.
     *
     * @param nombre  Nombre del área
     * @param padreId ID del área padre
     * @return DTO de request configurado
     */
    public static AreaRequest areaRequest(String nombre, Long padreId) {
        AreaRequest request = new AreaRequest();
        request.setNombre(nombre);
        request.setPadreId(padreId);
        request.setResponsableId(null);
        return request;
    }

    /**
     * Crea un AreaResponse para tests unitarios.
     *
     * @param id      ID del área
     * @param nombre  Nombre del área
     * @param padreId ID del área padre
     * @return DTO de response configurado
     */
    public static AreaResponse areaResponse(Long id, String nombre, Long padreId) {
        AreaResponse response = new AreaResponse();
        response.setId(id);
        response.setNombre(nombre);
        response.setPadreId(padreId);
        response.setResponsableId(null);
        response.setCreatedBy(DEFAULT_USUARIO_ID);
        response.setFecCreacion(null);
        response.setUpdatedBy(null);
        response.setFecModificacion(null);
        return response;
    }

    // ── Cargo ───────────────────────────────────────────────────

    /**
     * Crea una entidad Cargo para tests unitarios.
     *
     * @param id     ID del cargo
     * @param nombre Nombre del cargo
     * @return Entidad Cargo configurada
     */
    public static Cargo cargo(Long id, String nombre) {
        Cargo cargo = new Cargo();
        cargo.setId(id);
        cargo.setNombre(nombre);
        cargo.setNivel("OPERATIVO");
        cargo.setSueldoMinimo(new BigDecimal("2500.0000"));
        cargo.setSueldoMaximo(new BigDecimal("4000.0000"));
        cargo.setCreatedBy(DEFAULT_USUARIO_ID);
        cargo.setFecCreacion(Instant.now());
        cargo.setUpdatedBy(null);
        cargo.setFecModificacion(null);
        return cargo;
    }

    /**
     * Crea una entidad Cargo con banda salarial personalizada.
     *
     * @param id            ID del cargo
     * @param nombre        Nombre del cargo
     * @param nivel         Nivel del cargo
     * @param sueldoMinimo  Sueldo mínimo
     * @param sueldoMaximo  Sueldo máximo
     * @return Entidad Cargo configurada
     */
    public static Cargo cargo(Long id, String nombre, String nivel, 
                              BigDecimal sueldoMinimo, BigDecimal sueldoMaximo) {
        Cargo cargo = new Cargo();
        cargo.setId(id);
        cargo.setNombre(nombre);
        cargo.setNivel(nivel);
        cargo.setSueldoMinimo(sueldoMinimo);
        cargo.setSueldoMaximo(sueldoMaximo);
        cargo.setCreatedBy(DEFAULT_USUARIO_ID);
        cargo.setFecCreacion(Instant.now());
        cargo.setUpdatedBy(null);
        cargo.setFecModificacion(null);
        return cargo;
    }

    /**
     * Crea un CargoRequest para tests unitarios.
     *
     * @param nombre Nombre del cargo
     * @return DTO de request configurado
     */
    public static CargoRequest cargoRequest(String nombre) {
        CargoRequest request = new CargoRequest();
        request.setNombre(nombre);
        request.setNivel("OPERATIVO");
        request.setSueldoMinimo(new BigDecimal("2500.0000"));
        request.setSueldoMaximo(new BigDecimal("4000.0000"));
        return request;
    }

    /**
     * Crea un CargoRequest con banda salarial personalizada.
     *
     * @param nombre        Nombre del cargo
     * @param nivel         Nivel del cargo
     * @param sueldoMinimo  Sueldo mínimo
     * @param sueldoMaximo  Sueldo máximo
     * @return DTO de request configurado
     */
    public static CargoRequest cargoRequest(String nombre, String nivel,
                                            BigDecimal sueldoMinimo, BigDecimal sueldoMaximo) {
        CargoRequest request = new CargoRequest();
        request.setNombre(nombre);
        request.setNivel(nivel);
        request.setSueldoMinimo(sueldoMinimo);
        request.setSueldoMaximo(sueldoMaximo);
        return request;
    }

    /**
     * Crea un CargoResponse para tests unitarios.
     *
     * @param id     ID del cargo
     * @param nombre Nombre del cargo
     * @return DTO de response configurado
     */
    public static CargoResponse cargoResponse(Long id, String nombre) {
        CargoResponse response = new CargoResponse();
        response.setId(id);
        response.setNombre(nombre);
        response.setNivel("OPERATIVO");
        response.setSueldoMinimo(new BigDecimal("2500.0000"));
        response.setSueldoMaximo(new BigDecimal("4000.0000"));
        response.setCreatedBy(DEFAULT_USUARIO_ID);
        response.setFecCreacion(null);
        response.setUpdatedBy(null);
        response.setFecModificacion(null);
        return response;
    }

    // ── TipoNovedadRrhh ─────────────────────────────────────────

    public static TipoNovedadRrhh tipoNovedadRrhh(Long id, String codigo, String nombre) {
        return tipoNovedadRrhh(id, codigo, nombre, "1");
    }

    public static TipoNovedadRrhh tipoNovedadRrhh(Long id, String codigo, String nombre, String flagEstado) {
        TipoNovedadRrhh tn = new TipoNovedadRrhh();
        tn.setId(id);
        tn.setCodigo(codigo);
        tn.setNombre(nombre);
        tn.setFlagEstado(flagEstado);
        tn.setCreatedBy(DEFAULT_USUARIO_ID);
        tn.setFecCreacion(Instant.now());
        tn.setUpdatedBy(null);
        tn.setFecModificacion(null);
        return tn;
    }

    public static TipoNovedadRrhhCreateRequest tipoNovedadRrhhCreateRequest(String codigo, String nombre) {
        TipoNovedadRrhhCreateRequest r = new TipoNovedadRrhhCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoNovedadRrhhUpdateRequest tipoNovedadRrhhUpdateRequest(String nombre, String flagEstado) {
        TipoNovedadRrhhUpdateRequest r = new TipoNovedadRrhhUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado(flagEstado);
        return r;
    }

    public static TipoNovedadRrhhResponse tipoNovedadRrhhResponse(Long id, String codigo, String nombre) {
        TipoNovedadRrhhResponse r = new TipoNovedadRrhhResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── GanDescFijo ────────────────────────────────────────────

    public static GanDescFijo ganDescFijo(Long id) {
        return ganDescFijo(id, "1");
    }

    public static GanDescFijo ganDescFijo(Long id, String flagEstado) {
        GanDescFijo entity = new GanDescFijo();
        entity.setId(id);
        entity.setTrabajadorId(1L);
        entity.setConceptoId(1L);
        entity.setImpGanDesc(new BigDecimal("500.0000"));
        entity.setPorcentaje(null);
        entity.setImpMaxGanDesc(null);
        entity.setFlagEstado(flagEstado);
        entity.setCreatedBy(DEFAULT_USUARIO_ID);
        entity.setFecCreacion(Instant.now());
        return entity;
    }

    public static GanDescFijoRequest ganDescFijoRequest() {
        return GanDescFijoRequest.builder()
                .trabajadorId(1L)
                .conceptoId(1L)
                .impGanDesc(new BigDecimal("500.0000"))
                .flagEstado("1")
                .build();
    }

    public static GanDescFijoRequest ganDescFijoRequestSinImporteNiPorcentaje() {
        return GanDescFijoRequest.builder()
                .trabajadorId(1L)
                .conceptoId(1L)
                .impGanDesc(null)
                .porcentaje(null)
                .flagEstado("1")
                .build();
    }

    public static GanDescFijoEstadoRequest ganDescFijoEstadoRequest(String flagEstado) {
        return GanDescFijoEstadoRequest.builder()
                .flagEstado(flagEstado)
                .build();
    }

    public static GanDescFijoResponse ganDescFijoResponse(Long id) {
        return GanDescFijoResponse.builder()
                .id(id)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .conceptoId(1L)
                .conceptoDescripcion("Sueldo Básico Test")
                .impGanDesc(new BigDecimal("500.0000"))
                .flagEstado("1")
                .createdBy(DEFAULT_USUARIO_ID)
                .build();
    }

    // ── PermisoLicencia ──────────────────────────────────────────

    public static PermisoLicencia permisoLicencia(Long id) {
        return permisoLicencia(id, "1");
    }

    public static PermisoLicencia permisoLicencia(Long id, String flagEstado) {
        PermisoLicencia e = new PermisoLicencia();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setTipoSuspensionLaboralId(1L);
        e.setFechaInicio(LocalDate.of(2026, 1, 15));
        e.setFechaFin(null);
        e.setDias(null);
        e.setSustento(null);
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static PermisoLicenciaCreateRequest permisoLicenciaCreateRequest() {
        PermisoLicenciaCreateRequest r = new PermisoLicenciaCreateRequest();
        r.setTrabajadorId(1L);
        r.setTipoSuspensionLaboralId(1L);
        r.setFechaInicio(LocalDate.of(2026, 1, 15));
        return r;
    }

    public static PermisoLicenciaUpdateRequest permisoLicenciaUpdateRequest() {
        PermisoLicenciaUpdateRequest r = new PermisoLicenciaUpdateRequest();
        r.setFechaFin(LocalDate.of(2026, 1, 20));
        r.setDias(5);
        r.setFlagEstado("1");
        return r;
    }

    public static PermisoLicenciaUpdateRequest permisoLicenciaUpdateRequestConNuevoTipo() {
        PermisoLicenciaUpdateRequest r = new PermisoLicenciaUpdateRequest();
        r.setTipoSuspensionLaboralId(2L);
        r.setFechaInicio(LocalDate.of(2026, 2, 1));
        r.setFlagEstado("1");
        return r;
    }

    public static PermisoLicenciaResponse permisoLicenciaResponse(Long id) {
        PermisoLicenciaResponse r = new PermisoLicenciaResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setTipoSuspensionLaboralId(1L);
        r.setFechaInicio(LocalDate.of(2026, 1, 15));
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoSuspensionLaboral ────────────────────────────────────

    public static TipoSuspensionLaboral tipoSuspensionLaboral(Long id, String codigo) {
        TipoSuspensionLaboral e = new TipoSuspensionLaboral();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("Tipo " + codigo);
        e.setFlagTipoSusp("1");
        e.setTipoSubsidioId(null);
        e.setFlagCitt("0");
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoSuspensionLaboralCreateRequest tipoSuspensionLaboralCreateRequest(String codigo, String nombre) {
        TipoSuspensionLaboralCreateRequest r = new TipoSuspensionLaboralCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagTipoSusp("1");
        r.setFlagCitt("0");
        return r;
    }

    public static TipoSuspensionLaboralUpdateRequest tipoSuspensionLaboralUpdateRequest(String nombre) {
        TipoSuspensionLaboralUpdateRequest r = new TipoSuspensionLaboralUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoSuspensionLaboralResponse tipoSuspensionLaboralResponse(Long id, String codigo, String nombre) {
        TipoSuspensionLaboralResponse r = new TipoSuspensionLaboralResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagTipoSusp("1");
        r.setFlagCitt("0");
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── SancionAmonestacion ──────────────────────────────────────

    public static SancionAmonestacion sancionAmonestacion(Long id) {
        return sancionAmonestacion(id, "1");
    }

    public static SancionAmonestacion sancionAmonestacion(Long id, String flagEstado) {
        SancionAmonestacion e = new SancionAmonestacion();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setTipoSancionId(1L);
        e.setFecha(LocalDate.of(2026, 1, 15));
        e.setMotivo("Amonestación de prueba");
        e.setDocumento("DOC-001");
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static SancionAmonestacionCreateRequest sancionAmonestacionCreateRequest() {
        SancionAmonestacionCreateRequest r = new SancionAmonestacionCreateRequest();
        r.setTrabajadorId(1L);
        r.setTipoSancionId(1L);
        r.setFecha(LocalDate.of(2026, 1, 15));
        r.setMotivo("Amonestación de prueba");
        return r;
    }

    public static SancionAmonestacionUpdateRequest sancionAmonestacionUpdateRequest() {
        SancionAmonestacionUpdateRequest r = new SancionAmonestacionUpdateRequest();
        r.setMotivo("Motivo actualizado");
        r.setFlagEstado("1");
        return r;
    }

    public static SancionAmonestacionResponse sancionAmonestacionResponse(Long id) {
        SancionAmonestacionResponse r = new SancionAmonestacionResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setTipoSancionId(1L);
        r.setFecha(LocalDate.of(2026, 1, 15));
        r.setMotivo("Amonestación de prueba");
        r.setDocumento("DOC-001");
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoSancion ──────────────────────────────────────────────

    public static TipoSancion tipoSancion(Long id, String codigo) {
        TipoSancion e = new TipoSancion();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("Sanción " + codigo);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoSancionCreateRequest tipoSancionCreateRequest(String codigo, String nombre) {
        TipoSancionCreateRequest r = new TipoSancionCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoSancionUpdateRequest tipoSancionUpdateRequest(String nombre) {
        TipoSancionUpdateRequest r = new TipoSancionUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoSancionResponse tipoSancionResponse(Long id, String codigo, String nombre) {
        TipoSancionResponse r = new TipoSancionResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── Capacitacion ─────────────────────────────────────────────

    public static Capacitacion capacitacion(Long id) {
        return capacitacion(id, "1");
    }

    public static Capacitacion capacitacion(Long id, String flagEstado) {
        Capacitacion e = new Capacitacion();
        e.setId(id);
        e.setNombre("Capacitación " + id);
        e.setDescripcion("Descripción capacitación " + id);
        e.setFechaInicio(LocalDate.of(2026, 2, 1));
        e.setFechaFin(LocalDate.of(2026, 2, 5));
        e.setHoras(20);
        e.setProveedor("Proveedor " + id);
        e.setCosto(new BigDecimal("500.0000"));
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static CapacitacionCreateRequest capacitacionCreateRequest() {
        CapacitacionCreateRequest r = new CapacitacionCreateRequest();
        r.setNombre("Capacitación Nueva");
        r.setDescripcion("Descripción nueva");
        r.setFechaInicio(LocalDate.of(2026, 3, 1));
        r.setFechaFin(LocalDate.of(2026, 3, 5));
        r.setHoras(20);
        r.setProveedor("Proveedor Externo");
        r.setCosto(new BigDecimal("1000.0000"));
        return r;
    }

    public static CapacitacionUpdateRequest capacitacionUpdateRequest() {
        CapacitacionUpdateRequest r = new CapacitacionUpdateRequest();
        r.setNombre("Capacitación Actualizada");
        r.setHoras(30);
        r.setFlagEstado("1");
        return r;
    }

    public static CapacitacionResponse capacitacionResponse(Long id) {
        CapacitacionResponse r = new CapacitacionResponse();
        r.setId(id);
        r.setNombre("Capacitación " + id);
        r.setDescripcion("Descripción capacitación " + id);
        r.setFechaInicio(LocalDate.of(2026, 2, 1));
        r.setFechaFin(LocalDate.of(2026, 2, 5));
        r.setHoras(20);
        r.setProveedor("Proveedor " + id);
        r.setCosto(new BigDecimal("500.0000"));
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── CapacitacionTrabajador ───────────────────────────────────

    public static CapacitacionTrabajador capacitacionTrabajador(Long id, Long capId) {
        CapacitacionTrabajador e = new CapacitacionTrabajador();
        e.setId(id);
        e.setCapacitacionId(capId);
        e.setTrabajadorId(1L);
        e.setAsistio(true);
        e.setCalificacion(new BigDecimal("15.50"));
        e.setCertificado(true);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static CapacitacionTrabajadorRequest capacitacionTrabajadorRequest() {
        CapacitacionTrabajadorRequest r = new CapacitacionTrabajadorRequest();
        r.setTrabajadorId(2L);
        r.setAsistio(true);
        r.setCalificacion(new BigDecimal("18.00"));
        r.setCertificado(true);
        return r;
    }

    public static CapacitacionTrabajadorResponse capacitacionTrabajadorResponse(Long id, Long capId) {
        CapacitacionTrabajadorResponse r = new CapacitacionTrabajadorResponse();
        r.setId(id);
        r.setCapacitacionId(capId);
        r.setTrabajadorId(1L);
        r.setAsistio(true);
        r.setCalificacion(new BigDecimal("15.50"));
        r.setCertificado(true);
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        return r;
    }

    // ── PeriodoGratificacion ──────────────────────────────────────

    public static PeriodoGratificacion periodoGratificacion(Long id) {
        PeriodoGratificacion e = new PeriodoGratificacion();
        e.setId(id);
        e.setCodigo("PG-" + id);
        e.setNombre("Período Gratificación " + id);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    // ── Gratificacion ────────────────────────────────────────────

    public static Gratificacion gratificacion(Long id) {
        Gratificacion e = new Gratificacion();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setAnio(2026);
        e.setPeriodoGratificacionId(1L);
        e.setRemuneracionComputable(new BigDecimal("3000.0000"));
        e.setMesesLaborados(6);
        e.setMontoGratificacion(new BigDecimal("1500.0000"));
        e.setBonificacionExtraordinaria(new BigDecimal("135.0000"));
        e.setTotal(new BigDecimal("1635.0000"));
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static GratificacionResponse gratificacionResponse(Long id) {
        GratificacionResponse r = new GratificacionResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setAnio(2026);
        r.setPeriodoGratificacionId(1L);
        r.setRemuneracionComputable(new BigDecimal("3000.0000"));
        r.setMesesLaborados(6);
        r.setMontoGratificacion(new BigDecimal("1500.0000"));
        r.setBonificacionExtraordinaria(new BigDecimal("135.0000"));
        r.setTotal(new BigDecimal("1635.0000"));
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── PeriodoCts ───────────────────────────────────────────────

    public static PeriodoCts periodoCts(Long id) {
        PeriodoCts e = new PeriodoCts();
        e.setId(id);
        e.setCodigo("PC-" + id);
        e.setNombre("Período CTS " + id);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    // ── Cts ──────────────────────────────────────────────────────

    public static Cts cts(Long id) {
        Cts e = new Cts();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setAnio(2026);
        e.setPeriodoCtsId(1L);
        e.setRemuneracionComputable(new BigDecimal("3000.0000"));
        e.setMesesComputables(6);
        e.setDiasComputables(180);
        e.setMontoCts(new BigDecimal("1500.0000"));
        e.setEntidadFinanciera("Banco Test");
        e.setNumeroCuentaCts("123456789");
        e.setFechaDeposito(LocalDate.of(2026, 5, 15));
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static CtsResponse ctsResponse(Long id) {
        CtsResponse r = new CtsResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setAnio(2026);
        r.setPeriodoCtsId(1L);
        r.setRemuneracionComputable(new BigDecimal("3000.0000"));
        r.setMesesComputables(6);
        r.setDiasComputables(180);
        r.setMontoCts(new BigDecimal("1500.0000"));
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── NovedadRrhh ──────────────────────────────────────────────

    public static NovedadRrhh novedadRrhh(Long id) {
        return novedadRrhh(id, "1");
    }

    public static NovedadRrhh novedadRrhh(Long id, String flagEstado) {
        NovedadRrhh e = new NovedadRrhh();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setTipoNovedadRrhhId(1L);
        e.setCitt("CITT-001");
        e.setFechaIni(LocalDate.of(2026, 1, 1));
        e.setFechaFin(LocalDate.of(2026, 1, 15));
        e.setDiasTeoricos(15);
        e.setDiasReales(15);
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static NovedadRrhhCreateRequest novedadRrhhCreateRequest() {
        NovedadRrhhCreateRequest r = new NovedadRrhhCreateRequest();
        r.setTrabajadorId(1L);
        r.setTipoNovedadRrhhId(1L);
        r.setFechaIni(LocalDate.of(2026, 2, 1));
        r.setFechaFin(LocalDate.of(2026, 2, 15));
        return r;
    }

    public static NovedadRrhhUpdateRequest novedadRrhhUpdateRequest() {
        NovedadRrhhUpdateRequest r = new NovedadRrhhUpdateRequest();
        r.setCitt("CITT-UPD");
        r.setDiasReales(10);
        r.setFlagEstado("1");
        return r;
    }

    public static NovedadRrhhResponse novedadRrhhResponse(Long id) {
        NovedadRrhhResponse r = new NovedadRrhhResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setTipoNovedadRrhhId(1L);
        r.setCitt("CITT-001");
        r.setFechaIni(LocalDate.of(2026, 1, 1));
        r.setFechaFin(LocalDate.of(2026, 1, 15));
        r.setDiasTeoricos(15);
        r.setDiasReales(15);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── NovedadRrhhDet ───────────────────────────────────────────

    public static NovedadRrhhDet novedadRrhhDet(Long id) {
        NovedadRrhhDet e = new NovedadRrhhDet();
        e.setId(id);
        e.setNovedadRrhhId(1L);
        e.setFechaProceso(LocalDate.of(2026, 1, 16));
        e.setMontoPlanilla(new BigDecimal("500.0000"));
        e.setMontoSeguro(new BigDecimal("50.0000"));
        e.setReferenciaDoc("REF-001");
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static NovedadRrhhDetResponse novedadRrhhDetResponse(Long id) {
        NovedadRrhhDetResponse r = new NovedadRrhhDetResponse();
        r.setId(id);
        r.setNovedadRrhhId(1L);
        r.setFechaProceso(LocalDate.of(2026, 1, 16));
        r.setMontoPlanilla(new BigDecimal("500.0000"));
        r.setMontoSeguro(new BigDecimal("50.0000"));
        r.setReferenciaDoc("REF-001");
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── CntaCrrte ────────────────────────────────────────────────

    public static CntaCrrte cntaCrrte(Long id) {
        return cntaCrrte(id, "1");
    }

    public static CntaCrrte cntaCrrte(Long id, String flagEstado) {
        CntaCrrte e = new CntaCrrte();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setFechaApertura(LocalDate.of(2026, 1, 1));
        e.setSaldoInicial(new BigDecimal("1000.0000"));
        e.setSaldoActual(new BigDecimal("500.0000"));
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static CntaCrrteResponse cntaCrrteResponse(Long id) {
        CntaCrrteResponse r = new CntaCrrteResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setFechaApertura(LocalDate.of(2026, 1, 1));
        r.setSaldoInicial(new BigDecimal("1000.0000"));
        r.setSaldoActual(new BigDecimal("500.0000"));
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── CntaCrrteDet ─────────────────────────────────────────────

    public static CntaCrrteDet cntaCrrteDet(Long id) {
        CntaCrrteDet e = new CntaCrrteDet();
        e.setId(id);
        e.setCntaCrrteId(1L);
        e.setFechaMovimiento(LocalDate.of(2026, 1, 15));
        e.setTipoMovimientoCntaCrrteId(1L);
        e.setConcepto("Abono de prueba");
        e.setMonto(new BigDecimal("200.0000"));
        e.setReferencia("ABO-001");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static CntaCrrteDetResponse cntaCrrteDetResponse(Long id) {
        CntaCrrteDetResponse r = new CntaCrrteDetResponse();
        r.setId(id);
        r.setCntaCrrteId(1L);
        r.setFechaMovimiento(LocalDate.of(2026, 1, 15));
        r.setTipoMovimientoCntaCrrteId(1L);
        r.setConcepto("Abono de prueba");
        r.setMonto(new BigDecimal("200.0000"));
        r.setReferencia("ABO-001");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        return r;
    }

    // ── Prestamo ─────────────────────────────────────────────────

    public static Prestamo prestamo(Long id) {
        return prestamo(id, "1");
    }

    public static Prestamo prestamo(Long id, String flagEstado) {
        Prestamo e = new Prestamo();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setMontoTotal(new BigDecimal("5000.0000"));
        e.setCuotas(12);
        e.setCuotaMensual(new BigDecimal("450.0000"));
        e.setSaldo(new BigDecimal("3000.0000"));
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static PrestamoCreateRequest prestamoCreateRequest() {
        PrestamoCreateRequest r = new PrestamoCreateRequest();
        r.setTrabajadorId(1L);
        r.setMontoTotal(new BigDecimal("6000.0000"));
        r.setCuotas(12);
        return r;
    }

    public static PrestamoUpdateRequest prestamoUpdateRequest() {
        PrestamoUpdateRequest r = new PrestamoUpdateRequest();
        r.setMontoTotal(new BigDecimal("6000.0000"));
        r.setCuotas(12);
        r.setFlagEstado("1");
        return r;
    }

    public static PrestamoResponse prestamoResponse(Long id) {
        PrestamoResponse r = new PrestamoResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setMontoTotal(new BigDecimal("5000.0000"));
        r.setCuotas(12);
        r.setCuotaMensual(new BigDecimal("450.0000"));
        r.setSaldo(new BigDecimal("3000.0000"));
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── EstadoCivil ──────────────────────────────────────────────

    public static EstadoCivil estadoCivil(Long id, String codigo) {
        EstadoCivil e = new EstadoCivil();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("Estado " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static EstadoCivilCreateRequest estadoCivilCreateRequest(String codigo, String nombre) {
        EstadoCivilCreateRequest r = new EstadoCivilCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static EstadoCivilUpdateRequest estadoCivilUpdateRequest(String nombre) {
        EstadoCivilUpdateRequest r = new EstadoCivilUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static EstadoCivilResponse estadoCivilResponse(Long id, String codigo, String nombre) {
        EstadoCivilResponse r = new EstadoCivilResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── RegimenLaboral ───────────────────────────────────────────

    public static RegimenLaboral regimenLaboral(Long id, String codigo) {
        RegimenLaboral e = new RegimenLaboral();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("Regimen " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static RegimenLaboralCreateRequest regimenLaboralCreateRequest(String codigo, String nombre) {
        RegimenLaboralCreateRequest r = new RegimenLaboralCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static RegimenLaboralUpdateRequest regimenLaboralUpdateRequest(String nombre) {
        RegimenLaboralUpdateRequest r = new RegimenLaboralUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static RegimenLaboralResponse regimenLaboralResponse(Long id, String codigo, String nombre) {
        RegimenLaboralResponse r = new RegimenLaboralResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoConceptoCalculo ───────────────────────────────────────

    public static TipoConceptoCalculo tipoConceptoCalculo(Long id, String codigo) {
        TipoConceptoCalculo e = new TipoConceptoCalculo();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoConceptoCalculo " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoConceptoCalculoCreateRequest tipoConceptoCalculoCreateRequest(String codigo, String nombre) {
        TipoConceptoCalculoCreateRequest r = new TipoConceptoCalculoCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoConceptoCalculoUpdateRequest tipoConceptoCalculoUpdateRequest(String nombre) {
        TipoConceptoCalculoUpdateRequest r = new TipoConceptoCalculoUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoConceptoCalculoResponse tipoConceptoCalculoResponse(Long id, String codigo, String nombre) {
        TipoConceptoCalculoResponse r = new TipoConceptoCalculoResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoContrato ─────────────────────────────────────────────

    public static TipoContrato tipoContrato(Long id, String codigo) {
        TipoContrato e = new TipoContrato();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoContrato " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoContratoCreateRequest tipoContratoCreateRequest(String codigo, String nombre) {
        TipoContratoCreateRequest r = new TipoContratoCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoContratoUpdateRequest tipoContratoUpdateRequest(String nombre) {
        TipoContratoUpdateRequest r = new TipoContratoUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoContratoResponse tipoContratoResponse(Long id, String codigo, String nombre) {
        TipoContratoResponse r = new TipoContratoResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoMovimientoCntaCrrte ──────────────────────────────────

    public static TipoMovimientoCntaCrrte tipoMovimientoCntaCrrte(Long id, String codigo) {
        TipoMovimientoCntaCrrte e = new TipoMovimientoCntaCrrte();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoMovimientoCntaCrrte " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoMovimientoCntaCrrteCreateRequest tipoMovimientoCntaCrrteCreateRequest(String codigo, String nombre) {
        TipoMovimientoCntaCrrteCreateRequest r = new TipoMovimientoCntaCrrteCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoMovimientoCntaCrrteUpdateRequest tipoMovimientoCntaCrrteUpdateRequest(String nombre) {
        TipoMovimientoCntaCrrteUpdateRequest r = new TipoMovimientoCntaCrrteUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoMovimientoCntaCrrteResponse tipoMovimientoCntaCrrteResponse(Long id, String codigo, String nombre) {
        TipoMovimientoCntaCrrteResponse r = new TipoMovimientoCntaCrrteResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoPlanilla ─────────────────────────────────────────────

    public static TipoPlanilla tipoPlanilla(Long id, String codigo) {
        TipoPlanilla e = new TipoPlanilla();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoPlanilla " + codigo);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoPlanillaCreateRequest tipoPlanillaCreateRequest(String codigo, String nombre) {
        TipoPlanillaCreateRequest r = new TipoPlanillaCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoPlanillaUpdateRequest tipoPlanillaUpdateRequest(String nombre) {
        TipoPlanillaUpdateRequest r = new TipoPlanillaUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoPlanillaResponse tipoPlanillaResponse(Long id, String codigo, String nombre) {
        TipoPlanillaResponse r = new TipoPlanillaResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── PeriodoCts ───────────────────────────────────────────────

    public static PeriodoCtsCreateRequest periodoCtsCreateRequest(String codigo, String nombre) {
        PeriodoCtsCreateRequest r = new PeriodoCtsCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static PeriodoCtsUpdateRequest periodoCtsUpdateRequest(String nombre) {
        PeriodoCtsUpdateRequest r = new PeriodoCtsUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static PeriodoCtsResponse periodoCtsResponse(Long id, String codigo, String nombre) {
        PeriodoCtsResponse r = new PeriodoCtsResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── Sexo ─────────────────────────────────────────────────────

    public static Sexo sexo(Long id, String codigo) {
        Sexo e = new Sexo();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("Sexo " + codigo);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static SexoCreateRequest sexoCreateRequest(String codigo, String nombre) {
        SexoCreateRequest r = new SexoCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static SexoUpdateRequest sexoUpdateRequest(String nombre) {
        SexoUpdateRequest r = new SexoUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static SexoResponse sexoResponse(Long id, String codigo, String nombre) {
        SexoResponse r = new SexoResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoMovAsistencia ────────────────────────────────────────

    public static TipoMovAsistencia tipoMovAsistencia(Long id, String codigo) {
        TipoMovAsistencia e = new TipoMovAsistencia();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoMovAsistencia " + codigo);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoMovAsistenciaCreateRequest tipoMovAsistenciaCreateRequest(String codigo, String nombre) {
        TipoMovAsistenciaCreateRequest r = new TipoMovAsistenciaCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoMovAsistenciaUpdateRequest tipoMovAsistenciaUpdateRequest(String nombre) {
        TipoMovAsistenciaUpdateRequest r = new TipoMovAsistenciaUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoMovAsistenciaResponse tipoMovAsistenciaResponse(Long id, String codigo, String nombre) {
        TipoMovAsistenciaResponse r = new TipoMovAsistenciaResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── TipoSubsidio ─────────────────────────────────────────────

    public static TipoSubsidio tipoSubsidio(Long id, String codigo) {
        TipoSubsidio e = new TipoSubsidio();
        e.setId(id);
        e.setCodigo(codigo);
        e.setNombre("TipoSubsidio " + codigo);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static TipoSubsidioCreateRequest tipoSubsidioCreateRequest(String codigo, String nombre) {
        TipoSubsidioCreateRequest r = new TipoSubsidioCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static TipoSubsidioUpdateRequest tipoSubsidioUpdateRequest(String nombre) {
        TipoSubsidioUpdateRequest r = new TipoSubsidioUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static TipoSubsidioResponse tipoSubsidioResponse(Long id, String codigo, String nombre) {
        TipoSubsidioResponse r = new TipoSubsidioResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── PeriodoGratificacion (request/response) ──────────────────

    public static PeriodoGratificacionCreateRequest periodoGratificacionCreateRequest(String codigo, String nombre) {
        PeriodoGratificacionCreateRequest r = new PeriodoGratificacionCreateRequest();
        r.setCodigo(codigo);
        r.setNombre(nombre);
        return r;
    }

    public static PeriodoGratificacionUpdateRequest periodoGratificacionUpdateRequest(String nombre) {
        PeriodoGratificacionUpdateRequest r = new PeriodoGratificacionUpdateRequest();
        r.setNombre(nombre);
        r.setFlagEstado("1");
        return r;
    }

    public static PeriodoGratificacionResponse periodoGratificacionResponse(Long id, String codigo, String nombre) {
        PeriodoGratificacionResponse r = new PeriodoGratificacionResponse();
        r.setId(id);
        r.setCodigo(codigo);
        r.setNombre(nombre);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── CntaCrrte DTOs ──────────────────────────────────────────────

    public static CntaCrrteCreateRequest cntaCrrteCreateRequest() {
        CntaCrrteCreateRequest r = new CntaCrrteCreateRequest();
        r.setTrabajadorId(1L);
        r.setFechaApertura(LocalDate.of(2026, 1, 1));
        r.setSaldoInicial(new BigDecimal("1000.0000"));
        return r;
    }

    public static CntaCrrteUpdateRequest cntaCrrteUpdateRequest() {
        CntaCrrteUpdateRequest r = new CntaCrrteUpdateRequest();
        r.setFechaApertura(LocalDate.of(2026, 2, 1));
        r.setSaldoInicial(new BigDecimal("2000.0000"));
        r.setFlagEstado("1");
        return r;
    }

    public static CntaCrrteMovimientoRequest cntaCrrteMovimientoRequest() {
        CntaCrrteMovimientoRequest r = new CntaCrrteMovimientoRequest();
        r.setFechaMovimiento(LocalDate.of(2026, 1, 15));
        r.setTipoMovimientoCntaCrrteId(1L);
        r.setConcepto("Abono de prueba");
        r.setMonto(new BigDecimal("200.0000"));
        r.setReferencia("ABO-001");
        return r;
    }

    public static CntaCrrteMovimientoUpdateRequest cntaCrrteMovimientoUpdateRequest() {
        CntaCrrteMovimientoUpdateRequest r = new CntaCrrteMovimientoUpdateRequest();
        r.setFechaMovimiento(LocalDate.of(2026, 1, 20));
        r.setTipoMovimientoCntaCrrteId(2L);
        r.setConcepto("Abono actualizado");
        r.setMonto(new BigDecimal("300.0000"));
        r.setReferencia("ABO-002");
        return r;
    }

    // ── Vacacion ─────────────────────────────────────────────────

    public static Vacacion vacacion(Long id) {
        return vacacion(id, "1");
    }

    public static Vacacion vacacion(Long id, String flagEstado) {
        Vacacion e = new Vacacion();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setPeriodoAnio(2026);
        e.setDiasDerecho(30);
        e.setDiasGozados(0);
        e.setDiasPendientes(30);
        e.setFechaInicio(LocalDate.of(2026, 1, 15));
        e.setFechaFin(LocalDate.of(2026, 2, 13));
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static VacacionCreateRequest vacacionCreateRequest() {
        VacacionCreateRequest r = new VacacionCreateRequest();
        r.setTrabajadorId(1L);
        r.setPeriodoAnio(2026);
        r.setDiasDerecho(30);
        return r;
    }

    public static VacacionUpdateRequest vacacionUpdateRequest() {
        VacacionUpdateRequest r = new VacacionUpdateRequest();
        r.setDiasDerecho(15);
        return r;
    }

    public static VacacionResponse vacacionResponse(Long id) {
        VacacionResponse r = new VacacionResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setPeriodoAnio(2026);
        r.setDiasDerecho(30);
        r.setDiasGozados(0);
        r.setDiasPendientes(30);
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    public static SolicitarGoceRequest solicitarGoceRequest() {
        SolicitarGoceRequest r = new SolicitarGoceRequest();
        r.setFechaInicio(LocalDate.of(2026, 3, 1));
        r.setFechaFin(LocalDate.of(2026, 3, 15));
        return r;
    }

    // ── GanDescVariable ──────────────────────────────────────────

    public static GanDescVariable ganDescVariable(Long id) {
        GanDescVariable e = GanDescVariable.builder()
                .id(id)
                .trabajadorId(1L)
                .fecMovim(LocalDate.of(2026, 1, 15))
                .conceptoId(1L)
                .nroDoc("DOC-001")
                .impVar(new BigDecimal("500.0000"))
                .centrosCostoId(1L)
                .cantLabor(new BigDecimal("30.0000"))
                .nroDias(new BigDecimal("15.00"))
                .nroHoras(new BigDecimal("120.00"))
                .nroCuotas(1)
                .tipoPlanillaId(1L)
                .build();
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static GanDescVariableRequest ganDescVariableRequest() {
        return GanDescVariableRequest.builder()
                .trabajadorId(1L)
                .fecMovim(LocalDate.of(2026, 2, 1))
                .conceptoId(1L)
                .nroDoc("DOC-002")
                .impVar(new BigDecimal("600.0000"))
                .centrosCostoId(1L)
                .cantLabor(new BigDecimal("25.0000"))
                .nroDias(new BigDecimal("10.00"))
                .nroHoras(new BigDecimal("80.00"))
                .nroCuotas(1)
                .tipoPlanillaId(1L)
                .build();
    }

    public static GanDescVariableResponse ganDescVariableResponse(Long id) {
        return GanDescVariableResponse.builder()
                .id(id)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .fecMovim("2026-01-15")
                .conceptoId(1L)
                .conceptoNombre("Sueldo Básico Test")
                .nroDoc("DOC-001")
                .impVar(new BigDecimal("500.0000"))
                .centrosCostoId(1L)
                .cantLabor(new BigDecimal("30.0000"))
                .nroDias(new BigDecimal("15.00"))
                .nroHoras(new BigDecimal("120.00"))
                .nroCuotas(1)
                .tipoPlanillaId(1L)
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .build();
    }

    // ── ControlSubsidio ──────────────────────────────────────────

    public static ControlSubsidio controlSubsidio(Long id) {
        return controlSubsidio(id, "1");
    }

    public static ControlSubsidio controlSubsidio(Long id, String flagEstado) {
        ControlSubsidio e = new ControlSubsidio();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setTipoSubsidioId(1L);
        e.setFechaInicio(LocalDate.of(2026, 1, 1));
        e.setFechaFin(LocalDate.of(2026, 1, 15));
        e.setDias(15);
        e.setMontoSubsidio(new BigDecimal("500.0000"));
        e.setFlagEstado(flagEstado);
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static ControlSubsidioCreateRequest controlSubsidioCreateRequest() {
        ControlSubsidioCreateRequest r = new ControlSubsidioCreateRequest();
        r.setTrabajadorId(1L);
        r.setTipoSubsidioId(1L);
        r.setFechaInicio(LocalDate.of(2026, 2, 1));
        r.setFechaFin(LocalDate.of(2026, 2, 15));
        r.setDias(15);
        r.setMontoSubsidio(new BigDecimal("600.0000"));
        return r;
    }

    public static ControlSubsidioUpdateRequest controlSubsidioUpdateRequest() {
        ControlSubsidioUpdateRequest r = new ControlSubsidioUpdateRequest();
        r.setFechaInicio(LocalDate.of(2026, 3, 1));
        r.setFechaFin(LocalDate.of(2026, 3, 15));
        r.setDias(15);
        r.setMontoSubsidio(new BigDecimal("700.0000"));
        r.setFlagEstado("1");
        return r;
    }

    public static ControlSubsidioResponse controlSubsidioResponse(Long id) {
        ControlSubsidioResponse r = new ControlSubsidioResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setTipoSubsidioId(1L);
        r.setFechaInicio("2026-01-01");
        r.setFechaFin("2026-01-15");
        r.setDias(15);
        r.setMontoSubsidio(new BigDecimal("500.0000"));
        r.setFlagEstado("1");
        r.setCreatedBy(DEFAULT_USUARIO_ID.toString());
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── EvaluacionDesempeno ──────────────────────────────────────

    public static EvaluacionDesempeno evaluacionDesempeno(Long id) {
        EvaluacionDesempeno e = EvaluacionDesempeno.builder()
                .trabajadorId(1L)
                .periodoAnio(2026)
                .periodoSemestre(1)
                .calificacion(new BigDecimal("15.50"))
                .observaciones("Buen desempeño")
                .evaluadorId(2L)
                .fechaEvaluacion(LocalDate.of(2026, 6, 15))
                .build();
        e.setId(id);
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static EvaluacionDesempenoCreateRequest evaluacionDesempenoCreateRequest() {
        EvaluacionDesempenoCreateRequest r = new EvaluacionDesempenoCreateRequest();
        r.setTrabajadorId(1L);
        r.setPeriodoAnio(2026);
        r.setPeriodoSemestre(1);
        r.setCalificacion(new BigDecimal("18.00"));
        r.setObservaciones("Excelente desempeño");
        r.setEvaluadorId(2L);
        r.setFechaEvaluacion(LocalDate.of(2026, 12, 15));
        return r;
    }

    public static EvaluacionDesempenoUpdateRequest evaluacionDesempenoUpdateRequest() {
        EvaluacionDesempenoUpdateRequest r = new EvaluacionDesempenoUpdateRequest();
        r.setCalificacion(new BigDecimal("16.00"));
        r.setObservaciones("Desempeño mejorado");
        return r;
    }

    public static EvaluacionDesempenoResponse evaluacionDesempenoResponse(Long id) {
        EvaluacionDesempenoResponse r = new EvaluacionDesempenoResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setPeriodoAnio(2026);
        r.setPeriodoSemestre(1);
        r.setCalificacion(new BigDecimal("15.50"));
        r.setObservaciones("Buen desempeño");
        r.setEvaluadorId(2L);
        r.setFechaEvaluacion("2026-06-15");
        r.setCreatedBy(DEFAULT_USUARIO_ID);
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }

    // ── Asistencia ────────────────────────────────────────────────

    public static Asistencia asistencia(Long id) {
        Asistencia e = new Asistencia();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setFecha(LocalDate.of(2026, 1, 15));
        e.setHoraEntrada(LocalTime.of(8, 0));
        e.setHoraSalida(LocalTime.of(17, 0));
        e.setTipoMovAsistenciaId(1L);
        e.setHorasTrabajadas(new BigDecimal("9.00"));
        e.setHorasExtra(new BigDecimal("1.00"));
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static AsistenciaRequest asistenciaRequest() {
        return AsistenciaRequest.builder()
                .trabajadorId(1L)
                .fecha(LocalDate.of(2026, 2, 1))
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(17, 0))
                .tipoMovAsistenciaId(1L)
                .build();
    }

    public static AsistenciaResponse asistenciaResponse(Long id) {
        return AsistenciaResponse.builder()
                .id(id)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .fecha("2026-01-15")
                .horaEntrada("08:00:00")
                .horaSalida("17:00:00")
                .tipoMovAsistencia(RefResponse.builder().id(1L).codigo("I").nombre("Ingreso").build())
                .horasTrabajadas(new BigDecimal("9.00"))
                .horasExtra(new BigDecimal("1.00"))
                .flagEstado("1")
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .build();
    }

    // ── Calculo ───────────────────────────────────────────────────

    public static Calculo calculo(Long id) {
        Calculo e = Calculo.builder()
                .id(id)
                .anio(2026)
                .mes(6)
                .tipoPlanillaId(1L)
                .totalIngresos(new BigDecimal("5000.0000"))
                .totalDescuentos(new BigDecimal("500.0000"))
                .totalNeto(new BigDecimal("4500.0000"))
                .totalAportes(new BigDecimal("500.0000"))
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(Instant.now())
                .build();
        return e;
    }

    public static CalculoDet calculoDet(Long id, Long calculoId) {
        return CalculoDet.builder()
                .id(id)
                .calculoId(calculoId)
                .trabajadorId(1L)
                .conceptoId(1L)
                .monto(new BigDecimal("2500.0000"))
                .tipoConceptoCalculoId(1L)
                .build();
    }

    public static CalculoResponse calculoResponse(Long id) {
        return CalculoResponse.builder()
                .id(id)
                .anio(2026)
                .mes(6)
                .tipoPlanillaId(1L)
                .tipoPlanillaNombre("Planilla Test")
                .totalIngresos(new BigDecimal("5000.0000"))
                .totalDescuentos(new BigDecimal("500.0000"))
                .totalNeto(new BigDecimal("4500.0000"))
                .totalAportes(new BigDecimal("500.0000"))
                .totalTrabajadores(0)
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .build();
    }

    public static CalculoDetResponse calculoDetResponse(Long id) {
        return CalculoDetResponse.builder()
                .id(id)
                .calculoId(1L)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .conceptoId(1L)
                .conceptoNombre("Remuneración básica")
                .monto(new BigDecimal("2500.0000"))
                .tipoConceptoCalculoId(1L)
                .tipoConceptoCalculoNombre("INGRESO")
                .build();
    }

    public static CalculoDetalleResponse calculoDetalleResponse(Long id) {
        return CalculoDetalleResponse.builder()
                .id(id)
                .anio(2026)
                .mes(6)
                .tipoPlanillaId(1L)
                .tipoPlanillaNombre("Planilla Test")
                .totalIngresos(new BigDecimal("5000.0000"))
                .totalDescuentos(new BigDecimal("500.0000"))
                .totalNeto(new BigDecimal("4500.0000"))
                .totalAportes(new BigDecimal("500.0000"))
                .totalTrabajadores(1)
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .detalles(List.of(calculoDetResponse(1L)))
                .build();
    }

    public static CalculoProcesarRequest calculoProcesarRequest() {
        return CalculoProcesarRequest.builder()
                .anio(2026)
                .mes(6)
                .tipoPlanillaId(1L)
                .build();
    }

    // ── Liquidacion ────────────────────────────────────────────────

    public static Liquidacion liquidacion(Long id) {
        Liquidacion e = new Liquidacion();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setFechaCese(LocalDate.of(2026, 1, 31));
        e.setCtsPendiente(new BigDecimal("1500.0000"));
        e.setVacacionesTruncas(new BigDecimal("250.0000"));
        e.setGratificacionTrunca(new BigDecimal("3000.0000"));
        e.setIndemnizacion(BigDecimal.ZERO);
        e.setTotalBeneficios(new BigDecimal("4750.0000"));
        e.setTotalDescuentos(new BigDecimal("390.0000"));
        e.setNetoPagar(new BigDecimal("4360.0000"));
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static LiquidacionResponse liquidacionResponse(Long id) {
        return LiquidacionResponse.builder()
                .id(id)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .fechaCese("2026-01-31")
                .ctsPendiente(new BigDecimal("1500.0000"))
                .vacacionesTruncas(new BigDecimal("250.0000"))
                .gratificacionTrunca(new BigDecimal("3000.0000"))
                .indemnizacion(BigDecimal.ZERO)
                .totalBeneficios(new BigDecimal("4750.0000"))
                .totalDescuentos(new BigDecimal("390.0000"))
                .netoPagar(new BigDecimal("4360.0000"))
                .flagEstado("1")
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .build();
    }

    // ── QuintaCategoria ────────────────────────────────────────────

    public static QuintaCategoria quintaCategoria(Long id) {
        QuintaCategoria e = new QuintaCategoria();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setAnio(2026);
        e.setMes(6);
        e.setRentaBrutaAcumulada(new BigDecimal("15000.0000"));
        e.setRentaBrutaProyectada(new BigDecimal("42000.0000"));
        e.setDeduccion7uit(new BigDecimal("37450.0000"));
        e.setRentaNeta(new BigDecimal("4550.0000"));
        e.setImpuestoAnualProyectado(new BigDecimal("364.0000"));
        e.setRetencionMensual(new BigDecimal("60.6667"));
        e.setRetencionAcumulada(new BigDecimal("364.0000"));
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static QuintaCategoriaResponse quintaCategoriaResponse(Long id) {
        return QuintaCategoriaResponse.builder()
                .id(id)
                .trabajadorId(1L)
                .trabajadorNombres("Paterno Materno, Nombre 1")
                .anio(2026)
                .mes(6)
                .rentaBrutaAcumulada(new BigDecimal("15000.0000"))
                .rentaBrutaProyectada(new BigDecimal("42000.0000"))
                .deduccion7uit(new BigDecimal("37450.0000"))
                .rentaNeta(new BigDecimal("4550.0000"))
                .impuestoAnualProyectado(new BigDecimal("364.0000"))
                .retencionMensual(new BigDecimal("60.6667"))
                .retencionAcumulada(new BigDecimal("364.0000"))
                .createdBy(DEFAULT_USUARIO_ID)
                .fecCreacion(null)
                .updatedBy(null)
                .fecModificacion(null)
                .build();
    }

    // ── ProgramVacacion ──────────────────────────────────────────

    public static ProgramVacacion programVacacion(Long id) {
        ProgramVacacion e = new ProgramVacacion();
        e.setId(id);
        e.setTrabajadorId(1L);
        e.setAnio(2026);
        e.setMes(3);
        e.setDiasProgramados(15);
        e.setObservacion("Vacaciones programadas");
        e.setFlagEstado("1");
        e.setCreatedBy(DEFAULT_USUARIO_ID);
        e.setFecCreacion(Instant.now());
        return e;
    }

    public static ProgramVacacionCreateRequest programVacacionCreateRequest() {
        ProgramVacacionCreateRequest r = new ProgramVacacionCreateRequest();
        r.setTrabajadorId(1L);
        r.setAnio(2026);
        r.setMes(3);
        r.setDiasProgramados(15);
        r.setObservacion("Vacaciones nuevas");
        return r;
    }

    public static ProgramVacacionUpdateRequest programVacacionUpdateRequest() {
        ProgramVacacionUpdateRequest r = new ProgramVacacionUpdateRequest();
        r.setDiasProgramados(10);
        r.setObservacion("Actualizado");
        r.setFlagEstado("1");
        return r;
    }

    public static ProgramVacacionResponse programVacacionResponse(Long id) {
        ProgramVacacionResponse r = new ProgramVacacionResponse();
        r.setId(id);
        r.setTrabajadorId(1L);
        r.setAnio(2026);
        r.setMes(3);
        r.setDiasProgramados(15);
        r.setObservacion("Vacaciones programadas");
        r.setFlagEstado("1");
        r.setCreatedBy(String.valueOf(DEFAULT_USUARIO_ID));
        r.setFecCreacion(null);
        r.setUpdatedBy(null);
        r.setFecModificacion(null);
        return r;
    }
}
