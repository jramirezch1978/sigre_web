package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloEquivalencia;

public interface ArticuloEquivalenciaRepository extends JpaRepository<ArticuloEquivalencia, Long> {
    Page<ArticuloEquivalencia> findByArticuloId(Long articuloId, Pageable pageable);
    boolean existsByArticuloIdAndArticuloEquivalenteId(Long articuloId, Long articuloEquivalenteId);
}
