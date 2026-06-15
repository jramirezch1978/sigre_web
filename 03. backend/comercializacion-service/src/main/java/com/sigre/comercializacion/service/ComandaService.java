package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ComandaCabeceraRequest;
import com.sigre.comercializacion.dto.request.ComandaEstadoRequest;
import com.sigre.comercializacion.dto.request.ComandaItemsAppendRequest;
import com.sigre.comercializacion.dto.response.ComandaResponse;
import com.sigre.comercializacion.entity.Comanda;

import java.time.Instant;

public interface ComandaService {

    Page<Comanda> findAll(Long sucursalId, Long puntoVentaId, String mesa, String flagEstado,
                          Instant fechaDesde, Instant fechaHasta, Pageable pageable);

    ComandaResponse getById(Long id);

    ComandaResponse create(ComandaCabeceraRequest request);

    ComandaResponse update(Long id, ComandaCabeceraRequest request);

    ComandaResponse addItems(Long id, ComandaItemsAppendRequest request);

    ComandaResponse patchEstado(Long id, ComandaEstadoRequest request);

    ComandaResponse anular(Long id);

    ComandaResponse activate(Long id);

    ComandaResponse deactivate(Long id);

    void delete(Long id);
}
