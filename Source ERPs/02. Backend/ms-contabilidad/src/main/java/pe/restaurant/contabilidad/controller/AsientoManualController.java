package pe.restaurant.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.request.AsientoManualRequest;
import pe.restaurant.contabilidad.dto.request.AsientoSearchRequest;
import pe.restaurant.contabilidad.dto.response.AsientoResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.entity.CntblAsiento;
import pe.restaurant.contabilidad.mapper.AsientoMapper;
import pe.restaurant.contabilidad.service.AsientoManualService;
import pe.restaurant.contabilidad.service.AsientoService;

@RestController
@RequestMapping("/api/contabilidad/asientos/manual")
@RequiredArgsConstructor
@Tag(name = "Asientos Manuales", description = "Gestión de asientos contables creados manualmente (naturaleza M, módulo C)")
public class AsientoManualController {

    private final AsientoManualService asientoManualService;
    private final AsientoService asientoService;
    private final AsientoMapper mapper;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear asiento contable manual",
               description = "Crea un asiento con naturaleza MANUAL (M) y módulo CONTABILIDAD (C). "
                           + "Valida balanceo, cuentas de detalle, flags contables (flagPermiteMov, nivCnta, "
                           + "flagCencos, flagDocRef, flagCodRelacion, flagCtabco, flagTipoSaldo) y período abierto.")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "201", description = "Asiento manual creado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Asiento no balanceado, cuenta inválida o período cerrado")
    })
    public ApiResponse<AsientoResponse> crear(@Valid @RequestBody AsientoManualRequest request) {
        CntblAsiento asiento = asientoManualService.crear(request);
        return ApiResponse.ok(mapper.toResponse(asiento), "Asiento manual creado exitosamente");
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener asiento manual por ID",
               description = "Obtiene un asiento contable con todos sus detalles")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Asiento encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Asiento no encontrado")
    })
    public ApiResponse<AsientoResponse> obtenerPorId(@PathVariable Long id) {
        CntblAsiento asiento = asientoService.obtenerPorId(id);
        return ApiResponse.ok(mapper.toResponse(asiento));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar asiento manual",
               description = "Actualiza un asiento activo (flagEstado = '1') con origen manual")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Asiento actualizado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Error de validación"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Asiento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Asiento no activo, no balanceado o cuenta inválida")
    })
    public ApiResponse<AsientoResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody AsientoManualRequest request) {
        CntblAsiento asiento = asientoManualService.actualizar(id, request);
        return ApiResponse.ok(mapper.toResponse(asiento), "Asiento manual actualizado exitosamente");
    }

    @PostMapping("/{id}/anular")
    @Operation(summary = "Anular asiento manual",
               description = "Anula un asiento activo. Valida existencia, período contable abierto y estado activo.")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Asiento anulado exitosamente"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "404", description = "Asiento no encontrado"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "422", description = "Asiento ya anulado o período contable cerrado")
    })
    public ApiResponse<AsientoResponse> anular(@PathVariable Long id) {
        CntblAsiento asiento = asientoService.anular(id);
        return ApiResponse.ok(mapper.toResponse(asiento), "Asiento manual anulado exitosamente");
    }

    @GetMapping("/buscar")
    @Operation(summary = "Buscar asientos contables",
               description = "Busca asientos contables con filtros opcionales (fecha, cuenta contable, naturaleza, estado) y paginación")
    @ApiResponses({
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "200", description = "Búsqueda exitosa"),
        @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "Parámetros de búsqueda inválidos")
    })
    public ApiResponse<PageData<AsientoResponse>> buscar(
            AsientoSearchRequest request,
            @PageableDefault(size = 20) Pageable pageable) {
        PageData<AsientoResponse> result = asientoService.buscar(request, pageable);
        return ApiResponse.ok(result);
    }
}
