package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.Detraccion;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface DetraccionRepository extends JpaRepository<Detraccion, Long>, JpaSpecificationExecutor<Detraccion> {

    boolean existsByNroDetraccionAndFlagEstado(String nroDetraccion, String flagEstado);

    /**
     * Encuentra detracciones pendientes (activas).
     * Aplica filtros opcionales por rango de fechas.
     * 
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de detracciones pendientes
     */
    @Query(value = "SELECT d.* FROM finanzas.detraccion d " +
           "WHERE d.flag_estado = '1' " +
           "AND (CAST(:fechaDesde AS DATE) IS NULL OR d.fecha_registro >= CAST(:fechaDesde AS DATE)) " +
           "AND (CAST(:fechaHasta AS DATE) IS NULL OR d.fecha_registro <= CAST(:fechaHasta AS DATE)) " +
           "ORDER BY d.fecha_registro DESC", nativeQuery = true)
    List<Detraccion> findPendientes(
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta);
}
