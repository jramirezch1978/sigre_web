package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloClase;

public interface ArticuloClaseRepository extends JpaRepository<ArticuloClase, Long> {
    boolean existsByCodClaseIgnoreCase(String codClase);
    boolean existsByCodClaseIgnoreCaseAndIdNot(String codClase, Long id);
}
