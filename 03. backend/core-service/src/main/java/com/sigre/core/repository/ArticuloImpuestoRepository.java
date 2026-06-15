package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloImpuesto;

import java.util.List;
import java.util.Optional;

public interface ArticuloImpuestoRepository extends JpaRepository<ArticuloImpuesto, Long> {

    List<ArticuloImpuesto> findByArticuloIdOrderByOrdenAsc(Long articuloId);

    Optional<ArticuloImpuesto> findByArticuloIdAndTiposImpuestoId(Long articuloId, Long tiposImpuestoId);
}
