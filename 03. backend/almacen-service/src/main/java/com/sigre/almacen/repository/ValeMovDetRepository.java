package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.ValeMovDet;

import java.time.LocalDate;
import java.util.List;

public interface ValeMovDetRepository extends JpaRepository<ValeMovDet, Long> {

    /**
     * Líneas de movimiento cuyo tipo (cabecera) está en {@code tipoIds}
     * (tipos de merma/pérdida), filtrables por almacén, artículo y fechas.
     */
    @Query("""
            SELECT d FROM ValeMovDet d
            JOIN d.valeMov v
            WHERE v.articuloMovTipoId IN :tipoIds
              AND (:almacenId IS NULL OR v.almacenId = :almacenId)
              AND (:articuloId IS NULL OR d.articuloId = :articuloId)
              AND (:fechaDesde IS NULL OR v.fechaMov >= :fechaDesde)
              AND (:fechaHasta IS NULL OR v.fechaMov <= :fechaHasta)
            """)
    Page<ValeMovDet> buscarPerdidas(@Param("tipoIds") List<Long> tipoIds,
                                    @Param("almacenId") Long almacenId,
                                    @Param("articuloId") Long articuloId,
                                    @Param("fechaDesde") LocalDate fechaDesde,
                                    @Param("fechaHasta") LocalDate fechaHasta,
                                    Pageable pageable);
}
