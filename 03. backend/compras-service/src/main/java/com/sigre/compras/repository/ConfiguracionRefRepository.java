package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.ConfiguracionRef;

import java.util.Optional;

public interface ConfiguracionRefRepository extends JpaRepository<ConfiguracionRef, Long> {
    Optional<ConfiguracionRef> findFirstByParametro(String parametro);
}
