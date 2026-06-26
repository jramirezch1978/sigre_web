package pe.restaurant.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.contabilidad.dto.request.PlanContableRequest;
import pe.restaurant.contabilidad.dto.response.PlanContableResponse;

public interface PlanContableService {

    Page<PlanContableResponse> listar(String codigo, Integer anio, String flagEstado, Pageable pageable);

    PlanContableResponse obtenerPorId(Long id);

    PlanContableResponse crear(PlanContableRequest request);

    PlanContableResponse actualizar(Long id, PlanContableRequest request);

    PlanContableResponse cambiarEstado(Long id);
}
