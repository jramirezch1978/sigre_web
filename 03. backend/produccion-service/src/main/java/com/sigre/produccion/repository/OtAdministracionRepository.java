package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.produccion.entity.OtAdministracion;

public interface OtAdministracionRepository
        extends JpaRepository<OtAdministracion, Long>, JpaSpecificationExecutor<OtAdministracion> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    @Query(value = "SELECT COUNT(1) > 0 FROM produccion.orden_trabajo WHERE ot_administracion_id = :otAdminId",
            nativeQuery = true)
    boolean existsOrdenTrabajoByOtAdministracionId(@Param("otAdminId") Long otAdminId);
}
