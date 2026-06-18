package pe.restaurant.compras.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.compras.dto.RegistroComprasReporteRequest;
import pe.restaurant.compras.service.ReporteComprasService;
import pe.restaurant.compras.service.ReporteRegistroComprasService;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Reportes del módulo Compras.
 *
 * Agrupa:
 *  - Registro de compras (PDF y consulta) de tesorería/contabilidad.
 *  - Reportes operativos consumidos por el front (gestión, tránsito, sugeridas,
 *    por categoría, análisis de proveedores, etc.).
 *
 * Todas las rutas cuelgan de /api/compras/reportes. El front desenvuelve
 * {@code ApiResponse.data} como array plano, por lo que cada endpoint operativo
 * devuelve {@code List<Map<String,Object>>} con los nombres de campo exactos
 * esperados (ver docs front: pendientes-backend-compras.md).
 */
@RestController
@RequestMapping("/api/compras/reportes")
@RequiredArgsConstructor
public class ReportesController {

    private final ReporteRegistroComprasService reporteRegistroComprasService;
    private final ReporteComprasService service;

    @PostMapping("/registro-compras-pdf")
    public ResponseEntity<byte[]> generarRegistroCompras(
            @Valid @RequestBody RegistroComprasReporteRequest request) {

        byte[] pdf = reporteRegistroComprasService.generarPdf(
                request.getAnio(), request.getMes(), request.getOrigen());

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=registro_compras_"
                                + request.getAnio() + "_"
                                + String.format("%02d", request.getMes()) + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .contentLength(pdf.length)
                .body(pdf);
    }

    @PostMapping("/registro-compras/listar")
    public ApiResponse<List<Map<String, Object>>> listarRegistroCompras(
            @Valid @RequestBody RegistroComprasReporteRequest request) {

        List<Map<String, Object>> data = reporteRegistroComprasService.ejecutarConsulta(
                request.getAnio(), request.getMes(), request.getOrigen()
        );
        return ApiResponse.ok(data);
    }

    @GetMapping("/gestion-compras")
    public ApiResponse<List<Map<String, Object>>> gestionCompras(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        return ApiResponse.ok(service.gestionCompras(sucursalId, fechaDesde, fechaHasta));
    }

    @GetMapping("/compras-transito")
    public ApiResponse<List<Map<String, Object>>> comprasTransito(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.comprasTransito(sucursalId));
    }

    @GetMapping("/compras-por-ingresar")
    public ApiResponse<List<Map<String, Object>>> comprasPorIngresar(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.comprasPorIngresar(sucursalId));
    }

    @GetMapping("/compras-sugeridas")
    public ApiResponse<List<Map<String, Object>>> comprasSugeridas(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.comprasSugeridas(sucursalId));
    }

    @GetMapping("/compras-categoria")
    public ApiResponse<List<Map<String, Object>>> comprasCategoria(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.comprasCategoria(sucursalId));
    }

    @GetMapping("/analisis-proveedores")
    public ApiResponse<List<Map<String, Object>>> analisisProveedores(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.analisisProveedores(sucursalId));
    }

    @GetMapping("/compras")
    public ApiResponse<List<Map<String, Object>>> comprasProcesadas(
            @RequestParam(required = false) Long sucursalId) {
        return ApiResponse.ok(service.comprasProcesadas(sucursalId));
    }
}
