package pe.restaurant.activos.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.activos.dto.reporte.AfReporteDepreciacionAnualResponse;
import pe.restaurant.activos.dto.reporte.AfReporteLibroResponse;
import pe.restaurant.activos.service.AfReporteExportService;
import pe.restaurant.activos.service.AfReporteService;
import pe.restaurant.common.dto.ApiResponse;

import java.math.BigDecimal;
import java.time.LocalDate;

@RestController
@RequestMapping("/api/activos/reportes")
@RequiredArgsConstructor
public class AfReporteController {

    private final AfReporteService reporteService;
    private final AfReporteExportService reporteExportService;

    @GetMapping("/libro-activos")
    public ApiResponse<AfReporteLibroResponse> libroActivos(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaCorte,
            @RequestParam(required = false) Long afSubClaseId,
            @RequestParam(required = false) Long afUbicacionId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String estadoActivo,
            @RequestParam(required = false) BigDecimal valorMin,
            @RequestParam(required = false) BigDecimal valorMax) {
        return ApiResponse.ok(reporteService.libroActivos(
                fechaCorte, afSubClaseId, afUbicacionId, flagEstado, estadoActivo, valorMin, valorMax));
    }

    @GetMapping("/depreciacion-anual/{afMaestroId}/{anio}")
    public ApiResponse<AfReporteDepreciacionAnualResponse> depreciacionAnual(
            @PathVariable Long afMaestroId,
            @PathVariable Integer anio) {
        return ApiResponse.ok(reporteService.depreciacionAnual(afMaestroId, anio));
    }

    @GetMapping(value = "/libro-activos/export", produces = {
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "text/csv",
            "application/pdf"
    })
    public ResponseEntity<byte[]> exportarLibroActivos(
            @RequestParam(defaultValue = "xlsx") String formato,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaCorte,
            @RequestParam(required = false) Long afSubClaseId,
            @RequestParam(required = false) Long afUbicacionId,
            @RequestParam(required = false) String flagEstado,
            @RequestParam(required = false) String estadoActivo,
            @RequestParam(required = false) BigDecimal valorMin,
            @RequestParam(required = false) BigDecimal valorMax) {
        AfReporteLibroResponse data = reporteExportService.obtenerLibro(
                fechaCorte, afSubClaseId, afUbicacionId, flagEstado, estadoActivo, valorMin, valorMax);
        byte[] bytes = reporteExportService.exportarLibroActivos(data, formato);
        String fmt = formato.toLowerCase();
        MediaType mediaType = switch (fmt) {
            case "csv" -> MediaType.parseMediaType("text/csv");
            case "pdf" -> MediaType.APPLICATION_PDF;
            default -> MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        };
        String ext = "pdf".equals(fmt) ? "pdf" : ("csv".equals(fmt) ? "csv" : "xlsx");
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=libro-activos." + ext)
                .contentType(mediaType)
                .body(bytes);
    }

    @GetMapping("/consolidado")
    public ApiResponse<AfReporteLibroResponse> consolidado(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaCorte,
            @RequestParam(required = false) Long afClaseId) {
        return ApiResponse.ok(reporteService.consolidado(fechaCorte, afClaseId));
    }
}
