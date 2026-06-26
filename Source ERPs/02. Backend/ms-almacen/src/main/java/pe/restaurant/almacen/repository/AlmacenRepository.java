package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.Almacen;

public interface AlmacenRepository extends JpaRepository<Almacen, Long> {

    boolean existsBySucursalIdAndCodigoIgnoreCase(Long sucursalId, String codigo);

    boolean existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(Long sucursalId, String codigo, Long id);
}
