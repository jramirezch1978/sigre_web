package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.OpcionMenu;

import java.util.List;
import java.util.Optional;

public interface OpcionMenuRepository extends JpaRepository<OpcionMenu, Long> {

    Optional<OpcionMenu> findByCodigo(String codigo);

    List<OpcionMenu> findAllByOrderByModuloIdAscOrdenAscNombreAsc();

    List<OpcionMenu> findByModuloIdOrderByOrdenAscNombreAsc(Long moduloId);
}
