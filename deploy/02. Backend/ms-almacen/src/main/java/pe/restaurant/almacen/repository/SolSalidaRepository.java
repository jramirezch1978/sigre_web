package pe.restaurant.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.almacen.entity.SolSalida;

import java.util.Optional;

public interface SolSalidaRepository extends JpaRepository<SolSalida, Long>, JpaSpecificationExecutor<SolSalida> {
    Optional<SolSalida> findByNumero(String numero);
    Page<SolSalida> findByAlmacenId(Long almacenId, Pageable pageable);
}
