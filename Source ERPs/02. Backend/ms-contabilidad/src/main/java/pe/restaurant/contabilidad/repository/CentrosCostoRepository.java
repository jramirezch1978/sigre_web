package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.CentrosCosto;

import java.util.Optional;

@Repository
public interface CentrosCostoRepository extends JpaRepository<CentrosCosto, Long>, JpaSpecificationExecutor<CentrosCosto> {

    Optional<CentrosCosto> findByCencos(String cencos);

    boolean existsByCencosAndIdNot(String cencos, Long id);
}
