package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.CondicionPago;

public interface CondicionPagoRepository extends JpaRepository<CondicionPago, Long> {
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
    boolean existsByCodigoIgnoreCase(String codigo);
}
