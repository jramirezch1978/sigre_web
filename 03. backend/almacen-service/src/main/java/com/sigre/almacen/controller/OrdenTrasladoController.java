package com.sigre.almacen.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.almacen.dto.OrdenTrasladoRequest;
import com.sigre.almacen.dto.OrdenTrasladoResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.service.OrdenTrasladoOperacionService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/almacen/ordenes-traslado")
@RequiredArgsConstructor
public class OrdenTrasladoController {

    private final OrdenTrasladoOperacionService service;

    @GetMapping
    public ApiResponse<PageData<OrdenTrasladoResponse>> buscar(
            @RequestParam(required = false) Long almacenOrigenId,
            @RequestParam(required = false) Long almacenDestinoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = service.buscar(almacenOrigenId, almacenDestinoId, estado, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/exportar")
    public ResponseEntity<byte[]> exportarExcelGet(
            @RequestParam(required = false) Long almacenOrigenId,
            @RequestParam(required = false) Long almacenDestinoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        return buildExcelResponse(service.exportarExcel(
                almacenOrigenId, almacenDestinoId, estado, fechaDesde, fechaHasta));
    }

    @PostMapping("/exportar")
    public ResponseEntity<byte[]> exportarExcelPost(
            @RequestParam(required = false) Long almacenOrigenId,
            @RequestParam(required = false) Long almacenDestinoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        return exportarExcelGet(almacenOrigenId, almacenDestinoId, estado, fechaDesde, fechaHasta);
    }

    @GetMapping("/{id}")
    public ApiResponse<OrdenTrasladoResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(service.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<OrdenTrasladoResponse> crear(@Valid @RequestBody OrdenTrasladoRequest request) {
        return ApiResponse.ok(service.crear(request), "Orden de traslado creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<OrdenTrasladoResponse> actualizar(
            @PathVariable Long id, @Valid @RequestBody OrdenTrasladoRequest request) {
        return ApiResponse.ok(service.actualizar(id, request), "Orden actualizada");
    }

    @PatchMapping("/{id}/estado")
    public ApiResponse<OrdenTrasladoResponse> cambiarEstado(
            @PathVariable Long id, @RequestParam String estado) {
        return ApiResponse.ok(service.cambiarEstado(id, estado), "Estado actualizado");
    }

    @PostMapping("/{id}/aprobar")
    public ApiResponse<OrdenTrasladoResponse> aprobar(@PathVariable Long id) {
        return ApiResponse.ok(service.aprobar(id), "Orden aprobada");
    }

    @PostMapping("/{id}/rechazar")
    public ApiResponse<OrdenTrasladoResponse> rechazar(@PathVariable Long id) {
        return ApiResponse.ok(service.rechazar(id), "Orden rechazada");
    }

    @PostMapping("/{id}/cerrar")
    public ApiResponse<OrdenTrasladoResponse> cerrar(@PathVariable Long id) {
        return ApiResponse.ok(service.cerrar(id), "Orden cerrada");
    }

    @PostMapping("/{id}/anular")
    public ApiResponse<OrdenTrasladoResponse> anular(@PathVariable Long id) {
        return ApiResponse.ok(service.anular(id), "Orden anulada");
    }

    @GetMapping("/{id}/pdf")
    public ResponseEntity<byte[]> pdfGet(@PathVariable Long id) {
        return buildPdfResponse(id);
    }

    @PostMapping("/{id}/pdf")
    public ResponseEntity<byte[]> pdfPost(@PathVariable Long id) {
        return buildPdfResponse(id);
    }

    private static ResponseEntity<byte[]> buildExcelResponse(byte[] bytes) {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=ordenes_traslado.xlsx")
                .contentType(MediaType.parseMediaType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(bytes);
    }

    private ResponseEntity<byte[]> buildPdfResponse(Long id) {
        byte[] bytes = service.generarPdf(id);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=orden_traslado_" + id + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(bytes);
    }
}
