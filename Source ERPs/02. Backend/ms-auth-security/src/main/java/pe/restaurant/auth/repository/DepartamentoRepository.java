package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Departamento;

public interface DepartamentoRepository extends JpaRepository<Departamento, Long> {
}
