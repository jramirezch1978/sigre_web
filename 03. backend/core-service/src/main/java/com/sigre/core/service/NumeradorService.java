package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.Numerador;

public interface NumeradorService {
    Page<Numerador> findAll(Pageable pageable);
    Numerador findById(Long id);
    Numerador create(Numerador entity);
    Numerador update(Long id, Numerador entity);
    void delete(Long id);
    Numerador activate(Long id);
    Numerador deactivate(Long id);
    Long siguiente(String codigoNumerador);
}
