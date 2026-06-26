package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.compras.entity.SolicitudCompra;

public interface SolicitudCompraRepository extends JpaRepository<SolicitudCompra, Long>, JpaSpecificationExecutor<SolicitudCompra> {
}
