package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.ArticuloRef;

public interface ArticuloRefRepository extends JpaRepository<ArticuloRef, Long> {
}
