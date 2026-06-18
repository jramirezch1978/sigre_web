package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.produccion.entity.OtAdminUder;

import java.util.List;
import java.util.Optional;

public interface OtAdminUderRepository extends JpaRepository<OtAdminUder, Long> {

    List<OtAdminUder> findByOtAdministracionIdOrderByIdAsc(Long otAdministracionId);

    boolean existsByOtAdministracionIdAndUsuarioId(Long otAdministracionId, Long usuarioId);

    Optional<OtAdminUder> findByOtAdministracionIdAndUsuarioId(Long otAdministracionId, Long usuarioId);
}
