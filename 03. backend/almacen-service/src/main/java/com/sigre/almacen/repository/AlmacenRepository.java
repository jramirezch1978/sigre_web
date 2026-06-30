package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.Almacen;

import java.util.List;

public interface AlmacenRepository extends JpaRepository<Almacen, Long> {

    boolean existsBySucursalIdAndCodigoIgnoreCase(Long sucursalId, String codigo);

    boolean existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(Long sucursalId, String codigo, Long id);

    List<Almacen> findByFlagEstadoOrderByCodigoAsc(String flagEstado);

    /** Almacenes activos asignados a un usuario (almacen.almacen_user activo). */
    @Query("""
            SELECT a FROM Almacen a
            WHERE a.flagEstado = '1'
              AND a.id IN (SELECT au.almacenId FROM AlmacenUser au
                           WHERE au.usuarioId = :usuarioId AND au.flagEstado = '1')
            ORDER BY a.codigo ASC
            """)
    List<Almacen> findMisAlmacenes(@Param("usuarioId") Long usuarioId);
}
