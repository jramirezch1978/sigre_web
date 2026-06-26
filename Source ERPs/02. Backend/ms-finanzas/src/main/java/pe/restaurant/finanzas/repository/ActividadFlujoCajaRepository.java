package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.ActividadFlujoCaja;

import java.util.List;

@Repository
public interface ActividadFlujoCajaRepository extends JpaRepository<ActividadFlujoCaja, Long>, JpaSpecificationExecutor<ActividadFlujoCaja> {

    boolean existsByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);

    List<ActividadFlujoCaja> findAllByOrderByOrdenAsc();
}
