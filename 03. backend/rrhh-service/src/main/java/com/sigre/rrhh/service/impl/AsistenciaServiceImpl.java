package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.AsistenciaImportRequest;
import com.sigre.rrhh.dto.request.AsistenciaImportarRequest;
import com.sigre.rrhh.dto.request.AsistenciaRegularizarRequest;
import com.sigre.rrhh.dto.request.AsistenciaRequest;
import com.sigre.rrhh.dto.response.AsistenciaResponse;
import com.sigre.rrhh.entity.Asistencia;
import com.sigre.rrhh.mapper.AsistenciaMapper;
import com.sigre.rrhh.repository.AsistenciaRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.AsistenciaService;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Implementación del servicio de asistencia.
 * Contiene la lógica de negocio para las operaciones CRUD
 * y anulación de registros de asistencia (marcas).
 */
@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class AsistenciaServiceImpl implements AsistenciaService {

    private final AsistenciaRepository asistenciaRepo;
    private final TrabajadorRepository trabajadorRepo;
    private final AsistenciaMapper mapper;

    private static final BigDecimal JORNADA_NORMAL = new BigDecimal("8.00");

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public Page<Asistencia> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                                   Long tipoMovAsistenciaId, Pageable pageable) {
        return asistenciaRepo.findWithFilters(trabajadorId, fechaDesde, fechaHasta, tipoMovAsistenciaId, pageable);
    }

    /** {@inheritDoc} */
    @Override
    @Transactional(readOnly = true)
    public Asistencia obtenerPorId(Long id) {
        return asistenciaRepo.findById(id)
                .orElseThrow(() -> notFound("Asistencia no encontrada con ID: " + id));
    }

    /**
     * {@inheritDoc}
     * <p>Validaciones aplicadas (en orden):
     * <ul>
     *   <li>RH-AS-001 — trabajador existe y está activo</li>
     *   <li>RH-AS-002 — no duplicidad de marca para mismo trabajador + fecha</li>
     *   <li>RH-AS-003 — hora_salida posterior a hora_entrada</li>
     * </ul>
     */
    @Override
    @Timed("rrhh.asistencia.crear")
    public Asistencia crear(Asistencia a) {
        validarTrabajadorActivo(a.getTrabajadorId());
        validarTipoMovAsistencia(a.getTipoMovAsistenciaId());
        validarUnicidadCreacion(a);
        validarHoras(a);
        calcularHoras(a);
        if (a.getFlagEstado() == null) a.setFlagEstado("1");
        setAuditCreacion(a);
        return asistenciaRepo.save(a);
    }

    /**
     * {@inheritDoc}
     * <p>Validaciones:
     * <ul>
     *   <li>RH-AS-004 — registro debe estar activo para modificarse</li>
     *   <li>RH-AS-001 — trabajador existe y está activo</li>
     *   <li>RH-AS-002 — no duplicidad excluyendo el registro actual</li>
     *   <li>RH-AS-003 — hora_salida posterior a hora_entrada</li>
     * </ul>
     */
    @Override
    public Asistencia actualizar(Long id, Asistencia datos) {
        Asistencia existing = obtenerPorId(id);
        validarTrabajadorActivo(datos.getTrabajadorId());
        validarTipoMovAsistencia(datos.getTipoMovAsistenciaId());
        validarUnicidadActualizacion(datos, id);
        validarHoras(datos);
        calcularHoras(datos);

        existing.setTrabajadorId(datos.getTrabajadorId());
        existing.setFecha(datos.getFecha());
        existing.setHoraEntrada(datos.getHoraEntrada());
        existing.setHoraSalida(datos.getHoraSalida());
        existing.setTipoMovAsistenciaId(datos.getTipoMovAsistenciaId());
        existing.setHorasTrabajadas(datos.getHorasTrabajadas());
        existing.setHorasExtra(datos.getHorasExtra());
        setAuditModificacion(existing);
        return asistenciaRepo.save(existing);
    }

    /**
     * {@inheritDoc}
     * <p>Anulación lógica mediante {@code flag_estado = '0'}.
     */
    @Override
    public void anular(Long id) {
        Asistencia a = obtenerPorId(id);
        a.setFlagEstado("0");
        setAuditModificacion(a);
        asistenciaRepo.save(a);
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO
    // ══════════════════════════════════════════════════════════════

    @Override
    @Transactional
    @Timed("rrhh.asistencia.aprobar")
    public Asistencia aprobar(Long id) {
        Asistencia a = obtenerPorId(id);
        if (!List.of("1", "P").contains(a.getFlagEstado())) {
            throw new BusinessException("Solo se pueden aprobar asistencias en estado activo o pendiente",
                    HttpStatus.BAD_REQUEST, "RH-AS-004");
        }
        a.setFlagEstado("A");
        setAuditModificacion(a);
        return asistenciaRepo.save(a);
    }

    @Override
    @Transactional
    @Timed("rrhh.asistencia.rechazar")
    public Asistencia rechazar(Long id) {
        Asistencia a = obtenerPorId(id);
        if (!List.of("1", "P").contains(a.getFlagEstado())) {
            throw new BusinessException("Solo se pueden rechazar asistencias en estado activo o pendiente",
                    HttpStatus.BAD_REQUEST, "RH-AS-004");
        }
        a.setFlagEstado("R");
        setAuditModificacion(a);
        return asistenciaRepo.save(a);
    }

    @Override
    @Transactional
    @Timed("rrhh.asistencia.regularizar")
    public Asistencia regularizar(Long id, AsistenciaRegularizarRequest request) {
        Asistencia a = obtenerPorId(id);
        if (request.horaEntrada() != null) a.setHoraEntrada(request.horaEntrada());
        if (request.horaSalida() != null) a.setHoraSalida(request.horaSalida());
        setAuditModificacion(a);
        return asistenciaRepo.save(a);
    }

    @Override
    @Timed("rrhh.asistencia.desactivar")
    public AsistenciaResponse desactivar(Long id) {
        Asistencia a = obtenerPorId(id);
        a.setFlagEstado("0");
        setAuditModificacion(a);
        return mapper.toResponse(asistenciaRepo.save(a));
    }

    // ══════════════════════════════════════════════════════════════
    //  VALIDACIONES PRIVADAS
    // ══════════════════════════════════════════════════════════════

    /** Verifica que el trabajador exista y esté activo (RH-AS-001). */
    private void validarTrabajadorActivo(Long trabajadorId) {
        var trabajador = trabajadorRepo.findById(trabajadorId)
                .orElseThrow(() -> new BusinessException(
                        "Trabajador no encontrado con ID: " + trabajadorId,
                        HttpStatus.UNPROCESSABLE_ENTITY, "RH-AS-001"));

        if ("0".equals(trabajador.getFlagEstado())) {
            throw new BusinessException(
                    "El trabajador con ID " + trabajadorId + " está inactivo",
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-AS-001");
        }
    }

    /** Verifica que el tipo de movimiento de asistencia referenciado exista. */
    private void validarTipoMovAsistencia(Long tipoMovAsistenciaId) {
        if (tipoMovAsistenciaId != null && !asistenciaRepo.existsTipoMovAsistenciaById(tipoMovAsistenciaId)) {
            throw new BusinessException(
                    "Tipo de movimiento de asistencia no encontrado con ID: " + tipoMovAsistenciaId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-AS-001");
        }
    }

    /** Verifica unicidad de trabajador + fecha al crear (RH-AS-002). */
    private void validarUnicidadCreacion(Asistencia a) {
        if (asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstado(a.getTrabajadorId(), a.getFecha(), "1")) {
            throw new BusinessException(
                    "Ya existe un registro de asistencia para este trabajador en la fecha " + a.getFecha(),
                    HttpStatus.CONFLICT, "RH-AS-002");
        }
    }

    /** Verifica unicidad excluyendo el registro actual al actualizar (RH-AS-002). */
    private void validarUnicidadActualizacion(Asistencia a, Long id) {
        if (asistenciaRepo.existsByTrabajadorIdAndFechaAndFlagEstadoAndIdNot(a.getTrabajadorId(), a.getFecha(), "1", id)) {
            throw new BusinessException(
                    "Ya existe un registro de asistencia para este trabajador en la fecha " + a.getFecha(),
                    HttpStatus.CONFLICT, "RH-AS-002");
        }
    }

    /** Verifica que hora_salida sea posterior a hora_entrada cuando ambas se proporcionan (RH-AS-003). */
    private void validarHoras(Asistencia a) {
        if (a.getHoraEntrada() != null && a.getHoraSalida() != null) {
            if (!a.getHoraSalida().isAfter(a.getHoraEntrada())) {
                throw new BusinessException(
                        "La hora de salida debe ser posterior a la hora de entrada",
                        HttpStatus.BAD_REQUEST, "RH-AS-003");
            }
        }
    }

    /**
     * Calcula horas_trabajadas a partir de hora_entrada y hora_salida.
     * Si horas_trabajadas > 8, las horas_extra = horas_trabajadas - 8.
     */
    private void calcularHoras(Asistencia a) {
        if (a.getHoraEntrada() != null && a.getHoraSalida() != null) {
            long minutos = Duration.between(a.getHoraEntrada(), a.getHoraSalida()).toMinutes();
            BigDecimal horas = BigDecimal.valueOf(minutos)
                    .divide(BigDecimal.valueOf(60), 2, RoundingMode.HALF_UP);
            a.setHorasTrabajadas(horas);

            if (horas.compareTo(JORNADA_NORMAL) > 0) {
                a.setHorasExtra(horas.subtract(JORNADA_NORMAL));
            } else {
                a.setHorasExtra(BigDecimal.ZERO);
            }
        } else {
            a.setHorasTrabajadas(null);
            a.setHorasExtra(null);
        }
    }

    // ── Factories de excepciones ─────────────────────────────────

    private BusinessException notFound(String msg) {
        return new BusinessException(msg, HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
    }

    // ── Auditoría manual ─────────────────────────────────────────

    /** Setea created_by y fec_creacion antes del primer save. */
    private void setAuditCreacion(Asistencia entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
    }

    /** Setea updated_by y fec_modificacion antes de cada update. */
    private void setAuditModificacion(Asistencia entity) {
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
    }

    // ══════════════════════════════════════════════════════════════
    //  IMPORTACIÓN BATCH
    // ══════════════════════════════════════════════════════════════

    @Override @Transactional @Timed("rrhh.asistencia.importar")
    public List<AsistenciaResponse> importar(AsistenciaImportarRequest request) {
        List<AsistenciaResponse> results = new ArrayList<>();
        for (AsistenciaImportarRequest.AsistenciaImportRow row : request.registros()) {
            Asistencia a = new Asistencia();
            a.setTrabajadorId(row.trabajadorId());
            a.setFecha(row.fecha());
            a.setHoraEntrada(row.horaEntrada());
            a.setHoraSalida(row.horaSalida());
            a.setTipoMovAsistenciaId(row.tipoMovAsistenciaId());
            a.setFlagEstado("1");
            a.setCreatedBy(TenantContext.getUsuarioId());
            a.setFecCreacion(Instant.now());
            results.add(mapper.toResponse(asistenciaRepo.save(a)));
        }
        return results;
    }

    // ══════════════════════════════════════════════════════════════
    //  EXPORTACIÓN EXCEL
    // ══════════════════════════════════════════════════════════════

    @Override @Timed("rrhh.asistencia.exportar")
    public byte[] exportarExcel(LocalDate fechaDesde, LocalDate fechaHasta) {
        List<Asistencia> list;
        if (fechaDesde != null && fechaHasta != null) {
            list = asistenciaRepo.findByFechaBetween(fechaDesde, fechaHasta);
        } else {
            list = asistenciaRepo.findAll();
        }

        try (Workbook wb = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            Sheet sheet = wb.createSheet("Asistencias");
            Row header = sheet.createRow(0);
            String[] cols = {"ID", "Trabajador ID", "Fecha", "Hora Entrada", "Hora Salida",
                             "Tipo Mov", "Horas Trabajadas", "Horas Extra", "Estado"};
            for (int i = 0; i < cols.length; i++) {
                header.createCell(i).setCellValue(cols[i]);
            }
            int r = 1;
            for (Asistencia a : list) {
                Row row = sheet.createRow(r++);
                row.createCell(0).setCellValue(a.getId() != null ? a.getId() : 0);
                row.createCell(1).setCellValue(a.getTrabajadorId() != null ? a.getTrabajadorId() : 0);
                row.createCell(2).setCellValue(a.getFecha() != null ? a.getFecha().toString() : "");
                row.createCell(3).setCellValue(a.getHoraEntrada() != null ? a.getHoraEntrada().toString() : "");
                row.createCell(4).setCellValue(a.getHoraSalida() != null ? a.getHoraSalida().toString() : "");
                row.createCell(5).setCellValue(a.getTipoMovAsistenciaId() != null ? a.getTipoMovAsistenciaId() : 0);
                row.createCell(6).setCellValue(a.getHorasTrabajadas() != null ? a.getHorasTrabajadas().doubleValue() : 0);
                row.createCell(7).setCellValue(a.getHorasExtra() != null ? a.getHorasExtra().doubleValue() : 0);
                row.createCell(8).setCellValue(a.getFlagEstado() != null ? a.getFlagEstado() : "");
            }
            for (int i = 0; i < cols.length; i++) sheet.autoSizeColumn(i);
            wb.write(out);
            return out.toByteArray();
        } catch (Exception e) {
            throw new BusinessException("Error al exportar Excel: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "RH-AS-500");
        }
    }

    // ══════════════════════════════════════════════════════════════
    //  PROCESOS BATCH
    // ══════════════════════════════════════════════════════════════

    @Override @Transactional @Timed("rrhh.asistencia.procesarPeriodo")
    public void procesarPeriodo(LocalDate fechaDesde, LocalDate fechaHasta) {
        int actualizados = asistenciaRepo.actualizarEstadoPorRangoFechas(
                fechaDesde, fechaHasta, "C", TenantContext.getUsuarioId());
        log.info("Período procesado: {} asistencias cerradas entre {} y {}", actualizados, fechaDesde, fechaHasta);
    }
}
