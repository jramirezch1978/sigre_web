package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ComandaCabeceraRequest;
import pe.restaurant.ventas.dto.request.ComandaEstadoRequest;
import pe.restaurant.ventas.dto.request.ComandaItemsAppendRequest;
import pe.restaurant.ventas.dto.response.ComandaResponse;
import pe.restaurant.ventas.entity.Comanda;

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
