package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.AprobarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.request.OperacionMasivaGiroRequest;
import pe.restaurant.finanzas.dto.request.RechazarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.response.OperacionMasivaGiroResultadoResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.SolicitudGiroDetalleResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.service.OrdenGiroAprobacionExportService;
import pe.restaurant.finanzas.service.OrdenGiroAprobacionService;
import pe.restaurant.finanzas.service.PermisoAprobacionGiroValidator;
import pe.restaurant.finanzas.service.SolicitudGiroService;

import java.time.LocalDate;

/**
 * Endpoints dedicados a la <b>Aprobación de Órdenes de Giro</b> (HU-FIN-ADL-002), implementados
 * <b>sin modificar la BD</b> y sin alterar los endpoints existentes de
 * {@code /api/finanzas/solicitudes-giro} ni los de generación
 * {@code /api/finanzas/ordenes-giro}. Viven en una ruta propia
 * ({@code /api/finanzas/ordenes-giro/aprobacion}) para no romper contratos: el segmento literal
 * {@code aprobacion} tiene prioridad sobre cualquier path variable de las rutas hermanas.
 */
@RestController
@RequestMapping("/api/finanzas/ordenes-giro/aprobacion")
@RequiredArgsConstructor
@Tag(name = "Aprobación de Órdenes de Giro", description = "HU-FIN-ADL-002 - Aprobar / Rechazar Órdenes de Giro (tipo O)")
public class OrdenGiroAprobacionController {

    private final OrdenGiroAprobacionService service;
    private final OrdenGiroAprobacionExportService exportService;
    private final SolicitudGiroService solicitudGiroService;

    @GetMapping("/pendientes")
    @Operation(summary = "Listar Órdenes de Giro pendientes de aprobación",
               description = "Listado paginado (flag_estado=3) con filtros: rango de fechas, beneficiario, centro de costo y sucursal")
    public ApiResponse<PageData<SolicitudGiroResponse>> listarPendientes(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) Long beneficiarioId,
            @RequestParam(required = false) Long centrosCostoId,
            @RequestParam(required = false) Long sucursalId,
            Pageable pageable) {
        Page<SolicitudGiroResponse> page = service.listarPendientes(
                fechaDesde, fechaHasta, beneficiarioId, centrosCostoId, sucursalId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping
    @Operation(summary = "Listar Órdenes de Giro (cualquier estado)",
               description = "Listado paginado con filtros: estado, rango de fechas, beneficiario, centro de costo y sucursal")
    public ApiResponse<PageData<SolicitudGiroResponse>> listar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long beneficiarioId,
            @RequestParam(required = false) Long centrosCostoId,
            @RequestParam(required = false) Long sucursalId,
            Pageable pageable) {
        Page<SolicitudGiroResponse> page = service.listar(
                fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId, sucursalId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Ver detalle de una Orden de Giro",
               description = "Detalle completo previo a aprobar/rechazar (reutiliza el detalle existente)")
    public ApiResponse<SolicitudGiroDetalleResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(solicitudGiroService.obtenerPorId(id));
    }

    @PostMapping("/{id}/aprobar")
    @Operation(summary = "Aprobar Orden de Giro",
               description = "Valida rol (RBAC existente), cambia a Aprobada y registra aprobador/fecha. Observación opcional (no persistida por falta de columna)")
    public ApiResponse<SolicitudGiroDetalleResponse> aprobar(
            @PathVariable Long id,
            @RequestBody(required = false) AprobarOrdenGiroRequest request) {
        SolicitudGiroDetalleResponse resultado = service.aprobar(id, request);
        return ApiResponse.ok(resultado, "Orden de Giro aprobada");
    }

    @PostMapping("/{id}/rechazar")
    @Operation(summary = "Rechazar Orden de Giro (observación obligatoria)",
               description = "Valida rol (RBAC existente), exige observación (@NotBlank) y cambia a estado Rechazada (diferenciado de Anulada)")
    public ApiResponse<SolicitudGiroDetalleResponse> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody RechazarOrdenGiroRequest request) {
        SolicitudGiroDetalleResponse resultado = service.rechazar(id, request);
        return ApiResponse.ok(resultado, "Orden de Giro rechazada");
    }

    @PostMapping("/aprobar-masivo")
    @Operation(summary = "Aprobación masiva de Órdenes de Giro",
               description = "Aprueba varias Órdenes de Giro; cada una se procesa en su propia transacción")
    public ApiResponse<OperacionMasivaGiroResultadoResponse> aprobarMasivo(
            @Valid @RequestBody OperacionMasivaGiroRequest request) {
        return ApiResponse.ok(service.aprobarMasivo(request), "Aprobación masiva procesada");
    }

    @PostMapping("/rechazar-masivo")
    @Operation(summary = "Rechazo masivo de Órdenes de Giro (observación obligatoria)",
               description = "Rechaza varias Órdenes de Giro con una observación obligatoria; cada una en su propia transacción")
    public ApiResponse<OperacionMasivaGiroResultadoResponse> rechazarMasivo(
            @Valid @RequestBody OperacionMasivaGiroRequest request) {
        return ApiResponse.ok(service.rechazarMasivo(request), "Rechazo masivo procesado");
    }

    @GetMapping(value = "/export", produces = {
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "text/csv",
            "application/pdf"
    })
    @Operation(summary = "Exportar listado de Aprobación de Órdenes de Giro",
               description = "Exporta el listado filtrado a xlsx, pdf o csv (incluye Usuario Aprobador y estado Rechazada)")
    public ResponseEntity<byte[]> exportar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long beneficiarioId,
            @RequestParam(required = false) Long centrosCostoId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(defaultValue = "xlsx") String formato) {
        byte[] bytes = exportService.exportarListado(
                fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId, sucursalId, formato);
        return archivo(bytes, formato, "aprobacion-ordenes-giro");
    }

    private ResponseEntity<byte[]> archivo(byte[] bytes, String formato, String base) {
        String fmt = formato == null ? "xlsx" : formato.toLowerCase();
        MediaType mediaType = switch (fmt) {
            case "csv" -> MediaType.parseMediaType("text/csv");
            case "pdf" -> MediaType.APPLICATION_PDF;
            default -> MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        };
        String ext = "pdf".equals(fmt) ? "pdf" : ("csv".equals(fmt) ? "csv" : "xlsx");
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + base + "." + ext)
                .contentType(mediaType)
                .body(bytes);
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(ResourceNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(ex.getMessage(), "RESOURCE_NOT_FOUND"));
    }

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException ex) {
        // Respeta 403 (acceso denegado) y 503 (auth no disponible) del validador RBAC;
        // el resto de reglas de negocio se mapean a 422 como en los controladores hermanos.
        HttpStatus status = switch (ex.getStatus()) {
            case FORBIDDEN, SERVICE_UNAVAILABLE -> ex.getStatus();
            default -> HttpStatus.UNPROCESSABLE_ENTITY;
        };
        return ResponseEntity.status(status)
                .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }
}
