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
import pe.restaurant.finanzas.dto.request.GenerarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.request.OperacionMasivaGiroRequest;
import pe.restaurant.finanzas.dto.request.RechazarOrdenGiroRequest;
import pe.restaurant.finanzas.dto.response.OperacionMasivaGiroResultadoResponse;
import pe.restaurant.finanzas.dto.response.OrdenGiroGeneradaResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.service.OrdenGiroExportService;
import pe.restaurant.finanzas.service.OrdenGiroService;

import java.time.LocalDate;
import java.util.Map;

/**
 * Endpoints dedicados a la <b>Generación de Órdenes de Giro</b> (HU-FIN-ADL-001),
 * implementados <b>sin modificar la BD</b> y sin alterar los endpoints existentes de
 * {@code /api/finanzas/solicitudes-giro}. Vive en una ruta propia para no romper contratos.
 */
@RestController
@RequestMapping("/api/finanzas/ordenes-giro")
@RequiredArgsConstructor
@Tag(name = "Órdenes de Giro", description = "HU-FIN-ADL-001 - Generación de Órdenes de Giro (tipo O)")
public class OrdenGiroController {

    private final OrdenGiroService service;
    private final OrdenGiroExportService exportService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Generar Orden de Giro",
               description = "Genera una Orden de Giro (tipo O forzado). Valida monto vs saldo disponible y cuenta bancaria activa/de la sucursal")
    public ApiResponse<OrdenGiroGeneradaResponse> generar(@Valid @RequestBody GenerarOrdenGiroRequest request) {
        OrdenGiroGeneradaResponse resultado = service.generar(request);
        return ApiResponse.ok(resultado, "Orden de Giro generada");
    }

    @GetMapping
    @Operation(summary = "Listar Órdenes de Giro",
               description = "Listado paginado de Órdenes de Giro (tipo O) con filtros: estado, rango de fechas, beneficiario y centro de costo")
    public ApiResponse<PageData<SolicitudGiroResponse>> listar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long beneficiarioId,
            @RequestParam(required = false) Long centrosCostoId,
            Pageable pageable) {
        Page<SolicitudGiroResponse> page = service.listar(
                fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @PostMapping("/{id}/rechazar")
    @Operation(summary = "Rechazar Orden de Giro (observación obligatoria)",
               description = "Rechaza una Orden de Giro exigiendo observación (@NotBlank). No altera el endpoint /solicitudes-giro/{id}/rechazar")
    public ApiResponse<Map<String, Object>> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody RechazarOrdenGiroRequest request) {
        Map<String, Object> resultado = service.rechazarConObservacion(id, request);
        return ApiResponse.ok(resultado, "Orden de Giro rechazada");
    }

    @PostMapping("/aprobar-masivo")
    @Operation(summary = "Aprobación masiva de Órdenes de Giro",
               description = "Aprueba varias Órdenes de Giro; cada una se procesa de forma independiente")
    public ApiResponse<OperacionMasivaGiroResultadoResponse> aprobarMasivo(
            @Valid @RequestBody OperacionMasivaGiroRequest request) {
        OperacionMasivaGiroResultadoResponse resultado = service.aprobarMasivo(request);
        return ApiResponse.ok(resultado, "Aprobación masiva procesada");
    }

    @PostMapping("/anular-masivo")
    @Operation(summary = "Anulación masiva de Órdenes de Giro",
               description = "Anula varias Órdenes de Giro; cada una se procesa de forma independiente")
    public ApiResponse<OperacionMasivaGiroResultadoResponse> anularMasivo(
            @Valid @RequestBody OperacionMasivaGiroRequest request) {
        OperacionMasivaGiroResultadoResponse resultado = service.anularMasivo(request);
        return ApiResponse.ok(resultado, "Anulación masiva procesada");
    }

    @GetMapping(value = "/export", produces = {
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "text/csv",
            "application/pdf"
    })
    @Operation(summary = "Exportar listado de Órdenes de Giro",
               description = "Exporta el listado filtrado a xlsx, pdf o csv")
    public ResponseEntity<byte[]> exportarListado(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long beneficiarioId,
            @RequestParam(required = false) Long centrosCostoId,
            @RequestParam(defaultValue = "xlsx") String formato) {
        byte[] bytes = exportService.exportarListado(fechaDesde, fechaHasta, estado, beneficiarioId, centrosCostoId, formato);
        return archivo(bytes, formato, "ordenes-giro");
    }

    @GetMapping(value = "/{id}/export", produces = {
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "text/csv",
            "application/pdf"
    })
    @Operation(summary = "Exportar/descargar una Orden de Giro",
               description = "Descarga una Orden de Giro a xlsx, pdf o csv")
    public ResponseEntity<byte[]> exportarOrden(
            @PathVariable Long id,
            @RequestParam(defaultValue = "pdf") String formato) {
        byte[] bytes = exportService.exportarOrden(id, formato);
        return archivo(bytes, formato, "orden-giro-" + id);
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
        return ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY)
                .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }
}
