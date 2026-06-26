package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.mapper.ArticuloCategMapper;
import pe.restaurant.core.mapper.ArticuloSubCategMapper;
import pe.restaurant.core.service.ArticuloCategService;
import pe.restaurant.core.service.ArticuloSubCategService;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/core/categorias")
@RequiredArgsConstructor
public class ArticuloCategController {

    private final ArticuloCategService service;
    private final ArticuloCategMapper mapper;
    private final ArticuloSubCategService subCategService;
    private final ArticuloSubCategMapper subCategMapper;

    @GetMapping
    public ApiResponse<PageData<ArticuloCategResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/arbol")
    public ApiResponse<List<ArticuloCategArbolResponse>> arbol() {
        var categorias = service.findAll(Pageable.unpaged());
        List<ArticuloCategArbolResponse> arbol = categorias.getContent().stream()
                .map(cat -> {
                    var subCategorias = subCategService.findByCategoria(cat.getId());
                    var arbolItem = new ArticuloCategArbolResponse();
                    arbolItem.setId(cat.getId());
                    arbolItem.setCatArt(cat.getCatArt());
                    arbolItem.setDescCateg(cat.getDescCateg());
                    arbolItem.setFlagEstado(cat.getFlagEstado());
                    arbolItem.setSubCategorias(subCategMapper.toResponseList(subCategorias));
                    return arbolItem;
                })
                .collect(Collectors.toList());
        return ApiResponse.ok(arbol);
    }

    @GetMapping("/{id}")
    public ApiResponse<ArticuloCategResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloCategResponse> create(@Valid @RequestBody ArticuloCategRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<ArticuloCategResponse> update(@PathVariable Long id,
                                                     @Valid @RequestBody ArticuloCategRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<ArticuloCategResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(id)), "Registro desactivado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<ArticuloCategResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.activate(id)), "Registro activado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/{categoriaId}/sub-categorias")
    public ApiResponse<List<ArticuloSubCategResponse>> findSubCategorias(@PathVariable Long categoriaId) {
        service.findById(categoriaId);
        var subCategorias = subCategService.findByCategoria(categoriaId);
        return ApiResponse.ok(subCategMapper.toResponseList(subCategorias));
    }

    @PostMapping("/{categoriaId}/sub-categorias")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloSubCategResponse> createSubCategoria(@PathVariable Long categoriaId,
                                                                     @Valid @RequestBody ArticuloSubCategRequest request) {
        request.setArticuloCategId(categoriaId);
        var entity = subCategMapper.toEntity(request);
        return ApiResponse.ok(subCategMapper.toResponse(subCategService.create(entity)), "Registro creado");
    }
}
