package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfHistorial;

import java.time.LocalDateTime;
import java.util.List;

public interface AfHistorialRepository extends JpaRepository<AfHistorial, Long> {

    List<AfHistorial> findByAfMaestroIdOrderByFechaEventoDesc(Long afMaestroId);

    Page<AfHistorial> findByTipoEvento(String tipoEvento, Pageable pageable);

    List<AfHistorial> findByUsuarioId(Long usuarioId);

    @Query("SELECT h FROM AfHistorial h WHERE h.fechaEvento BETWEEN :fechaInicio AND :fechaFin ORDER BY h.fechaEvento DESC")
    List<AfHistorial> findByFechaRange(@Param("fechaInicio") LocalDateTime fechaInicio, @Param("fechaFin") LocalDateTime fechaFin);

    @Query("SELECT h FROM AfHistorial h WHERE h.modulo = :modulo ORDER BY h.fechaEvento DESC")
    List<AfHistorial> findByModulo(@Param("modulo") String modulo);

    @Query("SELECT h FROM AfHistorial h WHERE h.afMaestroId = :afMaestroId AND h.tipoEvento = :tipoEvento ORDER BY h.fechaEvento DESC")
    List<AfHistorial> findByActivoAndTipo(@Param("afMaestroId") Long afMaestroId, @Param("tipoEvento") String tipoEvento);
}
