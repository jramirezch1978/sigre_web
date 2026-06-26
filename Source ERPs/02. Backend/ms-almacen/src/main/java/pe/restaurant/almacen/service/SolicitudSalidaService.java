package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.dto.SolSalidaRequest;
import pe.restaurant.almacen.dto.SolSalidaResponse;

public interface SolicitudSalidaService {

    Page<SolSalidaResponse> buscar(Long almacenId, String estado, Pageable pageable);

    SolSalidaResponse obtener(Long id);

    SolSalidaResponse crear(SolSalidaRequest request);

    SolSalidaResponse actualizar(Long id, SolSalidaRequest request);

    void eliminar(Long id);

    SolSalidaResponse cambiarEstado(Long id, String nuevoEstado);
}
