package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.compras.dto.ConformidadServicioDetalleResponse;
import pe.restaurant.compras.dto.ConformidadServicioRequest;
import pe.restaurant.compras.dto.ConformidadServicioResponse;
import pe.restaurant.compras.dto.OrdenServicioPendienteConformidadResponse;
import pe.restaurant.compras.dto.PageData;
import pe.restaurant.compras.service.ConformidadServicioService;
import pe.restaurant.common.dto.ApiResponse;

@RestController
@RequestMapping("/api/compras/actas-conformidad")
@RequiredArgsConstructor
public class ConformidadServicioController {

    private final ConformidadServicioService conformidadServicioService;

    @GetMapping
    public ApiResponse<PageData<ConformidadServicioResponse>> listar(
            @RequestParam(required = false) Long ordenServicioId,
            @RequestParam(required = false) Boolean aprobado,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaDesde,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaHasta,
            Pageable pageable) {
        var page = conformidadServicioService.listar(ordenServicioId, aprobado, flagEstado, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/pendientes")
    public ApiResponse<PageData<OrdenServicioPendienteConformidadResponse>> pendientes(
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaDesde,
            @RequestParam(required = false) @org.springframework.format.annotation.DateTimeFormat(iso = org.springframework.format.annotation.DateTimeFormat.ISO.DATE) java.time.LocalDate fechaHasta,
            org.springframework.data.domain.Pageable pageable) {
        var page = conformidadServicioService.pendientes(proveedorId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<ConformidadServicioDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(conformidadServicioService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ConformidadServicioDetalleResponse> crear(
            @Valid @RequestBody ConformidadServicioRequest request) {
        return ApiResponse.ok(conformidadServicioService.crear(request), "Conformidad de servicio creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<ConformidadServicioDetalleResponse> actualizar(
            @PathVariable Long id,
            @Valid @RequestBody ConformidadServicioRequest request) {
        return ApiResponse.ok(conformidadServicioService.actualizar(id, request), "Conformidad de servicio actualizada");
    }

    @PostMapping("/{id}/aprobar")
    public ApiResponse<ConformidadServicioDetalleResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(conformidadServicioService.aprobar(id), "Conformidad aprobada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<ConformidadServicioDetalleResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(conformidadServicioService.anular(id), "Conformidad anulada");
    }

    @GetMapping("/{id}/pdf")
    public org.springframework.http.ResponseEntity<byte[]> pdf(@PathVariable Long id) {
        byte[] content = conformidadServicioService.generarPdf(id);
        return org.springframework.http.ResponseEntity.ok()
                .header(org.springframework.http.HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=ACTA-" + id + ".pdf")
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .contentLength(content.length)
                .body(content);
    }
}
