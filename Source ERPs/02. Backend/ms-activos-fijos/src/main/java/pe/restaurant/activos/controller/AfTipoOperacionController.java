package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfTipoOperacionRequest;
import pe.restaurant.activos.dto.AfTipoOperacionResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.entity.AfTipoOperacion;
import pe.restaurant.activos.service.AfTipoOperacionService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/activos/tipos-operacion")
@RequiredArgsConstructor
public class AfTipoOperacionController {

    private final AfTipoOperacionService service;

    @GetMapping
    public ApiResponse<PageData<AfTipoOperacionResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, page.map(this::toResponse).getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfTipoOperacionResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfTipoOperacionResponse> crear(@Valid @RequestBody AfTipoOperacionRequest request) {
        return ApiResponse.ok(toResponse(service.create(fromRequest(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfTipoOperacionResponse> actualizar(@PathVariable Long id,
                                                              @Valid @RequestBody AfTipoOperacionRequest request) {
        AfTipoOperacion existing = service.findById(id);
        applyRequest(request, existing);
        return ApiResponse.ok(toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<AfTipoOperacionResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.activate(id)));
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<AfTipoOperacionResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(toResponse(service.deactivate(id)));
    }

    private AfTipoOperacion fromRequest(AfTipoOperacionRequest r) {
        AfTipoOperacion e = new AfTipoOperacion();
        applyRequest(r, e);
        return e;
    }

    private void applyRequest(AfTipoOperacionRequest r, AfTipoOperacion e) {
        e.setCodigo(r.getCodigo().trim().toUpperCase());
        e.setDescripcion(r.getDescripcion());
        e.setNaturaleza(r.getNaturaleza());
        e.setTipoCalculo(r.getTipoCalculo());
        e.setCuentaContableId(r.getCuentaContableId());
        e.setCentroCostoId(r.getCentroCostoId());
        e.setAfectaContabilidad(r.getAfectaContabilidad());
        e.setMetodoCalculo(r.getMetodoCalculo());
        e.setObservaciones(r.getObservaciones());
    }

    private AfTipoOperacionResponse toResponse(AfTipoOperacion e) {
        AfTipoOperacionResponse r = new AfTipoOperacionResponse();
        r.setId(e.getId());
        r.setCodigo(e.getCodigo());
        r.setDescripcion(e.getDescripcion());
        r.setNaturaleza(e.getNaturaleza());
        r.setTipoCalculo(e.getTipoCalculo());
        r.setCuentaContableId(e.getCuentaContableId());
        r.setCentroCostoId(e.getCentroCostoId());
        r.setAfectaContabilidad(e.getAfectaContabilidad());
        r.setMetodoCalculo(e.getMetodoCalculo());
        r.setObservaciones(e.getObservaciones());
        r.setFlagEstado(e.getFlagEstado());
        return r;
    }
}
