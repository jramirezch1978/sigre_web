package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.SancionAmonestacion;

public interface SancionAmonestacionRepository extends JpaRepository<SancionAmonestacion, Long>,
        JpaSpecificationExecutor<SancionAmonestacion> {
}
