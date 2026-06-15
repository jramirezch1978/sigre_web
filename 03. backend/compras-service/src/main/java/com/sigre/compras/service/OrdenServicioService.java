package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.*;
import com.sigre.compras.dto.CuentaPagarVinculadaResponse;

import java.time.LocalDate;
import java.util.List;

public interface OrdenServicioService {

    Page<OrdenServicioResumenResponse> listar(Long sucursalId, Long proveedorId,
                                               String flagEstado,
                                               String codOrigen, String numero,
                                               LocalDate fechaDesde, LocalDate fechaHasta,
                                               Long monedaId, Long compradorId,
                                               String flagReqServ, Long ordenTrabajoId,
                                               String jobCodigo, Pageable pageable);

    Page<OrdenServicioResumenResponse> pendientesAprobacion(Pageable pageable);

    OrdenServicioDetalleResponse obtener(Long id);

    OrdenServicioDetalleResponse crear(OrdenServicioCabeceraRequest request);

    OrdenServicioDetalleResponse actualizar(Long id, OrdenServicioCabeceraRequest request);

    OrdenServicioDetalleResponse enviarAprobacion(Long id);

    OrdenServicioDetalleResponse aprobar(Long id, String observacion);

    OrdenServicioDetalleResponse rechazar(Long id, String motivo);

    OrdenServicioDetalleResponse devolver(Long id, String motivo);

    OrdenServicioDetalleResponse anular(Long id, String motivo);

    OrdenServicioDetalleResponse cerrar(Long id);

    OrdenServicioDetalleResponse registrarConformidad(Long id, Long lineaId,
                                                       ConformidadOsRequest request);

    OrdenServicioDetalleResponse revertirConformidad(Long id, Long lineaId,
                                                      ConformidadOsRequest request);

    OrdenServicioDetalleResponse ajustarValor(Long id, AjusteValorOsRequest request);

    List<HistorialAprobacionResponse> historial(Long id);

    OrdenServicioSaldoPendienteResponse saldoPendiente(Long id);

    DatosServicioResponse datosServicio(Long servicioId, Long proveedorId,
                                         Long monedaId, Long sucursalId);

    boolean enviarProveedor(Long id, EnviarProveedorOsRequest request);

    Page<LineaConformidadResponse> pendientesConformidad(String modo, Long proveedorId,
                                                          LocalDate fechaDesde, LocalDate fechaHasta,
                                                          Pageable pageable);

    OrdenServicioDetalleResponse asignarOc(Long id, AsignacionOsOcRequest request);

    List<AsignacionOsOcRequest.LineaAsignacion> obtenerAsignaciones(Long id);

    List<CuentaPagarVinculadaResponse> cuentasPagar(Long id);

    List<ServicioDisponibleResponse> serviciosDisponibles(Long proveedorId, Long monedaId,
                                                          LocalDate fechaRegistro, String codSubCat);
}
