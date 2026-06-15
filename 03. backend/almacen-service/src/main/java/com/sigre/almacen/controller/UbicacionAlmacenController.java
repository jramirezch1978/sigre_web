package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.UbicacionAlmacenRequest;
import com.sigre.almacen.dto.UbicacionAlmacenResponse;
import com.sigre.almacen.mapper.UbicacionAlmacenMapper;
import com.sigre.almacen.service.UbicacionAlmacenService;
import com.sigre.common.dto.ApiResponse;

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
