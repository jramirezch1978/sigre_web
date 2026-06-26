package pe.restaurant.contabilidad.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.contabilidad.dto.request.UitRequest;
import pe.restaurant.contabilidad.dto.response.PageData;
import pe.restaurant.contabilidad.dto.response.UitResponse;
import pe.restaurant.contabilidad.mapper.UitMapper;
import pe.restaurant.contabilidad.service.UitService;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/contabilidad/uit")
@RequiredArgsConstructor
@Tag(name = "UIT", description = "Unidad Impositiva Tributaria (core.uit)")
public class UitController {

    private final UitService service;
    private final UitMapper mapper;

    @GetMapping
    @Operation(summary = "Listar registros UIT")
    public ApiResponse<PageData<UitResponse>> findAll(
            @RequestParam(required = false) Integer ano,
            @RequestParam(required = false) String flagEstado,
            @PageableDefault(size = 20) Pageable pageable) {
        var page = service.findAll(ano, flagEstado, pageable);
        return ApiResponse.ok(PageData.of(page, mapper.toResponseList(page.getContent())));
    }

    @GetMapping("/ultima-vigente")
    @Operation(summary = "Obtener la última UIT vigente a una fecha de referencia")
    public ApiResponse<UitResponse> findUltimaVigente(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        return ApiResponse.ok(mapper.toResponse(service.findUltimaVigente(fecha)));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener UIT por ID")
    public ApiResponse<UitResponse> findById(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Registrar UIT")
    public ApiResponse<UitResponse> create(@Valid @RequestBody UitRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.create(request)), "UIT registrada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar UIT")
    public ApiResponse<UitResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody UitRequest request) {
        return ApiResponse.ok(mapper.toResponse(service.update(id, request)), "UIT actualizada");
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar UIT")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "UIT desactivada");
    }
}
