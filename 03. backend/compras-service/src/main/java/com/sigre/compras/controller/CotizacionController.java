package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.compras.dto.*;
import com.sigre.compras.service.CotizacionService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/compras/cotizaciones")
@RequiredArgsConstructor
public class CotizacionController {

    private final CotizacionService cotizacionService;

    @GetMapping
    public ApiResponse<PageData<CotizacionResponse>> listar(
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = cotizacionService.listar(proveedorId, flagEstado, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/comparativo")
    public ApiResponse<ComparativoCotizacionesResponse> comparativo(
            @RequestParam List<Long> proveedorIds,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        return ApiResponse.ok(cotizacionService.comparativo(proveedorIds, fechaDesde, fechaHasta));
    }

    @GetMapping("/{id}")
    public ApiResponse<CotizacionDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(cotizacionService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CotizacionDetalleResponse> crear(
            @Valid @RequestBody CotizacionRequest request) {
        return ApiResponse.ok(cotizacionService.crear(request), "Cotización creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<CotizacionDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody CotizacionRequest request) {
        return ApiResponse.ok(cotizacionService.actualizar(id, request), "Cotización actualizada");
    }

    @PostMapping("/{id}/seleccionar")
    public ApiResponse<CotizacionDetalleResponse> seleccionar(@PathVariable Long id) {
        return ApiResponse.ok(cotizacionService.seleccionar(id), "Cotización seleccionada");
    }

    @PostMapping("/{id}/descartar")
    public ApiResponse<CotizacionDetalleResponse> descartar(@PathVariable Long id) {
        return ApiResponse.ok(cotizacionService.descartar(id), "Cotización descartada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<CotizacionDetalleResponse> anular(
            @PathVariable Long id,
            @Valid @RequestBody CotizacionMotivoRequest request) {
        return ApiResponse.ok(cotizacionService.anular(id, request.getMotivo()), "Cotización anulada");
    }

    @PostMapping("/{id}/convertir-oc")
    public ApiResponse<OrdenCompraDetalleResponse> convertirOc(
            @PathVariable Long id,
            @Valid @RequestBody ConvertirOcRequest request) {
        return ApiResponse.ok(cotizacionService.convertirOc(id, request), "Cotización convertida a OC");
    }
}
