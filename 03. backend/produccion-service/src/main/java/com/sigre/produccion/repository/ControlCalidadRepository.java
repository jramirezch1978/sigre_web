package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.produccion.entity.ControlCalidad;

public interface ControlCalidadRepository extends JpaRepository<ControlCalidad, Long>,
        JpaSpecificationExecutor<ControlCalidad> {
}
