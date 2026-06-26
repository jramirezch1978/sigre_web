package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.ComparacionInventarioResponse;
import pe.restaurant.almacen.dto.DiagnosticoAlmacenResponse;
import pe.restaurant.almacen.dto.KardexResponse;
import pe.restaurant.almacen.dto.LoteVencimientoResponse;
import pe.restaurant.almacen.dto.PerdidaResponse;
import pe.restaurant.almacen.dto.StockAFechaResponse;
import pe.restaurant.almacen.dto.ValorizacionResponse;

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
