package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.ArticuloAlmacenPosicion;

import java.util.Optional;

public interface ArticuloAlmacenPosicionRepository extends JpaRepository<ArticuloAlmacenPosicion, Long> {

    Optional<ArticuloAlmacenPosicion> findByUbicacionAlmacenIdAndArticuloId(Long ubicacionAlmacenId, Long articuloId);
}
