package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import com.sigre.compras.dto.*;
import com.sigre.compras.service.SolicitudCompraService;
import com.sigre.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/compras/solicitudes-compra")
@RequiredArgsConstructor
public class SolicitudCompraController {

    private final SolicitudCompraService solicitudCompraService;

    @GetMapping
    public ApiResponse<PageData<SolicitudCompraResponse>> listar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String prioridad,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaDesde,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaHasta,
            Pageable pageable) {
        var page = solicitudCompraService.listar(sucursalId, flagEstado, prioridad, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<SolicitudCompraDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(solicitudCompraService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<SolicitudCompraDetalleResponse> crear(
            @Valid @RequestBody SolicitudCompraRequest request) {
        return ApiResponse.ok(solicitudCompraService.crear(request), "Solicitud de compra creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<SolicitudCompraDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody SolicitudCompraRequest request) {
        return ApiResponse.ok(solicitudCompraService.actualizar(id, request), "Solicitud de compra actualizada");
    }

    @PostMapping("/{id}/enviar")
    public ApiResponse<SolicitudCompraDetalleResponse> enviar(@PathVariable Long id) {
        return ApiResponse.ok(solicitudCompraService.enviar(id), "Solicitud enviada");
    }

    @PostMapping("/{id}/aprobar")
    public ApiResponse<SolicitudCompraDetalleResponse> aprobar(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenCompraObservacionRequest body) {
        String obs = body != null ? body.getObservacion() : null;
        return ApiResponse.ok(solicitudCompraService.aprobar(id, obs), "Solicitud aprobada");
    }

    @PostMapping("/{id}/rechazar")
    public ApiResponse<SolicitudCompraDetalleResponse> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody OrdenCompraMotivoRequest request) {
        return ApiResponse.ok(solicitudCompraService.rechazar(id, request.getMotivo()), "Solicitud rechazada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<SolicitudCompraDetalleResponse> anular(
            @PathVariable Long id,
            @Valid @RequestBody OrdenCompraMotivoRequest request) {
        return ApiResponse.ok(solicitudCompraService.anular(id, request.getMotivo()), "Solicitud anulada");
    }

    @PostMapping("/{id}/convertir")
    public ApiResponse<ConvertirSolicitudResponse> convertir(
            @PathVariable Long id,
            @Valid @RequestBody ConvertirSolicitudRequest request) {
        return ApiResponse.ok(solicitudCompraService.convertir(id, request), "Solicitud convertida");
    }

    @GetMapping("/{id}/trazabilidad")
    public ApiResponse<java.util.List<TrazabilidadDocumentoResponse>> trazabilidad(@PathVariable Long id) {
        return ApiResponse.ok(solicitudCompraService.trazabilidad(id));
    }
}
