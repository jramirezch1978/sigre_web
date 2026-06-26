package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.AprobacionEnBloqueRequest;
import pe.restaurant.finanzas.dto.request.AprobarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.DevolucionTotalRequest;
import pe.restaurant.finanzas.dto.request.RechazoDevolucionTotalRequest;
import pe.restaurant.finanzas.dto.request.RechazarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.SolicitudGiroRequest;
import pe.restaurant.finanzas.dto.response.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface SolicitudGiroService {

    Page<SolicitudGiroResponse> listarSolicitudes(
        LocalDate fechaDesde,
        LocalDate fechaHasta,
        String estado,
        Pageable pageable
    );

    SolicitudGiroDetalleResponse obtenerPorId(Long id);

    SolicitudGiroDetalleResponse crearSolicitud(SolicitudGiroRequest request);

    SolicitudGiroDetalleResponse actualizarSolicitud(Long id, SolicitudGiroRequest request);

    Map<String, Object> anularSolicitud(Long id);

    // FI308 - Aprobación de solicitudes
    Page<SolicitudPendienteAprobacionResponse> listarPendientesAprobacion(Pageable pageable);

    SolicitudGiroDetalleResponse aprobarSolicitud(Long id, AprobarSolicitudRequest request);

    List<BatchResultItem> aprobarEnBloque(AprobacionEnBloqueRequest request);

    Map<String, Object> rechazarSolicitud(Long id, RechazarSolicitudRequest request);

    // FI333 - Devolución Total (Escenario 1)
    SolicitudGiroDetalleResponse registrarDevolucionTotal(Long id, DevolucionTotalRequest request);

    SolicitudGiroDetalleResponse aprobarDevolucionTotal(Long id);

    SolicitudGiroDetalleResponse rechazarDevolucionTotal(Long id, RechazoDevolucionTotalRequest request);
}
