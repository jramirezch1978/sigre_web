package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.finanzas.dto.request.CodigoFlujoCajaRequest;
import com.sigre.finanzas.dto.response.CodigoFlujoCajaResponse;
import com.sigre.finanzas.entity.CodigoFlujoCaja;
import com.sigre.finanzas.mapper.CodigoFlujoCajaMapper;
import com.sigre.finanzas.service.CodigoFlujoCajaService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.response.PageData;

@RestController
@RequestMapping("/api/finanzas/codigos-flujo-caja")
@RequiredArgsConstructor
@Tag(name = "Códigos Flujo Caja", description = "Gestión del catálogo de códigos de flujo de caja")
public class CodigoFlujoCajaController {

    private final CodigoFlujoCajaService service;
    private final CodigoFlujoCajaMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CodigoFlujoCajaResponse>> findAll(Pageable pageable) {
        Page<CodigoFlujoCaja> page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CodigoFlujoCajaResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CodigoFlujoCajaResponse> create(@Valid @RequestBody CodigoFlujoCajaRequest request) {
        CodigoFlujoCaja entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CodigoFlujoCajaResponse> update(@PathVariable Long id,
                                                       @Valid @RequestBody CodigoFlujoCajaRequest request) {
        CodigoFlujoCaja existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CodigoFlujoCajaResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CodigoFlujoCajaResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
