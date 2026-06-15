package com.sigre.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.contabilidad.dto.request.CntblTipoDetraccionRequest;
import com.sigre.contabilidad.entity.CntblTipoDetraccion;

public interface CntblTipoDetraccionService {

    Page<CntblTipoDetraccion> findAll(String q, String flagEstado, Pageable pageable);

    CntblTipoDetraccion findById(Long id);

    CntblTipoDetraccion create(CntblTipoDetraccionRequest request);

    CntblTipoDetraccion update(Long id, CntblTipoDetraccionRequest request);

    void delete(Long id);
}
