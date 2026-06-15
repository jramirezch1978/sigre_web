package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.Prestamo;

public interface PrestamoRepository extends JpaRepository<Prestamo, Long>,
        JpaSpecificationExecutor<Prestamo> {
}
