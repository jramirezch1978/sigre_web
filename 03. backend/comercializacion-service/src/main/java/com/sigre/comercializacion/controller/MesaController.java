package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.comercializacion.dto.request.MesaRequest;
import com.sigre.comercializacion.dto.response.MesaResponse;
import com.sigre.comercializacion.entity.Mesa;
import com.sigre.comercializacion.mapper.MesaMapper;
import com.sigre.comercializacion.service.MesaService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.response.PageData;

import java.util.List;

@RestController
@RequestMapping("/api/ventas/mesas")
@RequiredArgsConstructor
@Tag(name = "Mesas", description = "Gestión de mesas del sigree")
public class MesaController {

    private final MesaService service;
    private final MesaMapper mapper;

    @GetMapping
    @Operation(summary = "Listar mesas", description = "Obtiene un listado paginado de mesas con filtros opcionales")
    public ApiResponse<PageData<MesaResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long zonaId,
            @RequestParam(required = false) String numero,
            @RequestParam(required = false) String flagEstado) {
        Page<Mesa> page = service.findAllWithFilters(zonaId, numero, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener mesa por ID")
    public ApiResponse<MesaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/zona/{zonaId}")
    @Operation(summary = "Listar mesas por zona", description = "Obtiene mesas activas de una zona")
    public ApiResponse<List<MesaResponse>> findByZonaId(@PathVariable Long zonaId) {
        List<Mesa> mesas = service.findByZonaId(zonaId);
        return ApiResponse.ok(mapper.toResponseList(mesas));
    }

    @GetMapping("/sucursal/{sucursalId}")
    @Operation(summary = "Listar mesas por sucursal", description = "Obtiene mesas activas de una sucursal")
    public ApiResponse<List<MesaResponse>> findBySucursalId(@PathVariable Long sucursalId) {
        List<Mesa> mesas = service.findBySucursalId(sucursalId);
        return ApiResponse.ok(mapper.toResponseList(mesas));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear mesa", description = "Crea una nueva mesa")
    public ApiResponse<MesaResponse> create(@Valid @RequestBody MesaRequest request) {
        Mesa entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Mesa creada exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar mesa")
    public ApiResponse<MesaResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody MesaRequest request) {
        Mesa existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Mesa actualizada exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar mesa")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Mesa eliminada exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar mesa")
    public ApiResponse<MesaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Mesa activada exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar mesa")
    public ApiResponse<MesaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Mesa desactivada exitosamente");
    }
}
