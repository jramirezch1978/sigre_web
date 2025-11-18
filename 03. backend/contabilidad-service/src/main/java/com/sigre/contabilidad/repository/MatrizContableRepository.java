package com.sigre.contabilidad.repository;

import com.sigre.contabilidad.model.entity.MatrizContable;
import com.sigre.contabilidad.model.entity.MatrizContableId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio para MatrizContable
 * CRÍTICO: Gestiona las reglas de integración contable automática
 */
@Repository
public interface MatrizContableRepository extends JpaRepository<MatrizContable, MatrizContableId> {

    /**
     * Busca la matriz contable para un tipo de movimiento específico
     */
    @Query("SELECT m FROM MatrizContable m WHERE m.id.empresa = :empresa " +
           "AND m.id.modulo = :modulo AND m.id.tipoMovimiento = :tipoMovimiento " +
           "AND m.id.tipoArticulo = :tipoArticulo AND m.flagActivo = 'S' " +
           "ORDER BY m.id.secuencia")
    List<MatrizContable> findMatricesByMovimiento(
        @Param("empresa") String empresa,
        @Param("modulo") String modulo,
        @Param("tipoMovimiento") String tipoMovimiento,
        @Param("tipoArticulo") String tipoArticulo
    );

    /**
     * Busca todas las matrices activas de un módulo
     */
    @Query("SELECT m FROM MatrizContable m WHERE m.id.empresa = :empresa " +
           "AND m.id.modulo = :modulo AND m.flagActivo = 'S'")
    List<MatrizContable> findByModulo(
        @Param("empresa") String empresa,
        @Param("modulo") String modulo
    );
}
