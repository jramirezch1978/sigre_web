package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.rrhh.entity.PermisoLicenciaDet;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface PermisoLicenciaDetRepository extends JpaRepository<PermisoLicenciaDet, Long> {

    List<PermisoLicenciaDet> findByPermisoLicenciaIdOrderByItemAsc(Long permisoLicenciaId);

    Optional<PermisoLicenciaDet> findFirstByPermisoLicenciaIdOrderByItemAsc(Long permisoLicenciaId);

    Optional<PermisoLicenciaDet> findByPermisoLicenciaIdAndItem(Long permisoLicenciaId, Integer item);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END "
            + "FROM rrhh.permiso_licencia_det d "
            + "JOIN rrhh.permiso_licencia p ON p.id = d.permiso_licencia_id "
            + "WHERE p.trabajador_id = :trabajadorId AND p.flag_estado NOT IN ('0','4') "
            + "AND :fechaInicio <= COALESCE(d.fecha_fin, :fechaInicio) "
            + "AND :fechaFin >= d.fecha_inicio "
            + "AND (:excluirPermisoId IS NULL OR p.id != :excluirPermisoId)", nativeQuery = true)
    boolean existsSolapamiento(@Param("trabajadorId") Long trabajadorId,
                               @Param("fechaInicio") LocalDate fechaInicio,
                               @Param("fechaFin") LocalDate fechaFin,
                               @Param("excluirPermisoId") Long excluirPermisoId);
}
