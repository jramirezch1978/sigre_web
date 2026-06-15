package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.produccion.entity.ParteProduccionInsumo;

import java.util.List;

public interface ParteProduccionInsumoRepository extends JpaRepository<ParteProduccionInsumo, Long> {

    List<ParteProduccionInsumo> findByParteProduccionIdOrderByIdAsc(Long parteProduccionId);

    void deleteByParteProduccionId(Long parteProduccionId);
}
