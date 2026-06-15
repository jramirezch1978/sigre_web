package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.PlanContable;

import java.util.Optional;

@Repository
public interface PlanContableRepository extends JpaRepository<PlanContable, Long> {

    Optional<PlanContable> findByCodigo(String codigo);

    Optional<PlanContable> findFirstByFlagEstadoOrderByEffectiveFromDesc(String flagEstado);
}
