package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ContactoRef;

import java.util.Optional;

public interface ContactoRefRepository extends JpaRepository<ContactoRef, Long> {

    Optional<ContactoRef> findFirstByEntidadContribuyenteIdAndFlagEstadoOrderByIdAsc(
            Long entidadContribuyenteId, String flagEstado);
}
