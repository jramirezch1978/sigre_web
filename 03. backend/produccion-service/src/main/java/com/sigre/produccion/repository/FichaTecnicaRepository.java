package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.produccion.entity.FichaTecnica;

import java.util.Optional;

public interface FichaTecnicaRepository extends JpaRepository<FichaTecnica, Long> {

    Optional<FichaTecnica> findByRecetaId(Long recetaId);

    void deleteByRecetaId(Long recetaId);
}
