package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.CntblCierre;

import java.util.Optional;

public interface CntblCierreRepository extends JpaRepository<CntblCierre, CntblCierre.CntblCierreId> {

    Optional<CntblCierre> findByAnoAndMes(Integer ano, Integer mes);
}
