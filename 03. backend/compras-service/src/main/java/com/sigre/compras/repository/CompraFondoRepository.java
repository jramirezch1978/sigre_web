package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.CompraFondo;

import java.util.Optional;

public interface CompraFondoRepository extends JpaRepository<CompraFondo, Long> {

    Optional<CompraFondo> findByCentrosCostoIdAndAnioAndFlagEstado(
            Long centrosCostoId, Integer anio, String flagEstado);
}
