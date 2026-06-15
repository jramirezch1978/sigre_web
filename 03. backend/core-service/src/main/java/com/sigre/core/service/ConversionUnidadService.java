package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.ConversionUnidadRequest;
import com.sigre.core.dto.ConversionUnidadResponse;
import com.sigre.core.entity.ConversionUnidad;

public interface ConversionUnidadService {
    Page<ConversionUnidad> list(Long articuloId, Long umOrigenId, Long umDestinoId, Pageable pageable);
    ConversionUnidadResponse getById(Long id);
    ConversionUnidadResponse create(ConversionUnidadRequest request);
    ConversionUnidadResponse update(Long id, ConversionUnidadRequest request);
    void delete(Long id);
    ConversionUnidad activate(Long id);
    ConversionUnidad deactivate(Long id);
}
