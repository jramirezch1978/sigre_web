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
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.dto.response.CargoResponse;
import pe.restaurant.rrhh.dto.response.PageData;
import pe.restaurant.rrhh.constants.CargoConstants;
import pe.restaurant.rrhh.service.CargoService;

import java.util.List;

@RestController
@RequestMapping("/api/rrhh/cargos")
@RequiredArgsConstructor
@Tag(name = "Cargos", description = "Gestión de cargos organizacionales y bandas salariales")
public class CargoController {

    private final CargoService service;

    @GetMapping
    @Operation(summary = "Listar cargos")
    public ApiResponse<PageData<CargoResponse>> listar(Pageable pageable,
                                                       @RequestParam(required = false) String nombre,
                                                       @RequestParam(required = false) String nivel) {
        Page<CargoResponse> page = service.listar(pageable, nombre, nivel);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener cargo por ID")
    public ApiResponse<CargoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear cargo")
    public ApiResponse<CargoResponse> crear(@Valid @RequestBody CargoRequest request) {
        return ApiResponse.ok(service.crear(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar cargo")
    public ApiResponse<CargoResponse> actualizar(@PathVariable Long id, @Valid @RequestBody CargoRequest request) {
        return ApiResponse.ok(service.actualizar(id, request));
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar cargo (baja lógica)")
    public ApiResponse<CargoResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(service.desactivar(id), CargoConstants.MSG_CARGO_DESACTIVADO);
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar cargo")
    public ApiResponse<CargoResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(service.activar(id), CargoConstants.MSG_CARGO_ACTIVADO);
    }

    @GetMapping("/activos")
    @Operation(summary = "Listar cargos activos")
    public ApiResponse<List<CargoResponse>> listarActivos() {
        return ApiResponse.ok(service.listarActivos());
    }
}
