package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.ArticuloRef;

public interface ArticuloRefRepository extends JpaRepository<ArticuloRef, Long> {
}
