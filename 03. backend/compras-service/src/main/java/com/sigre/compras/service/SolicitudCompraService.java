package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.ConvertirSolicitudRequest;
import com.sigre.compras.dto.ConvertirSolicitudResponse;
import com.sigre.compras.dto.SolicitudCompraDetalleResponse;
import com.sigre.compras.dto.SolicitudCompraRequest;
import com.sigre.compras.dto.SolicitudCompraResponse;
import com.sigre.compras.dto.TrazabilidadDocumentoResponse;

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
