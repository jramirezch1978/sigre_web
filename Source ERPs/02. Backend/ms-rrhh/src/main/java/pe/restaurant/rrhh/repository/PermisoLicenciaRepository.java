package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.PermisoLicencia;

import java.util.List;

public interface PermisoLicenciaRepository extends JpaRepository<PermisoLicencia, Long>,
        JpaSpecificationExecutor<PermisoLicencia> {

    List<PermisoLicencia> findByFlagEstado(String flagEstado);

    List<PermisoLicencia> findByFlagEstadoIn(List<String> estados);
}
