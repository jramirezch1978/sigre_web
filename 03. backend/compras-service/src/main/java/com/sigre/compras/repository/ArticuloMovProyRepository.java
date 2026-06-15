package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ArticuloMovProy;

import java.util.List;
import java.util.Optional;

public interface ArticuloMovProyRepository extends JpaRepository<ArticuloMovProy, Long> {

    Optional<ArticuloMovProy> findByOrdenCompraDetId(Long ordenCompraDetId);

    List<ArticuloMovProy> findByOrdenCompraDetIdIn(List<Long> detIds);

    void deleteByOrdenCompraDetIdIn(List<Long> detIds);

    void deleteByOrdenCompraDetId(Long detId);
}
