package pe.restaurant.finanzas.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.request.CntasPagarRequest;
import pe.restaurant.finanzas.dto.response.CntasPagarResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.dto.response.PendientesPagarResponse;
import pe.restaurant.finanzas.dto.response.PendientesPagarSimpleResponse;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.mapper.CntasPagarMapper;
import pe.restaurant.finanzas.service.CntasPagarService;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;

import java.time.LocalDate;

@Slf4j
@RestController
@RequestMapping("/api/finanzas/cuentas-pagar")
@RequiredArgsConstructor
@Tag(name = "Cuentas por Pagar", description = "FI304 - Registro de obligaciones con proveedores")
public class CntasPagarController {

    private final CntasPagarService service;
    private final CntasPagarMapper mapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping
    @Operation(summary = "Listar cuentas por pagar", 
               description = "Obtiene un listado paginado de cuentas por pagar con filtros opcionales")
    public ApiResponse<PageData<CntasPagarResponse>> listar(
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) Long docTipoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaVencimientoDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaVencimientoHasta,
            Pageable pageable) {
        Page<CntasPagar> page = service.listar(proveedorId, docTipoId, estado, fechaDesde, fechaHasta, fechaVencimientoDesde, fechaVencimientoHasta, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener cuenta por pagar por ID", 
               description = "Obtiene el detalle completo de una cuenta por pagar incluyendo detalles y asiento contable")
    public ApiResponse<CntasPagarResponse> obtenerPorId(@PathVariable Long id) {
        CntasPagar cxp = service.obtenerPorId(id);
        return ApiResponse.ok(mapper.toResponse(cxp));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Registrar cuenta por pagar", 
               description = "Registra una nueva cuenta por pagar con generación automática de asiento contable")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Cuenta por pagar creada exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "409", description = "Documento duplicado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Asiento no balanceado")
    })
    public ApiResponse<CntasPagarResponse> crear(@Valid @RequestBody CntasPagarRequest request) {
        CntasPagar cxp = service.crear(request);
        return ApiResponse.ok(mapper.toResponse(cxp), "Cuenta por pagar creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar cuenta por pagar", 
               description = "Actualiza una cuenta por pagar activa (flagEstado=1)")
    public ApiResponse<CntasPagarResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody CntasPagarRequest request) {
        CntasPagar cxp = service.actualizar(id, request);
        return ApiResponse.ok(mapper.toResponse(cxp), "Cuenta por pagar actualizada exitosamente");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular cuenta por pagar", 
               description = "Anula una cuenta por pagar y su asiento contable asociado")
    public ApiResponse<CntasPagarResponse> anular(@PathVariable Long id) {
        CntasPagar cxp = service.anular(id);
        return ApiResponse.ok(mapper.toResponse(cxp), "Cuenta por pagar anulada exitosamente");
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataIntegrityViolation(DataIntegrityViolationException ex) {
        String originalMessage = ex.getMessage();
        String improvedMessage = extractForeignKeyError(originalMessage);
        
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.error(
                improvedMessage, 
                FinanzasErrorCodes.ERROR_INTERNO
            ));
    }
    
    private String extractForeignKeyError(String fullMessage) {
        if (fullMessage == null) return "Error de integridad de datos";
        
        // Buscar el patrón de foreign key constraint
        String fkPattern = "violates foreign key constraint \"([^\"]+)\"";
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile(fkPattern);
        java.util.regex.Matcher matcher = pattern.matcher(fullMessage);
        
        if (matcher.find()) {
            String constraintName = matcher.group(1);
            
            // Buscar el patrón de Detail
            String detailPattern = "Detail: Key \\(([^=]+)\\)=\\(([^)]+)\\) is not present in table \"([^\"]+)\"";
            java.util.regex.Pattern detailPatternObj = java.util.regex.Pattern.compile(detailPattern);
            java.util.regex.Matcher detailMatcher = detailPatternObj.matcher(fullMessage);
            
            if (detailMatcher.find()) {
                String fieldName = detailMatcher.group(1);
                String fieldValue = detailMatcher.group(2);
                String tableName = detailMatcher.group(3);
                
                return String.format("Tabla \"%s\" viola la restricción de clave externa \"%s\": %s=%s no existe en tabla \"%s\"", 
                    "cntas_pagar_det", constraintName, fieldName, fieldValue, tableName);
            }
        }
        
        // Si no coincide con el patrón, retornar mensaje simplificado
        if (fullMessage.contains("violates foreign key constraint")) {
            return "Error de referencia: El registro especificado no existe en la tabla relacionada";
        }
        
        return fullMessage;
    }

    /**
     * Maneja excepciones de comunicación con ms-contabilidad.
     * Extrae el código de error y mensaje específico del response body.
     * 
     * @param ex Excepción de Feign al comunicarse con ms-contabilidad
     * @return Response con el error específico de ms-contabilidad
     */
    @ExceptionHandler(feign.FeignException.class)
    public ResponseEntity<ApiResponse<Void>> handleFeignException(feign.FeignException ex) {
        log.error("Error en comunicación con ms-contabilidad: status={}, message={}", ex.status(), ex.getMessage());
        
        String errorMessage = "Error de comunicación con ms-contabilidad";
        String errorCode = FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD;
        HttpStatus httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
        
        try {
            String responseBody = ex.contentUTF8();
            log.error("Response body de ms-contabilidad: {}", responseBody);
            
            if (responseBody != null && !responseBody.isEmpty()) {
                JsonNode jsonNode = objectMapper.readTree(responseBody);
                
                // Extraer mensaje y código de error del response
                if (jsonNode.has("message")) {
                    errorMessage = jsonNode.get("message").asText();
                }
                if (jsonNode.has("errorCode")) {
                    errorCode = jsonNode.get("errorCode").asText();
                }
                
                log.warn("Error de ms-contabilidad capturado: code={}, message={}", errorCode, errorMessage);
            }
        } catch (Exception parseEx) {
            log.error("Error al parsear response de ms-contabilidad", parseEx);
            errorMessage = "Error de validación: " + ex.getMessage();
        }
        
        // Determinar el status HTTP según el código de error
        if (ex.status() == 422) {
            httpStatus = HttpStatus.UNPROCESSABLE_ENTITY;
        } else if (ex.status() == 400) {
            httpStatus = HttpStatus.BAD_REQUEST;
        } else if (ex.status() == 404) {
            httpStatus = HttpStatus.NOT_FOUND;
        } else if (ex.status() == 503) {
            httpStatus = HttpStatus.SERVICE_UNAVAILABLE;
            errorMessage = "Servicio de contabilidad no disponible";
            errorCode = FinanzasErrorCodes.ERROR_COMUNICACION_CONTABILIDAD;
        }
        
        return ResponseEntity.status(httpStatus)
            .body(ApiResponse.error(errorMessage, errorCode));
    }

    /**
     * Lista todos los documentos pendientes por pagar agrupados por tipo.
     * Incluye: Cuentas por Pagar, Órdenes de Giro, Liquidaciones, Retenciones y Detracciones.
     * Retorna listas separadas por tipo de documento con totales calculados.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Respuesta agrupada con listas por tipo y totales
     */
    @GetMapping("/pendientes/agrupado")
    @Operation(summary = "Listar pendientes por pagar agrupados", 
               description = "Lista todos los documentos pendientes de pago agrupados por tipo con totales calculados")
    public ApiResponse<PendientesPagarResponse> listarPendientesPorPagarAgrupado(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        
        log.info("GET /api/finanzas/cuentas-pagar/pendientes/agrupado - sucursal: {}, proveedor: {}, fechas: {} - {}", 
                sucursalId, proveedorId, fechaDesde, fechaHasta);
        
        PendientesPagarResponse response = service.listarPendientesPorPagarAgrupado(
                sucursalId, proveedorId, fechaDesde, fechaHasta);
        
        return ApiResponse.ok(response);
    }

    /**
     * Lista todos los documentos pendientes por pagar en formato simple unificado.
     * Combina todos los tipos de documentos en una lista plana con estructura común.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista simple unificada de pendientes
     */
    @GetMapping("/pendientes/simple")
    @Operation(summary = "Listar pendientes por pagar simple", 
               description = "Lista todos los documentos pendientes de pago en formato unificado")
    public ApiResponse<PendientesPagarSimpleResponse> listarPendientesPorPagarSimple(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) Long docTipoId,
            @RequestParam(required = false) String tipoDocumento,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        
        log.info("GET /api/finanzas/cuentas-pagar/pendientes/simple - sucursal: {}, proveedor: {}, docTipoId: {}, tipoDocumento: {}, fechas: {} - {}", 
                sucursalId, proveedorId, docTipoId, tipoDocumento, fechaDesde, fechaHasta);
        
        PendientesPagarSimpleResponse response = service.listarPendientesPorPagarSimple(
                sucursalId, proveedorId, docTipoId, tipoDocumento, fechaDesde, fechaHasta);
        
        return ApiResponse.ok(response);
    }
}
