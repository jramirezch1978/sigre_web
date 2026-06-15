package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ArticuloAlmacenRef;

import java.util.Optional;

public interface ArticuloAlmacenRefRepository extends JpaRepository<ArticuloAlmacenRef, Long> {
    Optional<ArticuloAlmacenRef> findByArticuloIdAndAlmacenId(Long articuloId, Long almacenId);
}
