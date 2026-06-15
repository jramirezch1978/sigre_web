package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.ArticuloBonificacion;

public interface ArticuloBonificacionRepository extends JpaRepository<ArticuloBonificacion, Long> {

    Page<ArticuloBonificacion> findByArticuloId(Long articuloId, Pageable pageable);

    Page<ArticuloBonificacion> findByArticuloIdAndFlagEstado(Long articuloId, String flagEstado, Pageable pageable);

    boolean existsByArticuloIdAndCantidadMinimaAndIdNot(Long articuloId, java.math.BigDecimal cantidadMinima, Long id);

    boolean existsByArticuloIdAndCantidadMinima(Long articuloId, java.math.BigDecimal cantidadMinima);
}
