package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.*;

import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.util.List;

public interface ValeMovService {

    Page<MovimientoListItemResponse> listar(Long sucursalId,
                                            Long almacenId,
                                            Long articuloMovTipoId,
                                            String estado,
                                            LocalDate fechaDesde,
                                            LocalDate fechaHasta,
                                            Long ordenCompraId,
                                            Long ordenVentaId,
                                            String tipoReferenciaOrigen,
                                            Pageable pageable);

    MovimientoDetalleResponse obtener(Long id);

    MovimientoDetalleResponse crear(MovimientoCabeceraRequest request);

    /**
     * Crea un movimiento de almacén e integra su contabilización por concepto financiero (Ruta B):
     * persiste {@code conceptoFinancieroId} por línea y genera el pre-asiento en ms-contabilidad
     * (que resuelve la matriz contable por concepto). La integración es síncrona: si contabilidad
     * falla, se revierte el movimiento. No usa el mecanismo legacy {@code tipo_mov_matriz_subcat}.
     */
    MovimientoDetalleResponse crearContable(MovimientoContableCabeceraRequest request);

    MovimientoDetalleResponse actualizar(Long id, MovimientoCabeceraRequest request);

    MovimientoDetalleResponse confirmar(MovimientoConfirmarRequest request);

    MovimientoDetalleResponse anular(MovimientoAnularRequest request);

    DevolvibleResponse obtenerDevolvible(Long valeMovId);

    MovimientoDetalleResponse crearDevolucion(DevolucionRequest request);

    byte[] exportarExcel(Long sucursalId, Long almacenId, Long articuloMovTipoId,
                         String estado, LocalDate fechaDesde, LocalDate fechaHasta);

    byte[] generarPdf(Long valeMovId);

    /**
     * @param sucursalId opcional; si es nulo se infiere desde el {@code almacenId} de la primera fila de datos del Excel.
     */
    ImportResultResponse importarExcel(MultipartFile file, Long sucursalId);
}
