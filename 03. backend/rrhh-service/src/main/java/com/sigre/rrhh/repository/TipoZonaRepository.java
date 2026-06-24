package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.TipoZona;
import java.util.List;
import java.util.Optional;

public interface TipoZonaRepository extends JpaRepository<TipoZona, Long>, JpaSpecificationExecutor<TipoZona> {
    Optional<TipoZona> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoZona> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
