package pe.restaurant.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.request.MatrizContableDetRequest;
import pe.restaurant.contabilidad.dto.request.MatrizContableRequest;
import pe.restaurant.contabilidad.dto.response.MatrizContableDetResponse;
import pe.restaurant.contabilidad.dto.response.MatrizContableResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.mapper.MatrizContableMapper;
import pe.restaurant.contabilidad.service.MatrizContableService;

import java.util.List;

@RestController
@RequestMapping("/api/contabilidad/matriz-contable")
@RequiredArgsConstructor
@Tag(name = "Matriz Contable", description = "Mantenimiento de reglas contables (matriz_contable / matriz_contable_det)")
public class MatrizContableController {

    private final MatrizContableService service;
    private final MatrizContableMapper mapper;

    @GetMapping
    @Operation(summary = "Listar matrices contables")
    public ApiResponse<PageData<MatrizContableResponse>> findAll(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) Long grupoMatrizCntblId,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(size = 20) Pageable pageable) {
        var page = service.findAll(q, grupoMatrizCntblId, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseListWithoutDetalles(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener matriz contable con detalle")
    public ApiResponse<MatrizContableResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear matriz contable")
    public ApiResponse<MatrizContableResponse> create(@Valid @RequestBody MatrizContableRequest request) {
        return ApiResponse.ok(
                mapper.toResponseWithoutDetalles(service.create(request)),
                "Matriz contable creada"
        );
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar matriz contable")
    public ApiResponse<MatrizContableResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody MatrizContableRequest request) {
        return ApiResponse.ok(
                mapper.toResponseWithoutDetalles(service.update(id, request)),
                "Matriz contable actualizada"
        );
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar matriz contable (lógico)")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Matriz contable desactivada");
    }

    @GetMapping("/{id}/detalle")
    @Operation(summary = "Listar líneas de la matriz contable")
    public ApiResponse<List<MatrizContableDetResponse>> findDetalles(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toDetalleResponseList(service.findDetalles(id)));
    }

    @PostMapping("/{id}/detalle")
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Agregar línea a la matriz contable")
    public ApiResponse<MatrizContableDetResponse> createDetalle(
            @PathVariable Long id,
            @Valid @RequestBody MatrizContableDetRequest request) {
        return ApiResponse.ok(
                mapper.toDetalleResponse(service.createDetalle(id, request)),
                "Línea de matriz creada"
        );
    }

    @PutMapping("/{id}/detalle/{detalleId}")
    @Operation(summary = "Actualizar línea de la matriz contable")
    public ApiResponse<MatrizContableDetResponse> updateDetalle(
            @PathVariable Long id,
            @PathVariable Long detalleId,
            @Valid @RequestBody MatrizContableDetRequest request) {
        return ApiResponse.ok(
                mapper.toDetalleResponse(service.updateDetalle(id, detalleId, request)),
                "Línea de matriz actualizada"
        );
    }

    @DeleteMapping("/{id}/detalle/{detalleId}")
    @Operation(summary = "Eliminar línea de la matriz contable")
    public ApiResponse<Boolean> deleteDetalle(
            @PathVariable Long id,
            @PathVariable Long detalleId) {
        service.deleteDetalle(id, detalleId);
        return ApiResponse.ok(true, "Línea de matriz eliminada");
    }
}
