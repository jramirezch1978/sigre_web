package pe.restaurant.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.CntblPreasientoDet;

@Repository
public interface CntblPreasientoDetRepository extends JpaRepository<CntblPreasientoDet, Long> {
}
