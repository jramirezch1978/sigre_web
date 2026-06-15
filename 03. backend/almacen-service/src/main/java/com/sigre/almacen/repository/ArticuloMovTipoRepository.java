package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.ArticuloMovTipo;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ArticuloMovTipoRepository extends JpaRepository<ArticuloMovTipo, Long> {

    Optional<ArticuloMovTipo> findByTipoMov(String tipoMov);

    /** Ids de tipos cuyo código (sin espacios; el dato viene como "S15   ") está en la lista. */
    @Query("SELECT t.id FROM ArticuloMovTipo t WHERE TRIM(t.tipoMov) IN :codigos")
    List<Long> findIdsByTipoMovCodes(@Param("codigos") List<String> codigos);

    /**
     * Proyección {@code [id, tipoMov, descTipoMov]} por ids. Evita cargar la entidad
     * completa (algunos tenants migrados no tienen todas las columnas, p. ej. cnta_cntbl).
     */
    @Query("SELECT t.id, t.tipoMov, t.descTipoMov FROM ArticuloMovTipo t WHERE t.id IN :ids")
    List<Object[]> findResumenByIds(@Param("ids") List<Long> ids);

    boolean existsByTipoMov(String tipoMov);

    boolean existsByTipoMovAndIdNot(String tipoMov, Long id);

    Optional<ArticuloMovTipo> findFirstByFlagMovEntreAlmAndFactorSldoTotalGreaterThanAndFlagEstado(
            String flagMovEntreAlm, BigDecimal factorSldoTotal, String flagEstado);
}
