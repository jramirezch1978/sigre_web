package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.dto.CuentaPagarVinculadaResponse;
import pe.restaurant.compras.service.OrdenServicioPdfService;
import pe.restaurant.compras.service.OrdenServicioService;
import pe.restaurant.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/compras/ordenes-servicio")
@RequiredArgsConstructor
public class OrdenServicioController {

    private final OrdenServicioService ordenServicioService;
    private final OrdenServicioPdfService ordenServicioPdfService;

    @GetMapping
    public ApiResponse<PageData<OrdenServicioResumenResponse>> listar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String codOrigen,
            @RequestParam(required = false) String numero,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) Long compradorId,
            @RequestParam(required = false) String flagReqServ,
            @RequestParam(required = false) Long ordenTrabajoId,
            @RequestParam(required = false) String jobCodigo,
            Pageable pageable) {
        var page = ordenServicioService.listar(sucursalId, proveedorId, flagEstado,
                codOrigen, numero, fechaDesde, fechaHasta, monedaId, compradorId,
                flagReqServ, ordenTrabajoId, jobCodigo, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/pendientes-aprobacion")
    public ApiResponse<PageData<OrdenServicioResumenResponse>> pendientesAprobacion(Pageable pageable) {
        var page = ordenServicioService.pendientesAprobacion(pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<OrdenServicioDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OrdenServicioDetalleResponse> crear(
            @Valid @RequestBody OrdenServicioCabeceraRequest request) {
        return ApiResponse.ok(ordenServicioService.crear(request), "Orden de servicio creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrdenServicioDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody OrdenServicioCabeceraRequest request) {
        return ApiResponse.ok(ordenServicioService.actualizar(id, request), "Orden de servicio actualizada");
    }

    @PostMapping("/{id}/enviar-aprobacion")
    public ApiResponse<OrdenServicioDetalleResponse> enviarAprobacion(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.enviarAprobacion(id), "Enviada a aprobación");
    }

    @PostMapping("/{id}/aprobar")
    public ApiResponse<OrdenServicioDetalleResponse> aprobar(
            @PathVariable Long id,
            @RequestBody(required = false) OrdenServicioObservacionRequest body) {
        String obs = body != null ? body.getObservacion() : null;
        return ApiResponse.ok(ordenServicioService.aprobar(id, obs), "Orden aprobada");
    }

    @PostMapping("/{id}/rechazar")
    public ApiResponse<OrdenServicioDetalleResponse> rechazar(
            @PathVariable Long id,
            @Valid @RequestBody OrdenServicioMotivoRequest request) {
        return ApiResponse.ok(ordenServicioService.rechazar(id, request.getMotivo()), "Orden rechazada");
    }

    @PostMapping("/{id}/devolver")
    public ApiResponse<OrdenServicioDetalleResponse> devolver(
            @PathVariable Long id,
            @Valid @RequestBody OrdenServicioMotivoRequest request) {
        return ApiResponse.ok(ordenServicioService.devolver(id, request.getMotivo()), "Devuelta a generada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<OrdenServicioDetalleResponse> anular(
            @PathVariable Long id,
            @Valid @RequestBody OrdenServicioMotivoRequest request) {
        return ApiResponse.ok(ordenServicioService.anular(id, request.getMotivo()), "Orden anulada");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<OrdenServicioDetalleResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.cerrar(id), "Orden cerrada");
    }

    @PostMapping("/{id}/lineas/{lineaId}/conformidad")
    public ApiResponse<OrdenServicioDetalleResponse> registrarConformidad(
            @PathVariable Long id,
            @PathVariable Long lineaId,
            @RequestBody(required = false) ConformidadOsRequest request) {
        return ApiResponse.ok(
                ordenServicioService.registrarConformidad(id, lineaId, request),
                "Conformidad registrada");
    }

    @DeleteMapping("/{id}/lineas/{lineaId}/conformidad")
    public ApiResponse<OrdenServicioDetalleResponse> revertirConformidad(
            @PathVariable Long id,
            @PathVariable Long lineaId,
            @RequestBody(required = false) ConformidadOsRequest request) {
        return ApiResponse.ok(
                ordenServicioService.revertirConformidad(id, lineaId, request),
                "Conformidad revertida");
    }

    @PostMapping("/{id}/ajuste-valor")
    public ApiResponse<OrdenServicioDetalleResponse> ajustarValor(
            @PathVariable Long id,
            @Valid @RequestBody AjusteValorOsRequest request) {
        return ApiResponse.ok(
                ordenServicioService.ajustarValor(id, request),
                "Valor ajustado");
    }

    @GetMapping("/{id}/historial-aprobaciones")
    public ApiResponse<List<HistorialAprobacionResponse>> historial(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.historial(id));
    }

    @GetMapping("/{id}/saldo-pendiente")
    public ApiResponse<OrdenServicioSaldoPendienteResponse> saldoPendiente(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.saldoPendiente(id));
    }

    @GetMapping("/{id}/cuentas-pagar")
    public ApiResponse<List<CuentaPagarVinculadaResponse>> cuentasPagar(@PathVariable Long id) {
        return ApiResponse.ok(ordenServicioService.cuentasPagar(id));
    }

    @GetMapping("/servicios-disponibles")
    public ApiResponse<List<ServicioDisponibleResponse>> serviciosDisponibles(
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) Long monedaId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) java.time.LocalDate fechaRegistro,
            @RequestParam(required = false) String codSubCat) {
        return ApiResponse.ok(ordenServicioService.serviciosDisponibles(proveedorId, monedaId, fechaRegistro, codSubCat));
    }

    @GetMapping("/datos-servicio")
    public ApiResponse<DatosServicioResponse> datosServicio(
            @RequestParam Long servicioId,
            @RequestParam Long proveedorId,
            @RequestParam Long monedaId,
            @RequestParam Long sucursalId) {
        return ApiResponse.ok(ordenServicioService.datosServicio(
                servicioId, proveedorId, monedaId, sucursalId));
    }

    @PostMapping("/{id}/enviar-proveedor")
    public ApiResponse<Boolean> enviarProveedor(
            @PathVariable Long id,
            @RequestBody(required = false) EnviarProveedorOsRequest request) {
        boolean enviado = ordenServicioService.enviarProveedor(id, request);
        return ApiResponse.ok(enviado, "Orden de servicio enviada al proveedor");
    }

    @GetMapping("/pendientes-conformidad")
    public ApiResponse<PageData<LineaConformidadResponse>> pendientesConformidad(
            @RequestParam(defaultValue = "APROBACION") String modo,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = ordenServicioService.pendientesConformidad(modo, proveedorId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @PostMapping("/{id}/asignar-oc")
    public ApiResponse<OrdenServicioDetalleResponse> asignarOc(
            @PathVariable Long id,
            @Valid @RequestBody AsignacionOsOcRequest request) {
        return ApiResponse.ok(ordenServicioService.asignarOc(id, request), "Asignación OS-OC realizada");
    }

    @GetMapping("/{id}/pdf")
    public ResponseEntity<byte[]> pdf(@PathVariable Long id) {
        byte[] pdfBytes = ordenServicioPdfService.generarPdf(id);
        return ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=OS-" + id + ".pdf")
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .contentLength(pdfBytes.length)
                .body(pdfBytes);
    }

    @GetMapping("/{id}/acta-conformidad/pdf")
    public ResponseEntity<byte[]> actaConformidadPdf(@PathVariable Long id) {
        byte[] pdfBytes = ordenServicioPdfService.generarActaConformidadPdf(id);
        return ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=ACTA-OS-" + id + ".pdf")
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .contentLength(pdfBytes.length)
                .body(pdfBytes);
    }
}
