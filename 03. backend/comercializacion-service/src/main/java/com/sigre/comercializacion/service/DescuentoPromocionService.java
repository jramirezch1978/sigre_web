package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.entity.DescuentoPromocion;

public interface DescuentoPromocionService {

    Page<DescuentoPromocion> findAll(String nombre, String tipo, String flagEstado, Pageable pageable);

    DescuentoPromocion findById(Long id);

    DescuentoPromocion create(DescuentoPromocionRequest request);

    DescuentoPromocion update(Long id, DescuentoPromocionRequest request);

    void delete(Long id);

    DescuentoPromocion activar(Long id);

    DescuentoPromocion desactivar(Long id);
}
