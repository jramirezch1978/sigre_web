package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.PedidoMesaRequest;
import pe.restaurant.ventas.dto.response.PedidoMesaResponse;
import pe.restaurant.ventas.entity.PedidoMesa;

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
