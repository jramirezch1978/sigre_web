package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.compras.entity.OrdenServicio;

public interface OrdenServicioRepository extends JpaRepository<OrdenServicio, Long>, JpaSpecificationExecutor<OrdenServicio> {
}
