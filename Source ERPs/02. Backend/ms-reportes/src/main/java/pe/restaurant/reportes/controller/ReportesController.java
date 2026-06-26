package pe.restaurant.reportes.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.reportes.dto.request.RegistroComprasReporteRequest;
import pe.restaurant.reportes.dto.request.RegistroVentasReporteRequest;
import pe.restaurant.reportes.service.impl.ReporteRegistroComprasService;
import pe.restaurant.reportes.service.impl.ReporteRegistroVentasService;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reportes")
@RequiredArgsConstructor
public class ReportesController {

    private final ReporteRegistroComprasService reporteRegistroComprasService;
    private final ReporteRegistroVentasService reporteRegistroVentasService;

    @PostMapping("/registro-compras-pdf")
    public ResponseEntity<byte[]> generarRegistroComprasPdf(
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
                request.getAnio(), request.getMes(), request.getOrigen());
        return ApiResponse.ok(data);
    }

    @PostMapping("/registro-ventas-pdf")
    public ResponseEntity<byte[]> generarRegistroVentasPdf(
            @Valid @RequestBody RegistroVentasReporteRequest request) {
        byte[] pdf = reporteRegistroVentasService.generarPdf(
                request.getAnio(), request.getMes(), request.getOrigen());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=registro_ventas_"
                                + request.getAnio() + "_"
                                + String.format("%02d", request.getMes()) + ".pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .contentLength(pdf.length)
                .body(pdf);
    }

    @PostMapping("/registro-ventas/listar")
    public ApiResponse<List<Map<String, Object>>> listarRegistroVentas(
            @Valid @RequestBody RegistroVentasReporteRequest request) {
        List<Map<String, Object>> data = reporteRegistroVentasService.ejecutarConsulta(
                request.getAnio(), request.getMes(), request.getOrigen());
        return ApiResponse.ok(data);
    }
}
