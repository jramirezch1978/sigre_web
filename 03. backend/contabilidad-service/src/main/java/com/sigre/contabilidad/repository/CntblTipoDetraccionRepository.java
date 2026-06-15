package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.CntblTipoDetraccion;

import java.util.Optional;

@Repository
public interface CntblTipoDetraccionRepository extends JpaRepository<CntblTipoDetraccion, Long>,
        JpaSpecificationExecutor<CntblTipoDetraccion> {

    Optional<CntblTipoDetraccion> findByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);
}
