package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ValeMovRef;

import java.util.List;

public interface ValeMovRefRepository extends JpaRepository<ValeMovRef, Long> {
    List<ValeMovRef> findByOrdenCompraIdOrderByFechaDesc(Long ordenCompraId);
}
