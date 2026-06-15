package com.sigre.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.core.entity.CatalogoSunatDet;

import java.util.List;
import java.util.Optional;

public interface CatalogoSunatDetRepository extends JpaRepository<CatalogoSunatDet, Long> {

    Optional<CatalogoSunatDet> findByCatalogoSunatIdAndCodigoItem(Long catalogoSunatId, String codigoItem);

    @Query("SELECT d FROM CatalogoSunatDet d WHERE "
            + "(:catalogoSunatId IS NULL OR d.catalogoSunatId = :catalogoSunatId) "
            + "AND (:codigoItem IS NULL OR d.codigoItem LIKE %:codigoItem%) "
            + "AND (:nombreItem IS NULL OR d.nombreItem LIKE %:nombreItem%) "
            + "AND (:flagEstado IS NULL OR d.flagEstado = :flagEstado)")
    Page<CatalogoSunatDet> findWithFilters(
            @Param("catalogoSunatId") Long catalogoSunatId,
            @Param("codigoItem") String codigoItem,
            @Param("nombreItem") String nombreItem,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);

    @Query("SELECT d FROM CatalogoSunatDet d WHERE d.catalogoSunatId = :catalogoSunatId AND d.flagEstado = '1'")
    List<CatalogoSunatDet> findActivosByCatalogoId(@Param("catalogoSunatId") Long catalogoSunatId);
}
