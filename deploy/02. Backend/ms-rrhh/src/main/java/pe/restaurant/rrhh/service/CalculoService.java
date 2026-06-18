package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.response.CalculoDetalleResponse;
import pe.restaurant.rrhh.dto.response.CalculoResponse;

public interface CalculoService {

    Page<CalculoResponse> listar(Integer anio, Integer mes, Long tipoPlanillaId, Pageable pageable);

    CalculoDetalleResponse obtenerDetalle(Long id);

    CalculoDetalleResponse procesar(Integer anio, Integer mes, Long tipoPlanillaId);

    void eliminar(Long id);

}
