package pe.restaurant.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Calculo;

import java.util.Optional;

/**
 * Repositorio JPA para la entidad {@link Calculo}.
 * Gestiona las cabeceras de cálculo de planilla.
 */
@Repository
public interface CalculoRepository extends JpaRepository<Calculo, Long> {

    /** Busca un cálculo existente para el mismo período y tipo de planilla. */
    Optional<Calculo> findByAnioAndMesAndTipoPlanillaId(Integer anio, Integer mes, Long tipoPlanillaId);

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     */
    @Query("SELECT c FROM Calculo c WHERE "
            + "(:anio IS NULL OR c.anio = :anio) "
            + "AND (:mes IS NULL OR c.mes = :mes) "
            + "AND (:tipoPlanillaId IS NULL OR c.tipoPlanillaId = :tipoPlanillaId)")
    Page<Calculo> findWithFilters(
            @Param("anio") Integer anio,
            @Param("mes") Integer mes,
            @Param("tipoPlanillaId") Long tipoPlanillaId,
            Pageable pageable);

    /** Valida existencia de tipo de planilla. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.tipo_planilla WHERE id = :id", nativeQuery = true)
    boolean existsTipoPlanillaById(@Param("id") Long id);

    /** Obtiene el nombre del tipo de planilla por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.tipo_planilla WHERE id = :id", nativeQuery = true)
    String findTipoPlanillaNombreById(@Param("id") Long id);

    /** Obtiene el ID del tipo de concepto de cálculo por su código (INGRESO/DESCUENTO). */
    @Query(value = "SELECT id FROM rrhh.tipo_concepto_calculo WHERE codigo = :codigo", nativeQuery = true)
    Long findTipoConceptoCalculoIdByCodigo(@Param("codigo") String codigo);

    /** Obtiene el nombre del tipo de concepto de cálculo por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.tipo_concepto_calculo WHERE id = :id", nativeQuery = true)
    String findTipoConceptoCalculoNombreById(@Param("id") Long id);
}
