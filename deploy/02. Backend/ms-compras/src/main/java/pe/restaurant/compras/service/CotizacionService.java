package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.ComparativoCotizacionesResponse;
import pe.restaurant.compras.dto.ConvertirOcRequest;
import pe.restaurant.compras.dto.CotizacionDetalleResponse;
import pe.restaurant.compras.dto.CotizacionRequest;
import pe.restaurant.compras.dto.CotizacionResponse;
import pe.restaurant.compras.dto.OrdenCompraDetalleResponse;

import java.time.LocalDate;
import java.util.List;

public interface CotizacionService {

    Page<CotizacionResponse> listar(Long proveedorId, String flagEstado,
                                     java.time.LocalDate fechaDesde, java.time.LocalDate fechaHasta,
                                     Pageable pageable);

    CotizacionDetalleResponse obtener(Long id);

    CotizacionDetalleResponse crear(CotizacionRequest request);

    CotizacionDetalleResponse actualizar(Long id, CotizacionRequest request);

    CotizacionDetalleResponse seleccionar(Long id);

    CotizacionDetalleResponse descartar(Long id);

    CotizacionDetalleResponse anular(Long id, String motivo);

    ComparativoCotizacionesResponse comparativo(List<Long> proveedorIds, LocalDate fechaDesde, LocalDate fechaHasta);

    OrdenCompraDetalleResponse convertirOc(Long id, ConvertirOcRequest request);
}
