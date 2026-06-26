package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.CodigoRecuperacion;

public interface CodigoRecuperacionRepository extends JpaRepository<CodigoRecuperacion, Long> {
}
