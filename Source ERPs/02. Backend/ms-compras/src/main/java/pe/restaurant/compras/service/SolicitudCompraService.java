package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.ConvertirSolicitudRequest;
import pe.restaurant.compras.dto.ConvertirSolicitudResponse;
import pe.restaurant.compras.dto.SolicitudCompraDetalleResponse;
import pe.restaurant.compras.dto.SolicitudCompraRequest;
import pe.restaurant.compras.dto.SolicitudCompraResponse;
import pe.restaurant.compras.dto.TrazabilidadDocumentoResponse;

import java.util.List;

public interface SolicitudCompraService {

    Page<SolicitudCompraResponse> listar(Long sucursalId, String flagEstado, String prioridad,
                                         java.time.LocalDate fechaDesde, java.time.LocalDate fechaHasta,
                                         Pageable pageable);

    SolicitudCompraDetalleResponse obtener(Long id);

    SolicitudCompraDetalleResponse crear(SolicitudCompraRequest request);

    SolicitudCompraDetalleResponse actualizar(Long id, SolicitudCompraRequest request);

    SolicitudCompraDetalleResponse enviar(Long id);

    SolicitudCompraDetalleResponse aprobar(Long id, String observacion);

    SolicitudCompraDetalleResponse rechazar(Long id, String motivo);

    SolicitudCompraDetalleResponse anular(Long id, String motivo);

    ConvertirSolicitudResponse convertir(Long id, ConvertirSolicitudRequest request);

    List<TrazabilidadDocumentoResponse> trazabilidad(Long id);
}
