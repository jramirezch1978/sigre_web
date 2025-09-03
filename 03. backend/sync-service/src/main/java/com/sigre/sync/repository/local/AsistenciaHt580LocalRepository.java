package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.AsistenciaHt580Local;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AsistenciaHt580LocalRepository extends JpaRepository<AsistenciaHt580Local, String> {
    
    /**
     * Buscar registros pendientes de sincronización
     */
    List<AsistenciaHt580Local> findByEstadoSyncOrEstadoSyncIsNull(String estadoSync);
    
    /**
     * Buscar registros pendientes + errores que aún pueden reintentarse
     * Incluye: estado_sync='P', NULL, y 'E' con intentos <= maxRetries
     */
    @Query("SELECT a FROM AsistenciaHt580Local a WHERE " +
           "(a.estadoSync = 'P' OR a.estadoSync IS NULL) OR " +
           "(a.estadoSync = 'E' AND a.intentosSync <= :maxRetries)")
    List<AsistenciaHt580Local> findPendientesParaSincronizacion(@Param("maxRetries") int maxRetries);
    
    /**
     * Contar registros pendientes (incluyendo errores con reintentos disponibles)
     */
    @Query("SELECT COUNT(a) FROM AsistenciaHt580Local a WHERE " +
           "(a.estadoSync = 'P' OR a.estadoSync IS NULL) OR " +
           "(a.estadoSync = 'E' AND a.intentosSync <= :maxRetries)")
    long countPendientesParaSincronizacion(@Param("maxRetries") int maxRetries);
    
    /**
     * Marcar como sincronizado
     */
    @Modifying
    @Query("UPDATE AsistenciaHt580Local a SET a.estadoSync = 'S', a.fechaSync = :fecha WHERE a.reckey = :reckey")
    void marcarComoSincronizado(@Param("reckey") String reckey, @Param("fecha") LocalDateTime fecha);
    
    /**
     * Marcar como error
     */
    @Modifying
    @Query("UPDATE AsistenciaHt580Local a SET a.estadoSync = 'E', a.intentosSync = a.intentosSync + 1 WHERE a.reckey = :reckey")
    void marcarComoError(@Param("reckey") String reckey);
}
