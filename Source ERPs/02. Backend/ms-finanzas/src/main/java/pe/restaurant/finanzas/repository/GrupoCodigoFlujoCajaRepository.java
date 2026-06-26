package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.GrupoCodigoFlujoCaja;

import java.util.List;
import java.util.Optional;

@Repository
public interface GrupoCodigoFlujoCajaRepository extends JpaRepository<GrupoCodigoFlujoCaja, Long> {

    boolean existsByCodigo(String codigo);
    
    boolean existsByCodigoAndIdNot(String codigo, Long id);
    
    Optional<GrupoCodigoFlujoCaja> findByCodigoAndFlagEstado(String codigo, String flagEstado);

    List<GrupoCodigoFlujoCaja> findByActividadFlujoCajaIdOrderByOrden(Long actividadFlujoCajaId);

    boolean existsByActividadFlujoCajaId(Long actividadFlujoCajaId);
}
