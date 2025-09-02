package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.TurnoLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface TurnoLocalRepository extends JpaRepository<TurnoLocal, String> {
    
    /**
     * Buscar turnos activos
     */
    List<TurnoLocal> findByFlagEstadoOrderByTurno(String flagEstado);
    
    /**
     * Buscar turnos pendientes de sincronización
     */
    List<TurnoLocal> findByEstadoSyncOrderByFechaSync(String estadoSync);
    
    /**
     * Marcar todos los turnos como pendientes de sincronización
     */
    @Modifying
    @Query("UPDATE TurnoLocal t SET t.estadoSync = 'P', t.fechaSync = :fecha WHERE t.estadoSync = 'S'")
    void marcarTodosPendientes(@Param("fecha") LocalDateTime fecha);
    
    /**
     * Limpiar tabla antes de sincronización completa
     */
    @Modifying
    @Query("DELETE FROM TurnoLocal")
    void limpiarTabla();
}
