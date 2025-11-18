package com.sigre.contabilidad.repository;

import com.sigre.contabilidad.model.entity.AsientoContable;
import com.sigre.contabilidad.model.entity.AsientoContableId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

/**
 * Repositorio para AsientoContable
 */
@Repository
public interface AsientoContableRepository extends JpaRepository<AsientoContable, AsientoContableId> {

    /**
     * Obtiene asientos por empresa, libro y periodo
     */
    @Query("SELECT a FROM AsientoContable a WHERE a.id.empresa = :empresa " +
           "AND a.id.libro = :libro AND a.id.periodo = :periodo " +
           "ORDER BY a.id.nroAsiento, a.id.linea")
    List<AsientoContable> findByEmpresaLibroPeriodo(
        @Param("empresa") String empresa,
        @Param("libro") String libro,
        @Param("periodo") String periodo
    );

    /**
     * Obtiene asientos por rango de fechas
     */
    @Query("SELECT a FROM AsientoContable a WHERE a.id.empresa = :empresa " +
           "AND a.fechaAsiento BETWEEN :fechaInicio AND :fechaFin " +
           "AND a.flagEstado = '1' " +
           "ORDER BY a.fechaAsiento, a.id.nroAsiento")
    List<AsientoContable> findByRangoFechas(
        @Param("empresa") String empresa,
        @Param("fechaInicio") LocalDate fechaInicio,
        @Param("fechaFin") LocalDate fechaFin
    );

    /**
     * Obtiene el último número de asiento para un libro/periodo
     */
    @Query("SELECT COALESCE(MAX(a.id.nroAsiento), 0) FROM AsientoContable a " +
           "WHERE a.id.empresa = :empresa AND a.id.libro = :libro " +
           "AND a.id.origen = :origen AND a.id.periodo = :periodo")
    Long findUltimoNroAsiento(
        @Param("empresa") String empresa,
        @Param("libro") String libro,
        @Param("origen") String origen,
        @Param("periodo") String periodo
    );

    /**
     * Obtiene asientos pendientes de transferir (de otros módulos)
     */
    @Query("SELECT a FROM AsientoContable a WHERE a.id.empresa = :empresa " +
           "AND a.flagTransferido = 'N' AND a.origenIntegracion = :origen")
    List<AsientoContable> findPendientesTransferir(
        @Param("empresa") String empresa,
        @Param("origen") String origen
    );
}

