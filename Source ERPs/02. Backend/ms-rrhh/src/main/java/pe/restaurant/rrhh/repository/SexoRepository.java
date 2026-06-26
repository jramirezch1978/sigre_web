package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Sexo;

@Repository
public interface SexoRepository extends JpaRepository<Sexo, Long>, JpaSpecificationExecutor<Sexo> {
    boolean existsByCodigo(String codigo);
    java.util.List<Sexo> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
