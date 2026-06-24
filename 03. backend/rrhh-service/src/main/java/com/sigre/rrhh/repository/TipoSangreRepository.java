package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.TipoSangre;
import java.util.List;
import java.util.Optional;

public interface TipoSangreRepository extends JpaRepository<TipoSangre, Long>, JpaSpecificationExecutor<TipoSangre> {
    Optional<TipoSangre> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoSangre> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
