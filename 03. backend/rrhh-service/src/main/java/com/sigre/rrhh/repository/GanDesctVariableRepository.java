package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.GanDesctVariable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface GanDesctVariableRepository extends JpaRepository<GanDesctVariable, Long> {

    List<GanDesctVariable> findByTrabajadorIdAndFecMovim(Long trabajadorId, LocalDate fecMovim);

    List<GanDesctVariable> findByTrabajadorIdAndFecMovimAndTipoPlanillaId(
            Long trabajadorId, LocalDate fecMovim, Long tipoPlanillaId);

    /** Movimientos del período por trabajador cuyo código de concepto empieza con prefijo (1=ingresos, 2=descuentos). */
    @Query("SELECT gdv FROM GanDesctVariable gdv " +
           "JOIN ConceptoPlanilla cp ON cp.id = gdv.conceptoId " +
           "WHERE gdv.trabajadorId = :trabajadorId " +
           "AND gdv.fecMovim BETWEEN :fecInicio AND :fecFinal " +
           "AND cp.codigo LIKE :prefijo%")
    List<GanDesctVariable> findByTrabajadorPeriodoPrefijo(
            @Param("trabajadorId") Long trabajadorId,
            @Param("fecInicio") LocalDate fecInicio,
            @Param("fecFinal") LocalDate fecFinal,
            @Param("prefijo") String prefijo);

    Optional<GanDesctVariable> findByTrabajadorIdAndFecMovimAndConceptoId(
            Long trabajadorId, LocalDate fecMovim, Long conceptoId);

    /** Borra movimientos del período para un trabajador y concepto (usado por add_diferi_quincena). */
    @Modifying
    @Query("DELETE FROM GanDesctVariable gdv " +
           "WHERE gdv.trabajadorId = :trabajadorId " +
           "AND gdv.fecMovim BETWEEN :fecInicio AND :fecFinal " +
           "AND gdv.conceptoId = :conceptoId")
    void deleteByTrabajadorPeriodoConcepto(
            @Param("trabajadorId") Long trabajadorId,
            @Param("fecInicio") LocalDate fecInicio,
            @Param("fecFinal") LocalDate fecFinal,
            @Param("conceptoId") Long conceptoId);
}
