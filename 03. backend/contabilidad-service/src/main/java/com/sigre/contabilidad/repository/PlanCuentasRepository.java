package com.sigre.contabilidad.repository;

import com.sigre.contabilidad.model.entity.PlanCuentas;
import com.sigre.contabilidad.model.entity.PlanCuentasId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio para PlanCuentas
 */
@Repository
public interface PlanCuentasRepository extends JpaRepository<PlanCuentas, PlanCuentasId> {

    /**
     * Obtiene todas las cuentas activas de una empresa
     */
    @Query("SELECT p FROM PlanCuentas p WHERE p.id.empresa = :empresa " +
           "AND p.flagEstado = '1' ORDER BY p.id.cntaCntbl")
    List<PlanCuentas> findAllActivas(@Param("empresa") String empresa);

    /**
     * Obtiene cuentas por nivel
     */
    @Query("SELECT p FROM PlanCuentas p WHERE p.id.empresa = :empresa " +
           "AND p.nivel = :nivel AND p.flagEstado = '1' ORDER BY p.id.cntaCntbl")
    List<PlanCuentas> findByNivel(
        @Param("empresa") String empresa,
        @Param("nivel") Integer nivel
    );

    /**
     * Obtiene cuentas que permiten movimiento (de detalle)
     */
    @Query("SELECT p FROM PlanCuentas p WHERE p.id.empresa = :empresa " +
           "AND p.flagMovimiento = 'S' AND p.flagEstado = '1' " +
           "ORDER BY p.id.cntaCntbl")
    List<PlanCuentas> findCuentasMovimiento(@Param("empresa") String empresa);
}

