package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.EntidadTransporte;

import java.util.List;

public interface EntidadTransporteRepository extends JpaRepository<EntidadTransporte, Long> {
    List<EntidadTransporte> findByEntidadContribuyenteId(Long entidadContribuyenteId);
}
