package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.GuiaRequest;
import pe.restaurant.almacen.dto.GuiaResponse;

import java.time.LocalDate;

public interface GuiaRemisionService {

    Page<GuiaResponse> buscar(Long sucursalId,
                              String estado,
                              String serie,
                              String numero,
                              LocalDate fechaDesde,
                              LocalDate fechaHasta,
                              Long destinatarioId,
                              Pageable pageable);

    GuiaResponse obtener(Long id);

    GuiaResponse crear(GuiaRequest request);

    GuiaResponse actualizar(Long id, GuiaRequest request);

    GuiaResponse anular(Long id);

    GuiaResponse ponerEnTransito(Long id);

    GuiaResponse marcarEntregada(Long id);
}
