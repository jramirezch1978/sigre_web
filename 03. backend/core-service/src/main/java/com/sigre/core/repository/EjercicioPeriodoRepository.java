package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.EjercicioPeriodo;

import java.util.Optional;

public interface EjercicioPeriodoRepository extends JpaRepository<EjercicioPeriodo, Long> {
    Page<EjercicioPeriodo> findByAnio(Integer anio, Pageable pageable);
    Optional<EjercicioPeriodo> findByAnio(Integer anio);
}
