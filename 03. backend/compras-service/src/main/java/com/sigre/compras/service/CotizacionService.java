package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.dto.ComparativoCotizacionesResponse;
import com.sigre.compras.dto.ConvertirOcRequest;
import com.sigre.compras.dto.CotizacionDetalleResponse;
import com.sigre.compras.dto.CotizacionRequest;
import com.sigre.compras.dto.CotizacionResponse;
import com.sigre.compras.dto.OrdenCompraDetalleResponse;

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
