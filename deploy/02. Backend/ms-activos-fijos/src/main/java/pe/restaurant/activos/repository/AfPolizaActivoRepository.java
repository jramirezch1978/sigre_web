package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfPolizaActivo;

import java.util.List;

public interface AfPolizaActivoRepository extends JpaRepository<AfPolizaActivo, Long> {

    Page<AfPolizaActivo> findByAfPolizaSeguroId(Long afPolizaSeguroId, Pageable pageable);

    List<AfPolizaActivo> findByAfPolizaSeguroId(Long afPolizaSeguroId);

    Page<AfPolizaActivo> findByAfMaestroId(Long afMaestroId, Pageable pageable);

    List<AfPolizaActivo> findByAfMaestroId(Long afMaestroId);

    boolean existsByAfPolizaSeguroIdAndAfMaestroId(Long afPolizaSeguroId, Long afMaestroId);

    @Query("SELECT pa FROM AfPolizaActivo pa WHERE pa.afPolizaSeguroId = :polizaId AND pa.afMaestroId = :activoId")
    AfPolizaActivo findByPolizaAndActivo(@Param("polizaId") Long polizaId, @Param("activoId") Long activoId);
}
