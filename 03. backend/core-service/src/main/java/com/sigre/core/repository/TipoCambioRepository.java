package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.core.entity.TipoCambio;

import java.time.LocalDate;
import java.util.Optional;

public interface TipoCambioRepository extends JpaRepository<TipoCambio, Long>, JpaSpecificationExecutor<TipoCambio> {
    Optional<TipoCambio> findByFechaAndMonedaId(LocalDate fecha, Long monedaId);
    Optional<TipoCambio> findFirstByMonedaIdAndFechaLessThanEqualOrderByFechaDesc(Long monedaId, LocalDate fecha);
}
