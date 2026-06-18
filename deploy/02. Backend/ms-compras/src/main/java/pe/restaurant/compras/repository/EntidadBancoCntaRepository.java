package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.EntidadBancoCnta;

import java.util.Optional;

public interface EntidadBancoCntaRepository extends JpaRepository<EntidadBancoCnta, Long> {

    Optional<EntidadBancoCnta> findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(
            Long entidadContribuyenteId, Long monedaId, String flagEstado);
}
