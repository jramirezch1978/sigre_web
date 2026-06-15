package com.sigre.almacen.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.almacen.dto.ComparacionInventarioResponse;
import com.sigre.almacen.dto.DiagnosticoAlmacenResponse;
import com.sigre.almacen.dto.LoteVencimientoResponse;
import com.sigre.almacen.dto.PageData;
import com.sigre.almacen.dto.PerdidaResponse;
import com.sigre.almacen.dto.StockAFechaResponse;
import com.sigre.almacen.dto.ValorizacionResponse;
import com.sigre.almacen.service.ReporteAlmacenService;
import com.sigre.common.dto.ApiResponse;

import java.time.LocalDate;
import java.util.List;

/**
 * Reportes de almacén de solo lectura (sección 23.3 de la arquitectura):
 * valorización del stock y lotes próximos a vencer.
 */
@RestController
@RequestMapping("/api/almacen/reportes")
@RequiredArgsConstructor
public class ReporteAlmacenController {

    private final ReporteAlmacenService reporteAlmacenService;

    /** Valorización económica del stock (cantidad disponible × costo promedio). */
    @GetMapping("/valorizacion")
    public ApiResponse<PageData<ValorizacionResponse>> valorizacion(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            Pageable pageable) {
        var page = reporteAlmacenService.valorizacion(almacenId, articuloId, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    /** Lotes próximos a vencer (o vencidos) dentro de una ventana de días. */
    @GetMapping("/lotes-por-vencer")
    public ApiResponse<PageData<LoteVencimientoResponse>> lotesPorVencer(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(defaultValue = "30") int dias,
            Pageable pageable) {
        var page = reporteAlmacenService.lotesPorVencer(almacenId, articuloId, dias, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    /** Stock por artículo/almacén a una fecha de corte (default: hoy). */
    @GetMapping("/stock-a-fecha")
    public ApiResponse<PageData<StockAFechaResponse>> stockAFecha(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
            Pageable pageable) {
        var page = reporteAlmacenService.stockAFecha(almacenId, articuloId, fecha, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    /** Diagnóstico/resumen por almacén: nº de artículos, unidades y valorización. */
    @GetMapping("/diagnostico")
    public ApiResponse<List<DiagnosticoAlmacenResponse>> diagnostico(
            @RequestParam(required = false) Long almacenId) {
        return ApiResponse.ok(reporteAlmacenService.diagnostico(almacenId));
    }

    /** Comparación físico vs sistema (conteos de inventario). */
    @GetMapping("/comparacion-inventario")
    public ApiResponse<PageData<ComparacionInventarioResponse>> comparacionInventario(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = reporteAlmacenService.comparacionInventario(almacenId, articuloId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }

    /** Registro de pérdidas/mermas (consulta histórica): salidas de tipo merma/baja/pérdida. */
    @GetMapping("/perdidas")
    public ApiResponse<PageData<PerdidaResponse>> perdidas(
            @RequestParam(required = false) Long almacenId,
            @RequestParam(required = false) Long articuloId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta,
            Pageable pageable) {
        var page = reporteAlmacenService.perdidas(almacenId, articuloId, fechaDesde, fechaHasta, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent()));
    }
}
