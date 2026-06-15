package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.PedidoMesaRequest;
import com.sigre.comercializacion.dto.response.PedidoMesaResponse;
import com.sigre.comercializacion.entity.PedidoMesa;

public interface PedidoMesaService {

    Page<PedidoMesa> findAll(Long sucursalId, Long mesaId, Long meseroId, Long turnoId, String flagEstado, Pageable pageable);

    PedidoMesaResponse getById(Long id);

    PedidoMesaResponse create(PedidoMesaRequest request);

    PedidoMesaResponse update(Long id, PedidoMesaRequest request);

    PedidoMesaResponse cerrar(Long id);

    PedidoMesaResponse anular(Long id);

    PedidoMesaResponse activate(Long id);

    PedidoMesaResponse deactivate(Long id);

    void delete(Long id);
}
