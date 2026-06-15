package com.sigre.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.contabilidad.dto.request.PlanContableDetRequest;
import com.sigre.contabilidad.entity.PlanContableDet;

public interface PlanContableDetService {

    Page<PlanContableDet> findAll(Long planContableId, String q, String flagEstado, Pageable pageable);

    PlanContableDet findById(Long id);

    PlanContableDet create(PlanContableDetRequest request);

    PlanContableDet update(Long id, PlanContableDetRequest request);

    void delete(Long id);

    PlanContableDet activate(Long id);

    PlanContableDet deactivate(Long id);
}
