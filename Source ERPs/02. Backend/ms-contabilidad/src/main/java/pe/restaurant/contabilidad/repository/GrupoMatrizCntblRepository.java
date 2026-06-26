package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.GrupoMatrizCntbl;

@Repository
public interface GrupoMatrizCntblRepository extends JpaRepository<GrupoMatrizCntbl, Long> {
}
