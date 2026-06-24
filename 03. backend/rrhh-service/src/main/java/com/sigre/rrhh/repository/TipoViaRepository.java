package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.TipoVia;
import java.util.List;
import java.util.Optional;

public interface TipoViaRepository extends JpaRepository<TipoVia, Long>, JpaSpecificationExecutor<TipoVia> {
    Optional<TipoVia> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoVia> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
