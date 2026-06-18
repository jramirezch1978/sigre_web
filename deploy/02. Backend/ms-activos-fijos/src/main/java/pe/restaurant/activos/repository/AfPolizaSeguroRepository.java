package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfPolizaSeguro;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AfPolizaSeguroRepository extends JpaRepository<AfPolizaSeguro, Long> {

    Optional<AfPolizaSeguro> findByNumeroPolizaIgnoreCase(String numeroPoliza);

    boolean existsByNumeroPolizaIgnoreCase(String numeroPoliza);

    boolean existsByNumeroPolizaIgnoreCaseAndIdNot(String numeroPoliza, Long id);

    Page<AfPolizaSeguro> findByAfAseguradoraId(Long afAseguradoraId, Pageable pageable);

    @Query("SELECT p FROM AfPolizaSeguro p WHERE p.flagEstado = '1' " +
           "AND (p.fechaFin IS NULL OR p.fechaFin >= CURRENT_DATE)")
    Page<AfPolizaSeguro> findPolizasVigentes(Pageable pageable);

    @Query("SELECT p FROM AfPolizaSeguro p WHERE p.fechaFin IS NOT NULL " +
           "AND p.fechaFin BETWEEN :fechaActual AND :fechaLimite ORDER BY p.fechaFin ASC")
    List<AfPolizaSeguro> findPolizasPorVencer(
            @Param("fechaActual") LocalDate fechaActual,
            @Param("fechaLimite") LocalDate fechaLimite);
}
