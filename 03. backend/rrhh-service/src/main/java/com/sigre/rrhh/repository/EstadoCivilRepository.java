package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.EstadoCivil;

@Repository
public interface EstadoCivilRepository extends JpaRepository<EstadoCivil, Long>, JpaSpecificationExecutor<EstadoCivil> {
    boolean existsByCodigo(String codigo);
    java.util.List<EstadoCivil> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
