package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.finanzas.dto.request.BancoRequest;
import com.sigre.finanzas.dto.response.BancoResponse;
import com.sigre.finanzas.entity.Banco;
import com.sigre.finanzas.mapper.BancoMapper;
import com.sigre.finanzas.service.BancoService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.response.PageData;

@RestController
@RequestMapping("/api/finanzas/bancos")
@RequiredArgsConstructor
@Tag(name = "Bancos", description = "Gestión del catálogo de bancos")
public class BancoController {

    private final BancoService service;
    private final BancoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar bancos", description = "Obtiene un listado paginado de bancos")
    public ApiResponse<PageData<BancoResponse>> findAll(Pageable pageable) {
        Page<Banco> page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener banco por ID")
    public ApiResponse<BancoResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear banco", description = "Crea un nuevo banco en el catálogo")
    public ApiResponse<BancoResponse> create(@Valid @RequestBody BancoRequest request) {
        Banco entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Banco creado exitosamente");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar banco")
    public ApiResponse<BancoResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody BancoRequest request) {
        Banco existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Banco actualizado exitosamente");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar banco")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Banco eliminado exitosamente");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar banco")
    public ApiResponse<BancoResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Banco activado exitosamente");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar banco")
    public ApiResponse<BancoResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Banco desactivado exitosamente");
    }
}
