package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.RegimenPensionario;
import java.util.List;
import java.util.Optional;

public interface RegimenPensionarioRepository extends JpaRepository<RegimenPensionario, Long>, JpaSpecificationExecutor<RegimenPensionario> {
    Optional<RegimenPensionario> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<RegimenPensionario> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
