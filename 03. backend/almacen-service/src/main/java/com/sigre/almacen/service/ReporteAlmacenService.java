package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.dto.ComparacionInventarioResponse;
import com.sigre.almacen.dto.DiagnosticoAlmacenResponse;
import com.sigre.almacen.dto.KardexResponse;
import com.sigre.almacen.dto.LoteVencimientoResponse;
import com.sigre.almacen.dto.PerdidaResponse;
import com.sigre.almacen.dto.StockAFechaResponse;
import com.sigre.almacen.dto.ValorizacionResponse;

import java.time.LocalDate;
import java.util.List;

/**
 * Consultas de solo lectura derivadas del inventario existente:
 * kardex valorizado, valorización, lotes por vencer, stock a fecha,
 * diagnóstico por almacén y comparación de inventario.
 */
public interface ReporteAlmacenService {

    Page<KardexResponse> kardex(Long almacenId, Long articuloId,
                                LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);

    Page<ValorizacionResponse> valorizacion(Long almacenId, Long articuloId, Pageable pageable);

    Page<LoteVencimientoResponse> lotesPorVencer(Long almacenId, Long articuloId, int dias, Pageable pageable);

    Page<StockAFechaResponse> stockAFecha(Long almacenId, Long articuloId, LocalDate fecha, Pageable pageable);

    List<DiagnosticoAlmacenResponse> diagnostico(Long almacenId);

    Page<ComparacionInventarioResponse> comparacionInventario(Long almacenId, Long articuloId,
                                                              LocalDate fechaDesde, LocalDate fechaHasta,
                                                              Pageable pageable);

    Page<PerdidaResponse> perdidas(Long almacenId, Long articuloId,
                                   LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);
}
