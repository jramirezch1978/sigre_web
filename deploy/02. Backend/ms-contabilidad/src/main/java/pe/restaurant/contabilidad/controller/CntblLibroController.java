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
import pe.restaurant.contabilidad.dto.request.CntblLibroRequest;
import pe.restaurant.contabilidad.dto.response.CntblLibroResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.mapper.CntblLibroMapper;
import pe.restaurant.contabilidad.service.CntblLibroService;

@RestController
@RequestMapping("/api/contabilidad/libros-contables")
@RequiredArgsConstructor
@Tag(name = "Libros Contables", description = "Mantenimiento de libros contables (contabilidad.cntbl_libro)")
public class CntblLibroController {

    private final CntblLibroService service;
    private final CntblLibroMapper mapper;

    @GetMapping
    @Operation(summary = "Listar libros contables")
    public ApiResponse<PageData<CntblLibroResponse>> findAll(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(size = 20) Pageable pageable) {
        var page = service.findAll(q, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/por-codigo/{codigo}")
    @Operation(summary = "Obtener libro contable por código")
    public ApiResponse<CntblLibroResponse> findByCodigo(@PathVariable String codigo) {
        return ApiResponse.ok(mapper.toResponse(service.findByCodigo(codigo)));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener libro contable por ID")
    public ApiResponse<CntblLibroResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear libro contable")
    public ApiResponse<CntblLibroResponse> create(@Valid @RequestBody CntblLibroRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(request)), "Libro contable creado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar libro contable")
    public ApiResponse<CntblLibroResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody CntblLibroRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.update(id, request)), "Libro contable actualizado");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar libro contable")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Libro contable desactivado");
    }
}
