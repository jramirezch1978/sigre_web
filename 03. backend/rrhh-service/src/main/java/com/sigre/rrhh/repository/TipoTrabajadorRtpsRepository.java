package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.TipoTrabajadorRtps;
import java.util.List;
import java.util.Optional;

public interface TipoTrabajadorRtpsRepository extends JpaRepository<TipoTrabajadorRtps, Long>, JpaSpecificationExecutor<TipoTrabajadorRtps> {
    Optional<TipoTrabajadorRtps> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoTrabajadorRtps> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
