package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.Color;

public interface ColorRepository extends JpaRepository<Color, Long> {
    boolean existsByCodigoIgnoreCase(String codigo);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
