package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.EntidadContribuyenteRepresentante;

import java.util.List;

public interface EntidadContribuyenteRepresentanteRepository extends JpaRepository<EntidadContribuyenteRepresentante, Long> {
    List<EntidadContribuyenteRepresentante> findByEntidadContribuyenteId(Long entidadContribuyenteId);

    List<EntidadContribuyenteRepresentante> findByEntidadContribuyenteIdAndFlagEstado(Long entidadContribuyenteId, String flagEstado);
}
