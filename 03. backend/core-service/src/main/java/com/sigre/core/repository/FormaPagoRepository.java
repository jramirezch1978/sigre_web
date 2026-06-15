package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.FormaPago;

import java.util.Optional;

public interface FormaPagoRepository extends JpaRepository<FormaPago, Long> {
    Optional<FormaPago> findByCodigo(String codigo);
}
