package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.ArticuloDocTecnicaCaractDet;

import java.util.List;

public interface CaractDetRepository extends JpaRepository<ArticuloDocTecnicaCaractDet, Long> {

    List<ArticuloDocTecnicaCaractDet> findByArticuloDocTecnicaIdOrderByIdAsc(Long articuloDocTecnicaId);

    void deleteByArticuloDocTecnicaId(Long articuloDocTecnicaId);
}
