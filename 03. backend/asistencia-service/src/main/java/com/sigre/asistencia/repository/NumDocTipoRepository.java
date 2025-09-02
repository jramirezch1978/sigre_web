package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.NumDocTipo;
import com.sigre.asistencia.entity.NumDocTipoId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import jakarta.persistence.LockModeType;
import java.util.Optional;

@Repository
public interface NumDocTipoRepository extends JpaRepository<NumDocTipo, NumDocTipoId> {
    
    /**
     * Buscar numerador por ID compuesto con lock pesimista
     * Usa lock pesimista para evitar concurrencia en generación de números
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT n FROM NumDocTipo n WHERE n.id = :id")
    Optional<NumDocTipo> findByIdWithLock(@Param("id") NumDocTipoId id);
    
    /**
     * Buscar numerador por tipo de documento y código de origen
     */
    @Query("SELECT n FROM NumDocTipo n WHERE n.id.tipoDoc = :tipoDoc AND n.id.codOrigen = :codOrigen")
    Optional<NumDocTipo> findByTipoDocAndCodOrigen(@Param("tipoDoc") String tipoDoc, 
                                                   @Param("codOrigen") String codOrigen);
    
    /**
     * Buscar numerador por tipo de documento y código de origen con lock
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT n FROM NumDocTipo n WHERE n.id.tipoDoc = :tipoDoc AND n.id.codOrigen = :codOrigen")
    Optional<NumDocTipo> findByTipoDocAndCodOrigenWithLock(@Param("tipoDoc") String tipoDoc, 
                                                           @Param("codOrigen") String codOrigen);
    
    /**
     * Obtener último número generado para un tipo y origen específico
     */
    @Query("SELECT n.ultNro FROM NumDocTipo n WHERE n.id.tipoDoc = :tipoDoc AND n.id.codOrigen = :codOrigen")
    Optional<Long> findUltimoNumero(@Param("tipoDoc") String tipoDoc, @Param("codOrigen") String codOrigen);
}
