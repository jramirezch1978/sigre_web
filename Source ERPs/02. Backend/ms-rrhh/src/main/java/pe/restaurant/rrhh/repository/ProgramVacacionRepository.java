package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.ProgramVacacion;
import java.util.List;

@Repository
public interface ProgramVacacionRepository extends JpaRepository<ProgramVacacion, Long> {
    List<ProgramVacacion> findByTrabajadorIdAndAnio(Long trabajadorId, Integer anio);
    List<ProgramVacacion> findByAnio(Integer anio);
}
