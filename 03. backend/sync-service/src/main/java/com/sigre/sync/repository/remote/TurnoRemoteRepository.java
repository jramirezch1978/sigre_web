package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.TurnoRemote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TurnoRemoteRepository extends JpaRepository<TurnoRemote, String> {
    
    /**
     * Buscar turnos activos para sincronización
     */
    List<TurnoRemote> findByFlagEstadoOrderByTurno(String flagEstado);
    
    /**
     * Buscar todos los turnos activos - consulta JPA simple
     */
    @Query("SELECT t FROM TurnoRemote t WHERE t.flagEstado = '1' ORDER BY t.turno")
    List<TurnoRemote> findAllActivosParaSync();
    
    /**
     * Consulta SQL nativa para obtener TODOS los 18 campos de la tabla turno
     * Exactamente como están en Oracle sin modificaciones
     */
    @Query(value = "SELECT " +
            "turno, " +
            "hora_inicio_norm, hora_final_norm, " +
            "refrig_inicio_norm, refrig_final_norm, " +
            "hora_inicio_sab, hora_final_sab, " +
            "refrig_inicio_sab, refrig_final_sab, " +
            "hora_inicio_dom, hora_final_dom, " +
            "hora_ini_cmps_norm, hora_fin_cmps_norm, " +
            "hora_ini_cmps_sab, hora_fin_cmps_sab, " +
            "hora_ini_cmps_dom, hora_fin_cmps_dom, " +
            "marc_diaria_norm, marc_diaria_sab, marc_diaria_dom, " +
            "tolerancia, tipo_turno, flag_estado, descripcion, cod_usr, flag_replicacion " +
            "FROM turno WHERE flag_estado = '1' ORDER BY turno", 
            nativeQuery = true)
    List<Object[]> findTurnosConHorarios();
    
    /**
     * Consulta de TODOS los turnos (activos e inactivos) para diagnóstico
     */
    @Query(value = "SELECT turno, descripcion, flag_estado, " +
            "TO_CHAR(hora_inicio_norm, 'HH24:MI') as inicio, " +
            "TO_CHAR(hora_final_norm, 'HH24:MI') as final " +
            "FROM turno ORDER BY turno", 
            nativeQuery = true)
    List<Object[]> findAllTurnosParaDiagnostico();
    
    /**
     * Contar turnos activos
     */
    long countByFlagEstado(String flagEstado);
}
