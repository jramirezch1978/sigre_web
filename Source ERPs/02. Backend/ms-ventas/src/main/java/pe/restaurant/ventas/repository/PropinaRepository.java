package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.Propina;

import java.util.List;

@Repository
public interface PropinaRepository extends JpaRepository<Propina, Long>, JpaSpecificationExecutor<Propina> {

    List<Propina> findByFsFacturaSimplIdAndFlagEstado(Long fsFacturaSimplId, String flagEstado);
}
