package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.ParteProduccionProducido;

import java.util.List;

public interface ParteProduccionProducidoRepository extends JpaRepository<ParteProduccionProducido, Long> {

    List<ParteProduccionProducido> findByParteProduccionIdOrderByIdAsc(Long parteProduccionId);

    void deleteByParteProduccionId(Long parteProduccionId);
}
