package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.ConversionUnidadRequest;
import com.sigre.core.dto.ConversionUnidadResponse;

public interface ConversionUnidadService {
    Page<ConversionUnidadResponse> list(Long umOrigenId, Long umDestinoId, Pageable pageable);
    ConversionUnidadResponse getById(Long id);
    ConversionUnidadResponse create(ConversionUnidadRequest request);
    ConversionUnidadResponse update(Long id, ConversionUnidadRequest request);
    void delete(Long id);
    ConversionUnidadResponse activate(Long id);
    ConversionUnidadResponse deactivate(Long id);
}
