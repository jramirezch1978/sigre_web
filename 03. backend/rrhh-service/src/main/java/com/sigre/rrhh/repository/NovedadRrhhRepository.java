package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import com.sigre.rrhh.entity.NovedadRrhh;

public interface NovedadRrhhRepository extends JpaRepository<NovedadRrhh, Long>,
        JpaSpecificationExecutor<NovedadRrhh> {

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.novedad_rrhh " +
           "WHERE trabajador_id = :trabajadorId AND tipo_novedad_rrhh_id = :tipoNovedadId " +
           "AND flag_estado = '1' " +
           "AND fecha_ini <= :fechaFin AND fecha_fin >= :fechaIni " +
           "AND (:excluirId IS NULL OR id != :excluirId)", nativeQuery = true)
    boolean existsDuplicadoPeriodo(Long trabajadorId, Long tipoNovedadId,
                                   java.time.LocalDate fechaIni, java.time.LocalDate fechaFin,
                                   Long excluirId);
}
