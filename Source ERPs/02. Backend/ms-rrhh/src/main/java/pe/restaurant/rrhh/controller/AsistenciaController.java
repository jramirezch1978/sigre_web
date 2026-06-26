package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.constants.AsistenciaConstants;
import pe.restaurant.rrhh.dto.request.AsistenciaImportarRequest;
import pe.restaurant.rrhh.dto.request.AsistenciaRegularizarRequest;
import pe.restaurant.rrhh.dto.request.AsistenciaRequest;
import pe.restaurant.rrhh.dto.request.ProcesarPeriodoRequest;
import pe.restaurant.rrhh.dto.response.AsistenciaResponse;
import pe.restaurant.rrhh.entity.Asistencia;
import pe.restaurant.rrhh.mapper.AsistenciaMapper;
import pe.restaurant.rrhh.service.AsistenciaService;

import java.time.LocalDate;
import java.util.List;

/**
 * Controller REST para la gestión de registros de asistencia.
 * <p>
 * Base path: {@code /api/rrhh/asistencias}
 * <p>
 * Implementa los 5 endpoints: listar, detalle, crear, actualizar y anular.
 */
@RestController
@RequestMapping("/api/rrhh/asistencias")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Asistencias", description = "Gestión de registros de asistencia de trabajadores")
public class AsistenciaController {

    private final AsistenciaService service;
    private final AsistenciaMapper mapper;

    /**
     * Lista registros de asistencia con filtros opcionales y paginación.
     *
     * @param pageable     paginación inyectada (page, size, sort)
     * @param trabajadorId filtro exacto por trabajador
     * @param fechaDesde   fecha inicio del rango
     * @param fechaHasta   fecha fin del rango
     * @param tipoMarca    filtro exacto por tipo de marca
     * @return página de asistencias en formato DTO
     */
    @GetMapping
    @Operation(summary = "Listar asistencias", description = "Lista paginada con filtros opcionales")
    public ResponseEntity<ApiResponse<Page<AsistenciaResponse>>> listar(
            Pageable pageable,
            @Parameter(description = "ID del trabajador") @RequestParam(required = false) Long trabajadorId,
            @Parameter(description = "Fecha desde (yyyy-MM-dd)") @RequestParam(required = false) LocalDate fechaDesde,
            @Parameter(description = "Fecha hasta (yyyy-MM-dd)") @RequestParam(required = false) LocalDate fechaHasta,
            @Parameter(description = "ID del tipo de movimiento de asistencia") @RequestParam(required = false) Long tipoMovAsistenciaId) {

        log.info("GET /api/rrhh/asistencias - filtros: trabajador={}, desde={}, hasta={}, tipoMovAsistenciaId={}",
                trabajadorId, fechaDesde, fechaHasta, tipoMovAsistenciaId);

        Page<AsistenciaResponse> page = service.listar(trabajadorId, fechaDesde, fechaHasta, tipoMovAsistenciaId, pageable)
                .map(mapper::toResponse);

        return ResponseEntity.ok(ApiResponse.<Page<AsistenciaResponse>>builder()
                .success(true).message("Operación exitosa").data(page).build());
    }

    /**
     * Obtiene el detalle de un registro de asistencia por su ID.
     *
     * @param id ID de la asistencia
     * @return detalle de la asistencia con campos de auditoría
     */
    @GetMapping("/{id}")
    @Operation(summary = "Detalle de asistencia", description = "Retorna detalle completo del registro")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> obtener(
            @Parameter(description = "ID de la asistencia") @PathVariable Long id) {

        log.info("GET /api/rrhh/asistencias/{}", id);

        AsistenciaResponse resp = mapper.toResponse(service.obtenerPorId(id));

        return ResponseEntity.ok(ApiResponse.<AsistenciaResponse>builder()
                .success(true).message("Operación exitosa").data(resp).build());
    }

