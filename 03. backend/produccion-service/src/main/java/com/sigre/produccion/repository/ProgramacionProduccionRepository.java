package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.produccion.entity.ProgramacionProduccion;

public interface ProgramacionProduccionRepository extends JpaRepository<ProgramacionProduccion, Long>,
        JpaSpecificationExecutor<ProgramacionProduccion> {
}
