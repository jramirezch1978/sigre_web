package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.TipoNovedadRrhh;

import java.util.Optional;

@Repository
public interface TipoNovedadRrhhRepository extends JpaRepository<TipoNovedadRrhh, Long>,
                                                   JpaSpecificationExecutor<TipoNovedadRrhh> {

    boolean existsByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);

    Optional<TipoNovedadRrhh> findByCodigo(String codigo);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END " +
           "FROM rrhh.novedad_rrhh WHERE tipo_novedad_rrhh_id = :id AND flag_estado = '1'", nativeQuery = true)
    boolean existsNovedadesActivasByTipoNovedadId(@Param("id") Long id);
}
