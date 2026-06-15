package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.produccion.entity.Ejecutor;

import java.util.Optional;

public interface EjecutorRepository extends JpaRepository<Ejecutor, Long>,
        JpaSpecificationExecutor<Ejecutor> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
