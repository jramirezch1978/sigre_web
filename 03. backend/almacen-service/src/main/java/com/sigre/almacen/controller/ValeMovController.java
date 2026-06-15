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
import org.springframework.web.multipart.MultipartFile;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.service.ValeMovService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;

@RestController
@RequestMapping("/api/almacen/movimientos")
@RequiredArgsConstructor
public class ValeMovController {

    private final ValeMovService valeMovService;

    @GetMapping
    public ApiResponse<PageData<MovimientoListItemResponse>> listar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloMovTipoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            @RequestParam(required = false) Long ordenCompraId,
            @RequestParam(required = false) Long ordenVentaId,
            @RequestParam(required = false) String tipoReferenciaOrigen,
            Pageable pageable) {
        var page = valeMovService.listar(sucursalId, almacenId, articuloMovTipoId, estado,
                fechaDesde, fechaHasta, ordenCompraId, ordenVentaId, tipoReferenciaOrigen, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    @GetMapping("/{id}")
    public ApiResponse<MovimientoDetalleResponse> obtener(@PathVariable Long id) {
        return ApiResponse.ok(valeMovService.obtener(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MovimientoDetalleResponse> crear(@Valid @RequestBody MovimientoCabeceraRequest request) {
        return ApiResponse.ok(valeMovService.crear(request), "Movimiento registrado");
    }

    @PutMapping("/{id}")
    public ApiResponse<MovimientoDetalleResponse> actualizar(@PathVariable Long id,
                                                             @Valid @RequestBody MovimientoCabeceraRequest request) {
        return ApiResponse.ok(valeMovService.actualizar(id, request), "Movimiento actualizado");
    }

    @PostMapping("/confirmar")
    public ApiResponse<MovimientoDetalleResponse> confirmar(@Valid @RequestBody MovimientoConfirmarRequest request) {
        return ApiResponse.ok(valeMovService.confirmar(request), "Movimiento procesado");
    }

    @PostMapping("/anular")
    public ApiResponse<MovimientoDetalleResponse> anular(@Valid @RequestBody MovimientoAnularRequest request) {
        return ApiResponse.ok(valeMovService.anular(request), "Movimiento anulado");
    }

    // ── Devoluciones (HU §12) ──────────────────────────────────────────────

    @GetMapping("/devolvible/{id}")
    public ApiResponse<DevolvibleResponse> devolvible(@PathVariable Long id) {
        return ApiResponse.ok(valeMovService.obtenerDevolvible(id));
    }

    @PostMapping("/devolucion")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<MovimientoDetalleResponse> devolucion(@Valid @RequestBody DevolucionRequest request) {
        return ApiResponse.ok(valeMovService.crearDevolucion(request), "Devolución registrada");
    }

    // ── Excel Export (HU §18.8) ────────────────────────────────────────────

    private ResponseEntity<byte[]> buildExcelExportResponse(byte[] bytes) {
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=movimientos.xlsx")
                .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                .body(bytes);
    }

    @GetMapping("/exportar")
    public ResponseEntity<byte[]> exportarExcel(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloMovTipoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        byte[] bytes = valeMovService.exportarExcel(sucursalId, almacenId, articuloMovTipoId,
                estado, fechaDesde, fechaHasta);
        return buildExcelExportResponse(bytes);
    }

    /** Misma lógica que {@link #exportarExcel}; el contrato API expone exportación como {@code POST}. */
    @PostMapping("/exportar")
    public ResponseEntity<byte[]> exportarExcelPost(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloMovTipoId,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        return exportarExcel(sucursalId, almacenId, articuloMovTipoId, estado, fechaDesde, fechaHasta);
    }

    // ── Excel Import (HU §18.7) ──────────────────────────────────────────

    @PostMapping(value = "/importar", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<ImportResultResponse> importarExcel(
            @RequestParam("file") MultipartFile file,
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(valeMovService.importarExcel(file, sucursalId), "Importación completada");
    }

    // ── PDF (HU §18.9) ────────────────────────────────────────────────────

    private ResponseEntity<byte[]> buildPdfResponse(Long id) {
        byte[] bytes = valeMovService.generarPdf(id);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=vale_" + id + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(bytes);
    }

    @GetMapping("/pdf/{id}")
    public ResponseEntity<byte[]> pdf(@PathVariable Long id) {
        return buildPdfResponse(id);
    }

    /** Misma respuesta que {@link #pdf}; el contrato API expone la generación como {@code POST}. */
    @PostMapping("/{id}/pdf")
    public ResponseEntity<byte[]> pdfPost(@PathVariable Long id) {
        return buildPdfResponse(id);
    }
}
