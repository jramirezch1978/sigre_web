package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.PermisoLicencia;

import java.util.List;

public interface PermisoLicenciaRepository extends JpaRepository<PermisoLicencia, Long>,
        JpaSpecificationExecutor<PermisoLicencia> {

    List<PermisoLicencia> findByFlagEstado(String flagEstado);

    List<PermisoLicencia> findByFlagEstadoIn(List<String> estados);
}
