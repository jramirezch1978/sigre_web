package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.MaestroRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MaestroRemoteRepository extends JpaRepository<MaestroRemote, String> {
    
    /**
     * Obtener todos los trabajadores activos
     */
    List<MaestroRemote> findByFlagEstado(String flagEstado);
    
    /**
     * Contar trabajadores activos
     */
    @Query("SELECT COUNT(m) FROM MaestroRemote m WHERE m.flagEstado = '1'")
    long countActiveTrabajadores();
    
    /**
     * Obtener todos los registros ordenados por código
     */
    List<MaestroRemote> findAllByOrderByCodTrabajador();
}
