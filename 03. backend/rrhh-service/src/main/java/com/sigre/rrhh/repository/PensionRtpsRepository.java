package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.PensionRtps;
import java.util.List;
import java.util.Optional;

public interface PensionRtpsRepository extends JpaRepository<PensionRtps, Long>, JpaSpecificationExecutor<PensionRtps> {
    Optional<PensionRtps> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<PensionRtps> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
