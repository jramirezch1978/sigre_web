package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.comercializacion.dto.request.VendedorRequest;
import com.sigre.comercializacion.dto.response.VendedorResponse;
import com.sigre.comercializacion.entity.Vendedor;
import com.sigre.comercializacion.mapper.VendedorMapper;
import com.sigre.comercializacion.service.VendedorService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.response.PageData;

@RestController
@RequestMapping("/api/ventas/vendedores")
@RequiredArgsConstructor
@Tag(name = "Vendedores", description = "Gestión de vendedores/meseros")
public class VendedorController {

    private final VendedorService service;
    private final VendedorMapper mapper;

    @GetMapping
    @Operation(summary = "Listar vendedores", description = "Obtiene un listado paginado de vendedores con filtros opcionales")
    public ApiResponse<PageData<VendedorResponse>> findAll(
            Pageable pageable,
            @RequestParam(required = false) Long usuarioId,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado) {
        Page<Vendedor> page = service.findAllWithFilters(usuarioId, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener vendedor por ID")
    public ApiResponse<VendedorResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @GetMapping("/usuario/{usuarioId}")
    @Operation(summary = "Obtener vendedor por ID de usuario", description = "Obtiene el vendedor asociado a un usuario")
    public ApiResponse<VendedorResponse> findByUsuarioId(@PathVariable Long usuarioId) {
        Vendedor vendedor = service.findByUsuarioId(usuarioId);
        return ApiResponse.ok(mapper.toResponse(vendedor));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear vendedor", description = "Crea un nuevo vendedor")
    public ApiResponse<VendedorResponse> create(@Valid @RequestBody VendedorRequest request) {
        Vendedor entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Vendedor creado exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar vendedor")
    public ApiResponse<VendedorResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody VendedorRequest request) {
        Vendedor existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Vendedor actualizado exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar vendedor")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Vendedor eliminado exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar vendedor")
    public ApiResponse<VendedorResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Vendedor activado exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar vendedor")
    public ApiResponse<VendedorResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Vendedor desactivado exitosamente");
    }
}
