package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.LiquidacionAdelantoRequest;
import pe.restaurant.finanzas.dto.response.LiquidacionAdelantoResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionAdelantoResumenResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.service.LiquidacionAdelantoService;

import java.time.LocalDate;

/**
 * Endpoints NUEVOS para la Liquidación de Adelantos por Tipo de Adelanto (Proveedor /
 * Colaborador), HU-FIN-ADL-003. Se montan bajo {@code /api/finanzas/liquidaciones/adelantos}
 * para no alterar los contratos vigentes de {@link LiquidacionController}; el alta clásica
 * {@code POST /api/finanzas/liquidaciones} sigue intacta.
 *
 * <p>No requieren cambios en la base de datos: reutilizan las columnas existentes
 * ({@code tipo_liquidacion}, {@code proveedor_id}, {@code flag_estado}, {@code saldo}) y el
 * vínculo con {@code solicitud_giro}.
 */
@RestController
@RequestMapping("/api/finanzas/liquidaciones/adelantos")
@RequiredArgsConstructor
@Tag(name = "Liquidaciones de Adelanto",
     description = "HU-FIN-ADL-003 - Liquidación de adelantos por tipo (Proveedor / Colaborador)")
public class LiquidacionAdelantoController {

    private final LiquidacionAdelantoService service;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear liquidación de adelanto (Proveedor / Colaborador)",
               description = "HU-FIN-ADL-003 - Registra una liquidación distinguiendo el tipo de adelanto. "
                       + "Calcula el Total Gastado y el Saldo a Devolver/Regularizar, y permite guardar como Borrador.")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Liquidación creada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Solicitud de giro no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Error de regla de negocio")
    })
    public ApiResponse<LiquidacionAdelantoResponse> crear(@Valid @RequestBody LiquidacionAdelantoRequest request) {
        LiquidacionAdelantoResponse resultado = service.crearAdelanto(request);
        return ApiResponse.ok(resultado, "Liquidación de adelanto registrada");
    }

    @GetMapping
    @Operation(summary = "Listar liquidaciones de adelanto",
               description = "HU-FIN-ADL-003 - Listado paginado con filtro por Tipo de Adelanto (P/C) y otros filtros del servidor")
    public ApiResponse<PageData<LiquidacionAdelantoResumenResponse>> listar(
            @RequestParam(required = false) String tipoAdelanto,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) Long solicitudGiroId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaRegistroDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaRegistroHasta,
            Pageable pageable) {
        Page<LiquidacionAdelantoResumenResponse> page = service.listarAdelantos(
                tipoAdelanto, estado, solicitudGiroId, proveedorId, monedaId, sucursalId,
                fechaRegistroDesde, fechaRegistroHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Detalle de liquidación de adelanto",
               description = "HU-FIN-ADL-003 - Detalle con Tipo de Adelanto, beneficiario, monto del adelanto, "
                       + "Total Gastado y Saldo a Devolver/Regularizar calculados")
    public ApiResponse<LiquidacionAdelantoResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerAdelanto(id));
    }

    @PostMapping("/{id}/enviar")
    @Operation(summary = "Enviar liquidación de adelanto para revisión",
               description = "HU-FIN-ADL-003 - Pasa una liquidación de Borrador a Pendiente (Enviada para Revisión)")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Liquidación enviada para revisión"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Liquidación no encontrada"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "La liquidación no está en Borrador")
    })
    public ApiResponse<LiquidacionAdelantoResponse> enviar(@PathVariable Long id) {
        return ApiResponse.ok(service.enviarARevision(id), "Liquidación enviada para revisión");
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
