package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.UbicacionAlmacenRequest;
import pe.restaurant.almacen.dto.UbicacionAlmacenResponse;
import pe.restaurant.almacen.mapper.UbicacionAlmacenMapper;
import pe.restaurant.almacen.service.UbicacionAlmacenService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/ubicaciones")
@RequiredArgsConstructor
public class UbicacionAlmacenController {

    private final UbicacionAlmacenService service;
    private final UbicacionAlmacenMapper mapper;

    @PutMapping("/{id}")
    public ApiResponse<UbicacionAlmacenResponse> update(@PathVariable Long id,
                                                        @Valid @RequestBody UbicacionAlmacenRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
