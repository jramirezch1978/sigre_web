package pe.restaurant.contabilidad.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.MatrizContable;

import java.util.List;
import java.util.Optional;

@Repository
public interface MatrizContableRepository extends JpaRepository<MatrizContable, Long>, JpaSpecificationExecutor<MatrizContable> {

    /**
     * Resumen [id, codigo, descripcion] de matrices activas, opcionalmente
     * filtradas por código o descripción. Para selectores/autocompletes.
     */
    @Query("SELECT m.id, m.codigo, m.descripcion FROM MatrizContable m WHERE m.flagEstado = '1' "
            + "AND (:q IS NULL OR :q = '' "
            + "OR LOWER(m.codigo) LIKE LOWER(CONCAT('%', :q, '%')) "
            + "OR LOWER(m.descripcion) LIKE LOWER(CONCAT('%', :q, '%'))) "
            + "ORDER BY m.codigo")
    List<Object[]> buscarResumen(@Param("q") String q, Pageable pageable);

    @Query("SELECT m FROM MatrizContable m LEFT JOIN FETCH m.detalles d " +
           "WHERE m.codigo = :codigo AND m.flagEstado = '1' " +
           "ORDER BY d.secuencia")
    Optional<MatrizContable> findByCodigo(@Param("codigo") String codigo);

    @Query("SELECT m FROM MatrizContable m LEFT JOIN FETCH m.detalles d " +
           "WHERE m.id = :id AND m.flagEstado = '1' " +
           "ORDER BY d.secuencia")
    Optional<MatrizContable> findByIdWithDetalles(@Param("id") Long id);

    @Query("SELECT DISTINCT m FROM MatrizContable m LEFT JOIN FETCH m.detalles d " +
           "WHERE m.id = :id ORDER BY d.secuencia")
    Optional<MatrizContable> findByIdWithDetallesAll(@Param("id") Long id);

    boolean existsByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);
}
