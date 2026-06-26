package pe.restaurant.compras.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.Comprador;

public interface CompradorRepository extends JpaRepository<Comprador, Long> {
    Page<Comprador> findByFlagEstado(String flagEstado, Pageable pageable);

    java.util.Optional<Comprador> findByUsuarioIdAndFlagEstado(Long usuarioId, String flagEstado);

    boolean existsByUsuarioId(Long usuarioId);
}
