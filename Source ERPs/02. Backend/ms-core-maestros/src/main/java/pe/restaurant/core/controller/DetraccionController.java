package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.dto.PageData;
import pe.restaurant.core.mapper.DetraccionMapper;
import pe.restaurant.core.service.DetraccionService;

@RestController
@RequestMapping("/api/core/detracciones-bienes-servicios")
@RequiredArgsConstructor
public class DetraccionController {
    private final DetraccionService service;
    private final DetraccionMapper mapper;

    @GetMapping
    public ApiResponse<PageData<DetraccionResponse>> list(Pageable pageable) {
        var page = service.list(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(mapper::toResponse).toList()));
    }

    @GetMapping("/{bienServ}")
    public ApiResponse<DetraccionResponse> getById(@PathVariable String bienServ) {
        return ApiResponse.ok(service.getById(bienServ));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<DetraccionResponse> create(@Valid @RequestBody DetraccionRequest request) {
        return ApiResponse.ok(service.create(request), "Maestro de detraccion creado");
    }

    @PutMapping("/{bienServ}")
    public ApiResponse<DetraccionResponse> update(@PathVariable String bienServ, @Valid @RequestBody DetraccionRequest request) {
        return ApiResponse.ok(service.update(bienServ, request), "Maestro de detraccion actualizado");
    }

    @DeleteMapping("/{bienServ}")
    public ApiResponse<Boolean> delete(@PathVariable String bienServ) {
        service.delete(bienServ);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{bienServ}/activar")
    public ApiResponse<DetraccionResponse> activate(@PathVariable String bienServ) {
        return ApiResponse.ok(mapper.toResponse(service.activate(bienServ)), "Registro activado");
    }

    @PatchMapping("/{bienServ}/desactivar")
    public ApiResponse<DetraccionResponse> deactivate(@PathVariable String bienServ) {
        return ApiResponse.ok(mapper.toResponse(service.deactivate(bienServ)), "Registro desactivado");
    }
}
