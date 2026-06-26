package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.MotivoNota;

import java.util.List;
import java.util.Optional;

public interface MotivoNotaRepository extends JpaRepository<MotivoNota, Long> {

    Optional<MotivoNota> findByCodigo(String codigo);

    List<MotivoNota> findByTipoAndFlagEstado(String tipo, String flagEstado);
}
