package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ArticuloRef;

public interface ArticuloRefRepository extends JpaRepository<ArticuloRef, Long> {
}
