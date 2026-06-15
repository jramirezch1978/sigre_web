package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.Detraccion;

public interface DetraccionRepository extends JpaRepository<Detraccion, Long> {
    java.util.Optional<Detraccion> findByBienServ(String bienServ);
    boolean existsByBienServ(String bienServ);
}
