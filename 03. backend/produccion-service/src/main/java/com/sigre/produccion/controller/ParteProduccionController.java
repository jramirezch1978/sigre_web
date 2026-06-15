package com.sigre.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.dto.request.ParteProduccionRequest;
import com.sigre.produccion.dto.response.ParteInsumoResponse;
import com.sigre.produccion.dto.response.ParteProducidoResponse;
import com.sigre.produccion.dto.response.ParteProduccionResponse;
import com.sigre.produccion.dto.response.PageData;
import com.sigre.produccion.mapper.ParteInsumoMapper;
import com.sigre.produccion.mapper.ParteProducidoMapper;
import com.sigre.produccion.mapper.ParteProduccionMapper;
import com.sigre.produccion.service.ParteProduccionService;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/produccion/partes-produccion")
@RequiredArgsConstructor
public class ParteProduccionController {

    private final ParteProduccionService service;
    private final ParteProduccionMapper mapper;
    private final ParteInsumoMapper insumoMapper;
    private final ParteProducidoMapper producidoMapper;

    @GetMapping
    public ApiResponse<PageData<ParteProduccionResponse>> findAll(
            @RequestParam(required = false) Long ordenTrabajoId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(ordenTrabajoId, fechaDesde, fechaHasta, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ParteProduccionResponse> findById(@PathVariable Long id) {
        var entity = service.findById(id);
        var response = mapper.toResponse(entity);
        response.setInsumos(insumoMapper.toResponseList(service.findInsumos(id)));
        response.setProducidos(producidoMapper.toResponseList(service.findProducidos(id)));
        return ApiResponse.ok(response);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ParteProduccionResponse> create(@Valid @RequestBody ParteProduccionRequest request) {
        var entity = mapper.toEntity(request);
        var insumos = request.getInsumos() != null
                ? request.getInsumos().stream().map(insumoMapper::toEntity).toList() : null;
        var producidos = request.getProducidos() != null
                ? request.getProducidos().stream().map(producidoMapper::toEntity).toList() : null;
        var saved = service.create(entity, insumos, producidos);
        var response = mapper.toResponse(saved);
        response.setInsumos(insumoMapper.toResponseList(service.findInsumos(saved.getId())));
        response.setProducidos(producidoMapper.toResponseList(service.findProducidos(saved.getId())));
        return ApiResponse.ok(response, "Parte de producción creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ParteProduccionResponse> update(@PathVariable Long id,
                                                       @Valid @RequestBody ParteProduccionRequest request) {
        var entity = mapper.toEntity(request);
        var insumos = request.getInsumos() != null
                ? request.getInsumos().stream().map(insumoMapper::toEntity).toList() : null;
        var producidos = request.getProducidos() != null
                ? request.getProducidos().stream().map(producidoMapper::toEntity).toList() : null;
        var updated = service.update(id, entity, insumos, producidos);
        var response = mapper.toResponse(updated);
        response.setInsumos(insumoMapper.toResponseList(service.findInsumos(updated.getId())));
        response.setProducidos(producidoMapper.toResponseList(service.findProducidos(updated.getId())));
        return ApiResponse.ok(response, "Parte de producción actualizado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ParteProduccionResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Parte activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ParteProduccionResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Parte desactivado");
    }

    @GetMapping("/{id}/insumos")
    public ApiResponse<List<ParteInsumoResponse>> findInsumos(@PathVariable Long id) {
        return ApiResponse.ok(insumoMapper.toResponseList(service.findInsumos(id)));
    }

    @GetMapping("/{id}/producidos")
    public ApiResponse<List<ParteProducidoResponse>> findProducidos(@PathVariable Long id) {
        return ApiResponse.ok(producidoMapper.toResponseList(service.findProducidos(id)));
    }
}
