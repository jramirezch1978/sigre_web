package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.EntidadContribuyenteRef;

import java.util.Optional;

public interface EntidadContribuyenteRefRepository extends JpaRepository<EntidadContribuyenteRef, Long> {
    Optional<EntidadContribuyenteRef> findFirstByFlagEstadoOrderByIdAsc(String flagEstado);
}
