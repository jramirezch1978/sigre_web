package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.ArticuloProveedor;

import java.util.List;
import java.util.Optional;

public interface ArticuloProveedorRepository extends JpaRepository<ArticuloProveedor, Long> {
    List<ArticuloProveedor> findByArticuloIdAndFlagEstado(Long articuloId, String flagEstado);
    List<ArticuloProveedor> findByProveedorIdAndFlagEstado(Long proveedorId, String flagEstado);
    Optional<ArticuloProveedor> findByArticuloIdAndProveedorId(Long articuloId, Long proveedorId);
}
