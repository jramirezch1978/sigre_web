package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.Incoterm;

import java.util.Optional;

public interface IncotermRepository extends JpaRepository<Incoterm, Long> {

    Optional<Incoterm> findByCodigo(String codigo);
}
