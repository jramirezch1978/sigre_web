package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.dto.ConformidadServicioDetalleResponse;
import pe.restaurant.compras.dto.ConformidadServicioRequest;
import pe.restaurant.compras.dto.ConformidadServicioResponse;
import pe.restaurant.compras.dto.OrdenServicioPendienteConformidadResponse;

import java.time.LocalDate;

public interface ConformidadServicioService {

    Page<ConformidadServicioResponse> listar(Long ordenServicioId, Boolean aprobado,
                                              String flagEstado,
                                              LocalDate fechaDesde, LocalDate fechaHasta,
                                              Pageable pageable);

    ConformidadServicioDetalleResponse obtener(Long id);

    ConformidadServicioDetalleResponse crear(ConformidadServicioRequest request);

    ConformidadServicioDetalleResponse actualizar(Long id, ConformidadServicioRequest request);

    ConformidadServicioDetalleResponse aprobar(Long id);

    ConformidadServicioDetalleResponse anular(Long id);

    Page<OrdenServicioPendienteConformidadResponse> pendientes(Long proveedorId, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);

    byte[] generarPdf(Long id);
}
