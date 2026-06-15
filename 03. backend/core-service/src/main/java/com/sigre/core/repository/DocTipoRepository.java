package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.DocTipo;

import java.util.Optional;

public interface DocTipoRepository extends JpaRepository<DocTipo, Long> {

    Optional<DocTipo> findByCodigo(String codigo);
}
