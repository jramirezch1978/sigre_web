package com.sigre.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.compras.dto.*;
import com.sigre.compras.service.OrdenCompraPdfService;
import com.sigre.compras.service.OrdenCompraService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/compras/ordenes-compra")
@RequiredArgsConstructor
public class OrdenCompraController {

    private final OrdenCompraService ordenCompraService;
    private final OrdenCompraPdfService ordenCompraPdfService;

    @GetMapping
    public ApiResponse<PageData<OrdenCompraResumenResponse>> listar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) String numero,
            @RequestParam(required = false) Long monedaId,
            Pageable pageable) {
        var page = ordenCompraService.listar(sucursalId, proveedorId, flagEstado,
                fechaDesde, fechaHasta, numero, monedaId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/pendientes-aprobacion")
    public ApiResponse<PageData<OrdenCompraResumenResponse>> pendientesAprobacion(Pageable pageable) {
        var page = ordenCompraService.pendientesAprobacion(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<OrdenCompraDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OrdenCompraDetalleResponse> crear(@Valid @RequestBody OrdenCompraCabeceraRequest request) {
        return ApiResponse.ok(ordenCompraService.crear(request), "Orden de compra creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrdenCompraDetalleResponse> actualizar(@PathVariable Long id,
                                                                @Valid @RequestBody OrdenCompraCabeceraRequest request) {
        return ApiResponse.ok(ordenCompraService.actualizar(id, request), "Orden de compra actualizada");
    }

    @PatchMapping("/{id}/igv")
    public ApiResponse<OrdenCompraDetalleResponse> modificarIgv(@PathVariable Long id,
                                                                  @Valid @RequestBody ModificarIgvRequest request) {
        return ApiResponse.ok(ordenCompraService.modificarIgv(id, request), "IGV actualizado");
    }

    @PostMapping("/{id}/enviar-aprobacion")
    public ApiResponse<OrdenCompraDetalleResponse> enviarAprobacion(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.enviarAprobacion(id), "Enviada a aprobación");
    }

    @PostMapping("/{id}/aprobar")
    public ApiResponse<OrdenCompraDetalleResponse> aprobar(@PathVariable Long id,
                                                           @RequestBody(required = false) OrdenCompraObservacionRequest body) {
        String obs = body != null ? body.getObservacion() : null;
        return ApiResponse.ok(ordenCompraService.aprobar(id, obs), "Orden aprobada");
    }

    @PostMapping("/{id}/rechazar")
    public ApiResponse<OrdenCompraDetalleResponse> rechazar(@PathVariable Long id,
                                                             @Valid @RequestBody OrdenCompraMotivoRequest request) {
        return ApiResponse.ok(ordenCompraService.rechazar(id, request.getMotivo()), "Orden rechazada");
    }

    @PostMapping("/{id}/devolver")
    public ApiResponse<OrdenCompraDetalleResponse> devolver(@PathVariable Long id,
                                                             @RequestBody(required = false) OrdenCompraMotivoRequest request) {
        String motivo = request != null ? request.getMotivo() : null;
        return ApiResponse.ok(ordenCompraService.devolver(id, motivo), "Orden devuelta a borrador");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<OrdenCompraDetalleResponse> anular(@PathVariable Long id,
                                                          @Valid @RequestBody OrdenCompraMotivoRequest request) {
        return ApiResponse.ok(ordenCompraService.anular(id, request.getMotivo()), "Orden anulada");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<OrdenCompraDetalleResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.cerrar(id), "Orden cerrada");
    }

    @GetMapping("/{id}/historial-aprobaciones")
    public ApiResponse<List<HistorialAprobacionResponse>> historial(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.historial(id));
    }

    @GetMapping("/{id}/recepciones")
    public ApiResponse<List<RecepcionResumenResponse>> recepciones(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.recepciones(id));
    }

    @GetMapping("/{id}/saldo-pendiente")
    public ApiResponse<OrdenCompraSaldoPendienteResponse> saldoPendiente(@PathVariable Long id) {
        return ApiResponse.ok(ordenCompraService.saldoPendiente(id));
    }

    @PostMapping("/{id}/recepcionar-almacen")
    public ApiResponse<OrdenCompraRecepcionResponse> recepcionarEnAlmacen(
            @PathVariable Long id,
            @Valid @RequestBody OrdenCompraRecepcionRequest request) {
        return ApiResponse.ok(ordenCompraService.recepcionarEnAlmacen(id, request), "Recepción en almacén generada");
    }

    @GetMapping("/datos-articulo")
    public ApiResponse<DatosArticuloResponse> datosArticulo(
            @RequestParam Long articuloId,
            @RequestParam Long proveedorId,
            @RequestParam Long monedaId,
            @RequestParam Long sucursalId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaEmision) {
        return ApiResponse.ok(ordenCompraService.datosArticulo(
                articuloId, proveedorId, monedaId, sucursalId, fechaEmision));
    }

    @PostMapping("/{id}/enviar-proveedor")
    public ApiResponse<Boolean> enviarProveedor(@PathVariable Long id,
                                                @RequestBody(required = false) EnviarProveedorRequest request) {
        boolean enviado = ordenCompraService.enviarProveedor(id, request);
        return ApiResponse.ok(enviado, "Orden de compra enviada al proveedor");
    }

    @PostMapping("/{id}/pdf")
    public ResponseEntity<byte[]> pdf(@PathVariable Long id) {
        byte[] pdfBytes = ordenCompraPdfService.generarPdf(id);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=OC-" + id + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .contentLength(pdfBytes.length)
                .body(pdfBytes);
    }
}
