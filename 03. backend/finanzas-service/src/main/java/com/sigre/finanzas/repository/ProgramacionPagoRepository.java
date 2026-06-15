package com.sigre.finanzas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.ProgramacionPago;

import java.time.LocalDate;

@Repository
public interface ProgramacionPagoRepository extends JpaRepository<ProgramacionPago, Long>, JpaSpecificationExecutor<ProgramacionPago> {

    @Query("SELECT p FROM ProgramacionPago p " +
           "WHERE (CAST(:fechaDesde AS date) IS NULL OR p.fechaProgramada >= :fechaDesde) " +
           "AND (CAST(:fechaHasta AS date) IS NULL OR p.fechaProgramada <= :fechaHasta) " +
           "AND (CAST(:flagEstado AS string) IS NULL OR p.flagEstado = :flagEstado) " +
           "AND p.flagEstado <> '0' " +
           "ORDER BY p.fechaProgramada DESC")
    Page<ProgramacionPago> buscarConFiltros(
        @Param("fechaDesde") LocalDate fechaDesde,
        @Param("fechaHasta") LocalDate fechaHasta,
        @Param("flagEstado") String flagEstado,
        Pageable pageable
    );
}
