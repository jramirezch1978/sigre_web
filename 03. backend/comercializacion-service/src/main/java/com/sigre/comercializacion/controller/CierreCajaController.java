package com.sigre.comercializacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.common.dto.ApiResponse;
import com.sigre.comercializacion.dto.request.CierreCajaCerrarRequest;
import com.sigre.comercializacion.dto.request.CierreCajaRequest;
import com.sigre.comercializacion.dto.response.CierreCajaResponse;
import com.sigre.comercializacion.dto.response.PageData;
import com.sigre.comercializacion.mapper.VentasResponseMapper;
import com.sigre.comercializacion.service.CierreCajaService;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/ventas/cierre-caja")
@RequiredArgsConstructor
@Tag(name = "Cierre de caja", description = "Registro y cierre de turno de caja")
public class CierreCajaController {

    private final CierreCajaService service;
    private final VentasResponseMapper mapper;

    @GetMapping
    @Operation(summary = "Listar cierres de caja")
    public ApiResponse<PageData<CierreCajaResponse>> list(
            Pageable pageable,
            @RequestParam(required = false) Long turnoId,
            @RequestParam(required = false) Boolean abierto) {
        var page = service.findAll(turnoId, abierto, pageable);
        var content = page.getContent().stream().map(mapper::toCierreCajaResponse).collect(Collectors.toList());
        return ApiResponse.ok(PageData.of(page, content));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener cierre por id")
    public ApiResponse<CierreCajaResponse> get(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toCierreCajaResponse(service.findById(id)));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @Operation(summary = "Registrar cierre de caja abierto (sin fecha_cierre)")
    public ApiResponse<CierreCajaResponse> create(@Valid @RequestBody CierreCajaRequest request) {
        return ApiResponse.ok(mapper.toCierreCajaResponse(service.create(request)), "Cierre registrado");
    }

    @PatchMapping("/{id}/cerrar")
    @Operation(summary = "Finalizar cierre (fondo final, diferencia)")
    public ApiResponse<CierreCajaResponse> cerrar(@PathVariable Long id, @Valid @RequestBody CierreCajaCerrarRequest request) {
        return ApiResponse.ok(mapper.toCierreCajaResponse(service.cerrar(id, request)), "Cierre finalizado");
    }
}
