package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public interface OrdenCompraService {

    Page<OrdenCompraResumenResponse> listar(Long sucursalId,
                                            Long proveedorId,
                                            String flagEstado,
                                            LocalDate fechaDesde,
                                            LocalDate fechaHasta,
                                            String numero,
                                            Long monedaId,
                                            Pageable pageable);

    Page<OrdenCompraResumenResponse> pendientesAprobacion(Pageable pageable);

    OrdenCompraDetalleResponse obtener(Long id);

    OrdenCompraDetalleResponse crear(OrdenCompraCabeceraRequest request);

    OrdenCompraDetalleResponse actualizar(Long id, OrdenCompraCabeceraRequest request);

    OrdenCompraDetalleResponse enviarAprobacion(Long id);

    OrdenCompraDetalleResponse aprobar(Long id, String observacion);

    OrdenCompraDetalleResponse rechazar(Long id, String motivo);

    OrdenCompraDetalleResponse devolver(Long id, String motivo);

    OrdenCompraDetalleResponse anular(Long id, String motivo);

    OrdenCompraDetalleResponse cerrar(Long id);

    List<HistorialAprobacionResponse> historial(Long id);

    List<RecepcionResumenResponse> recepciones(Long id);

    OrdenCompraSaldoPendienteResponse saldoPendiente(Long id);

    OrdenCompraRecepcionResponse recepcionarEnAlmacen(Long id, OrdenCompraRecepcionRequest request);

    OrdenCompraRecepcionResponse recepcionarEnAlmacenContable(Long id, OrdenCompraRecepcionContableRequest request);

    DatosArticuloResponse datosArticulo(Long articuloId, Long proveedorId,
                                         Long monedaId, Long sucursalId,
                                         LocalDate fechaEmision);

    OrdenCompraDetalleResponse modificarIgv(Long id, ModificarIgvRequest request);

    boolean enviarProveedor(Long id, EnviarProveedorRequest request);

    void actualizarCantFacturada(ActualizarCantFacturadaRequest request);

    OrdenCompraDetalleResponse ajustarCantidadLinea(Long id, Long lineaId, BigDecimal nuevaCantidad);

    void ajustarStockPorNota(AjusteStockRequest request);
}
