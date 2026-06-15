package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.produccion.entity.LaborProduccion;

import java.util.List;
import java.util.Optional;

public interface LaborProduccionRepository extends JpaRepository<LaborProduccion, Long> {

    List<LaborProduccion> findByLaborIdOrderByIdAsc(Long laborId);

    boolean existsByLaborIdAndArticuloId(Long laborId, Long articuloId);

    Optional<LaborProduccion> findByLaborIdAndArticuloId(Long laborId, Long articuloId);
}
