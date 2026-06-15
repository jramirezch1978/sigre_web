package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.TipoCambio;

import java.time.LocalDate;

public interface TipoCambioService {
    Page<TipoCambio> findAll(Long monedaId, LocalDate fechaDesde, LocalDate fechaHasta, Pageable pageable);
    TipoCambio findByFecha(LocalDate fecha, Long monedaId);
    TipoCambio findUltimoByFecha(LocalDate fecha, Long monedaId);
    TipoCambio findById(Long id);
    TipoCambio create(TipoCambio entity);
    TipoCambio update(Long id, TipoCambio entity);
    void delete(Long id);
    TipoCambio activate(Long id);
    TipoCambio deactivate(Long id);
}
