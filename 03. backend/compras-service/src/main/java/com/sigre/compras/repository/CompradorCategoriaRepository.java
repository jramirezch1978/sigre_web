package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.CompradorCategoria;

import java.util.List;

public interface CompradorCategoriaRepository extends JpaRepository<CompradorCategoria, Long> {
    List<CompradorCategoria> findByCompradorId(Long compradorId);
    boolean existsByCompradorIdAndArticuloCategId(Long compradorId, Long articuloCategId);
}
