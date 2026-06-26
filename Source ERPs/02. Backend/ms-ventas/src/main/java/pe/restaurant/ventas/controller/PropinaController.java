package pe.restaurant.ventas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.ventas.dto.request.PropinaRequest;
import pe.restaurant.ventas.dto.response.PageData;
import pe.restaurant.ventas.dto.response.PropinaResponse;
import pe.restaurant.ventas.mapper.VentasIssue5DtoMapper;
import pe.restaurant.ventas.service.PropinaService;

import java.time.LocalDate;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/propinas")
@RequiredArgsConstructor
@Tag(name = "Propinas", description = "Propinas asociadas a factura simplificada")
public class PropinaController {

    private final PropinaService service;
    private final VentasIssue5DtoMapper mapper;

    @GetMapping
    @Operation(summary = "Listar propinas")
    public ApiResponse<PageData<PropinaResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long fsFacturaSimplId,
            @RequestParam(required = false) Long trabajadorId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta,
            @RequestParam(required = false) String flagEstado) {
        var page = service.findAll(fsFacturaSimplId, trabajadorId, fechaDesde, fechaHasta, flagEstado, pageable);
        var content = page.getContent().stream().map(mapper::toPropinaResponse).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener propina por id")
    public ApiResponse<PropinaResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toPropinaResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Crear propina")
    public ApiResponse<PropinaResponse> create(@Valid @RequestBody PropinaRequest request) {
        return ApiResponse.ok(mapper.toPropinaResponse(service.create(request)), "Propina registrada");
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar propina")
    public ApiResponse<PropinaResponse> update(@PathVariable Long id, @Valid @RequestBody PropinaRequest request) {
        return ApiResponse.ok(mapper.toPropinaResponse(service.update(id, request)), "Propina actualizada");
    }

    @PatchMapping("/{id}/activar")
    @Operation(summary = "Activar propina")
    public ApiResponse<PropinaResponse> activar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toPropinaResponse(service.activar(id)), "Activada");
    }

    @PatchMapping("/{id}/desactivar")
    @Operation(summary = "Desactivar propina")
    public ApiResponse<PropinaResponse> desactivar(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toPropinaResponse(service.desactivar(id)), "Desactivada");
    }
}
