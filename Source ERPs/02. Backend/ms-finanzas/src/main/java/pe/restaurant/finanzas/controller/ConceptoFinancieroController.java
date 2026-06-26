package pe.restaurant.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.finanzas.dto.request.ConceptoFinancieroRequest;
import pe.restaurant.finanzas.dto.response.ConceptoFinancieroResponse;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;
import pe.restaurant.finanzas.mapper.ConceptoFinancieroMapper;
import pe.restaurant.finanzas.service.ConceptoFinancieroService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.response.PageData;

@RestController
@RequestMapping("/api/finanzas/conceptos-financieros")
@RequiredArgsConstructor
@Tag(name = "Conceptos Financieros", description = "Gestión del catálogo de conceptos financieros")
public class ConceptoFinancieroController {

    private final ConceptoFinancieroService service;
    private final ConceptoFinancieroMapper mapper;

    @GetMapping
    @Operation(summary = "Listar conceptos financieros", description = "Obtiene un listado paginado de conceptos financieros")
    public ApiResponse<PageData<ConceptoFinancieroResponse>> findAll(Pageable pageable) {
        Page<ConceptoFinanciero> page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<ConceptoFinancieroResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ConceptoFinancieroResponse> create(@Valid @RequestBody ConceptoFinancieroRequest request) {
        ConceptoFinanciero entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ConceptoFinancieroResponse> update(@PathVariable Long id,
                                                         @Valid @RequestBody ConceptoFinancieroRequest request) {
        ConceptoFinanciero existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ConceptoFinancieroResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ConceptoFinancieroResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
