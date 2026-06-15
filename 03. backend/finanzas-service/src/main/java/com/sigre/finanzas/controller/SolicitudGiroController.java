package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.request.AprobarSolicitudRequest;
import com.sigre.finanzas.dto.request.DevolucionTotalRequest;
import com.sigre.finanzas.dto.request.RechazoDevolucionTotalRequest;
import com.sigre.finanzas.dto.request.RechazarSolicitudRequest;
import com.sigre.finanzas.dto.request.SolicitudGiroRequest;
import com.sigre.finanzas.dto.response.*;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.SolicitudGiroService;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/finanzas/solicitudes-giro")
@RequiredArgsConstructor
@Tag(name = "Solicitudes de Giro", description = "FI307 - Gestión de solicitudes de adelantos")
public class SolicitudGiroController {

    private final SolicitudGiroService service;

    @GetMapping
    @Operation(summary = "Listar solicitudes de giro",
               description = "Obtiene un listado paginado de solicitudes con filtros opcionales")
    public ApiResponse<PageData<SolicitudGiroResponse>> listar(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String estado,
            Pageable pageable) {
        Page<SolicitudGiroResponse> page = service.listarSolicitudes(
            fechaDesde, fechaHasta, estado, pageable
        );
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle de solicitud de giro",
               description = "Obtiene el detalle completo de una solicitud incluyendo sus detalles")
    public ApiResponse<SolicitudGiroDetalleResponse> obtenerPorId(@PathVariable Long id) {
        SolicitudGiroDetalleResponse detalle = service.obtenerPorId(id);
        return ApiResponse.ok(detalle);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear solicitud de giro",
               description = "Registra una nueva solicitud de adelanto (flagEstado=3, pendiente aprobación)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Solicitud creada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Número duplicado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> crear(@Valid @RequestBody SolicitudGiroRequest request) {
        SolicitudGiroDetalleResponse resultado = service.crearSolicitud(request);
        return ApiResponse.ok(resultado, "Solicitud registrada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar solicitud de giro",
               description = "Actualiza una solicitud pendiente de aprobación (flagEstado=3)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Solicitud actualizada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite edición")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody SolicitudGiroRequest request) {
        SolicitudGiroDetalleResponse resultado = service.actualizarSolicitud(id, request);
        return ApiResponse.ok(resultado, "Solicitud actualizada");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular solicitud de giro",
               description = "Anula una solicitud que no ha sido aprobada")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Solicitud anulada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Solicitud no anulable")
    })
    public ApiResponse<Map<String, Object>> anular(@PathVariable Long id) {
        Map<String, Object> resultado = service.anularSolicitud(id);
        return ApiResponse.ok(resultado, "Solicitud anulada");
    }

    @GetMapping("/pendientes-aprobacion")
    @Operation(summary = "Listar solicitudes pendientes de aprobación",
               description = "FI308 - Obtiene solicitudes pendientes de aprobación (flagEstado=3)")
    public ApiResponse<PageData<SolicitudPendienteAprobacionResponse>> listarPendientesAprobacion(Pageable pageable) {
        Page<SolicitudPendienteAprobacionResponse> page = service.listarPendientesAprobacion(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @PostMapping("/{id}/aprobar")
    @Operation(summary = "Aprobar solicitud de giro",
               description = "FI308 - Aprueba una solicitud y opcionalmente crea orden de giro")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Solicitud aprobada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite aprobación")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> aprobar(
            @PathVariable Long id,
            @Valid @RequestBody AprobarSolicitudRequest request) {
        SolicitudGiroDetalleResponse resultado = service.aprobarSolicitud(id, request);
        return ApiResponse.ok(resultado, "Solicitud aprobada");
    }

    @PostMapping("/{id}/rechazar")
    @Operation(summary = "Rechazar solicitud de giro",
               description = "FI308 - Rechaza una solicitud con observación")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Solicitud rechazada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite rechazo")
    })
    public ApiResponse<Map<String, Object>> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody RechazarSolicitudRequest request) {
        Map<String, Object> resultado = service.rechazarSolicitud(id, request);
        return ApiResponse.ok(resultado, "Solicitud rechazada");
    }

    // ========== FI333 - DEVOLUCIÓN TOTAL (Escenario 1) ==========

    @PostMapping("/{id}/devolucion-total")
    @Operation(summary = "Registrar devolución total",
               description = "FI333 - Registra devolución total del dinero entregado (sin liquidación)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Devolución total registrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Estado no permite devolución total")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> registrarDevolucionTotal(
            @PathVariable Long id,
            @Valid @RequestBody DevolucionTotalRequest request) {
        SolicitudGiroDetalleResponse resultado = service.registrarDevolucionTotal(id, request);
        return ApiResponse.ok(resultado, "Devolución total registrada, pendiente de aprobación");
    }

    @PostMapping("/{id}/aprobar-devolucion-total")
    @Operation(summary = "Aprobar devolución total",
               description = "FI333 - Aprueba una devolución total")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Devolución total aprobada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "No se puede aprobar devolución")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> aprobarDevolucionTotal(@PathVariable Long id) {
        SolicitudGiroDetalleResponse resultado = service.aprobarDevolucionTotal(id);
        return ApiResponse.ok(resultado, "Devolución total aprobada");
    }

    @PostMapping("/{id}/rechazar-devolucion-total")
    @Operation(summary = "Rechazar devolución total",
               description = "FI333 - Rechaza una devolución total")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Devolución total rechazada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "No se puede rechazar devolución")
    })
    public ApiResponse<SolicitudGiroDetalleResponse> rechazarDevolucionTotal(
            @PathVariable Long id,
            @Valid @RequestBody RechazoDevolucionTotalRequest request) {
        SolicitudGiroDetalleResponse resultado = service.rechazarDevolucionTotal(id, request);
        return ApiResponse.ok(resultado, "Devolución total rechazada");
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

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        String message = ex.getMessage();
        
        if (message != null) {
            if (message.contains("numero") || message.contains("unique")) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(ApiResponse.error(
                        "Número de solicitud duplicado",
                        FinanzasErrorCodes.SOLICITUD_NUMERO_DUPLICADO
                    ));
            } else if (message.contains("created_by") || message.contains("not-null constraint")) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(ApiResponse.error(
                        "Error de auditoría: usuario no autenticado",
                        "AUDIT_USER_REQUIRED"
                    ));
            }
        }
        
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse.error(
                "Error de integridad de datos: " + ex.getMostSpecificCause().getMessage(),
                "DATA_INTEGRITY_VIOLATION"
            ));
    }
}
