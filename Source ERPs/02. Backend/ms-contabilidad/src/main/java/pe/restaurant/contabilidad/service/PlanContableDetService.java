package pe.restaurant.contabilidad.service;

import pe.restaurant.contabilidad.dto.request.PlanContableDetRequest;
import pe.restaurant.contabilidad.entity.PlanContableDet;

import java.util.List;

public interface PlanContableDetService {

    List<PlanContableDet> findAllActivos(Long planContableId, String q, String flagEstado);

    PlanContableDet findById(Long id);

    PlanContableDet create(PlanContableDetRequest request);

    PlanContableDet update(Long id, PlanContableDetRequest request);

    void delete(Long id);

    PlanContableDet activate(Long id);

    PlanContableDet deactivate(Long id);
}
