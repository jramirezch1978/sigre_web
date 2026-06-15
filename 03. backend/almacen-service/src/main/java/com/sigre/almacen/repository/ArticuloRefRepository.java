package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.ArticuloRef;

public interface ArticuloRefRepository extends JpaRepository<ArticuloRef, Long> {
}
