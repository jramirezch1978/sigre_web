package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.ConciliacionBancaria;

import java.util.Optional;

@Repository
public interface ConciliacionBancariaRepository extends JpaRepository<ConciliacionBancaria, Long>, JpaSpecificationExecutor<ConciliacionBancaria> {

    @Query("SELECT c FROM ConciliacionBancaria c LEFT JOIN FETCH c.detalles WHERE c.id = :id")
    Optional<ConciliacionBancaria> findByIdWithDetalles(@Param("id") Long id);

    boolean existsByBancoCntaIdAndPeriodoAnioAndPeriodoMesAndFlagEstado(
            Long bancoCntaId, Integer periodoAnio, Integer periodoMes, String flagEstado);
}
