package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.EntidadBancoCntaRef;

import java.util.Optional;

public interface EntidadBancoCntaRefRepository extends JpaRepository<EntidadBancoCntaRef, Long> {

    Optional<EntidadBancoCntaRef> findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(
            Long entidadContribuyenteId, String flagEstado);
}
