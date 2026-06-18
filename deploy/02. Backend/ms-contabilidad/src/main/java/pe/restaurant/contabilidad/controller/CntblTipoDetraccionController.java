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
import pe.restaurant.contabilidad.dto.request.CntblTipoDetraccionRequest;
import pe.restaurant.contabilidad.dto.response.CntblTipoDetraccionResponse;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.mapper.CntblTipoDetraccionMapper;
import pe.restaurant.contabilidad.service.CntblTipoDetraccionService;

@RestController
@RequestMapping("/api/contabilidad/tipos-detraccion")
@RequiredArgsConstructor
@Tag(name = "Tipos de Detracción", description = "Mantenimiento de tipos de detracción (contabilidad.cntbl_tipo_detraccion)")
public class CntblTipoDetraccionController {

    private final CntblTipoDetraccionService service;
    private final CntblTipoDetraccionMapper mapper;

    @GetMapping
    @Operation(summary = "Listar tipos de detracción")
    public ApiResponse<PageData<CntblTipoDetraccionResponse>> findAll(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(size = 20) Pageable pageable) {
        var page = service.findAll(q, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener tipo de detracción por ID")
    public ApiResponse<CntblTipoDetraccionResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear tipo de detracción")
    public ApiResponse<CntblTipoDetraccionResponse> create(@Valid @RequestBody CntblTipoDetraccionRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(request)), "Tipo de detracción creado");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar tipo de detracción")
    public ApiResponse<CntblTipoDetraccionResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody CntblTipoDetraccionRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.update(id, request)), "Tipo de detracción actualizado");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar tipo de detracción")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Tipo de detracción desactivado");
    }
}
