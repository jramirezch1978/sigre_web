package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.SolSalidaDet;

import java.util.List;

public interface SolSalidaDetRepository extends JpaRepository<SolSalidaDet, Long> {
    List<SolSalidaDet> findBySolSalidaIdOrderById(Long solSalidaId);
    void deleteBySolSalidaId(Long solSalidaId);
}
