package com.sigre.sync.repository.remote;

import com.sigre.sync.entity.remote.AsistenciaHt580Remote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AsistenciaHt580RemoteRepository extends JpaRepository<AsistenciaHt580Remote, String> {
    
    /**
     * Verificar si existe por RECKEY
     */
    boolean existsByReckey(String reckey);
    
    /**
     * Buscar registro recién insertado por Oracle usando campos únicos
     * (para obtener el reckey real generado por trigger)
     */
    @Query("SELECT a " +
           "FROM AsistenciaHt580Remote a " +
           "WHERE a.codOrigen       = :codOrigen " +
           "  AND a.codigo          = :codigo " +
           "  AND a.flagInOut       = :flagInOut " +
           "  AND TO_CHAR(a.fechaMovimiento, 'dd/mm/yyyy hh24:mi:ss') = TO_CHAR(:fechaMovimiento, 'dd/mm/yyyy hh24:mi:ss') " +
           "  AND TRIM(a.codUsuario) = TRIM(:codUsuario) " +
           "  AND a.direccionIp     = :direccionIp " +
           "  AND TRIM(a.turno)     = TRIM(:turno) " +
           "  AND ((:lecturaPda IS NULL AND a.lecturaPda IS NULL) OR a.lecturaPda = :lecturaPda) " +
           "ORDER BY a.fechaRegistro DESC")
    AsistenciaHt580Remote findRegistroRecienInsertado(
            @Param("codOrigen") String codOrigen,
            @Param("codigo") String codigo,
            @Param("flagInOut") String flagInOut,
            @Param("fechaMovimiento") LocalDateTime fechaMovimiento,
            @Param("codUsuario") String codUsuario,
            @Param("direccionIp") String direccionIp,
            @Param("turno") String turno,
            @Param("lecturaPda") String lecturaPda
    );
    
    /**
     * FASE 3: Buscar todos los registros de Oracle por cod_origen (sin filtro fecha)
     */
    List<AsistenciaHt580Remote> findByCodOrigenOrderByFechaRegistroDesc(String codOrigen);
}
