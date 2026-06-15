package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.DespachoOvRequest;
import com.sigre.comercializacion.dto.request.OrdenVentaRequest;
import com.sigre.comercializacion.dto.response.DespachoOvResponse;
import com.sigre.comercializacion.entity.OrdenVenta;

public interface OrdenVentaService {

    Page<OrdenVenta> findAll(Long sucursalId, Long clienteId, String nro, Pageable pageable);

    OrdenVenta findById(Long id);

    OrdenVenta create(OrdenVentaRequest request);

    OrdenVenta update(Long id, OrdenVentaRequest request);

    OrdenVenta confirmar(Long id);

    OrdenVenta anular(Long id);

    OrdenVenta cerrar(Long id);

    DespachoOvResponse despacharEnAlmacen(Long id, DespachoOvRequest request);
}
