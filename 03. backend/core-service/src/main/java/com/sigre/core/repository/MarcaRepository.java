package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.Marca;

public interface MarcaRepository extends JpaRepository<Marca, Long> {
    boolean existsByCodigoIgnoreCase(String codigo);
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
