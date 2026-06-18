package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Contacto;

import java.util.List;

public interface ContactoRepository extends JpaRepository<Contacto, Long> {
    List<Contacto> findByRelacionComercialIdAndFlagEstado(Long relacionComercialId, String flagEstado);

    boolean existsByRelacionComercialIdAndNombreIgnoreCaseAndFlagEstado(
            Long relacionComercialId, String nombre, String flagEstado);
}
