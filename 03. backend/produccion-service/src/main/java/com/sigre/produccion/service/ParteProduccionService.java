package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.entity.ParteProduccion;
import com.sigre.produccion.entity.ParteProduccionInsumo;
import com.sigre.produccion.entity.ParteProduccionProducido;

import java.time.LocalDate;
import java.util.List;

public interface ParteProduccionService {

    Page<ParteProduccion> findAll(Long ordenTrabajoId, LocalDate fechaDesde, LocalDate fechaHasta,
                                  String flagEstado, Pageable pageable);

    ParteProduccion findById(Long id);

    ParteProduccion create(ParteProduccion entity, List<ParteProduccionInsumo> insumos,
                           List<ParteProduccionProducido> producidos);

    ParteProduccion update(Long id, ParteProduccion entity, List<ParteProduccionInsumo> insumos,
                           List<ParteProduccionProducido> producidos);

    ParteProduccion activate(Long id);

    ParteProduccion deactivate(Long id);

    void delete(Long id);

    // sub-recursos

    List<ParteProduccionInsumo> findInsumos(Long parteProduccionId);

    List<ParteProduccionProducido> findProducidos(Long parteProduccionId);
}
