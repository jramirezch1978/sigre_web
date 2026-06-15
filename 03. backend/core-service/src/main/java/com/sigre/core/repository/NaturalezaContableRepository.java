package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.NaturalezaContable;

import java.util.Optional;

public interface NaturalezaContableRepository extends JpaRepository<NaturalezaContable, Long> {
    Optional<NaturalezaContable> findByCodigo(String codigo);
}
