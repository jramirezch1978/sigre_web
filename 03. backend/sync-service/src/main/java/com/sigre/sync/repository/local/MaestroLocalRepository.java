package com.sigre.sync.repository.local;

import com.sigre.sync.entity.local.MaestroLocal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MaestroLocalRepository extends JpaRepository<MaestroLocal, String> {
    
    /**
     * Contar total de registros
     */
    @Query("SELECT COUNT(m) FROM MaestroLocal m")
    long countTotal();
    
    /**
     * Buscar registros pendientes de sincronización
     */
    List<MaestroLocal> findByEstadoSyncOrEstadoSyncIsNull(String estadoSync);
    
    /**
     * Marcar como sincronizado
     */
    @Query("UPDATE MaestroLocal m SET m.estadoSync = 'S', m.fechaSync = :fecha WHERE m.codTrabajador = :codTrabajador")
    void marcarComoSincronizado(@Param("codTrabajador") String codTrabajador, @Param("fecha") LocalDate fecha);
    
    /**
     * Verificar si existe por código
     */
    boolean existsByCodTrabajador(String codTrabajador);
}
