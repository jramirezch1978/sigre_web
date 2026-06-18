package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.mapper.GeografiaMapper;
import pe.restaurant.core.service.GeografiaService;

@RestController
@RequestMapping("/api/core/geografia")
@RequiredArgsConstructor
public class GeografiaController {

    private final GeografiaService service;
    private final GeografiaMapper mapper;

    // ── Pais ──────────────────────────────────────────────────────────────

    @GetMapping("/paises")
    public ApiResponse<PageData<PaisResponse>> listPaises(Pageable pageable) {
        var page = service.findAllPaises(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toPaisResponseList(page.getContent())));
    }

    @GetMapping("/paises/{id}")
    public ApiResponse<PaisResponse> findPaisById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findPaisById(id)));
    }

    @PostMapping("/paises")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<PaisResponse> createPais(@Valid @RequestBody PaisRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.createPais(entity)), "Registro creado");
    }

    @PutMapping("/paises/{id}")
    public ApiResponse<PaisResponse> updatePais(@PathVariable Long id,
                                                @Valid @RequestBody PaisRequest request) {
        var existing = service.findPaisById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.updatePais(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/paises/{id}/activar")
    public ApiResponse<PaisResponse> activatePais(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activatePais(id)), "Registro activado");
    }

    @PatchMapping("/paises/{id}/desactivar")
    public ApiResponse<PaisResponse> deactivatePais(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivatePais(id)), "Registro desactivado");
    }

    @DeleteMapping("/paises/{id}")
    public ApiResponse<Boolean> deletePais(@PathVariable Long id) {
        service.deletePais(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    // ── Departamento ──────────────────────────────────────────────────────

    @GetMapping("/departamentos")
    public ApiResponse<PageData<DepartamentoResponse>> listDepartamentos(
            @RequestParam(required = false) Long paisId,
            Pageable pageable) {
        var page = service.findAllDepartamentos(paisId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toDepartamentoResponseList(page.getContent())));
    }

    @GetMapping("/departamentos/{id}")
    public ApiResponse<DepartamentoResponse> findDepartamentoById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findDepartamentoById(id)));
    }

    @PostMapping("/departamentos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DepartamentoResponse> createDepartamento(@Valid @RequestBody DepartamentoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.createDepartamento(entity)), "Registro creado");
    }

    @PutMapping("/departamentos/{id}")
    public ApiResponse<DepartamentoResponse> updateDepartamento(@PathVariable Long id,
                                                                @Valid @RequestBody DepartamentoRequest request) {
        var existing = service.findDepartamentoById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.updateDepartamento(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/departamentos/{id}/activar")
    public ApiResponse<DepartamentoResponse> activateDepartamento(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activateDepartamento(id)), "Registro activado");
    }

    @PatchMapping("/departamentos/{id}/desactivar")
    public ApiResponse<DepartamentoResponse> deactivateDepartamento(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivateDepartamento(id)), "Registro desactivado");
    }

    @DeleteMapping("/departamentos/{id}")
    public ApiResponse<Boolean> deleteDepartamento(@PathVariable Long id) {
        service.deleteDepartamento(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    // ── Provincia ─────────────────────────────────────────────────────────

    @GetMapping("/provincias")
    public ApiResponse<PageData<ProvinciaResponse>> listProvincias(
            @RequestParam(required = false) Long departamentoId,
            Pageable pageable) {
        var page = service.findAllProvincias(departamentoId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toProvinciaResponseList(page.getContent())));
    }

    @GetMapping("/provincias/{id}")
    public ApiResponse<ProvinciaResponse> findProvinciaById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findProvinciaById(id)));
    }

    @PostMapping("/provincias")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ProvinciaResponse> createProvincia(@Valid @RequestBody ProvinciaRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.createProvincia(entity)), "Registro creado");
    }

    @PutMapping("/provincias/{id}")
    public ApiResponse<ProvinciaResponse> updateProvincia(@PathVariable Long id,
                                                          @Valid @RequestBody ProvinciaRequest request) {
        var existing = service.findProvinciaById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.updateProvincia(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/provincias/{id}/activar")
    public ApiResponse<ProvinciaResponse> activateProvincia(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activateProvincia(id)), "Registro activado");
    }

    @PatchMapping("/provincias/{id}/desactivar")
    public ApiResponse<ProvinciaResponse> deactivateProvincia(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivateProvincia(id)), "Registro desactivado");
    }

    @DeleteMapping("/provincias/{id}")
    public ApiResponse<Boolean> deleteProvincia(@PathVariable Long id) {
        service.deleteProvincia(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    // ── Distrito ──────────────────────────────────────────────────────────

    @GetMapping("/distritos")
    public ApiResponse<PageData<DistritoResponse>> listDistritos(
            @RequestParam(required = false) Long provinciaId,
            Pageable pageable) {
        var page = service.findAllDistritos(provinciaId, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toDistritoResponseList(page.getContent())));
    }

    @GetMapping("/distritos/{id}")
    public ApiResponse<DistritoResponse> findDistritoById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findDistritoById(id)));
    }

    @PostMapping("/distritos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DistritoResponse> createDistrito(@Valid @RequestBody DistritoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.createDistrito(entity)), "Registro creado");
    }

    @PutMapping("/distritos/{id}")
    public ApiResponse<DistritoResponse> updateDistrito(@PathVariable Long id,
                                                        @Valid @RequestBody DistritoRequest request) {
        var existing = service.findDistritoById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.updateDistrito(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/distritos/{id}/activar")
    public ApiResponse<DistritoResponse> activateDistrito(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activateDistrito(id)), "Registro activado");
    }

    @PatchMapping("/distritos/{id}/desactivar")
    public ApiResponse<DistritoResponse> deactivateDistrito(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivateDistrito(id)), "Registro desactivado");
    }

    @DeleteMapping("/distritos/{id}")
    public ApiResponse<Boolean> deleteDistrito(@PathVariable Long id) {
        service.deleteDistrito(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }
}
