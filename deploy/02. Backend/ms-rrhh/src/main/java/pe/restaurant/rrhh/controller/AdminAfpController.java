package pe.restaurant.rrhh.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.rrhh.dto.request.AdminAfpRequest;
import pe.restaurant.rrhh.dto.response.AdminAfpResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.constants.AdminAfpConstants;
import pe.restaurant.rrhh.service.AdminAfpService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/admin-afp")
@RequiredArgsConstructor
@Tag(name = "Administradoras de AFP", description = "Gestión del catálogo de AFP")
public class AdminAfpController {

    private final AdminAfpService adminAfpService;

    @GetMapping
    @Operation(summary = "Listar AFP")
    public ApiResponse<PageData<AdminAfpResponse>> listar(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        Page<AdminAfpResponse> page = adminAfpService.listar(nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener AFP por ID")
    public ApiResponse<AdminAfpResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(adminAfpService.obtenerPorId(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear AFP")
    public ApiResponse<AdminAfpResponse> crear(@Valid @RequestBody AdminAfpRequest request) {
        return ApiResponse.ok(adminAfpService.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar AFP")
    public ApiResponse<AdminAfpResponse> actualizar(@PathVariable Long id, @Valid @RequestBody AdminAfpRequest request) {
        return ApiResponse.ok(adminAfpService.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar AFP (baja lógica)")
    public ApiResponse<AdminAfpResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(adminAfpService.desactivar(id), AdminAfpConstants.MSG_AFP_DESACTIVADA);
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar AFP")
    public ApiResponse<AdminAfpResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(adminAfpService.activar(id), AdminAfpConstants.MSG_AFP_ACTIVADA);
    }

    @GetMapping("/activos")
    @Operation(summary = "Listar AFP activas")
    public ApiResponse<List<AdminAfpResponse>> listarActivos() {
        return ApiResponse.ok(adminAfpService.listarActivos());
    }
}
