package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.PuntoVentaRequest;
import com.sigre.comercializacion.dto.response.PuntoVentaResponse;
import com.sigre.comercializacion.entity.PuntoVenta;

import java.util.List;

public interface PuntoVentaService {

    Page<PuntoVenta> findAll(Pageable pageable);

    // Método con filtros según contrato
    Page<PuntoVenta> findAllWithFilters(Long sucursalId, String codigo, String nombre, String flagEstado, Pageable pageable);

    PuntoVenta findById(Long id);

    PuntoVenta create(PuntoVenta entity);

    PuntoVenta update(Long id, PuntoVenta entity);

    void delete(Long id);

    PuntoVenta activate(Long id);

    PuntoVenta deactivate(Long id);

    List<PuntoVenta> findBySucursalId(Long sucursalId);
}
