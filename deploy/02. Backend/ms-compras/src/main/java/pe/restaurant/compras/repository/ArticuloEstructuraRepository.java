package pe.restaurant.compras.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.ArticuloEstructura;
import pe.restaurant.compras.entity.ArticuloEstructuraId;

public interface ArticuloEstructuraRepository extends JpaRepository<ArticuloEstructura, ArticuloEstructuraId> {

    Page<ArticuloEstructura> findByArticuloPadreId(Long articuloPadreId, Pageable pageable);
}
