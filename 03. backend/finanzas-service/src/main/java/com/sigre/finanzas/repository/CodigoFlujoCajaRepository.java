package com.sigre.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.sigre.finanzas.entity.CodigoFlujoCaja;

import java.util.List;
import java.util.Optional;

public interface CodigoFlujoCajaRepository extends JpaRepository<CodigoFlujoCaja, Long> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    Page<CodigoFlujoCaja> findByTipoAndFlagEstado(String tipo, String flagEstado, Pageable pageable);

    Page<CodigoFlujoCaja> findByFlagEstado(String flagEstado, Pageable pageable);
    
    List<CodigoFlujoCaja> findByGrupoCodigoFlujoCajaIdAndFlagEstadoOrderByOrden(Long grupoCodigoFlujoCajaId, String flagEstado);
    
    List<CodigoFlujoCaja> findByGrupoCodigoFlujoCajaIdOrderByOrden(Long grupoCodigoFlujoCajaId);
    
    @Query("SELECT cfc FROM CodigoFlujoCaja cfc WHERE cfc.grupoCodigoFlujoCajaId = ?1 AND cfc.flagEstado = '1' ORDER BY cfc.orden")
    List<CodigoFlujoCaja> findActivosPorGrupo(Long grupoCodigoFlujoCajaId);
}
