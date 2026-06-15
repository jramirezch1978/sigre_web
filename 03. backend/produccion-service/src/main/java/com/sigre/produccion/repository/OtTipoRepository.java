package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.produccion.entity.OtTipo;

public interface OtTipoRepository extends JpaRepository<OtTipo, Long>, JpaSpecificationExecutor<OtTipo> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    @Query(value = "SELECT COUNT(1) > 0 FROM produccion.orden_trabajo WHERE ot_tipo_id = :otTipoId",
            nativeQuery = true)
    boolean existsOrdenTrabajoByOtTipoId(@Param("otTipoId") Long otTipoId);
}
