package pe.restaurant.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.almacen.entity.GuiaDet;

import java.util.List;

public interface GuiaDetRepository extends JpaRepository<GuiaDet, Long> {
    List<GuiaDet> findByGuiaIdOrderById(Long guiaId);
    void deleteByGuiaId(Long guiaId);
}
