package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.LotePalletRequest;
import com.sigre.almacen.dto.LotePalletResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.mapper.LotePalletMapper;
import com.sigre.almacen.service.LotePalletService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/lotes-pallets")
@RequiredArgsConstructor
public class LotePalletController {

    private final LotePalletService service;
    private final LotePalletMapper mapper;

    @GetMapping
    public ApiResponse<PageData<LotePalletResponse>> buscar(
            @RequestParam(required = false) Long articuloId,
            @PageableDefault(sort = "nroLote", direction = Sort.Direction.ASC) Pageable pageable) {
        var page = service.buscar(articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<LotePalletResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<LotePalletResponse> create(@Valid @RequestBody LotePalletRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<LotePalletResponse> update(@PathVariable Long id, @Valid @RequestBody LotePalletRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<LotePalletResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<LotePalletResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }
}
