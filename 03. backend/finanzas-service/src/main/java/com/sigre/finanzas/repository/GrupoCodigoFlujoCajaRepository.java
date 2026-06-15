package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.GrupoCodigoFlujoCaja;

import java.util.Optional;

@Repository
public interface GrupoCodigoFlujoCajaRepository extends JpaRepository<GrupoCodigoFlujoCaja, Long> {

    boolean existsByCodigo(String codigo);
    
    boolean existsByCodigoAndIdNot(String codigo, Long id);
    
    Optional<GrupoCodigoFlujoCaja> findByCodigoAndFlagEstado(String codigo, String flagEstado);
}