    /**
     * Crea un nuevo registro de asistencia.
     * Calcula automáticamente horas trabajadas y extras.
     *
     * @param request datos de la marca de asistencia
     * @return asistencia creada con HTTP 201
     */
    @PostMapping
    @Operation(summary = "Crear asistencia", description = "Registra una nueva marca de asistencia")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> crear(
            @Valid @RequestBody AsistenciaRequest request) {

        log.info("POST /api/rrhh/asistencias - trabajador={}, fecha={}", request.getTrabajadorId(), request.getFecha());

        Asistencia asistencia = mapRequestToEntity(request);
        Asistencia saved = service.crear(asistencia);
        AsistenciaResponse resp = mapper.toResponse(saved);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<AsistenciaResponse>builder()
                        .success(true).message("Asistencia registrada exitosamente").data(resp).build());
    }

    /**
     * Actualiza un registro de asistencia existente.
     * Solo permite actualización si el registro está activo (flagEstado='1').
     *
     * @param id      ID de la asistencia
     * @param request datos actualizados
     * @return asistencia actualizada
     */
    @PutMapping("/{id}")
    @Operation(summary = "Actualizar asistencia", description = "Modifica un registro activo de asistencia")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> actualizar(
            @Parameter(description = "ID de la asistencia") @PathVariable Long id,
            @Valid @RequestBody AsistenciaRequest request) {

        log.info("PUT /api/rrhh/asistencias/{}", id);

        Asistencia datos = mapRequestToEntity(request);
        Asistencia saved = service.actualizar(id, datos);
        AsistenciaResponse resp = mapper.toResponse(saved);

        return ResponseEntity.ok(ApiResponse.<AsistenciaResponse>builder()
                .success(true).message("Asistencia actualizada exitosamente").data(resp).build());
    }

    /**
     * Anula (elimina físicamente) un registro de asistencia.
     * La tabla no posee columna de estado, por lo que el borrado es físico.
     *
     * @param id ID de la asistencia
     * @return confirmación de la operación
     */
    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular asistencia", description = "Elimina físicamente el registro de asistencia")
    public ResponseEntity<ApiResponse<Void>> anular(
            @Parameter(description = "ID de la asistencia") @PathVariable Long id) {

        log.info("POST /api/rrhh/asistencias/{}/anular", id);

        service.anular(id);

        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true).message("Asistencia anulada exitosamente").data(null).build());
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO
    // ══════════════════════════════════════════════════════════════

    @Operation(summary = "Aprobar asistencia")
    @PostMapping("/{id}/aprobar")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> aprobar(@PathVariable Long id) {
        log.info("POST /api/rrhh/asistencias/{}/aprobar", id);
        AsistenciaResponse resp = mapper.toResponse(service.aprobar(id));
        return ResponseEntity.ok(ApiResponse.<AsistenciaResponse>builder()
                .success(true).message("Asistencia aprobada exitosamente").data(resp).build());
    }

    @Operation(summary = "Rechazar asistencia")
    @PostMapping("/{id}/rechazar")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> rechazar(@PathVariable Long id) {
        log.info("POST /api/rrhh/asistencias/{}/rechazar", id);
        AsistenciaResponse resp = mapper.toResponse(service.rechazar(id));
        return ResponseEntity.ok(ApiResponse.<AsistenciaResponse>builder()
                .success(true).message("Asistencia rechazada exitosamente").data(resp).build());
    }

    @Operation(summary = "Regularizar asistencia")
    @PostMapping("/{id}/regularizar")
    public ResponseEntity<ApiResponse<AsistenciaResponse>> regularizar(
            @PathVariable Long id, @Valid @RequestBody AsistenciaRegularizarRequest request) {
        log.info("POST /api/rrhh/asistencias/{}/regularizar", id);
        AsistenciaResponse resp = mapper.toResponse(service.regularizar(id, request));
        return ResponseEntity.ok(ApiResponse.<AsistenciaResponse>builder()
                .success(true).message("Asistencia regularizada exitosamente").data(resp).build());
    }

    @Operation(summary = "Desactivar asistencia (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AsistenciaResponse> desactivar(@PathVariable Long id) {
        log.info("PATCH /api/rrhh/asistencias/{}/desactivar", id);
        return ApiResponse.ok(service.desactivar(id), AsistenciaConstants.MSG_DESACTIVADO);
    }

    // ══════════════════════════════════════════════════════════════
    //  IMPORTACIÓN / EXPORTACIÓN
    // ══════════════════════════════════════════════════════════════

    @Operation(summary = "Importar asistencias (batch)")
    @PostMapping("/importar")
    public ResponseEntity<ApiResponse<List<AsistenciaResponse>>> importar(
            @Valid @RequestBody AsistenciaImportarRequest request) {
        log.info("POST /api/rrhh/asistencias/importar - {} registros", request.registros().size());
        List<AsistenciaResponse> results = service.importar(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.<List<AsistenciaResponse>>builder()
                        .success(true).message("Importación completada").data(results).build());
    }

    @Operation(summary = "Exportar asistencias a Excel")
    @GetMapping("/exportar")
    public ResponseEntity<byte[]> exportar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        byte[] bytes = service.exportarExcel(fechaDesde, fechaHasta);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=asistencias.xlsx")
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(bytes);
    }

    @Operation(summary = "Procesar período de asistencia")
    @PostMapping("/procesar")
    public ResponseEntity<ApiResponse<Void>> procesarPeriodo(
            @Valid @RequestBody ProcesarPeriodoRequest request) {
        log.info("POST /api/rrhh/asistencias/procesar - desde: {}, hasta: {}", request.fechaDesde(), request.fechaHasta());
        service.procesarPeriodo(request.fechaDesde(), request.fechaHasta());
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true).message("Período procesado exitosamente").build());
    }

    // ══════════════════════════════════════════════════════════════
    //  HELPER
    // ══════════════════════════════════════════════════════════════

    /** Convierte un {@link AsistenciaRequest} a la entidad {@link Asistencia}. */
    private Asistencia mapRequestToEntity(AsistenciaRequest r) {
        Asistencia asistencia = new Asistencia();
        asistencia.setTrabajadorId(r.getTrabajadorId());
        asistencia.setFecha(r.getFecha());
        asistencia.setHoraEntrada(r.getHoraEntrada());
        asistencia.setHoraSalida(r.getHoraSalida());
        asistencia.setTipoMovAsistenciaId(r.getTipoMovAsistenciaId());
        asistencia.setFlagEstado("1");
        return asistencia;
    }
}
