package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import pe.restaurant.rrhh.dto.response.PageData;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.constants.PermisoLicenciaConstants;
import pe.restaurant.rrhh.dto.request.PermisoLicenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.PermisoLicenciaResponse;
import pe.restaurant.rrhh.service.PermisoLicenciaService;
import java.time.LocalDate;
import java.util.List;

@Tag(name = "Permisos y Licencias", description = "Gestión de permisos y licencias de trabajadores")
@RestController
@RequestMapping("/api/rrhh/permisos-licencias")
@RequiredArgsConstructor
public class PermisoLicenciaController {

    private final PermisoLicenciaService service;

    @Operation(summary = "Listar permisos y licencias")
    @GetMapping
    public ApiResponse<PageData<PermisoLicenciaResponse>> listar(
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(sort = "fechaInicio", direction = Sort.Direction.DESC) Pageable pageable) {
        Page<PermisoLicenciaResponse> result = service.listar(trabajadorId, fechaDesde, fechaHasta, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(result, result.getContent()));
    }

    @Operation(summary = "Obtener permiso o licencia por ID")
    @GetMapping("/{id}")
    public ApiResponse<PermisoLicenciaResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtenerPorId(id));
    }

    @Operation(summary = "Registrar permiso o licencia")
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PermisoLicenciaResponse> crear(
            @Valid @RequestBody PermisoLicenciaCreateRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @Operation(summary = "Actualizar permiso o licencia")
    @PutMapping("/{id}")
    public ApiResponse<PermisoLicenciaResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody PermisoLicenciaUpdateRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @Operation(summary = "Aprobar permiso")
    @PostMapping("/{id}/aprobar")
    public ApiResponse<PermisoLicenciaResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(service.aprobar(id));
    }

    @Operation(summary = "Rechazar permiso")
    @PostMapping("/{id}/rechazar")
    public ApiResponse<PermisoLicenciaResponse> rechazar(@PathVariable Long id) {
        return ApiResponse.ok(service.rechazar(id));
    }

    @Operation(summary = "Desactivar permiso o licencia (baja lógica)")
    @PatchMapping("/{id}/desactivar")
    public ApiResponse<PermisoLicenciaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), PermisoLicenciaConstants.MSG_DESACTIVADO);
    }

    @Operation(summary = "Listar bandeja de permisos pendientes")
    @GetMapping("/bandeja-aprobacion")
    public ApiResponse<List<PermisoLicenciaResponse>> listarBandeja() {
        return ApiResponse.ok(service.listarBandeja());
    }

    @Operation(summary = "Observar permiso")
    @PostMapping("/{id}/observar")
    public ApiResponse<PermisoLicenciaResponse> observar(@PathVariable Long id) {
        return ApiResponse.ok(service.observar(id));
    }

    @Operation(summary = "Anular permiso")
    @PostMapping("/{id}/anular")
    public ApiResponse<PermisoLicenciaResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id));
    }

    @Operation(summary = "Cerrar permiso")
    @PostMapping("/{id}/cerrar")
    public ApiResponse<PermisoLicenciaResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(service.cerrar(id));
    }

    @Operation(summary = "Procesar permiso para planilla")
    @PostMapping("/{id}/procesar")
    public ApiResponse<PermisoLicenciaResponse> procesar(@PathVariable Long id) {
        return ApiResponse.ok(service.procesar(id));
    }

    @Operation(summary = "Procesar permisos batch para planilla")
    @PostMapping("/procesar")
    public ApiResponse<Void> procesarBatch() {
        service.procesarBatch();
        return ApiResponse.ok(null, "Permisos procesados para planilla correctamente");
    }

    @Operation(summary = "Enviar permiso a planilla")
    @PostMapping("/{id}/enviar-planilla")
    public ApiResponse<PermisoLicenciaResponse> enviarPlanilla(@PathVariable Long id) {
        return ApiResponse.ok(service.enviarPlanilla(id));
    }

    @Operation(summary = "Reflejar permiso en boleta de pago")
    @PostMapping("/{id}/boleta")
    public ApiResponse<PermisoLicenciaResponse> reflejarBoleta(@PathVariable Long id) {
        return ApiResponse.ok(service.reflejarBoleta(id));
    }
}
