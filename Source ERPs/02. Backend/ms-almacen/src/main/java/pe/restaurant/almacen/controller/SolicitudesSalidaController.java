package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.dto.SolSalidaRequest;
import pe.restaurant.almacen.dto.SolSalidaResponse;
import pe.restaurant.almacen.service.SolicitudSalidaService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/solicitudes-salida")
@RequiredArgsConstructor
public class SolicitudesSalidaController {

    private final SolicitudSalidaService service;

    @GetMapping
    public ApiResponse<PageData<SolSalidaResponse>> buscar(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) String estado,
            Pageable pageable) {
        var page = service.buscar(almacenId, estado, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<SolSalidaResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<SolSalidaResponse> crear(@Valid @RequestBody SolSalidaRequest request) {
        return ApiResponse.ok(service.crear(request), "Solicitud creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<SolSalidaResponse> actualizar(
            @PathVariable Long id, @Valid @RequestBody SolSalidaRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Solicitud actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/estado")
    public ApiResponse<SolSalidaResponse> cambiarEstado(@PathVariable Long id, @RequestParam String estado) {
        return ApiResponse.ok(service.cambiarEstado(id, estado), "Estado actualizado");
    }
}
