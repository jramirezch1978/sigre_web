package com.sigre.compras.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.Comprador;

public interface CompradorRepository extends JpaRepository<Comprador, Long> {
    Page<Comprador> findByFlagEstado(String flagEstado, Pageable pageable);

    java.util.Optional<Comprador> findByUsuarioIdAndFlagEstado(Long usuarioId, String flagEstado);
}
