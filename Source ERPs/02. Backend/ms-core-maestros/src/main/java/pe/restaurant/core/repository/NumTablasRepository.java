package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.NumTablas;

public interface NumTablasRepository extends JpaRepository<NumTablas, NumTablas.NumTablasId> {
}
