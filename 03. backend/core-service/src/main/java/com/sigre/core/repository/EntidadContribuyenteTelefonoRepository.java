package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.EntidadContribuyenteTelefono;

import java.util.List;

public interface EntidadContribuyenteTelefonoRepository extends JpaRepository<EntidadContribuyenteTelefono, Long> {
    List<EntidadContribuyenteTelefono> findByEntidadContribuyenteId(Long entidadContribuyenteId);

    List<EntidadContribuyenteTelefono> findByEntidadContribuyenteIdAndFlagEstado(Long entidadContribuyenteId, String flagEstado);
}
