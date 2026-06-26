package pe.restaurant.activos.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.AfDocumentoRequest;
import pe.restaurant.activos.dto.AfDocumentoResponse;
import pe.restaurant.activos.dto.PageData;
import pe.restaurant.activos.mapper.AfDocumentoMapper;
import pe.restaurant.activos.service.AfDocumentoService;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;

@RestController
@RequestMapping("/api/activos/documentos")
@RequiredArgsConstructor
public class AfDocumentoController {

    private final AfDocumentoService service;
    private final AfDocumentoMapper mapper;

    @GetMapping
    public ApiResponse<PageData<AfDocumentoResponse>> listar(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    public ApiResponse<AfDocumentoResponse> obtenerPorId(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<AfDocumentoResponse> crear(@Valid @RequestBody AfDocumentoRequest request) {
        var entity = mapper.toEntity(request);
        return ApiResponse.ok(mapper.toResponse(service.create(entity)), "Registro creado");
    }

    @PutMapping("/{id}")
    public ApiResponse<AfDocumentoResponse> actualizar(@PathVariable Long id,
                                                        @Valid @RequestBody AfDocumentoRequest request) {
        var existing = service.findById(id);
        mapper.updateEntity(request, existing);
        return ApiResponse.ok(mapper.toResponse(service.update(id, existing)), "Registro actualizado");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> eliminar(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @GetMapping("/activo/{activoId}")
    public ApiResponse<List<AfDocumentoResponse>> listarPorActivo(@PathVariable Long activoId) {
        var documentos = service.findByActivo(activoId);
        return ApiResponse.ok(mapper.toResponseList(documentos));
    }

    @GetMapping("/tipo/{tipoDocumento}")
    public ApiResponse<PageData<AfDocumentoResponse>> listarPorTipo(@PathVariable String tipoDocumento,
                                                                      Pageable pageable) {
        var page = service.findByTipo(tipoDocumento, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

}
