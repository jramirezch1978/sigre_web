package pe.restaurant.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.almacen.dto.LotePalletRequest;
import pe.restaurant.almacen.dto.LotePalletResponse;
import pe.restaurant.almacen.dto.PageData;
import pe.restaurant.almacen.mapper.LotePalletMapper;
import pe.restaurant.almacen.service.LotePalletService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/almacen/lotes-pallets")
@RequiredArgsConstructor
public class LotePalletController {

    private final LotePalletService service;
    private final LotePalletMapper mapper;

    @GetMapping
    public ApiResponse<PageData<LotePalletResponse>> buscar(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = service.buscar(almacenId, articuloId, pageable);
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
