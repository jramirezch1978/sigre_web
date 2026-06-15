package com.sigre.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.contabilidad.dto.request.CentrosCostoRequest;
import com.sigre.contabilidad.entity.CentrosCosto;

public interface CentrosCostoService {

    Page<CentrosCosto> findAll(String q, String flagEstado, Pageable pageable);

    CentrosCosto findById(Long id);

    CentrosCosto create(CentrosCostoRequest request);

    CentrosCosto update(Long id, CentrosCostoRequest request);

    void delete(Long id);
}
