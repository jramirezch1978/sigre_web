package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.AutorizadorGiro;

import java.util.List;
import java.util.Optional;

@Repository
public interface AutorizadorGiroRepository extends JpaRepository<AutorizadorGiro, Long> {

    boolean existsByCentrosCostoIdAndUsuarioId(Long centrosCostoId, Long usuarioId);
    
    boolean existsByCentrosCostoIdAndUsuarioIdAndIdNot(Long centrosCostoId, Long usuarioId, Long id);
    
    Optional<AutorizadorGiro> findByCentrosCostoIdAndUsuarioIdAndActivo(Long centrosCostoId, Long usuarioId, Boolean activo);
    
    List<AutorizadorGiro> findByCentrosCostoIdAndActivo(Long centrosCostoId, Boolean activo);
    
    List<AutorizadorGiro> findByUsuarioIdAndActivo(Long usuarioId, Boolean activo);
    
    @Query("SELECT ag FROM AutorizadorGiro ag WHERE ag.centrosCostoId = ?1 AND ag.activo = true")
    List<AutorizadorGiro> findAutorizadoresActivosPorCentroCosto(Long centrosCostoId);
    
}
