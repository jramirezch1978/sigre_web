package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.mapper.CompradorCategoriaMapper;
import pe.restaurant.compras.mapper.CompradorMapper;
import pe.restaurant.compras.service.CompradorService;

import java.util.List;

@RestController
@RequestMapping("/api/compras/maestros/compradores")
@RequiredArgsConstructor
public class CompradorController {

    private final CompradorService service;
    private final CompradorMapper mapper;
    private final CompradorCategoriaMapper categoriaMapper;

    @GetMapping
    public ApiResponse<PageData<CompradorResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<CompradorResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CompradorResponse> create(@Valid @RequestBody CompradorRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<CompradorResponse> update(@PathVariable Long id,
                                                 @Valid @RequestBody CompradorRequest request) {
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
    public ApiResponse<CompradorResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<CompradorResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @GetMapping("/{compradorId}/categorias")
    public ApiResponse<List<CompradorCategoriaResponse>> findCategorias(@PathVariable Long compradorId) {
        return ApiResponse.ok(categoriaMapper.toResponseList(service.findCategorias(compradorId)));
    }

    @PostMapping("/{compradorId}/categorias")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CompradorCategoriaResponse> assignCategoria(
            @PathVariable Long compradorId,
            @Valid @RequestBody CompradorCategoriaRequest request) {
        var saved = service.assignCategoria(compradorId, request.getArticuloCategId());
        return ApiResponse.ok(categoriaMapper.toResponse(saved), "Categoría asignada");
    }
}
