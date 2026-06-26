package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Notificacion;

public interface NotificacionRepository extends JpaRepository<Notificacion, Long> {
}
