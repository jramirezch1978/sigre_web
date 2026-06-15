package com.sigre.produccion.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.produccion.dto.request.LaborArticuloRequest;
import com.sigre.produccion.dto.request.LaborEjecutorRequest;
import com.sigre.produccion.dto.response.LaborEjecutorResponse;
import com.sigre.produccion.dto.response.LaborInsumoResponse;
import com.sigre.produccion.dto.response.LaborProduccionResponse;
import com.sigre.produccion.dto.request.LaborRequest;
import com.sigre.produccion.dto.response.LaborResponse;
import com.sigre.produccion.dto.response.PageData;
import com.sigre.produccion.mapper.LaborEjecutorMapper;
import com.sigre.produccion.mapper.LaborInsumoMapper;
import com.sigre.produccion.mapper.LaborMapper;
import com.sigre.produccion.mapper.LaborProduccionMapper;
import com.sigre.produccion.service.LaborService;

import java.util.List;

@RestController
@RequestMapping("/api/produccion/labores")
@RequiredArgsConstructor
public class LaborController {

    private final LaborService service;
    private final LaborMapper laborMapper;
    private final LaborInsumoMapper insumoMapper;
    private final LaborProduccionMapper produccionMapper;
    private final LaborEjecutorMapper ejecutorMapper;

    // ───────────────────────── Cabecera ─────────────────────────

    @GetMapping
    public ApiResponse<PageData<LaborResponse>> findAll(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String flagEstado,
            Pageable pageable) {
        var page = service.findAll(codigo, nombre, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, laborMapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<LaborResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(laborMapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<LaborResponse> create(@Valid @RequestBody LaborRequest request) {
        var entity = laborMapper.toEntity(request);
        return ApiResponse.ok(laborMapper.toResponse(service.create(entity)), "Labor creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<LaborResponse> update(@PathVariable Long id,
                                             @Valid @RequestBody LaborRequest request) {
        var existing = service.findById(id);
        laborMapper.updateEntity(request, existing);
        return ApiResponse.ok(laborMapper.toResponse(service.update(id, existing)), "Labor actualizada");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<LaborResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(laborMapper.toResponse(service.activate(id)), "Labor activada");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<LaborResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(laborMapper.toResponse(service.deactivate(id)), "Labor desactivada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Labor eliminada");
    }

    // ───────────────────────── Sub-recurso insumos ─────────────────────────

    @GetMapping("/{id}/insumos")
    public ApiResponse<List<LaborInsumoResponse>> findInsumos(@PathVariable Long id) {
        return ApiResponse.ok(insumoMapper.toResponseList(service.findInsumos(id)));
    }

    @PostMapping("/{id}/insumos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<LaborInsumoResponse> asignarInsumo(@PathVariable Long id,
                                                          @Valid @RequestBody LaborArticuloRequest request) {
        var saved = service.asignarInsumo(id, request.getArticuloId());
        return ApiResponse.ok(insumoMapper.toResponse(saved), "Insumo asignado a la labor");
    }

    @DeleteMapping("/{id}/insumos/{articuloId}")
    public ApiResponse<Boolean> desasignarInsumo(@PathVariable Long id, @PathVariable Long articuloId) {
        service.desasignarInsumo(id, articuloId);
        return ApiResponse.ok(true, "Insumo desasignado de la labor");
    }

    // ───────────────────────── Sub-recurso producidos ─────────────────────────

    @GetMapping("/{id}/producidos")
    public ApiResponse<List<LaborProduccionResponse>> findProducidos(@PathVariable Long id) {
        return ApiResponse.ok(produccionMapper.toResponseList(service.findProducidos(id)));
    }

    @PostMapping("/{id}/producidos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<LaborProduccionResponse> asignarProducido(@PathVariable Long id,
                                                                 @Valid @RequestBody LaborArticuloRequest request) {
        var saved = service.asignarProducido(id, request.getArticuloId());
        return ApiResponse.ok(produccionMapper.toResponse(saved), "Producido asignado a la labor");
    }

    @DeleteMapping("/{id}/producidos/{articuloId}")
    public ApiResponse<Boolean> desasignarProducido(@PathVariable Long id, @PathVariable Long articuloId) {
        service.desasignarProducido(id, articuloId);
        return ApiResponse.ok(true, "Producido desasignado de la labor");
    }

    // ───────────────────────── Sub-recurso ejecutores ─────────────────────────

    @GetMapping("/{id}/ejecutores")
    public ApiResponse<List<LaborEjecutorResponse>> findEjecutores(@PathVariable Long id) {
        var entities = service.findEjecutores(id);
        var responses = ejecutorMapper.toResponseList(entities);
        service.enrichEjecutores(responses);
        return ApiResponse.ok(responses);
    }

    @PostMapping("/{id}/ejecutores")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<LaborEjecutorResponse> asignarEjecutor(@PathVariable Long id,
                                                               @Valid @RequestBody LaborEjecutorRequest request) {
        var entity = ejecutorMapper.toEntity(request);
        var saved = service.asignarEjecutor(id, request.getEjecutorId(), entity);
        var response = ejecutorMapper.toResponse(saved);
        service.enrichEjecutores(List.of(response));
        return ApiResponse.ok(response, "Ejecutor asignado a la labor");
    }

    @PutMapping("/{id}/ejecutores/{ejecutorId}")
    public ApiResponse<LaborEjecutorResponse> actualizarEjecutor(@PathVariable Long id,
                                                                  @PathVariable Long ejecutorId,
                                                                  @Valid @RequestBody LaborEjecutorRequest request) {
        var entity = ejecutorMapper.toEntity(request);
        var saved = service.actualizarEjecutor(id, ejecutorId, entity);
        var response = ejecutorMapper.toResponse(saved);
        service.enrichEjecutores(List.of(response));
        return ApiResponse.ok(response, "Ejecutor actualizado en la labor");
    }

    @DeleteMapping("/{id}/ejecutores/{ejecutorId}")
    public ApiResponse<Boolean> desasignarEjecutor(@PathVariable Long id, @PathVariable Long ejecutorId) {
        service.desasignarEjecutor(id, ejecutorId);
        return ApiResponse.ok(true, "Ejecutor desasignado de la labor");
    }
}
