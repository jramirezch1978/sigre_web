package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.OrdenTrasladoDet;

import java.util.List;

public interface OrdenTrasladoDetRepository extends JpaRepository<OrdenTrasladoDet, Long> {
    List<OrdenTrasladoDet> findByOrdenTrasladoIdOrderById(Long ordenTrasladoId);
    void deleteByOrdenTrasladoId(Long ordenTrasladoId);
}
