package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.OperacionesDet;

import java.util.List;

public interface OperacionesDetRepository extends JpaRepository<OperacionesDet, Long> {

    List<OperacionesDet> findByOperacionIdOrderByIdAsc(Long operacionId);

    void deleteByOperacionId(Long operacionId);
}
