package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.Pago;

@Repository
public interface PagoRepository extends JpaRepository<Pago, Long> {
}
