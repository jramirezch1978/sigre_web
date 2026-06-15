package com.sigre.compras.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ArticuloEstructura;
import com.sigre.compras.entity.ArticuloEstructuraId;

public interface ArticuloEstructuraRepository extends JpaRepository<ArticuloEstructura, ArticuloEstructuraId> {

    Page<ArticuloEstructura> findByArticuloPadreId(Long articuloPadreId, Pageable pageable);
}
