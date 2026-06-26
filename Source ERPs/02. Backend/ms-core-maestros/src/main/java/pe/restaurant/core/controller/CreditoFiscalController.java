package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.CreditoFiscalRequest;
import pe.restaurant.core.dto.CreditoFiscalResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.CreditoFiscalMapper;
import pe.restaurant.core.service.CreditoFiscalService;

@RestController
@RequestMapping("/api/core/creditos-fiscales")
@RequiredArgsConstructor
public class CreditoFiscalController {

    private final CreditoFiscalService service;
    private final CreditoFiscalMapper mapper;

    @GetMapping
    public ApiResponse<PageData<CreditoFiscalResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CreditoFiscalResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CreditoFiscalResponse> create(@Valid @RequestBody CreditoFiscalRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CreditoFiscalResponse> update(@PathVariable Long id, @Valid @RequestBody CreditoFiscalRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<CreditoFiscalResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CreditoFiscalResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }
}
