package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.NumTablasRequest;
import pe.restaurant.core.dto.NumTablasResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.entity.NumTablas;
import pe.restaurant.core.mapper.NumTablasMapper;
import pe.restaurant.core.service.NumTablasService;

@RestController
@RequestMapping("/api/core/num-tablas")
@RequiredArgsConstructor
public class NumTablasController {

    private final NumTablasService service;
    private final NumTablasMapper mapper;

    @GetMapping
    public ApiResponse<PageData<NumTablasResponse>> findAll(Pageable pageable) {
        var page = service.findAll(pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/buscar")
    public ApiResponse<NumTablasResponse> findById(@RequestParam String nombreTabla, @RequestParam String codOrigen) {
        return ApiResponse.ok(mapper.toResponse(service.findById(buildId(nombreTabla, codOrigen))));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<NumTablasResponse> create(@Valid @RequestBody NumTablasRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(mapper.toEntity(request))), "Registro creado");
    }

    @PutMapping("/buscar")
    public ApiResponse<NumTablasResponse> update(@RequestParam String nombreTabla, @RequestParam String codOrigen,
                                                 @Valid @RequestBody NumTablasRequest request) {
        var existing = service.findById(buildId(nombreTabla, codOrigen));
        existing.setUltimoNumero(request.getUltimoNumero());
        return ApiResponse.ok(mapper.toResponse(service.update(existing)), "Registro actualizado");
    }

    @DeleteMapping("/buscar")
    public ApiResponse<Boolean> delete(@RequestParam String nombreTabla, @RequestParam String codOrigen) {
        service.delete(buildId(nombreTabla, codOrigen));
        return ApiResponse.ok(true, "Registro eliminado");
    }

    private NumTablas.NumTablasId buildId(String nombreTabla, String codOrigen) {
        NumTablas.NumTablasId id = new NumTablas.NumTablasId();
        id.setNombreTabla(nombreTabla);
        id.setCodOrigen(codOrigen);
        return id;
    }
}
