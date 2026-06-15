package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.RegimenLaboral;

@Repository
public interface RegimenLaboralRepository extends JpaRepository<RegimenLaboral, Long>, JpaSpecificationExecutor<RegimenLaboral> {
    boolean existsByCodigo(String codigo);
    java.util.List<RegimenLaboral> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
