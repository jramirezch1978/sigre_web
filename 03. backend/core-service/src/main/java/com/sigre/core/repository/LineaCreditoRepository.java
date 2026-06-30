package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.LineaCredito;

import java.util.List;

public interface LineaCreditoRepository extends JpaRepository<LineaCredito, Long> {
    List<LineaCredito> findByRelacionComercialIdAndFlagEstado(Long relacionComercialId, String flagEstado);
}
