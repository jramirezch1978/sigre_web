package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.ServiciosCxC;

@Repository
public interface ServiciosCxCRepository extends JpaRepository<ServiciosCxC, Long> {

    boolean existsByCodServicioAndFlagEstado(String codServicio, String flagEstado);

    boolean existsByCodServicioAndFlagEstadoAndIdNot(String codServicio, String flagEstado, Long id);

    // Búsqueda con filtros según contrato: codServicio, descServicio, codMoneda, flagEstado
    @Query("SELECT s FROM ServiciosCxC s " +
           "WHERE (:codServicio IS NULL OR :codServicio = '' OR LOWER(s.codServicio) LIKE LOWER(CONCAT('%', :codServicio, '%'))) " +
           "AND (:descServicio IS NULL OR :descServicio = '' OR LOWER(s.descServicio) LIKE LOWER(CONCAT('%', :descServicio, '%'))) " +
           "AND (:codMoneda IS NULL OR s.codMoneda = :codMoneda) " +
           "AND (:flagEstado IS NULL OR s.flagEstado = :flagEstado)")
    Page<ServiciosCxC> findAllWithFilters(@Param("codServicio") String codServicio,
                                          @Param("descServicio") String descServicio,
                                          @Param("codMoneda") String codMoneda,
                                          @Param("flagEstado") String flagEstado,
                                          Pageable pageable);
}
