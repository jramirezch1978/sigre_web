package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.CtsProcesarRequest;
import pe.restaurant.rrhh.dto.response.CtsResponse;
import java.util.List;

public interface CtsService {
    List<CtsResponse> procesar(CtsProcesarRequest request);
    Page<CtsResponse> listar(Long trabajadorId, Integer anio, Long periodoCtsId, Pageable pageable);
    CtsResponse obtenerPorId(Long id);
}
