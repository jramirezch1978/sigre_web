package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.compras.entity.ProgramacionCompras;

public interface ProgramacionComprasRepository extends JpaRepository<ProgramacionCompras, Long>,
        JpaSpecificationExecutor<ProgramacionCompras> {
}
