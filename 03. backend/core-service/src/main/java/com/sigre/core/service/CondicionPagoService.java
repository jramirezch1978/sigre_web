package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.CondicionPagoRequest;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.entity.CondicionPago;

public interface CondicionPagoService {
    Page<CondicionPago> list(Pageable pageable);
    CondicionPagoResponse getById(Long id);
    CondicionPagoResponse create(CondicionPagoRequest request);
    CondicionPagoResponse update(Long id, CondicionPagoRequest request);
    void delete(Long id);
    CondicionPago activate(Long id);
    CondicionPago deactivate(Long id);
}
