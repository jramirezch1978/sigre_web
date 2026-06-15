package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.produccion.entity.RecetaLaborConsumible;

import java.util.List;

public interface RecetaLaborConsumibleRepository extends JpaRepository<RecetaLaborConsumible, Long> {

    List<RecetaLaborConsumible> findByRecetaPadreIdOrderByIdAsc(Long recetaPadreId);

    void deleteByRecetaPadreId(Long recetaPadreId);
}
